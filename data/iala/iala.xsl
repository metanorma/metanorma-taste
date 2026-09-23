<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<xsl:variable name="marginTop">19</xsl:variable>
	<xsl:variable name="marginBottom">25.8</xsl:variable>
	<xsl:variable name="marginLeftRight1">16</xsl:variable>
	<xsl:variable name="marginLeftRight2">13.2</xsl:variable>

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
					<title>
						<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:title">
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
					<urn>urn:<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'urn']"/></urn>

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
			
			<!-- Preface pages -->
			<fo:page-sequence-master master-name="preface">
				<fo:repeatable-page-master-alternatives>
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
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="page"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="page"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-portrait">
				<fo:repeatable-page-master-alternatives>
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
				<fo:block text-align="center" font-size="10pt" role="SKIP">
					<fo:block margin-top="9mm" font-weight="bold">
						<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization/mn:name"/>
					</fo:block>
					<fo:block>
						<fo:basic-link external-destination="http://www.iala.net" fox:alt-text="www.iala.net">www.iala.net</fo:basic-link>
					</fo:block>
				</fo:block>
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
							<xsl:when test="$doctype = 'standard'"><xsl:value-of select="$color_corporate_blue"/></xsl:when>
							<xsl:when test="$doctype = 'recommendation'"><xsl:value-of select="$color_primary_recommendation_50"/></xsl:when>
							<xsl:when test="$doctype = 'model-course'"><xsl:value-of select="$color_primary_model_course"/></xsl:when>
							<!-- default, for doctype 'guideline' -->
							<xsl:otherwise><xsl:value-of select="$color_corporate_light_blue"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					
					<fo:block font-size="25pt" font-weight="bold" margin-left="17mm" margin-right="17mm" margin-top="4pt" text-transform="uppercase">
						<xsl:call-template name="getVariable"><xsl:with-param name="variable">doctype_full</xsl:with-param></xsl:call-template>
					</fo:block>
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
	</xsl:template> <!-- END cover-page -->

	<xsl:template name="inner-cover-page">
		<!-- empty -->
	</xsl:template>

	<xsl:attribute-set name="page-sequence-preface"><?extend?>
		<xsl:attribute name="format">1</xsl:attribute>
		<xsl:attribute name="force-page-count">no-force</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="page-sequence-main"><?extend?>
		<xsl:attribute name="force-page-count">no-force</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_page-sequence-main"><?extend?>
		<xsl:attribute name="initial-page-number">auto</xsl:attribute>
	</xsl:template>

	<!-- DOCUMENT REVISION -->
	<xsl:template match="mn:clause[@type = 'revision']" mode="contents"/>
	<xsl:template match="mn:clause[@type = 'revision']" priority="3">
		<fo:block role="Sect" break-after="page">
			<xsl:apply-templates/>
		</fo:block>
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

	<xsl:template name="refine_toc-item-block-style">
		<xsl:attribute name="text-transform">uppercase</xsl:attribute>
		<xsl:attribute name="line-height">1.4</xsl:attribute>
		<xsl:attribute name="margin-right">8mm</xsl:attribute>
		<xsl:attribute name="provisional-distance-between-starts">
			<xsl:choose>
				<xsl:when test="@root = 'preface'">0mm</xsl:when>
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
		<xsl:attribute name="text-transform">uppercase</xsl:attribute>
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
		<xsl:apply-templates select="../mn:clause[@type = 'revision']" mode="update_xml_step1">
			<xsl:with-param name="process">true</xsl:with-param>
		</xsl:apply-templates>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:preface/mn:clause[@type = 'revision']" mode="update_xml_step1" priority="4">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step1"/>
				<xsl:attribute name="displayorder">-1</xsl:attribute>
				
				<xsl:apply-templates select="node()" mode="update_xml_step1"/>
			</xsl:copy>
		</xsl:if>
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
	<!-- ============================================================ -->

	<!-- keep ' — ' -->
	<xsl:template match="mn:figure/mn:fmt-name/mn:span[@class = 'fmt-caption-delim']" mode="update_xml_step1" priority="4">
		<padding value="5mm"/>
	</xsl:template>
	
	<!-- ============================================================ -->
	<!-- ============================================================ -->

	<!-- <xsl:template match="mn:figure/mn:fmt-name/mn:span[@class = 'fmt-caption-delim']" priority="4">
		<fo:inline padding-right="5mm" role="SKIP"><xsl:value-of select="$zero_width_space"/></fo:inline>
	</xsl:template> -->
	<xsl:template name="refine_table-container-style"><?extend?>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_table-header-row-style"><?extend?>
		<xsl:attribute name="background-color">transparent</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
	</xsl:template>
	
	<xsl:template name="refine_table-header-cell-style"><?extend?>
		<xsl:attribute name="padding-left">4mm</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="refine_table-body-row-style"><?extend?>
		<!-- @type added in <xsl:template match="mn:table" mode="document_revision"> -->
		<xsl:if test="ancestor::mn:table[@type = 'revision']">
			<!--not 15mm, because there are padding-top and padding-bottom -->
			<xsl:attribute name="min-height">12mm</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="refine_table-cell-style"><?extend?>
		<xsl:attribute name="padding-left">4mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:template>

	<xsl:template name="refine_list-item-label-style"><?extend?>
		<xsl:if test="parent::mn:ul">
			<xsl:attribute name="color"><xsl:value-of select="$color_corporate_blue"/></xsl:attribute>
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

	<xsl:template name="insertHeaderFooter">
		<xsl:param name="orientation"/>
		
		<xsl:call-template name="insertHeader">
			<xsl:with-param name="orientation" select="$orientation"/>
		</xsl:call-template>
		
		<xsl:call-template name="insertFooter"/>
	</xsl:template>

	<xsl:template name="insertHeader">
		<fo:static-content flow-name="header" role="artifact">
			<fo:block text-align="right" margin-top="7.5mm" margin-right="-4.5mm" font-size="0pt">
				<xsl:if test="xalan:nodeset($IALA-Logo)/*">
					<fo:instream-foreign-object content-width="7.25mm" fox:alt-text="Image Logo IALA" fox:placement="Block">
						<xsl:copy-of select="$IALA-Logo"/>
					</fo:instream-foreign-object>
				</xsl:if>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="insertFooter">
		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container font-size="7.56pt" font-weight="bold" color="{$color_corporate_blue}" border-top="0.2pt solid black" line-height="1.43">
				<fo:block margin-top="4.5mm">
					<xsl:call-template name="getVariable"><xsl:with-param name="variable">doctype_full</xsl:with-param></xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:call-template name="getVariable"><xsl:with-param name="variable">docidentifier</xsl:with-param></xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:variable name="title">
						<xsl:call-template name="getVariableCopyOf"><xsl:with-param name="variable">title</xsl:with-param></xsl:call-template>
					</xsl:variable>
					<xsl:for-each select="xalan:nodeset($title)/item">
						<xsl:text> </xsl:text>
						<xsl:copy-of select="node()"/>
					</xsl:for-each>
				</fo:block>
				<fo:block text-align-last="justify">
					<xsl:call-template name="getVariable"><xsl:with-param name="variable">edition</xsl:with-param></xsl:call-template>
					<xsl:text> </xsl:text>
					<fo:inline text-transform="lowercase"><xsl:call-template name="getVariable"><xsl:with-param name="variable">urn</xsl:with-param></xsl:call-template></fo:inline>
					<fo:leader leader-pattern="space"/>
					<xsl:text>P&#xa0;</xsl:text><fo:page-number />
				</fo:block>
			</fo:block-container>
		</fo:static-content>
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
