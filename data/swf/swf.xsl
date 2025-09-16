<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">


	<xsl:variable name="pageWidth" select="210"/>
	<xsl:variable name="pageHeight" select="297"/>

	
	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="28.5mm" margin-bottom="30mm" margin-left="19mm" margin-right="50mm"/>
				<fo:region-before region-name="header" extent="10mm"/>
				<fo:region-after region-name="footer" extent="20mm"/>
			</fo:simple-page-master>
			
		</fo:layout-master-set>
	</xsl:template>

	
	<xsl:template name="cover-page">
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" font-family="Nacelle" >
			<fo:static-content flow-name="header">
				<xsl:call-template name="insertBackgroundPageImage"/>
			</fo:static-content>
			
			<fo:static-content flow-name="footer">
				<fo:block-container height="20mm" display-align="center">
					<fo:block font-size="12pt" font-weight="300" color="white" margin-left="11.3mm">
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
						<xsl:value-of select="$copyrightText"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body" color="rgb(30, 25, 29)">
				<!-- Logo -->
				<fo:block role="SKIP">
					<fo:inline-container width="66mm" role="SKIP">
						<fo:block font-size="0pt">
							<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization">
								<xsl:apply-templates select="mn:logo/mn:image"/>
							</xsl:for-each>
						</fo:block>
					</fo:inline-container>
				</fo:block>
				
				<fo:block font-size="20pt" font-weight="600" margin-top="10.5mm" margin-left="1mm">
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

	
	<!-- empty back-page to omit back cover -->
	<!-- <xsl:template name="back-page">
		
	</xsl:template> -->


	<xsl:template name="insertHeaderFooter">
		<xsl:call-template name="insertFooter"/>
	</xsl:template>

	<xsl:template name="insertFooter">
		<!-- <xsl:param name="invert"/> -->
		<xsl:variable name="footerText"> 
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