<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<xsl:variable name="pageWidth">210</xsl:variable>
	<xsl:variable name="pageHeight">297</xsl:variable>
	
	<xsl:variable name="marginTop">25</xsl:variable>
	<xsl:variable name="marginBottom">25</xsl:variable>

	<xsl:variable name="color_black">rgb(30, 25, 29)</xsl:variable>
	<xsl:variable name="color_header_background">rgb(240, 234, 219)</xsl:variable>
	
	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="60mm" margin-bottom="30mm" margin-left="19mm" margin-right="20mm"/>
				<fo:region-before region-name="header" extent="10mm"/>
				<fo:region-after region-name="footer" extent="20mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-even" extent="20mm"/> 
				<fo:region-after region-name="footer-even" extent="20mm"/>
				<fo:region-start region-name="left-region" extent="13mm"/>
				<fo:region-end region-name="right-region" extent="12mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="20mm"/> 
				<fo:region-after region-name="footer-odd" extent="20mm"/>
				<fo:region-start region-name="left-region" extent="13mm"/>
				<fo:region-end region-name="right-region" extent="12mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="document">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			
			<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-even" extent="20mm"/> 
				<fo:region-after region-name="footer-even" extent="20mm"/>
				<fo:region-start region-name="left-region" extent="13mm"/>
				<fo:region-end region-name="right-region" extent="12mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="20mm"/> 
				<fo:region-after region-name="footer-odd" extent="20mm"/>
				<fo:region-start region-name="left-region" extent="13mm"/>
				<fo:region-end region-name="right-region" extent="12mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
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
				
				<fo:block-container margin-right="30mm">
					<fo:block-container margin-right="0mm">
				
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
					</fo:block-container>
				</fo:block-container>
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
				<fo:block-container margin-left="1mm" margin-right="5mm">
					<fo:block-container margin-left="0mm">
					
						<xsl:variable name="contributors_">
							<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'author']/mn:person/mn:name/mn:completename">
								<xsl:copy-of select="."/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="contributors" select="xalan:nodeset($contributors_)"/>
					
						<xsl:if test="$contributors/*">
							<fo:block font-size="14pt" font-weight="600">Document contributors</fo:block>
							<fo:block font-size="12pt" font-weight="300" margin-top="5.5mm">
								<xsl:for-each select="$contributors/*">
									<fo:inline keep-together.within-line="always"><xsl:value-of select="."/></fo:inline><xsl:if test="position() != last()">, </xsl:if>
								</xsl:for-each>
							</fo:block>
						</xsl:if>
						
						<fo:block font-size="14pt" font-weight="600" margin-top="11mm">Spatial Web Foundation leadership</fo:block>
						
						<fo:block font-size="12pt" font-weight="300" margin-top="5.5mm">TBD</fo:block>
						
						
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
		<xsl:call-template name="insertHeader"/>
		<xsl:call-template name="insertFooter"/>
	</xsl:template>

	<xsl:template name="insertHeader">
		<xsl:variable name="docidentifier" select="/mn:metanorma/mn:bibdata/mn:docidentifier"/>
		<xsl:call-template name="insertHeaderOdd">
			<xsl:with-param name="text" select="$docidentifier"/>
		</xsl:call-template>
		<xsl:call-template name="insertHeaderEven">
			<xsl:with-param name="text" select="$docidentifier"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:attribute-set name="header-style">
		<xsl:attribute name="absolute-position">fixed</xsl:attribute>
		<xsl:attribute name="left">0mm</xsl:attribute>
		<xsl:attribute name="top">0mm</xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
		<xsl:attribute name="font-family">Nacelle</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">300</xsl:attribute>
		<xsl:attribute name="height">20mm</xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="$color_black"/></xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$color_header_background"/></xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="insertHeaderOdd">
		<xsl:param name="text"/>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container xsl:use-attribute-sets="header-style" id="__internal_layout__headerodd_{generate-id()}_{.//*[@id][1]/@id}">
				<fo:block text-align="right" margin-right="7mm">
					<xsl:value-of select="$text"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertHeaderEven">
		<xsl:param name="text"/>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container xsl:use-attribute-sets="header-style" id="__internal_layout__headereven_{generate-id()}_{.//*[@id][1]/@id}">
				<fo:block margin-left="10mm">
					<xsl:value-of select="$text"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:attribute-set name="footer-style">
		<xsl:attribute name="absolute-position">fixed</xsl:attribute>
		<xsl:attribute name="left">0mm</xsl:attribute>
		<xsl:attribute name="top"><xsl:value-of select="$pageHeight - 20"/>mm</xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
		<xsl:attribute name="font-family">Nacelle</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="height">20mm</xsl:attribute>
		<xsl:attribute name="color">white</xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$color_black"/></xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="insertFooter">
		<xsl:variable name="titles_">
			<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and (@type = 'intro' or not(@type))]"/>
			<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'main'][last()]"/>
			<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'part']"/>
		</xsl:variable>
		<xsl:variable name="titles">
			<xsl:for-each select="xalan:nodeset($titles_)/mn:title">
				<xsl:apply-templates />
				<xsl:if test="position() != last()"> -- </xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="insertFooterOdd">
			<xsl:with-param name="text" select="$titles"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooterEven">
			<xsl:with-param name="text" select="$titles"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="insertFooterOdd">
		<xsl:param name="text"/>
		<fo:static-content flow-name="footer-odd" role="artifact">
			<fo:block-container xsl:use-attribute-sets="footer-style" id="__internal_layout__footerodd_{generate-id()}_{.//*[@id][1]/@id}">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="proportional-column-width(9)"/>
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding-left="7mm">
								<fo:block>
									<xsl:copy-of select="$text"/>
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
		<xsl:param name="text"/>
		<fo:static-content flow-name="footer-even" role="artifact">
			<fo:block-container xsl:use-attribute-sets="footer-style" id="__internal_layout__footereven_{generate-id()}_{.//*[@id][1]/@id}">
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
									<xsl:copy-of select="$text"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
</xsl:stylesheet>