<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<xsl:attribute-set name="root-style">
		<xsl:attribute name="font-family">Source Sans Pro, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="17.5mm" margin-bottom="17.5mm" margin-left="17.5mm" margin-right="17.5mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="copyright-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="20mm" margin-bottom="35mm" margin-left="18mm" margin-right="18mm"/>
			</fo:simple-page-master>
		</fo:layout-master-set>
	</xsl:template>
		
	<xsl:variable name="cover_page_color_box1">rgb(202,152,49)</xsl:variable>
	<xsl:variable name="cover_page_color_box2">rgb(139,152,91)</xsl:variable>
	<xsl:variable name="cover_page_color_box3">rgb(208,63,78)</xsl:variable>
	<xsl:variable name="cover_page_color_box4">rgb(72,145,175)</xsl:variable>
	<xsl:variable name="cover_page_color_box_border_width">2.5pt</xsl:variable>
	<xsl:variable name="cover_page_color_box_height">57mm</xsl:variable>
	
	<xsl:attribute-set name="cover_page_box">
		<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
		<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		<xsl:attribute name="padding-top">-0.5mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">-0.5mm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="cover-page">
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body" font-family="Source Sans 3">
				
				<fo:block margin-top="-3mm" role="SKIP"> <!-- -3mm because there is a space before image in the source SVG -->
					<fo:inline-container width="47mm" role="SKIP">
						<fo:block font-size="0pt">
							<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization">
								<xsl:apply-templates select="mn:logo/mn:image"/>
							</xsl:for-each>
						</fo:block>
					</fo:inline-container>
				</fo:block>
				
				<!-- Type of document:
					Specification, Best Practice Guide, Application Note, Technical Note, Extension -->
				<fo:block font-size="29pt" font-weight="bold" text-align="right" margin-top="4mm">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) != '']"/>
				</fo:block>
				
				<fo:block-container width="112mm" line-height="1.2" margin-top="4mm">
					<!-- Main title of doc -->
					<fo:block font-size="32pt" font-weight="bold">
						<fo:block><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = 'intro-en']/node()"/></fo:block>
					</fo:block>
					<!-- Subtitle of doc -->
					<fo:block font-size="30pt">
						<fo:block><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = 'main-en']/node()"/></fo:block>
					</fo:block>
				</fo:block-container>
				
				<fo:block-container absolute-position="fixed" top="95mm" left="17.5mm" font-size="20pt">
					<fo:table table-layout="fixed" width="174mm">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell text-align="right" display-align="after" xsl:use-attribute-sets="cover_page_box"> <!-- padding-left="5mm" padding-right="5mm" -->
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$cover_page_color_box1}">
										<fo:block margin-left="5mm" margin-right="5mm">
											<fo:block>
												<!-- Status / Version.
												e.g. "Draft Release Candidate 1.2", or just a version -->
												<xsl:variable name="i18n_version"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">version</xsl:with-param></xsl:call-template></xsl:variable>
												<xsl:call-template name="capitalize">
													<xsl:with-param name="str" select="$i18n_version"/>
												</xsl:call-template>
												<xsl:text> </xsl:text>
												<xsl:variable name="edition" select="/mn:metanorma/mn:bibdata/mn:edition[normalize-space(@language) = '']"/>
												<xsl:value-of select="$edition"/>
												<xsl:if test="not(contains($edition, '.'))">.0</xsl:if>
											</fo:block>
											<fo:block margin-bottom="2mm">
												<xsl:value-of select="substring(/mn:metanorma/mn:bibdata/mn:version/mn:revision-date, 1, 7)"/>
											</fo:block>
										</fo:block>
									</fo:block-container>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell text-align="center" display-align="center" xsl:use-attribute-sets="cover_page_box">
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$cover_page_color_box2}">
										<fo:block font-size="0pt">
											<!-- set context node to the cover page image -->
											<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'coverpage-image'][1]/mn:value/mn:image[1]">
												<xsl:call-template name="insertPageImage">
													<xsl:with-param name="svg_content_height">53</xsl:with-param> <!-- this parameter is using for SVG images -->
													<xsl:with-param name="bitmap_width">53</xsl:with-param> <!-- this parameter is using for bitmap images -->
												</xsl:call-template>
											</xsl:for-each>
										</fo:block>
									</fo:block-container>
								</fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="after" xsl:use-attribute-sets="cover_page_box">
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$cover_page_color_box3}">
										<!-- the group that authored the doc -->
										<!-- Example: EA-PDF LWG -->
										<fo:block margin-left="5mm" margin-right="5mm" margin-bottom="3mm">
											<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role[@type = 'author' and 
											(mn:description[normalize-space(@language) = ''] = 'Technical committee' or mn:description[normalize-space(@language) = ''] = 'committee')]]/
											mn:organization/mn:subdivision[@type = 'Technical committee' or @type = 'Committee']/mn:name"/>
										</fo:block>
									</fo:block-container>
								</fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell display-align="after" xsl:use-attribute-sets="cover_page_box">
									<fo:block-container width="100%" height="{$cover_page_color_box_height}" border="{$cover_page_color_box_border_width} solid {$cover_page_color_box4}">
										<fo:block margin-left="2mm">
											<!-- Example: © 2025 PDF Association – pdfa.org -->
											<fo:block font-size="9.9pt" margin-bottom="1mm">
												<xsl:text>© </xsl:text>
												<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:from"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization/mn:name"/>
												<xsl:text> – </xsl:text>
												<fo:inline text-decoration="underline">
													<fo:basic-link fox:alt-text="PDF association" external-destination="https://pdfa.org/">pdfa.org</fo:basic-link>
												</fo:inline>
											</fo:block>
											<fo:block font-size="8pt" margin-bottom="3mm">
												<xsl:text>This work is licensed under CC-BY-4.0 </xsl:text>
												<!-- Note: the error occurs [Fatal Error] :1621:113: Character reference "&#55356" is an invalid XML character. -->
												<!-- Circled CC -->
												<fo:inline font-size="10pt"><xsl:call-template name="getCharByCodePoint"><xsl:with-param name="codepoint">1f16d</xsl:with-param></xsl:call-template></fo:inline>
												<xsl:text> </xsl:text>
												<!-- Circled Human Figure -->
												<fo:inline font-size="10pt"><xsl:call-template name="getCharByCodePoint"><xsl:with-param name="codepoint">1f16f</xsl:with-param></xsl:call-template></fo:inline>
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

	<!-- empty back-page to omit back cover -->
	<xsl:template name="back-page">
		<!-- put the back page layout -->
	</xsl:template>

	<xsl:template match="mn:copyright-statement" priority="2">
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:attribute-set name="link-style">
		<xsl:attribute name="color">rgb(14,85,117)</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="insertHeaderFooter">
		<xsl:call-template name="insertFooter"/>
	</xsl:template>

	<xsl:template name="insertFooter">
		<!-- <xsl:param name="invert"/> -->
		<xsl:variable name="footerText"> 
			<xsl:text>PDFa</xsl:text>
			<xsl:text>&#xA0;</xsl:text>
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
			<xsl:with-param name="footerText" select="$footerText"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooterEven">
			<xsl:with-param name="footerText" select="$footerText"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>