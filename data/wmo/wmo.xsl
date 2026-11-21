<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">
	<!-- WMO taste PDF stylesheet. Fork of data/iala/iala.xsl, reskinned
	     to the WMO corporate visual identity (June 2016) with IHO
	     conjunction hints. Applied to the base iho XSL via the
	     pdf stylesheet override flag. NEVER modify iho.standard.xsl
	     nor iho.specification.xsl. -->

	<xsl:variable name="marginTop">24</xsl:variable>
	<xsl:variable name="marginBottom">20</xsl:variable>
	<xsl:variable name="marginLeftRight1">28</xsl:variable>
	<xsl:variable name="marginLeftRight2">28</xsl:variable>

	<!-- CORPORATE COLOURS -->
	<xsl:variable name="color_corporate_blue">rgb(32, 86, 174)</xsl:variable>
	<xsl:variable name="color_corporate_light_blue">rgb(38, 184, 215)</xsl:variable>
	<xsl:variable name="color_corporate_yellow">rgb(248, 156, 14)</xsl:variable>
	<xsl:variable name="color_corporate_gradient_blue_start">rgb(34, 154, 59)</xsl:variable>
	<xsl:variable name="color_corporate_gradient_blue_end">rgb(45, 167, 73)</xsl:variable>

	<!-- PRIMARY COLOURS -->
	<xsl:variable name="color_primary_recommendation">rgb(32, 86, 174)</xsl:variable>
	<xsl:variable name="color_primary_recommendation_50">rgb(143, 170, 214)</xsl:variable>
	<xsl:variable name="color_primary_recommendation_20">rgb(226, 235, 247)</xsl:variable>
	<xsl:variable name="color_primary_model_course">rgb(102, 197, 68)</xsl:variable>
	<xsl:variable name="color_primary_model_course_50">rgb(198, 231, 181)</xsl:variable>
	<xsl:variable name="color_primary_model_course_20">rgb(238, 248, 233)</xsl:variable>
	<xsl:variable name="color_primary_">rgb(38, 184, 215)</xsl:variable>
	<xsl:variable name="color_primary_50">rgb(144, 219, 235)</xsl:variable>
	<xsl:variable name="color_primary_20">rgb(224, 243, 249)</xsl:variable>
	<xsl:variable name="color_primary_guideline">rgb(32, 86, 174)</xsl:variable>
	<xsl:variable name="color_primary_guideline_50">rgb(143, 170, 214)</xsl:variable>
	<xsl:variable name="color_primary_guideline_20">rgb(226, 235, 247)</xsl:variable>
	
	<!-- SECONDARY COLOURS -->
	<xsl:variable name="color_secondary_purple">rgb(248, 156, 14)</xsl:variable>
	<xsl:variable name="color_secondary_purple_50">rgb(251, 205, 134)</xsl:variable>
	<xsl:variable name="color_secondary_purple_20">rgb(253, 233, 205)</xsl:variable>
	<xsl:variable name="color_secondary_green">rgb(102, 197, 68)</xsl:variable>
	<xsl:variable name="color_secondary_green_50">rgb(198, 231, 181)</xsl:variable>
	<xsl:variable name="color_secondary_green_20">rgb(238, 248, 233)</xsl:variable>
	<xsl:variable name="color_secondary_red">rgb(230, 56, 17)</xsl:variable>
	<xsl:variable name="color_secondary_red_50">rgb(246, 174, 135)</xsl:variable>
	<xsl:variable name="color_secondary_red_20">rgb(253, 224, 208)</xsl:variable>
	<xsl:variable name="color_secondary_gray">rgb(87, 87, 86)</xsl:variable>
	<xsl:variable name="color_secondary_gray_50">rgb(157, 157, 156)</xsl:variable>
	<xsl:variable name="color_secondary_gray_20">rgb(218, 218, 218)</xsl:variable>
	<xsl:variable name="color_secondary_gray_10">rgb(237, 237, 237)</xsl:variable>

	<xsl:variable name="color_toc_title">rgb(32, 86, 174)</xsl:variable>

	<!-- ============================================================ -->
	<!-- Document kind switches                                       -->
	<!-- ============================================================ -->
	<xsl:variable name="iala_doctype_alias" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:doctype-alias)"/>
	<xsl:variable name="iala_is_report" select="$iala_doctype_alias = 'report'"/>
	<xsl:variable name="iala_is_manual" select="$iala_doctype_alias = 'manual'"/>

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
	<xsl:variable name="iala_is_letter" select="contains($iala_doctype_full_lc, 'letter')"/>
	<xsl:variable name="iala_is_resolution" select="not($iala_is_letter) and (contains($iala_doctype_full_lc, 'assembly') or contains($iala_doctype_full_lc, 'resolution'))"/>
	<xsl:variable name="iala_is_rescirc" select="$iala_is_letter or $iala_is_resolution"/>
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
	<xsl:variable name="iala_guide_family" select="not($iala_is_report) and not($iala_is_manual) and not($iala_is_rescirc) and not($iala_is_standard) and not($iala_is_recommendation)"/>
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
		<xsl:attribute name="font-family">Verdana, DejaVu Sans, Arial, Calibri, Cambria Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
		<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
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
					
					<!-- WMO running header: the main title, as printed centred
					     in the page head (WMO-No. 1364). -->
					<title_header><xsl:value-of select="normalize-space(/mn:metanorma/mn:bibdata/mn:title[@type = 'main' and (@language = 'en' or normalize-space(@language) = '')])"/></title_header>

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

<!-- END layout-master-set -->

	<!-- Shadow of the base layout-master-set: identical masters except
	     the cover page, which is full-bleed with the WMO green field as
	     the region background. -->
<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<!-- cover page -->
			<fo:simple-page-master master-name="back-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="0mm" margin-bottom="0mm" margin-left="0mm" margin-right="0mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="0mm" margin-bottom="0mm" margin-left="0mm" margin-right="0mm" background-color="{$wmo_cover_region_color}">
					<xsl:if test="normalize-space($wmo_cover_bg_image) != ''">
						<xsl:attribute name="background-image"><xsl:value-of select="normalize-space($wmo_cover_bg_image)"/></xsl:attribute>
						<xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
					</xsl:if>
				</fo:region-body>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="first" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-blank" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="blankpage-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-blank" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<!-- Preface pages -->
			<fo:page-sequence-master master-name="preface">
				<fo:repeatable-page-master-alternatives>
					<!-- <fo:conditional-page-master-reference master-reference="first" page-position="first"/> -->
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="preface-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<!-- Document pages -->
			<fo:page-sequence-master master-name="document">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-portrait">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>

			<!-- Index pages (two columns) -->
			<fo:simple-page-master master-name="index-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm" xsl:use-attribute-sets="indexsect-region-body-style"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="index-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm" xsl:use-attribute-sets="indexsect-region-body-style"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="index">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="index-even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="index-odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template>

	<xsl:template name="cover-page">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" initial-page-number="1">
			<fo:flow flow-name="xsl-region-body">
				<xsl:call-template name="insert_firstpage_id"><xsl:with-param name="num" select="$num"/></xsl:call-template>

				<!-- WMO signature cover: green field with sweeping arcs -->



				<!-- Cover image slot for technical publications: the image
				     is cropped to the band by the SVG viewport. -->
				<xsl:if test="$wmo_cover_class = 'technical'">
					<fo:block-container absolute-position="absolute" left="0mm" top="170mm" width="210mm" height="84mm" font-size="0pt" role="SKIP">
						<fo:block font-size="0pt" role="SKIP">
						<fo:external-graphic src="url({concat($baseassetpath, '/cover-image.jpg')})" content-width="210mm" content-height="84mm" scaling="non-uniform" fox:alt-text="Cover image" fox:placement="Block" />
						</fo:block>
					</fo:block-container>
				</xsl:if>

				<!-- Title: Level 1 (25 pts), left-aligned, white -->
				<fo:block-container absolute-position="absolute" left="29mm" top="58mm" width="150mm" height="70mm">
					<fo:block color="{$wmo_cover_ink}" font-size="25pt" line-height="30pt" font-weight="normal">
						<xsl:variable name="title">
							<xsl:call-template name="getVariableCopyOf"><xsl:with-param name="variable">title</xsl:with-param></xsl:call-template>
						</xsl:variable>
						<xsl:for-each select="xalan:nodeset($title)/item">
							<fo:block>
								<xsl:copy-of select="node()"/>
							</fo:block>
						</xsl:for-each>
					</fo:block>
				</fo:block-container>

				<!-- Edition line, mid page as in the printed series -->
				<fo:block-container absolute-position="absolute" left="29mm" top="149mm" width="120mm">
					<fo:block color="{$wmo_cover_ink}" font-size="10pt" font-weight="bold">
						<xsl:value-of select="substring(normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on), 1, 4)"/><xsl:text> edition</xsl:text>
					</fo:block>
				</fo:block-container>

				<!-- WMO logotype in reverse: emblem above the full name -->
				<fo:block-container absolute-position="absolute" left="29mm" top="200mm" width="80mm">
					<fo:block font-size="0pt" role="SKIP">
						<fo:instream-foreign-object content-width="16mm" fox:alt-text="World Meteorological Organization emblem" fox:placement="Block">
							<xsl:copy-of select="$wmo_cover_emblem"/>
						</fo:instream-foreign-object>
					</fo:block>
					<fo:block color="{$wmo_cover_ink}" font-size="10.5pt" letter-spacing="1.2pt" line-height="1.3" margin-top="2mm">
						<fo:block>WORLD</fo:block>
						<fo:block>METEOROLOGICAL</fo:block>
						<fo:block>ORGANIZATION</fo:block>
					</fo:block>
				</fo:block-container>
				<fo:block-container absolute-position="absolute" left="30mm" top="272mm" width="80mm">
					<fo:block color="{$wmo_cover_ink}" font-size="9pt" font-weight="bold">
						<xsl:call-template name="getVariable"><xsl:with-param name="variable">docidentifier</xsl:with-param></xsl:call-template>
					</fo:block>
				</fo:block-container>

				<!-- IHO conjunction, partner logos on one line, WMO first (B9) -->
				<fo:block-container absolute-position="absolute" left="148mm" top="240mm" width="52mm">
					<fo:block font-size="0pt" role="SKIP">
						<fo:instream-foreign-object content-width="22mm" fox:alt-text="International Hydrographic Organization emblem" fox:placement="Block">
							<xsl:copy-of select="$WMO-IHO-Emblem"/>
						</fo:instream-foreign-object>
					</fo:block>
					<fo:block color="{$wmo_cover_ink}" font-size="6.5pt" line-height="1.4" margin-top="1.5mm">
						<fo:block>In conjunction with the</fo:block>
						<fo:block>International Hydrographic Organization</fo:block>
					</fo:block>

				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END cover-page -->


	<xsl:template name="inner-cover-page">
		<fo:page-sequence master-reference="first" force-page-count="no-force" initial-page-number="1">
			<fo:static-content flow-name="header" role="SKIP"><fo:block font-size="0pt" role="SKIP"><fo:wrapper role="artifact">&#160;</fo:wrapper></fo:block></fo:static-content>
			<fo:static-content flow-name="footer" role="SKIP"><fo:block font-size="0pt" role="SKIP"><fo:wrapper role="artifact">&#160;</fo:wrapper></fo:block></fo:static-content>
			<fo:flow flow-name="xsl-region-body">

				<fo:block-container absolute-position="absolute" left="30mm" top="53mm" width="150mm" height="70mm">
					<fo:block color="black" font-size="25pt" line-height="30pt" font-weight="normal">
						<xsl:variable name="title">
							<xsl:call-template name="getVariableCopyOf"><xsl:with-param name="variable">title</xsl:with-param></xsl:call-template>
						</xsl:variable>
						<xsl:for-each select="xalan:nodeset($title)/item">
							<fo:block>
								<xsl:copy-of select="node()"/>
							</fo:block>
						</xsl:for-each>
					</fo:block>
				</fo:block-container>

				<fo:block-container absolute-position="absolute" left="30mm" top="152mm" width="120mm">
					<fo:block color="black" font-size="10pt" font-weight="bold">
						<xsl:value-of select="substring(normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on), 1, 4)"/><xsl:text> edition</xsl:text>
					</fo:block>
				</fo:block-container>

				<fo:block-container absolute-position="absolute" left="30mm" top="226mm" width="80mm">
					<fo:block font-size="0pt" role="SKIP">
						<fo:instream-foreign-object content-width="13mm" fox:alt-text="World Meteorological Organization emblem" fox:placement="Block">
							<xsl:copy-of select="$WMO-Emblem-BW"/>
						</fo:instream-foreign-object>
					</fo:block>
					<fo:block color="black" font-size="10.5pt" letter-spacing="1.2pt" line-height="1.3" margin-top="2mm">
						<fo:block>WORLD</fo:block>
						<fo:block>METEOROLOGICAL</fo:block>
						<fo:block>ORGANIZATION</fo:block>
					</fo:block>
					<fo:block color="black" font-size="9pt" font-weight="bold" margin-top="2.5mm">
						<xsl:call-template name="getVariable"><xsl:with-param name="variable">docidentifier</xsl:with-param></xsl:call-template>
					</fo:block>
				</fo:block-container>

				<fo:block-container absolute-position="absolute" left="148mm" top="240mm" width="52mm">
					<fo:block font-size="0pt" role="SKIP">
						<fo:instream-foreign-object content-width="22mm" fox:alt-text="International Hydrographic Organization emblem" fox:placement="Block">
							<xsl:copy-of select="$WMO-IHO-Emblem"/>
						</fo:instream-foreign-object>
					</fo:block>
					<fo:block color="black" font-size="6.5pt" line-height="1.4" margin-top="1.5mm">
						<fo:block>In conjunction with the</fo:block>
						<fo:block>International Hydrographic Organization</fo:block>
					</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END inner-cover-page -->


<xsl:template name="refine_list-item-style">
		<xsl:if test="ancestor::mn:table">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="ancestor::mn:clause[mn:fmt-title[normalize-space(.) = 'The Council']][$iala_is_recommendation]">
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
	</xsl:template>

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
		<!-- WMO contents heading: blue capitals at regular heading
			 weight (WMO-No. 1364), no rule beneath. -->
		<xsl:attribute name="font-size">13pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_toc_title"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">8mm</xsl:attribute>
		<xsl:attribute name="text-transform">uppercase</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="toc-style"><?extend?>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-top">6mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-item-block-style">
		<!-- WMO contents entries print black in the authored case with
			 dot leaders (WMO-No. 1364); no bold, no capitalisation. -->
		<xsl:attribute name="line-height">1.4</xsl:attribute>
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
		<!-- WMO: the list headings match the section-heading voice. -->
		<xsl:attribute name="font-size">13pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="margin-top">9mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">6mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_toc_title"/></xsl:attribute>
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
			<fo:block role="SKIP">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_title-style"><?extend?>
		<!-- WMO headings (WMO-No. 1364 body pages): level 1 prints in the
			 WMO blue in capitals at regular weight; deeper levels are
			 black bold in the authored case. -->
		<xsl:if test="$level = 1">
			<xsl:attribute name="text-transform">uppercase</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-size">13pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$level = 2">
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$level = 3">
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$level = 4">
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
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
		<!-- WMO figure captions: bold black, centred (WMO-No. 1364). -->
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<!-- WMO link colour: corporate blue replaces the base generic blue. -->
	<xsl:attribute-set name="link-style"><?extend?>
		<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<!-- WMO admonitions: the box line and the label take the corporate
	     blue; the body text stays black on white (no tint fill). -->
	<xsl:attribute-set name="admonition-style"><?extend?>
		<xsl:attribute name="border">0.5pt solid {$color_corporate_blue}</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-left">16mm</xsl:attribute>
		<xsl:attribute name="margin-right">16mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="admonition-name-style"><?extend?>
		<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
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
			<xsl:when test="not($iala_is_rescirc) and not($iala_is_recommendation) and not($iala_is_standard)">
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
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:call-template name="addNamedDestinationAttribute"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- rescirc annexes set the leading the published resolutions print:
	     the declaration spreads over the page like the reference PDF.
	     The base paragraph refinement is preserved for every other
	     paragraph (justification, keeps, spacing rules). -->
	<xsl:template name="refine_p-style">
		<xsl:param name="element-name"/>
		<xsl:param name="margin"/>
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
		<xsl:if test="not(ancestor::mn:table) and not(ancestor::mn:boilerplate) and not(ancestor::mn:feedback-statement) and not(ancestor::mn:note) and not(ancestor::mn:termnote) and not(ancestor::mn:admonition) and not(ancestor::mn:li)">
			<!-- WMO body: Verdana on the open 130% pitch with a full
				 paragraph step (WMO-No. 1364) -->
			<xsl:attribute name="line-height">130%</xsl:attribute>
			<xsl:attribute name="space-after">10pt</xsl:attribute>
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
	
	<xsl:template match="mn:tbody[count(mn:tr) &lt; 7]" mode="document_revision">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()" mode="document_revision"/>
			<xsl:variable name="tr_count" select="count(mn:tr)"/>
			<xsl:variable name="td_count" select="count(mn:tr[last()]/*)"/>
			<xsl:call-template name="addDocumentRevisionTableRow">
				<xsl:with-param name="tr_count" select="7 - $tr_count"/>
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

	<!-- ============ MODEL COURSE: published PART/MODULE numbering ======= -->
	<!-- The published model courses print unnumbered "PART A / PART B"
			banners and restart the clause numbering beneath each banner:
			the overview clauses number flat (1..13, 10.1), the teaching
			modules number per module (M.x, M.x.y). The C0103-1 era prints
			the module rows themselves as unnumbered "MODULE N" banners. -->
	<xsl:variable name="iala_upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="iala_lower" select="'abcdefghijklmnopqrstuvwxyz'"/>

	<!-- the printed label of a clause in the model-course numbering
			model (shared by the update pass and the contents resolution) -->
	<xsl:template name="iala_mc_label">
		<xsl:param name="clause" select="."/>
		<xsl:variable name="t" select="normalize-space($clause/mn:title)"/>
		<xsl:choose>
			<xsl:when test="$clause[parent::mn:sections][starts-with($t, 'Part ')]">
				<xsl:value-of select="concat('PART ', substring-before(substring-after($t, 'Part '), ' '))"/>
			</xsl:when>
			<xsl:when test="count($clause/ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part ')]) = 0"/>
			<xsl:otherwise>
				<xsl:variable name="part" select="$clause/ancestor::mn:clause[starts-with(normalize-space(mn:title), 'Part ')][1]"/>
				<xsl:variable name="pid" select="generate-id($part)"/>
				<xsl:variable name="chain" select="$clause/ancestor-or-self::mn:clause[ancestor::mn:clause[generate-id() = $pid]]"/>
				<xsl:variable name="chain_nums_">
					<xsl:for-each select="$chain">
						<xsl:sort select="count(ancestor::mn:clause)" data-type="number" order="ascending"/>
						<n v="{count(preceding-sibling::mn:clause) + 1}"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="depth" select="count(xalan:nodeset($chain_nums_)/*)"/>
				<xsl:choose>
					<xsl:when test="$depth = 1 and starts-with($t, 'Module ') and $iala_mc_module_banner">
						<xsl:value-of select="concat('MODULE ', xalan:nodeset($chain_nums_)/*/@v)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($chain_nums_)/*">
							<xsl:if test="position() &gt; 1"><xsl:text>.</xsl:text></xsl:if>
							<xsl:value-of select="@v"/>
						</xsl:for-each>
						<xsl:if test="$depth &lt;= 2"><xsl:text>.</xsl:text></xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- PART banner: unnumbered, "PART A" + tab + capitalised remainder -->
	<xsl:template match="mn:sections/mn:clause[mn:title][starts-with(normalize-space(mn:title), 'Part ')][$iala_is_model_course]/mn:fmt-title" mode="update_xml_step1" priority="4">
		<xsl:variable name="t" select="normalize-space(../mn:title)"/>
		<xsl:variable name="rest">
			<xsl:choose>
				<xsl:when test="contains($t, '&#8211;')"><xsl:value-of select="normalize-space(substring-after($t, '&#8211;'))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="normalize-space(substring-after($t, '- '))"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:span class="fmt-caption-label">
				<xsl:call-template name="iala_mc_label">
					<xsl:with-param name="clause" select=".."/>
				</xsl:call-template>
			</mn:span>
			<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
			<mn:semx element="title"><xsl:value-of select="translate($rest, $iala_lower, $iala_upper)"/></mn:semx>
		</xsl:copy>
	</xsl:template>

	<!-- Flat numbering restarts beneath the PART banner; the C0103-1
			module rows become "MODULE N" banners, the C2007-1 module rows
			stay numbered clauses -->
	<xsl:template match="mn:sections/mn:clause[mn:title][starts-with(normalize-space(mn:title), 'Part ')][$iala_is_model_course]/mn:clause/mn:fmt-title" mode="update_xml_step1" priority="4">
		<xsl:variable name="t" select="normalize-space(../mn:title)"/>
		<xsl:choose>
			<xsl:when test="$iala_mc_module_banner and starts-with($t, 'Module ')">
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="update_xml_step1"/>
					<mn:span class="fmt-caption-label">
						<xsl:call-template name="iala_mc_label">
							<xsl:with-param name="clause" select=".."/>
						</xsl:call-template>
					</mn:span>
					<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
					<mn:semx element="title"><xsl:value-of select="translate(normalize-space(substring-after($t, ':')), $iala_lower, $iala_upper)"/></mn:semx>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title" select="translate($t, $iala_lower, $iala_upper)"/>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="update_xml_step1"/>
					<mn:span class="fmt-caption-label">
						<xsl:call-template name="iala_mc_label">
							<xsl:with-param name="clause" select=".."/>
						</xsl:call-template>
					</mn:span>
					<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
					<mn:semx element="title"><xsl:value-of select="$title"/></mn:semx>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Deeper clauses beneath a PART banner number through the clause
			chain (M.x, M.x.y); the two top chain levels carry the printed
			trailing dot -->
	<xsl:template match="mn:sections/mn:clause[mn:title][starts-with(normalize-space(mn:title), 'Part ')][$iala_is_model_course]/mn:clause/mn:clause/mn:fmt-title | mn:sections/mn:clause[mn:title][starts-with(normalize-space(mn:title), 'Part ')][$iala_is_model_course]/mn:clause/mn:clause/mn:clause/mn:fmt-title" mode="update_xml_step1" priority="4">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<mn:span class="fmt-caption-label">
				<xsl:call-template name="iala_mc_label">
					<xsl:with-param name="clause" select=".."/>
				</xsl:call-template>
			</mn:span>
			<mn:span class="fmt-caption-delim"><mn:tab/></mn:span>
			<xsl:apply-templates select="node()[not(self::mn:span[@class = 'fmt-caption-label' or @class = 'fmt-autonum-delim' or @class = 'fmt-caption-delim'])]" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- Published model courses carry no List of Tables / Figures in
			their contents; the other doctypes keep them (rendered through
			the base collection logic, alt-texts included). -->
	<xsl:template name="processTables_Contents">
		<xsl:choose>
			<xsl:when test="$iala_is_model_course">
				<!-- published model courses carry no List of Tables -->
			</xsl:when>
			<xsl:otherwise>
				<mnx:tables>
					<xsl:for-each select="//mn:table[not(ancestor::mn:metanorma-extension)][@id and mn:fmt-name and normalize-space(@id) != '']">
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
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processFigures_Contents">
		<xsl:choose>
			<xsl:when test="$iala_is_model_course">
				<!-- published model courses carry no List of Figures -->
			</xsl:when>
			<xsl:otherwise>
				<mnx:figures>
					<xsl:for-each select="//mn:figure[@id and mn:fmt-name and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(mn:name, 'Figure ') and normalize-space(@id) != '']">
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
			</xsl:otherwise>
		</xsl:choose>
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
			<xsl:when test="$iala_is_model_course and self::mn:clause[mn:title]">
				<xsl:call-template name="iala_mc_label">
					<xsl:with-param name="clause" select="."/>
				</xsl:call-template>
			</xsl:when>
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
		<xsl:variable name="skip_leading_break" select="parent::mn:annex and not(preceding-sibling::*[not(self::mn:fmt-title)])"/>
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
		<xsl:variable name="first_tbl" select="mn:table[not(preceding-sibling::*[not(self::mn:fmt-title)])][1]"/>
		<xsl:if test="$first_tbl">
			<xsl:variable name="wide">
				<xsl:call-template name="is_iala_wide_table">
					<xsl:with-param name="table" select="$first_tbl"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="normalize-space($wide) = 'true'">
				<mn:pagebreak from_source_xml="true" orientation="landscape"/>
			</xsl:if>
		</xsl:if>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
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
				<!-- Circular letter: centered logo, then the letter number
				     and the date right-aligned, as printed -->
				<fo:block text-align="center" margin-top="6mm">
					<fo:instream-foreign-object content-width="34mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
						<xsl:copy-of select="$IALA-Logo-full"/>
					</fo:instream-foreign-object>
				</fo:block>
				<fo:block text-align="right" margin-top="14mm" margin-right="2mm">
					<xsl:text>Circular Letter </xsl:text>
					<xsl:value-of select="$iala_docidentifier"/>
				</fo:block>
				<fo:block text-align="right" margin-top="6mm" margin-right="2mm">
					<xsl:call-template name="rescirc_date"/>
				</fo:block>
				<fo:block font-size="0pt" margin-bottom="26mm">&#xa0;</fo:block>
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
						     adoption lines, then the title -->
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
						<fo:block text-align="right" font-weight="bold" margin-top="16mm" margin-right="2mm">
							<xsl:text>IALA General Assembly Resolution </xsl:text>
							<xsl:value-of select="$iala_docidentifier"/>
						</fo:block>
						<fo:block text-align="right" margin-top="6pt" margin-right="2mm">
							<xsl:text>Adopted on </xsl:text>
							<xsl:call-template name="rescirc_date"/>
						</fo:block>
						<fo:block font-weight="bold" font-size="11pt" text-transform="uppercase" color="{$color_primary_recommendation}" margin-top="16mm">
							<xsl:value-of select="$iala_title_en"/>
						</fo:block>
						<fo:block font-size="0pt" margin-bottom="10mm">&#xa0;</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<!-- A1x assembly resolutions (A13): docidentifier
						     top right, centered logo, then the body -->
						<fo:block text-align="right" font-size="10pt" margin-right="2mm">
							<xsl:text>Resolution </xsl:text>
							<xsl:value-of select="$iala_docidentifier"/>
						</fo:block>
						<fo:block text-align="center" margin-top="6mm">
							<fo:instream-foreign-object content-width="26mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
								<xsl:copy-of select="$IALA-Logo-full"/>
							</fo:instream-foreign-object>
						</fo:block>
						<fo:block font-size="0pt" margin-bottom="9mm">&#xa0;</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_table-header-row-style"><?extend?>
		<xsl:attribute name="background-color">transparent</xsl:attribute>
		<!-- WMO: bold black header row (WMO-No. 1364), no fill. -->
		<xsl:attribute name="color">black</xsl:attribute>
	</xsl:template>

	<xsl:attribute-set name="table-style"><?extend?>
		<!-- WMO tables rule like booktabs: the table frame keeps the top
			 and bottom rules; the side frame drops (FOP resolves the
			 internal verticals against the table-level border too). -->
		<xsl:attribute name="border-left">none</xsl:attribute>
		<xsl:attribute name="border-right">none</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_table-header-cell-style"><?extend?>
		<xsl:attribute name="padding-left">4mm</xsl:attribute>
		<!-- WMO tables rule like booktabs (WMO-No. 1364): horizontal
			 rules only, no verticals and no outer side frame. -->
		<xsl:attribute name="border-left">none</xsl:attribute>
		<xsl:attribute name="border-right">none</xsl:attribute>
		<xsl:if test="ancestor::mn:table[@landscape = 'true'] and $iala_compact_landscape">
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
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
		<!-- WMO tables rule like booktabs: horizontal rules only. -->
		<xsl:attribute name="border-left">none</xsl:attribute>
		<xsl:attribute name="border-right">none</xsl:attribute>
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
			<!-- WMO lists print black markers (WMO-No. 1364) -->
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
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

	<xsl:template name="insertFooter">
		<fo:static-content flow-name="footer" role="artifact">
			<fo:block font-size="0pt" role="SKIP"><fo:wrapper role="artifact">&#160;</fo:wrapper></fo:block>
		</fo:static-content>
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

	<!-- ==================== WMO corporate identity ==================== -->
	<!-- Palette sampled from the printed WMO-No. 574 (2024) and
	     WMO-No. 1364 (2025) covers; band colours per B2 of the
	     corporate visual identity guidelines (June 2016). -->
	<xsl:variable name="wmo_blue">rgb(32, 86, 174)</xsl:variable>
	<xsl:variable name="wmo_turquoise">rgb(38, 184, 215)</xsl:variable>
	<xsl:variable name="wmo_green">rgb(102, 197, 68)</xsl:variable>
	<xsl:variable name="wmo_gold">rgb(248, 156, 14)</xsl:variable>
	<xsl:variable name="wmo_cover_green">rgb(34, 154, 59)</xsl:variable>
	<xsl:variable name="wmo_cover_green_mid">rgb(37, 158, 64)</xsl:variable>
	<xsl:variable name="wmo_cover_green_light">rgb(45, 167, 73)</xsl:variable>
	<xsl:variable name="wmo_cover_green_dark">rgb(30, 143, 52)</xsl:variable>

	<!-- WMO publication-class colours (Pantone Coated approximations,
	     B5 of the corporate visual identity guidelines). -->
	<xsl:variable name="wmo_back_blue">rgb(0, 91, 170)</xsl:variable>
	<xsl:variable name="wmo_pantone_187">rgb(200, 16, 46)</xsl:variable>
	<xsl:variable name="wmo_pantone_341">rgb(0, 118, 114)</xsl:variable>
	<xsl:variable name="wmo_pantone_108">rgb(254, 209, 65)</xsl:variable>
	<xsl:variable name="wmo_pantone_196">rgb(244, 181, 200)</xsl:variable>
	<xsl:variable name="wmo_pantone_368">rgb(162, 214, 45)</xsl:variable>

	<!-- Document-class detection: the bibdata doctype, refined by the
	     wmo-cover-class presentation metadata, which carries the WMO
	     publication class injected per doctype by the taste config
	     (the presentation stage overwrites doctype-alias, so this
	     dedicated carrier key is used instead). -->
	<xsl:variable name="wmo_doctype" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) = ''])"/>
	<xsl:variable name="wmo_doctype_alias" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:wmo-cover-class)"/>

	<xsl:variable name="wmo_cover_class">
		<xsl:choose>
			<xsl:when test="$wmo_doctype = 'manual' or $wmo_doctype_alias = 'manual'">manual</xsl:when>
			<xsl:when test="$wmo_doctype = 'guide' or $wmo_doctype_alias = 'guide'">guide</xsl:when>
			<xsl:when test="$wmo_doctype_alias = 'ec-report' or $wmo_doctype_alias = 'congress-report'">report-yellow</xsl:when>
			<xsl:when test="$wmo_doctype_alias = 'ra-report'">report-pink</xsl:when>
			<xsl:when test="$wmo_doctype_alias = 'tc-report'">report-light-green</xsl:when>
			<xsl:when test="$wmo_doctype = 'guideline' or $wmo_doctype_alias = 'guideline'">guideline</xsl:when>
			<xsl:otherwise>technical</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Solid cover background: empty for the arc covers. -->
	<xsl:variable name="wmo_cover_solid">
		<xsl:choose>
			<xsl:when test="$wmo_cover_class = 'manual'"><xsl:value-of select="$wmo_pantone_187"/></xsl:when>
			<xsl:when test="$wmo_cover_class = 'guide'"><xsl:value-of select="$wmo_pantone_341"/></xsl:when>
			<xsl:when test="$wmo_cover_class = 'report-yellow'"><xsl:value-of select="$wmo_pantone_108"/></xsl:when>
			<xsl:when test="$wmo_cover_class = 'report-pink'"><xsl:value-of select="$wmo_pantone_196"/></xsl:when>
			<xsl:when test="$wmo_cover_class = 'report-light-green'"><xsl:value-of select="$wmo_pantone_368"/></xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>

	<!-- Cover background layer: the green arcs bitmap for the guideline
	     and technical classes only; all other classes are plain Pantone
	     solids with no raster image. Resolves against the baseassetpath
	     mn2pdf passes. -->
	<xsl:variable name="wmo_cover_art_file">
		<xsl:choose>
			<xsl:when test="$wmo_cover_class = 'guideline' or $wmo_cover_class = 'technical'">wmo-cover-art.png</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="wmo_cover_bg_image">
		<xsl:choose>
			<xsl:when test="normalize-space($wmo_cover_art_file) = ''"/>
			<xsl:when test="normalize-space($baseassetpath) != ''">
				url(<xsl:value-of select="concat($baseassetpath, '/', $wmo_cover_art_file)"/>)
			</xsl:when>
			<xsl:otherwise>url(<xsl:value-of select="$wmo_cover_art_file"/>)</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Region paint: the class Pantone on the plain covers, the green
	     field under the arcs bitmap on the arc covers. -->
	<xsl:variable name="wmo_cover_region_color">
		<xsl:choose>
			<xsl:when test="normalize-space($wmo_cover_solid) != ''"><xsl:value-of select="$wmo_cover_solid"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$wmo_cover_green"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="wmo_cover_ink">
		<xsl:choose>
			<xsl:when test="$wmo_cover_class = 'report-yellow' or $wmo_cover_class = 'report-pink' or $wmo_cover_class = 'report-light-green'"><xsl:value-of select="$wmo_blue"/></xsl:when>
			<xsl:otherwise>white</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Emblem variant: reverse (white, gold rose) on the dark classes,
	     blue-and-gold on the light Pantone solids. -->
	<xsl:variable name="wmo_cover_emblem">
		<xsl:choose>
			<xsl:when test="$wmo_cover_class = 'report-yellow' or $wmo_cover_class = 'report-pink' or $wmo_cover_class = 'report-light-green'">
				<xsl:copy-of select="$WMO-Emblem-Blue"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$WMO-Emblem-Reverse"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Base asset path supplied by mn2pdf as the baseassetpath
	     stylesheet parameter; declared here because the base
	     stylesheet does not declare it. -->
	<xsl:param name="baseassetpath"/>
	<!-- Technical publications carry a cover image over the arcs
	     (B14); the file resolves against the baseassetpath passed by
	     mn2pdf, falling back to the working directory. -->
	<xsl:variable name="wmo_cover_image">
		<xsl:choose>
			<xsl:when test="normalize-space($baseassetpath) != ''">
				<xsl:value-of select="concat($baseassetpath, '/cover-image.jpg')"/>
			</xsl:when>
			<xsl:otherwise>cover-image.jpg</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- WMO emblem, reverse (white emblem, gold wind rose) and
	     black-and-white interior variant per A1/A5. -->
	<xsl:variable name="WMO-Emblem-Blue">
<svg viewBox="0 0 248 272" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:2"><path d="m16.174 37.477-.251.5-.387.023-.257.659-.338.691-.002.985-1.464.014-.235.145-.655-.028-.41-.413-.501.058-.43.178-.538-.064-.166.269-.141.663-.035.864.334.288-.034.866.667.618.08-.978.678.343.059-.468.41.295.023.431.422.06.593.538.285.602.76.268.1.361 1.384 1.006 1.879.241.514.614.932-.197.585-.129.966-.076.176-.543-.6-1.323-.952-1.265-.038-.946-.021-.473-.478-.534.025-.629.248-.421-.131-.556-.429.1.045-1.061-.646-1.172.052-.353-.255-.403.208-.343.464-.061.142-.623.546-.171.024-.589-.183-.282.217-.545.471-.253.383.056.043.866.187.126-.2.191.142.322-.02.471-.242.303.303 1.075.29-.537.228.088.334.33 1.036.085-.014.355.391-.099.175.398.339.212.268.052-.057.429.287-.421.046.712.376.293.024-.588.273-.107.024-.549.514-.371.018-.432.57.142.186-.738.448-.611.215-.542.417.176-.017.433-.239.187.259.247-.393.179-.315.143.029.278-.122.192-.28.223-.134.465-.321.302s.453.256.568.222c.119-.035.967-.075.967-.075l.09-.349.314-.146.505-.054.151-.861.369-.572-.478-.534-.158.032-.122.23.028-.707-.337-.288.019-.474-.375-.252-.052.354-.16.149-.186-.166.253-.5-.03-.238-.272.066-.391.141-.027-.318.192.048.352-.14-.095-.516.891-.078.438-.415-.014-.589.274-.068.01-.234-.23-.051-.026-.315.276-.185.547-.213.012-.234-1.09.225-.304-.05.057-.473-.195.071-.324.419-.135.428-.63.365-.537-.065-.174-.44-.31-.013-.167.388-.542.012-.867-.509-.877-.198-.55.252-.932.194-.711.44-.161.152.266.088.507-.174.507-.135.229.089-.086.192-.463.022-1.049.227-.579.053-.291.461-.088.309-.282.303.091.596-.17.424-.207.303-.049.314-.202.188-.016.394-.341-.132.007.786-.213.505.102.357-.241.225-.537-.062-.489-.297-.423-.021Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m19.753 36.573-.3-.17-.059.511.178.397-.356.224-.026.625.248.525.237.836.07-.782.253-.542-.391.141.019-.472.213-.54-.211-.482.125-.271Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m19.948 37.526-.088.311.298.212-.103-.28-.107-.243ZM12.134 44.931l.057.514.262.209-.012.237.306.053-.02-.395-.214-.48-.379-.138ZM16.353 51.104l.385.056.028.197.295.287-.323.381-.398-.609.013-.312ZM38.542 45.481l.124-.193.228.049.443.531-.054.352.191.087-.004 1.063-.277.183-.436.257-.31.026.03-.746-.183-.206.019-.51.358-.259-.02-.473-.223-.169.114.008ZM33.856 43.264l-1.117-.051.832.391 1.055.601 1.435-.255.144-.659.354-.18.202.676.005.867.087.708-.371.576-.019.47.601.384.287.524-.025.628-.44.415-.081 1.059-.206.304-.147.742-.883.867-.627.285-.361.378-.576-.026-.366.455-.719-.308-.635-.499-.135-.517-.459-.019-.58-.933.214-.542-.392-.806-.792-.389-.704-.738-1.419-.142-.257-.289-1.236.025-.6-.382.053-.352-.662-.777.245-.383.229-.816.901-.391.327-.498.389-.063.275-.145.613.108.278-.223 1.047-.11.298.207 1.287-.334.197-.15.456.139.439-.375.433-.177.395-.298-.148-.163-.538.015-.518.409-.385-.014-.134-.481.752-.518.657-.049.131-.388-.685-.185-.343-.095-.24.226.146.163-.158.111-.417-.177-.012.355-.056.391.07.197-.123.154.145.205-.276.181-.033-.157.047-.195-.338-.21-.376-.255s-.534-.104-.539.017c-.004.118.101.358.101.358l.451.293.303.094.032.199-.149-.125-.123.152-.126.271-.109-.164-.025-.317-.342-.132-.462-.019-.576-.027-.025.61-.221.205-.544.093-.193.049-.203-.184-.188-.182.111-.354.102-.131.256-.106.443-.02.185-.289-.412-.274.32-.299.486-.116.099-.508.235-.086-.007.154-.119.055.035.099.641-.128.333-.124.055-.447.649-.286-.049-.241-.363-.075-.154-.46-.233.013-.201.225.038.491-.329.558-.271-.011-.007-.314-.4.354.019-.45.075-.41.496-.393.214-.935.316-.222.559.005.238-.165-.1-.399.034-.39.142-.153.051-.295-.307-.071.011-.235.181-.189-.154-.46-.672-.108.049-.195.217-.147.39-.121-.21-.483v-.529l-.345-.036-.26-.229.142-.19.118-.527-.653-.048-.2.109-.707-.543-.215-.384.203-.285.506-.114.146-.27-.377-.231.085-.216.284.17.746.093.286-.381-.043-.375.793-.102s.031.236.09.182c.061-.056-.148.305-.148.305l-.401.398.241.227.071.14.306.092.03.219.429-.121.27-.065s-.082-.813.053-.803c.133.005.678-.109.678-.109l.576.066.234.383.734.035-.091-.655.525-.136.691.111-.595.387-.375.674.281.207.028.257.217-.622-.048-.214.274-.088.132.535.286-.439-.143-.219.277-.168.334.251.402.117.521-.036.399.589-.007.156.459.138.057.495.257-.165.38-.338.341.093.439.57-.111.9.541-.055.038-.468.212-.05.087-.192.176-.112.128-.288.087.693-.198.167-.124.191-.106.292-.392.1-.712.026-.197.525.046.354-.364.398-.069.253-.457.374.045.258.303.131.14.4.172.025.123.283.071.653.227.069.048.238.304.111.177.421-.18.171-.407.019-.765.361-.244-.152-.384-.054-.012.315-.599.011-.547.666-.375.709-.384-.037-.189.387-.624.149.01.277.262.167.387-.022.335-.632.758-.184.201.739-.451.665-.007.593-.215.601-.083.154-.113-.103-.448.135-.491-.239-.158.153-.676-.464Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m37.083 42.068-.183.231.022.393.167.164.159-.129-.04-.435.062-.097-.187-.127ZM39.149 38.146l.169-.328.422.019.029.18s.312-.046.29.011c-.022.062-.046.178-.046.178l-.165.266-.169-.045-.53-.281ZM40.067 35.431l.029-1.137.367-.066.125-.679-.171-.542.365-.415-.209-.581-.452-.236-.657.05-.07-.653-.545-.34.032-.295.305.055-.412-.274.406-.081.06-.549-.546-.28-.13-.655-.599.091-.05-.179.139-.071.074-.429-.451-.297-.034-.592-.692-.464-.093-.574-.222-.187-.251-.071-.268-.484.148-.251-.146-.279-.571-.165.306-.437-.499-.497.006-.135.823.096.088.2.014.65.373.253.533.18.602.814-.325.005-.196.011.417.629.123.299.363.077.063.339-.033.391.285.072.31.465.333.309.298.723.178-.092.701 1.744.375-.276s-.219-.265-.196-.384c.025-.116-.249-.503-.19-.5.057.002.232-.069.232-.069s.278.306.255.385c-.023.076.157.421.157.421l.06.908.152.479-.072.804-.2.245.103.28-.06 1.042-.297.202-.384.87-.179.127Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m39.355 27.844.306.054.179.32-.016.395s-.154.033-.192-.048c-.033-.08-.123-.262-.123-.262s-.208-.067-.186-.144c.022-.078.032-.315.032-.315ZM39.995 28.659l.189.108.128.184-.119.544-.173-.047-.025-.295-.167-.146.167-.348ZM31.476 30.7l.382.057.157-.051.247.049.103.341.697-.561.606-.189s.522.378.58.38c.059.004.367.017.367.017l.962-.017-.708-.563-.443-.018-.139.092.008-.217-.646-.166-.37.1-.089.253-.414.258-.519-.064-.108-.164-.153-.024-.045.195-.213-.027-.028.194-.232.048-.002.077ZM35.91 31.096l.18-.169.384.016.107.183-.219.226-.233.009-.034-.121-.185-.144ZM36.749 31.231l.132-.387.218-.109-.003-.374.158-.151.012-.256-.152-.066.413-.236-.165-.204.395-.22.172.05.07.631-.367.004.085.32-.176.03-.035.412.24-.186.268.012.343.092-.109.35-.731-.09.013.196-.237.128-.544.054ZM32.788 22.064a3.967 3.967 0 0 0-.036.409l.636.955.461.038.129.124h.406l-.328-.467-.342-.115-.322-.585-.456-.197-.012-.157-.136-.005ZM34.561 23.953l-.012.333.222.167.658-.01-.202-.283-.323-.076-.051-.159-.292.028ZM39.128 21.711l-.421-.034-.202-.225-.443.129-.522.076-.075.229-.613.337.008.216.344.297.442.335.073.567.288.51-.323.366.443.285.047.45.443-.146.671.311-.065.345-.179.39.663.908.279-.088.172.19.182-.107.063.415s.039.286.151.307c.112.022.485.022.485.022l-.005.132.511.171s.026.168.041.253c.011.081.205.109.205.109l.346.295.19.507s.269.177.349.179c.082.005.373 0 .373 0l.178-.39.547-.271-.031-.434-.417-.896-1.35-1.916-.256-.476-.904-.953.194-.372-.14-.173-.258-.011s-.113-.452-.111-.5c.004-.051-.473-.686-.473-.686l-.068-.349-.147.042-.151.126-.144-.072-.259-.063-.131-.337ZM37.931 20.226l.586.222.217.383.347.036-.169-.147.021-.528-.147-.183-.751.044-.104.173ZM47.692 38.428s-.319.26-.324.323c0 .057-.011.293-.011.293l.252-.029.139-.132-.056-.455ZM45.613 40.265l-.065.154-.269.009-.007.648.295-.185.106-.192.138-.052.028-.234-.157.053-.069-.201ZM46.15 43.165l-.229-.032-.086.211-.193-.007-.066.23-.159.094.048.259.308-.027.344-.381.033-.347ZM46.726 42.736l-.227-.109-.094.408.187.168.134-.467ZM46.865 42.172l.172.066-.241.226-.056-.084.125-.208ZM28.197 40.665l-.075.041-.045.194.098.037-.105.132-.036.271-.092.166.173-.04.188-.069.075-.04-.094-.097.046-.226-.043-.14.01-.242-.1.013ZM27.994 41.065v.119l-.047.153-.094-.066.005-.137.136-.069ZM33.342 40.231s-.179.188-.103.192c.076.001.186.144.186.144l.289.013.026.317.274-.106.194-.031.207-.404-.2-.205-.504.036-.346-.017-.023.061ZM32.689 39.691l.311.014.377.172-.087.215-.401-.042-.069-.197-.131-.162ZM24.467 34.875l.207.088.12.361-.046.194.171.085.007.787-.35.064-.125-.241.162-.211-.019-.473-.227.346-.55.268.112-.368.296-.144.3-.262-.125-.299-.458-.102.087-.25.438.157ZM29.016 60.816c4.975 2.123 6.931 3.848 6.873 5.037-.036.759-2.064-1.616-3.276-2.45-1.397-1.066-2.85-2.003-4.338-2.293-1.439-.274-12.052 3.956-17.17.279 5.388-.348 12.303-2.967 17.911-.573ZM6.813 25.003c-.011.189-.549.992-.505.922 2.03-3.123 3.046-2.529 5.256-4.436-.36 3.499-4.355 5.69-6.286 7.176-.919-5.187.197-9.712 2.892-13.651-.732 3.896-.933 4.149-1.357 9.989Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M7.6 23.499c.226-3.589 2.605-5.863 5.387-7.349-.807 2.361-2.061 5.467-5.387 7.349ZM4.412 32.17c.711-1.886 2.571-4.12 4.538-5.169-.271 3.674-3.502 6.213-5.209 9.451-1.974-4.639-2.873-10.94-.046-15.444.031 3.53 1.088 8.229.717 11.162Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M4.021 38.721c.628-2.016 1.156-3.843 2.773-5.42 1.077 2.977-.867 6.349-2.139 9.101C1.524 38.887-.55 35.164.379 29.574c1.187 3.134 2.032 6.267 3.642 9.147Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M5.756 46.212c-.043-3.684.321-5.123 1.396-7.31 1.707 3.587.695 7.651.424 11.502C2.751 47.101.55 43.548 0 37.959c2.029 3.13 4.53 5.162 5.756 8.253Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M12.811 56.403c-3.414-.611-7.274-1.75-8.89-5.251l-1.706-4.461c1.891 2.866 3.923 3.245 7.096 6.463-1.141-4.233-.272-5.152-.632-7.951 2.965 2.888 3.055 7.349 4.132 11.2Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M19.276 59.555c-2.874-.174-5.837 1.486-8.44 0-1.527-.877-2.965-2.449-4.042-3.85 1.975 1.312 6.02.742 8.445 2.317-2.314-1.924-1.22-4.645-2.869-7.43-.012-.058-.007-.051-.007-.051 3.893 1.585 3.932 7.852 6.913 9.014ZM30.329 60.816c-4.977 2.123-6.934 3.848-6.875 5.037.037.759 2.063-1.616 3.274-2.45 1.399-1.066 2.852-2.003 4.341-2.293 1.439-.274 12.051 3.956 17.17.279-5.387-.348-12.303-2.967-17.91-.573ZM52.529 25.003c.014.189.552.992.508.922-2.031-3.123-3.047-2.529-5.256-4.436.358 3.499 4.353 5.69 6.287 7.176.916-5.187-.198-9.712-2.892-13.651.727 3.896.929 4.149 1.353 9.989Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M51.746 23.499c-.23-3.589-2.606-5.863-5.388-7.349.807 2.361 2.059 5.467 5.388 7.349ZM54.934 32.17c-.713-1.886-2.573-4.12-4.541-5.169.272 3.674 3.504 6.213 5.209 9.451 1.975-4.639 2.873-10.94.046-15.444-.028 3.53-1.087 8.229-.714 11.162Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M55.324 38.721c-.63-2.016-1.158-3.843-2.776-5.42-1.077 2.977.87 6.349 2.139 9.101 3.135-3.515 5.208-7.238 4.278-12.828-1.187 3.134-2.034 6.267-3.641 9.147Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M53.588 46.212c.041-3.684-.319-5.123-1.397-7.31-1.705 3.587-.691 7.651-.423 11.502 4.826-3.303 7.026-6.856 7.577-12.445-2.034 3.13-4.529 5.162-5.757 8.253Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M46.534 56.403c3.41-.611 7.273-1.75 8.889-5.251l1.706-4.461c-1.89 2.866-3.923 3.245-7.095 6.463 1.142-4.233.27-5.152.631-7.951-2.964 2.888-3.054 7.349-4.131 11.2Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M40.067 59.555c2.873-.174 5.837 1.486 8.443 0 1.526-.877 2.961-2.449 4.038-3.85-1.975 1.312-6.018.742-8.445 2.317 2.318-1.924 1.221-4.645 2.872-7.43l.008-.051c-3.896 1.585-3.935 7.852-6.916 9.014Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M46.43 36.373a16.712 16.712 0 0 0-4.786-11.534l2.582-2.582a20.352 20.352 0 0 1 5.856 14.116H46.43ZM41.644 48.28a16.71 16.71 0 0 0 4.786-11.534h3.652a20.354 20.354 0 0 1-5.856 14.116l-2.582-2.582Zm-11.798 5.05a16.719 16.719 0 0 0 11.535-4.786l2.581 2.582c-3.646 3.58-8.625 5.807-14.116 5.856V53.33Zm-11.907-4.786a16.716 16.716 0 0 0 11.534 4.786v3.652a20.354 20.354 0 0 1-14.116-5.856l2.582-2.582ZM12.89 36.746a16.71 16.71 0 0 0 4.785 11.534l-2.581 2.582a20.359 20.359 0 0 1-5.857-14.116h3.653Zm4.785-11.907a16.711 16.711 0 0 0-4.785 11.534H9.237a20.357 20.357 0 0 1 5.857-14.116l2.581 2.582Zm11.798-5.05a16.72 16.72 0 0 0-11.535 4.786l-2.581-2.582a20.354 20.354 0 0 1 14.116-5.856v3.652Zm11.908 4.786a16.719 16.719 0 0 0-11.535-4.786v-3.652c5.491.049 10.47 2.276 14.116 5.856l-2.581 2.582Zm1.021 11.798a12.707 12.707 0 0 0-3.604-8.688l2.583-2.583a16.343 16.343 0 0 1 4.676 11.271h-3.655Zm-3.604 9.061a12.705 12.705 0 0 0 3.604-8.688h3.655a16.343 16.343 0 0 1-4.676 11.271l-2.583-2.583Zm-8.952 3.868a12.7 12.7 0 0 0 8.688-3.605l2.583 2.583a16.348 16.348 0 0 1-11.271 4.677v-3.655Zm-9.061-3.605a12.701 12.701 0 0 0 8.688 3.605v3.655a16.35 16.35 0 0 1-11.271-4.676l2.583-2.584Zm-3.868-8.951a12.7 12.7 0 0 0 3.605 8.688l-2.584 2.583a16.343 16.343 0 0 1-4.676-11.271h3.655Zm3.605-9.061a12.701 12.701 0 0 0-3.605 8.688h-3.655a16.343 16.343 0 0 1 4.676-11.271l2.584 2.583Zm8.951-3.868a12.701 12.701 0 0 0-8.688 3.605l-2.583-2.583a16.341 16.341 0 0 1 11.271-4.677v3.655Zm9.061 3.605a12.7 12.7 0 0 0-8.688-3.605v-3.655a16.344 16.344 0 0 1 11.271 4.677l-2.583 2.583Zm-.157 8.951a8.691 8.691 0 0 0-2.424-5.843l2.581-2.581a12.328 12.328 0 0 1 3.495 8.424h-3.652Zm-2.424 6.216a8.691 8.691 0 0 0 2.424-5.843h3.652a12.332 12.332 0 0 1-3.495 8.425l-2.581-2.582Zm-6.107 2.688a8.689 8.689 0 0 0 5.843-2.424l2.581 2.581a12.324 12.324 0 0 1-8.424 3.495v-3.652Zm-6.216-2.424a8.691 8.691 0 0 0 5.843 2.424v3.652a12.325 12.325 0 0 1-8.424-3.495l2.581-2.581Zm-2.687-6.107a8.686 8.686 0 0 0 2.424 5.843l-2.582 2.582a12.332 12.332 0 0 1-3.495-8.425h3.653Zm2.424-6.216a8.686 8.686 0 0 0-2.424 5.843H17.29a12.328 12.328 0 0 1 3.495-8.424l2.582 2.581Zm6.106-2.688a8.687 8.687 0 0 0-5.843 2.425l-2.581-2.582a12.33 12.33 0 0 1 8.424-3.495v3.652Zm6.216 2.425a8.685 8.685 0 0 0-5.843-2.425V24.19a12.328 12.328 0 0 1 8.424 3.495l-2.581 2.582Zm-1.337 6.106a4.687 4.687 0 0 0-1.244-2.998l2.581-2.581a8.317 8.317 0 0 1 2.315 5.579h-3.652Zm-1.244 3.371a4.685 4.685 0 0 0 1.244-2.998h3.652a8.317 8.317 0 0 1-2.315 5.579l-2.581-2.581Zm-3.262 1.507a4.676 4.676 0 0 0 2.998-1.244l2.582 2.582a8.32 8.32 0 0 1-5.58 2.315v-3.653Zm-3.37-1.244a4.671 4.671 0 0 0 2.997 1.244v3.653a8.317 8.317 0 0 1-5.579-2.315l2.582-2.582Zm-1.508-3.261a4.68 4.68 0 0 0 1.244 2.998l-2.582 2.581a8.311 8.311 0 0 1-2.314-5.579h3.652Zm1.244-3.371a4.681 4.681 0 0 0-1.244 2.998h-3.652a8.311 8.311 0 0 1 2.314-5.579l2.582 2.581Zm3.261-1.507a4.676 4.676 0 0 0-2.997 1.243l-2.582-2.581a8.317 8.317 0 0 1 5.579-2.315v3.653Zm3.371 1.243a4.68 4.68 0 0 0-2.998-1.243v-3.653a8.321 8.321 0 0 1 5.58 2.315l-2.582 2.581Zm-3.184 7.772a4.328 4.328 0 0 1-4.324-4.323 4.329 4.329 0 0 1 4.324-4.324 4.328 4.328 0 0 1 4.323 4.324 4.328 4.328 0 0 1-4.323 4.323Zm0-25.121c-11.468 0-20.798 9.329-20.798 20.798 0 11.468 9.33 20.798 20.798 20.798 11.467 0 20.797-9.33 20.797-20.798 0-11.469-9.33-20.798-20.797-20.798Z" style="fill:#005aaa;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m44.313 15.637-9.945-2.642 1.713-3.349a.185.185 0 0 0-.03-.222.182.182 0 0 0-.221-.029l-3.35 1.713-2.642-9.946a.183.183 0 0 0-.178-.14.186.186 0 0 0-.179.14l-2.642 9.946-3.349-1.713a.182.182 0 0 0-.221.029.185.185 0 0 0-.03.222l1.713 3.349-9.946 2.642a.183.183 0 0 0 0 .356l9.946 2.642-1.713 3.35a.183.183 0 0 0 .251.25l3.349-1.712 2.642 9.945c.021.082.095.14.179.14a.183.183 0 0 0 .178-.14l2.642-9.945 3.35 1.712a.183.183 0 0 0 .251-.25l-1.713-3.35 9.945-2.642a.183.183 0 0 0 0-.356Z" style="fill:#fff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M29.641 30.542a.404.404 0 0 1-.393-.307l-2.428-9.712-3.117 1.781a.403.403 0 0 1-.551-.551l1.781-3.118-9.713-2.428a.403.403 0 0 1 .001-.784l9.712-2.428-1.781-3.117a.404.404 0 0 1 .551-.552l3.117 1.782 2.429-9.713a.403.403 0 0 1 .784.001l2.428 9.712 3.118-1.782a.404.404 0 0 1 .551.551l-1.781 3.118 9.712 2.428a.403.403 0 0 1-.001.784l-9.711 2.428 1.781 3.118a.404.404 0 0 1-.066.487.413.413 0 0 1-.485.064l-3.118-1.781-2.428 9.712a.404.404 0 0 1-.392.307Z" style="fill:none;stroke:#005aaa;stroke-width:.3px" transform="translate(0 -3.704) scale(4.16667)"/><path d="M29.641 30.542a.404.404 0 0 1-.393-.307l-2.428-9.712-3.117 1.781a.403.403 0 0 1-.551-.551l1.781-3.118-9.713-2.428a.403.403 0 0 1 .001-.784l9.712-2.428-1.781-3.117a.404.404 0 0 1 .551-.552l3.117 1.782 2.429-9.713a.403.403 0 0 1 .784.001l2.428 9.712 3.118-1.782a.404.404 0 0 1 .551.551l-1.781 3.118 9.712 2.428a.403.403 0 0 1-.001.784l-9.711 2.428 1.781 3.118a.404.404 0 0 1-.066.487.413.413 0 0 1-.485.064l-3.118-1.781-2.428 9.712a.404.404 0 0 1-.392.307Z" style="fill:none;stroke:#005aaa;stroke-width:.4px" transform="translate(0 -3.704) scale(4.16667)"/><path d="m15.831 15.815 9.718-2.426 4.092 2.426h-13.81ZM43.451 15.815l-9.718 2.426-4.092-2.426h13.81ZM29.641 29.625l-2.426-9.718 2.426-4.092v13.81Z" style="fill:#faa619;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m29.641 2.005 2.425 9.718-2.425 4.092V2.005Z" style="fill:#faa619;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m23.886 10.05 3.709 2.145 2.046 3.62-5.755-5.765ZM35.459 21.622l-3.709-2.144-2.109-3.663 5.818 5.807ZM23.887 21.623l2.145-3.709 3.609-2.099-5.754 5.808ZM35.459 10.05l-2.145 3.708-3.673 2.057 5.818-5.765Z" style="fill:#faa619;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/></svg>
	</xsl:variable>

	<xsl:variable name="WMO-Emblem-Reverse">
<svg viewBox="0 0 248 272" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:2"><path d="m16.174 37.477-.251.5-.387.023-.257.659-.338.691-.002.985-1.464.014-.235.145-.655-.028-.41-.413-.501.058-.43.178-.538-.064-.166.269-.141.663-.035.864.334.288-.034.866.667.618.08-.978.678.343.059-.468.41.295.023.431.422.06.593.538.285.602.76.268.1.361 1.384 1.006 1.879.241.514.614.932-.197.585-.129.966-.076.176-.543-.6-1.323-.952-1.265-.038-.946-.021-.473-.478-.534.025-.629.248-.421-.131-.556-.429.1.045-1.061-.646-1.172.052-.353-.255-.403.208-.343.464-.061.142-.623.546-.171.024-.589-.183-.282.217-.545.471-.253.383.056.043.866.187.126-.2.191.142.322-.02.471-.242.303.303 1.075.29-.537.228.088.334.33 1.036.085-.014.355.391-.099.175.398.339.212.268.052-.057.429.287-.421.046.712.376.293.024-.588.273-.107.024-.549.514-.371.018-.432.57.142.186-.738.448-.611.215-.542.417.176-.017.433-.239.187.259.247-.393.179-.315.143.029.278-.122.192-.28.223-.134.465-.321.302s.453.256.568.222c.119-.035.967-.075.967-.075l.09-.349.314-.146.505-.054.151-.861.369-.572-.478-.534-.158.032-.122.23.028-.707-.337-.288.019-.474-.375-.252-.052.354-.16.149-.186-.166.253-.5-.03-.238-.272.066-.391.141-.027-.318.192.048.352-.14-.095-.516.891-.078.438-.415-.014-.589.274-.068.01-.234-.23-.051-.026-.315.276-.185.547-.213.012-.234-1.09.225-.304-.05.057-.473-.195.071-.324.419-.135.428-.63.365-.537-.065-.174-.44-.31-.013-.167.388-.542.012-.867-.509-.877-.198-.55.252-.932.194-.711.44-.161.152.266.088.507-.174.507-.135.229.089-.086.192-.463.022-1.049.227-.579.053-.291.461-.088.309-.282.303.091.596-.17.424-.207.303-.049.314-.202.188-.016.394-.341-.132.007.786-.213.505.102.357-.241.225-.537-.062-.489-.297-.423-.021Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m19.753 36.573-.3-.17-.059.511.178.397-.356.224-.026.625.248.525.237.836.07-.782.253-.542-.391.141.019-.472.213-.54-.211-.482.125-.271Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m19.948 37.526-.088.311.298.212-.103-.28-.107-.243ZM12.134 44.931l.057.514.262.209-.012.237.306.053-.02-.395-.214-.48-.379-.138ZM16.353 51.104l.385.056.028.197.295.287-.323.381-.398-.609.013-.312ZM38.542 45.481l.124-.193.228.049.443.531-.054.352.191.087-.004 1.063-.277.183-.436.257-.31.026.03-.746-.183-.206.019-.51.358-.259-.02-.473-.223-.169.114.008ZM33.856 43.264l-1.117-.051.832.391 1.055.601 1.435-.255.144-.659.354-.18.202.676.005.867.087.708-.371.576-.019.47.601.384.287.524-.025.628-.44.415-.081 1.059-.206.304-.147.742-.883.867-.627.285-.361.378-.576-.026-.366.455-.719-.308-.635-.499-.135-.517-.459-.019-.58-.933.214-.542-.392-.806-.792-.389-.704-.738-1.419-.142-.257-.289-1.236.025-.6-.382.053-.352-.662-.777.245-.383.229-.816.901-.391.327-.498.389-.063.275-.145.613.108.278-.223 1.047-.11.298.207 1.287-.334.197-.15.456.139.439-.375.433-.177.395-.298-.148-.163-.538.015-.518.409-.385-.014-.134-.481.752-.518.657-.049.131-.388-.685-.185-.343-.095-.24.226.146.163-.158.111-.417-.177-.012.355-.056.391.07.197-.123.154.145.205-.276.181-.033-.157.047-.195-.338-.21-.376-.255s-.534-.104-.539.017c-.004.118.101.358.101.358l.451.293.303.094.032.199-.149-.125-.123.152-.126.271-.109-.164-.025-.317-.342-.132-.462-.019-.576-.027-.025.61-.221.205-.544.093-.193.049-.203-.184-.188-.182.111-.354.102-.131.256-.106.443-.02.185-.289-.412-.274.32-.299.486-.116.099-.508.235-.086-.007.154-.119.055.035.099.641-.128.333-.124.055-.447.649-.286-.049-.241-.363-.075-.154-.46-.233.013-.201.225.038.491-.329.558-.271-.011-.007-.314-.4.354.019-.45.075-.41.496-.393.214-.935.316-.222.559.005.238-.165-.1-.399.034-.39.142-.153.051-.295-.307-.071.011-.235.181-.189-.154-.46-.672-.108.049-.195.217-.147.39-.121-.21-.483v-.529l-.345-.036-.26-.229.142-.19.118-.527-.653-.048-.2.109-.707-.543-.215-.384.203-.285.506-.114.146-.27-.377-.231.085-.216.284.17.746.093.286-.381-.043-.375.793-.102s.031.236.09.182c.061-.056-.148.305-.148.305l-.401.398.241.227.071.14.306.092.03.219.429-.121.27-.065s-.082-.813.053-.803c.133.005.678-.109.678-.109l.576.066.234.383.734.035-.091-.655.525-.136.691.111-.595.387-.375.674.281.207.028.257.217-.622-.048-.214.274-.088.132.535.286-.439-.143-.219.277-.168.334.251.402.117.521-.036.399.589-.007.156.459.138.057.495.257-.165.38-.338.341.093.439.57-.111.9.541-.055.038-.468.212-.05.087-.192.176-.112.128-.288.087.693-.198.167-.124.191-.106.292-.392.1-.712.026-.197.525.046.354-.364.398-.069.253-.457.374.045.258.303.131.14.4.172.025.123.283.071.653.227.069.048.238.304.111.177.421-.18.171-.407.019-.765.361-.244-.152-.384-.054-.012.315-.599.011-.547.666-.375.709-.384-.037-.189.387-.624.149.01.277.262.167.387-.022.335-.632.758-.184.201.739-.451.665-.007.593-.215.601-.083.154-.113-.103-.448.135-.491-.239-.158.153-.676-.464Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m37.083 42.068-.183.231.022.393.167.164.159-.129-.04-.435.062-.097-.187-.127ZM39.149 38.146l.169-.328.422.019.029.18s.312-.046.29.011c-.022.062-.046.178-.046.178l-.165.266-.169-.045-.53-.281ZM40.067 35.431l.029-1.137.367-.066.125-.679-.171-.542.365-.415-.209-.581-.452-.236-.657.05-.07-.653-.545-.34.032-.295.305.055-.412-.274.406-.081.06-.549-.546-.28-.13-.655-.599.091-.05-.179.139-.071.074-.429-.451-.297-.034-.592-.692-.464-.093-.574-.222-.187-.251-.071-.268-.484.148-.251-.146-.279-.571-.165.306-.437-.499-.497.006-.135.823.096.088.2.014.65.373.253.533.18.602.814-.325.005-.196.011.417.629.123.299.363.077.063.339-.033.391.285.072.31.465.333.309.298.723.178-.092.701 1.744.375-.276s-.219-.265-.196-.384c.025-.116-.249-.503-.19-.5.057.002.232-.069.232-.069s.278.306.255.385c-.023.076.157.421.157.421l.06.908.152.479-.072.804-.2.245.103.28-.06 1.042-.297.202-.384.87-.179.127Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m39.355 27.844.306.054.179.32-.016.395s-.154.033-.192-.048c-.033-.08-.123-.262-.123-.262s-.208-.067-.186-.144c.022-.078.032-.315.032-.315ZM39.995 28.659l.189.108.128.184-.119.544-.173-.047-.025-.295-.167-.146.167-.348ZM31.476 30.7l.382.057.157-.051.247.049.103.341.697-.561.606-.189s.522.378.58.38c.059.004.367.017.367.017l.962-.017-.708-.563-.443-.018-.139.092.008-.217-.646-.166-.37.1-.089.253-.414.258-.519-.064-.108-.164-.153-.024-.045.195-.213-.027-.028.194-.232.048-.002.077ZM35.91 31.096l.18-.169.384.016.107.183-.219.226-.233.009-.034-.121-.185-.144ZM36.749 31.231l.132-.387.218-.109-.003-.374.158-.151.012-.256-.152-.066.413-.236-.165-.204.395-.22.172.05.07.631-.367.004.085.32-.176.03-.035.412.24-.186.268.012.343.092-.109.35-.731-.09.013.196-.237.128-.544.054ZM32.788 22.064a3.967 3.967 0 0 0-.036.409l.636.955.461.038.129.124h.406l-.328-.467-.342-.115-.322-.585-.456-.197-.012-.157-.136-.005ZM34.561 23.953l-.012.333.222.167.658-.01-.202-.283-.323-.076-.051-.159-.292.028ZM39.128 21.711l-.421-.034-.202-.225-.443.129-.522.076-.075.229-.613.337.008.216.344.297.442.335.073.567.288.51-.323.366.443.285.047.45.443-.146.671.311-.065.345-.179.39.663.908.279-.088.172.19.182-.107.063.415s.039.286.151.307c.112.022.485.022.485.022l-.005.132.511.171s.026.168.041.253c.011.081.205.109.205.109l.346.295.19.507s.269.177.349.179c.082.005.373 0 .373 0l.178-.39.547-.271-.031-.434-.417-.896-1.35-1.916-.256-.476-.904-.953.194-.372-.14-.173-.258-.011s-.113-.452-.111-.5c.004-.051-.473-.686-.473-.686l-.068-.349-.147.042-.151.126-.144-.072-.259-.063-.131-.337ZM37.931 20.226l.586.222.217.383.347.036-.169-.147.021-.528-.147-.183-.751.044-.104.173ZM47.692 38.428s-.319.26-.324.323c0 .057-.011.293-.011.293l.252-.029.139-.132-.056-.455ZM45.613 40.265l-.065.154-.269.009-.007.648.295-.185.106-.192.138-.052.028-.234-.157.053-.069-.201ZM46.15 43.165l-.229-.032-.086.211-.193-.007-.066.23-.159.094.048.259.308-.027.344-.381.033-.347ZM46.726 42.736l-.227-.109-.094.408.187.168.134-.467ZM46.865 42.172l.172.066-.241.226-.056-.084.125-.208ZM28.197 40.665l-.075.041-.045.194.098.037-.105.132-.036.271-.092.166.173-.04.188-.069.075-.04-.094-.097.046-.226-.043-.14.01-.242-.1.013ZM27.994 41.065v.119l-.047.153-.094-.066.005-.137.136-.069ZM33.342 40.231s-.179.188-.103.192c.076.001.186.144.186.144l.289.013.026.317.274-.106.194-.031.207-.404-.2-.205-.504.036-.346-.017-.023.061ZM32.689 39.691l.311.014.377.172-.087.215-.401-.042-.069-.197-.131-.162ZM24.467 34.875l.207.088.12.361-.046.194.171.085.007.787-.35.064-.125-.241.162-.211-.019-.473-.227.346-.55.268.112-.368.296-.144.3-.262-.125-.299-.458-.102.087-.25.438.157ZM29.016 60.816c4.975 2.123 6.931 3.848 6.873 5.037-.036.759-2.064-1.616-3.276-2.45-1.397-1.066-2.85-2.003-4.338-2.293-1.439-.274-12.052 3.956-17.17.279 5.388-.348 12.303-2.967 17.911-.573ZM6.813 25.003c-.011.189-.549.992-.505.922 2.03-3.123 3.046-2.529 5.256-4.436-.36 3.499-4.355 5.69-6.286 7.176-.919-5.187.197-9.712 2.892-13.651-.732 3.896-.933 4.149-1.357 9.989Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M7.6 23.499c.226-3.589 2.605-5.863 5.387-7.349-.807 2.361-2.061 5.467-5.387 7.349ZM4.412 32.17c.711-1.886 2.571-4.12 4.538-5.169-.271 3.674-3.502 6.213-5.209 9.451-1.974-4.639-2.873-10.94-.046-15.444.031 3.53 1.088 8.229.717 11.162Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M4.021 38.721c.628-2.016 1.156-3.843 2.773-5.42 1.077 2.977-.867 6.349-2.139 9.101C1.524 38.887-.55 35.164.379 29.574c1.187 3.134 2.032 6.267 3.642 9.147Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M5.756 46.212c-.043-3.684.321-5.123 1.396-7.31 1.707 3.587.695 7.651.424 11.502C2.751 47.101.55 43.548 0 37.959c2.029 3.13 4.53 5.162 5.756 8.253Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M12.811 56.403c-3.414-.611-7.274-1.75-8.89-5.251l-1.706-4.461c1.891 2.866 3.923 3.245 7.096 6.463-1.141-4.233-.272-5.152-.632-7.951 2.965 2.888 3.055 7.349 4.132 11.2Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M19.276 59.555c-2.874-.174-5.837 1.486-8.44 0-1.527-.877-2.965-2.449-4.042-3.85 1.975 1.312 6.02.742 8.445 2.317-2.314-1.924-1.22-4.645-2.869-7.43-.012-.058-.007-.051-.007-.051 3.893 1.585 3.932 7.852 6.913 9.014ZM30.329 60.816c-4.977 2.123-6.934 3.848-6.875 5.037.037.759 2.063-1.616 3.274-2.45 1.399-1.066 2.852-2.003 4.341-2.293 1.439-.274 12.051 3.956 17.17.279-5.387-.348-12.303-2.967-17.91-.573ZM52.529 25.003c.014.189.552.992.508.922-2.031-3.123-3.047-2.529-5.256-4.436.358 3.499 4.353 5.69 6.287 7.176.916-5.187-.198-9.712-2.892-13.651.727 3.896.929 4.149 1.353 9.989Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M51.746 23.499c-.23-3.589-2.606-5.863-5.388-7.349.807 2.361 2.059 5.467 5.388 7.349ZM54.934 32.17c-.713-1.886-2.573-4.12-4.541-5.169.272 3.674 3.504 6.213 5.209 9.451 1.975-4.639 2.873-10.94.046-15.444-.028 3.53-1.087 8.229-.714 11.162Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M55.324 38.721c-.63-2.016-1.158-3.843-2.776-5.42-1.077 2.977.87 6.349 2.139 9.101 3.135-3.515 5.208-7.238 4.278-12.828-1.187 3.134-2.034 6.267-3.641 9.147Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M53.588 46.212c.041-3.684-.319-5.123-1.397-7.31-1.705 3.587-.691 7.651-.423 11.502 4.826-3.303 7.026-6.856 7.577-12.445-2.034 3.13-4.529 5.162-5.757 8.253Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M46.534 56.403c3.41-.611 7.273-1.75 8.889-5.251l1.706-4.461c-1.89 2.866-3.923 3.245-7.095 6.463 1.142-4.233.27-5.152.631-7.951-2.964 2.888-3.054 7.349-4.131 11.2Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M40.067 59.555c2.873-.174 5.837 1.486 8.443 0 1.526-.877 2.961-2.449 4.038-3.85-1.975 1.312-6.018.742-8.445 2.317 2.318-1.924 1.221-4.645 2.872-7.43l.008-.051c-3.896 1.585-3.935 7.852-6.916 9.014Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M46.43 36.373a16.712 16.712 0 0 0-4.786-11.534l2.582-2.582a20.352 20.352 0 0 1 5.856 14.116H46.43ZM41.644 48.28a16.71 16.71 0 0 0 4.786-11.534h3.652a20.354 20.354 0 0 1-5.856 14.116l-2.582-2.582Zm-11.798 5.05a16.719 16.719 0 0 0 11.535-4.786l2.581 2.582c-3.646 3.58-8.625 5.807-14.116 5.856V53.33Zm-11.907-4.786a16.716 16.716 0 0 0 11.534 4.786v3.652a20.354 20.354 0 0 1-14.116-5.856l2.582-2.582ZM12.89 36.746a16.71 16.71 0 0 0 4.785 11.534l-2.581 2.582a20.359 20.359 0 0 1-5.857-14.116h3.653Zm4.785-11.907a16.711 16.711 0 0 0-4.785 11.534H9.237a20.357 20.357 0 0 1 5.857-14.116l2.581 2.582Zm11.798-5.05a16.72 16.72 0 0 0-11.535 4.786l-2.581-2.582a20.354 20.354 0 0 1 14.116-5.856v3.652Zm11.908 4.786a16.719 16.719 0 0 0-11.535-4.786v-3.652c5.491.049 10.47 2.276 14.116 5.856l-2.581 2.582Zm1.021 11.798a12.707 12.707 0 0 0-3.604-8.688l2.583-2.583a16.343 16.343 0 0 1 4.676 11.271h-3.655Zm-3.604 9.061a12.705 12.705 0 0 0 3.604-8.688h3.655a16.343 16.343 0 0 1-4.676 11.271l-2.583-2.583Zm-8.952 3.868a12.7 12.7 0 0 0 8.688-3.605l2.583 2.583a16.348 16.348 0 0 1-11.271 4.677v-3.655Zm-9.061-3.605a12.701 12.701 0 0 0 8.688 3.605v3.655a16.35 16.35 0 0 1-11.271-4.676l2.583-2.584Zm-3.868-8.951a12.7 12.7 0 0 0 3.605 8.688l-2.584 2.583a16.343 16.343 0 0 1-4.676-11.271h3.655Zm3.605-9.061a12.701 12.701 0 0 0-3.605 8.688h-3.655a16.343 16.343 0 0 1 4.676-11.271l2.584 2.583Zm8.951-3.868a12.701 12.701 0 0 0-8.688 3.605l-2.583-2.583a16.341 16.341 0 0 1 11.271-4.677v3.655Zm9.061 3.605a12.7 12.7 0 0 0-8.688-3.605v-3.655a16.344 16.344 0 0 1 11.271 4.677l-2.583 2.583Zm-.157 8.951a8.691 8.691 0 0 0-2.424-5.843l2.581-2.581a12.328 12.328 0 0 1 3.495 8.424h-3.652Zm-2.424 6.216a8.691 8.691 0 0 0 2.424-5.843h3.652a12.332 12.332 0 0 1-3.495 8.425l-2.581-2.582Zm-6.107 2.688a8.689 8.689 0 0 0 5.843-2.424l2.581 2.581a12.324 12.324 0 0 1-8.424 3.495v-3.652Zm-6.216-2.424a8.691 8.691 0 0 0 5.843 2.424v3.652a12.325 12.325 0 0 1-8.424-3.495l2.581-2.581Zm-2.687-6.107a8.686 8.686 0 0 0 2.424 5.843l-2.582 2.582a12.332 12.332 0 0 1-3.495-8.425h3.653Zm2.424-6.216a8.686 8.686 0 0 0-2.424 5.843H17.29a12.328 12.328 0 0 1 3.495-8.424l2.582 2.581Zm6.106-2.688a8.687 8.687 0 0 0-5.843 2.425l-2.581-2.582a12.33 12.33 0 0 1 8.424-3.495v3.652Zm6.216 2.425a8.685 8.685 0 0 0-5.843-2.425V24.19a12.328 12.328 0 0 1 8.424 3.495l-2.581 2.582Zm-1.337 6.106a4.687 4.687 0 0 0-1.244-2.998l2.581-2.581a8.317 8.317 0 0 1 2.315 5.579h-3.652Zm-1.244 3.371a4.685 4.685 0 0 0 1.244-2.998h3.652a8.317 8.317 0 0 1-2.315 5.579l-2.581-2.581Zm-3.262 1.507a4.676 4.676 0 0 0 2.998-1.244l2.582 2.582a8.32 8.32 0 0 1-5.58 2.315v-3.653Zm-3.37-1.244a4.671 4.671 0 0 0 2.997 1.244v3.653a8.317 8.317 0 0 1-5.579-2.315l2.582-2.582Zm-1.508-3.261a4.68 4.68 0 0 0 1.244 2.998l-2.582 2.581a8.311 8.311 0 0 1-2.314-5.579h3.652Zm1.244-3.371a4.681 4.681 0 0 0-1.244 2.998h-3.652a8.311 8.311 0 0 1 2.314-5.579l2.582 2.581Zm3.261-1.507a4.676 4.676 0 0 0-2.997 1.243l-2.582-2.581a8.317 8.317 0 0 1 5.579-2.315v3.653Zm3.371 1.243a4.68 4.68 0 0 0-2.998-1.243v-3.653a8.321 8.321 0 0 1 5.58 2.315l-2.582 2.581Zm-3.184 7.772a4.328 4.328 0 0 1-4.324-4.323 4.329 4.329 0 0 1 4.324-4.324 4.328 4.328 0 0 1 4.323 4.324 4.328 4.328 0 0 1-4.323 4.323Zm0-25.121c-11.468 0-20.798 9.329-20.798 20.798 0 11.468 9.33 20.798 20.798 20.798 11.467 0 20.797-9.33 20.797-20.798 0-11.469-9.33-20.798-20.797-20.798Z" style="fill:#ffffff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m44.313 15.637-9.945-2.642 1.713-3.349a.185.185 0 0 0-.03-.222.182.182 0 0 0-.221-.029l-3.35 1.713-2.642-9.946a.183.183 0 0 0-.178-.14.186.186 0 0 0-.179.14l-2.642 9.946-3.349-1.713a.182.182 0 0 0-.221.029.185.185 0 0 0-.03.222l1.713 3.349-9.946 2.642a.183.183 0 0 0 0 .356l9.946 2.642-1.713 3.35a.183.183 0 0 0 .251.25l3.349-1.712 2.642 9.945c.021.082.095.14.179.14a.183.183 0 0 0 .178-.14l2.642-9.945 3.35 1.712a.183.183 0 0 0 .251-.25l-1.713-3.35 9.945-2.642a.183.183 0 0 0 0-.356Z" style="fill:#fff;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M29.641 30.542a.404.404 0 0 1-.393-.307l-2.428-9.712-3.117 1.781a.403.403 0 0 1-.551-.551l1.781-3.118-9.713-2.428a.403.403 0 0 1 .001-.784l9.712-2.428-1.781-3.117a.404.404 0 0 1 .551-.552l3.117 1.782 2.429-9.713a.403.403 0 0 1 .784.001l2.428 9.712 3.118-1.782a.404.404 0 0 1 .551.551l-1.781 3.118 9.712 2.428a.403.403 0 0 1-.001.784l-9.711 2.428 1.781 3.118a.404.404 0 0 1-.066.487.413.413 0 0 1-.485.064l-3.118-1.781-2.428 9.712a.404.404 0 0 1-.392.307Z" style="fill:none;stroke:#ffffff;stroke-width:.3px" transform="translate(0 -3.704) scale(4.16667)"/><path d="M29.641 30.542a.404.404 0 0 1-.393-.307l-2.428-9.712-3.117 1.781a.403.403 0 0 1-.551-.551l1.781-3.118-9.713-2.428a.403.403 0 0 1 .001-.784l9.712-2.428-1.781-3.117a.404.404 0 0 1 .551-.552l3.117 1.782 2.429-9.713a.403.403 0 0 1 .784.001l2.428 9.712 3.118-1.782a.404.404 0 0 1 .551.551l-1.781 3.118 9.712 2.428a.403.403 0 0 1-.001.784l-9.711 2.428 1.781 3.118a.404.404 0 0 1-.066.487.413.413 0 0 1-.485.064l-3.118-1.781-2.428 9.712a.404.404 0 0 1-.392.307Z" style="fill:none;stroke:#ffffff;stroke-width:.4px" transform="translate(0 -3.704) scale(4.16667)"/><path d="m15.831 15.815 9.718-2.426 4.092 2.426h-13.81ZM43.451 15.815l-9.718 2.426-4.092-2.426h13.81ZM29.641 29.625l-2.426-9.718 2.426-4.092v13.81Z" style="fill:#faa619;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m29.641 2.005 2.425 9.718-2.425 4.092V2.005Z" style="fill:#faa619;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m23.886 10.05 3.709 2.145 2.046 3.62-5.755-5.765ZM35.459 21.622l-3.709-2.144-2.109-3.663 5.818 5.807ZM23.887 21.623l2.145-3.709 3.609-2.099-5.754 5.808ZM35.459 10.05l-2.145 3.708-3.673 2.057 5.818-5.765Z" style="fill:#faa619;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/></svg>
	</xsl:variable>

	<xsl:variable name="WMO-Emblem-BW">
<svg viewBox="0 0 248 272" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:2"><path d="m16.174 37.477-.251.5-.387.023-.257.659-.338.691-.002.985-1.464.014-.235.145-.655-.028-.41-.413-.501.058-.43.178-.538-.064-.166.269-.141.663-.035.864.334.288-.034.866.667.618.08-.978.678.343.059-.468.41.295.023.431.422.06.593.538.285.602.76.268.1.361 1.384 1.006 1.879.241.514.614.932-.197.585-.129.966-.076.176-.543-.6-1.323-.952-1.265-.038-.946-.021-.473-.478-.534.025-.629.248-.421-.131-.556-.429.1.045-1.061-.646-1.172.052-.353-.255-.403.208-.343.464-.061.142-.623.546-.171.024-.589-.183-.282.217-.545.471-.253.383.056.043.866.187.126-.2.191.142.322-.02.471-.242.303.303 1.075.29-.537.228.088.334.33 1.036.085-.014.355.391-.099.175.398.339.212.268.052-.057.429.287-.421.046.712.376.293.024-.588.273-.107.024-.549.514-.371.018-.432.57.142.186-.738.448-.611.215-.542.417.176-.017.433-.239.187.259.247-.393.179-.315.143.029.278-.122.192-.28.223-.134.465-.321.302s.453.256.568.222c.119-.035.967-.075.967-.075l.09-.349.314-.146.505-.054.151-.861.369-.572-.478-.534-.158.032-.122.23.028-.707-.337-.288.019-.474-.375-.252-.052.354-.16.149-.186-.166.253-.5-.03-.238-.272.066-.391.141-.027-.318.192.048.352-.14-.095-.516.891-.078.438-.415-.014-.589.274-.068.01-.234-.23-.051-.026-.315.276-.185.547-.213.012-.234-1.09.225-.304-.05.057-.473-.195.071-.324.419-.135.428-.63.365-.537-.065-.174-.44-.31-.013-.167.388-.542.012-.867-.509-.877-.198-.55.252-.932.194-.711.44-.161.152.266.088.507-.174.507-.135.229.089-.086.192-.463.022-1.049.227-.579.053-.291.461-.088.309-.282.303.091.596-.17.424-.207.303-.049.314-.202.188-.016.394-.341-.132.007.786-.213.505.102.357-.241.225-.537-.062-.489-.297-.423-.021Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m19.753 36.573-.3-.17-.059.511.178.397-.356.224-.026.625.248.525.237.836.07-.782.253-.542-.391.141.019-.472.213-.54-.211-.482.125-.271Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m19.948 37.526-.088.311.298.212-.103-.28-.107-.243ZM12.134 44.931l.057.514.262.209-.012.237.306.053-.02-.395-.214-.48-.379-.138ZM16.353 51.104l.385.056.028.197.295.287-.323.381-.398-.609.013-.312ZM38.542 45.481l.124-.193.228.049.443.531-.054.352.191.087-.004 1.063-.277.183-.436.257-.31.026.03-.746-.183-.206.019-.51.358-.259-.02-.473-.223-.169.114.008ZM33.856 43.264l-1.117-.051.832.391 1.055.601 1.435-.255.144-.659.354-.18.202.676.005.867.087.708-.371.576-.019.47.601.384.287.524-.025.628-.44.415-.081 1.059-.206.304-.147.742-.883.867-.627.285-.361.378-.576-.026-.366.455-.719-.308-.635-.499-.135-.517-.459-.019-.58-.933.214-.542-.392-.806-.792-.389-.704-.738-1.419-.142-.257-.289-1.236.025-.6-.382.053-.352-.662-.777.245-.383.229-.816.901-.391.327-.498.389-.063.275-.145.613.108.278-.223 1.047-.11.298.207 1.287-.334.197-.15.456.139.439-.375.433-.177.395-.298-.148-.163-.538.015-.518.409-.385-.014-.134-.481.752-.518.657-.049.131-.388-.685-.185-.343-.095-.24.226.146.163-.158.111-.417-.177-.012.355-.056.391.07.197-.123.154.145.205-.276.181-.033-.157.047-.195-.338-.21-.376-.255s-.534-.104-.539.017c-.004.118.101.358.101.358l.451.293.303.094.032.199-.149-.125-.123.152-.126.271-.109-.164-.025-.317-.342-.132-.462-.019-.576-.027-.025.61-.221.205-.544.093-.193.049-.203-.184-.188-.182.111-.354.102-.131.256-.106.443-.02.185-.289-.412-.274.32-.299.486-.116.099-.508.235-.086-.007.154-.119.055.035.099.641-.128.333-.124.055-.447.649-.286-.049-.241-.363-.075-.154-.46-.233.013-.201.225.038.491-.329.558-.271-.011-.007-.314-.4.354.019-.45.075-.41.496-.393.214-.935.316-.222.559.005.238-.165-.1-.399.034-.39.142-.153.051-.295-.307-.071.011-.235.181-.189-.154-.46-.672-.108.049-.195.217-.147.39-.121-.21-.483v-.529l-.345-.036-.26-.229.142-.19.118-.527-.653-.048-.2.109-.707-.543-.215-.384.203-.285.506-.114.146-.27-.377-.231.085-.216.284.17.746.093.286-.381-.043-.375.793-.102s.031.236.09.182c.061-.056-.148.305-.148.305l-.401.398.241.227.071.14.306.092.03.219.429-.121.27-.065s-.082-.813.053-.803c.133.005.678-.109.678-.109l.576.066.234.383.734.035-.091-.655.525-.136.691.111-.595.387-.375.674.281.207.028.257.217-.622-.048-.214.274-.088.132.535.286-.439-.143-.219.277-.168.334.251.402.117.521-.036.399.589-.007.156.459.138.057.495.257-.165.38-.338.341.093.439.57-.111.9.541-.055.038-.468.212-.05.087-.192.176-.112.128-.288.087.693-.198.167-.124.191-.106.292-.392.1-.712.026-.197.525.046.354-.364.398-.069.253-.457.374.045.258.303.131.14.4.172.025.123.283.071.653.227.069.048.238.304.111.177.421-.18.171-.407.019-.765.361-.244-.152-.384-.054-.012.315-.599.011-.547.666-.375.709-.384-.037-.189.387-.624.149.01.277.262.167.387-.022.335-.632.758-.184.201.739-.451.665-.007.593-.215.601-.083.154-.113-.103-.448.135-.491-.239-.158.153-.676-.464Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m37.083 42.068-.183.231.022.393.167.164.159-.129-.04-.435.062-.097-.187-.127ZM39.149 38.146l.169-.328.422.019.029.18s.312-.046.29.011c-.022.062-.046.178-.046.178l-.165.266-.169-.045-.53-.281ZM40.067 35.431l.029-1.137.367-.066.125-.679-.171-.542.365-.415-.209-.581-.452-.236-.657.05-.07-.653-.545-.34.032-.295.305.055-.412-.274.406-.081.06-.549-.546-.28-.13-.655-.599.091-.05-.179.139-.071.074-.429-.451-.297-.034-.592-.692-.464-.093-.574-.222-.187-.251-.071-.268-.484.148-.251-.146-.279-.571-.165.306-.437-.499-.497.006-.135.823.096.088.2.014.65.373.253.533.18.602.814-.325.005-.196.011.417.629.123.299.363.077.063.339-.033.391.285.072.31.465.333.309.298.723.178-.092.701 1.744.375-.276s-.219-.265-.196-.384c.025-.116-.249-.503-.19-.5.057.002.232-.069.232-.069s.278.306.255.385c-.023.076.157.421.157.421l.06.908.152.479-.072.804-.2.245.103.28-.06 1.042-.297.202-.384.87-.179.127Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m39.355 27.844.306.054.179.32-.016.395s-.154.033-.192-.048c-.033-.08-.123-.262-.123-.262s-.208-.067-.186-.144c.022-.078.032-.315.032-.315ZM39.995 28.659l.189.108.128.184-.119.544-.173-.047-.025-.295-.167-.146.167-.348ZM31.476 30.7l.382.057.157-.051.247.049.103.341.697-.561.606-.189s.522.378.58.38c.059.004.367.017.367.017l.962-.017-.708-.563-.443-.018-.139.092.008-.217-.646-.166-.37.1-.089.253-.414.258-.519-.064-.108-.164-.153-.024-.045.195-.213-.027-.028.194-.232.048-.002.077ZM35.91 31.096l.18-.169.384.016.107.183-.219.226-.233.009-.034-.121-.185-.144ZM36.749 31.231l.132-.387.218-.109-.003-.374.158-.151.012-.256-.152-.066.413-.236-.165-.204.395-.22.172.05.07.631-.367.004.085.32-.176.03-.035.412.24-.186.268.012.343.092-.109.35-.731-.09.013.196-.237.128-.544.054ZM32.788 22.064a3.967 3.967 0 0 0-.036.409l.636.955.461.038.129.124h.406l-.328-.467-.342-.115-.322-.585-.456-.197-.012-.157-.136-.005ZM34.561 23.953l-.012.333.222.167.658-.01-.202-.283-.323-.076-.051-.159-.292.028ZM39.128 21.711l-.421-.034-.202-.225-.443.129-.522.076-.075.229-.613.337.008.216.344.297.442.335.073.567.288.51-.323.366.443.285.047.45.443-.146.671.311-.065.345-.179.39.663.908.279-.088.172.19.182-.107.063.415s.039.286.151.307c.112.022.485.022.485.022l-.005.132.511.171s.026.168.041.253c.011.081.205.109.205.109l.346.295.19.507s.269.177.349.179c.082.005.373 0 .373 0l.178-.39.547-.271-.031-.434-.417-.896-1.35-1.916-.256-.476-.904-.953.194-.372-.14-.173-.258-.011s-.113-.452-.111-.5c.004-.051-.473-.686-.473-.686l-.068-.349-.147.042-.151.126-.144-.072-.259-.063-.131-.337ZM37.931 20.226l.586.222.217.383.347.036-.169-.147.021-.528-.147-.183-.751.044-.104.173ZM47.692 38.428s-.319.26-.324.323c0 .057-.011.293-.011.293l.252-.029.139-.132-.056-.455ZM45.613 40.265l-.065.154-.269.009-.007.648.295-.185.106-.192.138-.052.028-.234-.157.053-.069-.201ZM46.15 43.165l-.229-.032-.086.211-.193-.007-.066.23-.159.094.048.259.308-.027.344-.381.033-.347ZM46.726 42.736l-.227-.109-.094.408.187.168.134-.467ZM46.865 42.172l.172.066-.241.226-.056-.084.125-.208ZM28.197 40.665l-.075.041-.045.194.098.037-.105.132-.036.271-.092.166.173-.04.188-.069.075-.04-.094-.097.046-.226-.043-.14.01-.242-.1.013ZM27.994 41.065v.119l-.047.153-.094-.066.005-.137.136-.069ZM33.342 40.231s-.179.188-.103.192c.076.001.186.144.186.144l.289.013.026.317.274-.106.194-.031.207-.404-.2-.205-.504.036-.346-.017-.023.061ZM32.689 39.691l.311.014.377.172-.087.215-.401-.042-.069-.197-.131-.162ZM24.467 34.875l.207.088.12.361-.046.194.171.085.007.787-.35.064-.125-.241.162-.211-.019-.473-.227.346-.55.268.112-.368.296-.144.3-.262-.125-.299-.458-.102.087-.25.438.157ZM29.016 60.816c4.975 2.123 6.931 3.848 6.873 5.037-.036.759-2.064-1.616-3.276-2.45-1.397-1.066-2.85-2.003-4.338-2.293-1.439-.274-12.052 3.956-17.17.279 5.388-.348 12.303-2.967 17.911-.573ZM6.813 25.003c-.011.189-.549.992-.505.922 2.03-3.123 3.046-2.529 5.256-4.436-.36 3.499-4.355 5.69-6.286 7.176-.919-5.187.197-9.712 2.892-13.651-.732 3.896-.933 4.149-1.357 9.989Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M7.6 23.499c.226-3.589 2.605-5.863 5.387-7.349-.807 2.361-2.061 5.467-5.387 7.349ZM4.412 32.17c.711-1.886 2.571-4.12 4.538-5.169-.271 3.674-3.502 6.213-5.209 9.451-1.974-4.639-2.873-10.94-.046-15.444.031 3.53 1.088 8.229.717 11.162Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M4.021 38.721c.628-2.016 1.156-3.843 2.773-5.42 1.077 2.977-.867 6.349-2.139 9.101C1.524 38.887-.55 35.164.379 29.574c1.187 3.134 2.032 6.267 3.642 9.147Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M5.756 46.212c-.043-3.684.321-5.123 1.396-7.31 1.707 3.587.695 7.651.424 11.502C2.751 47.101.55 43.548 0 37.959c2.029 3.13 4.53 5.162 5.756 8.253Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M12.811 56.403c-3.414-.611-7.274-1.75-8.89-5.251l-1.706-4.461c1.891 2.866 3.923 3.245 7.096 6.463-1.141-4.233-.272-5.152-.632-7.951 2.965 2.888 3.055 7.349 4.132 11.2Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M19.276 59.555c-2.874-.174-5.837 1.486-8.44 0-1.527-.877-2.965-2.449-4.042-3.85 1.975 1.312 6.02.742 8.445 2.317-2.314-1.924-1.22-4.645-2.869-7.43-.012-.058-.007-.051-.007-.051 3.893 1.585 3.932 7.852 6.913 9.014ZM30.329 60.816c-4.977 2.123-6.934 3.848-6.875 5.037.037.759 2.063-1.616 3.274-2.45 1.399-1.066 2.852-2.003 4.341-2.293 1.439-.274 12.051 3.956 17.17.279-5.387-.348-12.303-2.967-17.91-.573ZM52.529 25.003c.014.189.552.992.508.922-2.031-3.123-3.047-2.529-5.256-4.436.358 3.499 4.353 5.69 6.287 7.176.916-5.187-.198-9.712-2.892-13.651.727 3.896.929 4.149 1.353 9.989Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M51.746 23.499c-.23-3.589-2.606-5.863-5.388-7.349.807 2.361 2.059 5.467 5.388 7.349ZM54.934 32.17c-.713-1.886-2.573-4.12-4.541-5.169.272 3.674 3.504 6.213 5.209 9.451 1.975-4.639 2.873-10.94.046-15.444-.028 3.53-1.087 8.229-.714 11.162Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M55.324 38.721c-.63-2.016-1.158-3.843-2.776-5.42-1.077 2.977.87 6.349 2.139 9.101 3.135-3.515 5.208-7.238 4.278-12.828-1.187 3.134-2.034 6.267-3.641 9.147Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M53.588 46.212c.041-3.684-.319-5.123-1.397-7.31-1.705 3.587-.691 7.651-.423 11.502 4.826-3.303 7.026-6.856 7.577-12.445-2.034 3.13-4.529 5.162-5.757 8.253Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M46.534 56.403c3.41-.611 7.273-1.75 8.889-5.251l1.706-4.461c-1.89 2.866-3.923 3.245-7.095 6.463 1.142-4.233.27-5.152.631-7.951-2.964 2.888-3.054 7.349-4.131 11.2Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M40.067 59.555c2.873-.174 5.837 1.486 8.443 0 1.526-.877 2.961-2.449 4.038-3.85-1.975 1.312-6.018.742-8.445 2.317 2.318-1.924 1.221-4.645 2.872-7.43l.008-.051c-3.896 1.585-3.935 7.852-6.916 9.014Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M46.43 36.373a16.712 16.712 0 0 0-4.786-11.534l2.582-2.582a20.352 20.352 0 0 1 5.856 14.116H46.43ZM41.644 48.28a16.71 16.71 0 0 0 4.786-11.534h3.652a20.354 20.354 0 0 1-5.856 14.116l-2.582-2.582Zm-11.798 5.05a16.719 16.719 0 0 0 11.535-4.786l2.581 2.582c-3.646 3.58-8.625 5.807-14.116 5.856V53.33Zm-11.907-4.786a16.716 16.716 0 0 0 11.534 4.786v3.652a20.354 20.354 0 0 1-14.116-5.856l2.582-2.582ZM12.89 36.746a16.71 16.71 0 0 0 4.785 11.534l-2.581 2.582a20.359 20.359 0 0 1-5.857-14.116h3.653Zm4.785-11.907a16.711 16.711 0 0 0-4.785 11.534H9.237a20.357 20.357 0 0 1 5.857-14.116l2.581 2.582Zm11.798-5.05a16.72 16.72 0 0 0-11.535 4.786l-2.581-2.582a20.354 20.354 0 0 1 14.116-5.856v3.652Zm11.908 4.786a16.719 16.719 0 0 0-11.535-4.786v-3.652c5.491.049 10.47 2.276 14.116 5.856l-2.581 2.582Zm1.021 11.798a12.707 12.707 0 0 0-3.604-8.688l2.583-2.583a16.343 16.343 0 0 1 4.676 11.271h-3.655Zm-3.604 9.061a12.705 12.705 0 0 0 3.604-8.688h3.655a16.343 16.343 0 0 1-4.676 11.271l-2.583-2.583Zm-8.952 3.868a12.7 12.7 0 0 0 8.688-3.605l2.583 2.583a16.348 16.348 0 0 1-11.271 4.677v-3.655Zm-9.061-3.605a12.701 12.701 0 0 0 8.688 3.605v3.655a16.35 16.35 0 0 1-11.271-4.676l2.583-2.584Zm-3.868-8.951a12.7 12.7 0 0 0 3.605 8.688l-2.584 2.583a16.343 16.343 0 0 1-4.676-11.271h3.655Zm3.605-9.061a12.701 12.701 0 0 0-3.605 8.688h-3.655a16.343 16.343 0 0 1 4.676-11.271l2.584 2.583Zm8.951-3.868a12.701 12.701 0 0 0-8.688 3.605l-2.583-2.583a16.341 16.341 0 0 1 11.271-4.677v3.655Zm9.061 3.605a12.7 12.7 0 0 0-8.688-3.605v-3.655a16.344 16.344 0 0 1 11.271 4.677l-2.583 2.583Zm-.157 8.951a8.691 8.691 0 0 0-2.424-5.843l2.581-2.581a12.328 12.328 0 0 1 3.495 8.424h-3.652Zm-2.424 6.216a8.691 8.691 0 0 0 2.424-5.843h3.652a12.332 12.332 0 0 1-3.495 8.425l-2.581-2.582Zm-6.107 2.688a8.689 8.689 0 0 0 5.843-2.424l2.581 2.581a12.324 12.324 0 0 1-8.424 3.495v-3.652Zm-6.216-2.424a8.691 8.691 0 0 0 5.843 2.424v3.652a12.325 12.325 0 0 1-8.424-3.495l2.581-2.581Zm-2.687-6.107a8.686 8.686 0 0 0 2.424 5.843l-2.582 2.582a12.332 12.332 0 0 1-3.495-8.425h3.653Zm2.424-6.216a8.686 8.686 0 0 0-2.424 5.843H17.29a12.328 12.328 0 0 1 3.495-8.424l2.582 2.581Zm6.106-2.688a8.687 8.687 0 0 0-5.843 2.425l-2.581-2.582a12.33 12.33 0 0 1 8.424-3.495v3.652Zm6.216 2.425a8.685 8.685 0 0 0-5.843-2.425V24.19a12.328 12.328 0 0 1 8.424 3.495l-2.581 2.582Zm-1.337 6.106a4.687 4.687 0 0 0-1.244-2.998l2.581-2.581a8.317 8.317 0 0 1 2.315 5.579h-3.652Zm-1.244 3.371a4.685 4.685 0 0 0 1.244-2.998h3.652a8.317 8.317 0 0 1-2.315 5.579l-2.581-2.581Zm-3.262 1.507a4.676 4.676 0 0 0 2.998-1.244l2.582 2.582a8.32 8.32 0 0 1-5.58 2.315v-3.653Zm-3.37-1.244a4.671 4.671 0 0 0 2.997 1.244v3.653a8.317 8.317 0 0 1-5.579-2.315l2.582-2.582Zm-1.508-3.261a4.68 4.68 0 0 0 1.244 2.998l-2.582 2.581a8.311 8.311 0 0 1-2.314-5.579h3.652Zm1.244-3.371a4.681 4.681 0 0 0-1.244 2.998h-3.652a8.311 8.311 0 0 1 2.314-5.579l2.582 2.581Zm3.261-1.507a4.676 4.676 0 0 0-2.997 1.243l-2.582-2.581a8.317 8.317 0 0 1 5.579-2.315v3.653Zm3.371 1.243a4.68 4.68 0 0 0-2.998-1.243v-3.653a8.321 8.321 0 0 1 5.58 2.315l-2.582 2.581Zm-3.184 7.772a4.328 4.328 0 0 1-4.324-4.323 4.329 4.329 0 0 1 4.324-4.324 4.328 4.328 0 0 1 4.323 4.324 4.328 4.328 0 0 1-4.323 4.323Zm0-25.121c-11.468 0-20.798 9.329-20.798 20.798 0 11.468 9.33 20.798 20.798 20.798 11.467 0 20.797-9.33 20.797-20.798 0-11.469-9.33-20.798-20.797-20.798Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m44.313 15.637-9.945-2.642 1.713-3.349a.185.185 0 0 0-.03-.222.182.182 0 0 0-.221-.029l-3.35 1.713-2.642-9.946a.183.183 0 0 0-.178-.14.186.186 0 0 0-.179.14l-2.642 9.946-3.349-1.713a.182.182 0 0 0-.221.029.185.185 0 0 0-.03.222l1.713 3.349-9.946 2.642a.183.183 0 0 0 0 .356l9.946 2.642-1.713 3.35a.183.183 0 0 0 .251.25l3.349-1.712 2.642 9.945c.021.082.095.14.179.14a.183.183 0 0 0 .178-.14l2.642-9.945 3.35 1.712a.183.183 0 0 0 .251-.25l-1.713-3.35 9.945-2.642a.183.183 0 0 0 0-.356Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="M29.641 30.542a.404.404 0 0 1-.393-.307l-2.428-9.712-3.117 1.781a.403.403 0 0 1-.551-.551l1.781-3.118-9.713-2.428a.403.403 0 0 1 .001-.784l9.712-2.428-1.781-3.117a.404.404 0 0 1 .551-.552l3.117 1.782 2.429-9.713a.403.403 0 0 1 .784.001l2.428 9.712 3.118-1.782a.404.404 0 0 1 .551.551l-1.781 3.118 9.712 2.428a.403.403 0 0 1-.001.784l-9.711 2.428 1.781 3.118a.404.404 0 0 1-.066.487.413.413 0 0 1-.485.064l-3.118-1.781-2.428 9.712a.404.404 0 0 1-.392.307Z" style="fill:none;stroke:#005aaa;stroke-width:.3px" transform="translate(0 -3.704) scale(4.16667)"/><path d="M29.641 30.542a.404.404 0 0 1-.393-.307l-2.428-9.712-3.117 1.781a.403.403 0 0 1-.551-.551l1.781-3.118-9.713-2.428a.403.403 0 0 1 .001-.784l9.712-2.428-1.781-3.117a.404.404 0 0 1 .551-.552l3.117 1.782 2.429-9.713a.403.403 0 0 1 .784.001l2.428 9.712 3.118-1.782a.404.404 0 0 1 .551.551l-1.781 3.118 9.712 2.428a.403.403 0 0 1-.001.784l-9.711 2.428 1.781 3.118a.404.404 0 0 1-.066.487.413.413 0 0 1-.485.064l-3.118-1.781-2.428 9.712a.404.404 0 0 1-.392.307Z" style="fill:none;stroke:#005aaa;stroke-width:.4px" transform="translate(0 -3.704) scale(4.16667)"/><path d="m15.831 15.815 9.718-2.426 4.092 2.426h-13.81ZM43.451 15.815l-9.718 2.426-4.092-2.426h13.81ZM29.641 29.625l-2.426-9.718 2.426-4.092v13.81Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m29.641 2.005 2.425 9.718-2.425 4.092V2.005Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/><path d="m23.886 10.05 3.709 2.145 2.046 3.62-5.755-5.765ZM35.459 21.622l-3.709-2.144-2.109-3.663 5.818 5.807ZM23.887 21.623l2.145-3.709 3.609-2.099-5.754 5.808ZM35.459 10.05l-2.145 3.708-3.673 2.057 5.818-5.765Z" style="fill:#000000;fill-rule:nonzero" transform="translate(0 -3.704) scale(4.16667)"/></svg>
	</xsl:variable>

	<!-- IHO three-tile emblem for the conjunction statement -->
	<xsl:variable name="WMO-IHO-Emblem">
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2000.5 667">
<g id="uuid-cc53c83d-696a-477a-bb10-6f5f1da40b87"><rect x="666.5" width="667" height="667" style="fill:#01a9aa;"/><rect x="1333.5" width="667" height="667" style="fill:#f0ebd8;"/><rect width="667" height="667" style="fill:#00154c;"/><path d="M345.73,314.66v-75.32c-4.09-.54-8.25-.82-12.48-.82s-8.57.3-12.73.86v75.28h25.22Z" style="fill:#fdda5a;"/><path d="M215.62,172.83l9.45,13,95.44,7.97v9.33c4.21-.4,8.45-.61,12.73-.61s8.36.2,12.48.59v-9.31l93.48-7.68,10.74-13.29-104.22-8.45v-7.09c8.47-4.6,14.23-13.57,14.23-23.89,0-15-12.16-27.16-27.16-27.16s-27.16,12.16-27.16,27.16c0,3.66.74,7.15,2.05,10.33,4.9-3.49,9.75-6.94,13.33-9.49,0-.12-.02-.23-.02-.35,0-6.52,5.29-11.81,11.81-11.81s11.81,5.29,11.81,11.81c0,4.99-3.09,9.24-7.46,10.98l-2.47,1.76-14.87,10.62c.22.12.44.25.67.37v6.76l-104.89,8.45Z" style="fill:#fdda5a;"/><path d="M362.63,311.41c-.73-.06-1.45-.05-2.17-.01-2.24-5.11-4.71-10.73-6.47-14.73,2.05-.98,3.92-2.4,5.45-4.28,5.55-6.8,4.54-16.81-2.26-22.36-1.02-.83-3.22-2.99-5.58-5.31v9.72c.44.4.82.74,1.15,1,3.8,3.1,4.37,8.71,1.27,12.51-.68.84-1.51,1.52-2.41,2.05v24.68s0,0,0,.02c-3.4,2.64-5.74,6.63-6.11,11.25-.23,2.86-2.46,13.85-2.76,17.56-.55,6.7,3.16,12.76,8.85,15.55-.63,3.84-1.31,8.05-1.95,11.98-5.46.88-10.3,4.59-12.37,10.14-1,2.69-6.13,12.65-7.43,16.14-2.18,5.86-.67,12.19,3.35,16.45-1.95,3.31-4.1,6.95-6.11,10.37-.81-.13-1.62-.19-2.43-.19-5.07,0-10.05,2.42-13.13,6.91-1.62,2.37-9.01,10.8-11.11,13.87-4.15,6.06-3.52,13.96,1.03,19.29l-3.82,5.59,9.38,2.97,2.38-3.53c1.36.37,2.74.56,4.13.56,5.07,0,10.05-2.42,13.13-6.91,1.62-2.37,9.01-10.8,11.11-13.87,4.5-6.57,3.38-15.3-2.26-20.57,1.93-3.28,3.96-6.73,5.81-9.89,1.15.26,2.3.4,3.44.4,6.45,0,12.51-3.95,14.9-10.35,1-2.69,6.13-12.65,7.43-16.14,2.92-7.82-.73-16.47-8.17-19.94.63-3.87,1.3-8.01,1.91-11.81,7.2-1.01,13.01-6.89,13.63-14.44.23-2.86,2.46-13.85,2.76-17.56.71-8.75-5.8-16.42-14.55-17.13ZM331.95,444.89c-.94,1.37-3.63,4.62-5.8,7.23-2.71,3.27-4.42,5.34-5.31,6.64-1.62,2.36-4.27,3.78-7.13,3.86l2.71-4.03h0c.32-.57.53-1.2.59-1.88.22-2.57-1.68-4.83-4.25-5.05-1.67-.14-3.2.62-4.14,1.87h0s-2.98,4.35-2.98,4.35c-.41-.78-.7-1.62-.87-2.51-.44-2.34.06-4.7,1.41-6.66.94-1.37,3.63-4.62,5.8-7.23,2.71-3.27,4.42-5.34,5.31-6.64,1.34-1.95,3.39-3.25,5.67-3.69-1.94,3.29-3.34,5.68-3.66,6.23-1.29,2.23-.52,5.09,1.71,6.38s5.09.52,6.38-1.71c.18-.31,1.95-3.32,4.38-7.46,2.19,2.96,2.39,7.1.19,10.31ZM360.24,383.04c.99,2.16,1.07,4.58.24,6.8-.58,1.55-2.41,5.36-3.88,8.41-1.84,3.83-3,6.25-3.55,7.73-1.24,3.32-4.36,5.57-7.87,5.76,1.06-1.8,1.89-3.21,2.37-4.03.15-.2.27-.42.38-.65.05-.09.08-.14.08-.14h0c.27-.59.42-1.24.42-1.92,0-2.58-2.09-4.67-4.67-4.67-1.68,0-3.14.89-3.96,2.22h0s-1.11,1.87-2.79,4.73c-1.26-2.21-1.57-4.95-.62-7.51.58-1.55,2.41-5.36,3.88-8.41,1.84-3.83,3-6.25,3.55-7.73.83-2.22,2.5-3.96,4.57-4.94-.6,3.7-1.03,6.38-1.13,7-.39,2.55,1.36,4.93,3.91,5.33,2.55.39,4.93-1.36,5.33-3.91.05-.32.52-3.23,1.18-7.34,1.09.86,1.97,1.97,2.56,3.27ZM370.2,327.98c-.13,1.65-.86,5.81-1.45,9.15-.73,4.18-1.19,6.83-1.32,8.41-.28,3.42-2.47,6.23-5.43,7.47.38-2.33.68-4.18.84-5.2.06-.24.1-.49.12-.74.02-.1.03-.16.03-.16h0c.04-.64-.05-1.3-.3-1.94-.94-2.4-3.64-3.59-6.05-2.66-1.56.61-2.6,1.97-2.89,3.51h0s-.37,2.28-.94,5.76c-2.1-1.79-3.34-4.52-3.1-7.48.13-1.65.86-5.81,1.45-9.15.73-4.18,1.19-6.83,1.32-8.41.16-1.99.98-3.76,2.21-5.15,1.07,2.38,2.1,4.72,2.45,5.74.85,2.44,3.51,3.73,5.94,2.88,2.44-.85,3.73-3.51,2.88-5.94-.09-.26-1-2.36-2.31-5.38,4.07,1.09,6.91,4.96,6.56,9.31Z" style="fill:#fdda5a;"/><path d="M314.84,237.85c-.99-2.69-3.59-13.6-4.88-17.09-2.29-6.22-8.08-10.14-14.32-10.38-.78-2.82-1.62-5.9-2.45-8.93,1.25-.85,2.37-1.87,3.34-3.04-8.7-.79-17.64-1.59-26.13-2.35,2.25,4.03,6.23,7.05,11.14,7.9.92.16,1.83.24,2.74.24.79,2.91,1.6,5.85,2.34,8.58-6.26,3.9-9.14,11.78-6.49,18.97.99,2.69,3.59,13.6,4.88,17.09,2.37,6.42,8.45,10.4,14.91,10.4,1.83,0,3.68-.32,5.49-.98.65-.24,1.26-.52,1.85-.83,2.62,2.56,5.5,5.37,8.24,8.05v-13.04c-.54-.53-1.08-1.05-1.61-1.57,2.08-3.87,2.57-8.58.93-13.02ZM304.96,242.14c-.16-.19-.35-.36-.54-.53-.07-.07-.12-.12-.12-.12h0c-.51-.39-1.1-.7-1.76-.87-.37-.09-.75-.14-1.12-.14-2.1,0-4.01,1.43-4.53,3.56-.4,1.63.12,3.26,1.21,4.38h0s1.45,1.42,3.68,3.6c-.61.13-1.22.2-1.84.2-3.71,0-7.06-2.34-8.35-5.82-.57-1.56-1.66-5.63-2.54-8.91-1.1-4.1-1.8-6.69-2.34-8.18-1.21-3.29-.34-6.84,1.93-9.22.69,2.53,1.18,4.3,1.32,4.78.7,2.48,3.28,3.92,5.77,3.22,2.48-.7,3.92-3.28,3.22-5.77-.07-.24-.55-1.98-1.26-4.59,2.6.81,4.75,2.78,5.72,5.42.57,1.56,1.66,5.63,2.54,8.91,1.1,4.1,1.8,6.69,2.34,8.18.64,1.74.72,3.59.25,5.35-1.6-1.56-2.85-2.78-3.56-3.47Z" style="fill:#fdda5a;"/><path d="M330.34,135.59c-1.53-.68-3.23-.46-4.52.42h0s-15.71,11.17-25.45,18.12c-2.22-2.17-5.09-3.72-8.37-4.29-.92-.16-1.84-.24-2.75-.24-7.58,0-14.29,5.44-15.64,13.16-.01.07-.03.15-.04.23l7.37-.62c1.28-3.42,4.55-5.77,8.31-5.77.51,0,1.03.05,1.55.14,1.37.24,2.63.79,3.71,1.58-.8.57-1.37.98-1.59,1.14-.73.53-1.26,1.24-1.57,2.03l16.79-1.42c8.43-6.02,19.71-14.07,22.68-16.19.22-.13.42-.28.61-.44.08-.06.14-.1.14-.1h0c.48-.43.89-.96,1.17-1.59,1.05-2.36,0-5.12-2.36-6.17Z" style="fill:#fdda5a;"/><path d="M367.51,382.73v8.09c.73-2.73.68-5.5,0-8.09Z" style="fill:#fdda5a;"/><path d="M324.31,418.97l2.83-4.8c-3.54-5.48-4.34-12.31-2-18.58.77-2.07,2.57-5.81,4.31-9.43,1.28-2.66,2.73-5.67,3.12-6.71,2.18-5.85,6.86-10.37,12.65-12.41l.51-3.1v-2.66c-3.4-2.64-5.88-6.22-7.12-10.27h-18.09v68.37c1.24-.25,2.51-.39,3.8-.41Z" style="fill:#fdda5a;"/><path d="M298.14,346h39.57c-.03-.46-.04-.93-.03-1.4,0-.01,0-.03,0-.04,0-.48.03-.96.07-1.45.18-2.2.9-6.29,1.59-10.25.51-2.91,1.09-6.2,1.18-7.31.05-.56.12-1.11.21-1.65.05-.28.11-.56.17-.84.05-.24.1-.47.16-.71.09-.37.19-.74.3-1.1.03-.11.07-.22.1-.33.14-.43.28-.85.45-1.26h0s-43.76,0-43.76,0v-55.42h-28.77v138.67h28.77v-56.91Z" style="fill:#fdda5a;"/><path d="M367.51,264.24v13.63c.07.31.12.62.18.94.04.21.07.43.1.64.07.5.12.99.16,1.49.01.18.02.37.03.55.02.56.02,1.11,0,1.67,0,.14,0,.28-.02.42-.06,1.08-.21,2.16-.44,3.23v20.48c.2.06.39.14.58.2.36.12.71.25,1.06.39.23.09.45.19.68.29.32.14.64.3.96.45.2.1.41.2.61.31.49.27.96.55,1.43.85.1.06.19.13.28.2.39.27.77.55,1.15.84.15.12.31.25.46.38.32.27.63.55.94.83.13.13.27.25.4.38.42.42.83.85,1.22,1.31,3.61,4.25,5.35,9.66,4.9,15.22-.18,2.2-.9,6.29-1.59,10.25-.51,2.91-1.09,6.2-1.18,7.31-.04.51-.1,1.01-.18,1.5-.03.17-.06.34-.09.5-.06.32-.11.64-.19.96-.05.2-.1.4-.15.6-.07.27-.14.55-.22.81-.07.22-.14.43-.21.65-.08.24-.17.48-.26.72-.09.23-.18.45-.27.67-.09.22-.18.43-.28.64-.11.24-.22.47-.33.7-.09.18-.19.36-.29.55-.13.25-.27.49-.41.73-.08.14-.18.28-.26.42-.17.27-.34.54-.52.8-.05.07-.1.13-.15.2-1.27,1.78-2.8,3.34-4.56,4.64,0,0,0,0,0,0-.35.26-.72.51-1.09.75-.01,0-.03.02-.04.03-.37.24-.75.46-1.13.67-.01,0-.03.01-.04.02-.39.22-.79.42-1.2.61v8.95c1.6,1.75,2.88,3.76,3.8,5.92,0,.01.01.03.02.04.16.38.31.76.44,1.15.03.1.07.19.1.29.12.35.23.71.33,1.07.04.13.07.27.11.41.09.34.18.69.25,1.03.03.16.06.31.09.47.19,1.04.31,2.1.34,3.16,0,.28.02.57.02.85,0,.24-.02.47-.03.71-.01.3-.03.6-.06.9-.02.23-.04.45-.07.68-.04.32-.09.63-.14.95-.04.21-.07.42-.11.63-.07.35-.16.7-.25,1.05-.04.17-.08.35-.13.52-.15.52-.31,1.04-.51,1.56-.09.25-.21.53-.33.83-.04.1-.09.21-.13.32-.09.21-.17.42-.27.64-.06.14-.13.3-.2.44-.09.21-.18.41-.28.63-.08.17-.16.35-.24.52-.1.21-.19.42-.29.64-.09.2-.19.41-.29.61-.09.2-.19.4-.28.61-.11.23-.22.47-.33.71-.09.19-.18.38-.27.57-.12.26-.25.51-.37.77-.09.18-.17.36-.26.54-.16.32-.31.65-.47.97-.01.03-.03.06-.04.09h28.6v-138.67h-28.77Z" style="fill:#fdda5a;"/><path d="M297.62,453.35s0,0,0,0c0,0,0-.02,0-.02,0,0,0,.02,0,.02Z" style="fill:#fdda5a;"/><path d="M292.72,451.78s0,0,0,0c.03-.38.08-.76.14-1.14.01-.07.02-.15.03-.22.05-.34.12-.68.19-1.01.02-.12.05-.23.07-.35.07-.31.15-.61.23-.91.04-.15.08-.3.13-.45.08-.28.17-.55.26-.82.06-.18.13-.36.2-.54.09-.24.18-.49.29-.73.09-.21.19-.42.28-.63.1-.21.19-.42.29-.62.13-.26.27-.51.41-.76.09-.16.17-.32.26-.47.24-.41.49-.81.77-1.21,1.25-1.82,3.9-5.02,6.46-8.11.31-.38.63-.76.95-1.14.02-.03.05-.06.07-.09.32-.39.64-.78.96-1.16-42.43-12.35-73.44-51.51-73.44-97.93,0-36.15,18.81-67.91,47.18-86.02-1.73-6.25-3.75-14.28-4.7-16.85-.77-2.1-1.2-4.25-1.32-6.37-9.98,5.58-19.26,12.56-27.56,20.87-23.61,23.61-36.61,54.99-36.61,88.37s13,64.77,36.61,88.37c13.7,13.7,30.03,23.82,47.85,29.91Z" style="fill:#fdda5a;"/><path d="M482.4,415.39l-7.09,12.11,8.27,4.73s-91.47,40.65-137.86,48.14v-22.51c28.67-2.82,55.25-15.35,75.89-35.99,23.61-23.61,36.61-54.99,36.61-88.37s-13-64.77-36.61-88.37c-23.61-23.61-54.99-36.61-88.37-36.61-7.28,0-14.47.62-21.51,1.83,1.14,1.58,2.1,3.32,2.81,5.24,1.18,3.21,3.18,11,4.77,16.88,4.55-.62,9.2-.95,13.93-.95,56.32,0,101.98,45.66,101.98,101.98,0,52.26-39.32,95.34-89.99,101.27-.11.01-.21.02-.32.03.03.12.05.24.08.36.08.33.15.66.21.99.03.17.06.34.09.5.05.35.1.7.14,1.06h0c.01.13.03.25.04.38,0,0,0,.01,0,.02.03.4.05.8.06,1.2,0,.16,0,.32,0,.49,0,.34,0,.68-.02,1.02,0,.12,0,.25-.02.37-.03.44-.07.88-.13,1.32-.02.14-.04.28-.06.42-.05.35-.11.69-.18,1.04-.03.13-.05.25-.08.38-.1.44-.21.89-.34,1.33-.02.06-.04.12-.06.19-.01.04-.03.09-.04.13-.11.36-.23.72-.37,1.07-.05.12-.09.24-.14.37-.17.44-.36.88-.56,1.31-.03.06-.07.13-.1.19-.18.38-.38.75-.59,1.12-.07.12-.13.23-.2.35-.25.42-.51.85-.79,1.26-.15.21-.31.45-.5.7-.06.09-.14.18-.2.27-.13.17-.25.34-.39.52-.09.11-.18.23-.27.34-.08.11-.17.22-.26.34-.05.07-.1.13-.16.2-.1.13-.21.26-.31.39-.14.18-.29.37-.44.55-.11.14-.23.28-.34.43-.15.19-.31.38-.46.57-.13.16-.25.31-.38.47-.11.14-.23.28-.34.41-.42.52-.86,1.04-1.3,1.57h0c-.37.45-.74.89-1.11,1.34-1.88,2.27-4.02,4.85-4.65,5.76-2.53,3.69-6.13,6.41-10.23,7.87v7c-3.52-.56-7.3-1.3-11.27-2.2l-.2.29-3.57-1.13-.61-.19c-49.1-12.02-123.43-44.64-123.43-44.64l9.43-5.6-7.97-12.7-49.16,27.97,9.75,14.84,14.4-9.53,175.37,112.61,174.56-112.24,14.77,8.86,8.57-13.88-48.73-27.47Z" style="fill:#fdda5a;"/></g>
		</svg>
	</xsl:variable>

	<!-- WMO "CONTENTS": bold caps, no rule (WMO-No. 574 style) -->
	<xsl:attribute-set name="toc-title-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">16pt</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-top">4pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">7.5pt</xsl:attribute>
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template name="back-page">
		<fo:page-sequence master-reference="back-page" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body">
				<fo:block-container absolute-position="absolute" left="0mm" top="0mm" width="210mm" height="297mm" background-color="{$wmo_back_blue}" font-size="0pt" role="SKIP">
					<fo:block font-size="0pt" role="SKIP"><fo:wrapper role="artifact">&#160;</fo:wrapper></fo:block>
				</fo:block-container>
				<fo:block-container absolute-position="absolute" left="60mm" top="216mm" width="120mm">
					<fo:block color="white" font-size="7pt" text-align="right">For more information, please contact:</fo:block>
					<fo:block color="white" font-size="10pt" font-weight="bold" text-align="right" margin-top="1.5mm">World Meteorological Organization</fo:block>
					<fo:block color="white" font-size="7pt" text-align="right" margin-top="0.8mm">7 bis, avenue de la Paix &#8211; P.O. Box 2300 &#8211; CH-1211 Geneva 2 &#8211; Switzerland</fo:block>
					<fo:block color="white" font-size="7.5pt" font-weight="bold" text-align="right" margin-top="2.2mm">Strategic Communications Office</fo:block>
					<fo:block color="white" font-size="7pt" text-align="right" margin-top="0.8mm">Tel.: +41 (0) 22 730 83 14</fo:block>
					<fo:block color="white" font-size="7pt" text-align="right">Email: spa@wmo.int</fo:block>
					<fo:block color="white" font-size="8pt" font-weight="bold" text-align="right" margin-top="1.5mm">wmo.int</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>

</xsl:stylesheet>
