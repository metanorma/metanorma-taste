<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<!-- Page margins. The base values serve every doctype; the published
	     resolutions and circular letters print their own geometry, so the
	     variables are computed per document class:
	     - legacy assembly resolutions (A12 era): the body starts at the
	       19mm flow top on page 1 and at 30.5mm on continuation pages,
	       with 25mm side margins and the footer block reserved below;
	     - A1x assembly resolutions (A13): the bilingual page opens near
	       the sheet top (11.9mm) on 14.6mm side margins;
	     - circular letters: the letterhead rides page 1 at 19mm and the
	       body continues at 28.5mm, with the printed footer zone kept
	       free at the bottom. -->
	<xsl:variable name="iala_rescirc_legacy" select="$iala_is_rescirc and number(substring(normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on), 1, 4)) &lt; 2016"/>
	<xsl:variable name="iala_rescirc_a1x" select="$iala_is_resolution and not(starts-with($iala_docidentifier, 'GA')) and not($iala_rescirc_legacy)"/>
	<xsl:variable name="marginTop">
		<xsl:choose>
			<xsl:when test="$iala_rescirc_legacy">30.5</xsl:when>
			<xsl:when test="$iala_rescirc_a1x">11.9</xsl:when>
			<xsl:when test="$iala_is_letter">28.5</xsl:when>
			<xsl:otherwise>19</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- the flow top of page 1: circular letters open with the letterhead
	     block riding a tall first-page header zone; the A1x bilingual
	     resolutions open the whole page near the sheet top -->
	<xsl:variable name="marginTopFirst">
		<xsl:choose>
			<xsl:when test="$iala_is_letter">46</xsl:when>
			<xsl:when test="$iala_rescirc_a1x">11.9</xsl:when>
			<xsl:otherwise>19</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginBottom">
		<xsl:choose>
			<xsl:when test="$iala_rescirc_legacy">34.4</xsl:when>
			<xsl:when test="$iala_rescirc_a1x">27.5</xsl:when>
			<xsl:when test="$iala_is_letter">31.75</xsl:when>
			<xsl:otherwise>25.8</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginLeftRight1">
		<xsl:choose>
			<xsl:when test="$iala_rescirc_legacy">25</xsl:when>
			<xsl:when test="$iala_rescirc_a1x">14.6</xsl:when>
			<xsl:otherwise>16</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginLeftRight2">
		<xsl:choose>
			<xsl:when test="$iala_rescirc_legacy">25</xsl:when>
			<xsl:when test="$iala_rescirc_a1x">14.6</xsl:when>
			<xsl:otherwise>13.2</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- CORPORATE COLOURS -->
	<xsl:variable name="color_corporate_blue">rgb(0, 85, 140)</xsl:variable>
	<xsl:variable name="color_corporate_light_blue">rgb(103, 135, 196)</xsl:variable>
	<xsl:variable name="color_corporate_yellow">rgb(254, 219, 0)</xsl:variable>
	<xsl:variable name="color_corporate_gradient_blue_start">rgb(0, 109, 158)</xsl:variable>
	<xsl:variable name="color_corporate_gradient_blue_end">rgb(0, 169, 207)</xsl:variable>

	<!-- PRIMARY COLOURS -->
	<xsl:variable name="color_primary_recommendation">rgb(0, 159, 223)</xsl:variable>
	<xsl:variable name="color_primary_recommendation_50">rgb(131, 208, 245)</xsl:variable>
	<xsl:variable name="color_primary_recommendation_20">rgb(212, 237, 252)</xsl:variable>
	<xsl:variable name="color_primary_model_course">rgb(0, 175, 170)</xsl:variable>
	<xsl:variable name="color_primary_model_course_50">rgb(148, 217, 213)</xsl:variable>
	<xsl:variable name="color_primary_model_course_20">rgb(213, 240, 237)</xsl:variable>
	<xsl:variable name="color_primary_">rgb(0, 181, 208)</xsl:variable>
	<xsl:variable name="color_primary_50">rgb(171, 219, 233)</xsl:variable>
	<xsl:variable name="color_primary_20">rgb(216, 238, 245)</xsl:variable>
	<xsl:variable name="color_primary_guideline">rgb(64, 126, 201)</xsl:variable>
	<xsl:variable name="color_primary_guideline_50">rgb(178, 193, 237)</xsl:variable>
	<xsl:variable name="color_primary_guideline_20">rgb(218, 223, 246)</xsl:variable>
	
	<!-- SECONDARY COLOURS -->
	<xsl:variable name="color_secondary_purple">rgb(153, 80, 159)</xsl:variable>
	<xsl:variable name="color_secondary_purple_50">rgb(201, 169, 208)</xsl:variable>
	<xsl:variable name="color_secondary_purple_20">rgb(232, 221, 233)</xsl:variable>
	<xsl:variable name="color_secondary_green">rgb(82, 174, 50)</xsl:variable>
	<xsl:variable name="color_secondary_green_50">rgb(183, 214, 155)</xsl:variable>
	<xsl:variable name="color_secondary_green_20">rgb(226, 238, 217)</xsl:variable>
	<xsl:variable name="color_secondary_red">rgb(230, 56, 17)</xsl:variable>
	<xsl:variable name="color_secondary_red_50">rgb(246, 174, 135)</xsl:variable>
	<xsl:variable name="color_secondary_red_20">rgb(253, 224, 208)</xsl:variable>
	<xsl:variable name="color_secondary_gray">rgb(87, 87, 86)</xsl:variable>
	<xsl:variable name="color_secondary_gray_50">rgb(157, 157, 156)</xsl:variable>
	<xsl:variable name="color_secondary_gray_20">rgb(218, 218, 218)</xsl:variable>
	<xsl:variable name="color_secondary_gray_10">rgb(237, 237, 237)</xsl:variable>

	<xsl:variable name="color_toc_title">rgb(0, 159, 227)</xsl:variable>

	<!-- ============================================================ -->
	<!-- Document kind switches                                       -->
	<!-- ============================================================ -->
	<xsl:variable name="iala_doctype_alias" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:doctype-alias)"/>
	<xsl:variable name="iala_is_report" select="$iala_doctype_alias = 'report'"/>
	<xsl:variable name="iala_is_manual" select="$iala_doctype_alias = 'manual'"/>
	<!-- The information-paper leaflet family (the 2008 "Definitions
			relating to ..." form): routed per document through the
			presentation-metadata doctype alias; the registered base doctype
			stays whatever the catalogue carries. -->
	<xsl:variable name="iala_is_information_paper" select="$iala_doctype_alias = 'information-paper'"/>

	<!-- ============================================================ -->
	<!-- RESOLUTIONS + CIRCULAR LETTERS (published-PDF parity)        -->
	<!-- Resolutions (doctype general-assembly) and circular letters  -->
	<!-- (doctype letter) carry no standard-style cover: the published -->
	<!-- PDFs open with a letterhead block that shares page 1 with the -->
	<!-- body, and carry no Contents page and no Foreword.             -->
	<!-- ============================================================ -->
	<!-- The language-tagged ext/doctype carries the full name: resolutions
	     are "General Assembly Resolution" (base doctype "standard"),
	     letters are "Circular Letter" / "Letter" (base doctype "letter") -->
	<xsl:variable name="iala_doctype_full_lc" select="translate(normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) != '']), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
	<!-- The model course doctype: the base doctype is "standard" for them,
			so key the model-course form on the language-tagged full name. -->
	<xsl:variable name="iala_is_model_course" select="$iala_doctype_full_lc = 'model course'"/>
	<xsl:variable name="iala_is_letter" select="contains($iala_doctype_full_lc, 'letter')"/>
	<xsl:variable name="iala_is_resolution" select="not($iala_is_letter) and (contains($iala_doctype_full_lc, 'assembly') or contains($iala_doctype_full_lc, 'resolution'))"/>
	<xsl:variable name="iala_is_rescirc" select="$iala_is_letter or $iala_is_resolution"/>
	<!-- the first-page header region carries the printed letterhead logo on
	     circular letters; every other document keeps the running header -->
	<xsl:variable name="iala_first_header_region">
		<xsl:choose>
			<xsl:when test="$iala_is_letter">header-first</xsl:when>
			<xsl:otherwise>header</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Example: GA01.01 - GA resolutions print the docidentifier in the
	     slash form GA01/Res.01; A1x assembly resolutions (A12-01) print
	     "Resolution " + docidentifier verbatim -->
	<xsl:variable name="iala_docidentifier" select="normalize-space(/mn:metanorma/mn:bibdata/mn:docidentifier[@primary = 'true'])"/>
	<xsl:variable name="iala_docid_slash">
		<xsl:choose>
			<xsl:when test="contains($iala_docidentifier, '.') and starts-with($iala_docidentifier, 'GA')">
				<xsl:value-of select="concat(substring-before($iala_docidentifier, '.'), '/Res.', substring-after($iala_docidentifier, '.'))"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$iala_docidentifier"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- the GA series ordinal: GA01.01 - "1st General Assembly" (the
	     ordinal comes from the series part, before the dot) -->
	<xsl:variable name="iala_ga_series" select="substring-before(concat($iala_docidentifier, '.'), '.')"/>
	<xsl:variable name="iala_ga_ordinal" select="number(substring-after($iala_ga_series, 'GA'))"/>
	<xsl:variable name="iala_ga_ordinal_suffix">
		<xsl:choose>
			<xsl:when test="$iala_ga_ordinal = 1">st</xsl:when>
			<xsl:when test="$iala_ga_ordinal = 2">nd</xsl:when>
			<xsl:when test="$iala_ga_ordinal = 3">rd</xsl:when>
			<xsl:otherwise>th</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="iala_docdate" select="normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on)"/>
	<xsl:variable name="iala_lang" select="normalize-space(/mn:metanorma/mn:bibdata/mn:language[@current = 'true'])"/>
	<xsl:variable name="iala_title_en" select="normalize-space(/mn:metanorma/mn:bibdata/mn:title[@type = 'main' and (@language = 'en' or normalize-space(@language) = '')])"/>

	<!-- The standards family (guidelines, model courses, recommendations,
			standards) carries the published clause numbering model and the
			base-size landscape tables; the reports, manuals and rescirc
			doctypes were tuned without them. -->
	<xsl:variable name="iala_std_numbering" select="not($iala_is_report) and not($iala_is_manual) and not($iala_is_rescirc)"/>
	<!-- the guide sub-family (guidelines, model courses) carries the
			published numbering model and the standards-family landscape
			rules; the standards and recommendations were verified without
			them (their published form is the stdrec brand-era layout) -->
	<xsl:variable name="iala_guide_family" select="not($iala_is_report) and not($iala_is_manual) and not($iala_is_rescirc) and not($iala_is_standard) and not($iala_is_recommendation) and not($iala_is_information_paper)"/>
	<!-- the compact landscape rendering (7.5pt, tight paddings, equal
			column shares) is the reports/manuals published form -->
	<xsl:variable name="iala_compact_landscape" select="$iala_is_report or $iala_is_manual"/>

	<!-- the model courses print unnumbered PART banners and restart the
			clause numbering beneath each banner (flat overview, module-
			scoped M.x teaching modules); the model-course doctype sits in
			the language-tagged ext/doctype and the doctype alias, while
			the bare ext/doctype slot reads "standard" -->
	<xsl:variable name="iala_is_model_course" select="$iala_doctype_alias = 'model-course' or /mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) = ''] = 'model-course'"/>
	<!-- the C0103-1 era prints the module rows as unnumbered "MODULE N"
			banners ("Module 1: Communication ..."); the C2007-1 era numbers
			them as ordinary clauses ("Module 1 - Introduction ...") -->
	<xsl:variable name="iala_mc_module_banner" select="$iala_is_model_course and /mn:metanorma/mn:sections//mn:clause[mn:title][starts-with(normalize-space(mn:title), 'Module ')][contains(mn:title, ':')]"/>

	<!-- ============================================================ -->
	<!-- BRAND ERA HELPERS (published-PDF parity)                     -->
	<!-- The published IALA corpus spans three brand eras, driven by  -->
	<!-- the publication year on bibdata/date[@type='published']:     -->
	<!--   legacy (<= 2023): "IALA ..." banner, iala-aism address     -->
	<!--   transitional (2024-2025): same banner, iala.int address    -->
	<!--   current (>= 2026): plain doctype banner, iala.int          -->
	<!-- Recommendations keep the light-blue banner in every era; the -->
	<!-- base doctype is 'standard' for them, so decisions key on the -->
	<!-- language-tagged ext/doctype (Standard / Recommendation).     -->
	<!-- ============================================================ -->
	<xsl:variable name="iala_doctype_full" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) != ''])"/>
	<xsl:variable name="iala_year" select="substring(normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on), 1, 4)"/>
	<!-- NaN comparisons are false, so unknown years stay out of every era -->
	<xsl:variable name="iala_era_legacy" select="number($iala_year) &lt; 2024"/>
	<xsl:variable name="iala_era_transitional" select="number($iala_year) &gt;= 2024 and number($iala_year) &lt; 2026"/>
	<xsl:variable name="iala_era_old" select="number($iala_year) &lt; 2026"/>
	<xsl:variable name="iala_is_standard" select="$iala_doctype_full = 'Standard'"/>
	<xsl:variable name="iala_is_recommendation" select="$iala_doctype_full = 'Recommendation'"/>
	<!-- Published documents dated before 2026 carry the "IALA" association
			prefix on the doctype banner and in the running footer (the
			December 2025 guidelines print "IALA GUIDELINE", the model
			courses "IALA MODEL COURSE"); the 2026 editions print the bare
			doctype. Reports, manuals, leaflets and rescirc documents are
			not keyed on it. -->
	<xsl:variable name="iala_iala_prefix" select="$iala_era_old and ($iala_is_standard or $iala_is_recommendation or $iala_guide_family)"/>

	<!-- Recital qualifier printed under the doctype banner on recommendation
			covers ("(NORMATIVE)" / "(INFORMATIVE)" / "(Normative)", as printed
			per document), carried by the typed normativity clause; the running
			footer prints it sentence-cased. -->
	<xsl:variable name="iala_normativity" select="normalize-space((//mn:clause[@type = 'normativity'])[1]/mn:p[1])"/>
	<!-- The running footer title as printed, carried by the typed
			running-title clause (R1026 "Marine AtoN", R1027 lower-case
			"payload"); absent, the footer prints the main title. -->
	<xsl:variable name="iala_running_title" select="normalize-space((//mn:clause[@type = 'running-title'])[1]/mn:p[1])"/>

	<xsl:variable name="iala_lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="iala_upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<!-- "(NORMATIVE)" as encoded on the cover prints "(Normative)" in the
			running footer: sentence-case the string inside the parentheses. -->
	<xsl:template name="iala_sentence_case">
		<xsl:param name="str"/>
		<xsl:variable name="paren" select="normalize-space(substring-after($str, '('))"/>
		<xsl:variable name="word" select="normalize-space(substring-before($paren, ')'))"/>
		<xsl:choose>
			<xsl:when test="$word != ''">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="translate(substring($word, 1, 1), $iala_lower, $iala_upper)"/>
				<xsl:value-of select="translate(substring($word, 2), $iala_upper, $iala_lower)"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:attribute-set name="root-style">
		<xsl:attribute name="font-family">Calibri, Cambria Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
		<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
	</xsl:attribute-set>

		<xsl:variable name="variables_">
		<xsl:for-each select="//mn:metanorma">
			<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>

			<xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($current_document)">
				<mnx:doc num="{$num}">
					<!-- Example: guideline -->
					<doctype><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) = '']"/></doctype>
					<doctype_full><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[@language != '']"/></doctype_full>
					
					<!-- Example: G1199 -->
					<docidentifier><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[@primary = 'true']"/></docidentifier>

					<!-- Example: VTS DIGITAL COMMUNICATIONS -->
					<!-- The main title only: the recommendation recital
						qualifier and the running footer title ride their own
						typed clauses and print in their own slots. -->
					<title>
						<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:title[@type = 'main']">
							<item>
								<xsl:apply-templates />
							</item>
						</xsl:for-each>
					</title>

					<!-- Example: Edition 1.0 -->
					<edition>
						<xsl:call-template name="capitalize">
							<xsl:with-param name="str" select="/mn:metanorma/mn:bibdata/mn:edition[@language != '']"/>
						</xsl:call-template>
					</edition>
					
					<!-- Example: June 2026 -->
					<date>
						<xsl:call-template name="convertDate">
							<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on"/>
						</xsl:call-template>
					</date>

					<!-- Example: urn:mrn:iala:pub:g1199:ed1.0 -->
					<!-- IALA bibdata carries the URN in uri[@type='urn']; the
						docidentifier[@type='urn'] slot is the fallback and lacks
						the 'urn:' scheme prefix -->
					<urn>
						<xsl:choose>
							<xsl:when test="normalize-space(/mn:metanorma/mn:bibdata/mn:uri[@type = 'urn']) != ''">
								<xsl:value-of select="normalize-space(/mn:metanorma/mn:bibdata/mn:uri[@type = 'urn'])"/>
							</xsl:when>
							<xsl:otherwise>urn:<xsl:value-of select="normalize-space(/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'urn'])"/></xsl:otherwise>
						</xsl:choose>
					</urn>

				</mnx:doc>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
				
			<!-- Cover page -->
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="48mm" margin-bottom="31mm" margin-left="6mm" margin-right="7mm"/>
				<fo:region-before region-name="cover-page-header" extent="48mm" />
				<fo:region-after region-name="cover-page-footer" extent="31mm"/>
				<fo:region-start extent="6mm"/>
				<fo:region-end extent="7mm"/>
			</fo:simple-page-master>
		
			<fo:simple-page-master master-name="page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="page-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>

			<!-- first body page of the resolutions and circular letters: the
			     letterhead zone differs from the continuation pages (circular
			     letters ride the printed letterhead logo in a tall header
			     region, named header-first so the running header stays off
			     page 1) -->
			<fo:simple-page-master master-name="page-first" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTopFirst}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="{$iala_first_header_region}" extent="{$marginTopFirst}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>

			<!-- Preface pages -->
			<fo:page-sequence-master master-name="preface">
				<fo:repeatable-page-master-alternatives>
					<xsl:if test="$iala_is_rescirc">
						<fo:conditional-page-master-reference page-position="first" master-reference="page-first"/>
					</xsl:if>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="page"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="page"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="preface-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="page-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="page-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<!-- Document pages -->
			<fo:page-sequence-master master-name="document">
				<fo:repeatable-page-master-alternatives>
					<xsl:if test="$iala_is_rescirc">
						<fo:conditional-page-master-reference page-position="first" master-reference="page-first"/>
					</xsl:if>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="page"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="page"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-portrait">
				<fo:repeatable-page-master-alternatives>
					<xsl:if test="$iala_is_rescirc">
						<fo:conditional-page-master-reference page-position="first" master-reference="page-first"/>
					</xsl:if>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="page"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="page"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="page-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="page-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<fo:page-sequence-master master-name="index">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="page"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="page"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template><!-- END layout-master-set -->

	<xsl:template name="cover-page">
		<xsl:param name="num"/>
		<!-- The information-paper leaflet cover: the published form is a
				plain title page - the doctype line, the subtitle, the title,
				the date, the IALA-AISM logo over the pre-2014 address block;
				no docidentifier, no URN and no banner block. -->
		<xsl:if test="$iala_is_information_paper">
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" initial-page-number="1" color="{$color_corporate_blue}">
			<fo:static-content flow-name="cover-page-header" id="__internal_layout__coverpage_image_{$num}_{generate-id()}" role="SKIP">
				<fo:block text-align="center" margin-left="0.5mm" margin-top="3mm" font-size="0pt">
					<fo:instream-foreign-object content-width="47mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
						<xsl:copy-of select="$IALA-Logo-full"/>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:static-content>
			<fo:static-content flow-name="cover-page-footer" role="SKIP">
				<fo:block-container font-size="9pt" margin-left="2.5mm" role="SKIP">
					<fo:block margin-top="4mm">20ter, rue Schnapper, 78100</fo:block>
					<fo:block>Saint Germain en Laye, France</fo:block>
					<fo:block>Telephone +33 1 34 51 70 01 Telefax +33 1 34 51 82 05</fo:block>
					<fo:block>E-mail - iala-aism@wanadoo.fr&#160;&#160;&#160;&#160;&#160;Internet -&#160;&#160;<fo:basic-link external-destination="http://iala-aism.org" fox:alt-text="http://iala-aism.org">http://iala-aism.org</fo:basic-link></fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body" color="black">
				<xsl:call-template name="insert_firstpage_id"><xsl:with-param name="num" select="$num"/></xsl:call-template>
				<fo:block text-align="center" font-size="17pt" font-weight="bold" margin-top="8mm" text-transform="uppercase" role="H1">
					<xsl:text>Information Paper</xsl:text>
				</fo:block>
				<xsl:variable name="subtitle" select="(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:cover-subtitle[1] | /mn:metanorma/mn:bibdata/mn:title[@type = 'subtitle'][normalize-space(@language) = '' or @language = 'en'][1])[1]"/>
				<xsl:if test="normalize-space($subtitle) != ''">
					<fo:block text-align="center" font-size="12pt" margin-top="6mm">
						<xsl:text>(</xsl:text><xsl:value-of select="normalize-space($subtitle)"/><xsl:text>)</xsl:text>
					</fo:block>
				</xsl:if>
				<fo:block text-align="center" font-size="18pt" font-weight="bold" margin-top="30mm" line-height="1.3" role="H2">
					<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'main' and (@language = 'en' or normalize-space(@language) = '')][1]/node()"/>
				</fo:block>
				<fo:block text-align="center" font-size="12pt" margin-top="14mm">
					<xsl:call-template name="convertDate">
						<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on"/>
					</xsl:call-template>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
		</xsl:if>

		<!-- resolutions and circular letters carry no cover page: the
		     letterhead rides the first document page (see the rescirc
		     header templates below) -->
		<xsl:if test="not($iala_is_rescirc) and not($iala_is_information_paper)">
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" initial-page-number="1" color="{$color_corporate_blue}">
			<!-- Logo -->
			<fo:static-content flow-name="cover-page-header" id="__internal_layout__coverpage_image_{$num}_{generate-id()}" role="SKIP">
				<fo:block text-align="center" margin-left="0.5mm" margin-top="3mm" font-size="0pt">
					<fo:instream-foreign-object content-width="47mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
						<xsl:copy-of select="$IALA-Logo-full"/>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:static-content>
			
			<fo:static-content flow-name="cover-page-footer" role="SKIP">
				<fo:block-container border-top="1pt solid {$color_corporate_blue}" font-size="0pt" margin-left="2.5mm" margin-right="-3.5mm" role="SKIP">
					<fo:block role="SKIP"><fo:wrapper role="artifact">&#xa0;</fo:wrapper></fo:block>
				</fo:block-container>
				<xsl:choose>
					<!-- Legacy brand (<= 2023): Saint Germain address block and the
						bilingual organization name of the former association -->
					<xsl:when test="($iala_is_standard or $iala_is_recommendation) and $iala_era_legacy">
						<fo:block text-align="center" font-size="6pt" role="SKIP">
							<fo:block margin-top="4mm">10, rue des Gaudines – 78100 Saint Germain en Laye, France</fo:block>
							<fo:block>Tél. +33 (0)1 34 51 70 01 – contact@iala-aism.org</fo:block>
							<fo:block font-weight="bold" color="{$color_corporate_blue}">www.iala-aism.org</fo:block>
							<fo:block color="{$color_corporate_blue}" margin-top="1.5mm">International Association of Marine Aids to Navigation and Lighthouse Authorities</fo:block>
							<fo:block color="{$color_corporate_blue}">Association Internationale de Signalisation Maritime</fo:block>
						</fo:block>
					</xsl:when>
					<!-- Transitional brand (2024-2025): legacy address block with the
						new organization name and iala.int -->
					<xsl:when test="($iala_is_standard or $iala_is_recommendation) and $iala_era_transitional">
						<fo:block text-align="center" font-size="6pt" role="SKIP">
							<fo:block margin-top="4mm">10, rue des Gaudines – 78100 Saint Germain en Laye, France</fo:block>
							<fo:block>Tél. +33 (0)1 34 51 70 01 – <fo:basic-link external-destination="mailto:contact@iala.int" fox:alt-text="contact@iala.int">contact@iala.int</fo:basic-link></fo:block>
							<fo:block font-weight="bold" color="{$color_corporate_blue}"><fo:basic-link external-destination="http://www.iala.int" fox:alt-text="www.iala.int">www.iala.int</fo:basic-link></fo:block>
							<fo:block color="{$color_corporate_blue}" margin-top="1.5mm">
								<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization/mn:name"/>
							</fo:block>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block text-align="center" font-size="10pt" role="SKIP">
							<fo:block margin-top="9mm" font-weight="bold">
								<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization/mn:name"/>
							</fo:block>
							<fo:block>
								<fo:basic-link external-destination="http://www.iala.int" fox:alt-text="www.iala.int">www.iala.int</fo:basic-link>
							</fo:block>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body">
				<xsl:call-template name="insert_firstpage_id"><xsl:with-param name="num" select="$num"/></xsl:call-template>
				
				<!-- yellow arc -->
				<fo:block font-size="0pt" margin-bottom="-0.8mm">
					<fo:instream-foreign-object content-width="197mm" content-height="2.5mm" scaling="non-uniform" fox:alt-text="Image Arc" fox:placement="Block">
						<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" viewBox="0 0 80 40" style="enable-background:new 0 0 80 40;">
							<path d="M0,40C0,17.9,17.9,0,40,0s40,17.9,40,40" fill="{$color_corporate_yellow}"/>
						</svg>
					</fo:instream-foreign-object>
				</fo:block>
				
				<!-- Example: GUIDELINE -->
				<fo:block-container height="52mm" color="white" display-align="center">
					<xsl:variable name="doctype"><xsl:call-template name="getVariable"><xsl:with-param name="variable">doctype</xsl:with-param></xsl:call-template></xsl:variable>
					<xsl:attribute name="background-color">
						<xsl:choose>
							<!-- Recommendations carry base doctype 'standard', so the
								light-blue branch keys on the IALA doctype, not the base one -->
							<xsl:when test="$iala_is_recommendation"><xsl:value-of select="$color_primary_recommendation_50"/></xsl:when>
							<xsl:when test="$iala_is_model_course"><xsl:value-of select="$color_primary_model_course"/></xsl:when>
							<xsl:when test="$iala_is_standard or $doctype = 'standard'"><xsl:value-of select="$color_corporate_blue"/></xsl:when>
							<!-- default, for doctype 'guideline' -->
							<xsl:otherwise><xsl:value-of select="$color_corporate_light_blue"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>


					<fo:block font-size="25pt" font-weight="bold" margin-left="17mm" margin-right="17mm" margin-top="4pt" text-transform="uppercase">
						<!-- Publications dated before 2026 read "IALA STANDARD" /
							"IALA GUIDELINE" / "IALA MODEL COURSE" on the banner -->
						<xsl:if test="$iala_iala_prefix">
							<xsl:text>IALA </xsl:text>
						</xsl:if>
						<xsl:call-template name="getVariable"><xsl:with-param name="variable">doctype_full</xsl:with-param></xsl:call-template>
					</fo:block>
					<!-- Published recommendations print the recital qualifier as the
							second banner line, in the case the document prints -->
					<xsl:if test="$iala_is_recommendation and $iala_normativity != ''">
						<fo:block font-size="25pt" font-weight="bold" margin-left="17mm" margin-right="17mm">
							<xsl:value-of select="$iala_normativity"/>
						</fo:block>
					</xsl:if>
				</fo:block-container>
				
				<fo:block-container height="10mm" role="SKIP"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xa0;</fo:wrapper></fo:block></fo:block-container>
				
				<fo:block-container margin-left="17mm">
					<fo:block-container margin-left="0mm">
						<fo:table table-layout="fixed" width="100%" role="SKIP">
							<fo:table-body role="SKIP">
								<fo:table-row role="SKIP" height="100mm">
									<fo:table-cell role="SKIP" font-size="25pt" text-transform="uppercase" line-height="1.07">
										<fo:block>
											<!-- Example: G1199 -->
											<xsl:call-template name="getVariable"><xsl:with-param name="variable">docidentifier</xsl:with-param></xsl:call-template>
										</fo:block>
										<!-- Example: VTS DIGITAL COMMUNICATIONS -->
										<xsl:variable name="title">
											<xsl:call-template name="getVariableCopyOf"><xsl:with-param name="variable">title</xsl:with-param></xsl:call-template>
										</xsl:variable>
										<xsl:for-each select="xalan:nodeset($title)/item">
											<fo:block>
												<xsl:copy-of select="node()"/>
											</fo:block>
										</xsl:for-each>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row role="SKIP" height="41mm" display-align="after">
									<fo:table-cell role="SKIP" font-weight="bold" padding-left="1mm">
										<fo:block font-size="25pt" line-height="1.08">
											<!-- Example: Edition 1.0 -->
											<xsl:call-template name="getVariable"><xsl:with-param name="variable">edition</xsl:with-param></xsl:call-template>
										</fo:block>
										<fo:block font-size="14pt">
											<xsl:call-template name="getVariable"><xsl:with-param name="variable">date</xsl:with-param></xsl:call-template>
										</fo:block>
										<fo:block font-size="14pt" margin-top="12pt" text-transform="lowercase">
											<xsl:call-template name="getVariable"><xsl:with-param name="variable">urn</xsl:with-param></xsl:call-template><!-- To do -->
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block-container>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
		</xsl:if>

		<xsl:if test="$iala_is_report">
			<!-- Published IALA reports carry a blank verso after the cover;
					the page still carries the running header and footer. -->
			<fo:page-sequence master-reference="page" force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block/>
				</fo:flow>
			</fo:page-sequence>
		</xsl:if>
	</xsl:template> <!-- END cover-page -->

	<xsl:template name="inner-cover-page">
		<!-- ============ THE GENERAL ASSEMBLY approval page ============ -->
		<!-- Legacy-era standards open with the General Assembly recitals,
			printed between the cover and the contents. When the source
			encodes the page as a real recitals clause it prints verbatim;
			the fallback renders the house boilerplate with only the APPROVES
			line document specific (docnumber + title from bibdata). The page
			carries no header or footer in the published PDF. -->
		<xsl:if test="$iala_is_standard and $iala_era_old">
			<fo:page-sequence master-reference="page" format="1" force-page-count="no-force">
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container margin-left="7mm" margin-right="4mm">
						<xsl:choose>
							<xsl:when test="/mn:metanorma/mn:preface/mn:clause[@type = 'recitals'] | /mn:metanorma/mn:sections/mn:clause[@type = 'recitals']">
								<fo:block font-size="15pt" color="{$color_corporate_blue}" margin-top="17mm" margin-bottom="12mm" text-transform="uppercase">
									<xsl:apply-templates select="(/mn:metanorma/mn:preface/mn:clause[@type = 'recitals'] | /mn:metanorma/mn:sections/mn:clause[@type = 'recitals'])[1]/mn:fmt-title" mode="iala_recitals_title"/>
								</fo:block>
								<fo:block font-size="10pt" line-height="1.4" text-align="justify">
									<xsl:for-each select="(/mn:metanorma/mn:preface/mn:clause[@type = 'recitals'] | /mn:metanorma/mn:sections/mn:clause[@type = 'recitals'])[1]/mn:p">
										<fo:block margin-bottom="2.5mm">
											<xsl:apply-templates select="."/>
										</fo:block>
									</xsl:for-each>
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
							<fo:block font-size="15pt" color="{$color_corporate_blue}" margin-top="17mm" margin-bottom="12mm">
								THE GENERAL ASSEMBLY
							</fo:block>
							<fo:block font-size="10pt" line-height="1.4" text-align="justify">
								<fo:block margin-bottom="2.5mm"><fo:inline font-weight="bold">BEARING IN MIND</fo:inline> the provisions of the United Nations Convention on the Law of the Sea (UNCLOS) and the International Convention for the Safety of Life at Sea (SOLAS),</fo:block>
								<fo:block margin-bottom="2.5mm"><fo:inline font-weight="bold">RECOGNIZING</fo:inline> that the aim of IALA is to foster the safe, economic and efficient movement of vessels, through improvement and harmonization of Marine Aids to Navigation world-wide,</fo:block>
								<fo:block margin-bottom="2.5mm"><fo:inline font-weight="bold">RECALLING</fo:inline> article 7 of the IALA Constitution regarding the authority, duties and functions of the General Assembly,</fo:block>
								<fo:block margin-bottom="2.5mm"><fo:inline font-weight="bold">RECALLING ALSO</fo:inline> that a goal of the work of IALA is that Marine Aids to Navigation are developed and harmonized through international cooperation and the provision of standards as described in the Strategic Vision,</fo:block>
								<fo:block margin-bottom="2.5mm"><fo:inline font-weight="bold">HAVING CONSIDERED</fo:inline> the advice of the Council provided to General Assembly at its 13th Session,</fo:block>
								<fo:block margin-bottom="2.5mm"><fo:inline font-weight="bold">APPROVES</fo:inline> the IALA Standard <xsl:value-of select="normalize-space(/mn:metanorma/mn:bibdata/mn:docnumber)"/>&#160;<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'main']/node()"/>, and</fo:block>
								<fo:block margin-bottom="2.5mm"><fo:inline font-weight="bold">INVITES</fo:inline> members and Marine Aids to Navigation authorities world-wide to undertake to implement the provisions of the Standard.</fo:block>
							</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block-container>
				</fo:flow>
			</fo:page-sequence>
		</xsl:if>

		<!-- ============ DOCUMENT REVISION page ============ -->
		<!-- Recommendations open with the DOCUMENT REVISION page (no contents
			page in the published PDF; the contents clause is dropped for them
			in update_xml_step1 below). When the source carries a real revision
			clause it renders from the sections flow (first clause, first page
			after the cover) through the revision-clause template below; this
			synthetic placeholder only fills the slot when no rows are
			encoded. -->
		<xsl:if test="$iala_is_recommendation and not(/mn:metanorma/mn:sections/mn:clause[@type = 'revision'] | /mn:metanorma/mn:preface/mn:clause[@type = 'revision'])">
			<fo:page-sequence master-reference="page" format="1" force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block xsl:use-attribute-sets="toc-title-style" margin-top="13mm" margin-bottom="4.5mm">
						<xsl:call-template name="refine_toc-title-style"/>
						<fo:block-container width="100%" border-bottom="1.25pt solid {$color_corporate_blue}" role="SKIP">
							<fo:block margin-bottom="2mm" role="SKIP">DOCUMENT REVISION</fo:block>
						</fo:block-container>
					</fo:block>
					<fo:block font-size="10pt" margin-bottom="5mm">
						<xsl:text>Revisions to this document are to be noted in the table prior to the issue of a revised document.</xsl:text>
						<xsl:if test="not($iala_era_old)">
							<xsl:text> The latest edition of the Recommendation is the only version in force unless the Recommendation is explicitly revoked by the Council.</xsl:text>
						</xsl:if>
					</fo:block>
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="18%"/>
						<fo:table-column column-width="58%"/>
						<fo:table-column column-width="24%"/>
						<fo:table-header>
							<fo:table-row>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" padding-top="1.5mm" padding-bottom="1.5mm" display-align="center">
									<fo:block font-size="10pt" font-weight="bold" color="{$color_corporate_blue}">Date</fo:block>
								</fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" padding-top="1.5mm" padding-bottom="1.5mm" display-align="center">
									<fo:block font-size="10pt" font-weight="bold" color="{$color_corporate_blue}">
										<xsl:choose>
											<xsl:when test="$iala_era_old">Details</xsl:when>
											<xsl:otherwise>Revision details</xsl:otherwise>
										</xsl:choose>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" padding-top="1.5mm" padding-bottom="1.5mm" display-align="center">
									<fo:block font-size="10pt" font-weight="bold" color="{$color_corporate_blue}">Approval</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-header>
						<fo:table-body>
							<!-- six empty rows at the house revision-table height -->
							<fo:table-row min-height="12mm">
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
							<fo:table-row min-height="12mm">
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
							<fo:table-row min-height="12mm">
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
							<fo:table-row min-height="12mm">
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
							<fo:table-row min-height="12mm">
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
							<fo:table-row min-height="12mm">
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:flow>
			</fo:page-sequence>
		</xsl:if>
	</xsl:template>

	<!-- (the list-item refinement lives with the rescirc list geometry
			below; it merges the published recital gap of the recommendations) -->

	<xsl:attribute-set name="page-sequence-preface"><?extend?>
		<xsl:attribute name="format">1</xsl:attribute>
		<xsl:attribute name="force-page-count">no-force</xsl:attribute>
	</xsl:attribute-set>

	<!-- ANNEX CONTENTS page (R1024): the published recommendation prints a
			contents page for its annex ahead of the annex itself. The source
			encodes the page as a typed clause; the entry list renders from the
			annex headings with dot leaders and live page references, in the
			case the printed entries carry (top-level clause titles upper
			case, sub-clause titles as typed). -->
	<xsl:template match="mn:clause[@type = 'annex-contents']" mode="contents"/>
	<xsl:template match="mn:clause[@type = 'annex-contents']" priority="3">
		<fo:block role="Sect" break-before="page">
			<xsl:apply-templates select="mn:fmt-title"/>
			<fo:block font-size="11pt" line-height="1.6" margin-top="8mm" margin-bottom="4mm">
				<xsl:apply-templates select="//mn:annex" mode="iala_annex_contents"/>
			</fo:block>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:clause[@type = 'annex-contents']/mn:fmt-title" priority="3">
		<!-- the printed annex contents title is 20pt, one step below the
			section-title style -->
		<fo:block xsl:use-attribute-sets="toc-title-style" font-size="20pt" margin-top="13mm" margin-bottom="8mm">
			<xsl:call-template name="refine_toc-title-style"/>
			<fo:block-container width="100%" border-bottom="1.25pt solid {$color_corporate_blue}" role="SKIP">
				<fo:block margin-bottom="2mm" role="SKIP">
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:annex" mode="iala_annex_contents">
		<xsl:apply-templates select="mn:clause" mode="iala_annex_contents"/>
	</xsl:template>
	<!-- Annex clause entry: the caption label as rewritten for print
			("1." / "2.1.") plus the clause title; depth-2 titles upper case,
			sub-clause titles as typed. -->
	<xsl:template match="mn:annex/mn:clause | mn:annex/mn:clause/mn:clause" mode="iala_annex_contents">
		<fo:block text-align-last="justify" margin-bottom="1.5mm">
			<xsl:choose>
				<xsl:when test="mn:fmt-title[@depth = '3']">
					<!-- sub-clause entries: 11pt regular, titles as typed -->
					<fo:inline font-size="11pt" color="{$color_corporate_blue}">
						<xsl:copy-of select="mn:fmt-title/mn:span[@class = 'fmt-caption-label']/node()"/>
						<xsl:text>&#160;</xsl:text>
						<xsl:copy-of select="mn:fmt-title/node()[not(self::mn:span[@class = 'fmt-caption-label'] or self::mn:span[@class = 'fmt-caption-delim'])]"/>
					</fo:inline>
				</xsl:when>
				<xsl:otherwise>
					<!-- top-level annex clause entries: 12pt bold, titles upper case -->
					<fo:inline font-size="12pt" font-weight="bold" color="{$color_corporate_blue}">
						<xsl:copy-of select="mn:fmt-title/mn:span[@class = 'fmt-caption-label']/node()"/>
						<xsl:text>&#160;&#160;</xsl:text>
						<fo:inline text-transform="uppercase">
							<xsl:copy-of select="mn:fmt-title/node()[not(self::mn:span[@class = 'fmt-caption-label'] or self::mn:span[@class = 'fmt-caption-delim'])]"/>
						</fo:inline>
					</fo:inline>
				</xsl:otherwise>
			</xsl:choose>
			<fo:leader leader-pattern="dots" font-size="11pt" color="{$color_corporate_blue}"/>
			<fo:page-number-citation ref-id="{@id}"/>
		</fo:block>
		<xsl:apply-templates select="mn:clause" mode="iala_annex_contents"/>
	</xsl:template>
	<!-- deeper annex nesting prints no contents entries -->
	<xsl:template match="mn:annex/mn:clause/mn:clause/mn:clause" mode="iala_annex_contents"/>
	<xsl:attribute-set name="page-sequence-main"><?extend?>
		<xsl:attribute name="force-page-count">no-force</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_page-sequence-main"><?extend?>
		<xsl:attribute name="initial-page-number">auto</xsl:attribute>
		<!-- Published standards end on an even page number: a short document
			history page is followed by a blank filler page carrying the
			running footer (see the trailing page of S1050/S1060) -->
		<xsl:if test="$iala_is_standard">
			<xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- DOCUMENT REVISION -->
	<xsl:template match="mn:clause[@type = 'revision']" mode="contents"/>
	<xsl:template match="mn:clause[@type = 'revision']" priority="3">
		<fo:block role="Sect" break-after="page">
			<xsl:choose>
				<xsl:when test="$iala_is_recommendation">
					<!-- Published recommendations print the revision page with
						the house table: the first encoded row sits under the
						header, the remaining rows pad to the house height. -->
					<xsl:apply-templates select="mn:fmt-title"/>
					<fo:block font-size="11pt" line-height="1.4" margin-bottom="5mm">
						<xsl:apply-templates select="mn:p[1]" mode="iala_revision_intro"/>
					</fo:block>
					<xsl:call-template name="iala_recommendation_revision_table"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:clause[@type = 'revision']/mn:p" mode="iala_revision_intro">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- The house revision table (18% / 58% / 24% columns, ruled cells,
			blue bold header): the source clause supplies the header labels
			and the first data row, exactly as printed; empty rows pad the
			table to the house height. -->
	<xsl:template name="iala_recommendation_revision_table">
		<fo:table table-layout="fixed" width="100%">
			<fo:table-column column-width="18%"/>
			<fo:table-column column-width="58%"/>
			<fo:table-column column-width="24%"/>
			<fo:table-header>
				<fo:table-row>
					<xsl:for-each select="mn:table/mn:thead/mn:tr[1]/*">
						<fo:table-cell border="0.5pt solid black" padding-left="2mm" padding-top="1.5mm" padding-bottom="1.5mm" display-align="center">
							<fo:block font-size="10pt" font-weight="bold" color="{$color_corporate_blue}"><xsl:value-of select="normalize-space(.)"/></fo:block>
						</fo:table-cell>
					</xsl:for-each>
				</fo:table-row>
			</fo:table-header>
			<fo:table-body>
				<fo:table-row min-height="12mm">
					<xsl:for-each select="mn:table/mn:tbody/mn:tr[1]/*">
						<fo:table-cell border="0.5pt solid black" padding-left="2mm" padding-top="1.5mm" display-align="center">
							<fo:block font-size="10pt"><xsl:value-of select="normalize-space(.)"/></fo:block>
						</fo:table-cell>
					</xsl:for-each>
				</fo:table-row>
				<fo:table-row min-height="12mm">
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
				</fo:table-row>
				<fo:table-row min-height="12mm">
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
				</fo:table-row>
				<fo:table-row min-height="12mm">
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
				</fo:table-row>
				<fo:table-row min-height="12mm">
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
				</fo:table-row>
				<fo:table-row min-height="12mm">
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
					<fo:table-cell border="0.5pt solid black" padding-left="2mm" display-align="center"><fo:block font-size="10pt">&#xa0;</fo:block></fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	<xsl:template match="mn:clause[@type = 'revision']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="toc-title-style"  margin-top="13mm" margin-bottom="4.5mm">
			<xsl:call-template name="refine_toc-title-style"/>
			<fo:block-container width="100%" border-bottom="1.25pt solid {$color_corporate_blue}" role="SKIP">
				<fo:block margin-bottom="2mm" role="SKIP">
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block>
	</xsl:template>
	
	<!-- The normativity qualifier and the running footer title print from
			their typed clauses on the cover and in the footer; the clauses
			themselves are suppressed from every flow and the contents. The
			update-stage rewrite leaves a whitespace-only paragraph so the
			preface page_sequence they sit in tests empty and is skipped
			outright - suppressing at render time alone would leave an empty
			fo:flow, which FOP rejects. -->
	<xsl:template match="mn:clause[@type = 'normativity'] | mn:clause[@type = 'running-title']" mode="update_xml_step1" priority="4">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<mn:p> </mn:p>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:clause[@type = 'normativity'] | mn:clause[@type = 'running-title']" mode="contents"/>
	<xsl:template match="mn:clause[@type = 'normativity'] | mn:clause[@type = 'running-title']" priority="3"/>

	<!-- THE GENERAL ASSEMBLY recitals page (legacy-era standards): when the
			source encodes it as a real recitals clause, the clause is printed
			on the furniture-less page after the cover (see inner-cover-page)
			and suppressed from every other flow, the contents included. -->
	<xsl:template match="mn:clause[@type = 'recitals']" mode="contents"/>
	<xsl:template match="mn:clause[@type = 'recitals']" priority="3"/>
	<xsl:template match="mn:clause[@type = 'recitals']/mn:fmt-title" mode="iala_recitals_title">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:attribute-set name="toc-title-style"><?extend?>
		<xsl:attribute name="font-size">28pt</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_toc_title"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">0</xsl:attribute>
		<xsl:attribute name="text-transform">uppercase</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="toc-style"><?extend?>
		<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
		<xsl:attribute name="margin-top">6mm</xsl:attribute>
		<!-- 
		<xsl:attribute name="border-right">1pt solid black</xsl:attribute> -->
	</xsl:attribute-set>

	<!-- the published leaflet contents join entry and page number with
			space, not dots -->
	<xsl:template name="refine_toc-leader-style"><?extend?>
		<xsl:if test="$iala_is_information_paper">
			<xsl:attribute name="leader-pattern">space</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="refine_toc-item-block-style">
		<!-- Text case: the leaflet prints its deeper contents levels in
				source case; guide-family contents print typed case with only
				the top level in capitals; manual and report ToCs keep the
				authored title case; every other doctype is all-capitals. -->
		<xsl:if test="not(($iala_is_information_paper and @level &gt; 1) or ($iala_guide_family and @level != 1) or $iala_is_report or $iala_is_manual)">
			<xsl:attribute name="text-transform">uppercase</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="line-height">
			<xsl:choose>
				<!-- the published model-course contents run at generous
						leading with a margin per entry, spreading over two pages -->
				<xsl:when test="$iala_is_model_course">1.9</xsl:when>
				<xsl:otherwise>1.4</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$iala_is_model_course">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="margin-right">8mm</xsl:attribute>
		<xsl:attribute name="provisional-distance-between-starts">
			<xsl:choose>
				<xsl:when test="@root = 'preface'">0mm</xsl:when>
				<xsl:when test="@root = 'annex'">0mm</xsl:when>
				<xsl:when test="@level = 1">7mm</xsl:when>
				<xsl:when test="@level = 2">12mm</xsl:when>
				<xsl:when test="@level = 3">13mm</xsl:when>
				<xsl:otherwise>15mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		
		<xsl:if test="@level = 1">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="@level &gt;= 3">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="@level &lt;= 2">
			<xsl:attribute name="margin-top">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="@level &gt;= 3">
			<xsl:attribute name="margin-top">2pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="@level &gt;= 3">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="refine_toc-item-style"><?extend?>
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="text-indent">0mm</xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_toc-listof-title-style"><?extend?>
		<xsl:attribute name="font-size">20pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="margin-top">9mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">6mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_toc_title"/></xsl:attribute>
		<!-- the manual's combined LIST OF TABLES AND FIGURES prints in the
				Contents tail at the heading size of the section lists; the
				report's page placement is handled by insertListsOf -->
		<xsl:if test="$iala_is_manual">
			<xsl:attribute name="font-size">14pt</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="refine_toc-listof-item-style"><?extend?>
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="text-indent">0mm</xsl:attribute>
		<xsl:attribute name="line-height">1.4</xsl:attribute>
		<xsl:attribute name="margin-right">8mm</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:template>
	
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']" name="toc" priority="4">
		<xsl:variable name="num" select="number(java:org.metanorma.fop.global.Variables.getVariable('num'))"/>
		<!-- Table of Contents -->
		<fo:block xsl:use-attribute-sets="toc-container-style">
			<xsl:call-template name="refine_toc-container-style"/>
			<xsl:call-template name="addTagElementT"/>
			
			<xsl:copy-of select="@id"/>
		
			<fo:table role="SKIP" table-layout="fixed" width="100%">
				<fo:table-column column-width="100%"/>
				<!-- repeat CONTENTS on each page -->
				<fo:table-header role="SKIP">
					<fo:table-row role="SKIP" height="33mm" display-align="after">
						<fo:table-cell role="SKIP" text-align="left">
							<fo:block role="SKIP">
								<xsl:apply-templates select="mn:fmt-title"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-header>
				<fo:table-body role="SKIP">
					<fo:table-row role="SKIP">
						<fo:table-cell role="SKIP" text-align="left">
							<xsl:apply-templates select="node()[not(self::mn:fmt-title)]"/>
							
							<xsl:if test="count(*) = 1 and mn:fmt-title"> <!-- if there isn't user ToC -->
			
								<fo:block role="SKIP" xsl:use-attribute-sets="toc-style">
								
									<fo:block role="TOC">
										<xsl:apply-templates select="$contents/mnx:doc[@num = $num]/mnx:contents/mnx:item[@display = 'true']">
											<xsl:with-param name="num" select="$num"/>
										</xsl:apply-templates>
									</fo:block>
									
									<xsl:call-template name="insertListsOf">
										<xsl:with-param name="num" select="$num"/>
									</xsl:call-template>
								</fo:block>
							</xsl:if>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOfTables">
		<xsl:param name="num"/>
		<!-- List of Tables -->
		<xsl:if test="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:tables/mnx:table[not(@root = 'annex')]">
			<xsl:call-template name="insertListOf_Title">
				<xsl:with-param name="title" select="$toc_title_lists/mnx:doc[@num = $num]/mnx:title-list-tables"/>
			</xsl:call-template>
			<fo:block role="TOC">
				<xsl:for-each select="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:tables/mnx:table[not(@root = 'annex')]">
					<xsl:call-template name="insertListOf_Item"/>
				</xsl:for-each>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertListOfFigures">
		<xsl:param name="num"/>
		<!-- List of Figures -->
		<xsl:if test="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:figures/mnx:figure[not(@root = 'annex')]">
			<xsl:call-template name="insertListOf_Title">
				<xsl:with-param name="title" select="$toc_title_lists/mnx:doc[@num = $num]/mnx:title-list-figures"/>
			</xsl:call-template>
			<fo:block role="TOC">
				<xsl:for-each select="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:figures/mnx:figure[not(@root = 'annex')]">
					<xsl:call-template name="insertListOf_Item"/>
				</xsl:for-each>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertListOfExamples">
		<xsl:param name="num"/>
		<!-- List of Examples -->
		<xsl:if test="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:examples/mnx:example[not(@root = 'annex')]">
			<xsl:call-template name="insertListOf_Title">
				<xsl:with-param name="title" select="$toc_title_lists/mnx:doc[@num = $num]/mnx:title-list-examples"/>
			</xsl:call-template>
			<fo:block role="TOC">
				<xsl:for-each select="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:examples/mnx:example[not(@root = 'annex')]">
					<xsl:call-template name="insertListOf_Item"/>
				</xsl:for-each>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="toc-title-style">
			<xsl:call-template name="refine_toc-title-style"/>
			<fo:block-container width="100%" border-bottom="1.25pt solid {$color_corporate_blue}" role="SKIP">
				<fo:block margin-bottom="2mm" role="SKIP">
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_title-style"><?extend?>
		<!-- the standards/guideline/resolution families print headings in
				caps; the published manuals and reports keep the authored
				title case ("Scope and Objectives", "Session 1 - Opening of
				the Workshop") -->
		<xsl:if test="not($iala_is_report) and not($iala_is_manual)">
			<xsl:attribute name="text-transform">uppercase</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
		<xsl:if test="$level = 1">
			<xsl:attribute name="font-size">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$level = 2 or $level = 3">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> To do --> 
			<xsl:attribute name="font-size">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$level = 4">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- the information-paper leaflet prints its definition entries as
			run-in lines: "TERM - definition", not as a two-column list -->
	<xsl:template match="mn:dl[$iala_is_information_paper]" priority="3">
		<fo:block>
			<xsl:for-each select="mn:dt">
				<fo:block margin-bottom="1.5mm">
					<xsl:apply-templates/>
					<xsl:text> - </xsl:text>
					<xsl:apply-templates select="following-sibling::mn:dd[1]/node()"/>
				</fo:block>
			</xsl:for-each>
		</fo:block>
	</xsl:template>

	<!-- the leaflet contents heading prints as "Table of Contents" -->
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title[$iala_is_information_paper]" priority="4">
		<fo:block xsl:use-attribute-sets="toc-title-style">
			<xsl:call-template name="refine_toc-title-style"/>
			<fo:block-container width="100%" role="SKIP">
				<fo:block role="SKIP">
					<xsl:attribute name="color">black</xsl:attribute>
					<xsl:attribute name="text-transform">none</xsl:attribute>
					<xsl:attribute name="font-size">13pt</xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:text>Table of Contents</xsl:text>
				</fo:block>
			</fo:block-container>
		</fo:block>
	</xsl:template>

	<!-- Tabulation processing -->
	<xsl:template match="mn:tab">
		<xsl:variable name="padding-right">8</xsl:variable>
		<xsl:choose>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%" role="SKIP">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline padding-right="{$padding-right}mm" role="SKIP"><xsl:value-of select="$zero_width_space"/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- tab -->

	<xsl:template match="mn:fmt-title[@depth = '3']/text()[1][following-sibling::*[1][self::mn:tab]][translate(substring(., 1, 1), '0123456789.', '') = '']">
		<fo:inline font-size="11pt"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- Published-PDF parity for clause numbering:                   -->
	<!--   standards print clause numbers with a trailing dot         -->
	<!--   ("1. INTRODUCTION") in headings and contents;              -->
	<!--   recommendations number only annex clauses (the Council      -->
	<!--   recital page heading prints unnumbered).                   -->
	<!-- ============================================================ -->
	<xsl:template match="mn:fmt-title[@depth = '1']/mn:span[@class = 'fmt-caption-label']" mode="update_xml_step1" priority="3">		<xsl:choose>
			<xsl:when test="$iala_is_recommendation and not(ancestor::mn:annex)"/>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
					<xsl:if test="$iala_is_standard">
						<xsl:text>.</xsl:text>
					</xsl:if>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Published recommendations number their annex clauses without the
			annex letter and with a trailing dot ("1.", "2.", "2.1."): the
			"A." prefix computed by Metanorma is dropped here. -->
	<xsl:template match="mn:fmt-title[@depth = '2' or @depth = '3']/mn:span[@class = 'fmt-caption-label'][$iala_is_recommendation][ancestor::mn:annex]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="node()[position() &gt; 2]"/>
			<xsl:text>.</xsl:text>
		</xsl:copy>
	</xsl:template>

	<!-- THE COUNCIL recital page: the published recommendations print the
			recitals indented off the left margin at 12pt under a 24pt
			heading (indent and body size are the printed deltas between
			the house eras; the lead-in words are bold in the source). -->
	<xsl:variable name="iala_council_clause" select="/mn:metanorma/mn:sections/mn:clause[mn:fmt-title[normalize-space(.) = 'The Council']][$iala_is_recommendation]"/>
	<xsl:variable name="iala_council_indent">
		<xsl:choose>
			<xsl:when test="number($iala_year) &gt;= 2026">0mm</xsl:when>
			<xsl:when test="number($iala_year) = 2024">17.6mm</xsl:when>
			<xsl:otherwise>10mm</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="mn:sections/mn:clause[mn:fmt-title[normalize-space(.) = 'The Council']][$iala_is_recommendation]" priority="3">
		<fo:block role="Sect">
			<fo:block font-size="24pt" font-weight="bold" color="{$color_toc_title}" text-transform="uppercase" margin-bottom="20pt" role="H1">
				<xsl:copy-of select="mn:fmt-title/node()[not(self::mn:span[@class = 'fmt-caption-label'] or self::mn:span[@class = 'fmt-caption-delim'])]"/>
			</fo:block>
			<fo:block font-size="12pt" margin-left="{$iala_council_indent}" margin-right="10mm">
				<xsl:apply-templates select="*[not(self::mn:fmt-title)]"/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- Council recital paragraphs and list items run at 12pt with the
			published line pitch (the base p style is tighter) -->
	<xsl:template match="mn:p[ancestor::mn:clause[mn:fmt-title[normalize-space(.) = 'The Council']][$iala_is_recommendation]]" priority="4">
		<fo:block line-height="1.275" text-align="justify" margin-bottom="5.5pt" role="P">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- Published standards carry no table captions (and therefore no -->
	<!-- List of Tables in the contents); recommendations keep them.   -->
	<!-- ============================================================ -->
	<!-- List of Tables/Figures in the contents: suppressed for standards -->
	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="not($iala_is_standard)">
			<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:toc[@type='table']/mn:title) or normalize-space($always) = 'true'">
				<xsl:call-template name="processTables_Contents"/>
			</xsl:if>
			<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:toc[@type='figure']/mn:title) or normalize-space($always) = 'true'">
				<xsl:call-template name="processFigures_Contents"/>
			</xsl:if>
			<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:toc[@type='example']/mn:title)">
				<xsl:call-template name="processExamples_Contents"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="figure-name-style"><?extend?>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_secondary_gray"/></xsl:attribute>
	</xsl:attribute-set>


	<!-- ============================================================ -->
	<!-- ============================================================ -->
	<!-- mode="update_xml_step1" -->
	<!-- ============================================================ -->
	<!-- ============================================================ -->
	<!-- change the order ToC and DOCUMENT REVISION -->
	<xsl:template match="mn:preface/mn:clause[@type = 'toc']" mode="update_xml_step1" priority="4">
		<xsl:choose>
			<xsl:when test="$iala_is_report">
				<!-- Published IALA reports open with the Executive summary,
						then the Contents; they carry no Document Revision page
						and a blank verso follows the cover. -->
				<xsl:apply-templates select="../mn:executivesummary" mode="update_xml_step1">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="../mn:clause[@type = 'revision'] or /mn:metanorma/mn:sections/mn:clause[@type = 'revision'][$iala_guide_family]">
				<!-- The printed DOCUMENT REVISION page carries the real
						revision rows; the source may encode them as a
						preface sibling of the Contents or as the first
						body clause (metanorma has no preface route for
						it) — either way it renders in this slot, ahead
						of the Contents. -->
				<xsl:apply-templates select="(../mn:clause[@type = 'revision'] | /mn:metanorma/mn:sections/mn:clause[@type = 'revision'][$iala_guide_family])[1]" mode="update_xml_step1">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$iala_is_manual">
				<!-- Published IALA manuals print a DOCUMENT HISTORY page
						before the contents; synthesise it from the bibdata
						edition when the source carries no revision clause. -->
				<xsl:variable name="synth_revision">
					<xsl:call-template name="make_document_history_clause"/>
				</xsl:variable>
				<xsl:apply-templates select="xalan:nodeset($synth_revision)/mn:clause" mode="update_xml_step1"/>
			</xsl:when>
			<xsl:when test="not($iala_is_rescirc) and not($iala_is_recommendation) and not($iala_is_standard) and not($iala_is_information_paper)">
				<!-- The guide family (guidelines, model courses) prints a
						DOCUMENT REVISION page before the contents; synthesise
						it when the source carries no revision clause (the
						table is padded to the house height by the
						document_revision mode below). Recommendations render
						their DOCUMENT REVISION page from inner-cover-page
						instead; the standards carry no revision page at all. -->
				<xsl:variable name="synth_revision">
					<xsl:call-template name="make_document_revision_clause"/>
				</xsl:variable>
				<xsl:apply-templates select="xalan:nodeset($synth_revision)/mn:clause" mode="update_xml_step1"/>
			</xsl:when>
		</xsl:choose>
		<!-- resolutions, circular letters and recommendations carry no
				Contents clause here (the recommendation DOCUMENT REVISION
				page takes its slot), so the contents clause is dropped
				rather than blanked at render time, to keep the preface
				page_sequence away. The standards keep their Contents. -->
		<xsl:if test="not($iala_is_rescirc) and not($iala_is_recommendation)">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- Reports: the Executive summary moves ahead of the Contents -->
	<xsl:template match="mn:preface/mn:executivesummary" mode="update_xml_step1" priority="4">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step1"/>
				<xsl:attribute name="displayorder">-1</xsl:attribute>
				<xsl:apply-templates select="node()" mode="update_xml_step1"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- Synthesised DOCUMENT HISTORY clause for manuals: the published
			manuals print the title above a Date / Details / Approval table. -->
	<xsl:template name="make_document_history_clause">
		<mn:clause type="revision" id="__iala_synth_document_revision" displayorder="-1">
			<mn:title>Document history</mn:title>
			<mn:fmt-title>Document history</mn:fmt-title>
			<mn:table id="__iala_synth_document_revision_table" unnumbered="true">
				<mn:thead>
					<mn:tr>
						<mn:td>Date</mn:td>
						<mn:td>Details</mn:td>
						<mn:td>Approval</mn:td>
					</mn:tr>
				</mn:thead>
				<mn:tbody>
					<mn:tr>
						<mn:td>
							<xsl:call-template name="convertDate">
								<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on"/>
							</xsl:call-template>
						</mn:td>
						<mn:td>
							<xsl:text>Edition </xsl:text>
							<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:edition[normalize-space(@language) != '' or not(@language)][1]"/>
						</mn:td>
						<mn:td>Council</mn:td>
					</mn:tr>
				</mn:tbody>
			</mn:table>
		</mn:clause>
	</xsl:template>

	<!-- Synthesised DOCUMENT REVISION clause: Date / Revision details / Approval
			with the current edition as the only populated row. -->
	<xsl:template name="make_document_revision_clause">
		<mn:clause type="revision" id="__iala_synth_document_revision" displayorder="-1">
			<mn:title>Document revision</mn:title>
			<mn:fmt-title>Document revision</mn:fmt-title>
			<mn:p>
				<xsl:choose>
					<xsl:when test="$iala_is_model_course">
						<xsl:text>Revisions to this IALA document are to be noted in the table prior to the issue of a revised document.</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Revisions to this document are to be noted in the table prior to the issue of a revised document. The latest edition of the Guideline is the only version in force unless the Guideline is explicitly revoked by the Council.</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</mn:p>
			<mn:table id="__iala_synth_document_revision_table" unnumbered="true">
				<mn:thead>
					<mn:tr>
						<mn:td>Date</mn:td>
						<mn:td>Revision details</mn:td>
						<mn:td>Approval</mn:td>
					</mn:tr>
				</mn:thead>
				<mn:tbody>
					<mn:tr>
						<mn:td>
							<xsl:call-template name="convertDate">
								<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on"/>
							</xsl:call-template>
						</mn:td>
						<mn:td>
							<xsl:text>Edition </xsl:text>
							<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:edition[normalize-space(@language) != '' or not(@language)][1]"/>
						</mn:td>
						<mn:td>Council</mn:td>
					</mn:tr>
				</mn:tbody>
			</mn:table>
		</mn:clause>
	</xsl:template>
	<xsl:template match="mn:preface/mn:clause[@type = 'revision'] | mn:sections/mn:clause[@type = 'revision'][$iala_guide_family]" mode="update_xml_step1" priority="4">
		<xsl:param name="process">false</xsl:param>
		<!-- without the process flag (the body flow pass) the clause is
				swallowed: it renders in the Contents slot instead -->
		<xsl:if test="$process = 'true'">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step1"/>
				<xsl:attribute name="displayorder">-1</xsl:attribute>

				<xsl:apply-templates select="node()" mode="update_xml_step1"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- Resolutions and circular letters carry no "Foreword" heading in
	     the published PDFs - and in the GA resolutions the resolution body
	     itself rides the generated foreword. Keep the content, drop the
	     heading. -->
	<!-- Resolutions and circular letters carry no "Foreword" heading in
	     the published PDFs. In the GA resolutions the resolution body
	     itself rides the generated foreword: the sections update below
	     hoists that content into the body flow, so the whole foreword is
	     dropped here. -->
	<xsl:template match="mn:preface/mn:foreword | mn:foreword" mode="update_xml_step1" priority="4">
		<xsl:if test="not($iala_is_rescirc)">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- the published resolutions and standards print no table caption
			(standards therefore carry no List of Tables either); the other
			doctypes keep the base caption handling (including the named
			destination attribute for caption links) -->
	<xsl:template match="mn:table/mn:fmt-name" mode="update_xml_step1" priority="5">
		<xsl:choose>
			<xsl:when test="$iala_is_rescirc or $iala_is_standard"><!-- no caption, as published --></xsl:when>
			<xsl:when test="$iala_guide_family and not(mn:semx[@element = 'name' or @element = 'title'])">
				<!-- auto-numbered table: no caption, as published -->
			</xsl:when>
			<xsl:when test="$iala_guide_family">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:call-template name="addNamedDestinationAttribute"/>
					<!-- flat caption number: position among the named tables -->
					<xsl:variable name="flat" select="count(preceding::mn:table[mn:fmt-name/mn:semx[@element = 'name' or @element = 'title']][not(ancestor::mn:metanorma-extension)]) + 1"/>
					<span class="fmt-caption-label">
						<span class="fmt-element-name">Table</span>
						<xsl:text> </xsl:text>
						<mn:semx element="autonum"><xsl:value-of select="$flat"/></mn:semx>
					</span>
					<xsl:apply-templates select="mn:span[@class = 'fmt-caption-delim']" mode="update_xml_step1"/>
					<xsl:apply-templates select="mn:semx[@element = 'name' or @element = 'title']" mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:call-template name="addNamedDestinationAttribute"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- the published resolutions and circular letters print no figure
	     caption either: the Secretary-General signature graphic rides the
	     letter bare, without the generated "Figure N" line -->
	<xsl:template match="mn:figure/mn:fmt-name" mode="update_xml_step1" priority="5">
		<xsl:choose>
			<xsl:when test="$iala_is_rescirc"><!-- no caption, as published --></xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- the letter signature block prints flush left, not centred -->
	<xsl:template name="refine_image-style">
		<xsl:if test="$iala_is_letter and parent::mn:figure">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="refine_figure-block-style">
		<xsl:if test="$iala_is_letter">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			<xsl:attribute name="margin-top">0pt</xsl:attribute>
			<!-- the signature graphic rides the closing block on the last page -->
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- rescirc annexes set the leading the published resolutions print:
	     the declaration spreads over the page like the reference PDF.
	     The base paragraph refinement is preserved for every other
	     paragraph (justification, keeps, spacing rules). -->
	<xsl:template name="refine_p-style">
		<xsl:param name="element-name"/>
		<xsl:param name="margin"/>
		<xsl:if test="$iala_guide_family and $iala_era_old and not(ancestor::mn:clause[@type = 'revision']) and not(ancestor::mn:table)">
			<!-- the published legacy guidelines and model courses run looser
				body paragraphs than the generated ones (table content stays
				tight, as printed) -->
			<xsl:attribute name="line-height">1.32</xsl:attribute>
		</xsl:if>
		<xsl:if test="$iala_is_model_course and not(ancestor::mn:clause[@type = 'revision']) and not(ancestor::mn:table)">
			<!-- the published model courses run looser body paragraphs still -->
			<xsl:attribute name="line-height">1.5</xsl:attribute>
		</xsl:if>
		<xsl:if test="$iala_is_rescirc and ancestor::mn:annex">
			<xsl:attribute name="line-height">150%</xsl:attribute>
			<xsl:attribute name="space-after">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$iala_guide_family and not(ancestor::mn:table) and not(ancestor::mn:figure)">
			<!-- the published guide family sets body text on the 1.4 leading
					with a 10pt paragraph step; the landscape competence
					tables keep their tuned compact leading -->
			<xsl:attribute name="line-height">140%</xsl:attribute>
			<xsl:attribute name="space-after">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="($iala_is_report or $iala_is_manual) and not(ancestor::mn:table) and not(ancestor::mn:boilerplate)">
			<!-- the published manual and report print Word single spacing
					for Calibri 11 (13.4pt pitch); the FOP default packs 6%
					tighter and the body drifts ahead of the published
					pagination -->
			<xsl:attribute name="line-height">122%</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="ancestor::mn:quote">justify</xsl:when>
				<xsl:when test="ancestor::mn:feedback-statement">right</xsl:when>
				<xsl:when test="ancestor::mn:boilerplate and not(@align)">justify</xsl:when>
				<xsl:when test="@align = 'justified'">justify</xsl:when>
				<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
				<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
				<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
				<xsl:otherwise>justify</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:call-template name="setKeepAttributes"/>

		<xsl:if test="parent::mn:dd">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="ancestor::*[2][self::mn:license-statement] and not(following-sibling::mn:p)">
			<xsl:attribute name="space-after">0pt</xsl:attribute>
		</xsl:if>

		<xsl:if test="ancestor::mn:boilerplate and not(ancestor::mn:feedback-statement)">
			<xsl:attribute name="line-height">125%</xsl:attribute>
			<xsl:attribute name="space-after">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:termnote or self::mn:example or self::mn:dl]">
			<xsl:attribute name="space-after">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="following-sibling::*[1][self::mn:dl]">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="ancestor::mn:quote">
			<xsl:attribute name="line-height">130%</xsl:attribute>
		</xsl:if>

		<xsl:if test="ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission] and    not(following-sibling::*)">
			<xsl:attribute name="space-after">0pt</xsl:attribute>
		</xsl:if>

		<xsl:if test="ancestor::mn:li and ancestor::mn:table">
			<xsl:attribute name="space-after">0pt</xsl:attribute>
		</xsl:if>

		<xsl:if test=".//mn:fn">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>

		<!-- Resolutions and circular letters carry the printed paragraph
		     rhythm. Set after the base rules so the printed gaps survive
		     the generic pre-list tightening. -->
		<!-- legacy assembly resolutions (A12 era): the recital flow prints
		     at 122% leading with a full blank line between paragraphs; the
		     operative list items print looser, set solid inside the item -->
		<xsl:if test="$iala_rescirc_legacy">
			<xsl:choose>
				<xsl:when test="ancestor::mn:li">
					<xsl:attribute name="line-height">155%</xsl:attribute>
					<xsl:attribute name="space-after">0pt</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="line-height">122%</xsl:attribute>
					<xsl:attribute name="space-after">13.4pt</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!-- circular letters: the correspondence flow prints at 140% leading;
		     the bullet lists print set solid at 128%; the correspondence head
		     carries the printed extra spacing after the Subject line, after
		     the To line, and after the salutation (the base rules keep the
		     body paragraph gap) -->
		<xsl:if test="$iala_is_letter">
			<xsl:choose>
				<xsl:when test="ancestor::mn:li">
					<xsl:attribute name="line-height">128%</xsl:attribute>
					<xsl:attribute name="space-after">0pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="not(ancestor::mn:td)">
					<xsl:attribute name="line-height">140%</xsl:attribute>
					<xsl:variable name="letter_p" select="normalize-space()"/>
					<!-- the correspondence body prints the paragraph gap a shade
					     looser than the base default (pre-list paragraphs keep
					     the base tightening) -->
					<xsl:if test="not(following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:termnote or self::mn:example or self::mn:dl])">
						<xsl:attribute name="space-after">7.5pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="starts-with($letter_p, 'Subject:')">
						<xsl:attribute name="space-after">11.5pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="starts-with($letter_p, 'To:')">
						<xsl:attribute name="space-after">24.9pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="starts-with($letter_p, 'Dear ')">
						<xsl:attribute name="space-after">10.6pt</xsl:attribute>
					</xsl:if>
					<!-- the printed page break falls inside the final membership
					     list, with the closing paragraph and the signature block
					     opening the last page: keep the letter tail bound so the
					     printed break reproduces wherever the list splits -->
					<xsl:if test="following-sibling::*[1][self::mn:figure]">
						<xsl:attribute name="keep-with-previous">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="following-sibling::mn:p[1][starts-with(normalize-space(), 'Yours sincerely')]">
						<xsl:attribute name="keep-with-previous">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="preceding-sibling::mn:figure">
						<xsl:attribute name="keep-with-previous">always</xsl:attribute>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<!-- A1x bilingual resolutions (A13): the table text prints at 120%
		     leading; the constitution-title cell drops its second line to
		     the printed 12pt, and the resolution body cells keep the
		     printed paragraph gap -->
		<xsl:if test="$iala_rescirc_a1x and ancestor::mn:td">
			<xsl:attribute name="line-height">120%</xsl:attribute>
			<xsl:variable name="a13_row" select="count(ancestor::mn:td[1]/parent::mn:tr[1]/preceding-sibling::mn:tr) + 1 + count(ancestor::mn:tbody[1]/preceding-sibling::mn:thead[1]/mn:tr)"/>
			<xsl:choose>
				<xsl:when test="$a13_row = 3 and count(preceding-sibling::mn:p) = 1">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
					<xsl:attribute name="space-after">0pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="$a13_row = 5">
					<xsl:attribute name="space-after">6pt</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="space-after">0pt</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<xsl:copy-of select="@id"/>
	</xsl:template>

	<!-- rescirc: hoist the foreword content into sections. These documents
	     have no bibliography, so a plain copy of the section children plus
	     the hoisted foreword content matches the base update for them. -->
	<xsl:template match="mn:sections[$iala_is_rescirc]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
			<xsl:apply-templates select="/mn:metanorma/mn:preface/mn:foreword/node()[not(self::mn:title or self::mn:fmt-title)] | /mn:metanorma/mn:preface/mn:foreword/mn:title/node() | /mn:metanorma/mn:preface/mn:foreword/mn:fmt-title/node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:clause[@type = 'revision']/mn:table[@unnumbered = 'true']" mode="update_xml_step1" priority="3">
		<xsl:apply-templates select="." mode="document_revision"/>
	</xsl:template>
	
	<!-- ============================================================ -->
	<!-- ============================================================ -->
	<!-- pre-processing for DOCUMENT REVISION table -->
	<!-- ============================================================ -->
	<!-- ============================================================ -->
	<xsl:template match="@*|node()" mode="document_revision">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="document_revision"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:table" mode="document_revision">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="ancestor::mn:clause[@type = 'revision']/@type"/>
			<xsl:if test="not(mn:colgroup) and count(mn:tbody/mn:tr/*) = 3">
				<mn:colgroup>
					<mn:col width="18%"/>
					<mn:col width="58%"/>
					<mn:col width="24%"/>
				</mn:colgroup>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="document_revision"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- The published revision table height: guidelines pad to seven body
			rows (one data row over six spare rows), the model courses to six
			(two data rows over four spare rows). -->
	<xsl:variable name="iala_rev_pad_target" select="6 + number(not($iala_is_model_course))"/>

	<xsl:template match="mn:tbody[count(mn:tr) &lt; number($iala_rev_pad_target)]" mode="document_revision">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()" mode="document_revision"/>
			<xsl:variable name="tr_count" select="count(mn:tr)"/>
			<xsl:variable name="td_count" select="count(mn:tr[last()]/*)"/>
			<xsl:call-template name="addDocumentRevisionTableRow">
				<xsl:with-param name="tr_count" select="number($iala_rev_pad_target) - $tr_count"/>
				<xsl:with-param name="td_count" select="$td_count"/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="addDocumentRevisionTableRow">
		<xsl:param name="tr_count"/>
		<xsl:param name="td_count"/>
		<xsl:if test="$tr_count &gt; 0">
			<mn:tr>
				<xsl:call-template name="addDocumentRevisionTableCell">
					<xsl:with-param name="td_count" select="$td_count"/>
				</xsl:call-template>
			</mn:tr>
			<xsl:call-template name="addDocumentRevisionTableRow">
				<xsl:with-param name="tr_count" select="$tr_count - 1"/>
				<xsl:with-param name="td_count" select="$td_count"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="addDocumentRevisionTableCell">
		<xsl:param name="td_count"/>
		<xsl:if test="$td_count &gt; 0">
			<mn:td></mn:td>
			<xsl:call-template name="addDocumentRevisionTableCell">
				<xsl:with-param name="td_count" select="$td_count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:tbody//mn:td" mode="document_revision">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="valign">middle</xsl:attribute>
			<xsl:apply-templates select="node()" mode="document_revision"/>
		</xsl:copy>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- Published numbering model                                    -->
	<!-- ============================================================ -->
	<!-- The published IALA documents number the Introduction as clause 1
			and print the bibliography collected at the end as "References"
			(and "Further reading"), numbered after the last body clause.
			The reports, manuals and rescirc doctypes were tuned without
			this model; it applies to the standards family only. -->

	<!-- Introduction: receives number 1 -->
	<xsl:template match="mn:introduction/mn:fmt-title[not(mn:span[@class = 'fmt-caption-label'])][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:span class="fmt-caption-label"><mn:semx element="autonum">1</mn:semx></mn:span>
			<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- Normative references: move to the end of the document, retitle
			"References", number after the last body clause. The published
			"Further reading" section comes through the converter marked
			normative like its References sibling, so it is told apart by
			title, not by the normative flag. -->
	<xsl:template match="mn:sections/mn:references[@normative = 'true'][mn:title != 'Further reading'][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:variable name="num" select="count(../*[not(self::mn:references or self::mn:clause[@type = 'revision' or mn:title = 'Appended publications'])]) + 2 - (count(../mn:introduction | ../mn:clause[mn:title = 'Introduction']) &gt; 0)"/>
		<!-- wrap as a clause so the heading renders through the normal
				clause path exactly once -->
		<mn:clause id="{@id}">
			<xsl:attribute name="displayorder">998</xsl:attribute>
			<mn:title>References</mn:title>
			<mn:fmt-title depth="1">
				<mn:span class="fmt-caption-label"><mn:semx element="autonum"><xsl:value-of select="$num"/></mn:semx></mn:span>
				<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
				<mn:semx element="title">References</mn:semx>
			</mn:fmt-title>
			<mn:fmt-xref-label><mn:span class="fmt-element-name">Clause</mn:span><xsl:text> </xsl:text><mn:semx element="autonum"><xsl:value-of select="$num"/></mn:semx></mn:fmt-xref-label>
			<!-- the published references print the heading straight into the
					citations; the standard normative-preamble paragraph is
					not carried over -->
			<xsl:apply-templates select="node()[not(self::mn:title or self::mn:fmt-title or self::mn:fmt-xref-label or self::mn:p)]" mode="update_xml_step1"/>
		</mn:clause>
	</xsl:template>

	<!-- Further reading: follows References, numbered after it -->
	<xsl:template match="mn:sections/mn:references[mn:title = 'Further reading' or not(@normative = 'true')][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:variable name="num" select="count(../*[not(self::mn:references or self::mn:clause[@type = 'revision'])]) + 3 - (count(../mn:introduction | ../mn:clause[mn:title = 'Introduction']) &gt; 0)"/>
		<mn:clause id="{@id}">
			<xsl:attribute name="displayorder">999</xsl:attribute>
			<mn:title>Further reading</mn:title>
			<mn:fmt-title depth="1">
				<mn:span class="fmt-caption-label"><mn:semx element="autonum"><xsl:value-of select="$num"/></mn:semx></mn:span>
				<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
				<mn:semx element="title">Further reading</mn:semx>
			</mn:fmt-title>
			<mn:fmt-xref-label><mn:span class="fmt-element-name">Clause</mn:span><xsl:text> </xsl:text><mn:semx element="autonum"><xsl:value-of select="$num"/></mn:semx></mn:fmt-xref-label>
			<xsl:apply-templates select="node()[not(self::mn:title or self::mn:fmt-title or self::mn:fmt-xref-label or self::mn:p)]" mode="update_xml_step1"/>
		</mn:clause>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<mnx:tables>
			<xsl:for-each select="//mn:table[not(ancestor::mn:metanorma-extension)][@id and mn:fmt-name and normalize-space(@id) != ''][not($iala_guide_family) or mn:fmt-name/mn:semx[@element = 'name' or @element = 'title']]">
				<xsl:variable name="root">
					<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
					<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
				</xsl:variable>
				<xsl:variable name="fmt_name">
					<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
				</xsl:variable>
				<xsl:variable name="alt_text_">
					<xsl:apply-templates select="xalan:nodeset($fmt_name)/node()" mode="bookmarks"/>
				</xsl:variable>
				<xsl:variable name="alt_text" select="normalize-space(translate(normalize-space($alt_text_), concat($nbsp,$zero_width_space,$hair_space), ' '))"/>
				<mnx:table id="{@id}" alt-text="{$alt_text}" root="{$root}">
					<xsl:copy-of select="$fmt_name"/>
				</mnx:table>
			</xsl:for-each>
		</mnx:tables>
	</xsl:template>

	<xsl:template name="processFigures_Contents">
		<mnx:figures>
			<xsl:for-each select="(//mn:figure[@id and mn:fmt-name and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(mn:name, 'Figure ') and normalize-space(@id) != ''])[not($iala_guide_family) or mn:fmt-name/mn:semx[@element = 'name' or @element = 'title']]">
				<xsl:variable name="root">
					<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
					<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
				</xsl:variable>
				<xsl:variable name="fmt_name">
					<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
				</xsl:variable>
				<xsl:variable name="alt_text_">
					<xsl:apply-templates select="xalan:nodeset($fmt_name)/node()" mode="bookmarks"/>
				</xsl:variable>
				<xsl:variable name="alt_text" select="normalize-space(translate(normalize-space($alt_text_), concat($nbsp,$zero_width_space,$hair_space), ' '))"/>
				<mnx:figure id="{@id}" alt-text="{$alt_text}" root="{$root}">
					<xsl:copy-of select="$fmt_name"/>
				</mnx:figure>
			</xsl:for-each>
		</mnx:figures>
	</xsl:template>


	<!-- ============================================================ -->
	<!-- GUIDE FAMILY round 2: published flow and numbering           -->
	<!-- ============================================================ -->

	<!-- The published guidelines flow the Introduction (clause 1) straight
			into the clause that follows it on the same page; metanorma parks
			the introduction in the preface, whose page sequence forces a
			page break after it. Relocate it to the head of sections so the
			main flow renders it as the first body clause. -->
	<xsl:template match="mn:preface/mn:introduction[$iala_guide_family][/mn:metanorma/mn:sections]" mode="update_xml_step1" priority="3"/>

	<xsl:template match="mn:sections[$iala_guide_family][/mn:metanorma/mn:preface/mn:introduction]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

			<!-- the preface Introduction joins the body (its displayorder
					seats it ahead of the first body clause); normative
					references move inside 'sections' as in the base -->
			<xsl:for-each select="/mn:metanorma/mn:preface/mn:introduction | * | ancestor::mn:metanorma/mn:bibliography/mn:references[@normative='true'] | ancestor::mn:metanorma/mn:bibliography/mn:clause[mn:references[@normative='true']]">
				<xsl:sort select="@displayorder" data-type="number"/>

				<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<!-- The introduction subclauses carry the printed 1.x / 1.x.y numbers;
			metanorma numbers only the body clauses, so synthesize the chain
			here from the position inside the introduction -->
	<xsl:template match="mn:introduction/mn:clause/mn:fmt-title[not(mn:span[@class = 'fmt-caption-label'])][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:span class="fmt-caption-label">
				<xsl:call-template name="iala_intro_clause_number">
					<xsl:with-param name="clause" select=".."/>
				</xsl:call-template>
			</mn:span>
			<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="iala_intro_clause_number">
		<xsl:param name="clause"/>
		<!-- the introduction itself is clause 1 -->
		<xsl:text>1.</xsl:text>
		<xsl:variable name="chain" select="$clause/ancestor-or-self::mn:clause[parent::mn:introduction or parent::mn:clause[ancestor::mn:introduction]]"/>
		<xsl:variable name="chain_nums_">
			<xsl:for-each select="$chain">
				<xsl:sort select="count(ancestor::mn:clause[ancestor::mn:introduction])" data-type="number" order="ascending"/>
				<n v="{count(preceding-sibling::mn:clause) + 1}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($chain_nums_)/*">
			<xsl:if test="position() &gt; 1"><xsl:text>.</xsl:text></xsl:if>
			<xsl:value-of select="@v"/>
		</xsl:for-each>
	</xsl:template>

	<!-- The published guide family numbers tables and figures sequentially
			across the whole document ("Table 1"), not per clause -->
	<xsl:template match="mn:table/mn:fmt-name[$iala_guide_family][not(../@unnumbered = 'true')]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:span class="fmt-caption-label">
				<mn:span class="fmt-element-name"><xsl:text>Table </xsl:text></mn:span>
				<mn:semx element="autonum"><xsl:value-of select="count(../preceding::mn:table[not(@unnumbered = 'true')][mn:fmt-name]) + 1"/></mn:semx>
			</mn:span>
			<mn:span class="fmt-caption-delim"><xsl:text> </xsl:text></mn:span>
			<xsl:apply-templates select="node()[not(self::mn:span[@class = 'fmt-caption-label' or @class = 'fmt-caption-delim'])]" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:figure/mn:fmt-name[$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:span class="fmt-caption-label">
				<mn:span class="fmt-element-name"><xsl:text>Figure </xsl:text></mn:span>
				<mn:semx element="autonum"><xsl:value-of select="count(../preceding::mn:figure[mn:fmt-name]) + 1"/></mn:semx>
			</mn:span>
			<mn:span class="fmt-caption-delim"><xsl:text> </xsl:text></mn:span>
			<xsl:apply-templates select="node()[not(self::mn:span[@class = 'fmt-caption-label' or @class = 'fmt-caption-delim'])]" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- The published guide family titles its standalone definitions
			section "Definitions"; the converter renames it to the i18n
			"Terms and definitions" -->
	<xsl:template match="mn:sections/mn:terms/mn:title[. = 'Terms and definitions'][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:copy>Definitions</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:sections/mn:terms/mn:fmt-title[mn:title = 'Terms and definitions' or normalize-space() = 'Terms and definitions'][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:apply-templates select="node()[not(self::mn:semx[@element = 'title'])][not(self::text()[normalize-space() = 'Terms and definitions'])]" mode="update_xml_step1"/>
			<mn:semx element="title">Definitions</mn:semx>
		</xsl:copy>
	</xsl:template>

	<!-- G1200 prints "Further reading"; the source clause carries an inert
			title because the converter strips trailing informative sections
			by their printed title. It numbers after References and rides
			the very end of the body flow. -->
	<xsl:template match="mn:sections/mn:clause[mn:title = 'Appended publications'][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:attribute name="displayorder">1000</xsl:attribute>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:sections/mn:clause[mn:title = 'Appended publications'][$iala_guide_family]/mn:title" mode="update_xml_step1" priority="3">
		<xsl:copy>Further reading</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:sections/mn:clause[mn:title = 'Appended publications'][$iala_guide_family]/mn:fmt-title" mode="update_xml_step1" priority="4">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:apply-templates select="node()[not(self::mn:semx[@element = 'title'])][not(self::text()[normalize-space() = 'Appended publications'])]" mode="update_xml_step1"/>
			<mn:semx element="title">Further reading</mn:semx>
		</xsl:copy>
	</xsl:template>

	<!-- The presentation step numbers the body clauses against its own
			canonical model (normative references first); the published
			guide family numbers the Introduction 1 and the body clauses
			after it. Renumber the baked caption labels to the published
			model; deeper captions keep their tail under the new prefix. -->
	<xsl:template match="mn:sections/*[not(self::mn:clause[@type = 'revision'] or self::mn:references)]/mn:fmt-title/mn:span[@class = 'fmt-caption-label'][$iala_guide_family]" mode="update_xml_step1" priority="4">
		<xsl:variable name="el" select="parent::mn:fmt-title/parent::*"/>
		<xsl:variable name="n">
			<xsl:choose>
				<xsl:when test="$el[mn:title = 'Appended publications']">
					<!-- Further reading numbers after References -->
					<xsl:value-of select="1 + count($el/preceding-sibling::*[not(self::mn:references or self::mn:clause[@type = 'revision' or mn:title = 'Appended publications'])][number(@displayorder) &lt; number($el/@displayorder)]) + count(/mn:metanorma/mn:preface/mn:introduction) + 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="1 + count($el/preceding-sibling::*[not(self::mn:references or self::mn:clause[@type = 'revision' or mn:title = 'Appended publications'])][number(@displayorder) &lt; number($el/@displayorder)]) + count(/mn:metanorma/mn:preface/mn:introduction)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:semx element="autonum"><xsl:value-of select="$n"/></mn:semx>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sections/*[not(self::mn:clause[@type = 'revision'] or self::mn:references)]/mn:clause//mn:span[@class = 'fmt-caption-label'][$iala_guide_family]" mode="update_xml_step1" priority="3">
		<xsl:variable name="top_parent" select="(ancestor::*[parent::mn:sections])[1]"/>
		<xsl:variable name="n" select="1 + count($top_parent/preceding-sibling::*[not(self::mn:references or self::mn:clause[@type = 'revision'])][number(@displayorder) &lt; number($top_parent/@displayorder)]) + count(/mn:metanorma/mn:preface/mn:introduction)"/>
		<xsl:variable name="old" select="normalize-space(.)"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:semx element="autonum">
				<xsl:value-of select="$n"/>
				<xsl:if test="contains($old, '.')"><xsl:value-of select="concat('.', substring-after($old, '.'))"/></xsl:if>
			</mn:semx>
		</xsl:copy>
	</xsl:template>

	<!-- the revision clause renders unnumbered -->
	<xsl:template match="mn:clause[@type = 'revision']/mn:fmt-title" mode="update_xml_step1" priority="5">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:apply-templates select="node()[not(self::mn:span[@class = 'fmt-caption-label' or @class = 'fmt-autonum-delim' or @class = 'fmt-caption-delim'])]" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- The published contents never list deeper than three levels. -->
	<xsl:variable name="toc_level">
		<xsl:variable name="pdftoclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata/mn:pdf-toc-heading-levels)"/>
		<xsl:variable name="toclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata/mn:toc-heading-levels)"/>
		<xsl:variable name="lvl">
			<xsl:choose>
				<xsl:when test="$pdftoclevels != ''"><xsl:value-of select="number($pdftoclevels)"/></xsl:when>
				<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>
				<xsl:otherwise>2</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number($lvl) &gt; 3">3</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lvl"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- The published guide-family contents list References and Further
			reading last (after the numbered body clauses); the source tree
			seats them first, so the guide family sorts them behind. -->
	<xsl:template name="processMainSectionsDefault_Contents">
		<xsl:variable name="nodes_sections_">
			<xsl:for-each select="/*/mn:sections/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true'] |    /*/mn:bibliography/mn:clause[mn:references[@normative='true']]">
			<xsl:sort select="($iala_guide_family and (self::mn:references or mn:title = 'Appended publications'))" data-type="number"/>
			<xsl:sort select="($iala_guide_family and mn:title = 'Appended publications')" data-type="number"/>
			<xsl:sort select="@displayorder" data-type="number"/>

			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>

		<xsl:for-each select="/*/mn:annex | /*/mn:bibliography/*[not(@normative='true') and not(mn:references[@normative='true'])][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0] |          /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- getSection / getName overrides                               -->
	<!-- ============================================================ -->
	<!-- The contents listings are collected from the source tree, so
			the relocations done in update_xml_step1 do not reach them;
			teach the label resolution about the published numbering model. -->
	<xsl:template name="getSection">
		<xsl:choose>
			<xsl:when test="$iala_guide_family and self::mn:introduction">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:when test="$iala_guide_family and parent::mn:sections and mn:title = 'Appended publications'">
				<xsl:value-of select="2 + count(preceding-sibling::*[not(self::mn:references or self::mn:clause[@type = 'revision' or mn:title = 'Appended publications'])][number(@displayorder) &lt; number(current()/@displayorder)]) + count(/mn:metanorma/mn:preface/mn:introduction)"/>
			</xsl:when>
			<xsl:when test="$iala_guide_family and parent::mn:sections and not(self::mn:references or self::mn:clause[@type = 'revision'])">
				<xsl:value-of select="1 + count(preceding-sibling::*[not(self::mn:references or self::mn:clause[@type = 'revision' or mn:title = 'Appended publications'])][number(@displayorder) &lt; number(current()/@displayorder)]) + count(/mn:metanorma/mn:preface/mn:introduction)"/>
			</xsl:when>
			<xsl:when test="$iala_guide_family and ancestor::mn:sections and not(parent::mn:sections) and (self::mn:clause or self::mn:terms or self::mn:definitions)">
				<!-- deeper clauses: the published number is the parent's new
						number plus the baked tail -->
				<xsl:variable name="top" select="(ancestor::*[parent::mn:sections])[1]"/>
				<xsl:variable name="pn" select="1 + count($top/preceding-sibling::*[not(self::mn:references or self::mn:clause[@type = 'revision' or mn:title = 'Appended publications'])][number(@displayorder) &lt; number($top/@displayorder)]) + count(/mn:metanorma/mn:preface/mn:introduction)"/>
				<xsl:variable name="old" select="normalize-space(mn:fmt-title//mn:span[@class = 'fmt-caption-label'])"/>
				<xsl:value-of select="$pn"/>
				<xsl:if test="contains($old, '.')"><xsl:value-of select="concat('.', substring-after($old, '.'))"/></xsl:if>
			</xsl:when>
			<xsl:when test="$iala_guide_family and self::mn:references[mn:title = 'Further reading']">
				<xsl:value-of select="count(parent::mn:sections/*[not(self::mn:references or self::mn:clause[@type = 'revision'])]) + 3 - count(parent::mn:sections/mn:introduction | parent::mn:sections/mn:clause[mn:title = 'Introduction'])"/>
			</xsl:when>
			<xsl:when test="$iala_guide_family and self::mn:references[not(mn:title = 'Further reading')]">
				<xsl:value-of select="count(parent::mn:sections/*[not(self::mn:references or self::mn:clause[@type = 'revision' or mn:title = 'Appended publications'])]) + 2 - count(parent::mn:sections/mn:introduction | parent::mn:sections/mn:clause[mn:title = 'Introduction'])"/>
			</xsl:when>
			<xsl:when test="$iala_is_model_course and self::mn:clause[starts-with(normalize-space(mn:title), 'Part')]">
				<!-- the published model courses print their part dividers unnumbered -->
			</xsl:when>
			<xsl:when test="$iala_is_model_course and self::mn:clause[ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part')]]">
				<!-- descendants of a part divider drop the part segment of
						their number: "2.1" under PART 2 prints as "1" -->
				<xsl:variable name="label">
					<xsl:value-of select="normalize-space(mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/preceding-sibling::node()[not(self::mn:annotation)])"/>
				</xsl:variable>
				<xsl:value-of select="substring-after($label, '.')"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title">
				<xsl:variable name="fmt_title_section">
					<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/preceding-sibling::node()[not(self::mn:annotation)]"/>
				</xsl:variable>
				<xsl:value-of select="normalize-space($fmt_title_section)"/>
				<xsl:if test="normalize-space($fmt_title_section) = ''">
					<xsl:value-of select="mn:fmt-title/mn:tab[1]/preceding-sibling::node()"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="mn:title/mn:tab[1]/preceding-sibling::node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="$iala_is_model_course and self::mn:clause[mn:title][starts-with(normalize-space(mn:title), 'Part ')][parent::mn:sections]">
				<!-- the PART banner: the contents print the capitalised
						remainder (the PART letter is the number column) -->
				<xsl:variable name="t" select="normalize-space(mn:title)"/>
				<xsl:choose>
					<xsl:when test="contains($t, '&#8211;')"><xsl:value-of select="translate(normalize-space(substring-after($t, '&#8211;')), $iala_lower, $iala_upper)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="translate(normalize-space(substring-after($t, '- ')), $iala_lower, $iala_upper)"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$iala_is_model_course and self::mn:clause[mn:title][starts-with(normalize-space(mn:title), 'Module ')][parent::mn:clause[parent::mn:sections]]">
				<!-- the module row: the printed title, in capitals -->
				<xsl:choose>
					<xsl:when test="$iala_mc_module_banner"><xsl:value-of select="translate(normalize-space(substring-after(mn:title, ':')), $iala_lower, $iala_upper)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="translate(normalize-space(mn:title), $iala_lower, $iala_upper)"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$iala_guide_family and self::mn:terms[mn:title = 'Terms and definitions'][parent::mn:sections]">Definitions</xsl:when>
			<xsl:when test="$iala_guide_family and self::mn:clause[mn:title = 'Appended publications'][parent::mn:sections]">Further reading</xsl:when>
			<xsl:when test="$iala_guide_family and self::mn:references[mn:title = 'Further reading']">Further reading</xsl:when>
			<xsl:when test="$iala_guide_family and self::mn:references">References</xsl:when>
			<xsl:when test="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab]">
				<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title/mn:tab">
				<xsl:copy-of select="mn:fmt-title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title">
				<xsl:copy-of select="mn:fmt-title/node()"/>
			</xsl:when>
			<xsl:when test="mn:title/mn:tab">
				<xsl:copy-of select="mn:title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="mn:title/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Published documents print reference entries as
			"[n] <document identifier> <title>"; the formattedref built by the
			presentation step carries the title only, so prepend the identifier. -->
	<xsl:template match="mn:bibitem/mn:formattedref[parent::mn:bibitem/mn:docidentifier[not(@scope)]][$iala_guide_family]" mode="update_xml_step1" priority="2">
		<mn:formattedref>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:value-of select="../mn:docidentifier[not(@scope)][1]"/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</mn:formattedref>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- ============================================================ -->

	<!-- keep ' — ' -->
		<!-- ============================================================ -->
	<!-- Model course part numbering model                            -->
	<!-- ============================================================ -->
	<!-- The published model courses print their "PART n - ..." dividers
			unnumbered and number the clauses beneath them restarting at 1
			(Part 1: 1..8; Part 2 modules: 1..5 with module-scoped 1.x
			sub-clauses). The clause below each part therefore drops the
			part segment of its number: "2.1" prints "1", "2.1.3.1" prints
			"1.3.1". Each part also starts its own page. -->
	<xsl:template match="mn:sections/mn:clause[starts-with(normalize-space(mn:title), 'Part')][$iala_is_model_course]" mode="update_xml_step1" priority="4">
		<mn:pagebreak from_source_xml="true"/>
		<mn:clause>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:apply-templates select="node()[not(self::mn:title)]" mode="update_xml_step1">
				<xsl:with-param name="iala_part_divider">true</xsl:with-param>
			</xsl:apply-templates>
		</mn:clause>
	</xsl:template>

	<!-- the part divider heading prints unnumbered: the label and the
			number delimiter are dropped, the title text is kept -->
	<xsl:template match="mn:fmt-title[mn:span[@class = 'fmt-caption-label']][$iala_is_model_course][count(ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part')]) = 1]" mode="update_xml_step1" priority="4">
		<xsl:param name="iala_part_divider"/>
		<xsl:if test="normalize-space($iala_part_divider) = 'true' and mn:span[@class = 'fmt-caption-delim']">
			<mn:fmt-title>
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()" mode="update_xml_step1"/>
			</mn:fmt-title>
		</xsl:if>
		<xsl:if test="not(normalize-space($iala_part_divider) = 'true' and mn:span[@class = 'fmt-caption-delim'])">
			<!-- titles outside the part-divider path keep their label -->
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step1"/>
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- descendants of a part divider: drop the first number segment;
			the number is rewritten from the label text (the autonum semx
			markers are resolved before this pass, and match-pattern
			predicates with nested steps do not resolve in this pipeline) -->
	<xsl:template match="mn:span[@class = 'fmt-caption-label'][$iala_is_model_course]" mode="update_xml_step1" priority="5">
		<xsl:variable name="under_part" select="count(ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part')]) = 1"/>
		<xsl:variable name="own_clause_is_part" select="count(ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part')]) = count(ancestor::mn:clause)"/>
		<xsl:choose>
			<xsl:when test="$under_part and not($own_clause_is_part) and contains(normalize-space(.), '.')">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:value-of select="substring-after(normalize-space(.), '.')"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- same for the cross-reference labels of part descendants -->
	<xsl:template match="mn:fmt-xref-label[$iala_is_model_course]" mode="update_xml_step1" priority="4">
		<xsl:variable name="under_part" select="count(ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part')]) = 1"/>
		<xsl:variable name="own_clause_is_part" select="count(ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part')]) = count(ancestor::mn:clause)"/>
		<xsl:choose>
			<xsl:when test="$under_part and not($own_clause_is_part) and contains(normalize-space(.), '.')">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="mn:span[@class = 'fmt-element-name']"/>
					<xsl:text> </xsl:text>
					<xsl:variable name="num" select="normalize-space(substring-after(normalize-space(.), normalize-space(mn:span[@class = 'fmt-element-name'])))"/>
					<xsl:value-of select="substring-after($num, '.')"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- the published model-course contents carry no Foreword entry -->
	<xsl:template match="mn:foreword[$iala_is_model_course]" mode="contents" priority="3"/>
	<!-- the published guide-family contents list no annex entries -->
	<xsl:template match="mn:annex[$iala_guide_family]" mode="contents" priority="3"/>

	<!-- Landscape pages for wide tables                              -->
	<!-- ============================================================ -->
	<!-- Published IALA documents print wide tables on landscape pages.
			Inject source-level pagebreaks so the page-sequence splitting
			machinery of the base stylesheet rotates those tables onto
			their own landscape sequences.
			Each doctype family is tuned against its own published form:
			reports and manuals rotate 10+ column matrices, named
			Taxonomy / Competence tables, and 4+ column tables carrying at
			least two long-text cells (>= 120 chars) - unless in an annex,
			where only 6+ column tables rotate; the standards family
			(guidelines, model courses) rotates every 5+ column table and
			the named Summary / Taxonomy tables; the rescirc documents
			print no rotated tables. -->
	<xsl:template name="is_iala_wide_table">
		<xsl:param name="table"/>
		<xsl:variable name="cols">
			<xsl:choose>
				<xsl:when test="$table/mn:colgroup">
					<xsl:value-of select="count($table/mn:colgroup/mn:col)"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- widest of the header row and the body rows -->
					<xsl:variable name="row_counts_">
						<r><xsl:value-of select="count($table/mn:thead/mn:tr[1]/*)"/></r>
						<xsl:for-each select="$table/mn:tbody/mn:tr">
							<r><xsl:value-of select="count(mn:th | mn:td)"/></r>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="xalan:nodeset($row_counts_)/r">
						<xsl:sort select="." data-type="number" order="descending"/>
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="long_cells" select="count($table/mn:tbody//mn:td[string-length(normalize-space()) &gt;= 120] | $table/mn:tbody//mn:th[string-length(normalize-space()) &gt;= 120])"/>
		<xsl:variable name="name" select="normalize-space($table/mn:fmt-name)"/>
		<xsl:choose>
			<!-- rescirc documents and standards print no rotated tables -->
			<xsl:when test="$iala_is_rescirc or $iala_is_standard"/>
			<!-- reports and manuals: the published report/manual form -->
			<xsl:when test="$iala_compact_landscape">
				<xsl:if test="$cols &gt;= 10
						or contains($name, 'Taxonomy') or contains($name, 'Competence Table')
						or ($cols &gt;= 4 and $long_cells &gt;= 2 and (not($table/ancestor::mn:annex) or $cols &gt;= 6))">
					<xsl:text>true</xsl:text>
				</xsl:if>
			</xsl:when>
			<!-- the guide family (guidelines, model courses): the published
					guideline/model-course form. Recommendations were verified
					without rotation (the stdrec brand-era layout keeps every
					table portrait), and every other doctype defaults to none. -->
			<xsl:when test="$iala_guide_family">
				<xsl:if test="$cols &gt;= 5 or contains($name, 'Summary of') or contains($name, 'Taxonomy')">
					<xsl:text>true</xsl:text>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:table[not(ancestor::mn:table)][not(ancestor::mn:clause[@type = 'revision'])]" mode="update_xml_step1" priority="1">
		<xsl:variable name="wide">
			<xsl:call-template name="is_iala_wide_table">
				<xsl:with-param name="table" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<!-- when the table opens its annex, the annex-level template
				below has already rotated the page before the title -->
		<xsl:variable name="skip_leading_break" select="parent::mn:annex and not(preceding-sibling::*[not(self::mn:fmt-title | self::mn:title | self::mn:fmt-xref-label | self::mn:variant-title)])"/>
		<xsl:if test="normalize-space($wide) = 'true' and not($skip_leading_break)">
			<mn:pagebreak from_source_xml="true" orientation="landscape"/>
		</xsl:if>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:if test="normalize-space($wide) = 'true'">
				<xsl:attribute name="landscape">true</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
		<xsl:variable name="next_tbl" select="following-sibling::mn:table[1]"/>
		<xsl:variable name="next_wide">
			<xsl:if test="$next_tbl">
				<xsl:call-template name="is_iala_wide_table">
					<xsl:with-param name="table" select="$next_tbl"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<!-- published layout keeps legend paragraphs and small companion
				tables of a table run on the same landscape spread -->
		<xsl:variable name="next_wide_id" select="generate-id($next_tbl)"/>
		<xsl:variable name="between" select="following-sibling::*[generate-id(following-sibling::mn:table[1]) = $next_wide_id]"/>
		<xsl:variable name="keep_landscape_run" select="normalize-space($next_wide) = 'true' and not($between[not(self::mn:p or self::mn:note)])"/>
		<xsl:if test="normalize-space($wide) = 'true' and not($keep_landscape_run)">
			<mn:pagebreak from_source_xml="true" orientation="portrait"/>
		</xsl:if>
	</xsl:template>
	<!-- Annexes that open with a wide table start on the landscape
			page itself (title and table share it, as published). -->
	<xsl:template match="mn:annex" mode="update_xml_step1" priority="1">
		<xsl:variable name="first_tbl" select="mn:table[not(preceding-sibling::*[not(self::mn:fmt-title | self::mn:title | self::mn:fmt-xref-label | self::mn:variant-title)])][1]"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:if test="$first_tbl">
				<xsl:variable name="wide">
					<xsl:call-template name="is_iala_wide_table">
						<xsl:with-param name="table" select="$first_tbl"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="normalize-space($wide) = 'true'">
					<!-- the break rides inside the annex: the annex title shares
						the first landscape page with the table, as published -->
					<mn:pagebreak from_source_xml="true" orientation="landscape"/>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>


	<!-- the published guide-family documents caption the named figures
			only; the auto-numbered figures (Annex C reference images) print
			no caption -->
	<xsl:template match="mn:figure/mn:fmt-name[$iala_guide_family and not(mn:semx[@element = 'name' or @element = 'title'])]" mode="update_xml_step1" priority="5">
		<!-- no caption, as published -->
	</xsl:template>

	<xsl:template match="mn:figure/mn:fmt-name/mn:span[@class = 'fmt-caption-delim']" mode="update_xml_step1" priority="4">
		<padding value="5mm"/>
	</xsl:template>
	
	<!-- li/fmt-name -->
	<xsl:template match="mn:ol/mn:li/mn:fmt-name" priority="2" mode="update_xml_step1">
		<!-- rescirc lists take the computed position label (see mn:ol/mn:li) -->
		<xsl:if test="not($iala_is_rescirc)">
		<xsl:variable name="label_" select="normalize-space()"/>
		<xsl:variable name="label_last_char" select="substring($label_, string-length($label_), 1)"/>
		<!-- label without . or ) at the end -->
		<xsl:variable name="label">
			<xsl:choose>
				<xsl:when test="$label_last_char = '.' or $label_last_char = ')'">
					<xsl:value-of select="substring($label_, 1, string-length($label_) - 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$label_"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="label"><xsl:value-of select="$label"/></xsl:attribute>
		<xsl:attribute name="full">true</xsl:attribute>
			</xsl:if>
	</xsl:template>
	
	<!-- ============================================================ -->
	<!-- ============================================================ -->

	<!-- <xsl:template match="mn:figure/mn:fmt-name/mn:span[@class = 'fmt-caption-delim']" priority="4">
		<fo:inline padding-right="5mm" role="SKIP"><xsl:value-of select="$zero_width_space"/></fo:inline>
	</xsl:template> -->
	<xsl:template name="refine_table-container-style"><?extend?>
		<xsl:variable name="in_annex" select="boolean(ancestor::mn:annex)"/>
		<xsl:variable name="n_cols_">
			<xsl:choose>
				<xsl:when test="mn:colgroup"><xsl:value-of select="count(mn:colgroup/mn:col)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count(mn:thead/mn:tr[1]/*)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="font-size">
			<xsl:choose>
				<!-- the 2021 report prints its gap/measure matrices at the
						10pt body size -->
				<xsl:when test="@landscape = 'true' and $iala_is_report">10pt</xsl:when>
				<!-- the 2017 manual prints the many-column annex radio tables
						one step below the body size and the few-column annex
						matrices (the ITU recommendations table) a further step
						down, and the wide body matrices (Tables 1-2) in
						miniature -->
				<xsl:when test="@landscape = 'true' and $iala_is_manual and $in_annex and $n_cols_ &gt;= 8">9.5pt</xsl:when>
				<xsl:when test="@landscape = 'true' and $iala_is_manual and $in_annex">9pt</xsl:when>
				<xsl:when test="@landscape = 'true' and $iala_is_manual">6pt</xsl:when>
				<xsl:otherwise>10pt</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- Top-level lists and tables in clause-less documents          -->
	<!-- (resolutions, circular letters)                              -->
	<!-- ============================================================ -->
	<!-- The base wildcards also hijack top-level mn:p elements: the
	     clause-less paragraphs render through sections_node without any
	     paragraph styling (no p-style attributes, no refine_p-style). The
	     legacy and A1x assembly resolutions print their recitals with the
	     published leading and paragraph gap, so route those paragraphs
	     through the real paragraph template inside the same Sect wrapper. -->
	<xsl:template match="/*/mn:sections/mn:p[$iala_rescirc_legacy or $iala_rescirc_a1x] |
			mn:sections/mn:page_sequence/mn:p[$iala_rescirc_legacy or $iala_rescirc_a1x]" priority="3">
		<fo:block role="Sect">
			<xsl:call-template name="addTagElementT"/>
			<xsl:call-template name="paragraph"/>
		</fo:block>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- Top-level lists and tables in clause-less documents (lists)  -->
	<!-- ============================================================ -->
	<!-- The base XSL's top-level wildcards (sections_node
	     match="/*/mn:sections/*", and match="mn:sections/mn:page_sequence/*[not(@top-level)]",
	     both priority 2) hijack top-level mn:ol / mn:ul / mn:table elements in
	     documents that carry no clauses (the FO pre-processing wraps each
	     sections child in a mn:page_sequence). Their children (fo:list-item,
	     fo:table-header) end up bare inside a fo:block, which FOP rejects
	     as a fatal validation error and the whole compile dies. Give them
	     priority-3 templates that render through the proper list / table
	     templates, wrapped in the same Sect block the wildcard would give.
	     Gated to the rescirc doctypes: the other families were verified
	     with the base wildcard rendering. -->
	<xsl:template match="/*/mn:sections/mn:ol[$iala_is_rescirc] | /*/mn:sections/mn:ul[$iala_is_rescirc] |
			/*/mn:sections/mn:page_sequence/mn:ol[$iala_is_rescirc] | /*/mn:sections/mn:page_sequence/mn:ul[$iala_is_rescirc]" priority="3">
		<fo:block role="Sect">
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addTagElementT"/>
			<fo:block role="SKIP">
				<xsl:apply-templates select="." mode="list"/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template match="/*/mn:sections/mn:table[$iala_is_rescirc] |
			/*/mn:sections/mn:page_sequence/mn:table[$iala_is_rescirc]" priority="3">
		<!-- no setId here: the rendered fo:table keeps the element's id,
		     and a duplicate on the wrapper breaks FOP -->
		<fo:block role="Sect">
			<xsl:call-template name="addTagElementT"/>
			<xsl:call-template name="table"/>
		</fo:block>
	</xsl:template>

	<!-- ============================================================ -->
	<!-- Resolutions + circular letters: letterhead on page 1         -->
	<!-- ============================================================ -->
	<!-- The published PDFs open the letterhead block at the top of the
	     FIRST body page and flow the document content right below it on
	     the same page (no cover page-sequence, no Contents, no Foreword).
	     The first sections element carries the letterhead ahead of its
	     normal rendering. -->
<xsl:template match="/*/mn:sections/mn:page_sequence/*[1][$iala_is_rescirc]" priority="4">
		<xsl:call-template name="rescirc_letterhead"/>
		<xsl:choose>
			<xsl:when test="self::mn:ol or self::mn:ul">
				<fo:block role="Sect">
					<xsl:call-template name="setId"/>
					<xsl:call-template name="addTagElementT"/>
					<fo:block role="SKIP">
						<xsl:apply-templates select="." mode="list"/>
					</fo:block>
				</fo:block>
			</xsl:when>
			<xsl:when test="self::mn:table">
				<!-- no setId: the fo:table keeps the element's id -->
				<fo:block role="Sect">
					<xsl:call-template name="addTagElementT"/>
					<xsl:call-template name="table"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- date as printed: 08 January 2025 (or January 2025 when the
	     bibdata date carries no day) -->
	<xsl:template name="rescirc_date">
		<xsl:if test="$iala_docdate != ''">
			<xsl:if test="substring($iala_docdate, 9, 2) != ''">
				<xsl:value-of select="substring($iala_docdate, 9, 2)"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:call-template name="getMonthByNum">
				<xsl:with-param name="num" select="substring($iala_docdate, 6, 2)"/>
			</xsl:call-template>
			<xsl:text> </xsl:text>
			<xsl:value-of select="substring($iala_docdate, 1, 4)"/>
		</xsl:if>
	</xsl:template>

	<!-- language as printed: Original: English -->
	<xsl:template name="rescirc_lang_name">
		<xsl:choose>
			<xsl:when test="$iala_lang = 'en'">English</xsl:when>
			<xsl:when test="$iala_lang = 'fr'">French</xsl:when>
			<xsl:when test="$iala_lang = 'es'">Spanish</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(translate(substring($iala_lang, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring($iala_lang, 2))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="rescirc_letterhead">
		<xsl:choose>
			<xsl:when test="$iala_is_letter">
				<!-- Circular letter: the letterhead logo rides the page-first
				     header region (see insertHeader); the flow opens with the
				     letter number (bold, right-aligned) and the date, as
				     printed -->
				<fo:block text-align="right" font-weight="bold" margin-top="14mm" margin-right="2mm">
					<xsl:text>Circular Letter </xsl:text>
					<xsl:value-of select="$iala_docidentifier"/>
				</fo:block>
				<fo:block text-align="right" margin-top="3.5mm" margin-right="2mm">
					<xsl:call-template name="rescirc_date"/>
				</fo:block>
				<fo:block font-size="0pt" margin-bottom="9.5mm">&#xa0;</fo:block>
			</xsl:when>
			<xsl:when test="starts-with($iala_docidentifier, 'GA')">
				<!-- GA resolutions: docidentifier top left, language top
				     right, centered logo, assembly / document block, rule,
				     centered resolution line and title -->
				<fo:block-container width="100%" role="SKIP">
					<fo:block text-align="left" font-weight="bold" font-size="10pt">
						<xsl:value-of select="$iala_docid_slash"/>
					</fo:block>
				</fo:block-container>
				<fo:block text-align="right" font-size="10pt" margin-top="-4mm" margin-right="2mm">
					<xsl:value-of select="translate($iala_lang, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
				</fo:block>
				<fo:block text-align="center" margin-top="6mm">
					<fo:instream-foreign-object content-width="26mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
						<xsl:copy-of select="$IALA-Logo-full"/>
					</fo:instream-foreign-object>
				</fo:block>
				<fo:table table-layout="fixed" width="100%" role="SKIP" margin-top="8mm">
					<fo:table-column column-width="50%"/>
					<fo:table-column column-width="50%"/>
					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<fo:table-cell role="SKIP" font-size="10pt" line-height="1.3">
								<fo:block><xsl:value-of select="$iala_ga_ordinal"/><xsl:value-of select="$iala_ga_ordinal_suffix"/> General Assembly</fo:block>
								<fo:block>International Organization</fo:block>
								<fo:block>for Marine Aids to Navigation</fo:block>
							</fo:table-cell>
							<fo:table-cell role="SKIP" font-size="10pt" line-height="1.3" text-align="right">
								<fo:block><xsl:value-of select="$iala_docid_slash"/></fo:block>
								<fo:block><xsl:call-template name="rescirc_date"/></fo:block>
								<fo:block>Original: <xsl:call-template name="rescirc_lang_name"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				<!-- the printed rule: a run of underscores in the published PDF -->
				<fo:block font-size="10pt" margin-top="4mm" margin-right="2mm" role="SKIP">___________________________________________________________________</fo:block>
				<fo:block text-align="center" font-weight="bold" font-size="11pt" margin-top="9mm">
					<xsl:text>Resolution </xsl:text>
					<xsl:value-of select="$iala_docidentifier"/>
				</fo:block>
				<fo:block text-align="center" font-weight="bold" font-size="11pt" margin-top="8pt">
					<xsl:text>Adopted on </xsl:text>
					<xsl:call-template name="rescirc_date"/>
				</fo:block>
				<fo:block text-align="center" font-weight="bold" font-size="11pt" margin-top="8pt" text-transform="uppercase" color="{$color_primary_recommendation}">
					<xsl:value-of select="$iala_title_en"/>
				</fo:block>
				<fo:block font-size="0pt" margin-bottom="7mm">&#xa0;</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="number(substring(normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on), 1, 4)) &lt; 2016">
						<!-- Legacy assembly resolutions (A12 era): logo left,
						     association name block right, resolution and
						     adoption lines, then the title. FOP collapses a
						     leading table margin, so the printed offset rides
						     a spacer block -->
						<fo:block font-size="0pt" margin-bottom="4mm">&#xa0;</fo:block>
						<fo:table table-layout="fixed" width="100%" role="SKIP">
							<fo:table-column column-width="30%"/>
							<fo:table-column column-width="70%"/>
							<fo:table-body role="SKIP">
								<fo:table-row role="SKIP">
									<fo:table-cell role="SKIP">
										<fo:block text-align="left" margin-top="4mm">
											<fo:instream-foreign-object content-width="30mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
												<xsl:copy-of select="$IALA-Logo-full"/>
											</fo:instream-foreign-object>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell role="SKIP" text-align="justify" font-style="italic" font-weight="bold" color="{$color_primary_recommendation}" font-size="10pt">
										<fo:block>IALA &#8212; AISM <fo:inline font-weight="normal">(International Association of Marine</fo:inline></fo:block>
										<fo:block><fo:inline font-weight="normal">Aids to Navigation and Lighthouse Authorities</fo:inline></fo:block>
										<fo:block><fo:inline font-weight="normal">Association Internationale de Signalisation Maritime)</fo:inline></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
						<fo:block text-align="right" font-weight="bold" margin-top="8.5mm" margin-right="2mm">
							<xsl:text>IALA General Assembly Resolution </xsl:text>
							<!-- the A12-era print sets the session-less resolution
							     index: A12-01 prints as A.01 -->
							<xsl:value-of select="concat(substring($iala_docidentifier, 1, 1), '.', substring-after($iala_docidentifier, '-'))"/>
						</fo:block>
						<fo:block text-align="right" margin-top="6pt" margin-right="2mm">
							<xsl:text>Adopted on </xsl:text>
							<xsl:call-template name="rescirc_date"/>
						</fo:block>
						<fo:block font-weight="bold" font-size="12pt" text-transform="uppercase" color="black" margin-top="15mm">
							<xsl:value-of select="$iala_title_en"/>
						</fo:block>
						<fo:block font-size="0pt" margin-bottom="4mm">&#xa0;</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<!-- A1x assembly resolutions (A13): docidentifier
						     top right, centered logo, then the body -->
						<fo:block text-align="right" font-size="11pt" margin-right="2mm">
							<xsl:text>Resolution </xsl:text>
							<xsl:value-of select="$iala_docidentifier"/>
						</fo:block>
						<fo:block text-align="center" margin-top="1mm">
							<fo:instream-foreign-object content-width="45mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
								<xsl:copy-of select="$IALA-Logo-full"/>
							</fo:instream-foreign-object>
						</fo:block>
						<fo:block font-size="0pt" margin-bottom="1mm">&#xa0;</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_table-header-row-style"><?extend?>
		<xsl:attribute name="background-color">transparent</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
	</xsl:template>
	
	<xsl:template name="refine_table-header-cell-style"><?extend?>
		<xsl:attribute name="padding-left">4mm</xsl:attribute>
		<xsl:if test="ancestor::mn:table[@landscape = 'true'] and $iala_compact_landscape">
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$iala_rescirc_a1x">
			<xsl:attribute name="padding-left">0mm</xsl:attribute>
			<xsl:attribute name="padding-right">0mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">3mm</xsl:attribute>
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<!-- the printed French column wraps the resolution header after
					"de": under the substituted Carlito metrics the wrap
					reproduces with a small size lift on the French cell -->

		</xsl:if>
	</xsl:template>
	
	<xsl:template name="refine_table-body-row-style"><?extend?>
		<!-- @type added in <xsl:template match="mn:table" mode="document_revision"> -->
		<xsl:if test="ancestor::mn:table[@type = 'revision']">
			<!--not 15mm, because there are padding-top and padding-bottom -->
			<xsl:attribute name="min-height">12mm</xsl:attribute>
		</xsl:if>
		<!-- Published standards print roomy table rows (~13mm); the generated
			ones were text-height, squeezing sections 7-8 onto the previous page -->
		<xsl:if test="$iala_is_standard and not(ancestor::mn:table[@type = 'revision'])">
			<xsl:attribute name="min-height">12mm</xsl:attribute>
		</xsl:if>
		<!-- The published G1195 spreads its landscape Annex A descriptors over
			five pages at roughly half a page per element row; the generated
			rows were text-height and packed the table tighter -->
		<xsl:if test="$iala_guide_family and ancestor::mn:annex and ancestor::mn:table[@landscape = 'true'] and not(ancestor::mn:table[@type = 'revision'])">
			<xsl:attribute name="min-height">38mm</xsl:attribute>
		</xsl:if>
		<!-- The document history table never splits: it moves whole to the
			next page, leaving the clause heading at the bottom of the previous
			one (S1060 published layout) -->
		<xsl:if test="$iala_is_standard and ancestor::mn:table[ancestor::mn:clause[mn:fmt-title[contains(translate(normalize-space(.), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'document history')]]]">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="refine_table-cell-style"><?extend?>
		<xsl:attribute name="padding-left">4mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:if test="$iala_guide_family and not(ancestor::mn:table[@landscape = 'true'])">
			<!-- the published guide-family body tables set compact cells
				(the Annex D assessment matrix spreads over four pages) -->
			<xsl:attribute name="padding-left">2.5mm</xsl:attribute>
			<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="line-height">1.12</xsl:attribute>
		</xsl:if>
		<xsl:if test="ancestor::mn:table[@landscape = 'true'] and $iala_compact_landscape">
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">1.25mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1.25mm</xsl:attribute>
			<xsl:choose>
				<!-- the manual's dense radio matrices print tight leading;
						the report's gap/measure tables keep the house
						line-height of the published 2021 PDF -->
				<xsl:when test="$iala_is_manual"><xsl:attribute name="line-height">1.15</xsl:attribute></xsl:when>
				<xsl:otherwise><xsl:attribute name="line-height">1.2</xsl:attribute></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!-- Published standards print roomy rows (~13mm) with the cell content
			centred; padding (not row min-height, unsupported by FOP here)
			reproduces the height and pushes the late sections to their own page -->
		<xsl:if test="$iala_is_standard and not(ancestor::mn:table[@type = 'revision'])">
			<xsl:attribute name="padding-top">3.2mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">3.2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$iala_rescirc_a1x">
			<xsl:attribute name="padding-left">0mm</xsl:attribute>
			<xsl:attribute name="padding-right">0mm</xsl:attribute>
			<xsl:attribute name="padding-top">2.2mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">2.2mm</xsl:attribute>
			<xsl:attribute name="border">none</xsl:attribute>
			<xsl:variable name="a13_row" select="count(parent::mn:tr/preceding-sibling::mn:tr) + 1 + count(ancestor::mn:tbody[1]/preceding-sibling::mn:thead[1]/mn:tr)"/>
			<xsl:attribute name="font-size">
				<xsl:choose>
					<xsl:when test="$a13_row = 1">16pt</xsl:when>
					<xsl:when test="$a13_row = 2 or $a13_row = 3">14pt</xsl:when>
					<xsl:otherwise>11pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
		<!-- the letter membership tables print compact: tight rows on a
			trimmed table width -->
		<xsl:if test="$iala_is_letter">
			<xsl:attribute name="padding-top">0.2mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- Published table refinements: border arrays from the markup, plus
			the rescirc table widths -->
	<xsl:template name="refine_table-style">
		<xsl:param name="margin-side"/>
		<xsl:call-template name="setBordersTableArray"/>
		<xsl:call-template name="setNoBordersForTableList"/>
		<!-- the letter membership tables print trimmed, not full measure -->
		<xsl:if test="$iala_is_letter">
			<xsl:attribute name="width">66%</xsl:attribute>
		</xsl:if>
		<!-- the A1x bilingual resolutions print the facing columns without
			the grid -->
		<xsl:if test="$iala_rescirc_a1x">
			<xsl:attribute name="border">none</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- Column widths: the base derives proportional widths from the
			longest word in each column, which starves the leading text
			column of wide tables. On landscape tables give the first
			column double weight, as in the published documents. -->
	<xsl:template name="insertTableColumnWidth">
		<xsl:param name="colwidths"/>
		<xsl:variable name="is_landscape_table" select="boolean(self::mn:table[@landscape = 'true'] or ancestor-or-self::mn:table[@landscape = 'true'])"/>
		<xsl:variable name="n_cols" select="count(xalan:nodeset($colwidths)//column)"/>
		<xsl:for-each select="xalan:nodeset($colwidths)//column">
			<xsl:choose>
				<!-- the letter membership tables print the label column at
						double weight over three equal rate columns -->
				<xsl:when test="$iala_is_letter">
					<xsl:choose>
						<xsl:when test="position() = 1">
							<fo:table-column column-width="proportional-column-width(2.4)"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width(1)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- on the manuals' many-column landscape tables the precomputed
						portrait proportions starve the leading column; equal
						shares reproduce the published layout. Tables with fewer
						columns (the four-column ITU recommendations matrix) print
						pronounced unequal columns and keep the computed
						proportions -->
				<xsl:when test="$is_landscape_table and $iala_is_manual and $n_cols &gt;= 8">
					<fo:table-column column-width="proportional-column-width(20)"/>
				</xsl:when>
				<xsl:when test=". = 1 or . = 0">
					<fo:table-column column-width="proportional-column-width(2)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="divider">
						<xsl:value-of select="@divider"/>
						<xsl:if test="not(@divider)">1</xsl:if>
					</xsl:variable>
					<xsl:variable name="w" select="round(. div $divider)"/>
					<fo:table-column column-width="proportional-column-width({$w})"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:variable name="ul_labels_">
		<!-- only styles are using -->
		<!-- labes render from XML -->
		<label level="1" font-size="120%" line-height="100%">•</label><!-- font-size="150%"   line-height="80%"-->
		<label level="2" font-size="120%" line-height="100%">•</label><!-- font-size="150%" line-height="80%" -->
		<label level="3" font-size="80%" line-height="130%">&#x25CB;</label><!-- white circle -->
	</xsl:variable>

	<xsl:template name="refine_list-item-label-style"><?extend?>
		<xsl:if test="parent::mn:ul">
			<xsl:attribute name="color">
				<xsl:choose>
					<xsl:when test="@label = '&#x25CB;'">black</xsl:when>
					<xsl:when test="parent::mn:ul/parent::mn:li/@label = '&#x2022;'">
						<xsl:value-of select="$color_primary_guideline_50"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$color_corporate_blue"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- the printed letter bullets sit on the text line: the 120%
			     bullet keeps its size but stops inflating the line pitch -->
			<xsl:if test="$iala_is_letter">
				<xsl:attribute name="line-height">100%</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- published resolutions and circular letters print the operative
	     lists with the period label ("1."), taken verbatim from the item
	     position (the base would append the parenthesis form) -->
	<xsl:template name="refine_list-style">
		<xsl:if test="$iala_rescirc_legacy and self::mn:ol">
			<xsl:attribute name="margin-left">6.35mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- Published recital lists run a slightly wider item gap (the base
			list-item style is tighter); table cells keep the base zero. The
			resolutions and letters carry their own item rhythm (the legacy
			operative list keeps a full blank line between items; the letter
			bullet lists print set solid), and the final membership list of a
			letter keeps its last two items bound so the printed page break
			inside the list reproduces. -->
	<xsl:template name="refine_list-item-style">
		<xsl:if test="ancestor::mn:table">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="ancestor::mn:clause[mn:fmt-title[normalize-space(.) = 'The Council']][$iala_is_recommendation]">
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$iala_rescirc_legacy and parent::mn:ol">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$iala_is_letter and parent::mn:ul">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			<!-- the printed page break falls inside the closing membership
					list: bind its last two items so the list splits after its
					first item, as printed -->
			<xsl:if test="count(following-sibling::mn:li) &lt;= 1">
				<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- rescirc operative items carry the computed period label on the li,
	     printed verbatim by the base getListItemFormat via @full -->
	<xsl:template match="mn:ol/mn:li" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*[not(name() = 'label' or name() = 'full')]"/>
			<xsl:if test="$iala_is_rescirc">
				<xsl:attribute name="label">
					<xsl:value-of select="concat(string(count(preceding-sibling::mn:li) + 1), '.')"/>
				</xsl:attribute>
				<xsl:attribute name="full">true</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:attribute-set name="quote-container-style">
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_quote-container-style"><?extend?>
		<xsl:variable name="count_ancestor_lists" select="count(ancestor::mn:ul) + count(ancestor::mn:ol)"/>
		<xsl:variable name="provisional_distance_between_starts_">
			<attributes xsl:use-attribute-sets="list-style">
				<xsl:call-template name="refine_list-style_provisional-distance-between-starts"/>
			</attributes>
		</xsl:variable>
		<xsl:variable name="provisional_distance_between_starts__" select="substring-before(normalize-space(xalan:nodeset($provisional_distance_between_starts_)/attributes/@provisional-distance-between-starts), 'mm')"/>
		<xsl:variable name="provisional_distance_between_starts">
			<xsl:value-of select="$provisional_distance_between_starts__"/>
			<xsl:if test="$provisional_distance_between_starts__ = ''">0</xsl:if>
		</xsl:variable>
		<xsl:variable name="provisional_distance_between_starts_value" select="number(normalize-space($provisional_distance_between_starts))"/>
		<xsl:variable name="margin_left" select="$provisional_distance_between_starts_value + 6 * $count_ancestor_lists"/>
		<xsl:attribute name="margin-left"><xsl:value-of select="$margin_left"/>mm</xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_bibitem-normative-list-style"><?extend?>
		<xsl:attribute name="provisional-distance-between-starts">
			<xsl:choose>
				<xsl:when test="string-length($docidentifier) = 0">0mm</xsl:when>
				<xsl:when test="string-length($docidentifier) &gt; 19">46.5mm</xsl:when>
				<xsl:when test="string-length($docidentifier) &gt; 10">37mm</xsl:when>
				<xsl:otherwise>9.5mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="insertHeaderFooter">
		<xsl:param name="orientation"/>
		
		<xsl:call-template name="insertHeader">
			<xsl:with-param name="orientation" select="$orientation"/>
		</xsl:call-template>
		
		<xsl:call-template name="insertFooter"/>
	</xsl:template>

	<xsl:template name="insertHeader">
		<xsl:choose>
			<xsl:when test="$iala_is_letter">
				<!-- Circular letters: page 1 rides the printed letterhead logo
				     (big, centred, high on the sheet) in the header-first
				     region of the page-first master; the continuation pages
				     keep the small right-hand logo of the published template -->
				<fo:static-content flow-name="header-first" role="artifact">
					<fo:block text-align="center" margin-top="5mm" font-size="0pt">
						<fo:instream-foreign-object content-width="41mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
							<xsl:copy-of select="$IALA-Logo-full"/>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:static-content>
				<fo:static-content flow-name="header" role="artifact">
					<fo:block text-align="right" margin-top="5mm" margin-right="-4.5mm" font-size="0pt">
						<fo:instream-foreign-object content-width="20mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
							<xsl:copy-of select="$IALA-Logo-full"/>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:static-content>
			</xsl:when>
			<xsl:when test="$iala_is_rescirc">
				<!-- the published resolutions carry no running header: the
				     letterhead logo rides the first body page in the flow -->
				<fo:static-content flow-name="header" role="artifact">
					<fo:block font-size="0pt" role="SKIP"><fo:wrapper role="artifact">&#xa0;</fo:wrapper></fo:block>
				</fo:static-content>
			</xsl:when>
			<xsl:otherwise>
				<fo:static-content flow-name="header" role="artifact">
					<fo:block text-align="right" margin-top="7.5mm" margin-right="-4.5mm" font-size="0pt">
						<xsl:if test="xalan:nodeset($IALA-Logo)/*">
							<fo:instream-foreign-object content-width="7.25mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
								<xsl:copy-of select="$IALA-Logo"/>
							</fo:instream-foreign-object>
						</xsl:if>
					</fo:block>
				</fo:static-content>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertFooter">
		<xsl:choose>
			<xsl:when test="$iala_is_rescirc and number(substring(normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on), 1, 4)) &lt; 2016">
				<fo:static-content flow-name="footer" role="artifact">
					<!-- the legacy (A12-era) print sets the association address
					     block in 10pt Century Gothic: right-aligned first line,
					     centred address lines, no rule above -->
					<fo:block-container font-size="10pt" margin-top="4.5mm" line-height="1.25">
						<fo:block text-align="right">IALA-AISM</fo:block>
						<fo:block text-align="center">10, rue des Gaudines &#8211; 78100 Saint-Germain-en-Laye &#8211; France</fo:block>
						<fo:block text-align="center">Tel.: +33 1 34 51 70 01 &#8211; Fax: +33 1 34 51 82 05</fo:block>
						<fo:block text-align="center">e-mail: contact@iala-aism.org &#8211; web: www.iala-aism.org</fo:block>
					</fo:block-container>
				</fo:static-content>
			</xsl:when>
			<xsl:when test="$iala_is_rescirc">
				<!-- the published PDFs carry no footer text for resolutions
				     and circular letters: the address block is a graphic -->
				<fo:static-content flow-name="footer" role="artifact">
					<fo:block-container border-top="0.2pt solid black" font-size="0pt" margin-top="4.5mm" role="SKIP">
						<fo:block role="SKIP"><fo:wrapper role="artifact">&#xa0;</fo:wrapper></fo:block>
					</fo:block-container>
				</fo:static-content>
			</xsl:when>

			<xsl:when test="$iala_is_manual">
				<!-- Published manual footer: gold rule over the association
						name and title, then the publication date left and the
						"____ P N" page stamp right, as printed in the 2017
						MRCP -->
				<fo:static-content flow-name="footer" role="artifact">
					<fo:block-container font-size="7.56pt" font-weight="bold" color="{$color_corporate_blue}" border-top="0.75pt solid {$color_corporate_yellow}" line-height="1.43">
						<fo:block margin-top="4.5mm">
							<xsl:text>IALA </xsl:text>
							<xsl:variable name="title">
								<xsl:call-template name="getVariableCopyOf"><xsl:with-param name="variable">title</xsl:with-param></xsl:call-template>
							</xsl:variable>
							<xsl:for-each select="xalan:nodeset($title)/item">
								<xsl:copy-of select="node()"/>
							</xsl:for-each>
						</fo:block>
						<fo:block text-align-last="justify">
							<xsl:call-template name="getVariable"><xsl:with-param name="variable">date</xsl:with-param></xsl:call-template>
							<fo:leader leader-pattern="space"/>
							<fo:inline color="{$color_corporate_yellow}">____</fo:inline>
							<xsl:text> P&#xa0;</xsl:text><fo:page-number />
						</fo:block>
					</fo:block-container>
				</fo:static-content>
			</xsl:when>
			<xsl:when test="$iala_is_report">
				<!-- Published 2021-report footer: plain title line, then the
						centred "Page N" Word stamp -->
				<fo:static-content flow-name="footer" role="artifact">
					<fo:block-container font-size="7.56pt" color="{$color_corporate_blue}" line-height="1.43">
						<fo:block margin-top="4.5mm">
							<xsl:variable name="title">
								<xsl:call-template name="getVariableCopyOf"><xsl:with-param name="variable">title</xsl:with-param></xsl:call-template>
							</xsl:variable>
							<xsl:for-each select="xalan:nodeset($title)/item">
								<xsl:copy-of select="node()"/>
							</xsl:for-each>
						</fo:block>
						<fo:block text-align="center">
							<xsl:text>Page </xsl:text><fo:page-number />
					</fo:block>
				</fo:block-container>
			</fo:static-content>
		</xsl:when>
		<xsl:when test="$iala_is_information_paper">
				<!-- the published leaflet footer: "Information Paper – <title> /
						<date>" left, "Page n" right -->
				<fo:static-content flow-name="footer" role="artifact">
					<fo:block-container font-size="9pt" border-top="0.2pt solid black" margin-top="4.5mm">
						<fo:block text-align-last="justify">
							<fo:inline font-weight="bold"><xsl:text>Information Paper</xsl:text></fo:inline>
							<xsl:text> &#8211; </xsl:text>
							<xsl:value-of select="normalize-space(/mn:metanorma/mn:bibdata/mn:title[@type = 'main' and (@language = 'en' or normalize-space(@language) = '')][1])"/>
							<fo:leader leader-pattern="space"/>
							<xsl:call-template name="convertDate">
								<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on"/>
							</xsl:call-template>
						</fo:block>
						<fo:block text-align="right">
							<xsl:text>Page </xsl:text><fo:page-number/>

						</fo:block>
					</fo:block-container>
				</fo:static-content>
			</xsl:when>
			<xsl:otherwise>

		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container font-size="7.56pt" font-weight="bold" color="{$color_corporate_blue}" border-top="0.2pt solid black" line-height="1.43">
				<fo:block margin-top="4.5mm">
					<!-- Publications dated before 2026 open with the
						"IALA" association prefix -->
					<xsl:if test="$iala_iala_prefix">
						<xsl:text>IALA </xsl:text>
					</xsl:if>
					<xsl:call-template name="getVariable"><xsl:with-param name="variable">doctype_full</xsl:with-param></xsl:call-template>
					<!-- Recommendations carry the recital qualifier in the running
							title, sentence-cased as printed -->
					<xsl:if test="$iala_is_recommendation and $iala_normativity != ''">
						<xsl:text> </xsl:text>
						<xsl:call-template name="iala_sentence_case">
							<xsl:with-param name="str" select="$iala_normativity"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:call-template name="getVariable"><xsl:with-param name="variable">docidentifier</xsl:with-param></xsl:call-template>
					<xsl:choose>
						<xsl:when test="$iala_is_standard"><xsl:text> – </xsl:text></xsl:when>
						<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<!-- the published model courses join the docidentifier with
							the course subtitle: "IALA Model Course C2007-1 – Radar
							Beacons (Racon) Maintenance" -->
						<xsl:when test="$iala_is_model_course and normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:cover-subtitle | /mn:metanorma/mn:bibdata/mn:title[@type = 'subtitle']) != ''">
							<xsl:text> &#8211; </xsl:text>
							<xsl:value-of select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:cover-subtitle | /mn:metanorma/mn:bibdata/mn:title[@type = 'subtitle'])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="title">
								<xsl:choose>
									<xsl:when test="$iala_running_title != ''">
										<item><xsl:value-of select="$iala_running_title"/></item>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="getVariableCopyOf"><xsl:with-param name="variable">title</xsl:with-param></xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:for-each select="xalan:nodeset($title)/item">
								<xsl:text> </xsl:text>
								<xsl:copy-of select="node()"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
				<fo:block>
					<xsl:if test="not($iala_is_standard and $iala_era_old)">
						<xsl:attribute name="text-align-last">justify</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="getVariable"><xsl:with-param name="variable">edition</xsl:with-param></xsl:call-template>
					<xsl:text> </xsl:text>
					<fo:inline text-transform="lowercase"><xsl:call-template name="getVariable"><xsl:with-param name="variable">urn</xsl:with-param></xsl:call-template></fo:inline>
					<!-- Legacy standards carry the page number on a third,
						publication-date line -->
					<xsl:if test="not($iala_is_standard and $iala_era_old)">
						<fo:leader leader-pattern="space"/>
						<xsl:text>P&#xa0;</xsl:text><fo:page-number />
					</xsl:if>
				</fo:block>
				<xsl:if test="$iala_is_standard and $iala_era_old">
					<fo:block text-align-last="justify">
						<xsl:call-template name="getVariable"><xsl:with-param name="variable">date</xsl:with-param></xsl:call-template>
						<fo:leader leader-pattern="space"/>
						<xsl:text>P&#xa0;</xsl:text><fo:page-number />
					</fo:block>
				</xsl:if>
			</fo:block-container>
		</fo:static-content>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Reports and manuals carry the printed caption numbers inside the
			titles themselves ("Table 3 – Gap Analysis...", "Table 6 – System
			Description Table"); the generated autonum label and its dash
			delimiter are dropped so the captions print verbatim. The manual's
			annex subsection headings do the same (the printed "E3 AIS Today"
			carries its number in the title; the body clauses keep theirs). -->
	<xsl:template match="mn:table/mn:fmt-name/mn:span[@class = 'fmt-caption-label'][$iala_compact_landscape] |
			mn:table/mn:fmt-name/mn:span[@class = 'fmt-caption-delim'][$iala_compact_landscape] |
			mn:figure/mn:fmt-name/mn:span[@class = 'fmt-caption-label'][$iala_compact_landscape] |
			mn:figure/mn:fmt-name/mn:span[@class = 'fmt-caption-delim'][$iala_compact_landscape] |
			mn:annex//mn:clause/mn:fmt-title/mn:span[@class = 'fmt-caption-label'][$iala_is_manual] |
			mn:annex//mn:clause/mn:fmt-title/mn:span[@class = 'fmt-caption-delim'][$iala_is_manual] |
			mn:annex//mn:clause/mn:fmt-title/mn:span[@class = 'fmt-autonum-delim'][$iala_is_manual]" mode="update_xml_step1" priority="3"/>

	<!-- Manuals print annex headings on one line, "ANNEX A – System
			Description" (the caption-delim break becomes an en dash and
			the Annex label uppercases), and the printed Contents carries
			no annex entries at all. -->
	<xsl:template match="mn:annex/mn:fmt-title/mn:span[@class = 'fmt-caption-delim'][mn:br][$iala_is_manual]" mode="update_xml_step1" priority="4">
		<span class="fmt-caption-delim"> &#8211; </span>
	</xsl:template>
	<xsl:template match="mn:annex/mn:fmt-title/mn:span[@class = 'fmt-caption-label']//mn:span[@class = 'fmt-element-name'][normalize-space() = 'Annex'][$iala_is_manual]" mode="update_xml_step1" priority="4">
		<span class="fmt-element-name">ANNEX</span>
	</xsl:template>
	<xsl:template match="mn:annex[$iala_is_manual]" mode="contents" priority="3">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- the printed MRCP Contents carries no level-1 entries (the Word ToC
			was built from the level 2-4 headings only) and no ANNEX A-E
			entries themselves, but keeps the annex subsection entries
			(E.1, E.6.1, ...): the level-1 items are skipped and their
			children render in their place -->
	<xsl:template match="mnx:item[$iala_is_manual][@level = '1' or @type = 'annex']" priority="3">
		<xsl:if test="mnx:item[@display = 'true']">
			<fo:block role="TOC">
				<xsl:apply-templates select="mnx:item[@display = 'true']"/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<!-- List-of sequences per published form:
			- the 2017 manual closes the Contents with a single combined
			  LIST OF TABLES AND FIGURES (tables first, then figures);
			- the 2021 report opens the List of Figures on its own page
			  with the List of Tables continuing below it;
			- every other family keeps the base order (tables, figures). -->
	<xsl:template name="insertListsOf">
		<xsl:param name="num"/>
		<xsl:variable name="tables" select="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:tables/mnx:table"/>
		<xsl:variable name="figures" select="$contents/mnx:doc[@num = $num]/mnx:contents//mnx:figures/mnx:figure"/>
		<xsl:choose>
			<xsl:when test="$iala_is_manual">
				<xsl:if test="$tables or $figures">
					<fo:block xsl:use-attribute-sets="toc-listof-title-style">
						<xsl:call-template name="refine_toc-listof-title-style"/>
						<xsl:text>LIST OF TABLES AND FIGURES</xsl:text>
					</fo:block>
					<fo:block role="TOC">
						<xsl:for-each select="$tables">
							<xsl:call-template name="insertListOf_Item"/>
						</xsl:for-each>
						<xsl:for-each select="$figures">
							<xsl:call-template name="insertListOf_Item"/>
						</xsl:for-each>
					</fo:block>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$iala_is_report">
				<xsl:if test="$figures">
					<fo:block break-before="page" font-size="1pt" role="SKIP"/>
					<xsl:call-template name="insertListOfFigures">
						<xsl:with-param name="num" select="$num"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$tables">
					<xsl:call-template name="insertListOfTables">
						<xsl:with-param name="num" select="$num"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="insertListOfTables">
					<xsl:with-param name="num" select="$num"/>
				</xsl:call-template>
				<xsl:call-template name="insertListOfFigures">
					<xsl:with-param name="num" select="$num"/>
				</xsl:call-template>
				<xsl:call-template name="insertListOfExamples">
					<xsl:with-param name="num" select="$num"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="IALA-Logo">
		<xsl:copy-of select="//mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization/mn:logo/mn:image/*[local-name() = 'svg']"/>
	</xsl:variable>

	<xsl:variable name="IALA-Logo-full">
		<svg xmlns="http://www.w3.org/2000/svg" width="1556" height="1520" viewBox="0 0 1556 1520">
			<path d="m838.09,607.21c5.44.52,10.89,1.04,16.33,1.57,9.09.88,18.17,2.04,27.29,2.61,15.93.99,31.88,1.85,47.83,2.35,15.14.47,30.3.86,45.43.45,15.78-.43,31.56-1.48,47.28-2.96,20.51-1.92,40.94-4.62,61.21-8.43,8-1.5,16.02-2.86,24.03-4.25.78-.13,1.6-.02,2.4-.02-.36,85.65-41.27,200.04-151.92,271.81-106.28,68.93-243.29,71.22-351.78,5.74-112.73-68.03-164.26-185.59-161.32-291.44,1.8-.33,3.69-.83,5.61-1,9.6-.83,19.2-1.68,28.82-2.31,14.26-.94,28.52-2.12,42.8-2.46,20.31-.48,40.64-.42,60.97-.33,9.97.04,19.96.44,29.92,1.1,15.25,1.02,30.48,2.33,45.7,3.67,10.6.94,21.19,2.01,31.75,3.28,11.21,1.35,22.39,3.01,33.58,4.54,6.74.92,13.48,1.83,21.12,2.87-1.48,1.06-2.25,1.75-3.14,2.22-9.45,4.97-18.41,10.6-26.19,18.06-10.02,9.61-17.11,21.17-23.1,33.5-9.15,18.82-18.11,37.72-27.35,56.49-4.56,9.27-9.79,18.13-17.29,25.47-5.59,5.47-12.02,7.49-19.6,5.69-1.93-.46-3.79-1.2-5.67-1.85-7.69-2.64-15.32-5.47-23.08-7.9-8.59-2.69-17.37-2.07-26.15-.84-12.71,1.78-24.91,5.61-37.19,9.14-3.03.87-6.1,1.61-9.13,2.47-1.27.36-2.58.74-3.7,1.4-1.61.96-1.75,2.92-.43,4.27.46.47,1.07.78,1.63,1.14,10.25,6.5,20.5,13,30.77,19.48,7.62,4.8,15.52,8.93,24.45,10.88,8.24,1.8,16.48,1.74,24.71.35,5.51-.93,10.95-2.34,17.13-3.7-.92,1.86-1.55,3.28-2.29,4.63-7.22,13.26-11.28,27.25-10.14,42.52.5,6.7,2.21,13.08,4.71,19.27.68,1.69,1.47,3.34,2.2,5.01,3.5,8.04,7.96,15.7,9.39,24.59,2.68-.06,3.95-1.7,5.35-3,8.97-8.3,15.19-18.42,19.57-29.74,4.53-11.71,6.84-23.88,8.14-36.34,1.04-9.98.9-19.96.61-29.94-.49-17,5.18-31.98,14.67-45.7,10.57-15.28,24.38-27.15,39.8-37.33,14.07-9.29,29.2-16.45,44.79-22.74,15.11-6.1,29.85-12.94,43.64-21.74,12.47-7.96,23.26-17.75,32.76-29.02.96-1.14,1.95-2.24,3.12-3.58Z" style="fill:#00558c; stroke-width:0px;"/>
			<path d="m948.07,304.56c6.82-18.64,17.22-80.01,15.33-96.36-12.01-2.94-24.2-5.93-36.55-8.96v-13.77h41.05c-3.61-2.02-4.36-4.88-4.4-8.74-.1-11.38-10.27-20.87-22.33-21.27-8.01-.26-15.32,2.42-22.59,5.39-4.9,2.01-9.85,4-14.93,5.47-11.63,3.38-23.02,1.98-34.09-2.56-6.3-2.58-12.64-5.09-18.78-8-8.2-3.89-16.77-5.19-25.73-4.65-17.01,1.02-33.91-.14-50.75-2.51-6.42-.9-12.85-1.65-19.56-2.51,2-2.41,4.8-1.88,7.04-2.28,9.01-1.59,18.09-2.61,27.29-2.54,17.86.14,35.47-1.85,52.81-6.31,12.58-3.23,25.42-4.98,38.44-5.17,7.87-.11,15.49,1.8,23.2,3,4.43.69,8.88,1.22,13.34,1.65,4.13.4,8.29.9,12.43.78,7.3-.21,14.59-1.04,21.89-1.27,13.24-.41,25.83,1.93,36.72,10.11,5.93,4.45,8.89,10.45,7.45,17.86-1.42,7.3-6.3,11.88-13.16,14.41-1.68.62-3.43,1.03-5.29,1.58.33,4.06,3.79,5.06,6.09,7.49h35.92v13.8c-11.8,2.99-23.81,6.03-36.13,9.15-9.83,34.4-14.39,69.83-20.47,105.23,55.66,37.88,96.91,87.68,122.86,149.85,15.57,37.29,23.75,76.26,24.97,117.23-83.23,9.46-166.01,7.49-249.09-4.43.92-1.44,1.58-2.53,2.3-3.58,6.5-9.46,12.98-18.93,19.53-28.36,7.96-11.44,17.87-21,28.54-29.89,5.99-4.99,11.37-10.71,16.98-16.15.94-.92,1.66-2.07,2.44-3.15,4.27-5.91,5.01-12.22,1.81-18.81-1.81-3.72-3.71-7.43-5.93-10.93-3.56-5.62-7.41-11.05-11.15-16.56-.28-.41-.58-.82-.88-1.21-3.41-4.36-3.34-8.56-.16-13.2,8.01-11.65,15.14-23.84,21.93-36.25,11.11-20.3,18.94-41.66,22.21-64.64.91-6.41,2.14-12.77,3.29-19.58-4.36-2.8-8.65-5.56-13.23-8.5-1.84,5.76-3.55,11.29-5.38,16.78-5.6,16.76-12.14,33.11-22.66,47.49-5.7,7.79-11.93,15.18-17.83,22.81-8.96,11.58-18.08,23.05-26.7,34.88-11.23,15.41-16.5,32.76-15.88,51.92.32,9.98-.4,19.94-1.83,29.83-2.31,15.9-8.07,30.13-20.28,41.16-6.22,5.62-13.32,9.93-20.79,13.66-10.04,5.01-10.02,4.87-20.88,3.2-13.63-2.1-27.29-4-40.95-5.84-12.35-1.67-24.71-3.25-37.09-4.65-8.59-.97-17.21-1.65-25.83-2.32-12.59-.99-25.19-1.95-37.8-2.73-6.31-.39-12.65-.44-18.98-.53-14.64-.21-29.3-.75-43.93-.42-16.11.37-32.22,1.39-48.3,2.49-11.27.77-22.53,1.93-33.74,3.34-12.36,1.55-24.67,3.52-36.97,5.45-8.37,1.32-16.69,2.91-25.03,4.36-.62.11-1.26.09-1.91.13,3.29-77.35,44.26-183.38,144.94-251.68,102.97-69.85,241.66-78.38,357.15-10.24Zm-65.71,90.32c-2.16-9.19-7.99-14.58-16.39-17.49-8.45-2.92-16.99-2.66-25.55-.44-8.88,2.3-16.94,6.19-22.81,13.43-9.88,12.19-10.69,25.7-4.79,39.84,1.27,3.04,3.2,5.8,4.91,8.84-22.31,12.35-33.37,30.8-28.92,56.72,2.68,15.58,16.83,29.32,29.24,32.95-1.17-8.8-.93-17.52,1.13-26.2,4.71-19.79,14.9-36.52,28.8-51.06,5.03-5.26,10.75-9.86,16.22-14.82-5.78-8.85-12.25-17.71-14.71-29.16,4.98.39,9.52.74,14.12,1.1.44-1.26.83-2.01.95-2.8.66-4.28,3.07-6.65,7.33-7.62,3.51-.8,6.9-2.15,10.46-3.3Z" style="fill:#00558c; stroke-width:0px;"/>
			<path d="m514.63,1002.37h66.58c46.76,85.85,93.61,171.87,140.52,257.99-3.94.91-61.56,1.07-66.94.24-4.69-8.73-9.49-17.63-14.28-26.55-4.71-8.76-9.4-17.54-14.1-26.31h-156.99c-9.47,17.63-18.96,35.31-28.36,52.82-5.26.88-62.92.71-66.94-.26,46.85-86,93.63-171.89,140.5-257.93Zm33.56,57.86c-18.22,32-48.67,89.22-49.53,93.1h99.45c-16.71-31.16-33.17-61.86-49.92-93.1Z" style="fill:#00558c; stroke-width:0px;"/>
			<path d="m1268.26,1207.75h-156.96c-9.5,17.68-19,35.35-28.55,53.12h-65.92c-.14-.26-.23-.4-.28-.54-.05-.15-.13-.34-.08-.47.24-.62.47-1.24.79-1.82,46.38-85.17,92.76-170.34,139.16-255.55h66.72c46.68,85.7,93.52,171.7,140.38,257.74-3.85,1.16-51.1,1.58-66.73.63-4.67-8.69-9.46-17.59-14.24-26.49-4.78-8.9-9.56-17.81-14.3-26.62Zm-28.29-54.45c-16.74-31.2-33.24-61.95-49.98-93.16-16.93,31.33-33.66,62.08-50.31,93.16h100.29Z" style="fill:#00558c; stroke-width:0px;"/>
			<path d="m833.62,1206.79h167.58c-10.12,18.63-20.27,36.27-30.21,54.12h-197.19c-.31-.31-.45-.42-.54-.55-.09-.13-.2-.28-.22-.43-.08-.99-.18-1.98-.18-2.97,0-84.47.03-168.93.06-253.4,0-.29.29-.58.54-1.05h60.17v204.29Z" style="fill:#00558c; stroke-width:0px;"/>
			<path d="m318.27,1260.84h-60.35v-257.88c3.73-.81,53.48-1.01,60.35-.23v258.11Z" style="fill:#00558c; stroke-width:0px;"/>
		</svg>
	</xsl:variable>
</xsl:stylesheet>
