<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<xsl:variable name="pageWidth">210</xsl:variable><!-- no units! in mm -->
	<xsl:variable name="pageHeight">297</xsl:variable><!-- no units! in mm -->
	<xsl:variable name="marginTop">24</xsl:variable><!-- no units! in mm. Allows for page header -->
	<xsl:variable name="marginLeftRight1">15</xsl:variable><!-- margin-left below, no units, in mm -->
	<xsl:variable name="marginLeftRight2">15</xsl:variable><!-- margin-right below, no units, in mm -->

	<xsl:variable name="toc_item_indent">4</xsl:variable><!-- ToC indentation level for each level. No units. In mm -->

	<!-- PDF Association logo colors -->
	<xsl:variable name="logo_yellow">rgb(202,152,49)</xsl:variable>
	<xsl:variable name="logo_green">rgb(139,152,91)</xsl:variable>
	<xsl:variable name="logo_red">rgb(208,63,78)</xsl:variable><!-- only logo color with sufficient contrast for WCAG Level AA -->
	<xsl:variable name="logo_blue">rgb(72,145,175)</xsl:variable>

	<!-- PDF Association preferred typefaces -->
	<xsl:variable name="proportional_font">Source Sans 3, STIX Two Math, <xsl:value-of select="$font_noto_sans"/>, sans-serif</xsl:variable>
	<xsl:variable name="small-text-reduction">85%</xsl:variable><!-- percentage of default typeface for small text such as notes -->
	<xsl:variable name="monospaced_font"><xsl:value-of select="$font_noto_sans_mono"/>, monospace</xsl:variable>
	<xsl:variable name="mono_font-reduction">85%</xsl:variable><!-- percentage of default typeface for monospaced text to reduce visual size -->

	<xsl:attribute-set name="root-style"><?extend?>
		<xsl:attribute name="font-family"><xsl:value-of select="$proportional_font"/></xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="line-height">1.5</xsl:attribute><!-- WCAG Level AA recommends 1.5 line height as a minimum -->
	</xsl:attribute-set>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="17.5mm" margin-bottom="17.5mm" margin-left="17.5mm" margin-right="17.5mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="copyright-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="20mm" margin-bottom="35mm" margin-left="18mm" margin-right="18mm"/>
			</fo:simple-page-master>

			<!-- ToC -->
			<fo:simple-page-master master-name="toc-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-toc-odd" extent="{$extent_header}"/>
				<fo:region-after region-name="footer-odd" extent="{$extent_footer}"/>
				<fo:region-start region-name="left-region" extent="{$extent_left}"/>
				<fo:region-end region-name="right-region" extent="{$extent_right}"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="toc-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-toc-even" extent="{$extent_header}"/>
				<fo:region-after region-name="footer-even" extent="{$extent_footer}"/>
				<fo:region-start region-name="left-region" extent="{$extent_left}"/>
				<fo:region-end region-name="right-region" extent="{$extent_right}"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="toc">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="odd"  master-reference="toc-odd"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="toc-even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>

			<fo:simple-page-master master-name="first" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer-even" extent="12.5mm"/>
				<fo:region-start region-name="left-region" extent="13mm"/>
				<fo:region-end region-name="right-region" extent="12mm"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="page-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer-odd" extent="{$extent_footer}"/>
				<fo:region-start region-name="left-region" extent="{$extent_left}"/>
				<fo:region-end region-name="right-region" extent="{$extent_right}"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="page-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer-even" extent="{$extent_footer}"/>
				<fo:region-start region-name="left-region" extent="{$extent_left}"/>
				<fo:region-end region-name="right-region" extent="{$extent_right}"/>
			</fo:simple-page-master>

			<fo:page-sequence-master master-name="document">
				<fo:single-page-master-reference master-reference="first"/>
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="page-odd" odd-or-even="odd"/>
					<fo:conditional-page-master-reference master-reference="page-even" odd-or-even="even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>

			<fo:simple-page-master master-name="page-odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer-odd" extent="{$extent_footer}"/>
				<fo:region-start region-name="left-region" extent="{$extent_left}"/>
				<fo:region-end region-name="right-region" extent="{$extent_right}"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="page-even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer-even" extent="{$extent_footer}"/>
				<fo:region-start region-name="left-region" extent="{$extent_left}"/>
				<fo:region-end region-name="right-region" extent="{$extent_right}"/>
			</fo:simple-page-master>

			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="page-odd-landscape" odd-or-even="odd"/>
					<fo:conditional-page-master-reference master-reference="page-even-landscape" odd-or-even="even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template>

	<xsl:variable name="cover_page_color_box_border_width">2.5pt</xsl:variable>
	<xsl:variable name="cover_page_color_box_height">57mm</xsl:variable>

	<xsl:attribute-set name="cover_page_box">
		<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
		<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		<xsl:attribute name="padding-top">-0.5mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">-0.5mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="cover-page">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" initial-page-number="1">
			<fo:flow flow-name="xsl-region-body" font-family="Source Sans 3">
				<xsl:call-template name="insert_firstpage_id"><xsl:with-param name="num" select="$num"/></xsl:call-template>
				
				<fo:block margin-top="-3mm" role="SKIP"> <!-- -3mm because there is a space before image in the source SVG -->
					<fo:inline-container width="47mm" role="SKIP">
						<fo:block font-size="0pt" fox:alt-text="PDF Association logo">
							<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization">
								<xsl:apply-templates select="mn:logo/mn:image"/>
							</xsl:for-each>
						</fo:block>
					</fo:inline-container>
				</fo:block>

				<!-- Type of document: Specification, Best Practice Guide, Application Note, Technical Note, Extension -->
				<fo:block font-size="29pt" font-weight="bold" text-align="right" margin-top="4mm">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) != '']"/>
				</fo:block>

				<fo:block-container width="112mm" height="98mm" line-height="1.5" margin-top="4mm" fox:shrink-to-fit="true"> <!-- line-height needs to be 1.5 for WCAG Level AA -->
					<xsl:call-template name="insertCoverPageTitles"/>

					<!-- Example: title-intro fr -->
					<!-- <xsl:variable name="lang_other">
						<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:title[@language != $lang]">
							<xsl:if test="not(preceding-sibling::mn:title[@language = current()/@language])">
								<xsl:element name="lang" namespace="{$namespace_mn_xsl}"><xsl:value-of select="@language"/></xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					
					<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
						<xsl:variable name="lang_other" select="."/>
						<fo:block font-size="4pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
						<fo:block font-style="italic" role="SKIP">
							<xsl:call-template name="insertCoverPageTitles">
								<xsl:with-param name="curr_lang" select="$lang_other"/>
								<xsl:with-param name="font_size">28</xsl:with-param>
							</xsl:call-template>
						</fo:block>
					</xsl:for-each> -->
				</fo:block-container>

				<fo:block-container absolute-position="fixed" top="95mm" left="17.5mm" font-size="20pt">
					<fo:table table-layout="fixed" width="174mm">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell><!-- NBSP required to maintain regular table -->
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell><!-- NBSP required to maintain regular table -->
								<fo:table-cell text-align="right" display-align="after" xsl:use-attribute-sets="cover_page_box"> <!-- padding-left="5mm" padding-right="5mm" -->
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$logo_yellow}">
										<fo:block font-size="18pt" margin-left="5mm" margin-right="5mm">
											<fo:block>
												<!-- <xsl:variable name="status" select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:status"/> -->
												<xsl:variable name="status">
													<xsl:call-template name="capitalize">
														<xsl:with-param name="str" select="/mn:metanorma/mn:bibdata/mn:status/mn:stage"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:if test="normalize-space($status) != '' and $status != 'Published'">
													<fo:block color="{$logo_red}">
														<xsl:value-of select="$status"/>
													</fo:block>
												</xsl:if>
												<xsl:variable name="i18n_version">
													<xsl:call-template name="getLocalizedString">
														<xsl:with-param name="key">edition </xsl:with-param>
													</xsl:call-template>
												</xsl:variable>
												<xsl:call-template name="capitalize">
													<xsl:with-param name="str" select="$i18n_version"/>
												</xsl:call-template>
												<xsl:text></xsl:text>
												<xsl:variable name="edition" select="/mn:metanorma/mn:bibdata/mn:edition[normalize-space(@language) = '']"/>
												<xsl:value-of select="$edition"/>
												<xsl:if test="not(contains($edition, '.'))">.0</xsl:if>
											</fo:block>
											<fo:block margin-bottom="2mm">
												<xsl:value-of select="substring(/mn:metanorma/mn:bibdata/mn:version/mn:revision-date, 1, 7)"/>
											</fo:block>
											<fo:block margin-bottom="2mm" font-size="9pt"><!-- small size full document identifier -->
												<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier"/>
											</fo:block>
										</fo:block>
									</fo:block-container>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell><!-- NBSP required to maintain regular table -->
								<fo:table-cell text-align="center" display-align="center" xsl:use-attribute-sets="cover_page_box">
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$logo_green}">
										<fo:block font-size="0pt" role="SKIP">
											<!-- set context node to the cover page image -->
											<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:coverpage-image[1]/mn:image[1]">
												<xsl:call-template name="insertPageImage">
													<xsl:with-param name="svg_content_height">53</xsl:with-param> <!-- this parameter is using for SVG images -->
													<xsl:with-param name="bitmap_width">53</xsl:with-param> <!-- this parameter is using for bitmap images -->
												</xsl:call-template>
											</xsl:for-each>
										</fo:block>
									</fo:block-container>
								</fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell><!-- NBSP required to maintain regular table -->
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="after" xsl:use-attribute-sets="cover_page_box">
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$logo_red}">
										<!-- the group that authored the doc -->
										<fo:block margin-left="5mm" margin-right="5mm" margin-bottom="3mm">
											<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role[@type = 'author' and 
											(mn:description[normalize-space(@language) = ''] = 'Technical committee' or mn:description[normalize-space(@language) = ''] = 'committee')]]/
											mn:organization/mn:subdivision[@type = 'Technical committee' or @type = 'Committee']/mn:name"/>
										</fo:block>
									</fo:block-container>
								</fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell><!-- NBSP required to maintain regular table -->
								<fo:table-cell display-align="after" xsl:use-attribute-sets="cover_page_box">
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$logo_blue}">
										<fo:block margin-left="2mm">
											<!-- Example: © 2025 PDF Association - pdfa.org -->
											<fo:block font-size="9.9pt">
												<xsl:text>© </xsl:text>
												<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:from"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization/mn:name"/>
												<xsl:text> - </xsl:text>
												<fo:inline text-decoration="underline">
													<fo:basic-link fox:alt-text="PDF Association" external-destination="https://pdfa.org/">pdfa.org</fo:basic-link>
												</fo:inline>
											</fo:block>
											<fo:block font-size="8pt" margin-bottom="2mm">
												<xsl:text>This work is licensed under CC-BY-4.0.</xsl:text>
												<!-- Note: the error occurs [Fatal Error] :1621:113: Character reference "&#55356" is an invalid XML character. -->
												<!-- Circled CC -->
												<!-- <fo:inline font-size="10pt"><xsl:call-template name="getCharByCodePoint"><xsl:with-param name="codepoint">1f16d</xsl:with-param></xsl:call-template></fo:inline>
												<xsl:text> </xsl:text> -->
												<!-- Circled Human Figure -->
												<!-- <fo:inline font-size="10pt"><xsl:call-template name="getCharByCodePoint"><xsl:with-param name="codepoint">1f16f</xsl:with-param></xsl:call-template></fo:inline> -->
												<!-- Characters replaced to SVG To prevent warning:
																										PDF isn't valid PDF/UA-1:
														ValidationResult [flavour=ua1, totalAssertions=112627, assertions=[
														TestAssertion [ruleId=RuleId [specification=ISO 14289-1:2014, clause=7.21.7, testNumber=1], status=failed,
														message=The Font dictionary of all fonts shall define the map of all used character codes to Unicode values, either via a ToUnicode entry, or other mechanisms as defined in ISO 14289-1, 7.21.7,
														location=Location [level=CosDocument, context=root/document[0]/pages[0](919 0 obj PDPage)/contentStream[0](947 0 obj PDSemanticContentStream)/operators[1391]/usedGlyphs[0](EAAAAB+SourceSans3-Regular EAAAAB+SourceSans3-Regular 43 0 2124645278 0 true)], locationContext=null, errorMessage=null]], isCompliant=false]
												-->
												<fo:inline baseline-shift="-60%" padding-left="0.5mm">
												<fo:instream-foreign-object content-width="5.6mm" fox:alt-text="Circled Chars">
													<xsl:copy-of select="$circledChars"/>
												</fo:instream-foreign-object>
												</fo:inline>
											</fo:block>
										</fo:block>
									</fo:block-container>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END cover-page -->

	<xsl:template name="insertCoverPageTitles">
		<xsl:param name="curr_lang" select="$lang"/>
		<xsl:param name="font_size">32</xsl:param>
		<xsl:param name="font_style">normal</xsl:param>
		<fo:block role="P/Title">
			<!-- Main title of doc -->
			<fo:block font-size="{$font_size}pt" font-weight="bold" font-style="{$font_style}" role="SKIP">
				<fo:block role="SKIP"><xsl:apply-templates select="mn:metanorma/mn:bibdata/mn:title[@type = 'intro' and @language = $curr_lang]/node()"/></fo:block>
			</fo:block>
			<!-- Subtitle of doc -->
			<fo:block font-size="{$font_size - 2}pt" font-style="{$font_style}" role="SKIP">
				<fo:block role="SKIP"><xsl:apply-templates select="mn:metanorma/mn:bibdata/mn:title[@type = 'main' and @language = $curr_lang][last()]/node()"/></fo:block>
			</fo:block>
			<!-- Part title -->
			<fo:block font-size="{$font_size - 8}pt" font-style="{$font_style}" role="SKIP">
				<fo:block role="SKIP"><xsl:apply-templates select="mn:metanorma/mn:bibdata/mn:title[@type = 'part' and @language = $curr_lang]/node()"/></fo:block>
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:variable name="circledChars">
		<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
			 viewBox="0 0 16 6.6" style="enable-background:new 0 0 16 6.6;" xml:space="preserve" aria-hidden="true" >
			<title>Creative Common icons</title>
  		<desc>Creative Common graphic icons for CC-BY-4.0.</desc>
			<style type="text/css">
				.ccst0 { fill: black; }
			</style>
			<path class="ccst0" d="M0,3.3C0,1.3,1.5,0,3.2,0C5,0,6.5,1.3,6.5,3.3c0,2-1.5,3.3-3.2,3.3C1.5,6.6,0,5.3,0,3.3z M6,3.3
				c0-1.7-1.2-2.8-2.7-2.8c-1.5,0-2.7,1.1-2.7,2.8c0,1.7,1.2,2.9,2.7,2.9C4.7,6.2,6,5,6,3.3z M1,3.3c0-1.2,0.6-1.8,1.3-1.8
				c0.4,0,0.6,0.2,0.8,0.4L2.7,2.3C2.6,2.2,2.5,2.1,2.4,2.1C2,2.1,1.7,2.6,1.7,3.3c0,0.8,0.2,1.2,0.6,1.2c0.2,0,0.3-0.1,0.5-0.2
				l0.3,0.4C2.9,4.9,2.7,5.1,2.3,5.1C1.6,5.1,1,4.5,1,3.3z M3.1,3.3c0-1.2,0.6-1.8,1.3-1.8c0.4,0,0.6,0.2,0.8,0.4L4.8,2.3
				C4.7,2.2,4.7,2.1,4.5,2.1c-0.3,0-0.6,0.5-0.6,1.2c0,0.8,0.2,1.2,0.6,1.2c0.2,0,0.3-0.1,0.5-0.2l0.3,0.4C5.1,4.9,4.8,5.1,4.4,5.1
				C3.7,5.1,3.1,4.5,3.1,3.3z M9.5,3.3c0-2,1.5-3.3,3.2-3.3S16,1.3,16,3.3c0,2-1.5,3.3-3.2,3.3S9.5,5.3,9.5,3.3z M15.4,3.3
				c0-1.7-1.2-2.8-2.7-2.8c-1.5,0-2.7,1.1-2.7,2.8c0,1.7,1.2,2.9,2.7,2.9C14.2,6.2,15.4,5,15.4,3.3z M12.1,5.7c0-0.5-0.1-0.9-0.1-1.4v0
				c-0.3,0-0.5-0.2-0.5-0.5c0-0.3,0-0.7,0.1-1c0.1-0.3,0.2-0.4,0.4-0.5c0.1,0,0.3,0,0.6,0c0.3,0,0.5,0,0.6,0c0.2,0.1,0.4,0.2,0.4,0.5
				c0.1,0.3,0.1,0.7,0.1,1c0,0.3-0.2,0.5-0.5,0.5v0c0,0.6,0,1-0.1,1.4H12.1z M12.1,1.4c0-0.3,0.3-0.6,0.6-0.6s0.6,0.2,0.6,0.6
				C13.3,1.7,13,2,12.7,2C12.4,2,12.1,1.7,12.1,1.4z"/>
		</svg>
	</xsl:variable>

	<xsl:attribute-set name="toc-style"><?extend?>
		<xsl:attribute name="margin-left">1mm</xsl:attribute>
		<xsl:attribute name="margin-right">5mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-listof-title-style"><?extend?>
		<xsl:attribute name="margin-left">5mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_clause-style"><?extend?>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:if test="$level = 0 or $level = 1 and not(ancestor-or-self::mn:annex)">
			<xsl:attribute name="break-before">page</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="toc_and_boilerplate">
		<xsl:param name="num"/>
		<fo:block margin-bottom="12pt" role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block>
		<fo:block-container height="{$pageHeight - $marginTop - $marginBottom - 20}mm" display-align="after">
			<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/*"/>
		</fo:block-container>
		<fo:block break-after="page"/>
		<xsl:apply-templates select="/mn:metanorma/mn:preface/mn:clause[@type = 'toc']">
			<xsl:with-param name="num" select="$num"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- empty back-page to omit back cover -->
	<xsl:template name="back-page">
		<!-- put the back page layout -->
	</xsl:template>

	<xsl:template match="mn:copyright-statement" priority="2">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template name="refine_link-style"><?extend?>
		<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:template>

	<xsl:variable name="variables_pdfa_">
		<xsl:for-each select="//mn:metanorma">
			<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
			<xsl:variable name="current_document"><xsl:copy-of select="."/></xsl:variable>
			<xsl:for-each select="xalan:nodeset($current_document)">
				<mnx:doc num="{$num}">
					<xsl:variable name="bibdata">
						<xsl:apply-templates select="mn:metanorma/mn:bibdata" mode="update_xml_enclose_keep-together_within-line"/>
					</xsl:variable>
					<title><xsl:apply-templates select="xalan:nodeset($bibdata)/mn:bibdata/mn:title[@type = 'main'][last()]/node()"/></title>
				</mnx:doc>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="variables_pdfa" select="xalan:nodeset($variables_pdfa_)"/>

	<xsl:template name="insertHeaderFooter">
		<xsl:param name="num"/>
		<xsl:param name="section"/>
		<xsl:call-template name="insertHeader">
			<xsl:with-param name="num" select="$num"/>
			<xsl:with-param name="section" select="$section"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="num" select="$num"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="insertHeader">
		<xsl:param name="num"/>
		<xsl:param name="section"/>
		<fo:static-content flow-name="header" role="artifact">
			<fo:block-container margin-top="10mm" border-bottom="0.5pt solid black" text-align="center" font-size="8pt">
				<fo:block><xsl:copy-of select="$variables_pdfa/mnx:doc[@num = $num]/title/node()"/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="insertFooter">
		<xsl:param name="num"/>
		<xsl:variable name="footerText"> 
			<xsl:call-template name="capitalizeWords">
				<xsl:with-param name="str">
					<xsl:choose>
						<xsl:when test="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:doctype-alias">
							<xsl:value-of select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:doctype-alias"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="insertFooterOdd">
			<xsl:with-param name="num" select="$num"/>
			<xsl:with-param name="footerText" select="$footerText"/>
		</xsl:call-template>
		
		<xsl:call-template name="insertFooterEven">
			<xsl:with-param name="num" select="$num"/>
			<xsl:with-param name="footerText" select="$footerText"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Page numbering: roman numerals for ToC/boilerplate, arabic for main body -->
	<xsl:attribute-set name="page-sequence-main"><?extend?>
		<xsl:attribute name="format">i</xsl:attribute>
		<xsl:attribute name="initial-page-number">1</xsl:attribute>
	</xsl:attribute-set>

	<!-- Overrides base refine_page-sequence-main to switch to Arabic numerals for body content.
	     Preface page sequences inherit format="i" from the attribute-set and override
	     initial-page-number to "auto" so they continue the roman count from the ToC.
	     The first main-body sequence restarts at Arabic 1; subsequent ones continue via "auto". -->
	<xsl:template name="refine_page-sequence-main">
		<xsl:param name="layoutVersion"/>
		<xsl:param name="doctype"/>
		<xsl:attribute name="master-reference">document<xsl:call-template name="getPageSequenceOrientation"/></xsl:attribute>
		<xsl:choose>
			<xsl:when test=".//mn:sections or .//mn:annex or .//mn:bibliography">
				<xsl:attribute name="format">1</xsl:attribute>
				<xsl:choose>
					<xsl:when test="not(preceding-sibling::mn:page_sequence[.//mn:sections or .//mn:annex or .//mn:bibliography])">
						<xsl:attribute name="initial-page-number">1</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="initial-page-number">auto</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- Preface sequences: continue roman numeral count from the ToC/boilerplate sequence -->
				<xsl:attribute name="initial-page-number">auto</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- All titles (headings) are NOT bold to preserve PDF notation formatting -->
	<xsl:template name="refine_title-style"><?extend?>
		<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute><!-- allow char-based PDF notation to be visible -->
	</xsl:template>

	<xsl:template match="mn:strong[ancestor::mn:fmt-title]" priority="2">
		<fo:inline font-weight="bold"><!-- ensure that PDF notation bold char formatting within titles is retained -->
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_strong_style"><!-- NO ?extend? !! so color remains unchanged -->
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="ancestor::*['preferred'] or ancestor::*['admitted']">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- "Table of Contents" H1 heading -->
	<xsl:template name="refine_toc-title-style"><!-- NO ?extend? ! --> <!-- TODO: THIS FAILS TO DO ANYTHING!!! -->
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute>
	</xsl:template>

	<!-- Term acronyms (preferred, admintted, etc.) are not bold -->
	<xsl:attribute-set name="refine_term-kind-style"><?extend?>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set>
  
	<!-- Suppress the boxes with text that appear to the right of preferred / admitted terms -->
	<xsl:template name="display_term_kind">
		<xsl:if test="not(self::mn:fmt-preferred or self::mn:fmt-admitted)">
			<xsl:call-template name="term_kind"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="refine_bibliography-title-style"><?extend?>
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_annex-title-style"><?extend?>
		<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_indexsect-title-style">
		<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute>
	</xsl:template>

	<xsl:template match="mn:fmt-title" name="title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="title_styles">
			<styles xsl:use-attribute-sets="title-style">
				<xsl:call-template name="refine_title-style"/>
			</styles>
		</xsl:variable>

		<xsl:element name="{$element-name}">
			<xsl:copy-of select="xalan:nodeset($title_styles)/styles/@*"/>
			<xsl:if test="$level = 1">
				<xsl:attribute name="break-before">page</xsl:attribute><!-- ensure all H1s start on a new page -->
			</xsl:if>
			<xsl:call-template name="apply-heading-font-size"/>
			<fo:block-container xsl:use-attribute-sets="reset-margins-style">
				<fo:block role="SKIP">
					<xsl:call-template name="setIDforNamedDestinationInline"/>
					<xsl:variable name="section-number" select="normalize-space(mn:tab[1]/preceding-sibling::node())"/>
					<xsl:if test="$section-number != ''">
						<xsl:value-of select="$section-number"/>&#x2003; <!-- em space (wider than NBSP) -->
					</xsl:if>
					<xsl:call-template name="extractTitle"/> <!-- section title -->
					<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
				</fo:block>
			</fo:block-container>
		</xsl:element>
	</xsl:template>

	<!-- Scale down monospaced fonts slightly because they look visually larger -->
	<xsl:template name="refine_tt-style"><?extend?>
		<xsl:attribute name="font-size"><xsl:value-of select="$mono_font-reduction"/></xsl:attribute>
	</xsl:template>
	
	<xsl:template name="refine_list-item-label-style"><?extend?>
		<xsl:if test="parent::mn:ul">
			<xsl:attribute name="color"><xsl:value-of select="$color_secondary"/></xsl:attribute>
			<xsl:copy-of select="@color"/>
			<xsl:copy-of select="@font-size"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="refine_sourcecode-style"><?extend?>
		<xsl:attribute name="font-size">85%</xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_pre-style"><?extend?>
		<xsl:attribute name="font-size"><xsl:value-of select="$mono_font-reduction"/></xsl:attribute>
	</xsl:template>

	<!-- Notes and Admonitions -->
	<xsl:attribute-set name="note-name-style"><?extend?>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_note-style"><?extend?>
		<xsl:attribute name="font-size"><xsl:value-of select="$small-text-reduction"/></xsl:attribute>
		<xsl:attribute name="background-color">rgb(252, 251, 212)</xsl:attribute>
		<xsl:attribute name="border-left">4pt solid rgb(255, 200, 36)</xsl:attribute>
		<xsl:attribute name="margin-left">3mm</xsl:attribute>
		<xsl:attribute name="margin-right">2mm</xsl:attribute>
		<xsl:attribute name="padding">1.5mm</xsl:attribute>
		<xsl:attribute name="margin-top">2mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">2mm</xsl:attribute>
		<xsl:if test="ancestor::mn:bibitem">
			<xsl:attribute name="margin-left">8.5mm</xsl:attribute> <!-- Notes that belong to bibliographic items need larger left indent to align with hanging para -->
		</xsl:if>
	</xsl:template>

	<!-- Admonitions -->
	<xsl:template match="mn:admonition">
		<fo:block margin-left="3mm" margin-right="2mm" padding="1.5mm" margin-top="2mm" margin-bottom="2mm" font-size="{$small-text-reduction}">
			<xsl:if test="@type = 'tip'">
				<xsl:attribute name="background-color">rgb(245,235,206)</xsl:attribute>
				<xsl:attribute name="border-left">4pt solid rgb(208,63,78)</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'warning'">
				<xsl:attribute name="background-color">rgb(255,245,230)</xsl:attribute>
				<xsl:attribute name="border-left">4pt solid rgb(255,140,0)</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'caution'">
				<xsl:attribute name="background-color">rgb(255,250,205)</xsl:attribute>
				<xsl:attribute name="border-left">4pt solid rgb(184,134,11)</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'important'">
				<xsl:attribute name="background-color">rgb(255,230,230)</xsl:attribute>
				<xsl:attribute name="border-left">4pt solid rgb(255,0,0)</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'safety-precaution'">
				<xsl:attribute name="background-color">rgb(230,245,230)</xsl:attribute>
				<xsl:attribute name="border-left">4pt solid rgb(0,128,0)</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'editorial'">
				<xsl:attribute name="background-color">rgb(240,240,240)</xsl:attribute>
				<xsl:attribute name="border-left">4pt solid rgb(128,128,128)</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'box'"><!-- "box" is NOT an independent property of other admonition types - it is its own type! -->
					<xsl:attribute name="background-color">rgb(154, 221, 218)</xsl:attribute>
				<xsl:attribute name="border">2pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@type) or @type = ''">
				<xsl:attribute name="background-color">rgb(240,240,240)</xsl:attribute>
					<xsl:attribute name="border-left">4pt solid rgb(80,80,80)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Style admonition name to match border colors above (except "box") --> <!-- TODO: DOES NOT WORK!!! -->
	<!-- "refine_admonition-name-style" does not support switching on type -->
	<xsl:template match="mn:admonition[@type = 'tip']/*/mn:fmt-name">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">rgb(208,63,78)</xsl:attribute>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:admonition[@type = 'warning']/*/mn:fmt-name']">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">rgb(255,140,0)</xsl:attribute>		
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:admonition[@type = 'caution']/*/mn:span[@class = 'fmt-element-name']">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<fo:inline color="rgb(184,134,11)" font-weight="bold" keep-with-next="always">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-element-name[ancestor::mn:admonition[@type = 'important']]">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<fo:inline color="rgb(255,0,0)" font-weight="bold" keep-with-next="always">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-element-name[ancestor-or-self::mn:admonition[@type = 'safety-precaution']]" mode="update_xml_step1" priority="2">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<fo:inline color="rgb(0,128,0)" font-weight="bold" keep-with-next="always">
			<xsl:apply-templates mode="update_xml_step1"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-element-name[ancestor-or-self::mn:admonition[@type = 'editorial']]" mode="update_xml_step1" priority="2">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<fo:inline color="rgb(128,128,128)" font-weight="bold" keep-with-next="always">
			<xsl:apply-templates mode="update_xml_step1"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-element-name[ancestor-or-self::mn:admonition[not(@type) or @type = '']]" mode="update_xml_step1" priority="2">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<fo:inline color="rgb(80,80,80)" font-weight="bold" keep-with-next="always">
			<xsl:apply-templates mode="update_xml_step1"/>
		</fo:inline>
	</xsl:template>

	<!-- Definition list (incl. Abbreviated terms) - center-aligned vertically -->
	<xsl:attribute-set name="dl-name-style"><?extend?>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-top">3pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style"><?extend?>
		<xsl:attribute name="font-weight">normal</xsl:attribute><!-- allow PDF notation to be visible -->
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="list-name-style"><?extend?>
		<xsl:attribute name="font-weight">normal</xsl:attribute><!-- allow PDF notation to be visible -->
	</xsl:attribute-set>

	<!-- Source code blocks -->
	<xsl:template name="refine_sourcecode-container-style"><?extend?>
		<xsl:attribute name="margin-left">3mm</xsl:attribute>
		<xsl:attribute name="margin-right">3mm</xsl:attribute>
		<xsl:attribute name="margin-top">0mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">0mm</xsl:attribute>
		<xsl:attribute name="padding">2mm</xsl:attribute>
		<xsl:attribute name="background-color">rgb(240, 240, 240)</xsl:attribute> <!-- check source code background color against table zebra stripes -->
	</xsl:template>

	<xsl:template name="refine_sourcecode-name-style"><?extend?>
		<xsl:attribute name="space-before">2pt</xsl:attribute>
		<xsl:attribute name="space-after">2pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin">0mm</xsl:attribute>
		<xsl:attribute name="padding">0mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_sourcecode-style"><?extend?>
		<xsl:attribute name="font-family"><xsl:value-of select="$monospaced_font"/></xsl:attribute>
		<xsl:attribute name="font-size"><xsl:value-of select="$mono_font-reduction"/></xsl:attribute>
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
		<xsl:attribute name="padding-top">0mm</xsl:attribute>
		<xsl:attribute name="margin-top">0mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">0mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">0mm</xsl:attribute>
	</xsl:template>

	<!-- Example blocks - mimic notes/admonitions above for margins and padding -->
	
	<!-- Separate EXAMPLE caption from first paragraph of example text -->
	<xsl:variable name="example_display_in">block</xsl:variable>

	<xsl:template name="refine_example-style"><?extend?>
		<xsl:attribute name="border-left">2pt solid <xsl:value-of select="$color_blue"/></xsl:attribute>
		<xsl:attribute name="margin-left">3mm</xsl:attribute>
		<xsl:attribute name="margin-right">2mm</xsl:attribute>
		<xsl:attribute name="padding">1.5mm</xsl:attribute>
		<xsl:attribute name="margin-top">2mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">0mm</xsl:attribute>
	</xsl:template>

	<xsl:attribute-set name="example-name-style"><?extend?>
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_example-p-style"><?extend?>
		<xsl:attribute name="margin">0mm</xsl:attribute>
		<xsl:attribute name="space-before">3pt</xsl:attribute>
		<xsl:attribute name="space-after">3pt</xsl:attribute>
	</xsl:template>

	<!-- Footnote text (incl. reference) to be black to meet WCAG Level AA contrast. Does NOT work if template refine_fn-style! -->
	<xsl:attribute-set name="fn-body-style"><?extend?>
		<xsl:attribute name="color">black</xsl:attribute>
	</xsl:attribute-set>

	<!-- PDF Association custom semantic span formatting -->
	<xsl:template match="mn:span[@class = 'requirement' or @class = 'recommendation' or @class = 'pdf-version' or @class = 'pdf-operator' or @class = 'pdf-keyword']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template match="mn:span[@class = 'requirement']">
		<fo:inline color="rgb(255, 0, 0)" font-weight="bold"> <!-- Red -->
			<xsl:value-of select="translate(., $lowercase, $uppercase)"/> <!-- convert to uppercase -->
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:span[@class = 'recommendation']">
		<fo:inline color="rgb(255, 140, 0)" font-weight="bold"> <!-- DarkOrange -->
			<xsl:value-of select="translate(., $lowercase, $uppercase)"/> <!-- convert to uppercase -->
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:span[@class = 'pdf-version']"> <!-- italic blue "(PDF x.y)"-->
		<fo:inline color="rgb(0, 0, 255)" font-weight="lighter" font-style="italic">
			<xsl:value-of select="concat('(PDF ', ., ')')"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:span[@class = 'pdf-operator']">
		<fo:inline font-family="monospace" background-color="rgb(224, 224, 175)" color="rgb(255, 0, 0)" font-weight="bold" font-size="{$mono_font-reduction}" padding="1pt">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:span[@class = 'pdf-keyword']">
		<fo:inline font-family="monospace" background-color="rgb(224, 224, 175)" color="rgb(0, 0, 255)" font-weight="bold" font-size="{$mono_font-reduction}" padding="1pt">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- default paragraph formatting. Make equally centred vertically so narrow table cells look better -->
	<xsl:template name="refine_p-style"><?extend?>
		<xsl:attribute name="space-after">3pt</xsl:attribute>
		<xsl:attribute name="space-before">3pt</xsl:attribute>
	</xsl:template>

	<!-- Table formatting -->
	<xsl:attribute-set name="table-name-style"><?extend?>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute> <!-- allow PDF notation to be visible in table captions -->
	</xsl:attribute-set>

	<xsl:template name="refine_table-style"><?extend?>
		<xsl:attribute name="border">1.5pt solid <xsl:value-of select="$color_blue"/></xsl:attribute> <!-- Thick outer border -->
	</xsl:template>

	<xsl:attribute-set name="table-header-row-style">
		<xsl:attribute name="font-weight">normal</xsl:attribute> <!-- allow PDF notation to be visible in table headers -->
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="border">0.75pt solid <xsl:value-of select="$color_blue"/></xsl:attribute> <!-- narrow row and column borders -->
		<xsl:attribute name="background-color">rgb(197, 237, 255)</xsl:attribute> <!-- Shade heading cells very pale blue -->
		<xsl:attribute name="border">1.5pt solid <xsl:value-of select="$color_blue"/></xsl:attribute> <!-- Thick border -->
	</xsl:attribute-set>

	<xsl:template name="refine_table-body-row-style"><!-- NO ?extend? ! -->
		<xsl:variable name="number"><xsl:number/></xsl:variable>
		<xsl:attribute name="border">0.75pt solid <xsl:value-of select="$color_blue"/></xsl:attribute> <!-- narrow row and column borders -->
		<xsl:if test="$number mod 2 = 0">
			<xsl:attribute name="background-color">rgb(221, 221, 221)</xsl:attribute> <!-- very pale zebra stripes. JND from sourcecode blocks. -->
		</xsl:if>
	</xsl:template>

	<!-- Captions "Table X-", "Figure X -", "EXAMPLE -", "Tip", "Caution", etc., up to and including delimiter but NOT caption text itself as conflicts with PDF notation -->
	<xsl:template match="mn:span[@class = 'fmt-caption-label' or @class = 'fmt-element-name' or @class = 'fmt-caption-delim']" mode="contents_item" priority="3">
		<xsl:attribute name="font-weight">bold</xsl:attribute> 
	</xsl:template>

	<!-- Compress space around ToC entries -->
	<xsl:template name="refine_toc-item-style"><?extend?>
		<xsl:if test="@level = 1">
			<xsl:if test="preceding-sibling::mnx:item[@display = 'true' and @level = 1]">
				<xsl:attribute name="space-before">3mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="space-after">1.5mm</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute> <!-- avoid bold as it conflicts with PDF notation - rely on color -->
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="@level &gt;= 2">
			<xsl:attribute name="margin-left"><xsl:value-of select="(@level - 1) * $toc_item_indent"/>mm</xsl:attribute>
			<xsl:attribute name="space-before">1.5mm</xsl:attribute>
			<xsl:attribute name="space-after">1.5mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- Control font size of headings -->
	<xsl:template name="apply-heading-font-size">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$level = 2">
				<xsl:attribute name="font-size">20pt</xsl:attribute>
			</xsl:when>
			<xsl:when test="$level = 3">
				<xsl:attribute name="font-size">18pt</xsl:attribute>
			</xsl:when>
			<xsl:when test="$level = 4">
				<xsl:attribute name="font-size">16pt</xsl:attribute>
			</xsl:when>
			<xsl:when test="$level >= 5">
				<xsl:attribute name="font-size">14pt</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- Bullet styles -->
	<xsl:template match="mn:ul/mn:li/mn:fmt-name" mode="update_xml_step1" priority="3">
		<xsl:choose>
			<xsl:when test="normalize-space() = 'o'">
				<xsl:attribute name="label">■</xsl:attribute>
				<xsl:attribute name="font-size">90%</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute><!-- TODO: not obeyed!?! -->
			</xsl:when>
			<xsl:when test="normalize-space() = '—'">
				<xsl:attribute name="label">◆</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$logo_blue"/></xsl:attribute><!-- TODO: not obeyed!?! -->
			</xsl:when>
			<xsl:when test="normalize-space() = '•'">
				<xsl:attribute name="label">●</xsl:attribute>
				<xsl:attribute name="font-size">110%</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$logo_green"/></xsl:attribute><!-- TODO: not obeyed!?! -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="color"><xsl:value-of select="$logo_red"/></xsl:attribute><!-- default --><!-- TODO: not obeyed!?! -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
