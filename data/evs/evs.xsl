<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<xsl:variable name="marginLeftRight1">25.4</xsl:variable>
	<xsl:variable name="marginLeftRight2">12.7</xsl:variable>

	<xsl:variable name="color_blue">rgb(6, 85, 162)</xsl:variable>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
				
			<!-- Cover page -->
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="110mm" margin-bottom="17mm" margin-left="20mm" margin-right="14.9mm"/>
				<fo:region-before region-name="cover-page-header" extent="110mm" />
				<fo:region-after region-name="cover-page-footer" extent="17mm"/>
				<fo:region-start extent="20mm"/>
				<fo:region-end extent="14.9mm"/>
			</fo:simple-page-master>
		
			<!-- first page -->
			<fo:simple-page-master master-name="preface_firstpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="20mm" margin-right="12mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer-even" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="20mm"/>
				<fo:region-end region-name="right-region" extent="12mm"/>
			</fo:simple-page-master>
		
			<!-- EUROPEAN STANDARD page -->
			<fo:simple-page-master master-name="european-standard" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="15mm" margin-bottom="28.5mm" margin-left="25mm" margin-right="9.4mm"/>
				<fo:region-before region-name="header" extent="15mm"/>
				<fo:region-after region-name="footer" extent="28.5mm"/>
				<fo:region-start region-name="left-region" extent="25mm"/>
				<fo:region-end region-name="right-region" extent="9.4mm"/>
			</fo:simple-page-master>
		
			<!-- Back page -->
			<fo:simple-page-master master-name="back-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="20mm" margin-bottom="100mm" margin-left="20mm" margin-right="20mm"/>
				<fo:region-before region-name="header-even" extent="20mm"/>
				<fo:region-after region-name="back-page-footer" extent="100mm"/>
				<fo:region-start region-name="left-region" extent="20mm"/>
				<fo:region-end region-name="right-region" extent="20mm"/>
			</fo:simple-page-master>
		
		</fo:layout-master-set>
	</xsl:template><!-- END layout-master-set -->

	<xsl:template name="cover-page">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" initial-page-number="1">
			<fo:static-content flow-name="cover-page-header" role="SKIP">
				<fo:block font-size="19pt" font-weight="bold" text-align-last="justify" color="{$color_blue}" margin-top="19mm" margin-right="2mm">
					<fo:inline keep-together.within-line="always" role="SKIP">
						<xsl:text>EESTI STANDARD</xsl:text>
						<fo:leader leader-pattern="space"/>
						<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[1]"/>
					</fo:inline>
				</fo:block>
				<fo:block font-size="0pt" margin-top="-0.5mm">
					<fo:external-graphic src="{normalize-space($horizontalLine)}" content-width="175mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Horizontal line" fox:placement="Block"/>
				</fo:block>
			</fo:static-content>
			
			<!-- Logo -->
			<fo:static-content flow-name="cover-page-footer" role="SKIP">
				<fo:block text-align="center" font-size="0pt" margin-left="2mm">
					<fo:external-graphic src="{normalize-space($EVS-Logo_cover)}" content-width="110mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="EVS Logo" fox:placement="Block"/>
				</fo:block>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body">
				<xsl:call-template name="insert_firstpage_id"><xsl:with-param name="num" select="$num"/></xsl:call-template>
				<fo:block-container font-size="19pt" font-weight="bold" width="160mm" line-height="1.17" margin-left="2mm">
					<fo:block-container margin-left="0mm">
						<fo:block text-transform="uppercase">
							<!-- Title in Estonian, for example:
								DIGITAALNE TOOTEPASS. ANDMEVAHETUSE PROTOKOLLID -->
							<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:title[@language = 'et' and @type = 'title-intro'] | 
									/mn:metanorma/mn:bibdata/mn:title[@language = 'et' and @type = 'title-main']">
								<xsl:apply-templates select="node()"/>
								<xsl:if test="position() != last()"><xsl:text>. </xsl:text></xsl:if>
							</xsl:for-each>
						</fo:block>
						<fo:block margin-top="14mm">
							<!-- Title in English, for example:
								Digital product passport - Data exchange protocols -->
							<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:title[@language = 'en' and @type = 'title-intro'] | 
									/mn:metanorma/mn:bibdata/mn:title[@language = 'en' and @type = 'title-main']">
								<xsl:apply-templates select="node()"/>
								<xsl:if test="position() != last()"><xsl:text>&#xa0;-&#xa0;</xsl:text></xsl:if>
							</xsl:for-each>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END cover-page -->

	<xsl:template name="inner-cover-page">
		<xsl:param name="num"/>
		
		<fo:page-sequence force-page-count="no-force" xsl:use-attribute-sets="page-sequence-preface" master-reference="preface_first">
			<xsl:call-template name="refinePageSequenceCommon"/>
			<xsl:call-template name="refine_page-sequence-preface"/>
			<xsl:attribute name="format">I</xsl:attribute>
			
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="num" select="$num"/>
			</xsl:call-template>
			
			<fo:flow flow-name="xsl-region-body" role="SKIP" font-size="11pt">
			
				<!-- <xsl:if test="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword']"> -->
				<xsl:if test="/mn:metanorma/mn:preface/mn:foreword[@type = 'national-foreword']">
					<fo:table table-layout="fixed" width="100%" line-height="1.2" role="SKIP">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<!-- <xsl:if test="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword'][2]"> -->
						<xsl:for-each select="/mn:metanorma/mn:preface/mn:foreword[@type = 'national-foreword'][position() &gt; 1]">
							<fo:table-column column-width="proportional-column-width(1)"/>
						</xsl:for-each>
						<fo:table-body role="P">
							<fo:table-row role="SKIP" height="22mm" font-size="13pt" font-weight="bold">
								<!-- <fo:table-cell role="SKIP" padding-left="3mm">
									<fo:block text-transform="uppercase">
										<xsl:apply-templates select="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword'][1]/mn:fmt-title/node()"/>
									</fo:block>
								</fo:table-cell>
								<xsl:if test="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword'][2]">
									<fo:table-cell role="SKIP" padding-left="3mm">
										<fo:block text-transform="uppercase">
											<xsl:apply-templates select="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword'][2]/mn:fmt-title/node()"/>
										</fo:block>
									</fo:table-cell>
								</xsl:if> -->
								<xsl:for-each select="/mn:metanorma/mn:preface/mn:foreword[@type = 'national-foreword']">
									<fo:table-cell role="SKIP" padding-left="3mm">
										<fo:block text-transform="uppercase">
											<xsl:apply-templates select="mn:fmt-title/node()"/>
										</fo:block>
									</fo:table-cell>
								</xsl:for-each>	
							</fo:table-row>
							<fo:table-row role="SKIP">
								<!-- <fo:table-cell role="SKIP" padding="2mm" padding-left="3mm" padding-right="3mm" border="0.5pt solid black">
									<fo:block>
										<xsl:apply-templates select="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword'][1]/*[not(self::mn:fmt-title)]"/>
									</fo:block>
								</fo:table-cell>
								<xsl:if test="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword'][2]">
									<fo:table-cell role="SKIP" padding="2mm" padding-left="3mm" padding-right="3mm" border="0.5pt solid black">
										<fo:block>
											<xsl:apply-templates select="/mn:metanorma/mn:preface/mn:clause[@type = 'national-foreword'][2]/*[not(self::mn:fmt-title)]"/>
										</fo:block>
									</fo:table-cell>
								</xsl:if> -->
								<xsl:for-each select="/mn:metanorma/mn:preface/mn:foreword[@type = 'national-foreword']">
									<fo:table-cell role="SKIP" padding="2mm" padding-left="3mm" padding-right="3mm" border="0.5pt solid black">
										<fo:block>
											<xsl:apply-templates select="*[not(self::mn:fmt-title)]"/>
										</fo:block>
									</fo:table-cell>
								</xsl:for-each>	
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</xsl:if>
			
				<fo:block-container position="absolute" height="{$pageHeight - $marginTop - $marginBottom - 2}mm" width="176mm" display-align="after" role="SKIP">
					<fo:block><xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:feedback-statement"/></fo:block>
					<!-- ICS -->
					<fo:block><xsl:value-of select="$variables/mnx:doc[@num = $num]/ics"/></fo:block>
					<fo:block>&#xa0;</fo:block>
					<fo:block-container margin-left="-2mm">
						<fo:block-container margin-left="0mm">
							<fo:block border="0.5pt solid black" role="SKIP" font-size="9pt" padding-top="1mm" padding-left="0.5mm" padding-bottom="1mm">
								<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement"/>
							</fo:block>
						</fo:block-container>
					</fo:block-container>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
		
		
		<fo:page-sequence force-page-count="no-force" master-reference="european-standard" initial-page-number="1">
			<fo:static-content flow-name="footer" role="Artifact">
				<fo:table table-layout="fixed" width="100%" role="SKIP" border-top="2pt solid black" font-size="8.5pt">
					<fo:table-column column-width="proportional-column-width(32)"/>
					<fo:table-column column-width="proportional-column-width(70)"/>
					<fo:table-column column-width="proportional-column-width(70)"/>
					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<fo:table-cell role="SKIP" padding-top="4.5mm">
								<!-- Example: © 2026 CEN/CENELEC -->
								<fo:block>
									<xsl:value-of select="concat('© ', /mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:copyright/mn:from, ' CEN/CENELEC')"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell role="SKIP" padding-top="4.5mm">
								<fo:block>All rights of exploitation in any form and by any means
									reserved worldwide for CEN national Members and for
									CENELEC Members.</fo:block> <!-- To do -->
							</fo:table-cell>
							<fo:table-cell role="SKIP" padding-top="4.5mm" text-align="right">
								<!-- Example: Ref. No. EN 18216:2026 E -->
								<fo:block>
									<xsl:value-of select="concat(
										'Ref. No. ',
										/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:docidentifier[@type = 'EN'],
										':',
										/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:copyright/mn:from,
										' ',
										java:toUpperCase(java:java.lang.String.new(substring(/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:language, 1, 1)))
										)"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body" role="SKIP" font-size="9pt">
			
				<fo:table table-layout="fixed" width="100%" role="SKIP" border-bottom="2pt solid black">
					<fo:table-column column-width="proportional-column-width(98)"/>
					<fo:table-column column-width="proportional-column-width(77)"/>
					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP" height="10mm">
							<fo:table-cell role="SKIP" font-size="18pt">
								<fo:block>EUROPEAN STANDARD</fo:block>
							</fo:table-cell>
							<fo:table-cell role="SKIP" font-size="20pt" font-weight="bold">
								<!-- Example: EN 18216 -->
								<fo:block><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:docidentifier[@type = 'EN']"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row role="SKIP" height="10mm">
							<fo:table-cell role="SKIP" font-size="18pt">
								<fo:block>NORME EUROPÉENNE</fo:block>
							</fo:table-cell>
							<fo:table-cell role="SKIP">
								<fo:block>&#xa0;</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row role="SKIP">
							<fo:table-cell role="SKIP" font-size="18pt">
								<fo:block>EUROPÄISCHE NORM</fo:block>
							</fo:table-cell>
							<fo:table-cell role="SKIP" display-align="after" font-size="11pt">
								<fo:block>
									<xsl:call-template name="convertDate">
										<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:date/mn:on"/>
										<xsl:with-param name="type">short</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				<fo:block font-size="10pt" margin-top="3.5mm"><xsl:value-of select="$variables/mnx:doc[@num = $num]/ics"/></fo:block>
				<fo:block text-align="center" margin-top="10mm" font-size="11pt">English version</fo:block><!-- To do -->
				<fo:block text-align="center" font-size="16pt" margin-top="4mm">
					<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:title[@language = 'en' and @type = 'main']/node()"/>
				</fo:block>
				
				<!-- Titles in French and German -->
				<fo:table table-layout="fixed" width="100%" role="SKIP" margin-top="6mm" margin-bottom="7mm">
					<fo:table-column column-width="proportional-column-width(77)"/>
					<fo:table-column column-width="proportional-column-width(22)"/>
					<fo:table-column column-width="proportional-column-width(77)"/>
					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<fo:table-cell role="SKIP" text-align="center" padding-left="6mm">
								<fo:block>
									<!-- Title in French, for example:
									Passeport numérique des produits - Protocoles d'échange de données -->
									<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:title[@language = 'fr' and @type = 'title-intro'] | 
											/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:title[@language = 'fr' and @type = 'title-main']">
										<xsl:apply-templates select="node()"/>
										<xsl:if test="position() != last()"><xsl:text>&#xa0;-&#xa0;</xsl:text></xsl:if>
									</xsl:for-each>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell role="SKIP">
								<fo:block>&#xa0;</fo:block>
							</fo:table-cell>
							<fo:table-cell role="SKIP" text-align="center" padding-right="6mm">
								<fo:block>
									<!-- Title in German, for example:
									Digitaler Produktpass - Protokolle zum Datenaustausch -->
									<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:title[@language = 'de' and @type = 'title-intro'] | 
											/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:title[@language = 'de' and @type = 'title-main']">
										<xsl:apply-templates select="node()"/>
										<xsl:if test="position() != last()"><xsl:text>&#xa0;-&#xa0;</xsl:text></xsl:if>
									</xsl:for-each>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				
				<fo:block-container line-height="1.17">
					<xsl:variable name="date">
						<xsl:call-template name="convertDate">
							<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:relation[@type = 'derivedFrom']/mn:bibitem/mn:date/mn:on"/>
						</xsl:call-template>
					</xsl:variable>
					<fo:block space-after="9.3pt">This European Standard was approved by CEN on <xsl:value-of select="$date"/>.</fo:block>
					<fo:block space-after="9.3pt">CEN and CENELEC members are bound to comply with the CEN/CENELEC Internal Regulations which stipulate the conditions for giving this European Standard the status of a national standard without any alteration. Up-to-date lists and bibliographical references concerning such national standards may be obtained on application to the CEN-CENELEC Management Centre or to any CEN and CENELEC member.</fo:block>
					<fo:block space-after="9.3pt">This European Standard exists in three official versions (English, French, German). A version in any other language made by translation under the responsibility of a CEN and CENELEC member into its own language and notified to the CEN-CENELEC Management Centre has the same status as the official versions.</fo:block>
					<fo:block space-after="9.3pt">CEN and CENELEC members are the national standards bodies and national electrotechnical committees of Austria, Belgium, Bulgaria, Croatia, Cyprus, Czech Republic, Denmark, Estonia, Finland, France, Germany, Greece, Hungary, Iceland, Ireland, Italy, Latvia, Lithuania, Luxembourg, Malta, Netherlands, Norway, Poland, Portugal, Republic of North Macedonia, Romania, Serbia, Slovakia, Slovenia, Spain, Sweden, Switzerland, Türkiye and United Kingdom.</fo:block>
				</fo:block-container>
				
				<!-- CEN/CENELEC Logos -->
				<fo:block-container position="absolute" height="{$pageHeight - $marginTop - $marginBottom - 2}mm" width="176mm" display-align="after" role="SKIP">
					<fo:table table-layout="fixed" width="100%" role="SKIP" margin-bottom="9mm">
						<fo:table-column column-width="proportional-column-width(27)"/>
						<fo:table-column column-width="proportional-column-width(54)"/>
						<fo:table-column column-width="proportional-column-width(67)"/>
						<fo:table-column column-width="proportional-column-width(27)"/>
						<fo:table-body role="SKIP">
							<fo:table-row role="SKIP">
								<fo:table-cell role="SKIP">
									<fo:block>&#xa0;</fo:block>
								</fo:table-cell>
								<fo:table-cell role="SKIP" text-align="center">
									<fo:block font-size="0pt">
										<fo:instream-foreign-object content-width="36mm" fox:alt-text="Image Logo CEN" fox:placement="Block">
											<xsl:copy-of select="$CEN-Logo"/>
										</fo:instream-foreign-object>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell role="SKIP" text-align="center" display-align="before">
									<fo:block font-size="0pt" >
										<fo:external-graphic src="{$CENELEC-Logo}" content-width="48mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo Cenelec" fox:placement="Block"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell role="SKIP">
									<fo:block>&#xa0;</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
					
					<fo:block text-align="center" font-weight="bold" margin-bottom="7mm">
						<fo:block>CEN-CENELEC Management Centre:</fo:block>
						<fo:block>Rue de la Science 23, B-1040 Brussels</fo:block>
					</fo:block>
				</fo:block-container>
				
			</fo:flow>
		</fo:page-sequence>
			
	</xsl:template> <!-- END: inner-cover-page -->

	<!-- National Foreword(s) render in the template inner-cover-page -->
	<xsl:template match="mn:preface//mn:foreword[@type = 'national-foreword']" priority="3"/>

	<xsl:template name="refine_page-sequence-preface"><?extend?>
		<xsl:attribute name="format">1</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="refine_page-sequence-main"><?extend?>
		<xsl:attribute name="initial-page-number">auto</xsl:attribute>
	</xsl:template>
	

	<xsl:template name="refine_p-style"><?extend?>
		<xsl:if test="ancestor::mn:clause[@type = 'national-foreword']">
			<xsl:attribute name="line-height">1.17</xsl:attribute>
			<xsl:if test="following-sibling::*">
				<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="refine_copyright-statement-p-style"><?extend?>
		<xsl:attribute name="line-height">1.17</xsl:attribute>
		<xsl:if test="following-sibling::mn:p">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertHeaderEven">
		<xsl:param name="num"/>
		<xsl:param name="is_header">true</xsl:param>
		<xsl:param name="header_region_name">header-even</xsl:param>
		<xsl:variable name="docidentifier" select="$variables/mnx:doc[@num = $num]/docidentifier_iso"/>
		<fo:static-content flow-name="{$header_region_name}">
			<fo:block-container height="23mm">
				<fo:block font-size="11pt" padding-top="12.5mm" line-height="1.2">
					<xsl:value-of select="$docidentifier"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template> <!-- END: insertHeaderEven -->
	<xsl:template name="insertHeaderFirst">
		<xsl:param name="num"/>
		<xsl:variable name="docidentifier" select="$variables/mnx:doc[@num = $num]/docidentifier_iso"/>
		<!-- The first instance of a running page header should be tagged - later instances should be marked as Artifact. -->
		<fo:static-content flow-name="header-first" role="SKIP"> <!-- role="artifact" -->
			<fo:block-container height="23mm">
				<fo:block font-size="11pt" text-align="right"  padding-top="12.5mm" line-height="1.2">
					<xsl:value-of select="$docidentifier"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template> <!-- END: insertHeaderFirst -->
	<xsl:template name="insertHeaderOdd">
		<xsl:param name="num"/>
		<xsl:variable name="docidentifier" select="$variables/mnx:doc[@num = $num]/docidentifier_iso"/>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="23mm">
				<fo:block font-size="11pt" text-align="right" padding-top="12.5mm" line-height="1.2">
					<xsl:value-of select="$docidentifier"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template> <!-- END: insertHeaderOdd -->

	<xsl:template name="insertFooterEven">
		<xsl:param name="num" />
		<xsl:param name="font-weight" select="'bold'"/>
		<fo:static-content flow-name="footer-even" role="artifact">
			<fo:block-container>
				<fo:block font-size="11pt" font-weight="{$font-weight}" margin-top="10pt"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template> <!-- END: insertFooterEven -->
	<xsl:template name="insertFooterOdd">
		<xsl:param name="num"/>
		<xsl:param name="font-weight" select="'bold'"/>
		<fo:static-content flow-name="footer-odd" role="artifact">
			<fo:block-container>
				<fo:block font-size="11pt" font-weight="{$font-weight}" text-align="right" margin-top="10pt"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template> <!-- END: insertFooterOdd -->

	<xsl:template name="back-page">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="back-page" force-page-count="no-force">
			<!-- Logo in footer -->
			<fo:static-content flow-name="back-page-footer" role="SKIP">
				<fo:block-container height="100%" display-align="after">
					<fo:block text-align="center" font-size="0pt" margin-bottom="16mm">
						<fo:instream-foreign-object content-width="74mm" fox:alt-text="Image Logo EVS" fox:placement="Block">
							<xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'author']/mn:organization/mn:logo/mn:image/*[local-name() = 'svg']"/>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<fo:block role="SKIP"><fo:wrapper role="Artifact">&#xa0;</fo:wrapper></fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>

	<xsl:variable name="horizontalLine">
		<xsl:text>data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAABLAAAAAPCAIAAAB7kKErAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAN1SURBVHhe7d3BaxRnGMfx/Rvc2Vn/gfbWQy/9AzxYL828k0svFuxJbRMKBSvYNLRHSYVkvXVnd6PQqj3ZEBJFCJp4ElICLaRQqCCCh2Sz2cUku+zOO32eZycQFO8OfH98MvtkNzM5/3jfmS1lPsuyVH689yN5kVnfIYQQQgghhBBSvEizy6c34rX4affTWO/zviSjDNYI1TtPJoQQQgghhBBShFi3U8fR+pd3PfsgzYbSAUdZJoVwOBxl3YP+y/brvf3DTveo3T3Y7R22dQAAAAAAFMd+X+x1B+2uHPs7ewe7ndf5qqCtENqgzdB+87pltHc0mLu7eebbJTezGv+wOjmz6mZ1AAAAAAAUyko8szKphW4lnl2Jvl+Ori1dmHt88/7WTq8vDTC1VjjKUiuFaUnLYeov1x5X4kbF1QPXCKMkcIsVlwAAAAAACqVRiZtS6wLpd3Gz4kQj1KK3+Mmle7+v/SuNUKMbR7US6j2EkmT5n2B8ftzUv47tQgAAAACAItFaF7h6JZajzM1QamFUD6UWTjTKrjV3Z9PKoB6yLNUtoz4bPn/V+/CL22WtkknoWmFUf+u6AAAAAID3WyT1L18YFFLuggk5NmWwopiEUev2w20tg5q0pIPUQ+9/uvWsOqFtsBwnoW4fBQAAAAAUi3Q/6YS2/dNWCE0iLa/6mfwq5TD54PyvO53DkZVC2zJq7fBoMDz73f2Ka51yzdNRMxCuIcZXlNOsUJ78TwAAAACAAijbml+osy4ezt3d8vZcmZLXL5+Q6BdTdHr9T68shbH0wHo10oVF+VOZzfjeRLaSAgAAAEDh5EuFgUuqbvHc1aXd7pF0QNsyqs+ZyV+HAz+7+OyjL+/ly4PSI6NGVZ800wwiuUrrresCAAAAAN5rVVcPJ5LKZKsc10P3y8cX7/z9X1sLoa0TaiMcP31U4rPR9ov9+T/+mrrx6PLP69O1p1/Nr03XNqbnN6YX1qcAAAAAAMUyv/51bWNq4ck3tY3Pf3xw/bc/dzoHo/E9hLZAaPcRyuF4C6mNavxqjyWVyd4ghBBCCCGEEFKc2PpfOq59+jgZr/cMSvRrJ2yRcGTv5RXQMtDZy5ly1onlQ0IIIYQQQgghxYpWOi1+48NxfMk+sUXB9Hjz6In+l0c/oAoSQgghhBBCSCFjfdB6nm37tCnNsux/hVgytTA5oa0AAAAASUVORK5CYII=</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="EVS-Logo_cover">
		<xsl:text>data:image/png;base64,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</xsl:text>
	</xsl:variable>	
	
	<xsl:variable name="CEN-Logo">
		<svg id="a" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 102.78 80.28" width="102.78" height="80.28">
			<polyline points="10.44 0 10.44 70.5 13.44 69.12 17.04 67.38 19.02 66.48 21.24 65.46 23.58 64.44 25.98 63.36 28.56 62.34 31.2 61.26 36.72 58.98 39.6 57.9 45.6 55.74 48.6 54.78 50.28 54.18 51.96 53.64 55.32 52.62 57 52.14 58.68 51.72 61.98 50.76 65.28 49.92 66.9 49.56 68.52 49.14 70.02 48.78 71.58 48.48 74.64 47.76 77.52 47.16 80.28 46.56 85.26 45.6 89.46 44.76 91.14 44.4 92.7 44.04 92.7 0 10.44 0" style="fill-rule: evenodd; stroke-width: 0px;"/>
			<polyline points="64.68 22.68 64.68 22.38 64.74 22.02 64.74 21.18 64.86 20.94 64.98 20.34 65.52 18.72 65.82 18.24 66.06 17.7 66.36 17.22 66.72 16.74 67.08 16.32 67.5 15.84 67.8 15.42 68.28 15.06 68.76 14.64 69.3 14.28 69.72 13.86 71.34 12.96 71.94 12.66 72.54 12.48 73.2 12.18 73.8 12 74.46 11.88 75.78 11.52 76.44 11.4 77.16 11.4 77.82 11.34 79.26 11.34 79.98 11.4 80.7 11.4 81.36 11.52 82.68 11.88 83.34 12 83.94 12.18 84.54 12.48 85.14 12.66 86.34 13.26 86.82 13.56 87.36 13.86 87.84 14.28 88.38 14.64 88.86 15.06 89.64 15.84 90.06 16.32 90.42 16.74 90.78 17.22 91.08 17.7 91.32 18.24 91.62 18.72 92.16 20.34 92.22 20.94 92.28 21.48 92.4 22.02 92.4 39 92.4 38.94 86.52 38.94 86.52 39 86.52 24.54 86.4 23.7 86.4 23.34 86.16 22.62 85.98 22.26 85.92 21.9 85.74 21.54 85.38 20.94 85.14 20.58 84.66 19.98 84.18 19.44 83.58 18.9 83.28 18.72 82.98 18.48 82.68 18.3 82.32 18.12 82.02 17.94 81.3 17.58 80.94 17.52 80.52 17.4 80.16 17.34 79.8 17.22 79.32 17.22 79.02 17.16 78.12 17.16 77.7 17.22 77.34 17.22 76.92 17.34 76.56 17.4 76.2 17.52 75.84 17.58 74.76 18.12 74.46 18.3 74.1 18.48 73.8 18.72 73.5 18.9 72.9 19.44 72.66 19.68 71.94 20.58 71.76 20.94 71.52 21.24 71.16 21.9 70.8 22.98 70.74 23.34 70.68 23.7 70.56 24.54 70.56 39 48.6 39 47.88 38.94 47.22 38.88 46.5 38.76 45.9 38.64 45.18 38.4 44.82 38.34 44.52 38.22 43.86 37.98 43.26 37.62 42.06 37.02 41.52 36.66 40.98 36.36 40.44 35.88 39.9 35.46 39.42 34.98 39 34.5 38.52 34.02 38.16 33.48 37.74 32.88 37.38 32.4 37.08 31.8 36.72 31.2 36.48 30.6 36.24 29.94 36 29.34 35.76 28.68 35.64 27.96 35.52 27.3 35.46 26.58 35.4 25.86 35.4 24.48 35.46 23.76 35.52 23.04 35.64 22.44 35.76 21.72 36 21.06 36.12 20.7 36.48 19.8 36.72 19.14 37.08 18.6 37.38 18 37.74 17.46 38.16 16.92 38.52 16.32 40.38 14.46 40.98 14.1 41.46 13.68 42.06 13.32 43.26 12.72 43.8 12.42 44.22 12.3 45.12 11.94 45.78 11.82 46.5 11.58 47.16 11.46 47.82 11.4 48.54 11.34 49.98 11.34 50.7 11.4 51.36 11.46 52.02 11.58 52.68 11.82 52.98 11.88 53.4 11.94 54.6 12.42 55.26 12.72 56.46 13.32 57 13.68 57.54 14.1 58.08 14.46 58.62 14.94 59.04 15.42 59.52 15.84 59.94 16.32 60.3 16.92 60.72 17.46 61.08 18 61.44 18.6 61.68 19.14 61.98 19.8 62.28 20.4 62.46 21.06 62.7 21.72 62.82 22.44 62.94 23.04 63.06 23.76 63.06 24.48 63.12 25.2 63.12 27.66 63.18 28.56 42.6 28.56 42.78 28.86 42.84 29.04 43.14 29.52 43.74 30.36 44.88 31.5 45.3 31.86 45.78 32.1 46.2 32.34 46.74 32.52 47.22 32.76 47.7 32.88 48.3 33 48.54 33.06 48.84 33.06 49.44 33.12 57.06 33.12 64.68 33.18 64.68 22.68" style="fill: #fff; fill-rule: evenodd; stroke-width: 0px;"/>
			<polyline points="42.84 23.28 55.92 23.28 55.8 22.62 55.62 21.96 55.38 21.42 55.08 20.88 54.78 20.28 54.42 19.86 53.7 18.9 53.22 18.6 52.74 18.24 52.26 17.94 51.66 17.7 51.12 17.46 50.58 17.34 50.28 17.28 50.04 17.22 48.78 17.22 47.58 17.46 47.1 17.7 46.5 17.94 46.02 18.24 45.6 18.6 45.12 18.9 44.28 19.86 43.92 20.28 43.62 20.88 43.32 21.42 43.02 22.32 42.9 22.62 42.84 22.92 42.84 23.28" style="fill-rule: evenodd; stroke-width: 0px;"/>
			<polyline points="21.96 11.34 21.36 11.4 20.76 11.4 20.52 11.46 20.16 11.52 19.92 11.58 19.62 11.64 18 12.18 17.46 12.48 16.98 12.78 16.5 13.02 16.02 13.38 15.6 13.74 14.64 14.58 14.28 14.94 13.92 15.42 13.5 15.9 13.14 16.38 12.54 17.46 12.18 18 11.22 20.4 11.04 21.06 10.92 21.72 10.74 22.44 10.68 23.04 10.62 23.76 10.56 24.48 10.56 25.86 10.62 26.58 10.68 27.3 10.74 27.96 10.92 28.62 11.04 29.28 11.22 29.94 11.7 31.14 11.94 31.8 12.18 32.34 12.54 32.88 12.84 33.48 13.14 33.96 13.5 34.5 13.92 34.98 14.28 35.46 14.64 35.88 15.12 36.3 15.6 36.66 16.02 36.96 16.5 37.32 17.46 37.92 18 38.16 18.54 38.34 19.08 38.58 19.62 38.7 19.92 38.76 20.16 38.82 20.52 38.88 20.76 38.94 21.36 38.94 21.66 39 36.72 39 36.72 33.18 23.82 33.18 23.4 33.12 23.04 33.06 22.62 33 21.9 32.76 21.48 32.64 21.18 32.52 20.88 32.34 20.52 32.16 19.86 31.8 18.96 31.08 18.42 30.54 18.18 30.24 18 29.94 17.7 29.58 17.34 28.98 17.04 28.26 16.86 27.9 16.74 27.54 16.62 26.82 16.5 26.4 16.44 26.04 16.44 25.62 16.38 25.2 16.44 24.72 16.44 24.36 16.5 24 16.62 23.58 16.68 23.22 16.74 22.8 16.86 22.44 17.04 22.08 17.34 21.36 17.52 21.06 17.7 20.7 18 20.4 18.18 20.16 18.42 19.86 19.26 19.02 19.86 18.6 20.16 18.36 20.88 18 21.18 17.88 21.48 17.7 21.9 17.58 22.26 17.46 22.62 17.4 23.04 17.34 23.4 17.22 36.72 17.22 36.66 17.22 36.66 11.34 36.72 11.34 21.96 11.34" style="fill: #fff; fill-rule: evenodd; stroke-width: 0px;"/>
			<rect x="9.42" y="22.56" width="2.22" height="5.4" style="fill: #fff; stroke-width: 0px;"/>
			<rect x="89.64" y="21.72" width="3.48" height="17.22" style="fill: #fff; stroke-width: 0px;"/>
			<polyline points="10.74 80.28 10.68 74.1 8.28 74.46 5.64 75.42 .72 77.52 0 77.4 2.76 75.78 5.76 74.34 8.76 73.02 11.76 71.94 15.06 70.8 18.36 69.78 21.72 68.76 24.96 67.62 29.64 65.22 31.62 64.98 32.46 64.14 33.48 63.72 35.76 63.18 36.9 62.46 38.52 61.86 41.76 60.96 47.76 58.74 53.88 56.58 58.08 55.56 62.34 54.3 66.6 53.16 70.86 52.62 87.54 49.02 90.48 48.78 93.48 48.9 100.2 48.72 100.32 48.54 101.82 48.66 102.6 48.96 102.72 49.26 102.78 49.62 100.62 49.68 100.62 49.92 101.4 50.52 99.6 50.58 98.7 50.64 97.56 50.82 93.12 51 93 80.28 10.74 80.28" style="fill-rule: evenodd; stroke-width: 0px;"/>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="CENELEC-Logo">
		<xsl:text>data:image/png;base64,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</xsl:text>
	</xsl:variable>
	
	<!-- no need National Foreword in ToC -->
	<xsl:template match="mn:foreword[@type = 'national-foreword']" mode="contents" priority="3"/>
	
	<!-- ignore empty foreword -->
	<xsl:template match="mn:foreword[count(mn:p) = 0]" mode="contents" priority="3"/>
	<xsl:template match="mn:foreword[count(mn:p) = 0]" mode="update_xml_step1" priority="3"/>
	
	<xsl:template match="mn:p[@class = 'zzSTDTitle1']" mode="update_xml_step1" priority="3"/>
	
</xsl:stylesheet>
