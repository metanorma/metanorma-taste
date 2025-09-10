<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="17.5mm" margin-bottom="17.5mm" margin-left="17.5mm" margin-right="17.5mm"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="copyright-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="20mm" margin-bottom="35mm" margin-left="20mm" margin-right="20mm"/>
			</fo:simple-page-master>
		</fo:layout-master-set>
	</xsl:template>

	<xsl:template name="cover-page">
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body" font-family="Source Sans 3">
				<fo:block-container width="47mm" role="SKIP" margin-top="-3mm"> <!-- -3mm because there space before image in the source SVG -->
					<fo:block>
						<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization">
							<xsl:apply-templates select="mn:logo/mn:image"/>
						</xsl:for-each>
					</fo:block>
				</fo:block-container>

				<!-- Type of document:
					Specification, Best Practice Guide, Application Note, Technical Note, Extension -->
				<fo:block font-size="29pt" font-weight="bold" text-align="right" margin-top="4mm">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[normalize-space(@language) != '']"/>
				</fo:block>

				<fo:block-container width="112mm" line-height="1.2" margin-top="4mm">
					<!-- Main title of doc -->
					<fo:block font-size="32pt" font-weight="bold">
						<fo:block><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-intro']/node()"/></fo:block>
					</fo:block>
					<!-- Subtitle of doc -->
					<fo:block font-size="30pt">
						<fo:block><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-main']/node()"/></fo:block>
					</fo:block>
				</fo:block-container>

				<fo:block-container absolute-position="fixed" top="95mm" left="17.5mm" font-size="20pt">
					<xsl:variable name="border_width">2.5pt</xsl:variable>
					<!-- <fo:block-container absolute-position="fixed" top="10mm" left="116mm" width="58mm" height="58mm" border="{$border_width} solid rgb(202,152,49)">
						<fo:block>&#xa0;</fo:block>
					</fo:block-container> -->
					<xsl:variable name="block_height">57mm</xsl:variable>
					<fo:table table-layout="fixed" width="174mm"> <!--  border-collapse="separate" -->
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell text-align="right" display-align="after" padding-left="0.5mm" padding-right="0.5mm" padding-top="-0.5mm" padding-bottom="-0.5mm"> <!-- padding-left="5mm" padding-right="5mm" -->
									<fo:block-container width="100%" height="{$block_height}" border="{$border_width} solid rgb(202,152,49)">
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
								<fo:table-cell text-align="center" display-align="center" padding-left="0.5mm" padding-right="0.5mm" padding-top="-0.5mm" padding-bottom="-0.5mm">
									<fo:block-container width="100%" height="{$block_height}" border="{$border_width} solid rgb(139,152,91)">
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
								<fo:table-cell display-align="after" padding-left="0.5mm" padding-right="0.5mm" padding-top="-0.5mm" padding-bottom="-0.5mm">
									<fo:block-container width="100%" height="{$block_height}" border="{$border_width} solid rgb(208,63,78)">
										<!-- the group that authored the doc -->
										<fo:block>TEMP FIXED TEXT</fo:block>
										<fo:block margin-left="5mm" margin-right="5mm" margin-bottom="3mm">EA-PDF LWG</fo:block>
									</fo:block-container>
								</fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell display-align="after" padding-left="0.5mm" padding-right="0.5mm" padding-top="-0.5mm" padding-bottom="-0.5mm">
									<fo:block-container width="100%" height="{$block_height}" border="{$border_width} solid rgb(72,145,175)">
										<fo:block margin-left="2mm">
											<!-- Example: © 2025 PDF Association – pdfa.org -->
											<fo:block font-size="9.9pt" margin-bottom="1mm">
												<xsl:text>© </xsl:text>
												<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:from"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization/mn:name"/>
												<xsl:text> – </xsl:text>
												<fo:inline text-decoration="underline">pdfa.org</fo:inline>
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

	<xsl:template name="copyright-statement">
		<fo:page-sequence master-reference="copyright-page" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body" line-height="1.36" role="SKIP" font-family="Source Sans Pro" font-size="12pt">
				<!-- height = pageHeight - page margin top - page margin bottom -->
				<fo:block-container height="{$pageHeight - 20 - 30}mm" display-align="after" role="SKIP">
					<fo:block>
						<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement"/>
					</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>

</xsl:stylesheet>