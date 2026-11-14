# frozen_string_literal: true

module Metanorma
  module Taste
    # Generic Metanorma presentation-XML -> DOCX renderer on uniword's
    # Builder API.
    #
    # This is the rendering half of the taste doc-engine wiring
    # ({DocEngine}): it walks the presentation XML that the compile driver
    # hands every Word-format leg and emits paragraphs, lists, tables,
    # figures, and a Word TOC field through `Uniword::Builder`, then writes
    # the OOXML package via `Uniword::DocumentWriter`.
    #
    # Dispatch is element-name keyed: every recognized block element maps to
    # exactly one handler (MECE), unrecognized elements recurse into their
    # children (wrapper elements such as +semx+ pass through), and
    # unrecognized text is kept, so the renderer degrades to plain text
    # rather than dropping content on elements it does not model.
    #
    # Branding is data-driven: the cover renders from the document's bibdata
    # (identifier, title, edition, publisher, dates), so a taste's
    # metadata — not the base flavor's — is what the cover carries.
    #
    # Requires `uniword` (and therefore `moxml`) at use time; only
    # {DocEngine} constructs this class.
    class UniwordDocRender
      # Elements that are sections: a heading followed by blocks.
      SECTION_ELEMENTS = %w[
        clause annex introduction foreword terms definitions abstract
        acknowledgments indexsect colophon bibliography references
      ].freeze

      # Elements read as a section's heading, most specific first: the
      # presentation copies carry the heading depth.
      PRESENTATION_TITLE_ELEMENTS = %w[fmt-title fmt-name].freeze
      SEMANTIC_TITLE_ELEMENTS = %w[title name].freeze

      # nested list containers, table cell elements, figure caption and
      # bibliography reference element names
      LIST_ELEMENTS = %w[ol ul].freeze
      CELL_ELEMENTS = %w[td th].freeze
      CAPTION_ELEMENTS = %w[fmt-name name].freeze
      BIBITEM_REF_ELEMENTS = %w[formattedref biblio-tag].freeze

      # inline elements that map to a fixed run (built by name)
      INLINE_RUN_ELEMENTS = { "br" => :line_break_run,
                              "tab" => :tab_run }.freeze

      # Cover and caption paragraph styles, defined so every style the
      # document references exists in styles.xml.
      COVER_STYLES = {
        cover_large: { size: 14, bold: true },
        cover_meta: { size: 11 },
        cover_title: { size: 18, bold: true },
      }.freeze

      # bibdata roles read for the publisher line on the cover.
      PUBLISHER_ROLES = %w[author publisher].freeze

      # Max image width on a US-letter/A4 body with 1in margins (~6.5M EMU);
      # cap below it so figures never overflow the text column.
      MAX_IMAGE_EMU = 6_000_000
      PX_TO_EMU = 9_525

      def initialize(presentation_xml)
        @xml = Moxml.new.parse(presentation_xml)
        @doc = Uniword::Builder::DocumentBuilder.new
        @tempfiles = []
      end

      # Render and write the DOCX package.
      #
      # @param outname [String] output path
      # @return [void]
      def save(outname)
        render_cover
        render_children(body_elements)
        # format: :docx pins the OOXML package: the engine keeps the flavor's
        # `doc` output symbol, so outname may end .doc while the bytes must
        # be the uniword DOCX package
        Uniword::DocumentWriter.new(@doc.model).save(outname, format: :docx)
      ensure
        @tempfiles.each(&:close)
        @tempfiles.clear
      end

      private

      # The root's element children below +bibdata+ (bibdata is rendered
      # from directly, the remaining top-level children are metadata or
      # sections).
      def body_elements
        @xml.root.children.reject do |n|
          n.name == "bibdata" || !n.element?
        end
      end

      # -- block dispatch --------------------------------------------------

      def render_children(nodes)
        nodes.each { |n| render_node(n) }
      end

      def render_node(node)
        return unless node.element?

        handler = handler_for(node.name)
        if handler
          send(handler, node)
        else
          render_children(node.children)
        end
      end

      def handler_for(name)
        if SECTION_ELEMENTS.include?(name) then :render_section
        else
          BLOCK_HANDLERS[name]
        end
      end

      # Block-element handlers. Adding a new block = one entry here plus the
      # method; the default (recursion) covers wrapper elements. `toc`
      # elements are deliberate non-entries: they are per-format TOC
      # directives from metanorma-extension, not content — the live Word
      # TOC field is emitted by the Contents section handler.
      BLOCK_HANDLERS = {
        "p" => :render_para,
        "dl" => :render_dl,
        "ol" => :render_ol,
        "ul" => :render_ul,
        "table" => :render_table,
        "figure" => :render_figure,
        "quote" => :render_quote,
        "note" => :render_note,
        "example" => :render_example,
        "sourcecode" => :render_sourcecode,
        "bibitem" => :render_bibitem,
      }.freeze
      private_constant :BLOCK_HANDLERS

      # -- sections --------------------------------------------------------

      def render_section(node)
        title = section_title(node)
        text = title && inline_text(title)
        render_heading(title, text) if text
        render_toc_field(node) if text&.casecmp?("Contents")
        render_children(node.children.reject { |n| n.equal?(title) })
      end

      # the presentation title (fmt-title/fmt-name) carries the heading
      # depth; the semantic title is the fallback for sections the pipeline
      # left without a presentation copy
      def section_title(node)
        node.children.find do |n|
          n.element? && PRESENTATION_TITLE_ELEMENTS.include?(n.name)
        end || node.children.find do |n|
          n.element? && SEMANTIC_TITLE_ELEMENTS.include?(n.name)
        end
      end

      def render_heading(title, text)
        level = (title&.attribute("depth")&.value || 1).to_i.clamp(1, 9)
        @doc.heading(text, level: level)
      end

      # The isodoc pipeline builds the Word TOC at render time, so a
      # Contents section arrives empty in the presentation XML; emit a live
      # Word TOC field in its place.
      def render_toc_field(_node)
        Uniword::Builder::TocBuilder.build(title: nil).each do |para|
          @doc << para
        end
      end

      # -- paragraphs and inline content -----------------------------------

      def render_para(node)
        para = Uniword::Builder::ParagraphBuilder.new(
          allocator: @doc.allocator,
        )
        render_inline_into(para, node.children)
        @doc << para
      end

      def render_inline_into(para, nodes, **formatting)
        nodes.each do |n|
          if n.text?
            para << Uniword::Builder.text(n.text, **formatting)
          elsif (run = INLINE_RUN_ELEMENTS[n.name])
            para << send(run)
          elsif n.name == "image"
            append_image_into(para, n)
          else
            render_inline_into(para, n.children, **formatting)
          end
        end
      end

      def line_break_run
        Uniword::Builder.line_break
      end

      def tab_run
        Uniword::Builder.tab
      end

      # -- lists ------------------------------------------------------------

      def render_ul(node) = render_list(node, :bullet_list)
      def render_ol(node) = render_list(node, :numbered_list)

      def render_list(node, method)
        @doc.send(method) do |list|
          node.children.select { |n| n.element? && n.name == "li" }
            .each { |li| render_list_item(list, li) }
        end
      end

      def render_list_item(list, item)
        render_item_text(list, item)
        # nested lists become sibling lists at one indent level
        item.children.select do |n|
          n.element? && LIST_ELEMENTS.include?(n.name)
        end
          .each { |sub| render_list(sub, :bullet_list) }
      end

      def render_item_text(list, item)
        list.item do |para|
          render_inline_into(para, item.children.reject do |n|
            n.element? && LIST_ELEMENTS.include?(n.name)
          end)
        end
      end

      # -- definition lists --------------------------------------------------

      def render_dl(node)
        node.children.select(&:element?)
          .each do |entry|
            case entry.name
            when "dt" then @doc << text_para(entry)
            when "dd" then render_indented_para(entry)
            else render_node(entry)
            end
          end
      end

      def text_para(node)
        para = paragraph
        render_inline_into(para, node.children)
        para
      end

      # -- tables ------------------------------------------------------------

      def render_table(node)
        @doc.table do |table|
          descendants(node, "tr").each { |tr| render_table_row(table, tr) }
        end
      end

      def render_table_row(table, trelem)
        table.row do |row|
          trelem.children.select do |cel|
            cel.element? && CELL_ELEMENTS.include?(cel.name)
          end
            .each do |cell|
              row.cell do |c|
                c << cell_paragraph(cell, header: cell.name == "th")
              end
            end
        end
      end

      def cell_paragraph(cell, header:)
        para = Uniword::Builder::ParagraphBuilder.new(
          allocator: @doc.allocator,
        )
        render_inline_into(para, cell.children, bold: header)
        para
      end

      # -- figures -----------------------------------------------------------

      def render_figure(node)
        image = child(node, "image")
        render_image(image) if image
        render_figure_caption(node)
      end

      def render_image(image)
        para = paragraph
        append_image_into(para, image)
        @doc << para
      end

      def render_figure_caption(node)
        caption = node.children.find do |n|
          n.element? && CAPTION_ELEMENTS.include?(n.name)
        end or return

        @doc << text_para(caption)
      end

      # Embed one image element as an inline drawing run. Prefers the EMF
      # variant the pipeline ships alongside SVG payloads (the Word-native
      # form), then the element's own data URI or file source.
      def append_image_into(para, image)
        path, = image_source(image)
        return para << image_fallback_text(image) unless path

        width, height = image_dimensions(image)
        para << Uniword::Builder::ImageBuilder.create_run(
          @doc, path, width: width, height: height
        )
      end

      def image_fallback_text(image)
        image.attribute("alt")&.value || "[Image]"
      end

      def image_dimensions(image)
        dimensions = %i[width height].map do |dim|
          image.attribute(dim.to_s)&.value.to_i * PX_TO_EMU
        end
        scale_to_page(*dimensions)
      end

      def scale_to_page(width, height)
        return [width, height] unless width.positive? && width > MAX_IMAGE_EMU

        ratio = MAX_IMAGE_EMU.to_f / width
        [MAX_IMAGE_EMU, (height * ratio).to_i]
      end

      # @return [Array(String, String), nil] [file path, mime type]
      def image_source(image)
        data_uri_source(image) || file_source(image)
      end

      # The EMF variant is tried before the element's own payload, so an
      # svg+emf pair resolves to the Word-native form.
      def data_uri_source(image)
        [child(image, "emf"), image].each do |n|
          uri = n&.attribute("src")&.value
          next unless uri&.start_with?("data:")

          return data_uri_file(uri)
        end
        nil
      end

      def file_source(image)
        src = image.attribute("src")&.value
        src && File.exist?(src) ? [src, nil] : nil
      end

      # Decode a data URI into a temp file for uniword to embed.
      def data_uri_file(uri)
        mime, payload = uri.match(%r{data:([^;,]+)(?:;base64)?,(.*)}).captures
        ext = mime.split("/").last.sub("jpeg", "jpg")
        file = Tempfile.new(["mn-image", ".#{ext}"])
        file.binmode
        file.write(Base64.decode64(payload))
        file.close
        @tempfiles << file
        [file.path, mime]
      end

      # -- misc blocks -------------------------------------------------------

      def render_quote(node)
        node.children.select { |n| n.element? && n.name == "p" }
          .each { |p| render_indented_para(p) }
        render_quote_attribution(node)
      end

      def render_indented_para(node)
        para = paragraph
        para.indent(left: 720)
        render_inline_into(para, node.children)
        @doc << para
      end

      def render_quote_attribution(node)
        attribution = child(node, "source") or return

        para = paragraph
        para.indent(left: 720)
        para << Uniword::Builder.text(inline_text(attribution), italic: true)
        @doc << para
      end

      def render_note(node) = render_labelled(node, "NOTE")
      def render_example(node) = render_labelled(node, "EXAMPLE")

      def render_labelled(node, label)
        para = paragraph
        para << Uniword::Builder.text(label, bold: true)
        para << "  "
        render_inline_into(para, node.children.reject do |n|
          n.element? && CAPTION_ELEMENTS.include?(n.name)
        end)
        @doc << para
      end

      def render_sourcecode(node)
        inline_text(node).each_line do |line|
          para = paragraph
          para << Uniword::Builder.text(line.chomp, font: "Courier New")
          @doc << para
        end
      end

      def render_bibitem(node)
        ref = node.children.find do |n|
          n.element? && BIBITEM_REF_ELEMENTS.include?(n.name)
        end
        para = paragraph
        if ref
          render_inline_into(para, ref.children)
        else
          para << inline_text(node)
        end
        @doc << para
      end

      # -- cover -------------------------------------------------------------

      def render_cover
        bibdata = child(@xml.root, "bibdata") or return

        org = publisher_org(bibdata)
        @doc.author(org_name(org))
        @doc.title(doc_title(bibdata))
        cover_lines(bibdata, org).each do |(text, kwargs)|
          cover_line(text, **kwargs)
        end
        @doc.page_break
      end

      # Cover block, top to bottom: identifier, publisher, edition, date,
      # title (+ subtitle). Nil entries are spacers.
      def cover_lines(bibdata, org)
        [
          [docidentifier(bibdata), { style: :cover_meta, large: true }],
          nil,
          [org_name(org), {}],
          [edition_text(bibdata), {}],
          [date_text(bibdata), {}],
          nil,
          [doc_title(bibdata), { style: :cover_title }],
          [title_of(bibdata, "subtitle"), { style: :cover_title }],
        ].map { |l| l || [nil, {}] }
      end

      def cover_line(text, style: :cover_meta, large: false)
        return if text.nil? || text.to_s.empty?

        para = paragraph
        para.style = style_name(large ? :cover_large : style)
        para << text.to_s
        @doc << para
      end

      def docidentifier(bibdata)
        primary_identifier(bibdata) ||
          descendants(bibdata, "docidentifier").first&.text ||
          descendants(bibdata, "docnumber").first&.text
      end

      def primary_identifier(bibdata)
        descendants(bibdata, "docidentifier")
          .find { |d| d.attribute("primary")&.value == "true" }&.text
      end

      def doc_title(bibdata)
        title_of(bibdata, "main") ||
          title_of(bibdata, nil)
      end

      def title_of(bibdata, type)
        descendants(bibdata, "title").find do |t|
          type.nil? || t.attribute("type")&.value == type
        end&.text&.strip
      end

      def publisher_org(bibdata)
        contributor = bibdata.children.find do |c|
          c.element? && c.name == "contributor" &&
            publisher_contributor?(c)
        end
        contributor && child(contributor, "organization")
      end

      def publisher_contributor?(contributor)
        contributor.children.any? do |n|
          n.element? && n.name == "role" &&
            PUBLISHER_ROLES.include?(n.attribute("type")&.value)
        end
      end

      def org_name(org)
        return nil unless org.is_a?(Moxml::Element)

        child(org, "name")&.text || child(org, "abbreviation")&.text
      end

      def edition_text(bibdata)
        ed = descendants(bibdata, "edition").first&.text
        "Edition #{ed}" if ed
      end

      def date_text(bibdata)
        date = child_with_type(bibdata, "date", "published") ||
          descendants(bibdata, "date").first
        date && child(date, "on")&.text
      end

      def child_with_type(node, name, type)
        node.children.find do |c|
          c.element? && c.name == name &&
            c.attribute("type")&.value == type
        end
      end

      # All descendant elements with the given local name, document order.
      # (Moxml xpath cannot address the document's default namespace, so
      # element access walks children by local name throughout.)
      def descendants(node, name, acc = [])
        node.children.each do |c|
          next unless c.element?

          acc << c if c.name == name
          descendants(c, name, acc)
        end
        acc
      end

      def child(node, name)
        node.children.find { |c| c.element? && c.name == name }
      end

      # -- styles ------------------------------------------------------------

      def style_name(key)
        spec = COVER_STYLES[key] or return "Normal"
        @defined_styles ||= {}
        @defined_styles[key] ||= define_cover_style(key, spec)
      end

      def define_cover_style(key, spec)
        name = cover_style_name(key)
        @doc.define_style(name) do |styling|
          styling.font_size(spec[:size])
          styling.bold(true) if spec[:bold]
        end
        # the paragraph reference is the styleId, which uniword derives
        # from the style name with spaces stripped
        name.tr(" ", "")
      end

      def cover_style_name(key)
        "MT #{key.to_s.tr('_ ', ' ').split.map(&:capitalize).join(' ')}"
      end

      def paragraph
        Uniword::Builder::ParagraphBuilder.new(allocator: @doc.allocator)
      end

      # Concatenated text of an element's inline content.
      def inline_text(node)
        node.text.strip
      end
    end
  end
end
