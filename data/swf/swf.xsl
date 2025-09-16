<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">


	<xsl:variable name="pageWidth" select="210"/>
	<xsl:variable name="pageHeight" select="297"/>

	<xsl:variable name="color_black">rgb(30, 25, 29)</xsl:variable>
	
	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="60mm" margin-bottom="30mm" margin-left="19mm" margin-right="50mm"/>
				<fo:region-before region-name="header" extent="10mm"/>
				<fo:region-after region-name="footer" extent="20mm"/>
			</fo:simple-page-master>
			
		</fo:layout-master-set>
	</xsl:template>

	
	<xsl:variable name="copyright_year" select="/mn:metanorma/mn:bibdata/mn:copyright/mn:from"/>
	<xsl:variable name="copyright_holder" select="normalize-space(/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization/mn:name)"/>
	<xsl:variable name="copyrightText">
		<xsl:text>© </xsl:text>
		<xsl:value-of select="$copyright_year"/>
		<xsl:text>. The </xsl:text>
		<xsl:value-of select="$copyright_holder"/>
		<xsl:text>, Inc. </xsl:text>
		<xsl:variable name="all_rights_reserved">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">all_rights_reserved</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$all_rights_reserved"/>
		<xsl:text>.</xsl:text>
	</xsl:variable>
	
	<xsl:template name="cover-page">
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" font-family="Nacelle" >
			<fo:static-content flow-name="header">
				<xsl:call-template name="insertBackgroundPageImage"/>
			</fo:static-content>
			
			<fo:static-content flow-name="footer">
				<fo:block-container height="20mm" display-align="center">
					<fo:block font-size="12pt" font-weight="300" color="white" margin-left="11.3mm">
						<xsl:value-of select="$copyrightText"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body" color="{$color_black}">
				
				<fo:block font-size="20pt" font-weight="600" margin-left="1mm">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier"/>
				</fo:block>
				
				<xsl:variable name="titles">
					<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and (@type = 'intro' or not(@type))]"/>
					<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'main'][last()]"/>
				</xsl:variable>
				
				<xsl:for-each select="xalan:nodeset($titles)/mn:title">
					<fo:block font-size="21pt" font-weight="600" margin-top="6mm" role="H1">
						<xsl:if test="position() = 1">
							<xsl:attribute name="font-size">22pt</xsl:attribute>
							<xsl:attribute name="margin-top">17mm</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates />
					</fo:block>
				</xsl:for-each>
				
				<xsl:variable name="title_part">
					<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'part']"/>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($title_part)/mn:title">
					<fo:block font-size="21pt" font-weight="600" margin-top="9mm">
						<xsl:apply-templates />
					</fo:block>
				</xsl:for-each>
				
				<fo:block font-size="14pt" font-weight="normal" margin-top="17mm">
					<xsl:call-template name="convertDate">
						<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/>
						<xsl:with-param name="format">full</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END cover-page -->

	
	<xsl:template name="back-page">
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" font-family="Nacelle" >
			<fo:static-content flow-name="header">
				<xsl:call-template name="insertBackgroundPageImage">
					<xsl:with-param name="name">backpage-image</xsl:with-param>
					<xsl:with-param name="suffix">back</xsl:with-param>
				</xsl:call-template>
			</fo:static-content>
			
			<fo:static-content flow-name="footer">
				<fo:block-container height="20mm" display-align="center">
					<fo:block font-size="12pt" font-weight="300" color="white" margin-left="11.3mm">
						<xsl:value-of select="$copyrightText"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body" color="{$color_black}">
				<fo:block-container margin-left="1mm">
					<fo:block-container margin-left="0mm">
						<fo:block font-size="14pt" font-weight="600">Document contributors</fo:block>
						
						<fo:block font-size="14pt" font-weight="300" margin-top="6mm">TBD</fo:block>
						
						<fo:block font-size="14pt" font-weight="600" margin-top="11mm">Spatial Web Foundation leadership</fo:block>
						
						<fo:block font-size="14pt" font-weight="300" margin-top="6mm">TBD</fo:block>
						
						
						<fo:block font-size="12pt" font-weight="300" margin-top="15mm">
							<xsl:text>Comments about the Spatial Web and this document can be sent to</xsl:text>
							<xsl:value-of select="$linebreak"/>
							<xsl:text>the Spatial Web Foundation at info@spatialwebfoundation.org</xsl:text>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- Ena back-page -->


	<xsl:template name="insertHeaderFooter">
		<xsl:call-template name="insertFooter"/>
	</xsl:template>

	<xsl:template name="insertFooter">
		<xsl:variable name="titles">
			<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and (@type = 'intro' or not(@type))]"/>
			<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'main'][last()]"/>
			<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'part']"/>
		</xsl:variable>
		<xsl:call-template name="insertFooterOdd">
			<xsl:with-param name="titles" select="$titles"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooterEven">
			<xsl:with-param name="titles" select="$titles"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="insertFooterOdd">
		<xsl:param name="titles"/>
		<fo:static-content flow-name="footer-odd" role="artifact">
			<fo:block-container absolute-position="fixed" left="0mm" top="{$pageHeight - 20}mm" width="{$pageWidth}mm" font-size="10pt" font-weight="normal" height="20mm" color="white" background-color="{$color_black}" id="__internal_layout__footerodd_{generate-id()}_{.//*[@id][1]/@id}" display-align="center">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="proportional-column-width(9)"/>
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding-left="7mm">
								<fo:block>
									<xsl:for-each select="xalan:nodeset($titles)/mn:title">
										<xsl:apply-templates />
										<xsl:if test="position() != last()"> -- </xsl:if>
									</xsl:for-each>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell text-align="right" padding-right="7mm">
								<fo:block><fo:page-number/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertFooterEven">
		<xsl:param name="titles"/>
		<fo:static-content flow-name="footer-even" role="artifact">
			<fo:block-container absolute-position="fixed" left="0mm" top="{$pageHeight - 20}mm" width="{$pageWidth}mm" font-size="10pt" font-weight="normal" height="20mm" color="white" background-color="{$color_black}" id="__internal_layout__footereven_{generate-id()}_{.//*[@id][1]/@id}" display-align="center">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-column column-width="proportional-column-width(9)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding-left="10mm">
								<fo:block><fo:page-number/></fo:block>
							</fo:table-cell>
							<fo:table-cell text-align="right" padding-right="9mm">
								<fo:block>
									<xsl:for-each select="xalan:nodeset($titles)/mn:title">
										<xsl:apply-templates />
										<xsl:if test="position() != last()"> -- </xsl:if>
									</xsl:for-each>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
</xsl:stylesheet>