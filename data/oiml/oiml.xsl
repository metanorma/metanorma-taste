<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:java="http://xml.apache.org/xalan/java" xmlns:barcode="http://barcode4j.krysalis.org/ns" xmlns:redirect="http://xml.apache.org/xalan/redirect" xmlns:svg="http://www.w3.org/2000/svg" exclude-result-prefixes="java" extension-element-prefixes="redirect" version="1.0">

	<xsl:attribute-set name="root-style">
		<xsl:attribute name="font-family">Times New Roman, Cambria Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="font-selection-strategy">character-by-character</xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="marginLeftRight1">25.5</xsl:variable>
	<xsl:variable name="marginLeftRight2">25.5</xsl:variable>
	<xsl:variable name="marginTop">26.5</xsl:variable>
	<xsl:variable name="marginBottom">26.5</xsl:variable>

	<xsl:variable name="layoutVersion">2024</xsl:variable>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="27mm" margin-bottom="25mm" margin-left="75mm" margin-right="15.7mm"/>
			</fo:simple-page-master>
			
			<fo:page-sequence-master master-name="document_first_sequence">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
		</fo:layout-master-set>
	</xsl:template>
	
	<xsl:template name="cover-page">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="end-on-even" font-family="Futura PT Book" color="rgb(34,30,31)"> <!-- Futura Bk -->
			<xsl:variable name="curr_lang"><xsl:call-template name="getLang"/></xsl:variable>
			<xsl:variable name="docidentifier"><xsl:call-template name="get_docidentifier"/></xsl:variable>
			<xsl:variable name="title_complementary"><xsl:call-template name="get_title_complementary"/></xsl:variable>
			<xsl:variable name="edition">
				<!-- Example: Edition 2021 (E) -->
				<xsl:variable name="i18n_edition"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">edition</xsl:with-param></xsl:call-template></xsl:variable>
				<xsl:call-template name="capitalize"><xsl:with-param name="str" select="$i18n_edition"/></xsl:call-template>
				<xsl:text>&#xa0;</xsl:text>
				<xsl:call-template name="get_edition"/>
			</xsl:variable>
			
			<fo:flow flow-name="xsl-region-body">
				<xsl:call-template name="insert_firstpage_id"><xsl:with-param name="num" select="$num"/></xsl:call-template>
				
				<xsl:variable name="ratio">0.82</xsl:variable>
				
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<xsl:variable name="doctype"><xsl:call-template name="getDoctype"/></xsl:variable>
								<xsl:variable name="doctype_capitalized">
									<xsl:call-template name="capitalizeWords"><xsl:with-param name="str" select="$doctype"/></xsl:call-template>
								</xsl:variable>
								<!-- <fo:block font-size="16.5pt" line-height="1.36">
									<xsl:call-template name="capitalize_oiml">
										<xsl:with-param name="str" select="$doctype_capitalized"/>
										<xsl:with-param name="font_size_capital">22</xsl:with-param>
									</xsl:call-template>
								</fo:block> -->
								<xsl:variable name="doctype_splitted">
									<xsl:call-template name="split">
										<xsl:with-param name="pText" select="$doctype_capitalized"/>
										<xsl:with-param name="sep" select="' '"/>
									</xsl:call-template>
								</xsl:variable>
								<fo:block margin-top="-2mm">
									<fo:instream-foreign-object fox:alt-text="doctype" width="100%" content-height="100%" scaling="uniform">
										<svg xmlns="http://www.w3.org/2000/svg" width="60mm" height="60mm">
											<xsl:variable name="y">30</xsl:variable>
											<xsl:for-each select="xalan:nodeset($doctype_splitted)//mnx:item">
												<!-- <xsl:copy-of select="."/> -->
												<text font-family="Futura PT Book" x="0" y="{$y * position() + 10 * (position() - 1)}" font-size="19pt" transform="scale({$ratio},1)">
													<xsl:call-template name="capitalize_oiml">
														<xsl:with-param name="str" select="."/>
														<xsl:with-param name="font_size_capital">25</xsl:with-param>
														<xsl:with-param name="element_name">svg:tspan</xsl:with-param>
													</xsl:call-template>
												</text>
											</xsl:for-each>
										</svg>
									</fo:instream-foreign-object>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell text-align="right">
								<!-- Example: OIML R 60-1 -->
								<!-- <fo:block font-size="27pt" font-family="Futura PT Demi"> 
									<xsl:value-of select="$docidentifier"/>
									<xsl:if test="$title_complementary != ''"><xsl:text> </xsl:text></xsl:if>
									<xsl:copy-of select="$title_complementary"/>
								</fo:block> -->
								<fo:block>
									<fo:instream-foreign-object fox:alt-text="docidentifier" width="100%" content-height="100%" scaling="uniform">
										<svg xmlns="http://www.w3.org/2000/svg" width="250" height="35">
											<xsl:if test="$title_complementary != ''">
												<xsl:attribute name="height">70</xsl:attribute>
											</xsl:if>
											<g font-family="Futura PT Demi" font-size="28pt" transform="scale({$ratio},1)">
												<text x="{250 div $ratio}" y="25" text-anchor="end">
													<xsl:value-of select="$docidentifier"/>
												</text>
												<xsl:if test="$title_complementary != ''">
													<text x="{250 div $ratio}" y="60" text-anchor="end">
														<xsl:value-of select="$title_complementary"/>
													</text>
												</xsl:if>
											</g>
										</svg>
									</fo:instream-foreign-object>
								</fo:block>
								<!-- Edition 2021 (E) -->
								<!-- <fo:block font-size="15.5pt" margin-top="2mm" margin-right="2mm">
									<xsl:value-of select="$edition"/>
								</fo:block> -->
								<fo:block margin-top="1mm">
									<fo:instream-foreign-object fox:alt-text="edition" width="100%" content-height="100%" scaling="uniform">
										<svg xmlns="http://www.w3.org/2000/svg" width="250" height="60">
											<!-- <line x1="250" y1="0" x2="250" y2="50" stroke="red" /> -->
											<text font-family="Futura PT Book" x="{250 div $ratio}" y="20" font-size="18pt" transform="scale({$ratio},1)" text-anchor="end" dominant-baseline="middle">
												<xsl:value-of select="$edition"/>
											</text>
										</svg>
									</fo:instream-foreign-object>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				
				<xsl:variable name="part" select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@part"/>
				<xsl:variable name="border_title">1pt solid black</xsl:variable>
				<fo:block-container position="absolute" top="65mm" width="119mm" height="80mm" role="SKIP" border-top="{$border_title}" border-bottom="{$border_title}">
					<fo:table table-layout="fixed" width="100%" role="SKIP">
						<fo:table-body role="SKIP">
							<fo:table-row height="55mm" font-size="16pt" role="SKIP">
								<fo:table-cell role="SKIP">
									<fo:block role="SKIP">
										<xsl:variable name="titles">
											<title><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-intro' and @language = $curr_lang]/node()"/></title>
											<title><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-main' and @language = $curr_lang]/node()"/></title>
											<title><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-complementary' and @language = $curr_lang]/node()"/></title>
											<title><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-addendum' and @language = $curr_lang]/node()"/></title>
										</xsl:variable>
										<xsl:for-each select="xalan:nodeset($titles)/title[normalize-space() != '']">
											<fo:block role="H1">
												<xsl:if test="position() = 1">
													<xsl:attribute name="margin-top">11mm</xsl:attribute>
												</xsl:if>
												<xsl:if test="position() != 1">
													<xsl:attribute name="space-before">12pt</xsl:attribute>
												</xsl:if>
												<xsl:copy-of select="node()"/>
											</fo:block>
										</xsl:for-each>
										<xsl:variable name="title_part">
											<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-part' and @language = $curr_lang]/node()"/>
										</xsl:variable>
										<xsl:if test="normalize-space($title_part) != ''">
											<xsl:variable name="i18n_locality_part"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">locality.part</xsl:with-param></xsl:call-template></xsl:variable>
											<xsl:variable name="space_fr"><xsl:if test="$curr_lang = 'fr'"><xsl:text>&#xa0;</xsl:text></xsl:if></xsl:variable>
											<fo:block space-before="5mm" role="H1">
												<xsl:value-of select="concat($i18n_locality_part, ' ', $part, $space_fr, ': ')"/>
												<xsl:copy-of select="$title_part"/>
											</fo:block>
										</xsl:if>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row height="25mm" font-size="11pt" role="SKIP">
								<fo:table-cell role="SKIP">
									<fo:block role="SKIP" font-family="Futura PT Light"> <!-- Futura-Light font-weight="300" -->
										<xsl:variable name="lang_other">
											<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:title[@language != $curr_lang]">
												<xsl:if test="not(preceding-sibling::mn:title[@language = current()/@language])">
													<xsl:element name="lang" namespace="{$namespace_mn_xsl}"><xsl:value-of select="@language"/></xsl:element>
												</xsl:if>
											</xsl:for-each>
										</xsl:variable>
										<xsl:variable name="bibdata_"><xsl:copy-of select="/mn:metanorma/mn:bibdata/node()"/></xsl:variable>
										<xsl:variable name="bibdata" select="xalan:nodeset($bibdata_)"/>
										<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
											<xsl:variable name="lang_other_" select="."/>
											<xsl:variable name="titles_lang_other">
												<title><xsl:apply-templates select="$bibdata/mn:title[@type = 'title-intro' and @language = $lang_other_]/node()"/></title>
												<title><xsl:apply-templates select="$bibdata/mn:title[@type = 'title-main' and @language = $lang_other_]/node()"/></title>
												<title><xsl:apply-templates select="$bibdata/mn:title[@type = 'title-complementary' and @language = $lang_other_]/node()"/></title>
												<title><xsl:apply-templates select="$bibdata/mn:title[@type = 'title-addendum' and @language = $lang_other_]/node()"/></title>
											</xsl:variable>
											<xsl:for-each select="xalan:nodeset($titles_lang_other)/title[normalize-space() != '']">
												<fo:block role="H1">
													<xsl:if test="position() != 1">
														<xsl:attribute name="space-before">8pt</xsl:attribute>
													</xsl:if>
													<xsl:copy-of select="node()"/>
												</fo:block>
											</xsl:for-each>
											<xsl:variable name="title_part">
												<xsl:apply-templates select="$bibdata/mn:title[@type = 'title-part' and @language = $lang_other_]/node()"/>
											</xsl:variable>
											<xsl:if test="normalize-space($title_part) != ''">
												<xsl:variable name="space_fr"><xsl:if test="$lang_other_ = 'fr'"><xsl:text> </xsl:text></xsl:if></xsl:variable>
												<xsl:variable name="i18n_locality_part" select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang = $lang_other_]),'#',concat($part, $space_fr))"/>
												<fo:block space-before="3mm" role="H1">
													<xsl:value-of select="concat($i18n_locality_part, ' ')"/>
													<xsl:copy-of select="$title_part"/>
												</fo:block>
											</xsl:if>
										</xsl:for-each>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
				
				<fo:block-container position="absolute" top="214mm" width="119mm" font-size="11.25pt" line-height="1.3" role="SKIP">
					<fo:table table-layout="fixed" width="100%" role="SKIP">
						<fo:table-column column-width="57mm"/>
						<fo:table-column column-width="62mm"/>
						<fo:table-body role="SKIP">
							<fo:table-row role="SKIP">
								<fo:table-cell role="SKIP">
									<fo:block margin-left="-2mm">
										<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization">
											<xsl:apply-templates select="mn:logo/mn:image"/>
											<xsl:if test="position() != last()"><fo:inline> </fo:inline></xsl:if>
										</xsl:for-each>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" role="SKIP">
									<fo:block border-bottom="0.5pt solid black">
										<!-- <xsl:variable name="oiml_fr">Organisation Internationale de Métrologie Légale</xsl:variable>
										<xsl:call-template name="capitalize_oiml">
											<xsl:with-param name="str" select="$oiml_fr"/>
										</xsl:call-template> -->
										<xsl:variable name="oiml_fr_part1">Organisation Internationale</xsl:variable>
										<xsl:variable name="oiml_fr_part2">de Métrologie Légale</xsl:variable>
										<xsl:call-template name="insert_oiml_title">
											<xsl:with-param name="oiml_part1" select="$oiml_fr_part1"/>
											<xsl:with-param name="oiml_part2" select="$oiml_fr_part2"/>
										</xsl:call-template>
									</fo:block>
									<fo:block padding-top="3mm">
										<!-- <xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization/mn:name/node()" mode="capitalize"/> -->
										<xsl:variable name="oiml" select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization/mn:name"/>
										<xsl:variable name="oiml_part1" select="substring-before($oiml, ' of ')"/>
										<xsl:variable name="oiml_part2" select="concat(' of ' , substring-after($oiml, ' of '))"/>
										<xsl:call-template name="insert_oiml_title">
											<xsl:with-param name="oiml_part1" select="$oiml_part1"/>
											<xsl:with-param name="oiml_part2" select="$oiml_part2"/>
										</xsl:call-template>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
				
				<!-- vertical identifier -->
				<fo:block-container position="absolute" left="-63.5mm" top="0mm" reference-orientation="90" font-size="11.5pt" text-align="left" role="SKIP"> <!-- top="215mm"  -->
					<fo:block>
						<xsl:variable name="docidentifier_full">
							<xsl:value-of select="$docidentifier"/>
							<xsl:if test="$title_complementary != ''"><xsl:text> </xsl:text></xsl:if>
							<xsl:copy-of select="$title_complementary"/>
							<xsl:text>&#xa0;</xsl:text>
							<xsl:value-of select="$edition"/>
						</xsl:variable>
						<!-- <xsl:value-of select="$docidentifier_full"/> -->
						<fo:instream-foreign-object fox:alt-text="doctype" width="100%" content-height="100%" scaling="uniform">
							<svg xmlns="http://www.w3.org/2000/svg" width="100mm" height="10mm">
								<text font-family="Futura PT Book" x="0" y="15" font-size="13pt" transform="scale(0.85,1)">
									<xsl:value-of select="$docidentifier_full"/>
								</text>
							</svg>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END cover-page -->

	<xsl:template name="insert_oiml_title">
		<xsl:param name="oiml_part1"/>
		<xsl:param name="oiml_part2"/>
		<xsl:param name="ratio">0.82</xsl:param>
		<fo:instream-foreign-object fox:alt-text="doctype" width="100%" content-height="100%" scaling="uniform">
			<svg xmlns="http://www.w3.org/2000/svg" width="250" height="52">
				<g font-family="Futura PT Book" font-size="13pt" transform="scale({$ratio},1)">
					<text x="{250 div $ratio}" y="15" text-anchor="end">
						<xsl:call-template name="capitalize_oiml">
							<xsl:with-param name="str" select="$oiml_part1"/>
							<xsl:with-param name="font_size_capital">17</xsl:with-param>
							<xsl:with-param name="element_name">svg:tspan</xsl:with-param>
						</xsl:call-template>
					</text>
					<text x="{250 div $ratio}" y="42" text-anchor="end">
						<xsl:call-template name="capitalize_oiml">
							<xsl:with-param name="str" select="$oiml_part2"/>
							<xsl:with-param name="font_size_capital">17</xsl:with-param>
							<xsl:with-param name="element_name">svg:tspan</xsl:with-param>
						</xsl:call-template>
					</text>
				</g>
			</svg>
		</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:template match="text()" mode="capitalize" name="capitalize_oiml">
		<xsl:param name="str" select="."/>
		<xsl:param name="font_size_capital">15</xsl:param>
		<xsl:param name="element_name">fo:inline</xsl:param>
		<xsl:if test="string-length($str) &gt; 0">
			<xsl:variable name="char" select="substring($str, 1,1)"/>
			<xsl:choose>
				<xsl:when test="normalize-space(java:java.lang.Character.isUpperCase($char)) = 'true'">
					<xsl:element name="{$element_name}">
						<xsl:attribute name="font-size"><xsl:value-of select="$font_size_capital"/>pt</xsl:attribute>
						<xsl:value-of select="$char"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="java:java.lang.Character.toUpperCase($char)"/></xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="capitalize_oiml">
				<xsl:with-param name="str" select="substring($str, 2)"/>
				<xsl:with-param name="font_size_capital" select="$font_size_capital"/>
				<xsl:with-param name="element_name" select="$element_name"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="get_docidentifier">
		<!-- Example: OIML R 60-1 -->
		<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[@primary = 'true']"/>
	</xsl:template>
	
	<xsl:template name="get_title_complementary">
		<xsl:variable name="curr_lang"><xsl:call-template name="getLang"/></xsl:variable>
		<!-- <xsl:text> </xsl:text> -->
		<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-complementary' and @language = $curr_lang]/node()"/>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>
	
	<xsl:template name="get_edition">
		<!-- ... :2021(E) -->
		<!-- <xsl:variable name="reference" select="substring-after(/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'iso-reference'], ':')"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($reference),'(\()', ' $1')"/> -->
		<xsl:variable name="curr_lang"><xsl:call-template name="getLang"/></xsl:variable>
		<xsl:variable name="curr_lang_1st_letter" select="java:java.lang.Character.toUpperCase(substring($curr_lang,1,1))"/>
		<xsl:value-of select="concat(substring(/mn:metanorma/mn:bibdata/mn:version/mn:revision-date, 1, 4), ' (', $curr_lang_1st_letter, ')')"/>
	</xsl:template>

	<!-- omit copyright-statement -->
	<xsl:template name="inner-cover-page">
	</xsl:template>

	<!-- empty back-page to omit back cover -->
	<xsl:template name="back-page">
	</xsl:template>
	
	<xsl:template name="insertHeaderFirst2">
	</xsl:template>
	
	<xsl:template name="insertHeaderEven">
		<xsl:param name="text_align">left</xsl:param>
		<xsl:param name="flow_name">header-even</xsl:param>
		<fo:static-content flow-name="{$flow_name}" > <!-- role="artifact" commented, because <fo:retrieve-marker occurs the FOP error -->
			<fo:block font-family="Arial" font-size="9pt" margin-top="13mm" border-bottom="0.5pt solid black" text-align="{$text_align}">
				<xsl:variable name="title_complementary">
					<xsl:call-template name="get_title_complementary"/>
				</xsl:variable>
				<xsl:if test="normalize-space($title_complementary) != ''">
					<xsl:attribute name="text-align">center</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="get_docidentifier"/><xsl:text>:</xsl:text>
				<xsl:call-template name="get_edition"/>
				<xsl:choose>
					<xsl:when test="mn:annex">
						<fo:retrieve-marker retrieve-class-name="annex_number" retrieve-boundary="document" /> <!-- retrieve-position="first-starting-within-page" -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="normalize-space($title_complementary) != ''">
							<xsl:text> – </xsl:text>
						</xsl:if>
						<xsl:copy-of select="$title_complementary"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertHeaderOdd">
		<xsl:call-template name="insertHeaderEven">
			<xsl:with-param name="text_align">right</xsl:with-param>
			<xsl:with-param name="flow_name">header-odd</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="insertFooterEven">
		<xsl:param name="flow_name">footer-even</xsl:param>
		<fo:static-content flow-name="{$flow_name}" role="artifact">
			<fo:block font-family="Arial" font-size="9pt" margin-top="8mm" border-top="0.5pt solid black" text-align="center" padding-top="0.5mm">
				<fo:page-number/>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="insertFooterOdd">
		<xsl:call-template name="insertFooterEven">
			<xsl:with-param name="flow_name">footer-odd</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="refine_page-sequence-preface">
		<xsl:attribute name="format">1</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="refine_page-sequence-main">
		<xsl:attribute name="initial-page-number">auto</xsl:attribute>
	</xsl:template>
	
	<xsl:attribute-set name="toc-title-style">
		<xsl:attribute name="font-size">14pt</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="space-after">26pt</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- no need Mandatory or Informative in ToC, replace to indent -->
	<xsl:template match="mn:span[@class = 'fmt-obligation']" priority="3" mode="contents_item">
		<xsl:element name="span" namespace="{$namespace_full}">
			<xsl:attribute name="style">text-indent:4mm</xsl:attribute>
			<xsl:value-of select="$zero_width_space"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="toc-title-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template name="refine_toc-leader-style">
		<xsl:if test="@level = 1">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="refine_clause_style">
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="refine_title-style"><?extend?>
		<xsl:if test="$level = 1">
			<xsl:attribute name="font-size">14pt</xsl:attribute>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:annex">
				<!-- <xsl:attribute name="margin-left">20mm</xsl:attribute>
				<xsl:attribute name="margin-right">20mm</xsl:attribute> -->
				<xsl:attribute name="margin-bottom">30pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$level = 2">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$level &gt;= 2">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!-- clause number -->
	<!-- <xsl:template match="mn:fmt-title[@depth = 2 or @depth = 3]//text()[following-sibling::mn:tab]" priority="5">
		<fo:inline font-size="12pt"><xsl:value-of select="."/></fo:inline>
	</xsl:template> -->
	
	<xsl:attribute-set name="p-style"><?extend?>
		<xsl:attribute name="line-height">1.2</xsl:attribute>
	</xsl:attribute-set>
	
	
	<xsl:template name="refine_p-style">
		<xsl:if test="parent::mn:li/following-sibling::*">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:if test="ancestor::mn:term">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="parent::mn:dd">
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!-- no need to show title, if there aren't main section -->
	<xsl:template match="mn:sections[mn:p[@class = 'zzSTDTitle1'] and count(*) = 1]" priority="3" mode="update_xml_step1"/>
	
	<xsl:template match="mn:sections//mn:p[@class = 'zzSTDTitle1']" priority="4">
		<fo:block font-size="18pt" font-weight="bold" text-align="center" margin-bottom="36pt" role="H1">
			<!-- Example: Part 1 - Metrological and technical requirements -->
			<xsl:variable name="bibdata_"><xsl:copy-of select="ancestor::mn:metanorma/mn:bibdata/node()"/></xsl:variable>
			<xsl:variable name="bibdata" select="xalan:nodeset($bibdata_)"/>
			<xsl:variable name="part" select="$bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@part"/>
			<xsl:variable name="i18n_locality_part"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">locality.part</xsl:with-param></xsl:call-template></xsl:variable>
			<xsl:variable name="curr_lang"><xsl:call-template name="getLang"/></xsl:variable>
			<xsl:value-of select="concat($i18n_locality_part, ' ', $part, ' - ')"/>
			<xsl:apply-templates select="$bibdata/mn:title[@type = 'title-part' and @language = $curr_lang]"/>
		</fo:block>
	</xsl:template>

	<xsl:attribute-set name="note-style"><?extend?>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="termnote-style"><?extend?>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="note-name-style"><?extend?>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="example-style"><?extend?>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="example-body-style">
		<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="example-p-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="margin-top">2pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="termnote-name-style"><?extend?>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template match="mn:note" name="note">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block xsl:use-attribute-sets="note-style" role="SKIP">
			<xsl:if test="not(parent::mn:references)">
				<xsl:copy-of select="@id"/>
			</xsl:if>
			<xsl:call-template name="refine_note-style"/>
			<fo:list-block>
				<xsl:attribute name="provisional-distance-between-starts">14.5mm</xsl:attribute>
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block xsl:use-attribute-sets="note-name-style">
							<xsl:call-template name="refine_note-name-style"/>
							
							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="sfx">:</xsl:with-param>
							</xsl:apply-templates>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:example" name="example">
		<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">
			<xsl:call-template name="setBlockSpanAll"/>
			<xsl:call-template name="refine_example-style"/>
			<fo:block-container margin-left="0mm" role="SKIP">
				<!-- display name 'EXAMPLE' in a separate block  -->
				<fo:block>
					<xsl:apply-templates select="mn:fmt-name">
						<xsl:with-param name="fo_element">fo:block</xsl:with-param>
					</xsl:apply-templates>
				</fo:block>
				<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
					<xsl:call-template name="refine_example-body-style"/>
					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<xsl:variable name="example_body">
							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]">
								<xsl:with-param name="fo_element">fo:block</xsl:with-param>
							</xsl:apply-templates>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="xalan:nodeset($example_body)/*">
								<xsl:copy-of select="$example_body"/>
							</xsl:when>
							<xsl:otherwise><fo:block/><!-- prevent empty block-container --></xsl:otherwise>
						</xsl:choose>
					</fo:block-container>
				</fo:block-container>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="mn:example/mn:fmt-name/text()" priority="5">
		<!-- remove all digits -->
		<xsl:variable name="example_name" select="java:replaceAll(java:java.lang.String.new(.),'\d','')"/>
		<xsl:value-of select="concat(normalize-space($example_name), ':')"/>
	</xsl:template>
	
	<xsl:template match="mn:ul/mn:li/mn:fmt-name[normalize-space() = '—']" priority="3" mode="update_xml_step1">
		<xsl:attribute name="label">■</xsl:attribute>
		<xsl:if test="ancestor::mn:term">
			<xsl:attribute name="label">●</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:variable name="ul_labels_">
		<label font-size="60%">■</label>
		<label font-size="90%" line-height="140%">●</label>
	</xsl:variable>
	
	<!-- <xsl:attribute-set name="list-style"><?extend?>
		
	</xsl:attribute-set> -->
	
	<xsl:template name="refine_list-style">
		<xsl:if test="self::mn:ul">
			<xsl:attribute name="margin-left">6.5mm</xsl:attribute>
			<xsl:if test="ancestor::mn:term">
				<xsl:attribute name="margin-left">15mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:attribute name="space-after">6pt</xsl:attribute>
		<xsl:if test="ancestor::mn:term">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="figure-name-style"><?extend?>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="table-name-style"><?extend?>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="term-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_term-style">
		<xsl:if test="mn:termnote">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="term-definition-style"><?extend?>
		<xsl:attribute name="space-before">6pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dt-block-style">
		<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
	</xsl:template>
	
	<xsl:attribute-set name="link-style">
	<!-- no underline and color -->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xref-style">
		<!-- no underline and color -->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="table-row-style"><?extend?>
		<xsl:attribute name="min-height">8.3mm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_footnote-separator-block-style"><?extend?>
		<xsl:attribute name="margin-bottom">16mm</xsl:attribute>
	</xsl:template>
	
	<!-- (Mandatory) and (Informative) in bold -->
	<xsl:template match="mn:annex/mn:fmt-title//mn:span[@class = 'fmt-obligation']" priority="3" mode="update_xml_step1">
		<xsl:element name="strong" namespace="{$namespace_full}">
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	<!-- remove redundant br in annex title -->
	<xsl:template match="mn:annex/mn:fmt-title//mn:br[preceding-sibling::node()[1][self::mn:br]]" priority="3" mode="update_xml_step1"/>
	
	<!-- copyed from iso.internation-standard.iso, added <fo:marker marker-class-name="annex_number"> -->
	<xsl:template match="mn:annex[normalize-space() != '']">
		<xsl:choose>
			<xsl:when test="@continue = 'true'"> <!-- it's using for figure/table on top level for block span -->
				<fo:block>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
			
				<fo:block break-after="page"/>
				<xsl:call-template name="setNamedDestination"/>
				
				<fo:block id="{@id}" role="Sect">
					<xsl:attribute name="role">Sect</xsl:attribute>
					<xsl:call-template name="addTagElementT"/>
					
					<xsl:call-template name="setBlockSpanAll"/>
					
					<fo:marker marker-class-name="annex_number">
						<!-- Example: Annex A -->
						<xsl:variable name="annex_number" select="normalize-space(mn:fmt-title/*[1])"/>
						<xsl:if test="normalize-space($annex_number) != ''"><xsl:text>&#xa0;–&#xa0;</xsl:text></xsl:if>
						<xsl:value-of select="$annex_number"/>
					</fo:marker>
					
					<xsl:call-template name="refine_annex_style"/>
					
				</fo:block>
				
				<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>
				
				<fo:block>
					<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]" />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:annex/mn:fmt-title//mn:br">
		<fo:block font-size="1pt" margin-top="2mm">&#xa0;</fo:block>
	</xsl:template>

	
</xsl:stylesheet>