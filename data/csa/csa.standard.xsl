<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java xalan" extension-element-prefixes="redirect" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:key name="kfn" match="mn:fn[not(ancestor::*[self::mn:table or self::mn:figure or self::mn:localized-strings] and not(ancestor::mn:fmt-name))]" use="@reference"/>

	<xsl:variable name="debug">false</xsl:variable>

	<xsl:variable name="copyright">
		<xsl:text>© Copyright </xsl:text>
		<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:from"/>
		<xsl:text>, Cloud Security Alliance. All rights reserved.</xsl:text>
	</xsl:variable>

	<xsl:variable name="color-header-document">rgb(79, 201, 204)</xsl:variable>

	<xsl:variable name="contents_">
		<mnx:contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
			<xsl:call-template name="processTablesFigures_Contents"/>
		</mnx:contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<!-- Cover page -->
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="21mm" margin-bottom="21mm" margin-left="25mm" margin-right="25mm"/>
				<fo:region-before region-name="cover-page-header" extent="21mm" precedence="true"/>
				<fo:region-after region-name="footer" extent="21mm"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="document" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm" precedence="true"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="document-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm" precedence="true"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>

		</fo:layout-master-set>
	</xsl:template> <!-- END: layout-master-set -->

	<xsl:template match="/">
		<fo:root xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>

			<xsl:call-template name="layout-master-set"/>

			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>

			<xsl:call-template name="cover-page"/>

			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="document" initial-page-number="2" format="1" force-page-count="no-force">

				<xsl:call-template name="insertFootnoteSeparatorCommon"/>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">

					<xsl:if test="$debug = 'true'">
						<redirect:write file="contents_.xml"> <!-- {java:getTime(java:java.util.Date.new())} -->
							<xsl:copy-of select="$contents"/>
						</redirect:write>
					</xsl:if>

					<fo:block>
						<fo:block>The permanent and official location for Cloud Security Alliance DevSecOps is</fo:block>
						<fo:block color="rgb(33, 94, 159)" text-decoration="underline">https://cloudsecurityalliance.org/group/DevSecOps/</fo:block>
					</fo:block>

					<fo:block-container absolute-position="fixed" left="25mm" top="152mm" width="165mm" height="100mm" display-align="after" color="rgb(165, 169, 172)" line-height="145%">
						<fo:block>© <xsl:value-of select="/mn:metanorma/mn:bibdata/mn:copyright/mn:from"/> Cloud Security Alliance – All Rights Reserved. You may download, store, display on your
						computer, view, print, and link to the Cloud Security Alliance at <fo:inline text-decoration="underline">https://cloudsecurityalliance.org</fo:inline>
						subject to the following: (a) the draft may be used solely for your personal, informational, noncommercial
						use; (b) the draft may not be modified or altered in any way; (c) the draft may not be
						redistributed; and (d) the trademark, copyright or other notices may not be removed. You may quote
						portions of the draft as permitted by the Fair Use provisions of the United States Copyright Act,
						provided that you attribute the portions to the Cloud Security Alliance.</fo:block>
					</fo:block-container>

					<fo:block break-after="page"/>

					<fo:block font-size="26pt" margin-bottom="18pt" role="H1">
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">acknowledgements</xsl:with-param>
						</xsl:call-template>
					</fo:block>

					<xsl:variable name="persons">
						<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:contributor[mn:person]">
							<contributor>
								<xsl:attribute name="type">
									<xsl:choose>
										<xsl:when test="mn:role/@type='author'">
											<xsl:value-of select="mn:role/mn:description"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="mn:role/@type"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="mn:person/mn:name/mn:completename"/>
							</contributor>
						</xsl:for-each>
					</xsl:variable>

					<xsl:variable name="contributors">
						<contributor title="Author" pluraltitle="Authors">full-author</contributor>
						<contributor title="Contributor" pluraltitle="Contributors">contributor</contributor>
						<contributor title="Staff" pluraltitle="Staff">staff</contributor>
						<contributor title="Reviewer" pluraltitle="Reviewers">reviewer</contributor>
						<contributor title="Editor" pluraltitle="Editors">editor</contributor>
					</xsl:variable>

					<!-- The sequence of author types is: full-author (omitted), Contributor, Staff, Reviewer -->

					<xsl:for-each select="xalan:nodeset($contributors)/*">
						<xsl:variable name="type" select="."/>
						<xsl:variable name="title" select="@title"/>
						<xsl:variable name="pluraltitle" select="@pluraltitle"/>
						<xsl:for-each select="xalan:nodeset($persons)/contributor[@type = $type]">
							<xsl:if test="position() = 1">
								<fo:block font-size="18pt" font-weight="bold" margin-top="16pt" margin-bottom="12pt" color="rgb(3, 115, 200)">
									<xsl:choose>
										<xsl:when test="following-sibling::contributor[@type = $type]">
											<xsl:value-of select="$pluraltitle"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$title"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>:</xsl:text>
								</fo:block>
							</xsl:if>
							<fo:block><xsl:value-of select="."/></fo:block>
						</xsl:for-each>
					</xsl:for-each>

					<!-- <fo:block break-after="page"/> -->

					<!-- Table of Contents -->
					<!-- <xsl:apply-templates select="/*/mn:preface/mn:clause[@type = 'toc']">
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates> -->

					<!-- <fo:block line-height="145%">
						<xsl:call-template name="processPrefaceSectionsDefault"/>					
						<xsl:call-template name="processMainSectionsDefault"/>
					</fo:block> -->

				</fo:flow>
			</fo:page-sequence>

			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
			</xsl:variable>

			<xsl:for-each select="xalan:nodeset($updated_xml)/*">

				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processAllSectionsDefault_items"/>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface -->
					<xsl:for-each select=".//mn:page_sequence[normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
						<fo:page-sequence master-reference="document" format="1" force-page-count="no-force">

							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>

							<xsl:call-template name="insertFootnoteSeparatorCommon"/>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">

								<!-- Table of Contents -->
								<xsl:apply-templates select=".//mn:preface//mn:clause[@type = 'toc']">
									<xsl:with-param name="process">true</xsl:with-param>
								</xsl:apply-templates>

								<fo:block line-height="145%">
									<!-- <xsl:call-template name="processPrefaceSectionsDefault"/>					
									<xsl:call-template name="processMainSectionsDefault"/> -->
									<xsl:apply-templates/>
								</fo:block>

								<fo:block/> <!-- for prevent empty preface -->
							</fo:flow>
						</fo:page-sequence>

					</xsl:for-each>
				</xsl:for-each>

			</xsl:for-each>

			<!-- End Document Pages -->

		</fo:root>
	</xsl:template>

	<xsl:template name="cover-page">
		<!-- Cover Page -->
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
			<xsl:call-template name="insertFootnoteSeparatorCommon"/>
			<fo:static-content flow-name="cover-page-header">
				<fo:block-container height="2.5mm" background-color="rgb(55, 243, 244)">
					<fo:block font-size="1pt"> </fo:block>
				</fo:block-container>
				<fo:block-container position="absolute" top="2.5mm" height="{279.4 - 2.5}mm" width="100%" background-color="rgb(80, 203, 205)">
					<fo:block> </fo:block>
				</fo:block-container>
			</fo:static-content>

			<fo:flow flow-name="xsl-region-body">

				<fo:block-container width="136mm" margin-bottom="12pt">
					<fo:block font-size="36pt" font-weight="bold" color="rgb(54, 59, 74)" role="H1">
						<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:title[@language = 'en']"/>
					</fo:block>
				</fo:block-container>

				<fo:block font-size="26pt" color="rgb(55, 60, 75)" role="H2">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:title[@language = 'en' and @type = 'subtitle']"/>
				</fo:block>

				<fo:block-container absolute-position="fixed" left="11mm" top="245mm">
					<fo:block>
						<!-- <fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo))}" width="42mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/> -->
						<fo:instream-foreign-object content-width="42mm" fox:alt-text="CSA Logo">
							<xsl:copy-of select="$Image-Logo-SVG"/>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>

			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END: cover-page -->

	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block role="TOCI" keep-with-next="always">
			<fo:list-block xsl:use-attribute-sets="toc-listof-title-style">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block font-size="1pt"> </fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:value-of select="$title"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>

	<xsl:template name="insertListOf_Item">
		<fo:block role="TOCI">
			<fo:list-block xsl:use-attribute-sets="toc-listof-item-block-style">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block font-size="1pt"> </fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="toc-listof-item-style">
							<fo:basic-link internal-destination="{@id}">
								<xsl:call-template name="setAltText">
									<xsl:with-param name="value" select="@alt-text"/>
								</xsl:call-template>
								<xsl:apply-templates select="." mode="contents"/>
								<fo:inline keep-together.within-line="always">
									<fo:leader xsl:use-attribute-sets="toc-leader-style"/>
									<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
								</fo:inline>
							</fo:basic-link>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:preface//mn:clause[@type = 'toc']" name="toc" priority="3">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block-container xsl:use-attribute-sets="toc-style">

				<xsl:apply-templates/>

				<xsl:if test="count(*) = 1 and mn:fmt-title"> <!-- if there isn't user ToC -->
					<fo:block margin-left="-3mm" role="TOC">
						<xsl:for-each select="$contents//mnx:item[@display = 'true']">
							<fo:block role="TOCI">
								<fo:list-block xsl:use-attribute-sets="toc-item-block-style">
									<xsl:call-template name="refine_toc-item-block-style"/>
									<fo:list-item>
										<fo:list-item-label end-indent="label-end()">
											<fo:block font-size="1pt"> </fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block xsl:use-attribute-sets="toc-item-style">
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}">
													<fo:inline padding-right="2mm"><xsl:value-of select="@section"/></fo:inline>
													<xsl:apply-templates select="mnx:title"/>
													<fo:inline keep-together.within-line="always">
														<fo:leader xsl:use-attribute-sets="toc-leader-style"/>
														<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
													</fo:inline>
												</fo:basic-link>
											</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</fo:block>
						</xsl:for-each>

						<!-- List of Tables -->
						<xsl:for-each select="$contents//mnx:tables/mnx:table">
							<xsl:if test="position() = 1">
								<xsl:call-template name="insertListOf_Title">
									<xsl:with-param name="title" select="$title-list-tables"/>
								</xsl:call-template>
							</xsl:if>
							<xsl:call-template name="insertListOf_Item"/>
						</xsl:for-each>

						<!-- List of Figures -->
						<xsl:for-each select="$contents//mnx:figures/mnx:figure">
							<xsl:if test="position() = 1">
								<xsl:call-template name="insertListOf_Title">
									<xsl:with-param name="title" select="$title-list-figures"/>
								</xsl:call-template>
							</xsl:if>
							<xsl:call-template name="insertListOf_Item"/>
						</xsl:for-each>

					</fo:block>
				</xsl:if>
			</fo:block-container>

			<fo:block break-after="page"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="toc-title-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="node()">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->

	<!-- element with title -->
	<xsl:template match="*[mn:title or mn:fmt-title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mn:fmt-title/@depth | mn:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="$level &gt; $toc_level">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:term">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$skip = 'false'">
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>

			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>

			<mnx:item id="{@id}" level="{$level}" section="{$section}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
				<xsl:apply-templates mode="contents"/>
			</mnx:item>
		</xsl:if>
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	<xsl:template match="mn:annex/mn:fmt-title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">rgb(3, 115, 200)</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="12pt" text-align="center" margin-bottom="12pt" keep-with-next="always" color="{$color}" role="H{$level}">
			<xsl:apply-templates/>
			<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-title" name="title">

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::mn:preface and $level &gt;= 2">12pt</xsl:when>
				<xsl:when test="ancestor::mn:preface">13pt</xsl:when>
				<xsl:when test="$level = 1">26pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::mn:terms">11pt</xsl:when>
				<xsl:when test="$level = 2">14pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>16pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="font-weight">
			<xsl:choose>
				<xsl:when test="$level = 1">normal</xsl:when>
				<xsl:otherwise>bold</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">rgb(3, 115, 200)</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
			<xsl:attribute name="space-before">13.5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
			<xsl:attribute name="line-height">120%</xsl:attribute>
			<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>

			<xsl:if test="$level = 2">
				<fo:inline padding-right="1mm">
					<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Title))}" width="15mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}" vertical-align="middle"/>
				</fo:inline>
			</xsl:if>

			<xsl:apply-templates/>
			<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>

		</xsl:element>

	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:template match="mn:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'fmt-title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="parent::mn:admonition">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>

			<xsl:call-template name="setBlockAttributes"/>

			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::mn:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="line-height">155%</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(parent::mn:admonition)">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:ul | mn:ol" mode="list" priority="2">
		<xsl:choose>
			<xsl:when test="not(ancestor::mn:ul) and not(ancestor::mn:ol)">
				<fo:block-container border-left="0.75mm solid {$color-header-document}" margin-left="1mm" margin-bottom="12pt">
					<fo:block-container margin-left="8mm">
						<fo:block margin-left="-8mm" padding-top="6pt">
							<xsl:call-template name="listProcessing"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block-container>
					<fo:block-container margin-left="7mm">
						<fo:block margin-left="-7mm">
							<xsl:call-template name="listProcessing"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="listProcessing">
		<fo:list-block xsl:use-attribute-sets="list-style">
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="mn:ul/mn:note | mn:ol/mn:note" priority="2">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block/></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates select="mn:fmt-name"/>
					<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header" role="artifact">
			<fo:block-container height="2.5mm" background-color="{$color-header-document}">
				<fo:block font-size="1pt"> </fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container font-family="Azo Sans Lt" font-size="10.1pt" height="100%" display-align="after"> <!-- 11.5pt -->
				<fo:block padding-bottom="13mm" text-align="right" color="rgb(144, 144, 144)">
					<fo:inline padding-right="7mm"><xsl:value-of select="$copyright"/></fo:inline>
					<fo:page-number/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<!-- <xsl:variable name="Image-Logo">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAA+AAAAFsCAYAAABMytP3AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3BpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDplYWRhN2RlNC04YzAyLTQ1N2UtYjUwNy0zNGYzY2RjNWE2ZGQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NkU5NEE5NUY3NjVBMTFFQUFGNTc5RUZEMzQzODM4QzgiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NkU5NEE5NUU3NjVBMTFFQUFGNTc5RUZEMzQzODM4QzgiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgSW5EZXNpZ24gMTQuMCAoTWFjaW50b3NoKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ1dWlkOmQ1MDMzN2Q0LTBkZmItYzI0MS1iZTY2LWI3M2VlMWI2NWE4MyIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmlkOmJhMmE0NmVkLTFmMjUtNDExNS1hOTkzLWJkN2Q0YmY4MDBlMSIvPiA8L3Jk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</xsl:text>
	</xsl:variable> -->

	<xsl:variable name="Image-Logo-SVG">
		<svg xmlns="http://www.w3.org/2000/svg" id="Layer_1" data-name="Layer 1" viewBox="0 0 118.01 42.09" width="118.01" height="42.09">
			<defs>
				<style>
					.cls-1 {
						fill: #373c4b;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<path class="cls-1" d="m50.7,4.17c-.51-.46-1-.71-1.81-.71-1.25,0-2.36.99-2.63,2.75-.27,1.73.4,2.85,1.82,2.85.78,0,1.34-.28,1.96-.75l.59.64c-.76.6-1.6.98-2.73.98-1.75,0-3.18-1.18-2.81-3.64.4-2.6,2.34-3.7,4.01-3.7,1.08,0,1.85.35,2.4.83l-.8.75Z"/>
			<polygon class="cls-1" points="52.56 9.78 53.98 .56 55.21 0 53.7 9.78 52.56 9.78"/>
			<path class="cls-1" d="m60,3.46c-1.39,0-2.46.93-2.75,2.78-.29,1.85.5,2.82,1.88,2.82s2.48-.97,2.77-2.82c.29-1.85-.52-2.78-1.9-2.78m-1.03,6.47c-1.95,0-3.25-1.27-2.88-3.66.37-2.39,2.12-3.68,4.07-3.68s3.25,1.24,2.88,3.62c-.37,2.39-2.13,3.72-4.08,3.72"/>
			<path class="cls-1" d="m69.23,9.78l.13-.86c-.55.59-1.36,1.01-2.36,1.01-1.69,0-2.67-.87-2.36-2.9l.66-4.29h1.14l-.64,4.12c-.23,1.52.27,2.2,1.55,2.2,1.11,0,2.08-.66,2.32-2.2l.64-4.12h1.14l-1.09,7.04h-1.14Z"/>
			<path class="cls-1" d="m78.23,4.52c-.35-.59-1.06-1.06-2-1.06-1.33,0-2.14,1.01-2.43,2.9-.27,1.77.35,2.7,1.61,2.7.85,0,1.62-.4,2.28-1.02l.54-3.51Zm-.81,5.26l.13-.86c-.65.54-1.48,1.01-2.56,1.01-1.6,0-2.7-1.07-2.32-3.56.39-2.5,1.93-3.78,3.6-3.78,1.01,0,1.63.38,2.11.94l.46-2.96,1.23-.56-1.51,9.78h-1.14Z"/>
			<path class="cls-1" d="m58.25,38.79c-.48-.25-1.02-.4-2-.4-1.17,0-1.95.5-2.09,1.38-.16,1.05.42,1.5,1.4,1.5,1.04,0,1.89-.47,2.46-1.06l.22-1.42Zm-.49,3.15l.13-.86c-.65.54-1.51,1.01-2.65,1.01-1.25,0-2.47-.55-2.21-2.25.24-1.58,1.83-2.26,3.41-2.26.81,0,1.5.18,1.93.4l.13-.83c.16-1.05-.32-1.56-1.5-1.56-.84,0-1.56.2-2.26.54l-.3-.82c.75-.33,1.73-.56,2.77-.56,1.72,0,2.71.64,2.45,2.28l-.76,4.91h-1.14Z"/>
			<polygon class="cls-1" points="61.44 41.95 62.86 32.73 64.09 32.16 62.58 41.95 61.44 41.95"/>
			<polygon class="cls-1" points="65.23 41.95 66.66 32.73 67.89 32.16 66.38 41.95 65.23 41.95"/>
			<path class="cls-1" d="m70.91,33.64c-.47,0-.79-.32-.73-.71.06-.4.48-.72.95-.72.43,0,.74.32.68.72-.06.39-.48.71-.9.71m-1.88,8.31l1.09-7.04h1.14l-1.09,7.04h-1.14Z"/>
			<path class="cls-1" d="m77.82,38.79c-.48-.25-1.02-.4-2-.4-1.17,0-1.95.5-2.09,1.38-.16,1.05.42,1.5,1.4,1.5,1.04,0,1.89-.47,2.46-1.06l.22-1.42Zm-.49,3.15l.13-.86c-.65.54-1.51,1.01-2.65,1.01-1.25,0-2.47-.55-2.21-2.25.24-1.58,1.83-2.26,3.41-2.26.81,0,1.5.18,1.93.4l.13-.83c.16-1.05-.32-1.56-1.5-1.56-.84,0-1.55.2-2.26.54l-.3-.82c.75-.33,1.73-.56,2.77-.56,1.72,0,2.71.64,2.45,2.28l-.76,4.91h-1.14Z"/>
			<path class="cls-1" d="m85.94,41.95l.64-4.12c.23-1.51-.27-2.2-1.55-2.2-1.11,0-2.08.66-2.32,2.2l-.64,4.12h-1.14l1.09-7.04h1.14l-.13.86c.55-.59,1.36-1.01,2.36-1.01,1.69,0,2.67.87,2.36,2.9l-.66,4.29h-1.14Z"/>
			<path class="cls-1" d="m95.27,36.34c-.51-.46-1-.71-1.81-.71-1.25,0-2.36.99-2.63,2.75-.27,1.73.4,2.85,1.82,2.85.78,0,1.34-.28,1.96-.75l.59.65c-.76.6-1.6.98-2.73.98-1.75,0-3.18-1.18-2.81-3.64.4-2.6,2.34-3.7,4.02-3.7,1.08,0,1.85.35,2.4.83l-.8.75Z"/>
			<path class="cls-1" d="m100.63,35.63c-1.19,0-2.13.75-2.51,2.32h4.31c.12-1.37-.4-2.32-1.81-2.32m2.7,3.14h-5.33c-.12,1.5.54,2.46,1.85,2.46.93,0,1.51-.24,2.31-.67l.42.72c-1.04.54-1.79.82-2.99.82-1.46,0-3.1-.94-2.67-3.7.35-2.24,1.96-3.64,3.87-3.64,2.09,0,2.99,1.45,2.68,3.46-.04.24-.07.39-.13.55"/>
			<path class="cls-1" d="m66.65,25.14c-1.1,0-2-.36-2.68-.9l.78-.74c.56.5,1.27.78,2.06.78,1.1,0,1.68-.4,1.78-1.09.09-.58-.33-.9-1.67-1.44-1.51-.6-2.11-1.03-1.94-2.16.17-1.07,1.33-1.8,2.78-1.8,1.1,0,1.9.31,2.44.75l-.75.74c-.56-.43-1.05-.63-1.9-.63s-1.38.36-1.46.87c-.09.59.28.83,1.56,1.37,1.42.6,2.24.99,2.04,2.25-.21,1.38-1.66,1.99-3.05,1.99"/>
			<path class="cls-1" d="m75.23,18.67c-1.19,0-2.13.75-2.51,2.32h4.31c.12-1.37-.4-2.32-1.81-2.32m2.7,3.14h-5.33c-.12,1.5.53,2.46,1.84,2.46.93,0,1.52-.24,2.31-.67l.42.72c-1.04.54-1.79.82-2.99.82-1.46,0-3.1-.94-2.67-3.7.35-2.24,1.96-3.64,3.87-3.64,2.09,0,2.99,1.45,2.68,3.46-.04.24-.07.39-.13.55"/>
			<path class="cls-1" d="m85.32,19.38c-.51-.46-1-.71-1.81-.71-1.25,0-2.36.99-2.63,2.75-.27,1.73.4,2.85,1.82,2.85.78,0,1.34-.28,1.96-.75l.59.64c-.76.6-1.6.98-2.73.98-1.75,0-3.18-1.18-2.81-3.64.4-2.6,2.34-3.7,4.02-3.7,1.08,0,1.85.35,2.4.83l-.8.75Z"/>
			<path class="cls-1" d="m91.77,24.99l.13-.86c-.55.59-1.36,1.01-2.36,1.01-1.69,0-2.67-.87-2.36-2.9l.66-4.29h1.14l-.64,4.12c-.23,1.52.27,2.2,1.55,2.2,1.11,0,2.08-.66,2.32-2.2l.64-4.12h1.14l-1.09,7.04h-1.14Z"/>
			<path class="cls-1" d="m100.42,18.99c-.3-.16-.63-.27-1.16-.27-1.11,0-1.86.79-2.07,2.13l-.64,4.13h-1.14l1.09-7.04h1.14l-.13.87c.45-.56,1.29-1.02,2.14-1.02.59,0,.96.07,1.22.18l-.45,1.02Z"/>
			<path class="cls-1" d="m103.53,16.68c-.47,0-.79-.32-.73-.71.06-.4.48-.72.95-.72.43,0,.74.32.68.72-.06.39-.48.71-.9.71m-1.88,8.31l1.09-7.04h1.14l-1.09,7.04h-1.14Z"/>
			<path class="cls-1" d="m107.79,18.79l-.71,4.59c-.1.63.07.85.68.85.46,0,.77-.07,1.16-.2l-.21.87c-.47.16-.91.24-1.51.24-.99,0-1.46-.43-1.28-1.6l.73-4.75h-.99l.13-.84h.99l.34-2.17,1.23-.56-.42,2.74h1.98l-.13.84h-1.98Z"/>
			<polygon class="cls-1" points="112.56 27.47 111.42 27.47 112.91 24.91 111.14 17.94 112.34 17.94 113.5 23.06 113.67 23.78 114.05 23.07 116.81 17.94 118.01 17.94 112.56 27.47"/>
			<path class="cls-1" d="m.95,19.97c1.73-4.52,5.59-7.15,10.2-7.15,5.1,0,6.81,2.1,7.68,5.83l-5.51,1.95c-.47-1.84-1.01-3-2.91-3-1.51,0-2.62.91-3.35,2.37H.95Zm5.38,2.22c-.06.28-.11.56-.15.85-.45,3.03.21,5.43,2.7,5.43,1.81,0,2.72-.93,4.12-2.8l4.5,2.46c-1.78,2.6-4.46,5.12-9.38,5.12C1.95,33.25-.7,28.89.16,23.03c.04-.29.08-.57.14-.85h6.03Z"/>
			<path class="cls-1" d="m20.37,19.96c.01-.28.04-.58.09-.9.55-3.74,4.09-6.26,9.1-6.26,3.53,0,5.96.82,7.93,2.29l-3.42,4.3c-1.66-1.19-3.4-1.87-5.51-1.87-1.72,0-2.21.51-2.31,1.22-.08.53.26.86,1.42,1.22h-7.3Zm13.77,2.22c1.58,1.05,2.18,2.48,1.86,4.67-.67,4.53-4.53,6.4-9.51,6.4-3.35,0-6.43-1.05-8.39-2.4l3.42-4.3c1.37.99,3.86,1.98,5.79,1.98,2.05,0,2.75-.34,2.89-1.27.11-.74-.57-1.19-3.26-1.81-3.27-.75-5.32-1.57-6.14-3.25h13.35Z"/>
			<polyline class="cls-1" points="41.46 19.97 44.71 13.12 49.71 13.12 50.93 19.97"/>
			<polyline class="cls-1" points="43.93 25.08 46.89 25.08 46.57 22.18 51.33 22.18 53.26 32.94 47.91 32.94 47.45 29.46 42.1 29.46 40.62 32.94 35.31 32.94 40.42 22.18 45.16 22.18"/>
			<path class="cls-1" d="m108.44,33.72v1.07s.14,0,.3,0c.3,0,.5-.04.6-.12.1-.08.16-.22.16-.43,0-.35-.23-.53-.7-.53h-.36Zm1.28,2.82l-.82-1.38h-.46v1.38h-.46v-3.22h.82c.77,0,1.16.3,1.16.89,0,.41-.21.7-.62.88l.88,1.45h-.5Zm1.37-1.58c0-.6-.21-1.12-.64-1.54-.43-.43-.94-.64-1.54-.64s-1.12.21-1.55.64c-.43.43-.64.94-.64,1.54s.21,1.12.64,1.55c.43.43.94.64,1.55.64s1.12-.21,1.54-.64c.43-.43.64-.94.64-1.55m-4.8,0c0-.72.26-1.33.77-1.84.51-.51,1.13-.76,1.85-.76s1.34.25,1.85.76c.51.51.76,1.12.76,1.84s-.25,1.34-.76,1.85c-.51.51-1.12.77-1.85.77s-1.33-.26-1.85-.77c-.51-.51-.77-1.13-.77-1.85"/>
		</svg>
	</xsl:variable>

	<xsl:variable name="Image-Title">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAASEAAAEhCAYAAAAwHRYbAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3BpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDplYWRhN2RlNC04YzAyLTQ1N2UtYjUwNy0zNGYzY2RjNWE2ZGQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MDUyNzBENDc3NjVCMTFFQTlDMDhGMEI2ODhENjUxQkIiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MDUyNzBENDY3NjVCMTFFQTlDMDhGMEI2ODhENjUxQkIiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgSW5EZXNpZ24gMTQuMCAoTWFjaW50b3NoKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ1dWlkOmZiZjFiODZmLTIzMjMtM2U0OS1hMDMzLTVlOGQxYThlNmI1YiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmlkOjFlMzVjZTE3LWU5NzAtNDQ1OS05ZjI0LTM1NzcwZWYzMjNjMiIvPiA8L3Jk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</xsl:text>
	</xsl:variable>

	<!-- https://www.metanorma.org/ns/standoc -->
	<xsl:variable name="namespace_full" select="namespace-uri(//mn:metanorma[1])"/>

	<!-- https://www.metanorma.org/ns/xsl -->
	<xsl:variable name="namespace_mn_xsl">https://www.metanorma.org/ns/xslt</xsl:variable>

	<xsl:variable name="root_element">metanorma</xsl:variable>

	<!---examples: 2013, 2024 -->
	<xsl:variable name="document_scheme" select="normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'document-scheme']/mn:value)"/>

	<!-- external parameters -->
	<xsl:param name="svg_images"/> <!-- svg images array -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/> <!-- base path for images -->
	<xsl:param name="inputxml_basepath"/> <!-- input xml file path -->
	<xsl:param name="inputxml_filename"/> <!-- input xml file name -->
	<xsl:param name="output_path"/> <!-- output PDF file name -->
	<xsl:param name="outputpdf_basepath"/> <!-- output PDF folder -->
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:param name="syntax-highlight">false</xsl:param> <!-- syntax highlighting feature, default - off -->
	<xsl:param name="add_math_as_text">true</xsl:param> <!-- add math in text behind svg formula, to copy-paste formula from PDF as text -->

	<xsl:param name="table_if">false</xsl:param> <!-- generate extended table in IF for autolayout-algorithm -->
	<xsl:param name="table_widths"/> <!-- (debug: path to) xml with table's widths, generated on 1st pass, based on FOP Intermediate Format -->
	<!-- Example: <tables>
		<table page-width="509103" id="table1" width_max="223561" width_min="223560">
			<column width_max="39354" width_min="39354"/>
			<column width_max="75394" width_min="75394"/>
			<column width_max="108813" width_min="108813"/>
			<tbody>
				<tr>
					<td width_max="39354" width_min="39354">
						<p_len>39354</p_len>
						<word_len>39354</word_len>
					</td>
					
		OLD:
			<tables>
					<table id="table_if_tab-symdu" page-width="75"> - table id prefixed by 'table_if_' to simple search in IF 
						<tbody>
							<tr>
								<td id="tab-symdu_1_1">
									<p_len>6</p_len>
									<p_len>100</p_len>  for 2nd paragraph
									<word_len>6</word_len>
									<word_len>20</word_len>
								...
	-->

	<!-- for command line debug: <xsl:variable name="table_widths_from_if" select="document($table_widths)"/> -->
	<xsl:variable name="table_widths_from_if" select="xalan:nodeset($table_widths)"/>

	<xsl:variable name="table_widths_from_if_calculated_">
		<xsl:for-each select="$table_widths_from_if//table">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:call-template name="calculate-column-widths-autolayout-algorithm"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="table_widths_from_if_calculated" select="xalan:nodeset($table_widths_from_if_calculated_)"/>

	<xsl:param name="table_if_debug">false</xsl:param> <!-- set 'true' to put debug width data before table or dl -->

	<!-- for table auto-layout algorithm, see <xsl:template match="*[local-name()='table']" priority="2"> -->
	<xsl:param name="table_only_with_id"/> <!-- Example: 'table1' -->
	<xsl:param name="table_only_with_ids"/> <!-- Example: 'table1 table2 table3 ' -->

	<!-- don't remove and rename this variable, it's using in mn2pdf tool -->
	<xsl:variable name="isApplyAutolayoutAlgorithm_">true
	</xsl:variable>
	<xsl:variable name="isApplyAutolayoutAlgorithm" select="normalize-space($isApplyAutolayoutAlgorithm_)"/>

	<xsl:variable name="isGenerateTableIF"><xsl:value-of select="$table_if"/></xsl:variable>
	<!-- <xsl:variable name="isGenerateTableIF" select="normalize-space(normalize-space($table_if) = 'true' and 1 = 1)"/> -->

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<xsl:variable name="inputxml_filename_prefix">
		<xsl:choose>
			<xsl:when test="contains($inputxml_filename, '.presentation.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.presentation.xml')"/>
			</xsl:when>
			<xsl:when test="contains($inputxml_filename, '.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inputxml_filename"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Note 1: Each xslt has declated variable `namespace` that allows to set some properties, processing logic, etc. for concrete xslt.
	You can put such conditions by using xslt construction `xsl:if test="..."` or <xsl:choose><xsl:when test=""></xsl:when><xsl:otherwiste></xsl:otherwiste></xsl:choose>,
	BUT DON'T put any another conditions together with $namespace = '...' (such conditions will be ignored). For another conditions, please use nested xsl:if or xsl:choose -->

	<!-- Note 2: almost all localized string determined in the element //localized-strings in metanorma xml, but there are a few cases when:
	 - string didn't determined yet
	 - we need to put the string on two-languages (for instance, on English and French both), but xml contains only localized strings for one language
	 - there is a difference between localized string value and text that should be displayed in PDF
	-->
	<xsl:variable name="titles_">
		<!-- These titles of Table of contents renders different than determined in localized-strings -->
		<!-- <title-toc lang="en">
			<xsl:if test="$namespace = 'csd' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'unece-rec'">
				<xsl:text>Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper'">
				<xsl:text>Table of Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:text>Table of contents</xsl:text>
			</xsl:if>
		</title-toc> -->
		<title-toc lang="en">Table of contents</title-toc>
		<!-- <title-toc lang="fr">
			<xsl:text>Sommaire</xsl:text>
		</title-toc> -->
		<!-- <title-toc lang="zh">
			<xsl:choose>
				<xsl:when test="$namespace = 'gb'">
					<xsl:text>目次</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Contents</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</title-toc> -->
		<title-toc lang="zh">目次</title-toc>

		<title-part lang="en">
		</title-part>
		<title-part lang="fr">
		</title-part>
		<title-part lang="ru">
		</title-part>
		<title-part lang="zh">第 # 部分:</title-part>
	</xsl:variable>
	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>

	<xsl:variable name="ace_tag">ace-tag_</xsl:variable>

	<xsl:variable name="title-list-tables">
		<xsl:variable name="toc_table_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title"/>
		<xsl:value-of select="$toc_table_title"/>
		<xsl:if test="normalize-space($toc_table_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_tables</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-figures">
		<xsl:variable name="toc_figure_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title"/>
		<xsl:value-of select="$toc_figure_title"/>
		<xsl:if test="normalize-space($toc_figure_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_figures</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-recommendations">
		<xsl:variable name="toc_requirement_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='requirement']/mn:title"/>
		<xsl:value-of select="$toc_requirement_title"/>
		<xsl:if test="normalize-space($toc_requirement_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_recommendations</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//mn:metanorma/mn:bibdata"/>
		<xsl:copy-of select="//mn:metanorma/mn:localized-strings"/>
	</xsl:variable>

	<xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Characters -->
	<xsl:variable name="linebreak">&#8232;</xsl:variable>
	<xsl:variable name="tab_zh">　</xsl:variable>
	<xsl:variable name="non_breaking_hyphen">‑</xsl:variable>
	<xsl:variable name="thin_space"> </xsl:variable>
	<xsl:variable name="zero_width_space">​</xsl:variable>
	<xsl:variable name="hair_space"> </xsl:variable>
	<xsl:variable name="en_dash">–</xsl:variable>
	<xsl:variable name="em_dash">—</xsl:variable>
	<xsl:variable name="nonbreak_space_em_dash_space"> — </xsl:variable>
	<xsl:variable name="cr">&#13;</xsl:variable>
	<xsl:variable name="lf">
</xsl:variable>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>

	<!--
	<metanorma-extension>
		<presentation-metadata>
			<papersize>letter</papersize>
		</presentation-metadata>
	</metanorma-extension>
	-->

	<xsl:variable name="papersize" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:papersize)))"/>
	<xsl:variable name="papersize_width_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">215.9</xsl:when>
			<xsl:when test="$papersize = 'a4'">210</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_width" select="normalize-space($papersize_width_)"/>
	<xsl:variable name="papersize_height_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">279.4</xsl:when>
			<xsl:when test="$papersize = 'a4'">297</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_height" select="normalize-space($papersize_height_)"/>

	<!-- page width in mm -->
	<xsl:variable name="pageWidth_">
		<xsl:choose>
			<xsl:when test="$papersize_width != ''"><xsl:value-of select="$papersize_width"/></xsl:when>
			<xsl:otherwise>215.9
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageWidth" select="normalize-space($pageWidth_)"/>

	<!-- page height in mm -->
	<xsl:variable name="pageHeight_">
		<xsl:choose>
			<xsl:when test="$papersize_height != ''"><xsl:value-of select="$papersize_height"/></xsl:when>
			<xsl:otherwise>279.4
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageHeight" select="normalize-space($pageHeight_)"/>

	<!-- Page margins in mm (just digits, without 'mm')-->
	<!-- marginLeftRight1 and marginLeftRight2 - is left or right margin depends on odd/even page,
	for example, left margin on odd page and right margin on even page -->
	<xsl:variable name="marginLeftRight1_">25
	</xsl:variable>
	<xsl:variable name="marginLeftRight1" select="normalize-space($marginLeftRight1_)"/>

	<xsl:variable name="marginLeftRight2_">25
	</xsl:variable>
	<xsl:variable name="marginLeftRight2" select="normalize-space($marginLeftRight2_)"/>

	<xsl:variable name="marginTop_">25
	</xsl:variable>
	<xsl:variable name="marginTop" select="normalize-space($marginTop_)"/>

	<xsl:variable name="marginBottom_">21
	</xsl:variable>
	<xsl:variable name="marginBottom" select="normalize-space($marginBottom_)"/>

	<xsl:variable name="layout_columns_default">1</xsl:variable>
	<xsl:variable name="layout_columns_" select="normalize-space((//mn:metanorma)[1]/mn:metanorma-extension/mn:presentation-metadata/mn:layout-columns)"/>
	<xsl:variable name="layout_columns">
		<xsl:choose>
			<xsl:when test="$layout_columns_ != ''"><xsl:value-of select="$layout_columns_"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$layout_columns_default"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="font_noto_sans">Noto Sans, Noto Sans HK, Noto Sans JP, Noto Sans KR, Noto Sans SC, Noto Sans TC</xsl:variable>
	<xsl:variable name="font_noto_sans_mono">Noto Sans Mono, Noto Sans Mono CJK HK, Noto Sans Mono CJK JP, Noto Sans Mono CJK KR, Noto Sans Mono CJK SC, Noto Sans Mono CJK TC</xsl:variable>
	<xsl:variable name="font_noto_serif">Noto Serif, Noto Serif HK, Noto Serif JP, Noto Serif KR, Noto Serif SC, Noto Serif TC</xsl:variable>
	<xsl:attribute-set name="root-style">
		<xsl:attribute name="font-family">Azo Sans, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
		<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set> <!-- root-style -->

	<xsl:template name="insertRootStyle">
		<xsl:param name="root-style"/>
		<xsl:variable name="root-style_" select="xalan:nodeset($root-style)"/>

		<xsl:variable name="additional_fonts_">
			<xsl:for-each select="//mn:metanorma[1]/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'fonts']/mn:value |       //mn:metanorma[1]/mn:presentation-metadata[mn:name = 'fonts']/mn:value">
				<xsl:value-of select="."/><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="additional_fonts" select="normalize-space($additional_fonts_)"/>

		<xsl:variable name="font_family_generic" select="$root-style_/root-style/@font-family-generic"/>

		<xsl:for-each select="$root-style_/root-style/@*">

			<xsl:choose>
				<xsl:when test="local-name() = 'font-family-generic'"><!-- skip, it's using for determine 'sans' or 'serif' --></xsl:when>
				<xsl:when test="local-name() = 'font-family'">

					<xsl:variable name="font_regional_prefix">
						<xsl:choose>
							<xsl:when test="$font_family_generic = 'Sans'">Noto Sans</xsl:when>
							<xsl:otherwise>Noto Serif</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:attribute name="{local-name()}">

						<xsl:variable name="font_extended">
							<xsl:choose>
								<xsl:when test="$lang = 'zh'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'hk'"><xsl:value-of select="$font_regional_prefix"/> HK</xsl:when>
								<xsl:when test="$lang = 'jp'"><xsl:value-of select="$font_regional_prefix"/> JP</xsl:when>
								<xsl:when test="$lang = 'kr'"><xsl:value-of select="$font_regional_prefix"/> KR</xsl:when>
								<xsl:when test="$lang = 'sc'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'tc'"><xsl:value-of select="$font_regional_prefix"/> TC</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="normalize-space($font_extended) != ''">
							<xsl:value-of select="$font_regional_prefix"/><xsl:text>, </xsl:text>
							<xsl:value-of select="$font_extended"/><xsl:text>, </xsl:text>
						</xsl:if>

						<xsl:variable name="font_family" select="."/>

						<xsl:choose>
							<xsl:when test="$additional_fonts = ''">
								<xsl:value-of select="$font_family"/>
							</xsl:when>
							<xsl:otherwise> <!-- $additional_fonts != '' -->
								<xsl:choose>
									<xsl:when test="contains($font_family, ',')">
										<xsl:value-of select="substring-before($font_family, ',')"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
										<xsl:text>, </xsl:text><xsl:value-of select="substring-after($font_family, ',')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$font_family"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>

			<!-- <xsl:choose>
				<xsl:when test="local-name() = 'font-family'">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>, <xsl:value-of select="$additional_fonts"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:for-each>
	</xsl:template> <!-- insertRootStyle -->

	<!-- ===================================== -->
	<!-- Update xml -->
	<!-- ===================================== -->

	<xsl:template name="updateXML">
		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step1</xsl:message></xsl:if>
		<xsl:variable name="startTime1" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
		<xsl:variable name="updated_xml_step1">
			<xsl:if test="$table_if = 'false'">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="endTime1" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime1 - $startTime1"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step1</xsl:message>
			<!-- <redirect:write file="updated_xml_step1_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step1"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step2</xsl:message></xsl:if>
		<xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<xsl:variable name="updated_xml_step2">
			<xsl:if test="$table_if = 'false'">
				<xsl:copy-of select="$updated_xml_step1"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime2 - $startTime2"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step2</xsl:message>
			<!-- <redirect:write file="updated_xml_step2_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step2"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime3" select="java:getTime(java:java.util.Date.new())"/>

		<xsl:variable name="updated_xml_step3">
			<xsl:choose>
				<xsl:when test="$table_if = 'false'">
					<xsl:apply-templates select="xalan:nodeset($updated_xml_step2)" mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="endTime3" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime3 - $startTime3"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step3</xsl:message>
			<!-- <redirect:write file="updated_xml_step3_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step3"/>
			</redirect:write> -->
		</xsl:if>

		<!-- <xsl:if test="$debug = 'true'"><xsl:message>START copying updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime4" select="java:getTime(java:java.util.Date.new())"/>  -->
		<xsl:copy-of select="$updated_xml_step3"/>
		<!-- <xsl:variable name="endTime4" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime4 - $startTime4"/> msec.</xsl:message>
			<xsl:message>END copying updated_xml_step3</xsl:message>
		</xsl:if> -->

	</xsl:template>

	<!-- =========================================================================== -->
	<!-- STEP1:  -->
	<!--   - Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!--   - Put Section title in the correct position -->
	<!--   - Ignore 'span' without style -->
	<!--   - Remove semantic xml part -->
	<!--   - Remove image/emf (EMF vector image for Word) -->
	<!--   - add @id, redundant for table auto-layout algorithm -->
	<!--   - process 'passthrough' element -->
	<!--   - split math by element with @linebreak into maths -->
	<!--   - rename fmt-title to title, fmt-name to name and another changes to convert new presentation XML to  -->
	<!--   - old XML without significant changes in XSLT -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- change section's order based on @displayorder value -->
	<xsl:template match="mn:preface" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_preface_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

			<xsl:for-each select="*">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sections" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

			<!-- move section 'Normative references' inside 'sections' -->
			<xsl:for-each select="* |      ancestor::mn:metanorma/mn:bibliography/mn:references[@normative='true'] |     ancestor::mn:metanorma/mn:bibliography/mn:clause[mn:references[@normative='true']]">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:bibliography" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- copy all elements from bibliography except 'Normative references' (moved to 'sections') -->
			<xsl:for-each select="*[not(@normative='true') and not(*[@normative='true'])]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<!-- Example with 'class': <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@style or @class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear' or @class = 'fmt-hi' or @class = 'horizontal' or @class = 'norotate' or @class = 'halffontsize']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]/mn:span[@class] | mn:sourcecode//mn:span[@class]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- remove semantic xml -->
	<xsl:template match="mn:metanorma-extension/mn:metanorma/mn:source" mode="update_xml_step1"/>

	<!-- remove UnitML elements, big section especially in BIPM xml -->
	<xsl:template match="mn:metanorma-extension/*[local-name() = 'UnitsML']" mode="update_xml_step1"/>

	<!-- remove image/emf -->
	<xsl:template match="mn:image/mn:emf" mode="update_xml_step1"/>

	<!-- remove preprocess-xslt -->
	<xsl:template match="mn:preprocess-xslt" mode="update_xml_step1"/>

	<xsl:template match="mn:stem" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-stem" mode="update_xml_step1">
		<!-- <xsl:element name="stem" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="mn:semx and count(node()) = 1">
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="mn:semx/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:semx/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>

	<xsl:template match="mn:image[not(.//mn:passthrough)] |        mn:bibdata[not(.//mn:passthrough)] |        mn:localized-strings" mode="update_xml_step1">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<!-- mn:sourcecode[not(.//mn:passthrough) and not(.//mn:fmt-name)] -->
	<xsl:template match="mn:sourcecode" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:choose>
				<xsl:when test="mn:fmt-sourcecode">
					<xsl:choose>
						<xsl:when test="mn:fmt-sourcecode[not(.//mn:passthrough)] and not(.//mn:fmt-name)">
							<xsl:copy-of select="mn:fmt-sourcecode/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:fmt-sourcecode/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise> <!-- If fmt-sourcecode is not present -->
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//mn:fmt-name)">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<xsl:template match="mn:figure[mn:fmt-figure]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:apply-templates select="mn:fmt-figure/node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source" mode="update_xml_step1"/>
	<xsl:template match="mn:quote/mn:author" mode="update_xml_step1"/>
	<xsl:template match="mn:amend" mode="update_xml_step1"/>
	<!-- https://github.com/metanorma/isodoc/issues/687 -->
	<xsl:template match="mn:source" mode="update_xml_step1"/>

	<xsl:template match="mn:metanorma-extension/mn:attachment" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="1 = 2"> <!-- remove attachment/text(), because attachments added in the template 'addPDFUAmeta' before applying 'update_xml_step1' -->
				<xsl:variable name="name_filepath" select="concat($inputxml_basepath, @name)"/>
				<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($name_filepath)))"/>
				<xsl:if test="$file_exists = 'false'"> <!-- copy attachment content only if file on disk doesnt exist -->
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:if>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- add @id, mandatory for table auto-layout algorithm -->
	<xsl:template match="*[self::mn:dl or self::mn:table][not(@id)]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="add_id"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- prevent empty thead processing in XSL-FO, remove it -->
	<xsl:template match="mn:table/mn:thead[count(*) = 0]" mode="update_xml_step1"/>

	<xsl:template name="add_id">
		<xsl:if test="not(@id)">
			<!-- add @id - first element with @id plus '_element_name' -->
			<xsl:variable name="prefix_id_" select="(.//*[@id])[1]/@id"/>
			<xsl:variable name="prefix_id"><xsl:value-of select="$prefix_id_"/><xsl:if test="normalize-space($prefix_id_) = ''"><xsl:value-of select="generate-id()"/></xsl:if></xsl:variable>
			<xsl:variable name="document_suffix" select="ancestor::mn:metanorma/@document_suffix"/>
			<xsl:attribute name="id"><xsl:value-of select="concat($prefix_id, '_', local-name(), '_', $document_suffix)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- optimization: remove clause if table_only_with_id isn't empty and clause doesn't contain table or dl with table_only_with_id -->
	<xsl:template match="*[self::mn:clause or self::mn:p or self::mn:definitions or self::mn:annex]" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="($table_only_with_id != '' or $table_only_with_ids != '') and self::mn:p and (ancestor::*[self::mn:table or self::mn:dl or self::mn:toc])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_id != '' and not(.//*[self::mn:table or self::mn:dl][@id = $table_only_with_id])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_ids != '' and not(.//*[self::mn:table or self::mn:dl][contains($table_only_with_ids, concat(@id, ' '))])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
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

	<xsl:variable name="regex_passthrough">.*\bpdf\b.*</xsl:variable>
	<xsl:template match="mn:passthrough" mode="update_xml_step1">
		<!-- <xsl:if test="contains(@formats, ' pdf ')"> -->
		<xsl:if test="normalize-space(java:matches(java:java.lang.String.new(@formats), $regex_passthrough)) = 'true'">
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:if>
	</xsl:template>

	<!-- split math by element with @linebreak into maths -->
	<xsl:template match="mathml:math[.//mathml:mo[@linebreak] or .//mathml:mspace[@linebreak]]" mode="update_xml_step1">
		<xsl:variable name="maths">
			<xsl:apply-templates select="." mode="mathml_linebreak"/>
		</xsl:variable>
		<xsl:copy-of select="$maths"/>
	</xsl:template>

	<!-- update new Presentation XML -->
	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="update_xml_step1"/>
	<xsl:template match="mn:name[following-sibling::*[1][self::mn:fmt-name]]" mode="update_xml_step1"/>
	<xsl:template match="mn:section-title[following-sibling::*[1][self::mn:p][@type = 'section-title' or @type = 'floating-title']]" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:preferred[following-sibling::*[not(local-name() = 'preferred')][1][local-name() = 'fmt-preferred']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:preferred" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:admitted[following-sibling::*[not(local-name() = 'admitted')][1][local-name() = 'fmt-admitted']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:admitted" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:deprecates[following-sibling::*[not(local-name() = 'deprecates')][1][local-name() = 'fmt-deprecates']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:deprecates" mode="update_xml_step1"/>
	<xsl:template match="mn:related" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:definition[following-sibling::*[1][local-name() = 'fmt-definition']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:definition" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:termsource[following-sibling::*[1][local-name() = 'fmt-termsource']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:termsource" mode="update_xml_step1"/>

	<xsl:template match="mn:term[@unnumbered = 'true'][not(.//*[starts-with(local-name(), 'fmt-')])]" mode="update_xml_step1"/>

	<xsl:template match="mn:p[@type = 'section-title' or @type = 'floating-title'][preceding-sibling::*[1][self::mn:section-title]]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:copy-of select="preceding-sibling::*[1][self::mn:section-title]/@depth"/>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:fmt-title" mode="update_xml_step1">
		<!-- <xsl:element name="title" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="addNamedDestinationAttribute"/>

			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>

	<xsl:template name="addNamedDestinationAttribute">
	</xsl:template>

	<xsl:template match="mn:fmt-name" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'p' and ancestor::mn:table">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:element name="name" namespace="{$namespace_full}"> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:call-template name="addNamedDestinationAttribute"/>

					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
				<!-- </xsl:element> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- li/fmt-name -->
	<xsl:template match="mn:li/mn:fmt-name" priority="2" mode="update_xml_step1">
		<xsl:attribute name="label"><xsl:value-of select="."/></xsl:attribute>
		<xsl:attribute name="full">true</xsl:attribute>
	</xsl:template>

	<xsl:template match="mn:fmt-preferred[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-preferred[not(mn:p)] | mn:fmt-preferred/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-preferred" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:fmt-admitted[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-admitted[not(mn:p)] | mn:fmt-admitted/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-admitted" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:fmt-deprecates[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-deprecates[not(mn:p)] | mn:fmt-deprecates/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-deprecates" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<!-- <xsl:template match="mn:fmt-definition" mode="update_xml_step1">
		<xsl:element name="definition" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-termsource" mode="update_xml_step1">
		<xsl:element name="termsource" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-source" mode="update_xml_step1">
		<xsl:element name="source" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:span[                @class = 'fmt-caption-label' or                 @class = 'fmt-element-name' or                @class = 'fmt-caption-delim' or                @class = 'fmt-autonum-delim']" mode="update_xml_step1" priority="3">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label" mode="update_xml_step1"/>

	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:requirement/*[not(starts-with(local-name(), 'fmt-'))] |             mn:recommendation/*[not(starts-with(local-name(), 'fmt-'))] |              mn:permission/*[not(starts-with(local-name(), 'fmt-'))]" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-provision" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:identifier" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:fmt-identifier" mode="update_xml_step1">
		<xsl:element name="identifier" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:concept" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-concept" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:eref" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-eref" mode="update_xml_step1">
		<xsl:element name="eref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:xref" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-xref" mode="update_xml_step1">
		<xsl:element name="xref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:link" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-link" mode="update_xml_step1">
		<xsl:element name="link" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:origin" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-origin" mode="update_xml_step1">
		<xsl:element name="origin" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:erefstack" mode="update_xml_step1"/>

	<xsl:template match="mn:svgmap" mode="update_xml_step1"/>

	<xsl:template match="mn:annotation-container" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-identifier[not(ancestor::*[local-name() = 'bibdata'])]//text()" mode="update_xml_step1">
		<xsl:element name="{$element_name_keep-together_within-line}" namespace="{$namespace_full}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@semx-id | @anchor" mode="update_xml_step1"/>

	<!-- END: update new Presentation XML -->

	<!-- =========================================================================== -->
	<!-- END STEP1: update_xml_step1 -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step_move_pagebreak">
				<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<!-- replace 'pagebreak' by closing tags + page_sequence and  opening page_sequence + tags -->
	<xsl:template match="mn:pagebreak[not(following-sibling::*[1][self::mn:pagebreak])]" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top"/>
		<!-- <xsl:choose>
			<xsl:when test="ancestor::mn:sections">
			
			</xsl:when>
			<xsl:when test="ancestor::mn:annex">
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose> -->

		<!-- determine pagebreak is last element before </fo:flow> or not -->
		<xsl:variable name="isLast">
			<xsl:for-each select="ancestor-or-self::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
				<xsl:if test="following-sibling::*">false</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="contains($isLast, 'false')">

			<xsl:variable name="orientation" select="normalize-space(@orientation)"/>

			<xsl:variable name="tree_">
				<xsl:call-template name="makeAncestorsElementsTree">
					<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

			<!-- close fo:page-sequence (closing preceding fo elements) -->
			<xsl:call-template name="insertClosingElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

			<xsl:text disable-output-escaping="yes">&lt;/page_sequence&gt;</xsl:text>

			<!-- create a new page_sequence (opening elements) -->
			<xsl:text disable-output-escaping="yes">&lt;page_sequence xmlns="</xsl:text><xsl:value-of select="$namespace_full"/>"<xsl:if test="$orientation != ''"> orientation="<xsl:value-of select="$orientation"/>"</xsl:if><xsl:text disable-output-escaping="yes">&gt;</xsl:text>

			<xsl:call-template name="insertOpeningElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

		</xsl:if>
	</xsl:template>

	<xsl:template name="makeAncestorsElementsTree">
		<xsl:param name="page_sequence_at_top"/>

		<xsl:choose>
			<xsl:when test="$page_sequence_at_top = 'true'">
				<xsl:for-each select="ancestor::*[ancestor::mn:metanorma]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ancestor::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertClosingElements">
		<xsl:param name="tree"/>
		<xsl:for-each select="$tree//element">
			<xsl:sort data-type="number" order="descending" select="@pos"/>
			<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="."/>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;/<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertOpeningElements">
		<xsl:param name="tree"/>
		<xsl:param name="xmlns"/>
		<xsl:param name="add_continue">true</xsl:param>
		<xsl:for-each select="$tree//element">
			<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:value-of select="."/>
				<xsl:for-each select="@*[local-name() != 'pos']">
					<xsl:text> </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>="</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>"</xsl:text>
				</xsl:for-each>
				<xsl:if test="position() = 1 and $add_continue = 'true'"> continue="true"</xsl:if>
				<xsl:if test="position() = 1 and $xmlns != ''"> xmlns="<xsl:value-of select="$xmlns"/>"</xsl:if>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- move full page width figures, tables at top level -->
	<xsl:template match="*[self::mn:figure or self::mn:table][normalize-space(@width) != 'text-width']" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$layout_columns != 1">

				<xsl:variable name="tree_">
					<xsl:call-template name="makeAncestorsElementsTree">
						<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

				<xsl:call-template name="insertClosingElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:attribute name="top-level">true</xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:copy>

				<xsl:call-template name="insertOpeningElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =========================================================================== -->
	<!-- END STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
	<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY  -->
	<!-- =========================================================================== -->
	<!-- Example: <keep-together_within-line>ISO 10303-51</keep-together_within-line> -->
	<xsl:template match="@*|node()" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="express_reference_separators">_.\</xsl:variable>
	<xsl:variable name="express_reference_characters" select="concat($upper,$lower,'1234567890',$express_reference_separators)"/>
	<xsl:variable name="regex_express_reference">(^([A-Za-z0-9_.\\]+)$)</xsl:variable>

	<xsl:variable name="element_name_keep-together_within-line">keep-together_within-line</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_open">###<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_close">###/<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>

	<!-- \S matches any non-whitespace character (equivalent to [^\r\n\t\f\v ]) -->
	<!-- <xsl:variable name="regex_solidus_units">((\b((\S{1,3}\/\S+)|(\S+\/\S{1,3}))\b)|(\/\S{1,3})\b)</xsl:variable> -->
	<!-- add &lt; and &gt; to \S -->
	<xsl:variable name="regex_S">[^\r\n\t\f\v \&lt;&gt;\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_solidus_units">((\b((<xsl:value-of select="$regex_S"/>{1,3}\/<xsl:value-of select="$regex_S"/>+)|(<xsl:value-of select="$regex_S"/>+\/<xsl:value-of select="$regex_S"/>{1,3}))\b)|(\/<xsl:value-of select="$regex_S"/>{1,3})\b)</xsl:variable>

	<xsl:variable name="non_white_space">[^\s\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_dots_units">((\b((<xsl:value-of select="$non_white_space"/>{1,3}\.<xsl:value-of select="$non_white_space"/>+)|(<xsl:value-of select="$non_white_space"/>+\.<xsl:value-of select="$non_white_space"/>{1,3}))\b)|(\.<xsl:value-of select="$non_white_space"/>{1,3})\b)</xsl:variable>

	<xsl:template match="text()[not(ancestor::mn:bibdata or      ancestor::mn:fmt-link[not(contains(normalize-space(),' '))] or      ancestor::mn:sourcecode or      ancestor::*[local-name() = 'math'] or     ancestor::*[local-name() = 'svg'] or     ancestor::mn:name or ancestor::mn:fmt-name or     starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.') or normalize-space() = '' )]" name="keep_together_standard_number" mode="update_xml_enclose_keep-together_within-line">

		<xsl:variable name="parent" select="local-name(..)"/>

		<xsl:if test="1 = 2"> <!-- alternative variant -->

			<xsl:variable name="regexs">
				<!-- enclose standard's number into tag 'keep-together_within-line' -->
				<xsl:if test="not(ancestor::mn:table)"><regex><xsl:value-of select="$regex_standard_reference"/></regex></xsl:if>
				<!-- if EXPRESS reference -->
				<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
				<regex><xsl:value-of select="$regex_solidus_units"/></regex>
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:if test="ancestor::*[self::mn:td or self::mn:th]">
					<regex><xsl:value-of select="$regex_dots_units"/></regex>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="regex_replacement"><xsl:text>(</xsl:text>
				<xsl:for-each select="xalan:nodeset($regexs)/regex">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>

			<!-- regex_replacement='<xsl:value-of select="$regex_replacement"/>' -->

			<xsl:variable name="text_replaced" select="java:replaceAll(java:java.lang.String.new(.), $regex_replacement, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>

			<!-- text_replaced='<xsl:value-of select="$text_replaced"/>' -->

			<xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
				<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
				<xsl:with-param name="text" select="$text_replaced"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="1 = 1">

		<!-- enclose standard's number into tag 'keep-together_within-line' -->
		<xsl:variable name="text">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:choose>
					<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when> <!-- no need enclose standard's number into tag 'keep-together_within-line' in table cells -->
					<xsl:otherwise>
						<xsl:variable name="text_" select="java:replaceAll(java:java.lang.String.new(.), $regex_standard_reference, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
						<!-- <xsl:value-of select="$text__"/> -->

						<xsl:call-template name="replace_text_tags">
							<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text_"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="text2">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text)/*[local-name() = 'text']/node()"><xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
		<xsl:variable name="text3">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text2)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_units" select="java:replaceAll(java:java.lang.String.new(.),$regex_solidus_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_units">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_units"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_units)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:for-each select="xalan:nodeset($text3)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_dots" select="java:replaceAll(java:java.lang.String.new(.),$regex_dots_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_dots">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_dots"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_dots)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="xalan:nodeset($text3)/*[local-name() = 'text']/node()"/></xsl:otherwise>
		</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-stem | mn:image" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template name="replace_text_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>

				<xsl:element name="{substring-before(substring-after($tag_open, '###'),'###')}" namespace="{$namespace_full}">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</xsl:element>

				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ===================================== -->
	<!-- END XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- ===================================== -->

	<!-- Example:
	<metanorma>
		<preface>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</preface>
		<sections>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</sections>
		<page_sequence>
			<annex ..
		</page_sequence>
		<page_sequence>
			<annex ..
		</page_sequence>
	</metanorma>
	-->
	<xsl:template name="processPrefaceAndMainSectionsDefault_items">

		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>
				<xsl:call-template name="insertMainSectionsPageSequences"/>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>

		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsDefault_items -->

	<xsl:template name="insertPrefaceSectionsPageSequences">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertPrefaceSectionsPageSequences -->

	<xsl:template name="insertMainSectionsPageSequences">

		<xsl:call-template name="insertSectionsInPageSequence"/>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:for-each select="/*/mn:annex">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:for-each>
		</xsl:element>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
				<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |            /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertMainSectionsPageSequences -->

	<xsl:template name="insertSectionsInPageSequence">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="insertMainSectionsInSeparatePageSequences">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>

		<xsl:call-template name="insertAnnexAndBibliographyInSeparatePageSequences"/>

		<!-- <xsl:call-template name="insertBibliographyInSeparatePageSequences"/> -->

		<!-- <xsl:call-template name="insertIndexInSeparatePageSequences"/> -->
	</xsl:template> <!-- END: insertMainSectionsInSeparatePageSequences -->

	<xsl:template name="insertAnnexAndBibliographyInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex |           /*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]] |          /*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:choose>
				<xsl:when test="self::mn:annex or self::mn:indexsect">
					<xsl:element name="page_sequence" namespace="{$namespace_full}">
						<xsl:attribute name="main_page_sequence"/>
						<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise> <!-- bibliography -->
					<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:attribute name="main_page_sequence"/>
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertAnnexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="insertBibliographyInSeparatePageSequences">
		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="insertIndexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processAllSectionsDefault_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:call-template name="insertPrefaceSections"/>
					<xsl:call-template name="insertMainSections"/>
				</xsl:element>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_and_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		<!-- <xsl:message>updated_xml_step_move_pagebreak_filename=<xsl:value-of select="$updated_xml_step_move_pagebreak_filename"/></xsl:message>
		<xsl:message>start write updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		<!-- <xsl:message>end write updated_xml_step_move_pagebreak_filename</xsl:message> -->

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<!-- TODO: instead of 
		<xsl:for-each select=".//mn:page_sequence[normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<!-- <xsl:message>start delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
		<!-- <xsl:message>end delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
	</xsl:template> <!-- END: processAllSectionsDefault_items -->

	<xsl:template name="insertPrefaceSections">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="insertMainSections">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->

			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>

		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
		</xsl:for-each>

		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- boilerplate sections styles -->
	<xsl:attribute-set name="copyright-statement-style">
	</xsl:attribute-set> <!-- copyright-statement-style -->

	<xsl:attribute-set name="copyright-statement-title-style">
	</xsl:attribute-set> <!-- copyright-statement-title-style -->

	<xsl:attribute-set name="copyright-statement-p-style">
	</xsl:attribute-set> <!-- copyright-statement-p-style -->

		<xsl:attribute-set name="license-statement-style">
	</xsl:attribute-set> <!-- license-statement-style -->

	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- license-statement-title-style -->

	<xsl:attribute-set name="license-statement-p-style">
	</xsl:attribute-set> <!-- license-statement-p-style -->

	<xsl:attribute-set name="legal-statement-style">
	</xsl:attribute-set> <!-- legal-statement-style -->

	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- legal-statement-title-style -->

	<xsl:attribute-set name="legal-statement-p-style">
	</xsl:attribute-set> <!-- legal-statement-p-style -->

	<xsl:attribute-set name="feedback-statement-style">
	</xsl:attribute-set> <!-- feedback-statement-style -->

	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- feedback-statement-title-style -->

	<xsl:attribute-set name="feedback-statement-p-style">
	</xsl:attribute-set> <!-- feedback-statement-p-style -->

	<!-- End boilerplate sections styles -->

	<!-- ================================= -->
	<!-- Preface boilerplate sections processing -->
	<!-- ================================= -->
	<xsl:template match="mn:copyright-statement">
		<fo:block xsl:use-attribute-sets="copyright-statement-style" role="SKIP">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- copyright-statement -->

	<xsl:template match="mn:copyright-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>
	</xsl:template> <!-- copyright-statement//title -->

	<xsl:template match="mn:copyright-statement//mn:p">
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph"/>
	</xsl:template> <!-- copyright-statement//p -->

	<xsl:template match="mn:license-statement">
		<fo:block xsl:use-attribute-sets="license-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- license-statement -->

	<xsl:template match="mn:license-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>
	</xsl:template> <!-- license-statement/title -->

	<xsl:template match="mn:license-statement//mn:p">
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph"/>
	</xsl:template> <!-- license-statement/p -->

	<xsl:template match="mn:legal-statement">
		<xsl:param name="isLegacy">false</xsl:param>
		<fo:block xsl:use-attribute-sets="legal-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- legal-statement -->

	<xsl:template match="mn:legal-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>

	</xsl:template> <!-- legal-statement/title -->

	<xsl:template match="mn:legal-statement//mn:p">
		<xsl:param name="margin"/>
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph">
			<xsl:with-param name="margin" select="$margin"/>
		</xsl:call-template>
	</xsl:template> <!-- legal-statement/p -->

	<xsl:template match="mn:feedback-statement">
		<fo:block xsl:use-attribute-sets="feedback-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- feedback-statement -->

	<xsl:template match="mn:feedback-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>
	</xsl:template>

	<xsl:template match="mn:feedback-statement//mn:p">
		<xsl:param name="margin"/>
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph">
			<xsl:with-param name="margin" select="$margin"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================= -->
	<!-- END Preface boilerplate sections processing -->
	<!-- ================================= -->

	<xsl:attribute-set name="link-style">
		<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_link-style">
	</xsl:template> <!-- refine_link-style -->

	<xsl:template match="mn:fmt-link" name="link">
		<xsl:variable name="target_normalized" select="translate(@target, '\', '/')"/>
		<xsl:variable name="target_attachment_name" select="substring-after($target_normalized, '_attachments/')"/>
		<xsl:variable name="isLinkToEmbeddedFile" select="normalize-space(@attachment = 'true' and $pdfAttachmentsList//attachment[@filename = current()/@target])"/>
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<!-- link to the PDF attachment -->
				<xsl:when test="$isLinkToEmbeddedFile = 'true'">
					<xsl:variable name="target_file" select="java:org.metanorma.fop.Util.getFilenameFromPath(@target)"/>
					<xsl:value-of select="concat('url(embedded-file:', $target_file, ')')"/>
				</xsl:when>
				<!-- <xsl:when test="starts-with($target_normalized, '_') and contains($target_normalized, '_attachments/') and $pdfAttachmentsList//attachment[@filename = $target_attachment_name]">
					<xsl:value-of select="concat('url(embedded-file:', $target_attachment_name, ')')"/>
				</xsl:when>
				<xsl:when test="contains(@target, concat('_', $inputxml_filename_prefix, '_attachments'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="target__" select="substring-after($target_, concat('_', $inputxml_filename_prefix, '_attachments', '/'))"/>
					<xsl:value-of select="concat('url(embedded-file:', $target__, ')')"/>
				</xsl:when> -->

				<!-- <xsl:when test="not(starts-with(@target, 'http:') or starts-with(@target, 'https') or starts-with(@target, 'www') or starts-with(@target, 'mailto') or starts-with(@target, 'ftp'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="filename">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="value" select="$target_"/>
							<xsl:with-param name="delimiter" select="'/'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="target_filepath" select="concat($inputxml_basepath, @target)"/>
					<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($target_filepath)))"/>
					<xsl:choose>
						<xsl:when test="$file_exists = 'true'">
							<xsl:value-of select="concat('url(embedded-file:', $filename, ')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->

				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">

			<xsl:if test="starts-with(normalize-space(@target), 'mailto:') and not(ancestor::*[local-name() = 'td'])">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isLinkToEmbeddedFile = 'true'">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_link-style"/>

			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="alt_text">
						<xsl:call-template name="getAltText"/>
					</xsl:variable>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link external-destination="{$target}" fox:alt-text="{$alt_text}">
								<xsl:if test="$isLinkToEmbeddedFile = 'true'">
									<xsl:attribute name="role">Annot</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space(.) = ''">
										<xsl:call-template name="add-zero-spaces-link-java">
											<xsl:with-param name="text" select="$target_text"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<!-- output text from <link>text</link> -->
										<xsl:choose>
											<xsl:when test="starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.')">
												<xsl:call-template name="add-zero-spaces-link-java">
													<xsl:with-param name="text" select="."/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</fo:basic-link>
							<xsl:if test="$isLinkToEmbeddedFile = 'true'">
								<!-- reserve space at right for PaperClip icon -->
								<fo:inline keep-with-previous.within-line="always">        </fo:inline>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

	<xsl:attribute-set name="sourcecode-container-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>
		<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="line-height">113%</xsl:attribute>
	</xsl:attribute-set> <!-- sourcecode-style -->

	<xsl:template name="refine_sourcecode-style">
	</xsl:template> <!-- refine_sourcecode-style -->

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set> <!-- sourcecode-name-style -->

	<xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equals">(==========)</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equal">(=)</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equals,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equal,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add-zero-spaces-equal -->

	<!-- =============== -->
	<!-- sourcecode  -->
	<!-- =============== -->

	<xsl:variable name="source-highlighter-css_" select="//mn:metanorma/mn:metanorma-extension/mn:source-highlighter-css"/>
	<xsl:variable name="sourcecode_css_" select="java:org.metanorma.fop.Util.parseCSS($source-highlighter-css_)"/>
	<xsl:variable name="sourcecode_css" select="xalan:nodeset($sourcecode_css_)"/>

	<xsl:template match="*[local-name() = 'property']" mode="css">
		<xsl:attribute name="{@name}">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="get_sourcecode_attributes">
		<xsl:element name="sourcecode_attributes" use-attribute-sets="sourcecode-style">
			<xsl:variable name="_font-size">10<!-- inherit -->
			</xsl:variable>

			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::mn:note"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="$sourcecode_css//class[@name = 'sourcecode']" mode="css"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:sourcecode" name="sourcecode">

		<xsl:variable name="sourcecode_attributes">
			<xsl:call-template name="get_sourcecode_attributes"/>
		</xsl:variable>

    <!-- <xsl:copy-of select="$sourcecode_css"/> -->

		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true' and (ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])">
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
			</xsl:when>

			<xsl:otherwise>
				<fo:block-container xsl:use-attribute-sets="sourcecode-container-style" role="SKIP">

					<xsl:if test="not(ancestor::mn:li) or ancestor::mn:example">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::mn:example">
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>

					<xsl:copy-of select="@id"/>

					<xsl:if test="parent::mn:note">
						<xsl:attribute name="margin-left">
							<xsl:choose>
								<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:if>
					<fo:block-container margin-left="0mm" role="SKIP">

						<fo:block xsl:use-attribute-sets="sourcecode-style">

							<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
								<xsl:attribute name="{local-name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>

							<xsl:call-template name="refine_sourcecode-style"/>

							<!-- remove margin between rows in the table with sourcecode line numbers -->
							<xsl:if test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::mn:tr[1]/following-sibling::mn:tr">
								<xsl:attribute name="margin-top">0pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>

							<xsl:apply-templates select="node()[not(self::mn:fmt-name or self::mn:dl)]"/>
						</fo:block>

						<xsl:apply-templates select="mn:dl"/> <!-- Key table -->
						<xsl:apply-templates select="mn:fmt-name"/> <!-- show sourcecode's name AFTER content -->

					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:sourcecode/text() | mn:sourcecode//mn:span/text()" priority="2">
		<xsl:choose>
			<!-- disabled -->
			<xsl:when test="1 = 2 and normalize-space($syntax-highlight) = 'true' and normalize-space(../@lang) != ''"> <!-- condition for turn on of highlighting -->
				<xsl:variable name="syntax" select="java:org.metanorma.fop.Util.syntaxHighlight(., ../@lang)"/>
				<xsl:choose>
					<xsl:when test="normalize-space($syntax) != ''"><!-- if there is highlighted result -->
						<xsl:apply-templates select="xalan:nodeset($syntax)" mode="syntax_highlight"/> <!-- process span tags -->
					</xsl:when>
					<xsl:otherwise> <!-- if case of non-succesfull syntax highlight (for instance, unknown lang), process without highlighting -->
						<xsl:call-template name="add_spaces_to_sourcecode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- add sourcecode highlighting -->
	<xsl:template match="mn:sourcecode//mn:span[@class]" priority="2">
		<xsl:variable name="class" select="@class"/>

		<!-- Example: <1> -->
		<xsl:variable name="is_callout">
			<xsl:if test="parent::mn:dt">
				<xsl:variable name="dt_id" select="../@id"/>
				<xsl:if test="ancestor::mn:sourcecode//mn:callout[@target = $dt_id]">true</xsl:if>
			</xsl:if>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$sourcecode_css//class[@name = $class]">
				<fo:inline>
					<xsl:apply-templates select="$sourcecode_css//class[@name = $class]" mode="css"/>
					<xsl:if test="$is_callout = 'true'">&lt;</xsl:if>
					<xsl:apply-templates/>
					<xsl:if test="$is_callout = 'true'">&gt;</xsl:if>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- outer table with line numbers for sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] |  -->
		<fo:block>
			<fo:table width="100%" table-layout="fixed">
				<xsl:copy-of select="@id"/>
					<fo:table-column column-width="8%"/>
					<fo:table-column column-width="92%"/>
					<fo:table-body>
						<xsl:apply-templates/>
					</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table/mn:tbody" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']/*[local-name() = 'tbody'] |  -->
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']//*[local-name()='tr'] |  -->
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>
	<!-- first td with line numbers -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][not(preceding-sibling::*)]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block>

				<!-- set attibutes for line numbers - same as sourcecode -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:for-each select="following-sibling::*[local-name() = 'td']/mn:sourcecode">
						<xsl:call-template name="get_sourcecode_attributes"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*[not(starts-with(local-name(), 'margin-') or starts-with(local-name(), 'space-'))]">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>

				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- second td with sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][preceding-sibling::*]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- END outer table with line numbers for sourcecode -->

	<xsl:template name="add_spaces_to_sourcecode">
		<xsl:variable name="text_step1">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:variable name="text_step2">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$text_step1"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- <xsl:value-of select="$text_step2"/> -->

		<!-- add zero-width space after space -->
		<xsl:variable name="text_step3" select="java:replaceAll(java:java.lang.String.new($text_step2),' ',' ​')"/>

		<!-- split text by zero-width space -->
		<xsl:variable name="text_step4">
			<xsl:call-template name="split_for_interspers">
				<xsl:with-param name="pText" select="$text_step3"/>
				<xsl:with-param name="sep" select="$zero_width_space"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:for-each select="xalan:nodeset($text_step4)/node()">
			<xsl:choose>
				<xsl:when test="local-name() = 'interspers'"> <!-- word with length more than 30 will be interspersed with zero-width space -->
					<xsl:call-template name="interspers-java">
						<xsl:with-param name="str" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

	</xsl:template> <!-- add_spaces_to_sourcecode -->

	<xsl:variable name="interspers_tag_open">###interspers123###</xsl:variable>
	<xsl:variable name="interspers_tag_close">###/interspers123###</xsl:variable>
	<!-- split string by separator for interspers -->
	<xsl:template name="split_for_interspers">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<!-- word with length more than 30 will be interspersed with zero-width space -->
		<xsl:variable name="regex" select="concat('([^', $zero_width_space, ']{31,})')"/> <!-- sequence of characters (more 31), that doesn't contains zero-width space -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new($pText),$regex,concat($interspers_tag_open,'$1',$interspers_tag_close))"/>
		<xsl:call-template name="replace_tag_interspers">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template> <!-- end: split string by separator for interspers -->

	<xsl:template name="replace_tag_interspers">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $interspers_tag_open)">
				<xsl:value-of select="substring-before($text, $interspers_tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $interspers_tag_open)"/>
				<interspers>
					<xsl:value-of select="substring-before($text_after, $interspers_tag_close)"/>
				</interspers>
				<xsl:call-template name="replace_tag_interspers">
					<xsl:with-param name="text" select="substring-after($text_after, $interspers_tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="interspers-java">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($str),'([^ -.:=_—])',concat('$1', $char))"/> <!-- insert $char after each char excep space, - . : = _ etc. -->
	</xsl:template>

	<xsl:template match="*" mode="syntax_highlight">
		<xsl:apply-templates mode="syntax_highlight"/>
	</xsl:template>

	<xsl:variable name="syntax_highlight_styles_">
		<style class="hljs-addition" xsl:use-attribute-sets="hljs-addition"/>
		<style class="hljs-attr" xsl:use-attribute-sets="hljs-attr"/>
		<style class="hljs-attribute" xsl:use-attribute-sets="hljs-attribute"/>
		<style class="hljs-built_in" xsl:use-attribute-sets="hljs-built_in"/>
		<style class="hljs-bullet" xsl:use-attribute-sets="hljs-bullet"/>
		<style class="hljs-char_and_escape_" xsl:use-attribute-sets="hljs-char_and_escape_"/>
		<style class="hljs-code" xsl:use-attribute-sets="hljs-code"/>
		<style class="hljs-comment" xsl:use-attribute-sets="hljs-comment"/>
		<style class="hljs-deletion" xsl:use-attribute-sets="hljs-deletion"/>
		<style class="hljs-doctag" xsl:use-attribute-sets="hljs-doctag"/>
		<style class="hljs-emphasis" xsl:use-attribute-sets="hljs-emphasis"/>
		<style class="hljs-formula" xsl:use-attribute-sets="hljs-formula"/>
		<style class="hljs-keyword" xsl:use-attribute-sets="hljs-keyword"/>
		<style class="hljs-link" xsl:use-attribute-sets="hljs-link"/>
		<style class="hljs-literal" xsl:use-attribute-sets="hljs-literal"/>
		<style class="hljs-meta" xsl:use-attribute-sets="hljs-meta"/>
		<style class="hljs-meta_hljs-string" xsl:use-attribute-sets="hljs-meta_hljs-string"/>
		<style class="hljs-meta_hljs-keyword" xsl:use-attribute-sets="hljs-meta_hljs-keyword"/>
		<style class="hljs-name" xsl:use-attribute-sets="hljs-name"/>
		<style class="hljs-number" xsl:use-attribute-sets="hljs-number"/>
		<style class="hljs-operator" xsl:use-attribute-sets="hljs-operator"/>
		<style class="hljs-params" xsl:use-attribute-sets="hljs-params"/>
		<style class="hljs-property" xsl:use-attribute-sets="hljs-property"/>
		<style class="hljs-punctuation" xsl:use-attribute-sets="hljs-punctuation"/>
		<style class="hljs-quote" xsl:use-attribute-sets="hljs-quote"/>
		<style class="hljs-regexp" xsl:use-attribute-sets="hljs-regexp"/>
		<style class="hljs-section" xsl:use-attribute-sets="hljs-section"/>
		<style class="hljs-selector-attr" xsl:use-attribute-sets="hljs-selector-attr"/>
		<style class="hljs-selector-class" xsl:use-attribute-sets="hljs-selector-class"/>
		<style class="hljs-selector-id" xsl:use-attribute-sets="hljs-selector-id"/>
		<style class="hljs-selector-pseudo" xsl:use-attribute-sets="hljs-selector-pseudo"/>
		<style class="hljs-selector-tag" xsl:use-attribute-sets="hljs-selector-tag"/>
		<style class="hljs-string" xsl:use-attribute-sets="hljs-string"/>
		<style class="hljs-strong" xsl:use-attribute-sets="hljs-strong"/>
		<style class="hljs-subst" xsl:use-attribute-sets="hljs-subst"/>
		<style class="hljs-symbol" xsl:use-attribute-sets="hljs-symbol"/>
		<style class="hljs-tag" xsl:use-attribute-sets="hljs-tag"/>
		<!-- <style class="hljs-tag_hljs-attr" xsl:use-attribute-sets="hljs-tag_hljs-attr"></style> -->
		<!-- <style class="hljs-tag_hljs-name" xsl:use-attribute-sets="hljs-tag_hljs-name"></style> -->
		<style class="hljs-template-tag" xsl:use-attribute-sets="hljs-template-tag"/>
		<style class="hljs-template-variable" xsl:use-attribute-sets="hljs-template-variable"/>
		<style class="hljs-title" xsl:use-attribute-sets="hljs-title"/>
		<style class="hljs-title_and_class_" xsl:use-attribute-sets="hljs-title_and_class_"/>
		<style class="hljs-title_and_class__and_inherited__" xsl:use-attribute-sets="hljs-title_and_class__and_inherited__"/>
		<style class="hljs-title_and_function_" xsl:use-attribute-sets="hljs-title_and_function_"/>
		<style class="hljs-type" xsl:use-attribute-sets="hljs-type"/>
		<style class="hljs-variable" xsl:use-attribute-sets="hljs-variable"/>
		<style class="hljs-variable_and_language_" xsl:use-attribute-sets="hljs-variable_and_language_"/>
	</xsl:variable>
	<xsl:variable name="syntax_highlight_styles" select="xalan:nodeset($syntax_highlight_styles_)"/>

	<xsl:template match="span" mode="syntax_highlight" priority="2">
		<!-- <fo:inline color="green" font-style="italic"><xsl:apply-templates mode="syntax_highlight"/></fo:inline> -->
		<fo:inline>
			<xsl:variable name="classes_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@class"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
				<!-- a few classes together (_and_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-char') and contains(@class, 'escape_')">
					<item>hljs-char_and_escape_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_')">
					<item>hljs-title_and_class_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_') and contains(@class, 'inherited__')">
					<item>hljs-title_and_class__and_inherited__</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'function_')">
					<item>hljs-title_and_function_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-variable') and contains(@class, 'language_')">
					<item>hljs-variable_and_language_</item>
				</xsl:if>
				<!-- with parent classes (_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-keyword') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-keyword</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-string') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-string</item>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="classes" select="xalan:nodeset($classes_)"/>

			<xsl:for-each select="$classes/*[local-name() = 'item']">
				<xsl:variable name="class_name" select="."/>
				<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
					<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
				</xsl:for-each>
			</xsl:for-each>

			<!-- <xsl:variable name="class_name">
				<xsl:choose>
					<xsl:when test="@class = 'hljs-attr' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-attr</xsl:when>
					<xsl:when test="@class = 'hljs-name' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-name</xsl:when>
					<xsl:when test="@class = 'hljs-string' and ancestor::*/@class = 'hljs-meta'">hljs-meta_hljs-string</xsl:when>
					<xsl:otherwise><xsl:value-of select="@class"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
				<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each> -->

		<xsl:apply-templates mode="syntax_highlight"/></fo:inline>
	</xsl:template>

	<xsl:template match="text()" mode="syntax_highlight" priority="2">
		<xsl:call-template name="add_spaces_to_sourcecode"/>
	</xsl:template>

	<!-- end mode="syntax_highlight" -->

	<xsl:template match="mn:sourcecode/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- =============== -->
	<!-- END sourcecode  -->
	<!-- =============== -->

	<xsl:template match="mn:callout">
		<xsl:choose>
			<xsl:when test="normalize-space(@target) = ''">&lt;<xsl:apply-templates/>&gt;</xsl:when>
			<xsl:otherwise><fo:basic-link internal-destination="{@target}" fox:alt-text="{normalize-space()}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:callout-annotation">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}" white-space="nowrap">
			<fo:inline>
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:callout-annotation/mn:p">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<xsl:call-template name="setNamedDestination"/>
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::mn:p)"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- pre, strong, em, underline -->

	<!-- ========================= -->
	<!-- Rich text formatting -->
	<!-- ========================= -->

	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="line-height">113%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="tt-style">
		<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="add-style">
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<!-- <xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:variable name="add-style">
			<add-style xsl:use-attribute-sets="add-style"/>
		</xsl:variable>
	<xsl:template name="append_add-style">
		<xsl:copy-of select="xalan:nodeset($add-style)/add-style/@*"/>
	</xsl:template>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="mn:br">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

		<xsl:template match="mn:em">
		<fo:inline font-style="italic">
			<xsl:call-template name="refine_italic_style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_italic_style">
	</xsl:template>

	<xsl:template match="mn:strong | *[local-name()='b']">
		<xsl:param name="split_keep-within-line"/>
		<fo:inline font-weight="bold">

			<xsl:call-template name="refine_strong_style"/>

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_strong_style">
		<xsl:if test="ancestor::*['preferred']">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}"> </fo:inline>
	</xsl:template>

	<xsl:template match="mn:sup">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:sub">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:tt">
		<fo:inline xsl:use-attribute-sets="tt-style">

			<xsl:variable name="_font-size">10 <!-- inherit -->
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::mn:note or ancestor::mn:example"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template> <!-- tt -->

	<xsl:variable name="regex_url_start">^(http://|https://|www\.)?(.*)</xsl:variable>
	<xsl:template match="mn:tt/text()" priority="2">
		<xsl:choose>
			<xsl:when test="java:replaceAll(java:java.lang.String.new(.), $regex_url_start, '$2') != ''">
				 <!-- url -->
				<xsl:call-template name="add-zero-spaces-link-java"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:underline">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ================= -->
	<!-- Added,deleted text -->
	<!-- ================= -->
	<xsl:template match="mn:add | mn:change-open-tag | mn:change-close-tag" name="tag_add">
		<xsl:param name="skip">true</xsl:param>
		<xsl:param name="block">false</xsl:param>
		<xsl:param name="type"/>
		<xsl:param name="text-align"/>
		<xsl:choose>
			<xsl:when test="starts-with(., $ace_tag) or self::mn:change-open-tag or self::mn:change-close-tag"> <!-- examples: ace-tag_A1_start, ace-tag_A2_end, C1_start, AC_start, or
							<change-open-tag>A<sub>1</sub></change-open-tag>, <change-close-tag>A<sub>1</sub></change-close-tag> -->
				<xsl:choose>
					<xsl:when test="$skip = 'true' and       ((local-name(../..) = 'note' and not(preceding-sibling::node())) or       (parent::mn:fmt-title and preceding-sibling::node()[1][self::mn:tab]) or      local-name(..) = 'formattedref' and not(preceding-sibling::node()))      and       ../node()[last()][self::mn:add][starts-with(text(), $ace_tag)]"><!-- start tag displayed in template name="note" and title --></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="tag">
							<xsl:call-template name="insertTag">
								<xsl:with-param name="type">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag">start</xsl:when>
										<xsl:when test="self::mn:change-close-tag">end</xsl:when>
										<xsl:when test="$type = ''"><xsl:value-of select="substring-after(substring-after(., $ace_tag), '_')"/> <!-- start or end --></xsl:when>
										<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="kind">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 1, 1)"/> <!-- A or C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="mn:sub"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 2)"/> <!-- 1, 2, C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$block = 'false'">
								<fo:inline>
									<xsl:copy-of select="$tag"/>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:block> <!-- for around figures -->
									<xsl:if test="$text-align != ''">
										<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
									</xsl:if>
									<xsl:copy-of select="$tag"/>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add -->

	<xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20"/>
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-10%"><!-- alignment-baseline="middle" -->
				<xsl:attribute name="height">3.5mm</xsl:attribute> <!-- 5mm -->
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<!-- <svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg> -->
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,2.5 {$maxwidth},2.5 {$maxwidth + 20},40 {$maxwidth},77.5 0,77.5" stroke="black" stroke-width="5" fill="white"/>
						<line x1="9.5" y1="0" x2="9.5" y2="80" stroke="black" stroke-width="19"/>
					</g>
					<xsl:variable name="text_x">
						<xsl:choose>
							<xsl:when test="$type = 'closing' or $type = 'end'">28</xsl:when>
							<xsl:otherwise>22</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<text font-family="Arial" x="{$text_x}" y="50" font-size="40pt">
						<xsl:value-of select="$kind"/>
					</text>
					<text font-family="Arial" x="{$text_x + 33}" y="65" font-size="38pt">
						<xsl:value-of select="$value"/>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template match="mn:del">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ================= -->
	<!-- END Added,deleted text -->
	<!-- ================= -->

	<!-- highlight text -->
	<xsl:template match="mn:hi | mn:span[@class = 'fmt-hi']" priority="3">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="text()[ancestor::mn:smallcap]" name="smallcaps">
		<xsl:param name="txt"/>
		<!-- <xsl:variable name="text" select="normalize-space(.)"/> --> <!-- https://github.com/metanorma/metanorma-iso/issues/1115 -->
		<xsl:variable name="text">
			<xsl:choose>
				<xsl:when test="$txt != ''">
					<xsl:value-of select="$txt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ratio_">0.75
		</xsl:variable>
		<xsl:variable name="ratio" select="number(normalize-space($ratio_))"/>
		<fo:inline font-size="{$ratio * 100}%" role="SKIP">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:variable name="smallCapsText">
						<xsl:call-template name="recursiveSmallCaps">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ratio" select="$ratio"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- merge neighboring fo:inline -->
					<xsl:for-each select="xalan:nodeset($smallCapsText)/node()">
						<xsl:choose>
							<xsl:when test="self::fo:inline and preceding-sibling::node()[1][self::fo:inline]"><!-- <xsl:copy-of select="."/> --></xsl:when>
							<xsl:when test="self::fo:inline and @font-size">
								<xsl:variable name="curr_pos" select="count(preceding-sibling::node()) + 1"/>
								<!-- <curr_pos><xsl:value-of select="$curr_pos"/></curr_pos> -->
								<xsl:variable name="next_text_" select="count(following-sibling::node()[not(local-name() = 'inline')][1]/preceding-sibling::node())"/>
								<xsl:variable name="next_text">
									<xsl:choose>
										<xsl:when test="$next_text_ = 0">99999999</xsl:when>
										<xsl:otherwise><xsl:value-of select="$next_text_ + 1"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- <next_text><xsl:value-of select="$next_text"/></next_text> -->
								<fo:inline>
									<xsl:copy-of select="@*"/>
									<xsl:copy-of select="./node()"/>
									<xsl:for-each select="following-sibling::node()[position() &lt; $next_text - $curr_pos]"> <!-- [self::fo:inline] -->
										<xsl:copy-of select="./node()"/>
									</xsl:for-each>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</fo:inline>
	</xsl:template>

	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:param name="ratio">0.75</xsl:param>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div $ratio}%" role="SKIP">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
        <xsl:with-param name="ratio" select="$ratio"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

	<xsl:template match="mn:strike">
		<fo:inline text-decoration="line-through">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- Example: <span style="font-family:&quot;Noto Sans JP&quot;">styled text</span> -->
	<xsl:template match="mn:span[@style]" priority="2">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value_" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:variable name="value">
					<xsl:choose>
						<!-- if font-size is digits only -->
						<xsl:when test="$key = 'font-size' and translate($value_, '0123456789', '') = ''"><xsl:value-of select="$value_"/>pt</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value_"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$key = 'font-family' or $key = 'font-size' or $key = 'color' or $key = 'baseline-shift'">
					<style name="{$key}"><xsl:value-of select="$value"/></style>
				</xsl:if>
				<xsl:if test="$key = 'text-indent'">
					<style name="padding-left"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:choose>
			<xsl:when test="$styles/style">
				<fo:inline>
					<xsl:for-each select="$styles/style">
						<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- END: span[@style] -->

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Don't break standard's numbers -->
	<!-- Example : <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::mn:table"><xsl:apply-templates/></xsl:when>
			<xsl:when test="following-sibling::*[2][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']">
				<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()[not(ancestor::mn:table) and preceding-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear'] and   following-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']]" priority="2">
		<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:span[contains(@style, 'text-transform:none')]//text()" priority="5">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:pre" name="pre">
		<fo:block xsl:use-attribute-sets="pre-style">
			<xsl:copy-of select="@id"/>
			<xsl:choose>

				<xsl:when test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::*[local-name() = 'td'][1][not(preceding-sibling::*)]"> <!-- pre in the first td in the table with @linenums = 'true' -->
					<xsl:if test="ancestor::mn:tr[1]/following-sibling::mn:tr"> <!-- is current tr isn't last -->
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<fo:instream-foreign-object fox:alt-text="{.}" content-width="95%">
						<math xmlns="http://www.w3.org/1998/Math/MathML">
							<mtext><xsl:value-of select="."/></mtext>
						</math>
					</fo:instream-foreign-object>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>

			</xsl:choose>
		</fo:block>
	</xsl:template> <!-- pre -->

	<!-- ========================= -->
	<!-- END Rich text formatting -->
	<!-- ========================= -->

	<xsl:attribute-set name="permission-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-name-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-label-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-label-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="subject-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="inherit-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="description-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="specification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="measurement-target-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="verification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="import-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="component-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-name-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-label-style">
	</xsl:attribute-set>

	<!-- ========== -->
	<!-- permission -->
	<!-- ========== -->
	<xsl:template match="mn:permission">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:permission/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:permission/mn:label">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement -->
	<!-- ========== -->
	<xsl:template match="mn:requirement">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="mn:label"/>
			<xsl:apply-templates select="@obligation"/>
			<xsl:apply-templates select="mn:subject"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:label) and not(self::mn:subject)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">

			<fo:block xsl:use-attribute-sets="requirement-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:label">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/@obligation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:subject" priority="2">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="mn:recommendation">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:recommendation/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">

			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:recommendation/mn:label">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END recommendation -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- ========== -->

	<xsl:template match="mn:subject">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:div">
		<fo:block><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="mn:inherit | mn:component[@class = 'inherit'] |           mn:div[@type = 'requirement-inherit'] |           mn:div[@type = 'recommendation-inherit'] |           mn:div[@type = 'permission-inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:description | mn:component[@class = 'description'] |           mn:div[@type = 'requirement-description'] |           mn:div[@type = 'recommendation-description'] |           mn:div[@type = 'permission-description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:specification | mn:component[@class = 'specification'] |           mn:div[@type = 'requirement-specification'] |           mn:div[@type = 'recommendation-specification'] |           mn:div[@type = 'permission-specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:measurement-target | mn:component[@class = 'measurement-target'] |           mn:div[@type = 'requirement-measurement-target'] |           mn:div[@type = 'recommendation-measurement-target'] |           mn:div[@type = 'permission-measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:verification | mn:component[@class = 'verification'] |           mn:div[@type = 'requirement-verification'] |           mn:div[@type = 'recommendation-verification'] |           mn:div[@type = 'permission-verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:import | mn:component[@class = 'import'] |           mn:div[@type = 'requirement-import'] |           mn:div[@type = 'recommendation-import'] |           mn:div[@type = 'permission-import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:div[starts-with(@type, 'requirement-component')] |           mn:div[starts-with(@type, 'recommendation-component')] |           mn:div[starts-with(@type, 'permission-component')]">
		<fo:block xsl:use-attribute-sets="component-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END  -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement, recommendation, permission table -->
	<!-- ========== -->
	<xsl:template match="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt" role="SKIP">
			<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setNamedDestination"/>
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">
						<xsl:call-template name="getSimpleTable">
							<xsl:with-param name="id" select="@id"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//mn:tr[1]/mn:td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//mn:fn">
					<xsl:for-each select="mn:tbody">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="table_fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name()='thead']" mode="requirement">
		<fo:table-header>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="requirement">
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">

			<xsl:if test="parent::*[local-name()='thead'] or starts-with(*[local-name()='td' or local-name()='th'][1], 'Requirement ') or starts-with(*[local-name()='td' or local-name()='th'][1], 'Recommendation ')">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="mn:p[@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p2'][ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END requirement, recommendation, permission table -->
	<!-- ========== -->

	<xsl:attribute-set name="term-style">
	</xsl:attribute-set> <!-- term-style -->

	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- term-name-style -->

		<xsl:attribute-set name="preferred-block-style">
	</xsl:attribute-set> <!-- preferred-block-style -->

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="line-height">1</xsl:attribute>
	</xsl:attribute-set> <!-- preferred-term-style -->

	<xsl:attribute-set name="domain-style">
	</xsl:attribute-set> <!-- domain-style -->

	<xsl:attribute-set name="admitted-style">
	</xsl:attribute-set> <!-- admitted-style -->

	<xsl:attribute-set name="deprecates-style">
	</xsl:attribute-set> <!-- deprecates-style -->

	<xsl:attribute-set name="related-block-style" use-attribute-sets="preferred-block-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="definition-style">
		<xsl:attribute name="space-after">6pt</xsl:attribute>
	</xsl:attribute-set> <!-- definition-style -->

	<xsl:attribute-set name="termsource-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set> <!-- termsource-style -->

	<xsl:template name="refine_termsource-style">
	</xsl:template> <!-- refine_termsource-style -->

	<xsl:attribute-set name="termsource-text-style">
	</xsl:attribute-set> <!-- termsource-text-style -->

	<xsl:attribute-set name="origin-style">
		<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set> <!-- origin-style -->

	<!-- ====== -->
	<!-- term      -->
	<!-- ====== -->

	<xsl:template match="mn:terms">
		<!-- <xsl:message>'terms' <xsl:number/> processing...</xsl:message> -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:term">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">

			<xsl:if test="parent::mn:term and not(preceding-sibling::mn:term)">
			</xsl:if>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:term/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates />
			</fo:inline> -->
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- termsource -->
	<!-- origin -->
	<!-- modification -->
	<!-- ====== -->
	<xsl:template match="mn:fmt-termsource" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">

			<xsl:call-template name="refine_termsource-style"/>

			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			<xsl:copy-of select="$termsource_text"/>
			<!-- <xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>{</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>[</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>}</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>]</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose> -->
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource/text()[starts-with(., '[SOURCE: Adapted from: ') or     starts-with(., '[SOURCE: Quoted from: ') or     starts-with(., '[SOURCE: Modified from: ')]" priority="2">
		<xsl:text>[</xsl:text><xsl:value-of select="substring-after(., '[SOURCE: ')"/>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<!-- text SOURCE: -->
	<xsl:template match="mn:fmt-termsource/mn:strong[1][following-sibling::*[1][self::mn:fmt-origin]]/text()">
		<fo:inline xsl:use-attribute-sets="termsource-text-style">
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-origin">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:if test="normalize-space(@citeas) = ''">
						<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
					</xsl:if>
					<fo:inline xsl:use-attribute-sets="origin-style">
						<xsl:apply-templates/>
					</fo:inline>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- not using, see https://github.com/glossarist/iev-document/issues/23 -->
	<xsl:template match="mn:modification">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">modified</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="text"><xsl:apply-templates/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text>—</xsl:text></xsl:if></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text> — </xsl:text></xsl:if></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:modification/mn:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:modification/text()">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:value-of select="."/> -->
			<xsl:call-template name="text"/>
		</xsl:if>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- Preferred, admitted, deprecated -->
	<xsl:template match="mn:fmt-preferred">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>

		</xsl:variable>
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block font-size="{normalize-space($font-size)}" role="H{$levelTerm}" xsl:use-attribute-sets="preferred-block-style">

			<xsl:if test="parent::mn:term and not(preceding-sibling::mn:fmt-preferred)"> <!-- if first preffered in term, then display term's name -->

				<fo:block xsl:use-attribute-sets="term-name-style" role="SKIP">

					<xsl:for-each select="ancestor::mn:term[1]/mn:fmt-name"><!-- change context -->
						<xsl:call-template name="setIDforNamedDestination"/>
					</xsl:for-each>

					<xsl:apply-templates select="ancestor::mn:term[1]/mn:fmt-name"/>
				</fo:block>
			</xsl:if>

			<fo:block xsl:use-attribute-sets="preferred-term-style" role="SKIP">
				<xsl:call-template name="setStyle_preferred"/>

				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- <xsl:template match="mn:domain"> -->
		<!-- https://github.com/metanorma/isodoc/issues/607 
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text> -->
		<!-- <xsl:if test="not(@hidden = 'true')">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template> -->

	<!-- https://github.com/metanorma/isodoc/issues/632#issuecomment-2567163931 -->
	<xsl:template match="mn:domain"/>

	<xsl:template match="mn:fmt-admitted">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-deprecates">
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="setStyle_preferred">
		<xsl:if test="mn:strong">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- regarding ISO 10241-1:2011,  If there is more than one preferred term, each preferred term follows the previous one on a new line. -->
	<!-- in metanorma xml preferred terms delimited by semicolons -->
	<xsl:template match="mn:fmt-preferred/text()[contains(., ';')] | mn:fmt-preferred/mn:strong/text()[contains(., ';')]">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), ';', $linebreak)"/>
	</xsl:template>
	<!--  End Preferred, admitted, deprecated -->

	<xsl:template match="mn:fmt-related">
		<fo:block role="SKIP" xsl:use-attribute-sets="related-block-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:fmt-related/mn:p" priority="4">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="mn:fmt-definition">
		<fo:block xsl:use-attribute-sets="definition-style" role="SKIP">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-definition[preceding-sibling::mn:domain]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mn:fmt-definition[preceding-sibling::mn:domain]/mn:p[1]">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block/>
	</xsl:template>
	<!-- ========== -->
	<!-- END definition -->
	<!-- ========== -->

	<xsl:template match="mn:definitions">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:attribute-set name="termexample-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- termexample-style -->

	<xsl:template name="refine_termexample-style">
	</xsl:template> <!-- refine_termexample-style -->

	<xsl:attribute-set name="termexample-name-style">
		<xsl:attribute name="padding-right">10mm</xsl:attribute>
	</xsl:attribute-set> <!-- termexample-name-style -->

	<xsl:template name="refine_termexample-name-style">
	</xsl:template>

	<xsl:attribute-set name="example-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set> <!-- example-style -->

	<xsl:template name="refine_example-style">
	</xsl:template> <!-- refine_example-style -->

	<xsl:attribute-set name="example-body-style">
		<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
		<xsl:attribute name="margin-right">12.5mm</xsl:attribute>
	</xsl:attribute-set> <!-- example-body-style -->

	<xsl:attribute-set name="example-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:template name="refine_example-name-style">
	</xsl:template>

	<xsl:attribute-set name="example-p-style">
		<xsl:attribute name="margin-bottom">14pt</xsl:attribute>

	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:template name="refine_example-p-style">
	</xsl:template> <!-- refine_example-p-style -->

	<!-- ====== -->
	<!-- termexample -->
	<!-- ====== -->
	<xsl:template match="mn:termexample">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">
			<xsl:call-template name="refine_termexample-style"/>
			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:termexample/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:call-template name="refine_termexample-name-style"/>
				<xsl:apply-templates/> <!-- commented $namespace = 'ieee', https://github.com/metanorma/isodoc/issues/614-->
			</fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termexample/mn:p">
		<xsl:variable name="element">inline

		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">

					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- example -->
	<!-- ====== -->

	<!-- There are a few cases:
	1. EXAMPLE text
	2. EXAMPLE
	        text
	3. EXAMPLE text line 1
	     text line 2
	4. EXAMPLE
	     text line 1
			 text line 2
	-->
	<xsl:template match="mn:example" name="example">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_example-style"/>

			<xsl:variable name="fo_element">
				<xsl:if test=".//mn:table or .//mn:dl or *[not(self::mn:fmt-name)][1][self::mn:sourcecode]">block</xsl:if>block
			</xsl:variable>

			<fo:block-container margin-left="0mm" role="SKIP">

				<xsl:choose>

					<xsl:when test="contains(normalize-space($fo_element), 'block')">

						<!-- display name 'EXAMPLE' in a separate block  -->
						<fo:block>
							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
						</fo:block>

						<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
							<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
								<xsl:variable name="example_body">
									<xsl:apply-templates select="node()[not(self::mn:fmt-name)]">
										<xsl:with-param name="fo_element" select="$fo_element"/>
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
					</xsl:when> <!-- end block -->

					<xsl:when test="contains(normalize-space($fo_element), 'list')">

						<xsl:variable name="provisional_distance_between_starts_">7
						</xsl:variable>
						<xsl:variable name="provisional_distance_between_starts" select="normalize-space($provisional_distance_between_starts_)"/>
						<xsl:variable name="indent_">0
						</xsl:variable>
						<xsl:variable name="indent" select="normalize-space($indent_)"/>

						<fo:list-block provisional-distance-between-starts="{$provisional_distance_between_starts}mm">
							<fo:list-item>
								<fo:list-item-label start-indent="{$indent}mm" end-indent="label-end()">
									<fo:block>
										<xsl:apply-templates select="mn:fmt-name">
											<xsl:with-param name="fo_element">block</xsl:with-param>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:apply-templates select="node()[not(self::mn:fmt-name)]">
											<xsl:with-param name="fo_element" select="$fo_element"/>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</xsl:when> <!-- end list -->

					<xsl:otherwise> <!-- inline -->

						<!-- display 'EXAMPLE' and first element in the same line -->
						<fo:block>
							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
							<fo:inline>
								<xsl:apply-templates select="*[not(self::mn:fmt-name)][1]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>

						<xsl:if test="*[not(self::mn:fmt-name)][position() &gt; 1]">
							<!-- display further elements in blocks -->
							<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
								<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
									<xsl:apply-templates select="*[not(self::mn:fmt-name)][position() &gt; 1]">
										<xsl:with-param name="fo_element" select="'block'"/>
									</xsl:apply-templates>
								</fo:block-container>
							</fo:block-container>
						</xsl:if>
					</xsl:otherwise> <!-- end inline -->

				</xsl:choose>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<!-- example/name -->
	<xsl:template match="mn:example/mn:fmt-name">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:choose>
			<xsl:when test="ancestor::mn:appendix">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($fo_element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:call-template name="refine_example-name-style"/>
					<xsl:apply-templates/> <!-- $namespace = 'ieee', see https://github.com/metanorma/isodoc/issues/614  -->
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- table/example/name, table/tfoot//example/name -->
	<xsl:template match="mn:table/mn:example/mn:fmt-name |  mn:table/mn:tfoot//mn:example/mn:fmt-name">
		<fo:inline xsl:use-attribute-sets="example-name-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:example/mn:p">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			<xsl:value-of select="$fo_element"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space($element), 'block')">
				<fo:block-container role="SKIP">
					<xsl:if test="ancestor::mn:li and contains(normalize-space($fo_element), 'block')">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="example-p-style">

						<xsl:call-template name="refine_example-p-style"/>

						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="starts-with(normalize-space($element), 'list')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- example/p -->

	<!-- ====== -->
	<!-- ====== -->

	<!-- ========================== -->
	<!-- Table styles -->
	<!-- ========================== -->
	<xsl:variable name="table-border_">
	</xsl:variable>
	<xsl:variable name="table-border" select="normalize-space($table-border_)"/>

	<xsl:variable name="table-cell-border_">
	</xsl:variable>
	<xsl:variable name="table-cell-border" select="normalize-space($table-cell-border_)"/>

	<xsl:attribute-set name="table-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
	</xsl:attribute-set> <!-- table-container-style -->

	<xsl:template name="refine_table-container-style">
		<xsl:param name="margin-side"/>
		<xsl:attribute name="margin-left"><xsl:value-of select="-$margin-side"/>mm</xsl:attribute>
		<xsl:attribute name="margin-right"><xsl:value-of select="-$margin-side"/>mm</xsl:attribute>
		<!-- end table block-container attributes -->
	</xsl:template> <!-- refine_table-container-style -->

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
	</xsl:attribute-set><!-- table-style -->

	<xsl:template name="refine_table-style">
		<xsl:param name="margin-side"/>
		<xsl:if test="$margin-side != 0">
			<xsl:attribute name="margin-left"><xsl:value-of select="$margin-side"/>mm</xsl:attribute>
			<xsl:attribute name="margin-right"><xsl:value-of select="$margin-side"/>mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-style -->

	<xsl:attribute-set name="table-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- table-name-style -->

	<xsl:template name="refine_table-name-style">
		<xsl:param name="continued"/>
		<xsl:if test="$continued = 'true'">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_table-name-style -->

	<xsl:attribute-set name="table-row-style">
		<xsl:attribute name="min-height">4mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-header-row-style" use-attribute-sets="table-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_table-header-row-style">

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-header-row-style -->

	<xsl:attribute-set name="table-footer-row-style" use-attribute-sets="table-row-style">
	</xsl:attribute-set>

	<xsl:template name="refine_table-footer-row-style">
	</xsl:template> <!-- refine_table-footer-row-style -->

	<xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:template name="refine_table-body-row-style">

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-body-row-style -->

	<xsl:attribute-set name="table-header-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set> <!-- table-header-cell-style -->

	<xsl:template name="refine_table-header-cell-style">

		<xsl:call-template name="setBordersTableArray"/>

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setTableCellAttributes"/>
	</xsl:template> <!-- refine_table-header-cell-style -->

	<xsl:attribute-set name="table-cell-style">
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
	</xsl:attribute-set> <!-- table-cell-style -->

	<xsl:template name="refine_table-cell-style">

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setBordersTableArray"/>

	</xsl:template> <!-- refine_table-cell-style -->

	<xsl:attribute-set name="table-footer-cell-style">
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
	</xsl:attribute-set> <!-- table-footer-cell-style -->

	<xsl:template name="refine_table-footer-cell-style">
	</xsl:template> <!-- refine_table-footer-cell-style -->

	<xsl:attribute-set name="table-note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set><!-- table-note-style -->

	<xsl:template name="refine_table-note-style">
	</xsl:template> <!-- refine_table-note-style -->

	<xsl:attribute-set name="table-fn-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- table-fn-style -->

	<xsl:template name="refine_table-fn-style">
	</xsl:template>

	<xsl:attribute-set name="table-fn-number-style">
		<!-- <xsl:attribute name="padding-right">5mm</xsl:attribute> -->
	</xsl:attribute-set> <!-- table-fn-number-style -->

	<xsl:attribute-set name="table-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
	</xsl:attribute-set> <!-- table-fmt-fn-label-style -->

	<xsl:template name="refine_table-fmt-fn-label-style">
	</xsl:template>

	<xsl:attribute-set name="fn-container-body-style">
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-fn-body-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-fn-number-style">
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- figure-fn-number-style -->

	<xsl:attribute-set name="figure-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- figure-fmt-fn-label-style -->

	<xsl:template name="refine_figure-fmt-fn-label-style">
	</xsl:template>

	<xsl:attribute-set name="figure-fn-body-style">
		<xsl:attribute name="text-align">justify</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- ========================== -->
	<!-- END Table styles -->
	<!-- ========================== -->

	<xsl:template match="*[local-name()='table']" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="table"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='table']" name="table">

		<xsl:variable name="table-preamble">
		</xsl:variable>

		<xsl:variable name="table">

			<xsl:variable name="simple-table">
				<xsl:if test="$isGenerateTableIF = 'true' and $isApplyAutolayoutAlgorithm = 'true'">
					<xsl:call-template name="getSimpleTable">
						<xsl:with-param name="id" select="@id"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>

			<xsl:if test="$debug = 'true' and normalize-space($simple-table) != ''">
				<!-- <redirect:write file="simple-table_{@id}.xml">
					<xsl:copy-of select="$simple-table"/>
				</redirect:write> -->
			</xsl:if>
			<!-- <xsl:variable name="simple-table" select="xalan:nodeset($simple-table_)"/> -->

			<!-- simple-table=<xsl:copy-of select="$simple-table"/> -->

			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->
			<xsl:apply-templates select="mn:fmt-name"/> <!-- table's title rendered before table -->

			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/mn:tr[1]/mn:td)"/>

			<xsl:variable name="colwidths">
				<xsl:if test="not(mn:colgroup/mn:col) and not(@class = 'dl')">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- <xsl:variable name="colwidths" select="xalan:nodeset($colwidths_)"/> -->

			<!-- DEBUG -->
			<xsl:if test="$table_if_debug = 'true'">
				<fo:block font-size="60%">
					<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
				</fo:block>
			</xsl:if>

			<!-- <xsl:copy-of select="$colwidths"/> -->

			<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
			DEBUG
			colwidths=<xsl:copy-of select="$colwidths"/>
		<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

			<xsl:variable name="margin-side">
				<xsl:choose>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">0</xsl:when>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'">0</xsl:when>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="setNamedDestination"/>

			<fo:block-container xsl:use-attribute-sets="table-container-style" role="SKIP">

				<xsl:for-each select="mn:fmt-name">
					<xsl:call-template name="setIDforNamedDestination"/>
				</xsl:for-each>

				<xsl:call-template name="refine_table-container-style">
					<xsl:with-param name="margin-side" select="$margin-side"/>
				</xsl:call-template>

				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->

				<xsl:variable name="table_width_default">100%</xsl:variable>
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) --><xsl:value-of select="$table_width_default"/>
				</xsl:variable>

				<xsl:variable name="table_attributes">

					<xsl:element name="table_attributes" use-attribute-sets="table-style">

						<xsl:if test="$margin-side != 0">
							<xsl:attribute name="margin-left">0mm</xsl:attribute>
							<xsl:attribute name="margin-right">0mm</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></xsl:attribute>

						<xsl:call-template name="refine_table-style">
							<xsl:with-param name="margin-side" select="$margin-side"/>
						</xsl:call-template>

						<xsl:call-template name="setTableStyles">
							<xsl:with-param name="scope">table</xsl:with-param>
						</xsl:call-template>

					</xsl:element>
				</xsl:variable>

				<xsl:if test="$isGenerateTableIF = 'true'">
					<!-- to determine start of table -->
					<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
				</xsl:if>

				<fo:table id="{@id}">

					<xsl:if test="$isGenerateTableIF = 'true'">
						<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
					</xsl:if>

					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:attribute name="{local-name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>

					<xsl:variable name="isNoteOrFnExist" select="./mn:note[not(@type = 'units')] or ./mn:example or .//mn:fn[not(parent::mn:fmt-name)] or ./mn:fmt-source"/>
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<!-- <xsl:choose>
							<xsl:when test="$namespace = 'plateau'"></xsl:when>
							<xsl:otherwise>
								
							</xsl:otherwise>
						</xsl:choose> -->
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute><!-- set 0pt border, because there is a separete table below for footer -->
					</xsl:if>

					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<!-- generate IF for table widths -->
							<!-- example:
								<tr>
									<td valign="top" align="left" id="tab-symdu_1_1">
										<p>Symbol</p>
										<word id="tab-symdu_1_1_word_1">Symbol</word>
									</td>
									<td valign="top" align="left" id="tab-symdu_1_2">
										<p>Description</p>
										<word id="tab-symdu_1_2_word_1">Description</word>
									</td>
								</tr>
							-->
							<!-- <debug-simple-table><xsl:copy-of select="$simple-table"/></debug-simple-table> -->

							<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if"/>

						</xsl:when>
						<xsl:otherwise>

							<xsl:choose>
								<xsl:when test="mn:colgroup/mn:col">
									<xsl:for-each select="mn:colgroup/mn:col">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="@class = 'dl'">
									<xsl:for-each select=".//*[local-name()='tr'][1]/*">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="insertTableColumnWidth">
										<xsl:with-param name="colwidths" select="$colwidths"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:choose>
								<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
									<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:note) and not(self::mn:example) and not(self::mn:dl) and not(self::mn:fmt-source) and not(self::mn:p)          and not(self::mn:thead) and not(self::mn:tfoot) and not(self::mn:fmt-footnote-container)]"/> <!-- process all table' elements, except name, header, footer, note, source and dl which render separaterely -->
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>

				</fo:table>

				<xsl:variable name="colgroup" select="mn:colgroup"/>

				<!-- https://github.com/metanorma/metanorma-plateau/issues/171 -->

				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>
						<xsl:with-param name="colgroup" select="$colgroup"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- https://github.com/metanorma/metanorma-plateau/issues/171
				<xsl:if test="$namespace = 'plateau'">
					<xsl:apply-templates select="*[not(local-name()='thead') and not(local-name()='tbody') and not(local-name()='tfoot') and not(local-name()='name')]" />
					<xsl:for-each select="*[local-name()='tbody']"> - select context to tbody -
						<xsl:variable name="table_fn_block">
							<xsl:call-template name="table_fn_display" />
						</xsl:variable>
						<xsl:copy-of select="$table_fn_block"/>
					</xsl:for-each>
				</xsl:if> -->

				<xsl:if test="*[local-name()='bookmark']"> <!-- special case: table/bookmark -->
					<fo:block keep-with-previous="always" line-height="0.1">
						<xsl:for-each select="*[local-name()='bookmark']">
							<xsl:call-template name="bookmark"/>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</xsl:variable> <!-- END: variable name="table" -->

		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<xsl:choose>
			<xsl:when test="@width and @width != 'full-page-width' and @width != 'text-width'">

				<!-- centered table when table name is centered (see table-name-style) -->
				<fo:table table-layout="fixed" width="100%" xsl:use-attribute-sets="table-container-style" role="SKIP">
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-column column-width="{@width}"/>
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<fo:table-cell column-number="2" role="SKIP">
								<xsl:copy-of select="$table-preamble"/>
								<fo:block role="SKIP">
									<xsl:call-template name="setTrackChangesStyles">
										<xsl:with-param name="isAdded" select="$isAdded"/>
										<xsl:with-param name="isDeleted" select="$isDeleted"/>
									</xsl:call-template>
									<xsl:copy-of select="$table"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>

			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="setBordersTableArray">
	</xsl:template>

	<!-- table/name-->
	<xsl:template match="*[local-name()='table']/mn:fmt-name">
		<xsl:param name="continued"/>
		<xsl:param name="cols-count"/>
		<xsl:if test="normalize-space() != ''">

			<fo:block xsl:use-attribute-sets="table-name-style">

				<xsl:call-template name="refine_table-name-style">
					<xsl:with-param name="continued" select="$continued"/>
				</xsl:call-template>

				<xsl:choose>
					<xsl:when test="$continued = 'true'">
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>

			</fo:block>

			<!-- <xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'iso'"> -->
			<xsl:if test="$continued = 'true'">

				<!-- to prevent the error 'THead element may contain only TR elements' -->

				<xsl:choose>
					<xsl:when test="string(number($cols-count)) != 'NaN'">
						<fo:table width="100%" table-layout="fixed" role="SKIP">
							<fo:table-body role="SKIP">
								<fo:table-row>
									<fo:table-cell role="TH" number-columns-spanned="{$cols-count}">
										<fo:block text-align="right" role="SKIP">
											<xsl:apply-templates select="../mn:note[@type = 'units']/node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:when>
					<xsl:otherwise>
						<fo:block text-align="right">
							<xsl:apply-templates select="../mn:note[@type = 'units']/node()"/>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:if>
			<!-- </xsl:if> -->

		</xsl:if>
	</xsl:template> <!-- table/name -->

	<!-- workaround solution for https://github.com/metanorma/metanorma-iso/issues/1151#issuecomment-2033087938 -->
	<xsl:template match="*[local-name()='table']/mn:note[@type = 'units']/mn:p/text()" priority="4">
		<xsl:choose>
			<xsl:when test="preceding-sibling::mn:br">
				<!-- remove CR or LF at start -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'^(&#13;&#10;|&#13;|&#10;)', '')"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name()='table']/mn:fmt-source" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>

	<xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template>

	<xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:call-template name="get-calculated-column-widths-autolayout-algorithm"/>
			</xsl:when>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'"/>
			<xsl:otherwise>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================== -->
	<!-- Calculate column's width based on text string max widths -->
	<!-- ================================================== -->
	<xsl:template name="calculate-column-widths-proportional">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>

		<!-- table=<xsl:copy-of select="$table"/> -->

		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>

						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- <curr_col><xsl:value-of select="$curr-col"/></curr_col> -->

						<!-- <table><xsl:copy-of select="$table"/></table>
						 -->
						<xsl:for-each select="xalan:nodeset($table)/*/*[local-name()='tr']">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="*[local-name()='td'][$curr-col]" mode="td_text"/>
							</xsl:variable>
							<!-- <td_text><xsl:value-of select="$td_text"/></td_text> -->
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:message>string_with_added_zerospaces=<xsl:value-of select="$string_with_added_zerospaces"/></xsl:message> -->
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
								</xsl:call-template>
							</xsl:variable>
							<!-- words=<xsl:copy-of select="$words"/> -->
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<!-- <xsl:message>max_length=<xsl:value-of select="$max_length"/></xsl:message> -->
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="*[local-name()='td'][$curr-col]/@divide">
											<xsl:value-of select="*[local-name()='td'][$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>

						</xsl:for-each>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- widths=<xsl:copy-of select="$widths"/> -->

			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths-proportional">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- calculate-column-widths-proportional -->

	<!-- ================================= -->
	<!-- mode="td_text" -->
	<!-- ================================= -->
	<!-- replace each each char to 'X', just to process the tag 'keep-together_within-line' as whole word in longest word calculation -->
	<xsl:template match="*[@keep-together.within-line or local-name() = 'keep-together_within-line']/text()" priority="2" mode="td_text">
		<!-- <xsl:message>DEBUG t1=<xsl:value-of select="."/></xsl:message>
		<xsl:message>DEBUG t2=<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/></xsl:message> -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/>

		<!-- if all capitals english letters or digits -->
		<xsl:if test="normalize-space(translate(., concat($upper,'0123456789'), '')) = ''">
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="'X'"/>
				<xsl:with-param name="count" select="string-length(normalize-space(.)) * 0.5"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="td_text">
		<xsl:value-of select="translate(., $zero_width_space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource" mode="td_text">
		<xsl:value-of select="mn:fmt-origin/@citeas"/>
	</xsl:template>

	<xsl:template match="mn:fmt-link" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template>

	<xsl:template match="*[local-name()='math']" mode="td_text" name="math_length">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<xsl:variable name="mathml_">
				<xsl:for-each select="*">
					<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="mathml" select="xalan:nodeset($mathml_)"/>

			<xsl:variable name="math_text">
				<xsl:value-of select="normalize-space($mathml)"/>
				<xsl:for-each select="$mathml//@open"><xsl:value-of select="."/></xsl:for-each>
				<xsl:for-each select="$mathml//@close"><xsl:value-of select="."/></xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
		</xsl:if>
	</xsl:template>
	<!-- ================================= -->
	<!-- END mode="td_text" -->
	<!-- ================================= -->
	<!-- ================================================== -->
	<!-- END Calculate column's width based on text string max widths -->
	<!-- ================================================== -->

	<!-- ================================================== -->
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- (https://www.w3.org/TR/REC-html40/appendix/notes.html#h-B.5.2) -->
	<!-- ================================================== -->

	<!-- INPUT: table with columns widths, generated by table_if.xsl  -->
	<xsl:template name="calculate-column-widths-autolayout-algorithm">
		<xsl:param name="parent_table_page-width"/> <!-- for nested tables, in re-calculate step -->

		<!-- via intermediate format -->

		<!-- The algorithm uses two passes through the table data and scales linearly with the size of the table -->

		<!-- In the first pass, line wrapping is disabled, and the user agent keeps track of the minimum and maximum width of each cell. -->

		<!-- Since line wrap has been disabled, paragraphs are treated as long lines unless broken by BR elements. -->

		<xsl:variable name="page_width">
			<xsl:choose>
				<xsl:when test="$parent_table_page-width != ''">
					<xsl:value-of select="$parent_table_page-width"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@page-width"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$table_if_debug = 'true'">
			<page_width><xsl:value-of select="$page_width"/></page_width>
		</xsl:if>

		<!-- There are three cases: -->
		<xsl:choose>
			<!-- 1. The minimum table width is equal to or wider than the available space -->
			<xsl:when test="@width_min &gt;= $page_width and 1 = 2"> <!-- this condition isn't working see case 3 below -->
				<!-- call old algorithm -->
				<case1/>
				<!-- <xsl:variable name="cols-count" select="count(xalan:nodeset($table)/*/tr[1]/td)"/>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template> -->
			</xsl:when>
			<!-- 2. The maximum table width fits within the available space. In this case, set the columns to their maximum widths. -->
			<xsl:when test="@width_max &lt;= $page_width">
				<case2/>
				<autolayout/>
				<xsl:for-each select="column/@width_max">
					<column divider="100"><xsl:value-of select="."/></column>
				</xsl:for-each>
			</xsl:when>
			<!-- 3. The maximum width of the table is greater than the available space, but the minimum table width is smaller. 
			In this case, find the difference between the available space and the minimum table width, lets call it W. 
			Lets also call D the difference between maximum and minimum width of the table. 
			For each column, let d be the difference between maximum and minimum width of that column. 
			Now set the column's width to the minimum width plus d times W over D. 
			This makes columns with large differences between minimum and maximum widths wider than columns with smaller differences. -->
			<xsl:when test="(@width_max &gt; $page_width and @width_min &lt; $page_width) or (@width_min &gt;= $page_width)">
				<!-- difference between the available space and the minimum table width -->
				<_width_min><xsl:value-of select="@width_min"/></_width_min>
				<xsl:variable name="W" select="$page_width - @width_min"/>
				<W><xsl:value-of select="$W"/></W>
				<!-- difference between maximum and minimum width of the table -->
				<xsl:variable name="D" select="@width_max - @width_min"/>
				<D><xsl:value-of select="$D"/></D>
				<case3/>
				<autolayout/>
				<xsl:if test="@width_min &gt;= $page_width">
					<split_keep-within-line>true</split_keep-within-line>
				</xsl:if>
				<xsl:for-each select="column">
					<!-- difference between maximum and minimum width of that column.  -->
					<xsl:variable name="d" select="@width_max - @width_min"/>
					<d><xsl:value-of select="$d"/></d>
					<width_min><xsl:value-of select="@width_min"/></width_min>
					<e><xsl:value-of select="$d * $W div $D"/></e>
					<!-- set the column's width to the minimum width plus d times W over D.  -->
					<xsl:variable name="column_width_" select="round(@width_min + $d * $W div $D)"/> <!--  * 10 -->
					<xsl:variable name="column_width" select="$column_width_*($column_width_ &gt;= 0) - $column_width_*($column_width_ &lt; 0)"/> <!-- absolute value -->
					<column divider="100">
						<xsl:value-of select="$column_width"/>
					</column>
				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise><unknown_case/></xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- calculate-column-widths-autolayout-algorithm -->

	<xsl:template name="get-calculated-column-widths-autolayout-algorithm">

		<!-- if nested 'dl' or 'table' -->
		<xsl:variable name="parent_table_id" select="normalize-space(ancestor::*[local-name() = 'table' or local-name() = 'dl'][1]/@id)"/>
		<parent_table_id><xsl:value-of select="$parent_table_id"/></parent_table_id>

		<parent_element><xsl:value-of select="local-name(..)"/></parent_element>

		<ancestor_tree>
			<xsl:for-each select="ancestor::*">
				<ancestor><xsl:value-of select="local-name()"/></ancestor>
			</xsl:for-each>
		</ancestor_tree>

		<xsl:variable name="parent_table_page-width_">
			<xsl:if test="$parent_table_id != ''">
				<!-- determine column number in the parent table -->
				<xsl:variable name="parent_table_column_number">
					<xsl:choose>
						<!-- <xsl:when test="parent::mn:dd">2</xsl:when> -->
						<xsl:when test="(ancestor::*[local-name() = 'dd' or local-name() = 'table' or local-name() = 'dl'])[last()][local-name() = 'dd' or local-name() = 'dl']">2</xsl:when>
						<xsl:otherwise> <!-- parent is table -->
							<xsl:value-of select="count(ancestor::*[local-name() = 'td'][1]/preceding-sibling::*[local-name() = 'td']) + 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- find table by id in the file 'table_widths' and get all Nth `<column>...</column> -->

				<xsl:variable name="parent_table_column_" select="$table_widths_from_if_calculated//table[@id = $parent_table_id]/column[number($parent_table_column_number)]"/>
				<xsl:variable name="parent_table_column" select="xalan:nodeset($parent_table_column_)"/>
				<!-- <xsl:variable name="divider">
					<xsl:value-of select="$parent_table_column/@divider"/>
					<xsl:if test="not($parent_table_column/@divider)">1</xsl:if>
				</xsl:variable> -->
				<xsl:value-of select="$parent_table_column/text()"/> <!--  * 10 -->
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="parent_table_page-width" select="normalize-space($parent_table_page-width_)"/>

		<parent_table_page-width><xsl:value-of select="$parent_table_page-width"/></parent_table_page-width>

		<!-- get current table id -->
		<xsl:variable name="table_id" select="@id"/>

		<xsl:choose>
			<xsl:when test="$parent_table_id = '' or $parent_table_page-width = ''">
				<!-- find table by id in the file 'table_widths' and get all `<column>...</column> -->
				<xsl:copy-of select="$table_widths_from_if_calculated//table[@id = $table_id]/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- recalculate columns width based on parent table width -->
				<xsl:for-each select="$table_widths_from_if//table[@id = $table_id]">
					<xsl:call-template name="calculate-column-widths-autolayout-algorithm">
						<xsl:with-param name="parent_table_page-width" select="$parent_table_page-width"/> <!-- padding-left = 2mm  = 50000-->
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- get-calculated-column-widths-autolayout-algorithm -->

	<!-- ================================================== -->
	<!-- END: Calculate column's width based on HTML4 algorithm -->
	<!-- ================================================== -->

	<xsl:template match="mn:thead">
		<xsl:param name="cols-count"/>
		<fo:table-header>
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template> <!-- thead -->

	<!-- template is using for iec, iso, jcgm, bsi only -->
	<xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row role="SKIP">
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black" role="SKIP">

				<xsl:call-template name="refine_table-header-title-style"/>

				<xsl:apply-templates select="ancestor::mn:table/mn:fmt-name">
					<xsl:with-param name="continued">true</xsl:with-param>
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:apply-templates>

				<xsl:if test="not(ancestor::mn:table/mn:fmt-name)"> <!-- to prevent empty fo:table-cell in case of missing table's name -->
					<fo:block role="SKIP"/>
				</xsl:if>

			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- table-header-title -->

	<xsl:template name="refine_table-header-title-style">
	</xsl:template> <!-- refine_table-header-title-style -->

	<xsl:template match="*[local-name()='thead']" mode="process_tbody">
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="mn:tfoot">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../mn:tfoot">
			<fo:table-footer>
				<xsl:apply-templates select="../mn:tfoot"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>

		<xsl:variable name="isNoteOrFnExist" select="../mn:note[not(@type = 'units')] or ../mn:example or ../mn:dl or ..//mn:fn[not(parent::mn:fmt-name)] or ../mn:fmt-source or ../mn:p"/>

		<xsl:variable name="isNoteOrFnExistShowAfterTable">
		</xsl:variable>

		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">

			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//mn:col">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//mn:col)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="table_fn_block">
				<xsl:call-template name="table_fn_display"/>
			</xsl:variable>

			<xsl:variable name="tableWithNotesAndFootnotes">

				<fo:table keep-with-previous="always" role="SKIP">
					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:variable name="name" select="local-name()"/>
						<xsl:choose>
							<xsl:when test="$name = 'border-top'">
								<xsl:attribute name="{$name}">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:when test="$name = 'border'">
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
								<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:for-each select="ancestor::mn:table[1]">
						<xsl:call-template name="setTableStyles">
							<xsl:with-param name="scope">table</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:choose>
						<xsl:when test="xalan:nodeset($colgroup)//mn:col">
							<xsl:for-each select="xalan:nodeset($colgroup)//mn:col">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<!-- $colwidths=<xsl:copy-of select="$colwidths"/> -->
							<xsl:call-template name="insertTableColumnWidth">
								<xsl:with-param name="colwidths" select="$colwidths"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<xsl:for-each select="ancestor::mn:table[1]">
								<xsl:call-template name="setTableStyles">
									<xsl:with-param name="scope">ancestor_table</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>

							<fo:table-cell xsl:use-attribute-sets="table-footer-cell-style" number-columns-spanned="{$cols-count}" role="SKIP">

								<xsl:call-template name="refine_table-footer-cell-style"/>

								<xsl:for-each select="ancestor::mn:table[1]">
									<xsl:call-template name="setTableStyles">
										<xsl:with-param name="scope">ancestor_table_borders_only</xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>

								<xsl:call-template name="setBordersTableArray"/>

								<!-- fn will be processed inside 'note' processing -->
								<xsl:apply-templates select="../mn:p"/>
								<xsl:apply-templates select="../mn:dl"/>
								<xsl:apply-templates select="../mn:note[not(@type = 'units')]"/>
								<xsl:apply-templates select="../mn:example"/>
								<xsl:apply-templates select="../mn:fmt-source"/>

								<xsl:variable name="isDisplayRowSeparator">
								</xsl:variable>

								<!-- horizontal row separator -->
								<xsl:if test="normalize-space($isDisplayRowSeparator) = 'true'">
									<xsl:if test="(../mn:note[not(@type = 'units')] or ../mn:example) and normalize-space($table_fn_block) != ''">
										<fo:block-container border-top="0.5pt solid black" padding-left="1mm" padding-right="1mm">
											<xsl:call-template name="setBordersTableArray"/>
											<fo:block font-size="1pt"> </fo:block>
										</fo:block-container>
									</xsl:if>
								</xsl:if>

								<!-- fn processing -->
								<!-- <xsl:call-template name="table_fn_display" /> -->
								<xsl:copy-of select="$table_fn_block"/>

							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>

				</fo:table>
			</xsl:variable>

			<xsl:if test="normalize-space($tableWithNotesAndFootnotes) != ''">
				<xsl:copy-of select="$tableWithNotesAndFootnotes"/>
			</xsl:if>

		</xsl:if>
	</xsl:template> <!-- insertTableFooterInSeparateTable -->

	<xsl:template match="mn:tbody">

		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../mn:thead">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../mn:thead/mn:tr[1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./mn:tr[1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates select="../mn:thead">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>

		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>

		<fo:table-body>

			<xsl:apply-templates/>

		</fo:table-body>

	</xsl:template> <!-- tbody -->

	<!-- ======================================== -->
	<!-- mode="process_table-if"                  -->
	<!-- ======================================== -->
	<xsl:template match="/" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>
		<xsl:apply-templates mode="process_table-if">
			<xsl:with-param name="table_or_dl" select="$table_or_dl"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>

		<fo:table-body>
			<xsl:for-each select="*[local-name() = 'tr']">
				<xsl:variable name="col_count" select="count(*)"/>

				<!-- iteration for each tr/td -->

				<xsl:choose>
					<xsl:when test="$table_or_dl = 'table'">
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']/*">
							<fo:table-row number-columns-spanned="{$col_count}">
								<xsl:copy-of select="../@font-weight"/>
								<!-- <test_table><xsl:copy-of select="."/></test_table> -->
								<xsl:call-template name="td"/>
							</fo:table-row>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise> <!-- $table_or_dl = 'dl' -->
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']">
							<xsl:variable name="is_dt" select="position() = 1"/>

							<xsl:for-each select="*">
								<!-- <test><xsl:copy-of select="."/></test> -->
								<fo:table-row number-columns-spanned="{$col_count}">
									<xsl:choose>
										<xsl:when test="$is_dt">
											<xsl:call-template name="insert_dt_cell"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="insert_dd_cell"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:table-row>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</fo:table-body>
	</xsl:template> <!-- process_table-if -->
	<!-- ======================================== -->
	<!-- END: mode="process_table-if"             -->
	<!-- ======================================== -->

	<!-- ===================== -->
	<!-- Table's row processing -->
	<!-- ===================== -->
	<!-- row in table header (thead) thead/tr -->
	<xsl:template match="mn:thead/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-header-row-style">

			<xsl:call-template name="refine_table-header-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setBorderUnderRow">
		<xsl:variable name="border_under_row_" select="normalize-space(ancestor::mn:table[1]/@border-under-row)"/>
		<xsl:choose>
			<xsl:when test="$border_under_row_ != ''">
				<xsl:variable name="table_id" select="ancestor::mn:table[1]/@id"/>
				<xsl:variable name="row_num_"><xsl:number level="any" count="mn:table[@id = $table_id]//mn:tr"/></xsl:variable>
				<xsl:variable name="row_num" select="number($row_num_) - 1"/> <!-- because values in border-under-row start with 0 -->
				<xsl:variable name="border_under_row">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="$border_under_row_"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="xalan:nodeset($border_under_row)/mnx:item[. = normalize-space($row_num)]">
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- row in table footer (tfoot), tfoot/tr -->
	<xsl:template match="mn:tfoot/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-footer-row-style">

			<xsl:call-template name="refine_table-footer-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<!-- row in table's body (tbody) -->
	<xsl:template match="*[local-name()='tr']">
		<fo:table-row xsl:use-attribute-sets="table-body-row-style">

			<xsl:if test="count(*) = count(*[local-name() = 'th'])"> <!-- row contains 'th' only -->
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_table-body-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setTableRowAttributes">

		<xsl:for-each select="ancestor::mn:table[1]">
			<xsl:call-template name="setTableStyles">
				<xsl:with-param name="scope">ancestor_table</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="setTableStyles"/>

	</xsl:template> <!-- setTableRowAttributes -->
	<!-- ===================== -->
	<!-- END Table's row processing -->
	<!-- ===================== -->

	<!-- cell in table header row -->
	<xsl:template match="*[local-name()='th']">
		<fo:table-cell xsl:use-attribute-sets="table-header-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">center</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-header-cell-style"/>

			<!-- experimental feature, see https://github.com/metanorma/metanorma-plateau/issues/30#issuecomment-2145461828 -->
			<!-- <xsl:choose>
				<xsl:when test="count(node()) = 1 and mn:span[contains(@style, 'text-orientation')]">
					<fo:block-container reference-orientation="270">
						<fo:block role="SKIP" text-align="start">
							<xsl:apply-templates />
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<fo:block role="SKIP">
						<xsl:apply-templates />
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> -->

			<fo:block role="SKIP">
				<xsl:apply-templates/>
				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0"> </xsl:if>
			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- cell in table header row - 'th' -->

	<xsl:template name="setTableCellAttributes">
		<xsl:if test="@colspan">
			<xsl:attribute name="number-columns-spanned">
				<xsl:value-of select="@colspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="@rowspan">
			<xsl:attribute name="number-rows-spanned">
				<xsl:value-of select="@rowspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:call-template name="display-align"/>

		<xsl:for-each select="ancestor::mn:table[1]">
			<xsl:call-template name="setTableStyles">
				<xsl:with-param name="scope">ancestor_table_borders_only</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="setTableStyles"/>
	</xsl:template>

	<xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setTableStyles">
		<xsl:param name="scope">cell</xsl:param>
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<!-- PDF: Borderless tables https://github.com/metanorma/metanorma-jis/issues/344 -->
			<xsl:if test="@plain = 'true' or ancestor::mn:table/@plain = 'true'">
				<style name="border-top">none</style>
				<style name="border-right">none</style>
				<style name="border-left">none</style>
				<style name="border-bottom">none</style>
				<style name="color">inherit</style>
				<style name="background-color">transparent</style>
			</xsl:if>

			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:if test="($key = 'color' and ($scope = 'cell' or $scope = 'table')) or       ($key = 'background-color' and ($scope = 'cell' or $scope = 'ancestor_table')) or      $key = 'border' or      $key = 'border-top' or      $key = 'border-right' or      $key = 'border-left' or      $key = 'border-bottom' or      $key = 'border-style' or      $key = 'border-width' or      $key = 'border-color' or      $key = 'border-top-style' or      $key = 'border-top-width' or      $key = 'border-top-color' or      $key = 'border-right-style' or      $key = 'border-right-width' or      $key = 'border-right-color' or      $key = 'border-left-style' or      $key = 'border-left-width' or      $key = 'border-left-color' or      $key = 'border-bottom-style' or      $key = 'border-bottom-width' or      $key = 'border-bottom-color'">
					<style name="{$key}"><xsl:value-of select="java:replaceAll(java:java.lang.String.new($value), 'currentColor', 'inherit')"/></style>
				</xsl:if>
				<xsl:if test="$key = 'border' and ($scope = 'table' or $scope = 'ancestor_table' or $scope = 'ancestor_table_borders_only')">
					<style name="{$key}-top"><xsl:value-of select="$value"/></style>
					<style name="{$key}-right"><xsl:value-of select="$value"/></style>
					<style name="{$key}-left"><xsl:value-of select="$value"/></style>
					<style name="{$key}-bottom"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:for-each select="$styles/style">
			<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
		</xsl:for-each>
	</xsl:template> <!-- setTableStyles -->

	<!-- cell in table body, footer -->
	<xsl:template match="*[local-name()='td']" name="td">
		<fo:table-cell xsl:use-attribute-sets="table-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-cell-style"/>

			<xsl:call-template name="setTableCellAttributes"/>

			<xsl:if test=".//mn:table"> <!-- if there is nested table -->
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isGenerateTableIF = 'true'">
				<xsl:attribute name="border">1pt solid black</xsl:attribute> <!-- border is mandatory, to determine page width -->
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isGenerateTableIF = 'false'">
				<xsl:if test="@colspan and mn:note[@type = 'units']">
					<xsl:attribute name="text-align">right</xsl:attribute>
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
					<xsl:attribute name="border-top">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-left">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-right">1pt solid white</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:apply-templates/>

				<xsl:if test="$isGenerateTableIF = 'true'"> <fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0"> </xsl:if>

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- td -->

	<!-- table/note, table/example, table/tfoot//note, table/tfoot//example -->
	<xsl:template match="mn:table/*[self::mn:note or self::mn:example] |       mn:table/mn:tfoot//*[self::mn:note or self::mn:example]" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block xsl:use-attribute-sets="table-note-style">
			<xsl:copy-of select="@id"/>

			<xsl:call-template name="refine_table-note-style"/>

			<!-- Table's note/example name (NOTE, for example) -->
			<fo:inline xsl:use-attribute-sets="table-note-name-style">

				<xsl:call-template name="refine_table-note-name-style"/>

				<xsl:apply-templates select="mn:fmt-name"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template> <!-- table/note -->

	<xsl:template match="mn:table/*[self::mn:note or self::mn:example]/mn:p |  mn:table/mn:tfoot//*[self::mn:note or self::mn:example]/mn:p" priority="2">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ============================ -->
	<!-- table's footnotes rendering -->
	<!-- ============================ -->

	<!-- table/fmt-footnote-container -->
	<xsl:template match="mn:table/mn:fmt-footnote-container"/>

	<xsl:template match="mn:table/mn:tfoot//mn:fmt-footnote-container">
		<xsl:for-each select=".">
			<xsl:call-template name="table_fn_display"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="table_fn_display">
		<!-- <xsl:variable name="references">
			<xsl:if test="$namespace = 'bsi'">
				<xsl:for-each select="..//mn:fn[local-name(..) = 'name']">
					<xsl:call-template name="create_fn" />
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="..//mn:fn[local-name(..) != 'name']">
				<xsl:call-template name="create_fn" />
			</xsl:for-each>
		</xsl:variable> -->
		<!-- <xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])">  --> <!-- only unique reference puts in note-->
		<xsl:for-each select="..//mn:fmt-footnote-container/mn:fmt-fn-body">
				<fo:block xsl:use-attribute-sets="table-fn-style">
					<xsl:copy-of select="@id"/>
					<xsl:call-template name="refine_table-fn-style"/>

					<xsl:apply-templates select=".//mn:fmt-fn-label">
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>

					<fo:inline xsl:use-attribute-sets="table-fn-body-style">
						<!-- <xsl:copy-of select="./node()"/> -->
						<xsl:apply-templates/>
					</fo:inline>

				</fo:block>

			<!-- </xsl:if> -->
		</xsl:for-each>
	</xsl:template> <!-- table_fn_display -->

	<!-- fmt-fn-body/fmt-fn-label in text -->
	<xsl:template match="mn:fmt-fn-body//mn:fmt-fn-label"/>

	<!-- table//fmt-fn-body//fmt-fn-label -->
	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="table-fn-number-style" role="SKIP">

				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>

				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">(</fo:inline>
				</xsl:if> -->

				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>※</xsl:text>
				</xsl:if> -->

				<!-- <xsl:value-of select="@reference"/> -->
				<!-- <xsl:value-of select="normalize-space()"/> -->
				<xsl:apply-templates/>

				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">)</fo:inline>
				</xsl:if> -->

				<!-- commented https://github.com/metanorma/isodoc/issues/614 -->
				<!-- <xsl:if test="$namespace = 'itu'">
					<xsl:text>)</xsl:text>
				</xsl:if> -->

				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>：</xsl:text>
				</xsl:if> -->

			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  fmt-fn-body//fmt-fn-label -->

	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="table-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_table-fmt-fn-label-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- <xsl:template match="mn:fmt-footnote-container/mn:fmt-fn-body//mn:fmt-fn-label//mn:tab"/> -->
	<!-- 
	<xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
			<xsl:if test="ancestor::*[local-name()='table'][1]/@id">  - for footnotes in tables -
				<xsl:attribute name="id">
					<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::mn:preface">
					<xsl:attribute name="preface">true</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:attribute name="id">
					<xsl:value-of select="@reference"/>
					<xsl:text>_</xsl:text>
					<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fn>
	</xsl:template> -->

	<!-- footnotes for table's name rendering -->
	<xsl:template name="table_name_fn_display">
		<xsl:for-each select="mn:fmt-name//mn:fn">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================ -->
	<!-- EMD table's footnotes rendering -->
	<!-- ============================ -->

	<!-- fn reference in the table rendering (for instance, 'some text 1) some text' ) -->
	<!-- fn --> <!-- in table --> <!-- for figure see <xsl:template match="mn:figure/mn:fn" priority="2"/> -->
	<xsl:template match="mn:fn">
		<xsl:variable name="target" select="@target"/>
		<xsl:choose>
			<!-- case for footnotes in Requirement tables (https://github.com/metanorma/metanorma-ogc/issues/791) -->
			<xsl:when test="not(ancestor::mn:table[1]//mn:fmt-footnote-container/mn:fmt-fn-body[@id = $target]) and        $footnotes/mn:fmt-fn-body[@id = $target]">
				<xsl:call-template name="fn">
					<xsl:with-param name="footnote_body_from_table">true</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>

				<fo:inline xsl:use-attribute-sets="fn-reference-style">

					<xsl:call-template name="refine_fn-reference-style"/>

					<!-- <fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="footnote {@reference}"> --> <!-- @reference   | ancestor::mn:clause[1]/@id-->
					<fo:basic-link internal-destination="{@target}" fox:alt-text="footnote {@reference}">
						<!-- <xsl:if test="ancestor::*[local-name()='table'][1]/@id"> --> <!-- for footnotes in tables -->
						<!-- 	<xsl:attribute name="internal-destination">
								<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
								<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
							</xsl:attribute>
						</xsl:if> -->
						<!-- <xsl:if test="$namespace = 'plateau'">
							<xsl:text>※</xsl:text>
						</xsl:if> -->
						<!-- <xsl:value-of select="@reference"/> -->
						<xsl:value-of select="normalize-space(mn:fmt-fn-label)"/>

						<!-- <xsl:if test="$namespace = 'bsi'">
							<xsl:text>)</xsl:text>
						</xsl:if> -->
						<!-- commented, https://github.com/metanorma/isodoc/issues/614 -->
						<!-- <xsl:if test="$namespace = 'jis'">
							<fo:inline font-weight="normal">)</fo:inline>
						</xsl:if> -->
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn -->

	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="$isGenerateTableIF = 'true' and not(contains($text, $separator))">
				<word><xsl:value-of select="normalize-space($text)"/></word>
			</xsl:when>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:choose>
						<xsl:when test="normalize-space(translate($text, 'X', '')) = ''"> <!-- special case for keep-together.within-line -->
							<xsl:value-of select="$len_str_tmp"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
							<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
							<xsl:variable name="len_str">
								<xsl:choose>
									<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
										<xsl:value-of select="$len_str_tmp * 1.5"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$len_str_tmp"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
								<xsl:message>
									div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
									len_str=<xsl:value-of select="$len_str"/>
									len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
								</xsl:message>
							</xsl:if> -->
							<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
							<len_str><xsl:value-of select="$len_str"/></len_str> -->
							<xsl:choose>
								<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
									<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$len_str"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:variable name="word" select="normalize-space(substring-before($text, $separator))"/>
					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<xsl:value-of select="$word"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string-length($word)"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- split string 'text' by 'separator', enclosing in formatting tags -->
	<xsl:template name="tokenize_with_tags">
		<xsl:param name="tags"/>
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:if test="ancestor::mn:p[@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space($text)"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:if test="ancestor::mn:p[@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space(substring-before($text, $separator))"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
				<xsl:call-template name="tokenize_with_tags">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="tags" select="$tags"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="enclose_text_in_tags">
		<xsl:param name="text"/>
		<xsl:param name="tags"/>
		<xsl:param name="num">1</xsl:param> <!-- default (start) value -->

		<xsl:variable name="tag_name" select="normalize-space(xalan:nodeset($tags)//tag[$num])"/>

		<xsl:choose>
			<xsl:when test="$tag_name = ''"><xsl:value-of select="$text"/></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$tag_name}" namespace="{$namespace_full}">
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="$text"/>
						<xsl:with-param name="tags" select="$tags"/>
						<xsl:with-param name="num" select="$num + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get max value in array -->
	<xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>

		<!-- add zero-width space (#x200B) after dot with next non-digit -->
		<xsl:variable name="text1" select="java:replaceAll(java:java.lang.String.new($text),'(\.)([^\d\s])','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, equal, underscore, em dash, thin space, arrow right, ;   -->
		<xsl:variable name="text2" select="java:replaceAll(java:java.lang.String.new($text1),'(-|=|_|—| |→|;)','$1​')"/>
		<!-- add zero-width space (#x200B) after characters: colon, if there aren't digits after -->
		<xsl:variable name="text3" select="java:replaceAll(java:java.lang.String.new($text2),'(:)(\D)','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: 'great than' -->
		<xsl:variable name="text4" select="java:replaceAll(java:java.lang.String.new($text3), '(\u003e)(?!\u003e)', '$1​')"/><!-- negative lookahead: 'great than' not followed by 'great than' -->
		<!-- add zero-width space (#x200B) before characters: 'less than' -->
		<xsl:variable name="text5" select="java:replaceAll(java:java.lang.String.new($text4), '(?&lt;!\u003c)(\u003c)', '​$1')"/> <!-- (?<!\u003c)(\u003c) --> <!-- negative lookbehind: 'less than' not preceeded by 'less than' -->
		<!-- add zero-width space (#x200B) before character: { -->
		<xsl:variable name="text6" select="java:replaceAll(java:java.lang.String.new($text5), '(?&lt;!\W)(\{)', '​$1')"/> <!-- negative lookbehind: '{' not preceeded by 'punctuation char' -->
		<!-- add zero-width space (#x200B) after character: , -->
		<xsl:variable name="text7" select="java:replaceAll(java:java.lang.String.new($text6), '(\,)(?!\d)', '$1​')"/> <!-- negative lookahead: ',' not followed by digit -->
		<!-- add zero-width space (#x200B) after character: '/' -->
		<xsl:variable name="text8" select="java:replaceAll(java:java.lang.String.new($text7), '(\u002f)(?!\u002f)', '$1​')"/><!-- negative lookahead: '/' not followed by '/' -->

		<xsl:variable name="text9">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text8), '([\u3000-\u9FFF])', '$1​')"/> <!-- 3000 - CJK Symbols and Punctuation ... 9FFF CJK Unified Ideographs-->
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$text8"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="text10" select="java:replaceAll(java:java.lang.String.new($text9), '\u200b{2,}', '​')"/>

		<!-- replace sequence #x200B and space TO space -->
		<xsl:variable name="text11" select="java:replaceAll(java:java.lang.String.new($text10), '\u200b ', ' ')"/>

		<xsl:value-of select="$text11"/>
	</xsl:template> <!-- add-zero-spaces-java -->

	<xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>

		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$1')"/> <!-- http://. https:// or www. -->
		<xsl:variable name="url_continue" select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space, comma, slash, @  -->
		<xsl:variable name="url" select="java:replaceAll(java:java.lang.String.new($url_continue),'(-|\.|:|=|_|—| |,|/|@)','$1​')"/>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="url2" select="java:replaceAll(java:java.lang.String.new($url), '\u200b{2,}', '​')"/>

		<!-- remove zero-width space at the end -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($url2), '​$', '')"/>
	</xsl:template> <!-- add-zero-spaces-link-java -->

	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:param name="id"/>

		<!-- <test0>
			<xsl:copy-of select="."/>
		</test0> -->

		<xsl:variable name="simple-table">

			<xsl:variable name="table_without_semantic_elements">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:variable>

			<!-- Step 0. replace <br/> to <p>...</p> -->
			<xsl:variable name="table_without_br">
				<!-- <xsl:apply-templates mode="table-without-br"/> -->
				<xsl:apply-templates select="xalan:nodeset($table_without_semantic_elements)" mode="table-without-br"/>
			</xsl:variable>
			<!-- <debug-table_without_br><xsl:copy-of select="$table_without_br"/></debug-table_without_br> -->

			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<mn:tbody>
					<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-colspan"/>
				</mn:tbody>
			</xsl:variable>
			<!-- <debug-simple-table-colspan><xsl:copy-of select="$simple-table-colspan"/></debug-simple-table-colspan> -->

			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			<!-- <debug-simple-table-rowspan><xsl:copy-of select="$simple-table-rowspan"/></debug-simple-table-rowspan> -->

			<!-- Step 3: add id to each cell -->
			<!-- add <word>...</word> for each word, image, math -->
			<xsl:variable name="simple-table-id">
				<xsl:apply-templates select="xalan:nodeset($simple-table-rowspan)" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
			</xsl:variable>
			<!-- <debug-simple-table-id><xsl:copy-of select="$simple-table-id"/></debug-simple-table-id> -->

			<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>

	<!-- ================================== -->
	<!-- Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->
	<xsl:template match="@*|node()" mode="table-without-br">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="table-without-br"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name() = 'td'][not(mn:br) and not(mn:p) and not(mn:sourcecode) and not(mn:ul) and not(mn:ol)]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<mn:p>
				<xsl:copy-of select="node()"/>
			</mn:p>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td'][mn:br]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="mn:br">
				<xsl:variable name="current_id" select="generate-id()"/>
				<mn:p>
					<xsl:for-each select="preceding-sibling::node()[following-sibling::mn:br[1][generate-id() = $current_id]][not(local-name() = 'br')]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</mn:p>
				<xsl:if test="not(following-sibling::mn:br)">
					<mn:p>
						<xsl:for-each select="following-sibling::node()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</mn:p>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:p[mn:br]" mode="table-without-br">
		<xsl:for-each select="mn:br">
			<xsl:variable name="current_id" select="generate-id()"/>
			<mn:p>
				<xsl:for-each select="preceding-sibling::node()[following-sibling::mn:br[1][generate-id() = $current_id]][not(local-name() = 'br')]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</mn:p>
			<xsl:if test="not(following-sibling::mn:br)">
				<mn:p>
					<xsl:for-each select="following-sibling::node()">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</mn:p>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:sourcecode" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:sourcecode/text()[contains(., '&#13;') or contains(., '&#10;')]" mode="table-without-br">

		<xsl:variable name="sep">###SOURCECODE_NEWLINE###</xsl:variable>
		<xsl:variable name="sourcecode_text" select="java:replaceAll(java:java.lang.String.new(.),'(&#13;&#10;|&#13;|&#10;)', $sep)"/>
		<xsl:variable name="items">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="$sourcecode_text"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space">false</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($items)/*">
			<mn:p>
				<mn:sourcecode><xsl:copy-of select="node()"/></mn:sourcecode>
			</mn:p>
		</xsl:for-each>
	</xsl:template>

	<!-- remove redundant white spaces -->
	<xsl:template match="text()[not(ancestor::mn:sourcecode)]" mode="table-without-br">
		<xsl:variable name="text" select="translate(.,'&#9;&#10;&#13;','')"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),' {2,}',' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//*[local-name() = 'ol' or local-name() = 'ul']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//mn:li" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<!-- mode="table-without-br" -->
	<!-- ================================== -->
	<!-- END: Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->

	<!-- ===================== -->
	<!-- 1. mode "simple-table-colspan" 
			1.1. remove thead, tbody, fn
			1.2. rename th -> td
			1.3. repeating N td with colspan=N
			1.4. remove namespace
			1.5. remove @colspan attribute
			1.6. add @divide attribute for divide text width in further processing 
	-->
	<!-- ===================== -->
	<xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template>
	<xsl:template match="mn:fn" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="{local-name()}" namespace="{$namespace_full}">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:if test="local-name()='th'">
							<xsl:attribute name="font-weight">bold</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name()}" namespace="{$namespace_full}">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:if test="local-name()='th'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@colspan" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<mn:tr>
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</mn:tr>
	</xsl:template>

	<xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template>

	<!-- repeat node 'count' times -->
	<xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>

		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template>
	<!-- End mode simple-table-colspan  -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- ===================== -->
	<!-- 2. mode "simple-table-rowspan" 
	Row span processing, more information http://andrewjwelch.com/code/xslt/table/table-normalization.html	-->
	<!-- ===================== -->
	<xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="mn:tr[1]"/>
				<xsl:apply-templates select="mn:tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="mn:tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>

		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//*[self::mn:td or self::mn:th]">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/*[self::mn:td or self::mn:th][1 + count(current()/preceding-sibling::*[self::mn:td or self::mn:th][not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<!-- optimize to prevent StackOverflowError, just copy next 'tr' -->
		<xsl:variable name="currrow_num" select="count(preceding-sibling::mn:tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan_" select="count(following-sibling::mn:tr[*[@rowspan and @rowspan != 1]][1]/preceding-sibling::mn:tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan" select="$nextrow_without_rowspan_ - $currrow_num"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($newRow)/*/*[@rowspan and @rowspan != 1]) and $nextrow_without_rowspan &lt;= 0">
				<xsl:copy-of select="following-sibling::mn:tr"/>
			</xsl:when>
			<!-- <xsl:when test="xalan:nodeset($newRow)/*[not(@rowspan) or (@rowspan = 1)] and $nextrow_without_rowspan &gt; 0">
				<xsl:copy-of select="following-sibling::tr[position() &lt;= $nextrow_without_rowspan]"/>
				
				<xsl:copy-of select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				<xsl:apply-templates select="following-sibling::tr[$nextrow_without_rowspan + 2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				</xsl:apply-templates>
			</xsl:when> -->
			<xsl:otherwise>
				<xsl:apply-templates select="following-sibling::mn:tr[1]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="$newRow"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->

	<!-- Step 3: add id for each cell -->
	<!-- mode: simple-table-id -->
	<xsl:template match="/" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:variable name="id_prefixed" select="concat('table_if_',$id)"/> <!-- table id prefixed by 'table_if_' to simple search in IF  -->
		<xsl:apply-templates select="@*|node()" mode="simple-table-id">
			<xsl:with-param name="id" select="$id_prefixed"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="@*|node()" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
			<xsl:apply-templates select="node()" mode="simple-table-id">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="row_number" select="count(../preceding-sibling::*) + 1"/>
			<xsl:variable name="col_number" select="count(preceding-sibling::*) + 1"/>
			<xsl:variable name="divide">
				<xsl:choose>
					<xsl:when test="@divide"><xsl:value-of select="@divide"/></xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="id">
				<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_',$divide)"/>
			</xsl:attribute>

			<xsl:for-each select="*[local-name() = 'p']">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:variable name="p_num" select="count(preceding-sibling::*[local-name() = 'p']) + 1"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_p_',$p_num,'_',$divide)"/>
					</xsl:attribute>

					<!-- <xsl:copy-of select="node()" /> -->
					<xsl:apply-templates mode="simple-table-noid"/>

				</xsl:copy>
			</xsl:for-each>

			<xsl:if test="$isGenerateTableIF = 'true'"> <!-- split each paragraph to words, image, math -->

				<xsl:variable name="td_text">
					<xsl:apply-templates select="." mode="td_text_with_formatting"/>
				</xsl:variable>

				<!-- td_text='<xsl:copy-of select="$td_text"/>' -->

				<xsl:variable name="words_with_width">
					<!-- calculate width for 'word' which contain text only (without formatting tags inside) -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][not(*)]">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:attribute name="width">
								<xsl:value-of select="java:org.metanorma.fop.Util.getStringWidth(., $font_main)"/> <!-- Example: 'Times New Roman' -->
							</xsl:attribute>
							<xsl:copy-of select="node()"/>
						</xsl:copy>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="words_with_width_sorted">
					<xsl:for-each select="xalan:nodeset($words_with_width)//*[local-name() = 'word']">
						<xsl:sort select="@width" data-type="number" order="descending"/>
						<!-- select word maximal width only -->
						<xsl:if test="position() = 1">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
					<!-- add 'word' with formatting tags inside -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][*]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:variable>

				<!-- <xsl:if test="$debug = 'true'">
					<redirect:write file="{generate-id()}_words_with_width_sorted.xml">
						<td_text><xsl:copy-of select="$td_text"/></td_text>
						<words_with_width><xsl:copy-of select="$words_with_width"/></words_with_width>
						<xsl:copy-of select="$words_with_width_sorted"/>
					</redirect:write>
				</xsl:if> -->

				<xsl:variable name="words">
					<xsl:for-each select=".//*[local-name() = 'image' or local-name() = 'fmt-stem']">
						<word>
							<xsl:copy-of select="."/>
						</word>
					</xsl:for-each>

					<xsl:for-each select="xalan:nodeset($words_with_width_sorted)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<!-- <xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each> -->

				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($words)/word">
					<xsl:variable name="num" select="count(preceding-sibling::word) + 1"/>
					<xsl:copy>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_word_',$num,'_',$divide)"/>
						</xsl:attribute>
						<xsl:copy-of select="node()"/>
					</xsl:copy>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>

	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p']//*" mode="simple-table-noid">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@*[local-name() != 'id']"/> <!-- to prevent repeat id in colspan/rowspan cells -->
					<!-- <xsl:if test="local-name() = 'dl' or local-name() = 'table'">
						<xsl:copy-of select="@id"/>
					</xsl:if> -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="@*"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="node()" mode="simple-table-noid"/>
		</xsl:copy>
	</xsl:template>

	<!-- End mode: simple-table-id -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- =============================== -->
	<!-- mode="td_text_with_formatting" -->
	<!-- =============================== -->
	<xsl:template match="@*|node()" mode="td_text_with_formatting">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="td_text_with_formatting"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'fmt-stem' or local-name() = 'image']" mode="td_text_with_formatting"/>

	<xsl:template match="*[local-name() = 'keep-together_within-line']/text()" mode="td_text_with_formatting">
		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>
		<word>
			<xsl:call-template name="enclose_text_in_tags">
				<xsl:with-param name="text" select="normalize-space(.)"/>
				<xsl:with-param name="tags" select="$formatting_tags"/>
			</xsl:call-template>
		</word>
	</xsl:template>

	<xsl:template match="*[local-name() != 'keep-together_within-line']/text()" mode="td_text_with_formatting">

		<xsl:variable name="td_text" select="."/>

		<xsl:variable name="string_with_added_zerospaces">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$td_text"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>

		<!-- <word>text</word> -->
		<xsl:call-template name="tokenize_with_tags">
			<xsl:with-param name="tags" select="$formatting_tags"/>
			<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:fmt-link[normalize-space() = '']" mode="td_text_with_formatting">
		<xsl:variable name="link">
			<link_updated>
				<xsl:variable name="target_text">
					<xsl:choose>
						<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
							<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$target_text"/>
			</link_updated>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($link)/*">
			<xsl:apply-templates mode="td_text_with_formatting"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getFormattingTags">
		<tags>
			<xsl:if test="ancestor::mn:strong"><tag>strong</tag></xsl:if>
			<xsl:if test="ancestor::mn:em"><tag>em</tag></xsl:if>
			<xsl:if test="ancestor::mn:sub"><tag>sub</tag></xsl:if>
			<xsl:if test="ancestor::mn:sup"><tag>sup</tag></xsl:if>
			<xsl:if test="ancestor::mn:tt"><tag>tt</tag></xsl:if>
			<xsl:if test="ancestor::mn:sourcecode"><tag>sourcecode</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'keep-together_within-line']"><tag>keep-together_within-line</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'font_en_vertical']"><tag>font_en_vertical</tag></xsl:if>
		</tags>
	</xsl:template>
	<!-- =============================== -->
	<!-- END mode="td_text_with_formatting" -->
	<!-- =============================== -->

	<!-- ========================== -->
	<!-- Definition's list styles -->
	<!-- ========================== -->

	<xsl:attribute-set name="dl-block-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="dt-row-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="dt-cell-style">
	</xsl:attribute-set>

	<xsl:template name="refine_dt-cell-style">
	</xsl:template> <!-- refine_dt-cell-style -->

	<xsl:attribute-set name="dt-block-style">
		<xsl:attribute name="margin-top">0pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_dt-block-style">
	</xsl:template> <!-- refine_dt-block-style -->

	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set> <!-- dl-name-style -->

	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_dd-cell-style">
	</xsl:template> <!-- refine_dd-cell-style -->

	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->

	<!-- ===================== -->
	<!-- Definition List -->
	<!-- ===================== -->

	<!-- for table auto-layout algorithm -->
	<xsl:template match="mn:dl" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="dl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- dl -->

	<xsl:template match="mn:dl" name="dl">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<!-- <dl><xsl:copy-of select="."/></dl> -->
		<fo:block-container xsl:use-attribute-sets="dl-block-style" role="SKIP">

			<xsl:if test="@key = 'true' and ancestor::mn:figure">
				<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setBlockSpanAll"/>
			<xsl:if test="not(ancestor::mn:quote)">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::mn:sourcecode">
				<!-- set font-size as sourcecode font-size -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:call-template name="get_sourcecode_attributes"/>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@font-size">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="parent::mn:note">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<fo:block-container margin-left="0mm" role="SKIP">
				<xsl:attribute name="margin-right">0mm</xsl:attribute>

				<xsl:variable name="parent" select="local-name(..)"/>

				<xsl:variable name="key_iso"> <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>

				<xsl:variable name="onlyOneComponent" select="normalize-space($parent = 'formula' and count(mn:dt) = 1)"/>

				<xsl:choose>
					<xsl:when test="$onlyOneComponent = 'true'"> <!-- only one component -->
						<fo:block margin-bottom="12pt" text-align="left">
							<!-- <xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/> -->
							<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="mn:dt/*"/>
							<xsl:if test="mn:dd/node()[normalize-space() != ''][1][self::text()]">
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:apply-templates select="mn:dd/node()" mode="inline"/>
						</fo:block>
					</xsl:when> <!-- END: only one component -->
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">

							<xsl:call-template name="refine_dl_formula_where_style"/>

							<!-- <xsl:variable name="title-where">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">where</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-where"/><xsl:if test="$namespace = 'bsi' or $namespace = 'itu'">:</xsl:if> -->
							<!-- preceding 'p' with word 'where' -->
							<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
						</fo:block>
					</xsl:when>  <!-- END: a few components -->
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')"> <!-- definition list in a figure -->
						<!-- Presentation XML contains 'Key' caption, https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:if test="not(preceding-sibling::*[1][self::mn:p and @keep-with-next])"> <!-- for old Presentation XML -->
							<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">

								<xsl:call-template name="refine_figure_key_style"/>

								<xsl:variable name="title-key">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">key</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$title-key"/>
							</fo:block>
						</xsl:if>
					</xsl:when>  <!-- END: definition list in a figure -->
				</xsl:choose>

				<!-- a few components -->
				<xsl:if test="$onlyOneComponent = 'false'">
					<fo:block role="SKIP">

						<xsl:call-template name="refine_multicomponent_style"/>

						<xsl:if test="ancestor::*[self::mn:dd or self::mn:td]">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>

						<fo:block role="SKIP">

							<xsl:call-template name="refine_multicomponent_block_style"/>

							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>

							<xsl:if test="$isGenerateTableIF = 'true'">
								<!-- to determine start of table -->
								<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
							</xsl:if>

							<fo:table width="95%" table-layout="fixed">

								<xsl:if test="$isGenerateTableIF = 'true'">
									<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'"/>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
									</xsl:when>
								</xsl:choose>

								<xsl:choose>
									<xsl:when test="$isGenerateTableIF = 'true'">
										<!-- generate IF for table widths -->
										<!-- example:
											<tr>
												<td valign="top" align="left" id="tab-symdu_1_1">
													<p>Symbol</p>
													<word id="tab-symdu_1_1_word_1">Symbol</word>
												</td>
												<td valign="top" align="left" id="tab-symdu_1_2">
													<p>Description</p>
													<word id="tab-symdu_1_2_word_1">Description</word>
												</td>
											</tr>
										-->

										<!-- create virtual html table for dl/[dt and dd] -->
										<xsl:variable name="simple-table">
											<!-- initial='<xsl:copy-of select="."/>' -->
											<xsl:variable name="dl_table">
												<mn:tbody>
													<xsl:apply-templates mode="dl_if">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
											</xsl:variable>

											<!-- dl_table='<xsl:copy-of select="$dl_table"/>' -->

											<!-- Step: replace <br/> to <p>...</p> -->
											<xsl:variable name="table_without_br">
												<xsl:apply-templates select="xalan:nodeset($dl_table)" mode="table-without-br"/>
											</xsl:variable>

											<!-- table_without_br='<xsl:copy-of select="$table_without_br"/>' -->

											<!-- Step: add id to each cell -->
											<!-- add <word>...</word> for each word, image, math -->
											<xsl:variable name="simple-table-id">
												<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-id">
													<xsl:with-param name="id" select="@id"/>
												</xsl:apply-templates>
											</xsl:variable>

											<!-- simple-table-id='<xsl:copy-of select="$simple-table-id"/>' -->

											<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

										</xsl:variable>

										<!-- DEBUG: simple-table<xsl:copy-of select="$simple-table"/> -->

										<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if">
											<xsl:with-param name="table_or_dl">dl</xsl:with-param>
										</xsl:apply-templates>

									</xsl:when>
									<xsl:otherwise>

										<xsl:variable name="simple-table">

											<xsl:variable name="dl_table">
												<mn:tbody>
													<xsl:apply-templates mode="dl">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
											</xsl:variable>

											<xsl:copy-of select="$dl_table"/>
										</xsl:variable>

										<xsl:variable name="colwidths">
											<xsl:choose>
												<!-- dl from table[@class='dl'] -->
												<xsl:when test="mn:colgroup">
													<autolayout/>
													<xsl:for-each select="mn:colgroup/mn:col">
														<column><xsl:value-of select="translate(@width,'%m','')"/></column>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="calculate-column-widths">
														<xsl:with-param name="cols-count" select="2"/>
														<xsl:with-param name="table" select="$simple-table"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>

										<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
											DEBUG
											colwidths=<xsl:copy-of select="$colwidths"/>
										<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

										<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->

										<xsl:variable name="maxlength_dt">
											<xsl:call-template name="getMaxLength_dt"/>
										</xsl:variable>

										<xsl:variable name="isContainsKeepTogetherTag_">false
										</xsl:variable>
										<xsl:variable name="isContainsKeepTogetherTag" select="normalize-space($isContainsKeepTogetherTag_)"/>
										<!-- isContainsExpressReference=<xsl:value-of select="$isContainsExpressReference"/> -->
										<xsl:call-template name="setColumnWidth_dl">
											<xsl:with-param name="colwidths" select="$colwidths"/>
											<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
											<xsl:with-param name="isContainsKeepTogetherTag" select="$isContainsKeepTogetherTag"/>
										</xsl:call-template>

										<fo:table-body>

											<!-- DEBUG -->
											<xsl:if test="$table_if_debug = 'true'">
												<fo:table-row>
													<fo:table-cell number-columns-spanned="2" font-size="60%">
														<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
													</fo:table-cell>
												</fo:table-row>
											</xsl:if>

											<xsl:apply-templates>
												<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
												<xsl:with-param name="split_keep-within-line" select="xalan:nodeset($colwidths)/split_keep-within-line"/>
											</xsl:apply-templates>

										</fo:table-body>
									</xsl:otherwise>
								</xsl:choose>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if> <!-- END: a few components -->
			</fo:block-container>
		</fo:block-container>

		<xsl:if test="$isGenerateTableIF = 'true'"> <!-- process nested 'dl' -->
			<xsl:apply-templates select="mn:dd/mn:dl"/>
		</xsl:if>

	</xsl:template> <!-- END: dl -->

	<xsl:template match="@*|node()" mode="dt_clean">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="dt_clean"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:asciimath" mode="dt_clean"/>

	<xsl:template name="refine_dl_formula_where_style">
	</xsl:template> <!-- refine_dl_formula_where_style -->

	<xsl:template name="refine_multicomponent_style">
		<xsl:variable name="parent" select="local-name(..)"/>
	</xsl:template> <!-- refine_multicomponent_style -->

	<xsl:template name="refine_multicomponent_block_style">
		<xsl:variable name="parent" select="local-name(..)"/>
	</xsl:template> <!-- refine_multicomponent_block_style -->

	<!-- dl/name -->
	<xsl:template match="mn:dl/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="dl-name-style">

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>
		<xsl:param name="maxlength_dt"/>
		<xsl:param name="isContainsKeepTogetherTag"/>

		<!-- <colwidths><xsl:copy-of select="$colwidths"/></colwidths> -->

		<xsl:choose>
			<!-- <xsl:when test="@class = 'formula_dl' and local-name(..) = 'figure'">
				<fo:table-column column-width="10%"/>
				<fo:table-column column-width="90%"/>
			</xsl:when> -->
			<xsl:when test="xalan:nodeset($colwidths)/autolayout">
				<xsl:call-template name="insertTableColumnWidth">
					<xsl:with-param name="colwidths" select="$colwidths"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="ancestor::mn:dl"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colwidths)/autolayout">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$isContainsKeepTogetherTag">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertTableColumnWidth">
		<xsl:param name="colwidths"/>

		<xsl:for-each select="xalan:nodeset($colwidths)//column">
			<xsl:choose>
				<xsl:when test=". = 1 or . = 0">
					<fo:table-column column-width="proportional-column-width(2)"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- <fo:table-column column-width="proportional-column-width({.})"/> -->
					<xsl:variable name="divider">
						<xsl:value-of select="@divider"/>
						<xsl:if test="not(@divider)">1</xsl:if>
					</xsl:variable>
					<fo:table-column column-width="proportional-column-width({round(. div $divider)})"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getMaxLength_dt">
		<xsl:variable name="lengths">
			<xsl:for-each select="mn:dt">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template>

	<!-- note in definition list: dl/note -->
	<!-- renders in the 2-column spanned table row -->
	<xsl:template match="mn:dl/mn:note" priority="2">
		<xsl:param name="key_iso"/>
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<!-- OLD Variant -->
		<!-- <fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="mn:name" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
				</fo:block>
			</fo:table-cell>
		</fo:table-row> -->
		<!-- <tr>
			<td number-columns-spanned="2">NOTE <xsl:apply-templates /> </td>
		</tr> 
		-->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="2">
				<fo:block role="SKIP">
					<xsl:call-template name="note"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- END: dl/note -->

	<!-- virtual html table for dl/[dt and dd]  -->
	<xsl:template match="mn:dt" mode="dl">
		<xsl:param name="id"/>
		<xsl:variable name="row_number" select="count(preceding-sibling::mn:dt) + 1"/>
		<mn:tr>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_1')"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</mn:td>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_2')"/>
				</xsl:attribute>
				<xsl:apply-templates select="following-sibling::mn:dd[1]">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>
			</mn:td>
		</mn:tr>
	</xsl:template>

	<!-- Definition's term -->
	<xsl:template match="mn:dt">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>

		<fo:table-row xsl:use-attribute-sets="dt-row-style">
			<xsl:call-template name="insert_dt_cell">
				<xsl:with-param name="key_iso" select="$key_iso"/>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:call-template>
			<xsl:for-each select="following-sibling::mn:dd[1]">
				<xsl:call-template name="insert_dd_cell">
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:call-template>
			</xsl:for-each>
		</fo:table-row>
	</xsl:template> <!-- END: dt -->

	<xsl:template name="insert_dt_cell">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dt-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_dt-cell-style"/>

			<xsl:call-template name="setNamedDestination"/>
			<fo:block xsl:use-attribute-sets="dt-block-style" role="SKIP">

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="@id"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="normalize-space($key_iso) = 'true'">
					<xsl:attribute name="margin-top">0</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="refine_dt-block-style"/>

				<xsl:apply-templates>
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:apply-templates>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dt_cell -->

	<xsl:template name="insert_dd_cell">
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dd-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_dd-cell-style"/>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:apply-templates> <!-- following-sibling::mn:dd[1] -->
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."> <!-- following-sibling::mn:dd[1] -->
							<xsl:with-param name="process">true</xsl:with-param>
							<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
						</xsl:apply-templates>
					</xsl:otherwise>

				</xsl:choose>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dd_cell -->

	<!-- END Definition's term -->

	<xsl:template match="mn:dd" mode="dl"/>
	<xsl:template match="mn:dd" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:dd">
		<xsl:param name="process">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates select="@language"/>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:dd/*" mode="inline">
		<xsl:variable name="is_inline_element_after_where">
			<xsl:if test="self::mn:p and not(preceding-sibling::node()[normalize-space() != ''])">true</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$is_inline_element_after_where = 'true'">
				<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =============================== -->
	<!-- mode="dl_if" -->
	<!-- =============================== -->
	<!-- virtual html table for dl/[dt and dd] for IF (Intermediate Format) -->
	<xsl:template match="mn:dt" mode="dl_if">
		<xsl:param name="id"/>
		<mn:tr>
			<mn:td>
				<xsl:copy-of select="node()"/>
			</mn:td>
			<mn:td>
				<!-- <xsl:copy-of select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]"/> -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]" mode="dl_if"/>
				<!-- get paragraphs from nested 'dl' -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/mn:dl" mode="dl_if_nested"/>
			</mn:td>
		</mn:tr>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if"/>

	<xsl:template match="*" mode="dl_if">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:p" mode="dl_if">
		<xsl:param name="indent"/>
		<mn:p>
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="$indent"/>
			<xsl:copy-of select="node()"/>
		</mn:p>
	</xsl:template>

	<xsl:template match="*[local-name() = 'ul' or local-name() = 'ol']" mode="dl_if">
		<xsl:variable name="list_rendered_">
			<xsl:apply-templates select="."/>
		</xsl:variable>
		<xsl:variable name="list_rendered" select="xalan:nodeset($list_rendered_)"/>

		<xsl:variable name="indent">
			<xsl:for-each select="($list_rendered//fo:block[not(.//fo:block)])[1]">
				<xsl:apply-templates select="ancestor::*[@provisional-distance-between-starts]/@provisional-distance-between-starts" mode="dl_if"/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="mn:li" mode="dl_if">
		<xsl:param name="indent"/>
		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="@provisional-distance-between-starts" mode="dl_if">
		<xsl:variable name="value" select="round(substring-before(.,'mm'))"/>
		<!-- emulate left indent for list item -->
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'x'"/>
			<xsl:with-param name="count" select="$value"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:dl" mode="dl_if_nested">
		<xsl:for-each select="mn:dt">
			<mn:p>
				<xsl:copy-of select="node()"/>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="following-sibling::mn:dd[1]/mn:p/node()"/>
			</mn:p>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if_nested"/>
	<!-- =============================== -->
	<!-- END mode="dl_if" -->
	<!-- =============================== -->
	<!-- ===================== -->
	<!-- END Definition List -->
	<!-- ===================== -->

	<xsl:attribute-set name="appendix-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="appendix-example-style">
	</xsl:attribute-set>

	<!-- ======================== -->
	<!-- Appendix processing -->
	<!-- ======================== -->
	<xsl:template match="mn:appendix">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="mn:fmt-title"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-title)]"/>
	</xsl:template>

	<xsl:template match="mn:appendix/mn:fmt-title" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:call-template name="setIDforNamedDestination"/><xsl:apply-templates/></fo:inline>
	</xsl:template>
	<!-- ======================== -->
	<!-- END Appendix processing -->
	<!-- ======================== -->

	<xsl:template match="mn:appendix//mn:example" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">
			<xsl:apply-templates select="mn:fmt-name"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
	</xsl:template>

	<xsl:attribute-set name="xref-style">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="mn:fmt-xref">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<xsl:variable name="alt_text">
					<xsl:call-template name="getAltText"/>
				</xsl:variable>
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{$alt_text}" xsl:use-attribute-sets="xref-style">
					<xsl:if test="string-length(normalize-space()) &lt; 30 and not(contains(normalize-space(), 'http://')) and not(contains(normalize-space(), 'https://')) and not(ancestor::*[self::mn:table or self::mn:dl])">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="parent::mn:add">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- xref -->

	<!-- command between two xref points to non-standard bibitem -->
	<xsl:template match="text()[. = ','][preceding-sibling::node()[1][self::mn:sup][mn:fmt-xref[@type = 'footnote']] and    following-sibling::node()[1][self::mn:sup][mn:fmt-xref[@type = 'footnote']]]"><xsl:value-of select="."/>
	</xsl:template>

	<xsl:attribute-set name="eref-style">
		<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_eref-style">
		<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
		<xsl:variable name="text" select="normalize-space()"/>
	</xsl:template> <!-- refine_eref-style -->

	<xsl:variable name="bibitems_">
		<xsl:for-each select="//mn:bibitem">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems" select="xalan:nodeset($bibitems_)"/>

	<!-- get all hidden bibitems to exclude them from eref/origin processing -->
	<xsl:variable name="bibitems_hidden_">
		<xsl:for-each select="//mn:bibitem[@hidden='true']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
		<xsl:for-each select="//mn:references[@hidden='true']//mn:bibitem">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems_hidden" select="xalan:nodeset($bibitems_hidden_)"/>
	<!-- ====== -->
	<!-- eref -->
	<!-- ====== -->
	<xsl:template match="mn:fmt-eref" name="eref">
		<xsl:variable name="current_bibitemid" select="@bibitemid"/>
		<!-- <xsl:variable name="external-destination" select="normalize-space(key('bibitems', $current_bibitemid)/mn:uri[@type = 'citation'])"/> -->
		<xsl:variable name="external-destination" select="normalize-space($bibitems/mn:bibitem[@id = $current_bibitemid]/mn:uri[@type = 'citation'])"/>
		<xsl:choose>
			<!-- <xsl:when test="$external-destination != '' or not(key('bibitems_hidden', $current_bibitemid))"> --> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
			<xsl:when test="$external-destination != '' or not($bibitems_hidden/mn:bibitem[@id = $current_bibitemid])"> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
						<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
						<xsl:attribute name="vertical-align">super</xsl:attribute>
						<xsl:attribute name="font-size">80%</xsl:attribute>
					</xsl:if>

					<xsl:call-template name="refine_eref-style"/>

					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link fox:alt-text="{@citeas}">
								<xsl:if test="normalize-space(@citeas) = ''">
									<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
								</xsl:if>
								<xsl:if test="@type = 'inline'">

									<xsl:call-template name="refine_basic_link_style"/>

								</xsl:if>

								<xsl:choose>
									<xsl:when test="$external-destination != ''"> <!-- external hyperlink -->
										<xsl:attribute name="external-destination"><xsl:value-of select="$external-destination"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="internal-destination"><xsl:value-of select="@bibitemid"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:apply-templates/>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise> <!-- if there is key('bibitems_hidden', $current_bibitemid) -->

				<!-- if in bibitem[@hidden='true'] there is url[@type='src'], then create hyperlink  -->
				<xsl:variable name="uri_src" select="normalize-space($bibitems_hidden/mn:bibitem[@id = $current_bibitemid]/mn:uri[@type = 'src'])"/>
				<xsl:choose>
					<xsl:when test="$uri_src != ''">
						<fo:basic-link external-destination="{$uri_src}" fox:alt-text="{$uri_src}"><xsl:apply-templates/></fo:basic-link>
					</xsl:when>
					<xsl:otherwise><fo:inline><xsl:apply-templates/></fo:inline></xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_basic_link_style">
	</xsl:template> <!-- refine_basic_link_style -->

	<!-- ====== -->
	<!-- END eref -->
	<!-- ====== -->

	<xsl:attribute-set name="note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="line-height">115%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_note-style">
	</xsl:template>

	<xsl:variable name="note-body-indent">10mm</xsl:variable>
	<xsl:variable name="note-body-indent-table">5mm</xsl:variable>

	<xsl:attribute-set name="note-name-style">
		<xsl:attribute name="padding-right">4mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_note-name-style">
	</xsl:template> <!-- refine_note-name-style -->

	<xsl:attribute-set name="table-note-name-style">
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_table-note-name-style">
	</xsl:template> <!-- refine_table-note-name-style -->

	<xsl:attribute-set name="note-p-style">
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="termnote-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_termnote-style">
	</xsl:template> <!-- refine_termnote-style -->

	<xsl:attribute-set name="termnote-name-style">
	</xsl:attribute-set>

	<xsl:template name="refine_termnote-name-style">
	</xsl:template>

	<xsl:attribute-set name="termnote-p-style">
	</xsl:attribute-set>

	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->

	<xsl:template match="mn:note" name="note">

		<xsl:call-template name="setNamedDestination"/>

		<fo:block-container xsl:use-attribute-sets="note-style" role="SKIP">
			<xsl:if test="not(parent::mn:references)">
				<xsl:copy-of select="@id"/>
			</xsl:if>

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_note-style"/>

			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
					<xsl:if test="ancestor::mn:ul or ancestor::mn:ol and not(ancestor::mn:note[1]/following-sibling::*)">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
						<fo:block>

							<xsl:call-template name="refine_note_block_style"/>

							<fo:inline xsl:use-attribute-sets="note-name-style" role="SKIP">

								<xsl:apply-templates select="mn:fmt-name/mn:tab" mode="tab"/>

								<xsl:call-template name="refine_note-name-style"/>

								<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
								<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
								<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
									<xsl:call-template name="append_add-style"/>
								</xsl:if>

								<!-- if note contains only one element and first and last childs are `add` ace-tag, then move start ace-tag before NOTE's name-->
								<xsl:if test="count(*[not(self::mn:fmt-name)]) = 1 and *[not(self::mn:fmt-name)]/node()[last()][self::mn:add][starts-with(text(), $ace_tag)]">
									<xsl:apply-templates select="*[not(self::mn:fmt-name)]/node()[1][self::mn:add][starts-with(text(), $ace_tag)]">
										<xsl:with-param name="skip">false</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>

								<xsl:apply-templates select="mn:fmt-name"/>

							</fo:inline>

							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
						</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="refine_note_block_style">
	</xsl:template> <!-- refine_note_block_style -->

	<xsl:template match="mn:note/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- display first NOTE's paragraph in the same line with label NOTE -->
				<fo:inline xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:termnote">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_termnote-style"/>

			<fo:inline xsl:use-attribute-sets="termnote-name-style">

				<xsl:call-template name="refine_termnote-name-style"/>

				<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
				<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
				<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>

				<xsl:apply-templates select="mn:fmt-name"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:note/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'iho' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'unece-rec' or $namespace = 'unece'  or $namespace = 'rsd'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termnote/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'jcgm'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece-rec' or $namespace = 'unece'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termnote/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- first paragraph renders in the same line as titlenote name -->
				<fo:inline xsl:use-attribute-sets="termnote-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="termnote-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-left">13mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_quote-style">
	</xsl:template>

	<xsl:attribute-set name="quote-source-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:attribute name="margin-right">25mm</xsl:attribute>
	</xsl:attribute-set>

	<!-- ====== -->
	<!-- quote -->
	<!-- source -->
	<!-- author  -->
	<!-- ====== -->
	<xsl:template match="mn:quote">
		<fo:block-container margin-left="0mm" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:if test="parent::mn:note">
				<xsl:if test="not(ancestor::mn:table)">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<fo:block-container xsl:use-attribute-sets="quote-style" role="SKIP">

					<xsl:call-template name="refine_quote-style"/>

					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block role="BlockQuote">
							<xsl:apply-templates select="./node()[not(self::mn:author) and         not(self::mn:fmt-source) and         not(self::mn:attribution)]"/> <!-- process all nested nodes, except author and source -->
						</fo:block>
					</fo:block-container>
				</fo:block-container>
				<xsl:if test="mn:author or mn:fmt-source or mn:attribution">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="mn:author"/>
						<xsl:apply-templates select="mn:fmt-source"/>
						<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:apply-templates select="mn:attribution/mn:p/node()"/>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:fmt-source">
		<xsl:if test="../mn:author">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="not(parent::quote)">
				<fo:block>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
								<xsl:apply-templates/>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
							<xsl:apply-templates/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:author">
		<xsl:if test="local-name(..) = 'quote'"> <!-- for old Presentation XML, https://github.com/metanorma/isodoc/issues/607 -->
			<xsl:text>— </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:quote//mn:referenceFrom"/>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:attribute-set name="figure-block-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_figure-block-style">
	</xsl:template>

	<xsl:attribute-set name="figure-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="space-after">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_figure-name-style">
	</xsl:template> <!-- refine_figure-name-style -->

	<xsl:attribute-set name="image-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_image-style">
	</xsl:template>

	<xsl:attribute-set name="image-graphic-style">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="content-height">100%</xsl:attribute>
		<xsl:attribute name="scaling">uniform</xsl:attribute>
		<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-source-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-pseudocode-p-style">
	</xsl:attribute-set>

	<!-- ============================ -->
	<!-- figure's footnotes rendering -->
	<!-- ============================ -->

	<!-- figure/fmt-footnote-container -->
	<xsl:template match="mn:figure//mn:fmt-footnote-container"/>

	<!-- TO DO: remove, now the figure fn in figure/dl/... https://github.com/metanorma/isodoc/issues/658 -->
	<xsl:template name="figure_fn_display">

		<xsl:variable name="references">
			<xsl:for-each select="./mn:fmt-footnote-container/mn:fmt-fn-body">
				<xsl:variable name="curr_id" select="@id"/>
				<!-- <curr_id><xsl:value-of select="$curr_id"/></curr_id>
				<curr><xsl:copy-of select="."/></curr>
				<ancestor><xsl:copy-of select="ancestor::mn:figure[.//mn:name[.//mn:fn]]"/></ancestor> -->
				<xsl:choose>
					<!-- skip figure/name/fn -->
					<xsl:when test="ancestor::mn:figure[.//mn:fmt-name[.//mn:fn[@target = $curr_id]]]"><!-- skip --></xsl:when>
					<xsl:otherwise>
						<xsl:element name="figure" namespace="{$namespace_full}">
							<xsl:element name="fmt-footnote-container" namespace="{$namespace_full}">
								<xsl:copy-of select="."/>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<!-- <references><xsl:copy-of select="$references"/></references> -->

		<xsl:if test="xalan:nodeset($references)//mn:fmt-fn-body">

			<xsl:variable name="key_iso">
			</xsl:variable>

			<fo:block>
				<!-- current hierarchy is 'figure' element -->
				<xsl:variable name="following_dl_colwidths">
					<xsl:if test="mn:dl"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
						<xsl:variable name="simple-table">
							<!-- <xsl:variable name="doc_ns">
								<xsl:if test="$namespace = 'bipm'">bipm</xsl:if>
							</xsl:variable>
							<xsl:variable name="ns">
								<xsl:choose>
									<xsl:when test="normalize-space($doc_ns)  != ''">
										<xsl:value-of select="normalize-space($doc_ns)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring-before(name(/*), '-')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable> -->

							<xsl:for-each select="mn:dl[1]">
								<mn:tbody>
									<xsl:apply-templates mode="dl"/>
								</mn:tbody>
							</xsl:for-each>
						</xsl:variable>

						<xsl:call-template name="calculate-column-widths">
							<xsl:with-param name="cols-count" select="2"/>
							<xsl:with-param name="table" select="$simple-table"/>
						</xsl:call-template>

					</xsl:if>
				</xsl:variable>

				<xsl:variable name="maxlength_dt">
					<xsl:for-each select="mn:dl[1]">
						<xsl:call-template name="getMaxLength_dt"/>
					</xsl:for-each>
				</xsl:variable>

				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="5%"/>
							<fo:table-column column-width="95%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<!-- <xsl:for-each select="xalan:nodeset($references)//fn"> -->
						<xsl:for-each select="xalan:nodeset($references)//mn:fmt-fn-body">

							<xsl:variable name="reference" select="@reference"/>
							<!-- <xsl:if test="not(preceding-sibling::*[@reference = $reference])"> --> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline id="{@id}" xsl:use-attribute-sets="figure-fmt-fn-label-style">
												<!-- <xsl:attribute name="padding-right">0mm</xsl:attribute> -->
												<!-- <xsl:value-of select="@reference"/> -->
												<xsl:value-of select="normalize-space(.//mn:fmt-fn-label)"/>
											</fo:inline>

										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block xsl:use-attribute-sets="figure-fn-body-style">
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											<!-- <xsl:copy-of select="./node()"/> -->
											<xsl:apply-templates/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							<!-- </xsl:if> -->
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
	</xsl:template> <!-- figure_fn_display -->

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="figure-fn-number-style" role="SKIP">
				<xsl:attribute name="padding-right">0mm</xsl:attribute>

				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates/>

			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  figure//fmt-fn-body//fmt-fn-label -->

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">

		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="figure-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_figure-fmt-fn-label-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
	<!-- figure's footnote label -->
	<!-- figure/dl[@key = 'true']/dt/p/sup -->
	<xsl:template match="mn:figure/mn:dl[@key = 'true']/mn:dt/     mn:p[count(node()[normalize-space() != '']) = 1]/mn:sup" priority="3">
		<xsl:variable name="key_iso">
		</xsl:variable>
		<xsl:if test="normalize-space($key_iso) = 'true'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<fo:inline xsl:use-attribute-sets="figure-fn-number-style figure-fmt-fn-label-style"> <!-- id="{@id}"  -->
			<!-- <xsl:value-of select="@reference"/> -->
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ============================ -->
	<!-- END: figure's footnotes rendering -->
	<!-- ============================ -->

	<!-- caption for figure key and another caption, https://github.com/metanorma/isodoc/issues/607 -->
	<xsl:template match="mn:figure/mn:p[@keep-with-next = 'true' and mn:strong]" priority="3">
		<fo:block text-align="left" margin-bottom="12pt" keep-with-next="always" keep-with-previous="always">
			<xsl:call-template name="refine_figure_key_style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_figure_key_style">
	</xsl:template> <!-- refine_figure_key_style -->

	<!-- ====== -->
	<!-- figure    -->
	<!-- image    -->
	<!-- ====== -->

	<xsl:template match="mn:figure" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="figure-block-style">
			<xsl:call-template name="refine_figure-block-style"/>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<!-- Example: Dimensions in millimeters -->
			<xsl:apply-templates select="mn:note[@type = 'units']"/>

			<xsl:variable name="show_figure_key_in_block_container">true
			</xsl:variable>

			<fo:block xsl:use-attribute-sets="figure-style" role="SKIP">

				<xsl:for-each select="mn:fmt-name"> <!-- set context -->
					<xsl:call-template name="setIDforNamedDestination"/>
				</xsl:for-each>

				<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:note and @type = 'units')]"/>
			</fo:block>

			<xsl:if test="normalize-space($show_figure_key_in_block_container) = 'true'">
				<xsl:call-template name="showFigureKey"/>
			</xsl:if>
			<xsl:apply-templates select="mn:fmt-name"/> <!-- show figure's name AFTER image -->

		</fo:block-container>
	</xsl:template>

	<xsl:template name="showFigureKey">
		<xsl:for-each select="*[(self::mn:note and not(@type = 'units')) or self::mn:example]">
			<xsl:choose>
				<xsl:when test="self::mn:note">
					<xsl:call-template name="note"/>
				</xsl:when>
				<xsl:when test="self::mn:example">
					<xsl:call-template name="example"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- TO DO: remove, now the figure fn in figure/dl/... https://github.com/metanorma/isodoc/issues/658 -->
		<xsl:call-template name="figure_fn_display"/>
	</xsl:template>

	<xsl:template match="mn:figure[@class = 'pseudocode']">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
		<xsl:apply-templates select="mn:fmt-name"/>
	</xsl:template>

	<xsl:template match="mn:figure[@class = 'pseudocode']//mn:p">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- SOURCE: ... -->
	<!-- figure/source -->
	<xsl:template match="mn:figure/mn:fmt-source" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>

	<xsl:template match="mn:image">
		<xsl:param name="indent">0</xsl:param>
		<xsl:param name="logo_width"/>
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::mn:fmt-title or not(parent::mn:figure) or parent::mn:p"> <!-- inline image ( 'image:path' in adoc, with one colon after image) -->
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:if test="not(parent::mn:figure) or parent::mn:p">
						<xsl:attribute name="padding-left">0mm</xsl:attribute>
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:call-template name="getImageScale">
							<xsl:with-param name="indent" select="$indent"/>
						</xsl:call-template>
					</xsl:variable>

					<!-- debug scale='<xsl:value-of select="$scale"/>', indent='<xsl:value-of select="$indent"/>' -->

					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle">

						<xsl:if test="parent::mn:logo"> <!-- publisher's logo -->
							<xsl:attribute name="scaling">uniform</xsl:attribute>
							<xsl:choose>
								<xsl:when test="@width and not(@height)">
									<xsl:attribute name="width">100%</xsl:attribute>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:when>
								<xsl:when test="@height and not(@width)">
									<xsl:attribute name="height">100%</xsl:attribute>
									<xsl:attribute name="content-height"><xsl:value-of select="@height"/></xsl:attribute>
								</xsl:when>
								<xsl:when test="not(@width) and not(@height)">
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:when>
							</xsl:choose>

							<xsl:if test="normalize-space($logo_width) != ''">
								<xsl:attribute name="width"><xsl:value-of select="$logo_width"/></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
							<xsl:attribute name="vertical-align">top</xsl:attribute>
						</xsl:if>

						<xsl:variable name="width">
							<xsl:call-template name="setImageWidth"/>
						</xsl:variable>
						<xsl:if test="$width != ''">
							<xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="height">
							<xsl:call-template name="setImageHeight"/>
						</xsl:variable>
						<xsl:if test="$height != ''">
							<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
						</xsl:if>

						<xsl:if test="$width = '' and $height = ''">
							<xsl:if test="number($scale) &lt; 100">
								<xsl:attribute name="content-width"><xsl:value-of select="number($scale)"/>%</xsl:attribute>
								<!-- <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute> -->
							</xsl:if>
						</xsl:if>

					</fo:external-graphic>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">

					<xsl:call-template name="refine_image-style"/>

					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$isDeleted = 'true'">
							<!-- enclose in svg -->
							<fo:instream-foreign-object fox:alt-text="Image {@alt}">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute>

								<xsl:apply-templates select="." mode="cross_image"/>

							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:otherwise>
							<!-- <fo:block>debug block image:
							<xsl:variable name="scale">
								<xsl:call-template name="getImageScale">
									<xsl:with-param name="indent" select="$indent"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="concat('scale=', $scale,', indent=', $indent)"/>
							</fo:block> -->

							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}">

								<xsl:choose>
									<!-- default -->
									<xsl:when test="((@width = 'auto' or @width = 'text-width' or @width = 'full-page-width' or @width = 'narrow') and @height = 'auto') or            (normalize-space(@width) = '' and normalize-space(@height) = '') ">
										<!-- add attribute for automatic scaling -->
										<xsl:variable name="image-graphic-style_attributes">
											<attributes xsl:use-attribute-sets="image-graphic-style"/>
										</xsl:variable>
										<xsl:copy-of select="xalan:nodeset($image-graphic-style_attributes)/attributes/@*"/>

										<xsl:if test="not(@mimetype = 'image/svg+xml') and not(ancestor::mn:table)">
											<xsl:variable name="scale">
												<xsl:call-template name="getImageScale">
													<xsl:with-param name="indent" select="$indent"/>
												</xsl:call-template>
											</xsl:variable>

											<xsl:variable name="scaleRatio">1
											</xsl:variable>

											<xsl:if test="number($scale) &lt; 100">
												<xsl:attribute name="content-width"><xsl:value-of select="number($scale) * number($scaleRatio)"/>%</xsl:attribute>
											</xsl:if>
										</xsl:if>

									</xsl:when> <!-- default -->
									<xsl:otherwise>

										<xsl:variable name="width_height_">
											<attributes>
												<xsl:call-template name="setImageWidthHeight"/>
											</attributes>
										</xsl:variable>
										<xsl:variable name="width_height" select="xalan:nodeset($width_height_)"/>

										<xsl:copy-of select="$width_height/attributes/@*"/>

										<xsl:if test="$width_height/attributes/@content-width != '' and             $width_height/attributes/@content-height != ''">
											<xsl:attribute name="scaling">non-uniform</xsl:attribute>
										</xsl:if>

									</xsl:otherwise>
								</xsl:choose>

								<!-- 
								<xsl:if test="not(@mimetype = 'image/svg+xml') and (../mn:name or parent::mn:figure[@unnumbered = 'true']) and not(ancestor::mn:table)">
								-->

							</fo:external-graphic>
						</xsl:otherwise>
					</xsl:choose>

				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setImageWidth">
		<xsl:if test="@width != '' and @width != 'auto' and @width != 'text-width' and @width != 'full-page-width' and @width != 'narrow'">
			<xsl:value-of select="@width"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageHeight">
		<xsl:if test="@height != '' and @height != 'auto'">
			<xsl:value-of select="@height"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageWidthHeight">
		<xsl:variable name="width">
			<xsl:call-template name="setImageWidth"/>
		</xsl:variable>
		<xsl:if test="$width != ''">
			<xsl:attribute name="content-width">
				<xsl:value-of select="$width"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:variable name="height">
			<xsl:call-template name="setImageHeight"/>
		</xsl:variable>
		<xsl:if test="$height != ''">
			<xsl:attribute name="content-height">
				<xsl:value-of select="$height"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getImageSrc">
		<xsl:choose>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:call-template name="getImageSrcExternal"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getImageSrcExternal">
		<xsl:choose>
			<xsl:when test="@extracted = 'true'"> <!-- added in mn2pdf v1.97 -->
				<xsl:value-of select="@src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_with_basepath" select="concat($basepath, @src)"/>
				<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($src_with_basepath)))"/>
				<xsl:choose>
					<xsl:when test="$file_exists = 'true'">
						<xsl:value-of select="$src_with_basepath"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getImageScale">
		<xsl:param name="indent"/>
		<xsl:variable name="indent_left">
			<xsl:choose>
				<xsl:when test="$indent != ''"><xsl:value-of select="$indent"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="img_src">
			<xsl:call-template name="getImageSrc"/>
		</xsl:variable>

		<xsl:variable name="image_width_effective">
			<xsl:value-of select="$width_effective - number($indent_left)"/>
		</xsl:variable>
		<xsl:variable name="image_height_effective" select="$height_effective - number($indent_left)"/>
		<!-- <xsl:message>width_effective=<xsl:value-of select="$width_effective"/></xsl:message>
		<xsl:message>indent_left=<xsl:value-of select="$indent_left"/></xsl:message>
		<xsl:message>image_width_effective=<xsl:value-of select="$image_width_effective"/></xsl:message> --> <!--  for <xsl:value-of select="ancestor::mn:p[1]/@id"/> -->
		<xsl:variable name="scale">
			<xsl:value-of select="java:org.metanorma.fop.utils.ImageUtils.getImageScale($img_src, $image_width_effective, $height_effective)"/>
		</xsl:variable>
		<!-- <xsl:message>scale=<xsl:value-of select="$scale"/></xsl:message> -->
		<xsl:value-of select="$scale"/>
	</xsl:template>

	<xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<!-- in WebP format, then convert image into PNG -->
			<xsl:when test="starts-with(@src, 'data:image/webp')">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="$src_png"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:')) and        (java:endsWith(java:java.lang.String.new(@src), '.webp') or       java:endsWith(java:java.lang.String.new(@src), '.WEBP'))">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="concat('url(file:///',$basepath, $src_png, ')')"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:variable name="file_protocol"><xsl:if test="not(starts-with($src_external, 'http:')) and not(starts-with($src_external, 'https:')) and not(starts-with($src_external, 'www.'))">file:///</xsl:if></xsl:variable>
				<xsl:value-of select="concat('url(', $file_protocol, $src_external, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:image" mode="cross_image">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:variable name="src">
					<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
				</xsl:variable>
				<xsl:variable name="width" select="document($src)/@width"/>
				<xsl:variable name="height" select="document($src)/@height"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:variable name="src" select="concat('url(file:///', $src_external, ')')"/>
				<xsl:variable name="file" select="java:java.io.File.new(@src)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="base64String" select="substring-after(@src, 'base64,')"/>
				<xsl:variable name="decoder" select="java:java.util.Base64.getDecoder()"/>
				<xsl:variable name="fileContent" select="java:decode($decoder, $base64String)"/>
				<xsl:variable name="bis" select="java:java.io.ByteArrayInputStream.new($fileContent)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($bis)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
	</xsl:template>

	<!-- =================== -->
	<!-- SVG images processing -->
	<!-- =================== -->
	<xsl:variable name="figure_name_height">14</xsl:variable>
	<xsl:variable name="width_effective" select="$pageWidth - $marginLeftRight1 - $marginLeftRight2"/><!-- paper width minus margins -->
	<xsl:variable name="height_effective" select="$pageHeight - $marginTop - $marginBottom - $figure_name_height"/><!-- paper height minus margins and title height -->
	<xsl:variable name="image_dpi" select="96"/>
	<xsl:variable name="width_effective_px" select="$width_effective div 25.4 * $image_dpi"/>
	<xsl:variable name="height_effective_px" select="$height_effective div 25.4 * $image_dpi"/>

	<xsl:template match="mn:figure[not(mn:image) and *[local-name() = 'svg']]/mn:fmt-name/mn:bookmark" priority="2"/>
	<xsl:template match="mn:figure[not(mn:image)]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>

		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>

		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../mn:fmt-name) != ''">
					<xsl:value-of select="../mn:fmt-name"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isPrecedingTitle" select="normalize-space(ancestor::mn:figure/preceding-sibling::*[1][self::mn:fmt-title] and 1 = 1)"/>

		<xsl:choose>
			<xsl:when test=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]">
				<fo:block>
					<xsl:variable name="width" select="@width"/>
					<xsl:variable name="height" select="@height"/>

					<xsl:variable name="scale_x">
						<xsl:choose>
							<xsl:when test="$width &gt; $width_effective_px">
								<xsl:value-of select="$width_effective_px div $width"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale_y">
						<xsl:choose>
							<xsl:when test="$height * $scale_x &gt; $height_effective_px">
								<xsl:value-of select="$height_effective_px div ($height * $scale_x)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:choose>
							<xsl:when test="$scale_y != 1">
								<xsl:value-of select="$scale_x * $scale_y"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scale_x"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="width_scale" select="round($width * $scale)"/>
					<xsl:variable name="height_scale" select="round($height * $scale)"/>

					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{$width_scale}px"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block>
										<fo:block-container width="{$width_scale}px" height="{$height_scale}px">
											<xsl:if test="../mn:fmt-name/mn:bookmark">
												<fo:block line-height="0" font-size="0">
													<xsl:for-each select="../mn:fmt-name/mn:bookmark">
														<xsl:call-template name="bookmark"/>
													</xsl:for-each>
												</fo:block>
											</xsl:if>
											<fo:block text-depth="0" line-height="0" font-size="0">

												<fo:instream-foreign-object fox:alt-text="{$alt-text}">
													<xsl:attribute name="width">100%</xsl:attribute>
													<xsl:attribute name="content-height">100%</xsl:attribute>
													<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
													<xsl:attribute name="scaling">uniform</xsl:attribute>

													<xsl:apply-templates select="xalan:nodeset($svg_content)" mode="svg_remove_a"/>
												</fo:instream-foreign-object>
											</fo:block>

											<xsl:apply-templates select=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]" mode="svg_imagemap_links">
												<xsl:with-param name="scale" select="$scale"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>

			</xsl:when>
			<xsl:otherwise>

				<xsl:variable name="image_class" select="ancestor::mn:image/@class"/>
				<xsl:variable name="ancestor_table_cell" select="normalize-space(ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])"/>

				<xsl:variable name="element">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'tr'] and $isGenerateTableIF = 'true'">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:when test="not(ancestor::mn:figure)">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:block xsl:use-attribute-sets="image-style">
								<xsl:if test="ancestor::mn:dt">
									<xsl:attribute name="text-align">left</xsl:attribute>
								</xsl:if>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($element)/*">
					<xsl:copy>
						<xsl:copy-of select="@*"/>
					<!-- <fo:block xsl:use-attribute-sets="image-style"> -->
						<fo:instream-foreign-object fox:alt-text="{$alt-text}">

							<xsl:choose>
								<xsl:when test="$image_class = 'corrigenda-tag'">
									<xsl:attribute name="fox:alt-text">CorrigendaTag</xsl:attribute>
									<xsl:attribute name="baseline-shift">-10%</xsl:attribute>
									<xsl:if test="$ancestor_table_cell = 'true'">
										<xsl:attribute name="baseline-shift">-25%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="height">3.5mm</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$isGenerateTableIF = 'false'">
										<xsl:attribute name="width">100%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
							<xsl:variable name="svg_width_" select="xalan:nodeset($svg_content)/*/@width"/>
							<xsl:variable name="svg_width" select="number(translate($svg_width_, 'px', ''))"/>
							<xsl:variable name="svg_height_" select="xalan:nodeset($svg_content)/*/@height"/>
							<xsl:variable name="svg_height" select="number(translate($svg_height_, 'px', ''))"/>

							<!-- Example: -->
							<!-- effective height 297 - 27.4 - 13 =  256.6 -->
							<!-- effective width 210 - 12.5 - 25 = 172.5 -->
							<!-- effective height / width = 1.48, 1.4 - with title -->

							<xsl:variable name="scale_x">
								<xsl:choose>
									<xsl:when test="$svg_width &gt; $width_effective_px">
										<xsl:value-of select="$width_effective_px div $svg_width"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="scale_y">
								<xsl:choose>
									<xsl:when test="$svg_height * $scale_x &gt; $height_effective_px">
										<xsl:variable name="height_effective_px_">
											<xsl:choose>
												<!-- title is 'keep-with-next' with following figure -->
												<xsl:when test="$isPrecedingTitle = 'true'"><xsl:value-of select="$height_effective_px - 80"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="$height_effective_px"/></xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:value-of select="$height_effective_px_ div ($svg_height * $scale_x)"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							 <!-- for images with big height -->
							<!-- <xsl:if test="$svg_height &gt; ($svg_width * 1.4)">
								<xsl:variable name="width" select="(($svg_width * 1.4) div $svg_height) * 100"/>
								<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
							</xsl:if> -->
							<xsl:attribute name="scaling">uniform</xsl:attribute>

							<xsl:if test="$scale_y != 1">
								<xsl:attribute name="content-height"><xsl:value-of select="round($scale_x * $scale_y * 100)"/>%</xsl:attribute>
							</xsl:if>

							<xsl:copy-of select="$svg_content"/>
						</fo:instream-foreign-object>
					<!-- </fo:block> -->
					</xsl:copy>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============== -->
	<!-- svg_update     -->
	<!-- ============== -->
	<xsl:template match="@*|node()" mode="svg_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:image/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:variable name="regex_starts_with_digit">^[0-9].*</xsl:variable>

	<xsl:template match="*[local-name() = 'svg'][not(@width and @height)]" mode="svg_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="svg_update"/>
			<xsl:variable name="viewbox_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@viewBox"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="viewbox" select="xalan:nodeset($viewbox_)"/>
			<xsl:variable name="width" select="normalize-space($viewbox//mnx:item[3])"/>
			<xsl:variable name="height" select="normalize-space($viewbox//mnx:item[4])"/>

			<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[1][self::mn:image]/@width)"/>
			<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[1][self::mn:image]/@height)"/>

			<xsl:attribute name="width">
				<xsl:choose>
					<!-- width is non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
					<xsl:when test="$width != ''">
						<xsl:value-of select="round($width)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default width -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<!-- height non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
					<xsl:when test="$height != ''">
						<xsl:value-of select="round($height)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default height -->
				</xsl:choose>
			</xsl:attribute>

			<xsl:apply-templates mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@width" mode="svg_update">
		<!-- image[@width]/svg -->
		<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[2][self::mn:image]/@width)"/>
		<xsl:attribute name="width">
			<xsl:choose>
				<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@height" mode="svg_update">
		<!-- image[@height]/svg -->
		<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[2][self::mn:image]/@height)"/>
		<xsl:attribute name="height">
			<xsl:choose>
				<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<!-- regex for 'display: inline-block;' -->
	<xsl:variable name="regex_svg_style_notsupported">display(\s|\h)*:(\s|\h)*inline-block(\s|\h)*;</xsl:variable>
	<xsl:template match="*[local-name() = 'svg']//*[local-name() = 'style']/text()" mode="svg_update">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), $regex_svg_style_notsupported, '')"/>
	</xsl:template>

	<!-- replace
			stroke="rgba(r, g, b, alpha)" to 
			stroke="rgb(r,g,b)" stroke-opacity="alpha", and
			fill="rgba(r, g, b, alpha)" to 
			fill="rgb(r,g,b)" fill-opacity="alpha" -->
	<xsl:template match="@*[local-name() = 'stroke' or local-name() = 'fill'][starts-with(normalize-space(.), 'rgba')]" mode="svg_update">
		<xsl:variable name="components_">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-before(substring-after(., '('), ')')"/>
				<xsl:with-param name="sep" select="','"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="components" select="xalan:nodeset($components_)"/>
		<xsl:variable name="att_name" select="local-name()"/>
		<xsl:attribute name="{$att_name}"><xsl:value-of select="concat('rgb(', $components/mnx:item[1], ',', $components/mnx:item[2], ',', $components/mnx:item[3], ')')"/></xsl:attribute>
		<xsl:attribute name="{$att_name}-opacity"><xsl:value-of select="$components/mnx:item[4]"/></xsl:attribute>
	</xsl:template>

	<!-- ============== -->
	<!-- END: svg_update -->
	<!-- ============== -->

	<!-- image with svg and emf -->
	<xsl:template match="mn:figure/mn:image[*[local-name() = 'svg']]" priority="3">
		<xsl:variable name="name" select="ancestor::mn:figure/mn:fmt-name"/>
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- For the structures like: <dt><image src="" mimetype="image/svg+xml" height="" width=""><svg xmlns="http://www.w3.org/2000/svg" ... -->
	<xsl:template match="*[not(self::mn:figure)]/mn:image[*[local-name() = 'svg']]" priority="3">
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:figure/mn:image[@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::mn:figure/mn:fmt-name"/>
		<xsl:for-each select="xalan:nodeset($svg_content)/node()">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="@*|node()" mode="svg_remove_a">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_remove_a"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_remove_a">
		<xsl:apply-templates mode="svg_remove_a"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_imagemap_links">
		<xsl:param name="scale"/>
		<xsl:variable name="dest">
			<xsl:choose>
				<xsl:when test="starts-with(@href, '#')">
					<xsl:value-of select="substring-after(@href, '#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="./*[local-name() = 'rect']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor(@x * $scale)"/>
				<xsl:with-param name="top" select="floor(@y * $scale)"/>
				<xsl:with-param name="width" select="floor(@width * $scale)"/>
				<xsl:with-param name="height" select="floor(@height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'polygon']">
			<xsl:variable name="points">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@points"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="x_coords">
				<xsl:for-each select="xalan:nodeset($points)//mnx:item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//mnx:item[position() mod 2 = 0]">
					<xsl:sort select="." data-type="number"/>
					<y><xsl:value-of select="."/></y>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="x" select="xalan:nodeset($x_coords)//x[1]"/>
			<xsl:variable name="y" select="xalan:nodeset($y_coords)//y[1]"/>
			<xsl:variable name="width" select="xalan:nodeset($x_coords)//x[last()] - $x"/>
			<xsl:variable name="height" select="xalan:nodeset($y_coords)//y[last()] - $y"/>
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor($x * $scale)"/>
				<xsl:with-param name="top" select="floor($y * $scale)"/>
				<xsl:with-param name="width" select="floor($width * $scale)"/>
				<xsl:with-param name="height" select="floor($height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'circle']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @r) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @r) * $scale)"/>
				<xsl:with-param name="width" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="./*[local-name() = 'ellipse']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @rx) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @ry) * $scale)"/>
				<xsl:with-param name="width" select="floor(@rx * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@ry * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertSVGMapLink">
		<xsl:param name="left"/>
		<xsl:param name="top"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="dest"/>
		<fo:block-container position="absolute" left="{$left}px" top="{$top}px" width="{$width}px" height="{$height}px">
		 <fo:block font-size="1pt">
			<xsl:call-template name="insert_basic_link">
				<xsl:with-param name="element">
					<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
						<fo:inline-container inline-progression-dimension="100%">
							<fo:block-container height="{$height - 1}px" width="100%">
								<!-- DEBUG <xsl:if test="local-name()='polygon'">
									<xsl:attribute name="background-color">magenta</xsl:attribute>
								</xsl:if> -->
							<fo:block> </fo:block></fo:block-container>
						</fo:inline-container>
					</fo:basic-link>
				</xsl:with-param>
			</xsl:call-template>
		 </fo:block>
	  </fo:block-container>
	</xsl:template>
	<!-- =================== -->
	<!-- End SVG images processing -->
	<!-- =================== -->

	<!-- ignore emf processing (Apache FOP doesn't support EMF) -->
	<xsl:template match="mn:emf"/>

	<!-- figure/name -->
	<xsl:template match="mn:figure/mn:fmt-name |         mn:image/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="figure-name-style">

				<xsl:call-template name="refine_figure-name-style"/>

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<!-- figure/fn -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:fn" priority="2"/>
	<!-- figure/note -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:note" priority="2"/>
	<!-- figure/example -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:example" priority="2"/>

	<!-- figure/note[@type = 'units'] -->
	<!-- image/note[@type = 'units'] -->
	<xsl:template match="mn:figure/mn:note[@type = 'units'] |         mn:image/mn:note[@type = 'units']" priority="2">
		<fo:block text-align="right" keep-with-next="always">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Formula's styles -->
	<xsl:attribute-set name="formula-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- formula-style -->

	<xsl:attribute-set name="formula-stem-block-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="margin-left">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- formula-stem-block-style -->

	<xsl:template name="refine_formula-stem-block-style">
	</xsl:template> <!-- refine_formula-stem-block-style -->

	<xsl:attribute-set name="formula-stem-number-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
	</xsl:attribute-set> <!-- formula-stem-number-style -->
	<!-- End Formula's styles -->

	<xsl:template name="refine_formula-stem-number-style">
	</xsl:template>

	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_mathml-style">
	</xsl:template>

	<!-- ====== -->
	<!-- formula  -->
	<!-- ====== -->
	<xsl:template match="mn:formula" name="formula">
		<fo:block-container margin-left="0mm" role="SKIP">
			<xsl:if test="parent::mn:note">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<xsl:call-template name="setNamedDestination"/>
				<fo:block id="{@id}">
					<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/> <!-- formula's number will be process in 'stem' template -->
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:formula/mn:dt/mn:fmt-stem">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-admitted/mn:fmt-stem">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:formula/mn:fmt-name"> <!-- show in 'stem' template -->
		<!-- https://github.com/metanorma/isodoc/issues/607 
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:if> -->
		<xsl:apply-templates/>
	</xsl:template>

	<!-- stem inside formula with name (with formula's number) -->
	<xsl:template match="mn:formula[mn:fmt-name]/mn:fmt-stem">
		<fo:block xsl:use-attribute-sets="formula-style">

			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-block-style" role="SKIP">

								<xsl:call-template name="refine_formula-stem-block-style"/>

								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">

							<fo:block xsl:use-attribute-sets="formula-stem-number-style" role="SKIP">

								<xsl:for-each select="../mn:fmt-name">
									<xsl:call-template name="setIDforNamedDestination"/>
								</xsl:for-each>

								<xsl:call-template name="refine_formula-stem-number-style"/>

								<xsl:apply-templates select="../mn:fmt-name"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!-- stem inside formula without name (without formula's number) -->
	<xsl:template match="mn:formula[not(mn:fmt-name)]/mn:fmt-stem">
		<fo:block xsl:use-attribute-sets="formula-style">
			<fo:block xsl:use-attribute-sets="formula-stem-block-style">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- ignore 'p' with 'where' in formula, before 'dl' -->
	<xsl:template match="mn:formula/*[self::mn:p and @keep-with-next = 'true' and following-sibling::*[1][self::mn:dl]]"/>

	<!-- ======================================= -->
	<!-- math -->
	<!-- ======================================= -->
	<xsl:template match="mn:stem[following-sibling::*[1][self::mn:fmt-stem]]"/> <!-- for tablesonly.xml generated by mn2pdf -->

	<xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<fo:inline xsl:use-attribute-sets="mathml-style">

			<!-- DEBUG -->
			<!-- <xsl:copy-of select="ancestor::mn:stem/@font-family"/> -->

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:if test="$isGenerateTableIF = 'true' and ancestor::*[local-name() = 'td' or local-name() = 'th' or local-name() = 'dl'] and not(following-sibling::node()[not(self::comment())][normalize-space() != ''])"> <!-- math in table cell, and math is last element -->
				<!-- <xsl:attribute name="padding-right">1mm</xsl:attribute> -->
			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<xsl:if test="$add_math_as_text = 'true'">
				<!-- insert helper tag -->
				<!-- set unique font-size (fiction) -->
				<xsl:variable name="font-size_sfx"><xsl:number level="any"/></xsl:variable>
				<fo:inline color="white" font-size="1.{$font-size_sfx}pt" font-style="normal" font-weight="normal"><xsl:value-of select="$zero_width_space"/></fo:inline> <!-- zero width space -->
			</xsl:if>

			<xsl:variable name="mathml_content">
				<xsl:apply-templates select="." mode="mathml_actual_text"/>
			</xsl:variable>
			<xsl:call-template name="mathml_instream_object">
				<xsl:with-param name="mathml_content" select="$mathml_content"/>
			</xsl:call-template>

		</fo:inline>
	</xsl:template>

	<xsl:template name="getMathml_comment_text">
		<xsl:variable name="comment_text_following" select="following-sibling::node()[1][self::comment()]"/>
		<xsl:variable name="comment_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($comment_text_following) != ''">
					<xsl:value-of select="$comment_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="comment_text_2" select="java:org.metanorma.fop.Util.unescape($comment_text_)"/>
		<xsl:variable name="comment_text" select="java:trim(java:java.lang.String.new($comment_text_2))"/>
		<xsl:value-of select="$comment_text"/>
	</xsl:template>

	<xsl:template match="mn:asciimath">
		<xsl:param name="process" select="'false'"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:latexmath"/>

	<xsl:template name="getMathml_asciimath_text">
		<xsl:variable name="asciimath" select="../mn:asciimath"/>
		<xsl:variable name="latexmath">
		</xsl:variable>
		<xsl:variable name="asciimath_text_following">
			<xsl:choose>
				<xsl:when test="normalize-space($latexmath) != ''">
					<xsl:value-of select="$latexmath"/>
				</xsl:when>
				<xsl:when test="normalize-space($asciimath) != ''">
					<xsl:value-of select="$asciimath"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="following-sibling::node()[1][self::comment()]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text_following) != ''">
					<xsl:value-of select="$asciimath_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_2" select="java:org.metanorma.fop.Util.unescape($asciimath_text_)"/>
		<xsl:variable name="asciimath_text" select="java:trim(java:java.lang.String.new($asciimath_text_2))"/>
		<xsl:value-of select="$asciimath_text"/>
	</xsl:template>

	<xsl:template name="mathml_instream_object">
		<xsl:param name="asciimath_text"/>
		<xsl:param name="mathml_content"/>

		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text) != ''"><xsl:value-of select="$asciimath_text"/></xsl:when>
				<!-- <xsl:otherwise><xsl:call-template name="getMathml_comment_text"/></xsl:otherwise> -->
				<xsl:otherwise><xsl:call-template name="getMathml_asciimath_text"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mathml">
			<xsl:apply-templates select="." mode="mathml"/>
		</xsl:variable>

		<fo:instream-foreign-object fox:alt-text="Math" fox:actual-text="Math">

			<xsl:call-template name="refine_mathml_insteam_object_style"/>

			<xsl:if test="$isGenerateTableIF = 'false'">
				<!-- put MathML in Actual Text -->
				<!-- DEBUG: mathml_content=<xsl:value-of select="$mathml_content"/> -->
				<xsl:attribute name="fox:actual-text">
					<xsl:value-of select="$mathml_content"/>
				</xsl:attribute>

				<!-- <xsl:if test="$add_math_as_text = 'true'"> -->
				<xsl:if test="normalize-space($asciimath_text_) != ''">
				<!-- put Mathin Alternate Text -->
					<xsl:attribute name="fox:alt-text">
						<xsl:value-of select="$asciimath_text_"/>
					</xsl:attribute>
				</xsl:if>
				<!-- </xsl:if> -->
			</xsl:if>

			<xsl:copy-of select="xalan:nodeset($mathml)"/>

		</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template name="refine_mathml_insteam_object_style">
	</xsl:template> <!-- refine_mathml_insteam_object_style -->

	<xsl:template match="mathml:*" mode="mathml_actual_text">
		<!-- <xsl:text>a+b</xsl:text> -->
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:if test="local-name() = 'math'">
			<xsl:text> xmlns="http://www.w3.org/1998/Math/MathML"</xsl:text>
		</xsl:if>
		<xsl:for-each select="@*">
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates mode="mathml_actual_text"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="text()" mode="mathml_actual_text">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template>

	<!-- <xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = '&#xa0;'])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<xsl:choose>
			if in msub, then don't add space
			<xsl:when test="ancestor::mathml:mrow[parent::mathml:msub and preceding-sibling::*[1][self::mathml:mrow]]"></xsl:when>
			if next char in digit,  don't add space
			<xsl:when test="translate(substring(following-sibling::*[1]/text(),1,1),'0123456789','') = ''"></xsl:when>
			<xsl:otherwise>
				<mathml:mspace width="0.5ex"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/>

	<!-- patch: slash in the mtd wrong rendering -->
	<xsl:template match="mathml:mtd/mathml:mo/text()[. = '/']" mode="mathml">
		<xsl:value-of select="."/><xsl:value-of select="$zero_width_space"/>
	</xsl:template>

	<!-- special case for:
		<math xmlns="http://www.w3.org/1998/Math/MathML">
			<mstyle displaystyle="true">
				<msup>
					<mi color="#00000000">C</mi>
					<mtext>R</mtext>
				</msup>
				<msubsup>
					<mtext>C</mtext>
					<mi>n</mi>
					<mi>k</mi>
				</msubsup>
			</mstyle>
		</math>
	-->
	<xsl:template match="mathml:msup/mathml:mi[. = '‌' or . = ''][not(preceding-sibling::*)][following-sibling::mathml:mtext]" mode="mathml">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="next_mtext" select="ancestor::mathml:msup/following-sibling::*[1][self::mathml:msubsup or self::mathml:msub or self::mathml:msup]/mathml:mtext"/>
			<xsl:if test="string-length($next_mtext) != ''">
				<xsl:attribute name="color">#00000000</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:value-of select="$next_mtext"/>
		</xsl:copy>
	</xsl:template>

	<!-- special case for:
				<msup>
					<mtext/>
					<mn>1</mn>
				</msup>
		convert to (add mspace after mtext and enclose them into mrow):
			<msup>
				<mrow>
					<mtext/>
					<mspace height="1.47ex"/>
				</mrow>
				<mn>1</mn>
			</msup>
	-->
	<xsl:template match="mathml:msup/mathml:mtext[not(preceding-sibling::*)]" mode="mathml">
		<mathml:mrow>
			<xsl:copy-of select="."/>
			<mathml:mspace height="1.47ex"/>
		</mathml:mrow>
	</xsl:template>

	<!-- add space around vertical line -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '|']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@lspace)">
				<xsl:attribute name="lspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@rspace) and not(following-sibling::*[1][self::mathml:mo and normalize-space(text()) = '|'])">
				<xsl:attribute name="rspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- decrease fontsize for 'Circled Times' char -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '⊗']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@fontsize)">
				<xsl:attribute name="fontsize">55%</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- increase space before '(' -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '(']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="(preceding-sibling::* and not(preceding-sibling::*[1][self::mathml:mo])) or (../preceding-sibling::* and not(../preceding-sibling::*[1][self::mathml:mo]))">
				<xsl:if test="not(@lspace)">
					<xsl:attribute name="lspace">0.4em</xsl:attribute>
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
						<xsl:when test="../preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml_linebreak">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml_linebreak"/>
		</xsl:copy>
	</xsl:template>

	<!-- split math into two math -->
	<xsl:template match="mathml:mo[@linebreak] | mathml:mspace[@linebreak]" mode="mathml_linebreak">
		<xsl:variable name="math_elements_tree_">
			<xsl:for-each select="ancestor::*[ancestor-or-self::mathml:math]">
				<element pos="{position()}">
					<xsl:copy-of select="@*[local-name() != 'id']"/>
					<xsl:value-of select="name()"/>
				</element>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="math_elements_tree" select="xalan:nodeset($math_elements_tree_)"/>

		<xsl:call-template name="insertClosingElements">
			<xsl:with-param name="tree" select="$math_elements_tree"/>
		</xsl:call-template>

		<xsl:element name="br" namespace="{$namespace_full}"/>

		<xsl:call-template name="insertOpeningElements">
			<xsl:with-param name="tree" select="$math_elements_tree"/>
			<xsl:with-param name="xmlns">http://www.w3.org/1998/Math/MathML</xsl:with-param>
			<xsl:with-param name="add_continue">false</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

	<!-- Examples: 
		<stem type="AsciiMath">x = 1</stem> 
		<stem type="AsciiMath"><asciimath>x = 1</asciimath></stem>
		<stem type="AsciiMath"><asciimath>x = 1</asciimath><latexmath>x = 1</latexmath></stem>
	-->
	<xsl:template match="mn:fmt-stem[@type = 'AsciiMath'][count(*) = 0]/text() | mn:fmt-stem[@type = 'AsciiMath'][mn:asciimath]" priority="3">
		<fo:inline xsl:use-attribute-sets="mathml-style">

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:choose>
				<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates>
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>

		</fo:inline>
	</xsl:template>
	<!-- ======================================= -->
	<!-- END: math -->
	<!-- ======================================= -->

	<xsl:attribute-set name="list-style">
		<xsl:attribute name="provisional-distance-between-starts">6.5mm</xsl:attribute>
		<xsl:attribute name="line-height">145%</xsl:attribute>
	</xsl:attribute-set> <!-- list-style -->

	<xsl:template name="refine_list-style">
	</xsl:template> <!-- refine_list-style -->

	<xsl:attribute-set name="list-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- list-name-style -->

	<xsl:attribute-set name="list-item-style">
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-style">
	</xsl:template> <!-- refine_list-item-style -->

	<xsl:attribute-set name="list-item-label-style">
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-label-style">
	</xsl:template> <!-- refine_list-item-label-style -->

	<xsl:attribute-set name="list-item-body-style">
		<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-body-style">
	</xsl:template> <!-- refine_list-item-body-style -->

	<!-- ===================================== -->
	<!-- Lists processing -->
	<!-- ===================================== -->
	<xsl:variable name="ul_labels_">
		<label level="1">•</label>
		<label level="2">-</label><!-- minus -->
		<label level="3" font-size="75%">o</label> <!-- white circle -->

	</xsl:variable>
	<xsl:variable name="ul_labels" select="xalan:nodeset($ul_labels_)"/>

	<xsl:template name="setULLabel">
		<xsl:variable name="list_level__"><xsl:value-of select="count(ancestor::mn:ul) + count(ancestor::mn:ol)"/>
		</xsl:variable>
		<xsl:variable name="list_level_" select="number($list_level__)"/>
		<xsl:variable name="list_level">
			<xsl:choose>
				<xsl:when test="$list_level_ &lt;= 3"><xsl:value-of select="$list_level_"/></xsl:when>
				<xsl:when test="$ul_labels/label[@level = 3]"><xsl:value-of select="$list_level_ mod 3"/></xsl:when>
				<xsl:when test="$list_level_ mod 2 = 0">2</xsl:when>
				<xsl:otherwise><xsl:value-of select="$list_level_ mod 2"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ul_labels/label[not(@level)]"> <!-- one label for all levels -->
				<xsl:apply-templates select="$ul_labels/label[not(@level)]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0 and $ul_labels/label[@level = 3]">
				<xsl:apply-templates select="$ul_labels/label[@level = 3]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 2 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 2]" mode="ul_labels"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="label" mode="ul_labels">
		<xsl:copy-of select="@*[not(local-name() = 'level')]"/>
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template name="getListItemFormat">
		<!-- Example: for BSI <?list-type loweralpha?> -->
		<xsl:variable name="processing_instruction_type" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-type'))"/>
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul'">
				<xsl:choose>
					<xsl:when test="normalize-space($processing_instruction_type) = 'simple'"/>
					<!-- https://github.com/metanorma/isodoc/issues/675 -->
					<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="setULLabel"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- https://github.com/metanorma/isodoc/issues/675 -->
			<xsl:when test="local-name(..) = 'ol' and @label and @full = 'true'"> <!-- @full added in the template li/fmt-name -->
				<xsl:value-of select="@label"/>
			</xsl:when>
			<xsl:when test="local-name(..) = 'ol' and @label"> <!-- for ordered lists 'ol', and if there is @label, for instance label="1.1.2" -->

				<xsl:variable name="type" select="../@type"/>

				<xsl:variable name="label">

					<xsl:variable name="style_prefix_">
						<xsl:if test="$type = 'roman'"> <!-- Example: (i) -->
						</xsl:if>
						<xsl:if test="$type = 'alphabet'">
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="style_prefix" select="normalize-space($style_prefix_)"/>

					<xsl:variable name="style_suffix_">
						<xsl:choose>
							<xsl:when test="$type = 'arabic'">)
							</xsl:when>
							<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">)
							</xsl:when>
							<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">)
							</xsl:when>
							<xsl:when test="$type = 'roman'">)
							</xsl:when>
							<xsl:when test="$type = 'roman_upper'">.</xsl:when> <!-- Example: I. -->
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="style_suffix" select="normalize-space($style_suffix_)"/>

					<xsl:if test="$style_prefix != '' and not(starts-with(@label, $style_prefix))">
						<xsl:value-of select="$style_prefix"/>
					</xsl:if>

					<xsl:value-of select="@label"/>

					<xsl:if test="not(java:endsWith(java:java.lang.String.new(@label),$style_suffix))">
						<xsl:value-of select="$style_suffix"/>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="normalize-space($label)"/>

			</xsl:when>
			<xsl:otherwise> <!-- for ordered lists 'ol' -->

				<!-- Example: for BSI <?list-start 2?> -->
				<xsl:variable name="processing_instruction_start" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-start'))"/>

				<xsl:variable name="start_value">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_start) != ''">
							<xsl:value-of select="number($processing_instruction_start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:when test="normalize-space(../@start) != ''">
							<xsl:value-of select="number(../@start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="curr_value"><xsl:number/></xsl:variable>

				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_type) != ''"><xsl:value-of select="$processing_instruction_type"/></xsl:when>
						<xsl:when test="normalize-space(../@type) != ''"><xsl:value-of select="../@type"/></xsl:when>

						<xsl:otherwise> <!-- if no @type or @class = 'steps' -->

							<xsl:variable name="list_level_" select="count(ancestor::mn:ul) + count(ancestor::mn:ol)"/>
							<xsl:variable name="list_level">
								<xsl:choose>
									<xsl:when test="$list_level_ &lt;= 5"><xsl:value-of select="$list_level_"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$list_level_ mod 5"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="$list_level mod 5 = 0">roman_upper</xsl:when> <!-- level 5 -->
								<xsl:when test="$list_level mod 4 = 0">alphabet_upper</xsl:when> <!-- level 4 -->
								<xsl:when test="$list_level mod 3 = 0">roman</xsl:when> <!-- level 3 -->
								<xsl:when test="$list_level mod 2 = 0 and ancestor::*/@class = 'steps'">alphabet</xsl:when> <!-- level 2 and @class = 'steps'-->
								<xsl:when test="$list_level mod 2 = 0">arabic</xsl:when> <!-- level 2 -->
								<xsl:otherwise> <!-- level 1 -->
									<xsl:choose>
										<xsl:when test="ancestor::*/@class = 'steps'">arabic</xsl:when>
										<xsl:otherwise>alphabet</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="format">
					<xsl:choose>
						<xsl:when test="$type = 'arabic'">1)
						</xsl:when>
						<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">a)
						</xsl:when>
						<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">A)
						</xsl:when>
						<xsl:when test="$type = 'roman'">i)
						</xsl:when>
						<xsl:when test="$type = 'roman_upper'">I.</xsl:when>
						<xsl:otherwise>1.</xsl:otherwise> <!-- for any case, if $type has non-determined value, not using -->
					</xsl:choose>
				</xsl:variable>

				<xsl:number value="$start_value + $curr_value" format="{normalize-space($format)}" lang="en"/>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getListItemFormat -->

	<xsl:template match="mn:ul | mn:ol">
		<xsl:param name="indent">0</xsl:param>
		<xsl:choose>
			<xsl:when test="parent::mn:note or parent::mn:termnote">
				<fo:block-container role="SKIP">
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:call-template name="refine_list_container_style"/>

					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block>
							<xsl:apply-templates select="." mode="list">
								<xsl:with-param name="indent" select="$indent"/>
							</xsl:apply-templates>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block role="SKIP">
					<xsl:apply-templates select="." mode="list">
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_list_container_style">
	</xsl:template> <!-- refine_list_container_style -->

	<xsl:template match="mn:ul | mn:ol" mode="list" name="list">

		<xsl:apply-templates select="mn:fmt-name">
			<xsl:with-param name="process">true</xsl:with-param>
		</xsl:apply-templates>

		<fo:list-block xsl:use-attribute-sets="list-style">

			<xsl:variable name="provisional_distance_between_starts_">
				<attributes xsl:use-attribute-sets="list-style">
					<xsl:call-template name="refine_list-style_provisional-distance-between-starts"/>
				</attributes>
			</xsl:variable>
			<xsl:variable name="provisional_distance_between_starts" select="normalize-space(xalan:nodeset($provisional_distance_between_starts_)/attributes/@provisional-distance-between-starts)"/>
			<xsl:if test="$provisional_distance_between_starts != ''">
				<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="provisional_distance_between_starts_value" select="substring-before($provisional_distance_between_starts, 'mm')"/>

			<!-- increase provisional-distance-between-starts for long lists -->
			<xsl:if test="self::mn:ol">
				<!-- Examples: xiii), xviii), xxviii) -->
				<xsl:variable name="item_numbers">
					<xsl:for-each select="mn:li">
						<item><xsl:call-template name="getListItemFormat"/></item>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="max_length">
					<xsl:for-each select="xalan:nodeset($item_numbers)/item">
						<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
						<xsl:if test="position() = 1"><xsl:value-of select="string-length(.)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<!-- base width (provisional-distance-between-starts) for 4 chars -->
				<xsl:variable name="addon" select="$max_length - 4"/>
				<xsl:if test="$addon &gt; 0">
					<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts_value + $addon * 2"/>mm</xsl:attribute>
				</xsl:if>
				<!-- DEBUG -->
				<!-- <xsl:copy-of select="$item_numbers"/>
				<max_length><xsl:value-of select="$max_length"/></max_length>
				<addon><xsl:value-of select="$addon"/></addon> -->
			</xsl:if>

			<xsl:call-template name="refine_list-style"/>

			<xsl:if test="mn:fmt-name">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="node()[not(self::mn:note)]"/>
		</fo:list-block>
		<!-- <xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each> -->
		<xsl:apply-templates select="./mn:note"/>
	</xsl:template>

	<xsl:template name="refine_list-style_provisional-distance-between-starts">
	</xsl:template> <!-- refine_list-style_provisional-distance-between-starts -->

	<xsl:template match="*[self::mn:ol or self::mn:ul]/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="list-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:li">
		<xsl:param name="indent">0</xsl:param>
		<!-- <fo:list-item xsl:use-attribute-sets="list-item-style">
			<fo:list-item-label end-indent="label-end()"><fo:block>x</fo:block></fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>debug li indent=<xsl:value-of select="$indent"/></fo:block>
			</fo:list-item-body>
		</fo:list-item> -->
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>

			<xsl:call-template name="refine_list-item-style"/>

			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style" role="SKIP">

					<xsl:call-template name="refine_list-item-label-style"/>

					<xsl:if test="local-name(..) = 'ul'">
						<xsl:variable name="li_label" select="@label"/>
						<xsl:copy-of select="$ul_labels//label[. = $li_label]/@*[not(local-name() = 'level')]"/>
					</xsl:if>

					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and mn:add]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>

					<xsl:call-template name="getListItemFormat"/>

				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block role="SKIP">

					<xsl:call-template name="refine_list-item-body-style"/>

					<xsl:apply-templates>
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>

					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./mn:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<!-- ===================================== -->
	<!-- END Lists processing -->
	<!-- ===================================== -->

	<xsl:attribute-set name="fn-reference-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_fn-reference-style">
	</xsl:template> <!-- refine_fn-reference-style -->

	<xsl:attribute-set name="fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="fn-num-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">65%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="fn-body-style">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
		<xsl:attribute name="font-family">Azo Sans Lt</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_fn-body-style">
	</xsl:template> <!-- refine_fn-body-style -->

	<xsl:attribute-set name="fn-body-num-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">60%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- fn-body-num-style -->

	<xsl:template name="refine_fn-body-num-style">
	</xsl:template> <!-- refine_fn-body-num-style -->

	<!-- ===================== -->
	<!-- Footnotes processing  -->
	<!-- ===================== -->

	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="footnotes_">
		<xsl:for-each select="//mn:fmt-footnote-container/mn:fmt-fn-body"> <!-- commented mn:metanorma/, because there are fn in figure or table name -->
			<!-- <xsl:copy-of select="."/> -->
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="footnotes" select="xalan:nodeset($footnotes_)"/>

	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<!-- footnotes in text (title, bibliography, main body), not for tables, figures and names --> <!-- table's, figure's names -->
	<!-- fn in text -->
	<xsl:template match="mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))]" priority="2" name="fn">
		<xsl:param name="footnote_body_from_table">false</xsl:param>

		<!-- list of unique footnotes -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>

		<xsl:variable name="gen_id" select="generate-id(.)"/>

		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="@reference"/>

		<xsl:variable name="current_fn_number_text">
			<xsl:value-of select="$current_fn_number"/>
		</xsl:variable>

		<xsl:variable name="ref_id" select="@target"/>

		<xsl:variable name="footnote_inline">
			<fo:inline role="Reference">

				<xsl:variable name="fn_styles">
					<xsl:choose>
						<xsl:when test="ancestor::mn:bibitem">
							<fn_styles xsl:use-attribute-sets="bibitem-note-fn-style">
							</fn_styles>
						</xsl:when>
						<xsl:otherwise>
							<fn_styles xsl:use-attribute-sets="fn-num-style">
							</fn_styles>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($fn_styles)/fn_styles/@*">
					<xsl:copy-of select="."/>
				</xsl:for-each>

				<xsl:if test="following-sibling::node()[normalize-space() != ''][1][self::mn:fn]">
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$ref_id}" fox:alt-text="footnote {$current_fn_number}"> <!-- note: role="Lbl" removed in https://github.com/metanorma/mn2pdf/issues/291 -->
							<fo:inline role="Lbl"> <!-- need for https://github.com/metanorma/metanorma-iso/issues/1003 -->
								<xsl:copy-of select="$current_fn_number_text"/>

							</fo:inline>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:inline>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space(@skip_footnote_body) = 'true'">
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:when>
			<!-- <xsl:when test="$footnotes//mn:fmt-fn-body[@id = $ref_id] or normalize-space(@skip_footnote_body) = 'false'"> -->
			<xsl:when test="$p_fn//fn[@gen_id = $gen_id] or normalize-space(@skip_footnote_body) = 'false' or $footnote_body_from_table = 'true'">

				<fo:footnote xsl:use-attribute-sets="fn-style" role="SKIP">
					<xsl:copy-of select="$footnote_inline"/>
					<fo:footnote-body role="Note">

						<fo:block-container xsl:use-attribute-sets="fn-container-body-style" role="SKIP">

							<xsl:variable name="fn_block">
								<xsl:call-template name="refine_fn-body-style"/>

								<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style" role="Lbl">

									<xsl:call-template name="refine_fn-body-num-style"/>

									<xsl:value-of select="$current_fn_number_text"/>

								</fo:inline>
								<!-- <xsl:apply-templates /> -->
								<!-- <ref_id><xsl:value-of select="$ref_id"/></ref_id>
								<here><xsl:copy-of select="$footnotes"/></here> -->
								<xsl:apply-templates select="$footnotes/mn:fmt-fn-body[@id = $ref_id]"/>
							</xsl:variable>
							<fo:block xsl:use-attribute-sets="fn-body-style" role="SKIP">
								<xsl:copy-of select="$fn_block"/>
							</fo:block>

						</fo:block-container>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn in text -->

	<xsl:template name="get_fn_list">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- for BSI, footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<!-- itetation for:
				footnotes in bibdata/title
				footnotes in bibliography
				footnotes in document's body (except table's head/body/foot and figure text) 
				-->
				<xsl:for-each select="ancestor::mn:metanorma/mn:bibdata/mn:note[@type='title-footnote']">
					<fn gen_id="{generate-id(.)}">
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="node()"/>
					</fn>
				</xsl:for-each>
				<xsl:for-each select="ancestor::mn:metanorma/mn:boilerplate/* |       ancestor::mn:metanorma//mn:preface/* |      ancestor::mn:metanorma//mn:sections/* |       ancestor::mn:metanorma//mn:annex |      ancestor::mn:metanorma//mn:bibliography/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<!-- commented:
					 .//mn:bibitem[ancestor::mn:references]/mn:note |
					 because 'fn' there is in biblio-tag -->
					<xsl:for-each select=".//mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- fn/text() -->
	<xsl:template match="mn:fn/text()[normalize-space() != '']">
		<fo:inline role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<!-- fn//p fmt-fn-body//p -->
	<xsl:template match="mn:fn//mn:p | mn:fmt-fn-body//mn:p">
		<fo:inline role="P">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="insertFootnoteSeparatorCommon">
		<xsl:param name="leader_length">30%</xsl:param>
		<fo:static-content flow-name="xsl-footnote-separator">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="{$leader_length}"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<!-- ===================== -->
	<!-- END Footnotes processing  -->
	<!-- ===================== -->

	<!-- admonition -->
	<xsl:attribute-set name="admonition-style">
		<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
		<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
		<xsl:attribute name="margin-left">16mm</xsl:attribute>
		<xsl:attribute name="margin-right">16mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-style -->

	<xsl:attribute-set name="admonition-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:attribute name="padding">2mm</xsl:attribute>
		<xsl:attribute name="padding-top">3mm</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-container-style -->

	<xsl:attribute-set name="admonition-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-name-style -->

	<xsl:attribute-set name="admonition-p-style">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-p-style -->
	<!-- end admonition -->

	<!-- ================ -->
	<!-- Admonition -->
	<!-- ================ -->
	<xsl:template match="mn:admonition"> <!-- text in the box -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style">

			<xsl:call-template name="setBlockSpanAll"/>
					<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">
								<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
									<fo:block>
										<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
									</fo:block>
								</fo:block-container>
					</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="displayAdmonitionName">
		<xsl:param name="sep"/> <!-- Example: ' - ' -->
		<!-- <xsl:choose>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="@type='important'"><xsl:apply-templates select="@type"/></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="mn:name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="mn:name"/>
				<xsl:if test="not(mn:name)">
					<xsl:apply-templates select="@type"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:variable name="name">
			<xsl:apply-templates select="mn:fmt-name"/>
		</xsl:variable>
		<xsl:copy-of select="$name"/>
		<xsl:if test="normalize-space($name) != ''">
			<xsl:value-of select="$sep"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:admonition/mn:fmt-name">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- <xsl:template match="mn:admonition/@type">
		<xsl:variable name="admonition_type_">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">admonition.<xsl:value-of select="."/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="admonition_type" select="normalize-space(java:toUpperCase(java:java.lang.String.new($admonition_type_)))"/>
		<xsl:value-of select="$admonition_type"/>
		<xsl:if test="$admonition_type = ''">
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(.))"/>
		</xsl:if>
	</xsl:template> -->

	<xsl:template match="mn:admonition/mn:p"> <!-- processing for admonition/p found in the template for 'p' -->
		<xsl:call-template name="paragraph"/>

	</xsl:template>

	<!-- ================ -->
	<!-- END Admonition -->
	<!-- ================ -->

	<!-- bibitem in Normative References (references/@normative="true") -->
	<xsl:attribute-set name="bibitem-normative-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="start-indent">12mm</xsl:attribute>
		<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		<xsl:attribute name="line-height">145%</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-normative-style -->

	<!-- bibitem in Normative References (references/@normative="true"), renders as list -->
	<xsl:attribute-set name="bibitem-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-normative-list-style -->

	<xsl:attribute-set name="bibitem-non-normative-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="line-height">145%</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-non-normative-style -->

	<!-- bibitem in bibliography section (references/@normative="false"), renders as list -->
	<xsl:attribute-set name="bibitem-non-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-non-normative-list-style -->

	<xsl:attribute-set name="bibitem-non-normative-list-item-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<!-- bibitem in bibliography section (references/@normative="false"), list body -->
	<xsl:attribute-set name="bibitem-normative-list-body-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="bibitem-non-normative-list-body-style">
	</xsl:attribute-set> <!-- bibitem-non-normative-list-body-style -->

	<!-- footnote reference number for bibitem, in the text  -->
	<xsl:attribute-set name="bibitem-note-fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">65%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-style -->

	<!-- footnote number on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-number-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">60%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-number-style -->

	<!-- footnote body (text) on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-body-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
		<xsl:attribute name="font-family">Azo Sans Lt</xsl:attribute>
		<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-body-style -->

	<xsl:attribute-set name="references-non-normative-style">
		<xsl:attribute name="line-height">145%</xsl:attribute>
	</xsl:attribute-set> <!-- references-non-normative-style -->

		<!-- ======================= -->
	<!-- Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	<xsl:template match="mn:references[@hidden='true']" priority="3"/>
	<xsl:template match="mn:bibitem[@hidden='true']" priority="3">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/>
	</xsl:template>
	<!-- don't display bibitem with @id starts with '_hidden', that was introduced for references integrity -->
	<xsl:template match="mn:bibitem[starts-with(@id, 'hidden_bibitem_')]" priority="3"/>

	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']" priority="2">

		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references">
		<xsl:if test="not(ancestor::mn:annex)">
			<fo:block break-after="page"/>
		</xsl:if>

		<!-- <xsl:if test="ancestor::mn:annex">
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'itu'">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if> -->

		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}"/>

		<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>

		<fo:block xsl:use-attribute-sets="references-non-normative-style">
			<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]"/>
		</fo:block>
	</xsl:template> <!-- references -->

	<xsl:template match="mn:bibitem">
		<xsl:call-template name="bibitem"/>
	</xsl:template>

	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']/mn:bibitem" name="bibitem" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
			<xsl:call-template name="processBibitem"/>
		</fo:block>

	</xsl:template> <!-- bibitem -->

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references[not(@normative='true')]/mn:bibitem | mn:references[not(@normative='true')]/mn:note" name="bibitem_non_normative" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[not(self::mn:note)][1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<!-- start CSA bibitem processing -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-style">
			<xsl:apply-templates select="mn:biblio-tag"/>
			<xsl:apply-templates select="mn:formattedref"/>
			<xsl:call-template name="processBibliographyNote"/>
		</fo:block>
		<!-- END CSA bibitem processing -->

	</xsl:template> <!-- references[not(@normative='true')]/bibitem -->

	<xsl:template name="insertListItem_Bibitem">
		<xsl:choose>
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-item id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-item-style">
					<fo:list-item-label end-indent="label-end()">
						<fo:block role="SKIP">
							<fo:inline role="SKIP">
								<xsl:apply-templates select="mn:biblio-tag">
									<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style" role="SKIP">
							<xsl:call-template name="processBibitem">
								<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
							</xsl:call-template>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="following-sibling::*[1]"> <!-- [self::mn:bibitem] -->
			<xsl:with-param name="skip">false</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="processBibitem">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<!-- start bibitem processing -->
		<xsl:if test=".//mn:fn">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>

		<xsl:apply-templates select="mn:biblio-tag">
			<xsl:with-param name="biblio_tag_part" select="$biblio_tag_part"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="mn:formattedref"/>
		<!-- end bibitem processing -->

		<xsl:call-template name="processBibliographyNote"/>
	</xsl:template> <!-- processBibitem (bibitem) -->

	<xsl:template name="processBibliographyNote">
		<xsl:if test="self::mn:note">
			<xsl:variable name="note_node">
				<xsl:element name="{local-name(..)}" namespace="{$namespace_full}"> <!-- save parent context node for determining styles -->
					<xsl:copy> <!-- skip @id -->
						<xsl:copy-of select="node()"/>
					</xsl:copy>
				</xsl:element>
			</xsl:variable>
			<!-- <xsl:for-each select="xalan:nodeset($note_node)//mn:note">
				<xsl:call-template name="note"/>
			</xsl:for-each> -->
			<xsl:call-template name="note"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:title" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:bibitem/mn:docidentifier"/>

	<xsl:template match="mn:formattedref">
		<!-- <xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:text>, </xsl:text>
		</xsl:if> -->
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:biblio-tag">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<xsl:choose>
			<xsl:when test="$biblio_tag_part = 'first' and mn:tab">
				<xsl:apply-templates select="./mn:tab[1]/preceding-sibling::node()"/>
			</xsl:when>
			<xsl:when test="$biblio_tag_part = 'last'">
				<xsl:apply-templates select="./mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:biblio-tag/mn:tab" priority="2">
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- ======================= -->
	<!-- END Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- END Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->

	<!-- Highlight.js syntax GitHub styles -->
	<xsl:attribute-set name="hljs-doctag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-tag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-variable">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-type">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable_and_language_">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-title">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class__and_inherited__">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_function_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-attribute">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-literal">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-number">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-operator">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-class">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-id">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-regexp">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-built_in">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-symbol">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-comment">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-code">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-formula">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-name">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-quote">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-tag">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-pseudo">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-subst">
		<xsl:attribute name="color">#24292e</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-section">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-bullet">
		<xsl:attribute name="color">#735c0f</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-emphasis">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-strong">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-addition">
		<xsl:attribute name="color">#22863a</xsl:attribute>
		<xsl:attribute name="background-color">#f0fff4</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-deletion">
		<xsl:attribute name="color">#b31d28</xsl:attribute>
		<xsl:attribute name="background-color">#ffeef0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-char_and_escape_">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-link">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-params">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-property">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-punctuation">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-tag">
	</xsl:attribute-set>
	<!-- End Highlight syntax styles -->

	<!-- Index section styles -->
	<xsl:attribute-set name="indexsect-title-style">
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="indexsect-clause-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>
	<!-- End Index section styles -->

	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>

	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//mn:bookmark[ancestor::mn:fn]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="@*|node()" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:xref" mode="index_add_id"/>
	<xsl:template match="mn:fmt-xref" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$en_dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id">
					<xsl:with-param name="docid" select="$docid"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)][1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $en_dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'fmt-xref'">
				<xsl:variable name="id" select="@id"/>

				<xsl:variable name="id_next" select="following-sibling::mn:fmt-xref[1]/@id"/>
				<xsl:variable name="id_prev" select="preceding-sibling::mn:fmt-xref[1]/@id"/>

				<xsl:variable name="pages_">
					<xsl:for-each select="$index/index/item[@id = $id or @id = $id_next or @id = $id_prev]">
						<xsl:choose>
							<xsl:when test="@id = $id">
								<page><xsl:value-of select="."/></page>
							</xsl:when>
							<xsl:when test="@id = $id_next">
								<page_next><xsl:value-of select="."/></page_next>
							</xsl:when>
							<xsl:when test="@id = $id_prev">
								<page_prev><xsl:value-of select="."/></page_prev>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="pages" select="xalan:nodeset($pages_)"/>

				<!-- <xsl:variable name="page" select="$index/index/item[@id = $id]"/> -->
				<xsl:variable name="page" select="$pages/page"/>
				<!-- <xsl:variable name="page_next" select="$index/index/item[@id = $id_next]"/> -->
				<xsl:variable name="page_next" select="$pages/page_next"/>
				<!-- <xsl:variable name="page_prev" select="$index/index/item[@id = $id_prev]"/> -->
				<xsl:variable name="page_prev" select="$pages/page_prev"/>

				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->

						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="generateIndexXrefId">
		<xsl:param name="docid"/>

		<xsl:variable name="level" select="count(ancestor::mn:ul)"/>

		<xsl:variable name="docid_curr">
			<xsl:value-of select="$docid"/>
			<xsl:if test="normalize-space($docid) = ''"><xsl:call-template name="getDocumentId"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="item_number">
			<xsl:number count="mn:li[ancestor::mn:indexsect]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="mn:fmt-xref"/></xsl:variable>
		<xsl:value-of select="concat($docid_curr, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:fmt-title | mn:indexsect/mn:title" priority="4">
		<fo:block xsl:use-attribute-sets="indexsect-title-style">
			<!-- Index -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause/mn:fmt-title | mn:indexsect/mn:clause/mn:title" priority="4">
		<!-- Letter A, B, C, ... -->
		<fo:block xsl:use-attribute-sets="indexsect-clause-title-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause" priority="4">
		<xsl:apply-templates/>
		<fo:block>
			<xsl:if test="following-sibling::mn:clause">
				<fo:block> </fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:ul" priority="4">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li" priority="4">
		<xsl:variable name="level" select="count(ancestor::mn:ul)"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li/text()">
		<!-- to split by '_' and other chars -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>

	<xsl:template match="mn:table/mn:bookmark" priority="2"/>

	<xsl:template match="mn:bookmark" name="bookmark">
		<xsl:variable name="bookmark_id" select="@id"/>
		<xsl:choose>
			<!-- Example:
				<fmt-review-start id="_7ef81cf7-3f6c-4ed4-9c1f-1ba092052bbd" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" end="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/>
				<bookmark id="_dda23915-8574-ef1e-29a1-822d465a5b97"/>
				<fmt-review-end id="_f336a8d0-08a8-4b7f-a1aa-b04688ed40c1" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" start="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/> -->
			<xsl:when test="1 = 2 and preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and        following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]">
				<!-- skip here, see the template 'fmt-review-start' -->
			</xsl:when>
			<xsl:otherwise>
				<!-- <fo:inline id="{@id}" font-size="1pt"/> -->
				<fo:inline id="{@id}" font-size="1pt"><xsl:if test="preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and        following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]"><xsl:attribute name="line-height">0.1</xsl:attribute></xsl:if><xsl:value-of select="$hair_space"/></fo:inline>
				<!-- we need to add zero-width space, otherwise this fo:inline is missing in IF xml -->
				<xsl:if test="not(following-sibling::node()[normalize-space() != ''])"><fo:inline font-size="1pt"> </fo:inline></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->

		<!-- =================== -->
	<!-- Form's elements processing -->
	<!-- =================== -->
	<xsl:template match="mn:form">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:form//mn:label">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'checkbox']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:select">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:textarea">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template>

	<!-- =================== -->
	<!-- End Form's elements processing -->
	<!-- =================== -->

	<xsl:attribute-set name="toc-style">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="line-height">170%</xsl:attribute>
		<xsl:attribute name="color">rgb(7, 72, 156)</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-style">
	</xsl:template>

	<xsl:attribute-set name="toc-title-style">
		<xsl:attribute name="font-size">26pt</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-top">2pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">30pt</xsl:attribute>
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-title-style">
	</xsl:template>

	<xsl:attribute-set name="toc-title-page-style">
	</xsl:attribute-set> <!-- toc-title-page-style -->

	<xsl:template name="refine_toc-title-page-style">
	</xsl:template>

	<xsl:attribute-set name="toc-item-block-style">
		<xsl:attribute name="provisional-distance-between-starts">3mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-item-block-style">
		<xsl:if test="@level &gt;= 2">
			<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="(@level - 1) * 10"/>mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="toc-item-style">
		<xsl:attribute name="role">TOCI</xsl:attribute>
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		<xsl:attribute name="role">SKIP</xsl:attribute>
	</xsl:attribute-set> <!-- END: toc-item-style -->

	<xsl:template name="refine_toc-item-style">
	</xsl:template> <!-- END: refine_toc-item-style -->

	<xsl:attribute-set name="toc-leader-style">
		<xsl:attribute name="leader-pattern">dots</xsl:attribute>
	</xsl:attribute-set> <!-- END: toc-leader-style -->

	<xsl:attribute-set name="toc-pagenumber-style">
	</xsl:attribute-set>

	<!-- List of Figures, Tables -->
	<xsl:attribute-set name="toc-listof-title-style">
		<xsl:attribute name="provisional-distance-between-starts">3mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-listof-title-style">
	</xsl:template>

	<xsl:attribute-set name="toc-listof-item-block-style">
		<xsl:attribute name="provisional-distance-between-starts">10mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="toc-listof-item-style">
		<xsl:attribute name="role">TOCI</xsl:attribute>
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="text-indent">-12mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault_Contents">

		<xsl:variable name="nodes_sections_">
			<xsl:for-each select="/*/mn:sections/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true'] |    /*/mn:bibliography/mn:clause[mn:references[@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>

		<!-- <xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each> -->

		<xsl:for-each select="/*/mn:annex | /*/mn:bibliography/*[not(@normative='true') and not(mn:references[@normative='true'])][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0] |          /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<mnx:tables>
			<xsl:for-each select="//mn:table[not(ancestor::mn:metanorma-extension)][@id and mn:fmt-name and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:table id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:table>
					</xsl:when>
					<xsl:otherwise>
						<mnx:table id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:tables>
	</xsl:template>

	<xsl:template name="processFigures_Contents">
		<mnx:figures>
			<xsl:for-each select="//mn:figure[@id and mn:fmt-name and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(mn:name, 'Figure ') and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:figure id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:figure>
					</xsl:when>
					<xsl:otherwise>
						<mnx:figure id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:figure>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:figures>
	</xsl:template>

	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name |                mn:table/mn:name | mnx:table/mn:name |               mn:permission/mn:name | mnx:permission/mn:name |               mn:recommendation/mn:name | mnx:recommendation/mn:name |               mn:requirement/mn:name | mnx:requirement/mn:name" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="contents"/>

	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name |               mn:table/mn:fmt-name | mnx:table/mn:fmt-name |               mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name |               mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name |               mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name" mode="contents">
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name |                mn:table/mn:name | mnx:table/mn:name |               mn:permission/mn:name | mnx:permission/mn:name |               mn:recommendation/mn:name | mnx:recommendation/mn:name |               mn:requirement/mn:name | mnx:requirement/mn:name |               mn:sourcecode/mn:name" mode="bookmarks">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="bookmarks"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name |                mn:table/mn:fmt-name | mnx:table/mn:fmt-name |                mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name |                mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name |                mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name |                mn:sourcecode/mn:fmt-name | mnx:sourcecode/mn:fmt-name" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:name/text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:name/text()" mode="contents" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:fmt-name/text() |   *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:fmt-name/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:name//text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:name//text()" mode="bookmarks" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:fmt-name//text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:fmt-name//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:add/text()" mode="bookmarks" priority="3"> <!-- mn:add[starts-with(., $ace_tag)] -->
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space(..), $ace_tag)"><!-- skip --></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[self::mn:preface or self::mn:sections]/mn:p[@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="mn:p[@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="mn:p[@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>

	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="mn:clause/mn:p[@type = 'section-title' and (@depth != ../*[self::mn:title or self::mn:fmt-title]/@depth or ../*[self::mn:title or self::mn:fmt-title]/@depth = 1)]" priority="3" mode="contents"/>

	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"/>
				<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
					<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">false</xsl:variable>

		<xsl:if test="$skip = 'false'">

			<xsl:variable name="title">
				<xsl:choose>
					<!-- https://github.com/metanorma/mn-native-pdf/issues/770 -->
					<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="mn:tab">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>

			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
			</mnx:item>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:stem" mode="contents"/>

	<xsl:template match="*[self::mn:title or self::mn:name or self::mn:fmt-title or self::mn:fmt-name]//mn:fmt-stem" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<!-- prevent missing stem for table and figures in ToC -->
	<xsl:template match="*[self::mn:name or self::mn:fmt-name]//mn:stem" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-stem])">
			<xsl:apply-templates select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:references[@hidden='true']" mode="contents" priority="3"/>

	<xsl:template match="mn:references/mn:bibitem" mode="contents"/>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="mn:concept" mode="contents"/>
	<xsl:template match="mn:eref" mode="contents"/>
	<xsl:template match="mn:xref" mode="contents"/>
	<xsl:template match="mn:link" mode="contents"/>
	<xsl:template match="mn:origin" mode="contents"/>
	<xsl:template match="mn:erefstack" mode="contents"/>

	<xsl:template match="mn:requirement |             mn:recommendation |              mn:permission" mode="contents" priority="3"/>

	<xsl:template match="mn:stem" mode="bookmarks"/>
	<xsl:template match="mn:fmt-stem" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:concept" mode="bookmarks"/>
	<xsl:template match="mn:eref" mode="bookmarks"/>
	<xsl:template match="mn:xref" mode="bookmarks"/>
	<xsl:template match="mn:link" mode="bookmarks"/>
	<xsl:template match="mn:origin" mode="bookmarks"/>
	<xsl:template match="mn:erefstack" mode="bookmarks"/>

	<xsl:template match="mn:requirement |             mn:recommendation |              mn:permission" mode="bookmarks" priority="3"/>

	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="contents_addon"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//mnx:item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/mnx:doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/mnx:doc) &gt; 1">

								<xsl:if test="$contents_nodes/collection">
									<fo:bookmark internal-destination="{$contents/collection/@firstpage_id}">
										<fo:bookmark-title>collection.pdf</fo:bookmark-title>
									</fo:bookmark>
								</xsl:if>

								<xsl:for-each select="$contents_nodes/mnx:doc">
									<fo:bookmark internal-destination="{mnx:contents/mnx:item[@display = 'true'][1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>

										<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>

										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
										</xsl:call-template>

										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>

									</fo:bookmark>

								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$contents_nodes/mnx:doc">

									<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>

									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
									</xsl:call-template>

									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>

								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$contents_nodes/mnx:contents/mnx:item" mode="bookmark"/>

						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
						</xsl:call-template>

						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>

				<!-- for $namespace = 'nist-sp' $namespace = 'ogc' $namespace = 'ogc-white-paper' -->
				<xsl:copy-of select="$contents_addon"/>

			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:figure">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
		<xsl:if test="$contents_nodes//mnx:figures/mnx:figure">
			<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">

				<xsl:variable name="bookmark-title">
							<xsl:value-of select="$title-list-figures"/>
				</xsl:variable>
				<fo:bookmark-title><xsl:value-of select="normalize-space($bookmark-title)"/></fo:bookmark-title>
				<xsl:for-each select="$contents_nodes//mnx:figures/mnx:figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
	</xsl:template> <!-- insertFigureBookmarks -->

	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:table">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
		<xsl:if test="$contents_nodes//mnx:tables/mnx:table">
			<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">

				<xsl:variable name="bookmark-title">
							<xsl:value-of select="$title-list-tables"/>
				</xsl:variable>

				<fo:bookmark-title><xsl:value-of select="$bookmark-title"/></fo:bookmark-title>

				<xsl:for-each select="$contents_nodes//mnx:tables/mnx:table">
					<fo:bookmark internal-destination="{@id}">
						<!-- <fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title> -->
						<fo:bookmark-title><xsl:apply-templates mode="bookmark_clean"/></fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->

	<!-- ============================ -->
	<!-- mode="bookmark_clean" -->
	<!-- ============================ -->
	<xsl:template match="node()" mode="bookmark_clean">
		<xsl:apply-templates select="node()" mode="bookmark_clean"/>
	</xsl:template>

	<xsl:template match="text()" mode="bookmark_clean">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'math']" mode="bookmark_clean">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>

	<xsl:template match="mn:asciimath" mode="bookmark_clean"/>
	<!-- ============================ -->
	<!-- END: mode="bookmark_clean" -->
	<!-- ============================ -->

	<xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mnx:item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:variable name="title">
							<xsl:for-each select="mnx:title/node()">
								<xsl:choose>
									<xsl:when test="local-name() = 'add' and starts-with(., $ace_tag)"><!-- skip --></xsl:when>
									<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="normalize-space($title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mnx:title" mode="bookmark"/>
	<xsl:template match="text()" mode="bookmark"/>

	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="mn:title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-title])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
			<!-- <xsl:text> </xsl:text> -->
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>

	<xsl:template match="mn:span[                @class = 'fmt-caption-label' or                 @class = 'fmt-element-name' or                @class = 'fmt-caption-delim']" mode="contents_item" priority="3">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label" mode="contents_item"/>

	<xsl:template match="mn:concept" mode="contents_item"/>
	<xsl:template match="mn:eref" mode="contents_item"/>
	<xsl:template match="mn:xref" mode="contents_item"/>
	<xsl:template match="mn:link" mode="contents_item"/>
	<xsl:template match="mn:origin" mode="contents_item"/>
	<xsl:template match="mn:erefstack" mode="contents_item"/>

	<!-- fn -->
	<xsl:template match="mn:fn" mode="contents"/>
	<xsl:template match="mn:fn" mode="bookmarks"/>

	<xsl:template match="mn:fn" mode="contents_item"/>

	<xsl:template match="mn:xref | mn:eref" mode="contents">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:annotation" mode="contents_item"/>

	<xsl:template match="mn:tab" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:strong" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:copy>
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="element" select="$element"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:em" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sub" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sup" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:stem" mode="contents_item"/>
	<xsl:template match="mn:fmt-stem" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:br" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="mn:add" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:choose>
			<xsl:when test="starts-with(text(), $ace_tag)">
				<xsl:if test="$mode = 'contents'">
					<xsl:copy>
						<xsl:apply-templates mode="contents_item"/>
					</xsl:copy>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:apply-templates mode="contents_item"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="contents_item">
		<xsl:variable name="text">
			<!-- to split by '_' and other chars -->
			<mnx:text><xsl:call-template name="add-zero-spaces-java"/></mnx:text>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($text)/mnx:text/text()">
			<xsl:call-template name="keep_together_standard_number"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:add/text()" mode="contents_item" priority="2"> <!-- mn:add[starts-with(., $ace_tag)]/text() -->
		<xsl:if test="starts-with(normalize-space(..), $ace_tag)"><xsl:value-of select="."/></xsl:if>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="element" select="$element"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->

	<xsl:variable name="toc_level">
		<!-- https://www.metanorma.org/author/ref/document-attributes/ -->
		<xsl:variable name="pdftoclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'PDF TOC Heading Levels']/mn:value)"/> <!-- :toclevels-pdf  Number of table of contents levels to render in PDF output; used to override :toclevels:-->
		<xsl:variable name="toclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'TOC Heading Levels']/mn:value)"/> <!-- Number of table of contents levels to render -->
		<xsl:choose>
			<xsl:when test="$pdftoclevels != ''"><xsl:value-of select="number($pdftoclevels)"/></xsl:when> <!-- if there is value in xml -->
			<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>  <!-- if there is value in xml -->
			<xsl:otherwise><!-- default value -->2
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="mn:toc">
		<xsl:param name="colwidths"/>
		<xsl:variable name="colwidths_">
			<xsl:choose>
				<xsl:when test="not($colwidths)">
					<xsl:variable name="toc_table_simple">
						<mn:tbody>
							<xsl:apply-templates mode="toc_table_width"/>
						</mn:tbody>
					</xsl:variable>
					<!-- <debug_toc_table_simple><xsl:copy-of select="$toc_table_simple"/></debug_toc_table_simple> -->
					<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/mn:tr[1]/mn:td)"/>
					<xsl:call-template name="calculate-column-widths-proportional">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$toc_table_simple"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$colwidths"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- <debug_colwidth><xsl:copy-of select="$colwidths_"/></debug_colwidth> -->
		<fo:block role="TOCI" space-after="16pt">
			<fo:table width="100%" table-layout="fixed">
				<xsl:for-each select="xalan:nodeset($colwidths_)/column">
					<fo:table-column column-width="proportional-column-width({.})"/>
				</xsl:for-each>
				<fo:table-body>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:toc//mn:li" priority="2">
		<fo:table-row min-height="5mm">
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="mn:toc//mn:li/mn:p">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:toc//mn:xref | mn:toc//mn:fmt-xref" priority="3">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format: one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- <test><xsl:copy-of select="."/></test> -->

		<xsl:variable name="target" select="@target"/>

		<xsl:for-each select="mn:tab">

			<xsl:if test="position() = 1">
				<!-- first column (data before first `tab`) -->
				<fo:table-cell>
					<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
						<xsl:call-template name="insert_basic_link">
							<xsl:with-param name="element">
								<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
									<xsl:for-each select="preceding-sibling::node()">
										<xsl:choose>
											<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
											<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</fo:basic-link>
							</xsl:with-param>
						</xsl:call-template>
					</fo:block>
				</fo:table-cell>
			</xsl:if>

			<xsl:variable name="current_id" select="generate-id()"/>
			<fo:table-cell>
				<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
								<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
									<xsl:choose>
										<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
										<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block role="SKIP">
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
							<fo:page-number-citation ref-id="{$target}"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- ================================== -->
	<!-- calculate ToC table columns widths -->
	<!-- ================================== -->
	<xsl:template match="*" mode="toc_table_width">
		<xsl:apply-templates mode="toc_table_width"/>
	</xsl:template>

	<xsl:template match="mn:clause[@type = 'toc']/mn:fmt-title" mode="toc_table_width"/>
	<xsl:template match="mn:clause[not(@type = 'toc')]/mn:fmt-title" mode="toc_table_width"/>

	<xsl:template match="mn:li" mode="toc_table_width">
		<mn:tr>
			<xsl:apply-templates mode="toc_table_width"/>
		</mn:tr>
	</xsl:template>

	<xsl:template match="mn:fmt-xref" mode="toc_table_width">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format - one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="mn:tab">
			<xsl:if test="position() = 1">
				<mn:td>
					<xsl:for-each select="preceding-sibling::node()">
						<xsl:choose>
							<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
							<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</mn:td>
			</xsl:if>
			<xsl:variable name="current_id" select="generate-id()"/>
			<mn:td>
				<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
					<xsl:choose>
						<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</mn:td>
		</xsl:for-each>
		<mn:td>333</mn:td> <!-- page number, just for fill -->
	</xsl:template>

	<!-- ================================== -->
	<!-- END: calculate ToC table columns widths -->
	<!-- ================================== -->

	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->

	<!-- Tabulation processing -->
	<xsl:template match="mn:tab">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="padding">2
		</xsl:variable>

		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'">
				<fo:inline role="SKIP"><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%" role="SKIP">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm" role="SKIP"><xsl:value-of select="$direction"/>​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- tab -->

	<xsl:template match="mn:note/mn:fmt-name/mn:tab" priority="2"/>
	<xsl:template match="mn:termnote/mn:fmt-name/mn:tab" priority="2"/>

	<xsl:template match="mn:note/mn:fmt-name/mn:tab" mode="tab">
		<xsl:attribute name="padding-right">4mm</xsl:attribute>
	</xsl:template>

	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="reviews_">
		<xsl:for-each select="//mn:annotation[not(parent::mn:annotation-container)][@from]">
			<xsl:copy>
				<xsl:copy-of select="@from"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
		<xsl:for-each select="//mn:fmt-annotation-start[@source]">
			<xsl:copy>
				<xsl:copy-of select="@source"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews" select="xalan:nodeset($reviews_)"/>

	<xsl:template name="addReviewHelper">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- if there is review with from="...", then add small helper block for Annot tag adding, see 'review' template -->
			<xsl:variable name="curr_id" select="@id"/>
			<!-- <xsl:variable name="review_id" select="normalize-space(/@id)"/> -->
			<xsl:for-each select="$reviews//mn:annotation[@from = $curr_id]"> <!-- $reviews//mn:fmt-review-start[@source = $curr_id] -->
				<xsl:variable name="review_id" select="normalize-space(@id)"/>
				<xsl:if test="$review_id != ''"> <!-- i.e. if review found -->
					<fo:block keep-with-next="always" line-height="0.1" id="{$review_id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$review_id}" fox:alt-text="Annot___{$review_id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!-- <fo:block>
			<curr_id><xsl:value-of select="$curr_id"/></curr_id>
			<xsl:copy-of select="$reviews"/>
		</fo:block> -->
	</xsl:template>

	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="reviews_container_">
		<xsl:for-each select="//mn:annotation-container/mn:fmt-annotation-body">
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews_container" select="xalan:nodeset($reviews_container_)"/>

	<xsl:template match="mn:annotation-container"/>

	<!-- for old Presentation XML (before https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:annotation[not(parent::mn:annotation-container)]">  <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<xsl:variable name="id_from" select="normalize-space(current()/@from)"/>
		<xsl:if test="$isGenerateTableIF = 'false'">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- for new Presentation XML (https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:fmt-annotation-start" name="fmt-annotation-start"> <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->

		<xsl:variable name="id_from" select="normalize-space(current()/@source)"/>

		<xsl:variable name="source" select="normalize-space(@source)"/>

		<xsl:if test="$isGenerateTableIF = 'false'">
		<!-- <xsl:variable name="id_from" select="normalize-space(current()/@from)"/> -->

		<!-- <xsl:if test="@source = @end"> -->
		<!-- following-sibling::node()[1][local-name() = 'bookmark'][@id = $source] and
				following-sibling::node()[2][local-name() = 'fmt-review-end'][@source = $source] -->
			<!-- <fo:block id="{$source}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$source}" fox:alt-text="Annot___{$source}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block> -->
			<xsl:call-template name="setNamedDestination"/>
			<fo:block id="{@id}" font-size="1pt" role="SKIP" keep-with-next="always" line-height="0.1"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
		<!-- </xsl:if> -->
		</xsl:if>

		<xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>

    <xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
		</xsl:choose>
    </xsl:if>

	</xsl:template>

	<!-- https://github.com/metanorma/mn-samples-bsi/issues/312 -->
	<xsl:template match="mn:annotation[@type = 'other']"/>

	<!-- ============ -->
	<!-- errata -->
	<!-- ============ -->
	<xsl:template match="mn:errata">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="mn:errata/mn:row">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="mn:errata/mn:row/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block role="SKIP"><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============ -->
	<!-- END errata -->
	<!-- ============ -->

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->
	<xsl:template match="mn:ruby">
		<fo:inline-container text-indent="0mm" last-line-end-indent="0mm">
			<xsl:if test="not(ancestor::mn:ruby)">
				<xsl:attribute name="alignment-baseline">central</xsl:attribute>
			</xsl:if>
			<xsl:variable name="rt_text" select="mn:rt"/>
			<xsl:variable name="rb_text" select=".//mn:rb[not(mn:ruby)]"/>
			<!-- Example: width="2em"  -->
			<xsl:variable name="text_rt_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rt_text, $font_main, 6)"/>
			<xsl:variable name="text_rb_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rb_text, $font_main, 10)"/>
			<xsl:variable name="text_width">
				<xsl:choose>
					<xsl:when test="$text_rt_width &gt;= $text_rb_width"><xsl:value-of select="$text_rt_width"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$text_rb_width"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="width"><xsl:value-of select="$text_width div 10"/>em</xsl:attribute>

			<xsl:choose>
				<xsl:when test="ancestor::mn:ruby">
					<xsl:apply-templates select="mn:rb"/>
					<xsl:apply-templates select="mn:rt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="mn:rt"/>
					<xsl:apply-templates select="mn:rb"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="node()[not(self::mn:rt) and not(self::mn:rb)]"/>
		</fo:inline-container>
	</xsl:template>

	<xsl:template match="mn:rb">
		<fo:block line-height="1em" text-align="center"><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="mn:rt">
		<fo:block font-size="0.5em" text-align="center" line-height="1.2em" space-before="-1.4em" space-before.conditionality="retain"> <!--  -->
			<xsl:if test="ancestor::mn:ruby[last()]//mn:ruby or      ancestor::mn:rb">
				<xsl:attribute name="space-before">0em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:block>

	</xsl:template>

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- END: Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->

	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="copyCommonElements">
		<!-- copy bibdata, localized-strings, metanorma-extension and boilerplate -->
		<xsl:copy-of select="/*/*[not(self::mn:preface) and not(self::mn:sections) and not(self::mn:annex) and not(self::mn:bibliography) and not(self::mn:indexsect)]"/>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault">
		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |          /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template><!-- END: processMainSectionsDefault -->

	<xsl:template name="deleteFile">
		<xsl:param name="filepath"/>
		<xsl:variable name="xml_file" select="java:java.io.File.new($filepath)"/>
		<xsl:variable name="xml_file_path" select="java:toPath($xml_file)"/>
		<xsl:variable name="deletefile" select="java:java.nio.file.Files.deleteIfExists($xml_file_path)"/>
	</xsl:template>

	<xsl:template name="getPageSequenceOrientation">
		<xsl:variable name="previous_orientation" select="preceding-sibling::mn:page_sequence[@orientation][1]/@orientation"/>
		<xsl:choose>
			<xsl:when test="@orientation = 'landscape'">-<xsl:value-of select="@orientation"/></xsl:when>
			<xsl:when test="$previous_orientation = 'landscape' and not(@orientation = 'portrait')">-<xsl:value-of select="$previous_orientation"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="regex_standard_reference">([A-Z]{2,}(/[A-Z]{2,})* \d+(-\d+)*(:\d{4})?)</xsl:variable> <!-- example: ISO 1234:2000 -->
	<xsl:variable name="tag_fo_inline_keep-together_within-line_open">###fo:inline keep-together_within-line###</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_close">###/fo:inline keep-together_within-line###</xsl:variable>
	<xsl:template match="text()" name="text">
		<xsl:choose>
			<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new(.),$regex_standard_reference,concat($tag_fo_inline_keep-together_within-line_open,'$1',$tag_fo_inline_keep-together_within-line_close))"/>
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_fo_inline_keep-together_within-line_open"/>
					<xsl:with-param name="tag_close" select="$tag_fo_inline_keep-together_within-line_close"/>
					<xsl:with-param name="text" select="$text"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replace_fo_inline_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<!-- <xsl:text disable-output-escaping="yes">&lt;fo:inline keep-together.within-line="always"&gt;</xsl:text> -->
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>
				<xsl:choose>
					<xsl:when test="local-name(..) = 'keep-together_within-line'"> <!-- prevent two nested <fo:inline keep-together.within-line="always"><fo:inline keep-together.within-line="always" -->
						<xsl:value-of select="substring-before($text_after, $tag_close)"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:inline keep-together.within-line="always" role="SKIP">
							<xsl:value-of select="substring-before($text_after, $tag_close)"/>
						</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <xsl:text disable-output-escaping="yes">&lt;/fo:inline&gt;</xsl:text> -->
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- keep-together for standard's name (ISO 12345:2020), added in mode="update_xml_enclose_keep-together_within-line" -->
	<xsl:template match="*[local-name() = 'keep-together_within-line']">
		<xsl:param name="split_keep-within-line"/>

		<!-- <fo:inline>split_keep-within-line='<xsl:value-of select="$split_keep-within-line"/>'</fo:inline> -->
		<xsl:choose>

			<xsl:when test="normalize-space($split_keep-within-line) = 'true'">
				<xsl:variable name="sep">_</xsl:variable>
				<xsl:variable name="items">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="."/>
						<xsl:with-param name="sep" select="$sep"/>
						<xsl:with-param name="normalize-space">false</xsl:with-param>
						<xsl:with-param name="keep_sep">true</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($items)/mnx:item">
					<xsl:choose>
						<xsl:when test=". = $sep">
							<xsl:value-of select="$sep"/><xsl:value-of select="$zero_width_space"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>

			<xsl:otherwise>
				<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>

		</xsl:choose>
	</xsl:template>

	<!-- add zero spaces into table cells text -->
	<xsl:template match="*[local-name() = 'td']//text() | *[local-name() = 'th']//text() | *[local-name() = 'dt']//text() | *[local-name() = 'dd']//text()" priority="1">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'keep-together_within-line']">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="addZeroWidthSpacesToTextNodes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addZeroWidthSpacesToTextNodes">
		<xsl:variable name="text"><text><xsl:call-template name="text"/></text></xsl:variable>
		<!-- <xsl:copy-of select="$text"/> -->
		<xsl:for-each select="xalan:nodeset($text)/text/node()">
			<xsl:choose>
				<xsl:when test="self::text()"><xsl:call-template name="add-zero-spaces-java"/></xsl:when>
				<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- default: ignore title in sections/p -->
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]" priority="3"/>

	<xsl:template match="mn:pagebreak">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>

	<xsl:variable name="font_main_root_style">
		<root-style xsl:use-attribute-sets="root-style">
		</root-style>
	</xsl:variable>
	<xsl:variable name="font_main_root_style_font_family" select="xalan:nodeset($font_main_root_style)/root-style/@font-family"/>
	<xsl:variable name="font_main">
		<xsl:choose>
			<xsl:when test="contains($font_main_root_style_font_family, ',')"><xsl:value-of select="substring-before($font_main_root_style_font_family, ',')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$font_main_root_style_font_family"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="language_current_3" select="normalize-space(//mn:bibdata//mn:language)"/>
							<xsl:choose>
								<xsl:when test="$language_current_3 != ''">
									<xsl:value-of select="$language_current_3"/>
								</xsl:when>
								<xsl:otherwise>en</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLang_fromCurrentNode">
		<xsl:variable name="language_current" select="normalize-space(.//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//mn:bibdata//mn:language"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>
	</xsl:template>

	<xsl:template match="mn:localityStack"/>

	<xsl:variable name="pdfAttachmentsList_">
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<attachment filename="{@name}"/>
		</xsl:for-each>
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<attachment filename="{$attachment_path}"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="pdfAttachmentsList" select="xalan:nodeset($pdfAttachmentsList_)"/>

	<xsl:template name="getAltText">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = ''"><xsl:value-of select="@target"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="normalize-space(translate(normalize-space(), ' —', ' -'))"/></xsl:otherwise>
			<!-- <xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise> -->
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setBlockSpanAll">
		<xsl:if test="@columns = 1 or     (local-name() = 'p' and *[@columns = 1])"><xsl:attribute name="span">all</xsl:attribute></xsl:if>
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:choose>
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

	<xsl:template name="extractSection">
		<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="mn:tab">
					<xsl:apply-templates select="mn:tab[1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<!-- main sections -->
	<xsl:template match="/*/mn:sections/*" name="sections_node" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>

			<xsl:call-template name="sections_element_style"/>

			<xsl:call-template name="addReviewHelper"/>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template>

	<!-- note: @top-level added in mode=" update_xml_step_move_pagebreak" -->
	<xsl:template match="mn:sections/mn:page_sequence/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/sections/clause -->
	<xsl:template match="mn:page_sequence/mn:sections/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sections_element_style">
		<xsl:variable name="pos"><xsl:number count="mn:sections/mn:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable>
		<xsl:if test="$pos &gt;= 2">
			<xsl:attribute name="space-before">18pt</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- sections_element_style -->

	<xsl:template match="//mn:metanorma/mn:preface/*" priority="2" name="preface_node"> <!-- /*/mn:preface/* -->
		<fo:block break-after="page"/>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- preface/ page_sequence/clause -->
	<xsl:template match="mn:preface/mn:page_sequence/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/preface/clause -->
	<xsl:template match="mn:page_sequence/mn:preface/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:clause[normalize-space() != '' or mn:figure or @id]" name="template_clause"> <!-- if clause isn't empty -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:if test="parent::mn:copyright-statement">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setId"/>

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_clause_style"/>

			<xsl:call-template name="addReviewHelper"/>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_clause_style">
	</xsl:template> <!-- refine_clause_style -->

	<xsl:template match="mn:annex[normalize-space() != '']">
		<xsl:choose>
			<xsl:when test="@continue = 'true'"> <!-- it's using for figure/table on top level for block span -->
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>

				<fo:block break-after="page"/>
				<xsl:call-template name="setNamedDestination"/>

				<fo:block id="{@id}">

					<xsl:call-template name="setBlockSpanAll"/>

					<xsl:call-template name="refine_annex_style"/>

				</fo:block>

				<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>

				<fo:block>
					<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_annex_style">
	</xsl:template>

	<xsl:template match="mn:name/text() | mn:fmt-name/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>

	<!-- insert fo:basic-link, if external-destination or internal-destination is non-empty, otherwise insert fo:inline -->
	<xsl:template name="insert_basic_link">
		<xsl:param name="element"/>
		<xsl:variable name="element_node" select="xalan:nodeset($element)"/>
		<xsl:variable name="external-destination" select="normalize-space(count($element_node/fo:basic-link/@external-destination[. != '']) = 1)"/>
		<xsl:variable name="internal-destination" select="normalize-space(count($element_node/fo:basic-link/@internal-destination[. != '']) = 1)"/>
		<xsl:choose>
			<xsl:when test="$external-destination = 'true' or $internal-destination = 'true'">
				<xsl:copy-of select="$element_node"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline>
					<xsl:for-each select="$element_node/fo:basic-link/@*[local-name() != 'external-destination' and local-name() != 'internal-destination' and local-name() != 'alt-text']">
						<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:copy-of select="$element_node/fo:basic-link/node()"/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:variant-title"/> <!-- [@type = 'sub'] -->
	<xsl:template match="mn:variant-title[@type = 'sub']" mode="subtitle">
		<fo:inline padding-right="5mm"> </fo:inline>
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:blacksquare" name="blacksquare">
		<fo:inline padding-right="2.5mm" baseline-shift="5%">
			<fo:instream-foreign-object content-height="2mm" content-width="2mm" fox:alt-text="Quad">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" viewBox="0 0 2 2">
						<rect x="0" y="0" width="2" height="2" fill="black"/>
					</svg>
				</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="@language">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="4">
		<xsl:call-template name="title"/>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source"/>
	<xsl:template match="mn:quote/mn:author"/>
	<xsl:template match="mn:amend"/>

	<!-- fmt-title renamed to title in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-title" /> -->

	<!-- fmt-name renamed to name in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-name" /> -->

	<!-- fmt-preferred renamed to preferred in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-preferred" /> -->

	<!-- fmt-admitted renamed to admitted in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-admitted" /> -->

	<!-- fmt-deprecates renamed to deprecates in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-deprecates" /> -->

	<!-- fmt-definition renamed to definition in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-definition" /> -->

	<!-- fmt-termsource renamed to termsource in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-termsource" /> -->

	<!-- fmt-source renamed to source in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-source" /> -->

	<xsl:template match="mn:semx">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label"/>

	<xsl:template match="mn:concept"/>

	<xsl:template match="mn:fmt-concept">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:erefstack"/>

	<xsl:template match="mn:svgmap"/>

	<!-- for correct rendering combining chars, added in mode="update_xml_step2" -->
	<xsl:template match="*[local-name() = 'lang_none']">
		<fo:inline xml:lang="none"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="replaceChar">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = '' or not($replace)">
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:element name="inlineChar" namespace="{$namespace_full}"><xsl:value-of select="$by"/></xsl:element>
				<xsl:call-template name="replaceChar">
						<xsl:with-param name="text" select="substring-after($text,$replace)"/>
						<xsl:with-param name="replace" select="$replace"/>
						<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- inlineChar added in the template replaceChar -->
	<xsl:template match="mn:inlineChar">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="printEdition">
		<xsl:variable name="edition_i18n" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition[normalize-space(@language) != ''])"/>
		<xsl:choose>
			<xsl:when test="$edition_i18n != ''">
				<!-- Example: <edition language="fr">deuxième édition</edition> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$edition_i18n"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="edition" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition)"/>
				<xsl:if test="$edition != ''"> <!-- Example: 1.3 -->
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">edition</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$edition"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- convert YYYY-MM-DD to 'Month YYYY' or 'Month DD, YYYY' or DD Month YYYY -->
	<xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:call-template name="getMonthByNum">
				<xsl:with-param name="num" select="$month"/>
				<xsl:with-param name="lowercase" select="'true'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="monthStr_localized">
			<xsl:if test="normalize-space($monthStr) != ''"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param></xsl:call-template></xsl:if>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'"> <!-- convert date from format 2007-04-01 to 1 April 2007 -->
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr_localized"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $day, ', ' , $year))"/> <!-- January 01, 2022 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template> <!-- convertDate -->

	<!-- return Month's name by number -->
	<xsl:template name="getMonthByNum">
		<xsl:param name="num"/>
		<xsl:param name="lang">en</xsl:param>
		<xsl:param name="lowercase">false</xsl:param> <!-- return 'january' instead of 'January' -->
		<xsl:variable name="monthStr_">
			<xsl:choose>
				<xsl:when test="$lang = 'fr'">
					<xsl:choose>
						<xsl:when test="$num = '01'">Janvier</xsl:when>
						<xsl:when test="$num = '02'">Février</xsl:when>
						<xsl:when test="$num = '03'">Mars</xsl:when>
						<xsl:when test="$num = '04'">Avril</xsl:when>
						<xsl:when test="$num = '05'">Mai</xsl:when>
						<xsl:when test="$num = '06'">Juin</xsl:when>
						<xsl:when test="$num = '07'">Juillet</xsl:when>
						<xsl:when test="$num = '08'">Août</xsl:when>
						<xsl:when test="$num = '09'">Septembre</xsl:when>
						<xsl:when test="$num = '10'">Octobre</xsl:when>
						<xsl:when test="$num = '11'">Novembre</xsl:when>
						<xsl:when test="$num = '12'">Décembre</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$num = '01'">January</xsl:when>
						<xsl:when test="$num = '02'">February</xsl:when>
						<xsl:when test="$num = '03'">March</xsl:when>
						<xsl:when test="$num = '04'">April</xsl:when>
						<xsl:when test="$num = '05'">May</xsl:when>
						<xsl:when test="$num = '06'">June</xsl:when>
						<xsl:when test="$num = '07'">July</xsl:when>
						<xsl:when test="$num = '08'">August</xsl:when>
						<xsl:when test="$num = '09'">September</xsl:when>
						<xsl:when test="$num = '10'">October</xsl:when>
						<xsl:when test="$num = '11'">November</xsl:when>
						<xsl:when test="$num = '12'">December</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($lowercase) = 'true'">
				<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($monthStr_))"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$monthStr_"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getMonthByNum -->

	<!-- return Month's name by number from localized strings -->
	<xsl:template name="getMonthLocalizedByNum">
		<xsl:param name="num"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$num = '01'">january</xsl:when>
				<xsl:when test="$num = '02'">february</xsl:when>
				<xsl:when test="$num = '03'">march</xsl:when>
				<xsl:when test="$num = '04'">april</xsl:when>
				<xsl:when test="$num = '05'">may</xsl:when>
				<xsl:when test="$num = '06'">june</xsl:when>
				<xsl:when test="$num = '07'">july</xsl:when>
				<xsl:when test="$num = '08'">august</xsl:when>
				<xsl:when test="$num = '09'">september</xsl:when>
				<xsl:when test="$num = '10'">october</xsl:when>
				<xsl:when test="$num = '11'">november</xsl:when>
				<xsl:when test="$num = '12'">december</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- getMonthLocalizedByNum -->

	<xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="meta" select="'false'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:param name="meta"/>
		<xsl:choose>
			<xsl:when test="$meta = 'true'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addPDFUAmeta">
		<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
			<pdf:dictionary type="normal" key="ViewerPreferences">
				<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
			</pdf:dictionary>
		</pdf:catalog>
		<x:xmpmeta xmlns:x="adobe:ns:meta/">
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<!-- Commented after upgrade to Apache FOP 2.10
				<rdf:Description xmlns:pdfaExtension="http://www.aiim.org/pdfa/ns/extension/" xmlns:pdfaProperty="http://www.aiim.org/pdfa/ns/property#" xmlns:pdfaSchema="http://www.aiim.org/pdfa/ns/schema#" rdf:about="">
					<pdfaExtension:schemas>
						<rdf:Bag>
							<rdf:li rdf:parseType="Resource">
								<pdfaSchema:namespaceURI>http://www.aiim.org/pdfua/ns/id/</pdfaSchema:namespaceURI>
								<pdfaSchema:prefix>pdfuaid</pdfaSchema:prefix>
								<pdfaSchema:schema>PDF/UA identification schema</pdfaSchema:schema>
								<pdfaSchema:property>
									<rdf:Seq>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA version identifier</pdfaProperty:description>
											<pdfaProperty:name>part</pdfaProperty:name>
											<pdfaProperty:valueType>Integer</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA amendment identifier</pdfaProperty:description>
											<pdfaProperty:name>amd</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA corrigenda identifier</pdfaProperty:description>
											<pdfaProperty:name>corr</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
									</rdf:Seq>
								</pdfaSchema:property>
							</rdf:li>
						</rdf:Bag>
					</pdfaExtension:schemas>
				</rdf:Description> -->
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
								<xsl:value-of select="mn:title[@language = $lang]"/>

							</xsl:for-each>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:choose>
									<xsl:when test="normalize-space($title) != ''">
										<xsl:value-of select="$title"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text> </xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</rdf:li>
						</rdf:Alt>
					</dc:title>
					<xsl:variable name="dc_creator">
						<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
							<rdf:Seq>
								<xsl:for-each select="mn:contributor[mn:role[not(mn:description)]/@type='author']">
									<rdf:li>
										<xsl:value-of select="mn:organization/mn:name"/>
									</rdf:li>
									<!-- <xsl:if test="position() != last()">; </xsl:if> -->
								</xsl:for-each>
							</rdf:Seq>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_creator) != ''">
						<dc:creator>
							<xsl:copy-of select="$dc_creator"/>
						</dc:creator>
					</xsl:if>

					<xsl:variable name="dc_description">
						<xsl:variable name="abstract">
							<xsl:copy-of select="//mn:metanorma/mn:preface/mn:abstract//text()[not(ancestor::mn:fmt-title) and not(ancestor::mn:title) and not(ancestor::mn:fmt-xref-label)]"/>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:value-of select="normalize-space($abstract)"/>
							</rdf:li>
						</rdf:Alt>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_description)">
						<dc:description>
							<xsl:copy-of select="$dc_description"/>
						</dc:description>
					</xsl:if>

					<pdf:Keywords>
						<xsl:call-template name="insertKeywords">
							<xsl:with-param name="meta">true</xsl:with-param>
						</xsl:call-template>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
		<!-- add attachments -->
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<xsl:variable name="bibitem_attachment_" select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment'] = current()/@name]"/>
			<xsl:variable name="bibitem_attachment" select="xalan:nodeset($bibitem_attachment_)"/>
			<xsl:variable name="description" select="normalize-space($bibitem_attachment/mn:formattedref)"/>
			<xsl:variable name="filename" select="java:org.metanorma.fop.Util.getFilenameFromPath(@name)"/>
			<!-- Todo: need update -->
			<xsl:variable name="afrelationship" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-AFRelationship'])"/>
			<xsl:variable name="volatile" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-volatile'])"/>

			<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" filename="{$filename}" link-as-file-annotation="true">
				<xsl:attribute name="src">
					<xsl:choose>
						<xsl:when test="normalize-space() != ''">
							<xsl:variable name="src_attachment" select="java:replaceAll(java:java.lang.String.new(.),'(&#13;&#10;|&#13;|&#10;)', '')"/> <!-- remove line breaks -->
							<xsl:value-of select="$src_attachment"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="url" select="concat('url(file:///',$inputxml_basepath , @name, ')')"/>
							<xsl:value-of select="$url"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="$description != ''">
					<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$afrelationship != ''">
					<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$volatile != ''">
					<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
				</xsl:if>
			</pdf:embedded-file>
		</xsl:for-each>
		<!-- references to external attachments (no binary-encoded within the Metanorma XML file) -->
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<xsl:variable name="attachment_name" select="java:org.metanorma.fop.Util.getFilenameFromPath($attachment_path)"/>
				<!-- <xsl:variable name="url" select="concat('url(file:///',$basepath, $attachment_path, ')')"/> -->
				<!-- See https://github.com/metanorma/metanorma-iso/issues/1369 -->
				<xsl:variable name="url" select="concat('url(file:///',$outputpdf_basepath, $attachment_path, ')')"/>
				<xsl:variable name="description" select="normalize-space(mn:formattedref)"/>
				<!-- Todo: need update -->
				<xsl:variable name="afrelationship" select="normalize-space(.//mn:classification[@type = 'pdf-AFRelationship'])"/>
				<xsl:variable name="volatile" select="normalize-space(.//mn:classification[@type = 'pdf-volatile'])"/>
				<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" src="{$url}" filename="{$attachment_name}" link-as-file-annotation="true">
					<xsl:if test="$description != ''">
						<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$afrelationship != ''">
						<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$volatile != ''">
						<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
					</xsl:if>
				</pdf:embedded-file>
			</xsl:for-each>
		</xsl:if>
	</xsl:template> <!-- addPDFUAmeta -->

	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Get or calculate depth of the element -->
	<xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<!-- <xsl:message>
			<xsl:choose>
				<xsl:when test="local-name() = 'title'">title=<xsl:value-of select="."/></xsl:when>
				<xsl:when test="local-name() = 'clause'">clause/title=<xsl:value-of select="mn:title"/></xsl:when>
			</xsl:choose>
		</xsl:message> -->
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*[local-name() != 'page_sequence'])"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::mn:preface">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface and not(ancestor::mn:foreword) and not(ancestor::mn:introduction)"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-title">
							<!-- determine 'depth' depends on upper clause with title/@depth -->
							<!-- <xsl:message>title=<xsl:value-of select="."/></xsl:message> -->
							<xsl:variable name="clause_with_depth_depth" select="ancestor::mn:clause[mn:fmt-title/@depth][1]/mn:fmt-title/@depth"/>
							<!-- <xsl:message>clause_with_depth_depth=<xsl:value-of select="$clause_with_depth_depth"/></xsl:message> -->
							<xsl:variable name="clause_with_depth_level" select="count(ancestor::mn:clause[mn:fmt-title/@depth][1]/ancestor::*)"/>
							<!-- <xsl:message>clause_with_depth_level=<xsl:value-of select="$clause_with_depth_level"/></xsl:message> -->
							<xsl:variable name="curr_level" select="count(ancestor::*) - 1"/>
							<!-- <xsl:message>curr_level=<xsl:value-of select="$curr_level"/></xsl:message> -->
							<!-- <xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:title/@depth)"/> -->
							<xsl:variable name="curr_clause_depth" select="number($clause_with_depth_depth) + (number($curr_level) - number($clause_with_depth_level)) "/>
							<!-- <xsl:message>curr_clause_depth=<xsl:value-of select="$curr_clause_depth"/></xsl:message> -->
							<xsl:choose>
								<xsl:when test="string(number($curr_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($curr_clause_depth)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-name and parent::mn:term">
							<xsl:variable name="upper_terms_depth" select="normalize-space(ancestor::mn:terms[1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_terms_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_terms_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::*[self::mn:clause or self::mn:terms][1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:bibliography">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::mn:annex">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex and self::mn:fmt-title">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="self::mn:annex">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevel -->

	<!-- Get or calculate depth of term's name -->
	<xsl:template name="getLevelTermName">
		<xsl:choose>
			<xsl:when test="normalize-space(../@depth) != ''">
				<xsl:value-of select="../@depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title_level_">
					<xsl:for-each select="../preceding-sibling::mn:fmt-title[1]">
						<xsl:call-template name="getLevel"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="title_level" select="normalize-space($title_level_)"/>
				<xsl:choose>
					<xsl:when test="$title_level != ''"><xsl:value-of select="$title_level + 1"/></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getLevel"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevelTermName -->

	<!-- split string by separator -->
	<xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:param name="keep_sep" select="'false'"/>
		<xsl:if test="string-length($pText) &gt;0">
			<xsl:element name="item" namespace="{$namespace_mn_xsl}">
				<xsl:choose>
					<xsl:when test="$normalize-space = 'true'">
						<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:if test="$keep_sep = 'true' and contains($pText, $sep)"><xsl:element name="item" namespace="{$namespace_mn_xsl}"><xsl:value-of select="$sep"/></xsl:element></xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space" select="$normalize-space"/>
				<xsl:with-param name="keep_sep" select="$keep_sep"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- split -->

	<xsl:template name="getDocumentId">
		<xsl:call-template name="getLang"/><xsl:value-of select="//mn:p[1]/@id"/>
	</xsl:template>

	<xsl:template name="getDocumentId_fromCurrentNode">
		<xsl:call-template name="getLang_fromCurrentNode"/><xsl:value-of select=".//mn:p[1]/@id"/>
	</xsl:template>

	<xsl:template name="setId">
		<xsl:param name="prefix"/>
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="concat($prefix, @id)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($prefix, generate-id())"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="setIDforNamedDestination">
		<xsl:if test="@named_dest">
			<xsl:attribute name="id"><xsl:value-of select="@named_dest"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setIDforNamedDestinationInline">
		<xsl:if test="@named_dest">
			<fo:inline><xsl:call-template name="setIDforNamedDestination"/></fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setNamedDestination">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- skip GUID, e.g. _33eac3cb-9663-4291-ae26-1d4b6f4635fc -->
			<xsl:if test="@id and       normalize-space(java:matches(java:java.lang.String.new(@id), '_[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}')) = 'false'">
				<fox:destination internal-destination="{@id}"/>
			</xsl:if>
			<xsl:for-each select=". | mn:fmt-title | mn:fmt-name">
				<xsl:if test="@named_dest">
					<fox:destination internal-destination="{@named_dest}"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getLocalizedString">
		<xsl:param name="key"/>
		<xsl:param name="formatted">false</xsl:param>
		<xsl:param name="lang"/>
		<xsl:param name="returnEmptyIfNotFound">false</xsl:param>
		<xsl:param name="bibdata_updated"/>

		<xsl:variable name="curr_lang">
			<xsl:choose>
				<xsl:when test="$lang != ''"><xsl:value-of select="$lang"/></xsl:when>
				<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="data_value">
			<xsl:choose>
				<xsl:when test="$formatted = 'true' and string-length($bibdata_updated) != 0">
					<xsl:apply-templates select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="string-length($bibdata_updated) != 0">
					<xsl:value-of select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space($data_value) != ''">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'"><xsl:copy-of select="$data_value"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$data_value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLocalizedString -->

	<xsl:template name="setTrackChangesStyles">
		<xsl:param name="isAdded"/>
		<xsl:param name="isDeleted"/>

		<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
		<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>

		<xsl:choose>
			<xsl:when test="local-name() = 'math'">
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-added"/></xsl:attribute>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-deleted"/></xsl:attribute>
					<xsl:if test="local-name() = 'table'">
						<xsl:attribute name="background-color">rgb(255, 185, 185)</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- setTrackChangesStyles -->

	<!--  see https://xmlgraphics.apache.org/fop/2.5/complexscripts.html#bidi_controls-->
	<xsl:variable name="LRM" select="'‎'"/> <!-- U+200E - LEFT-TO-RIGHT MARK (LRM) -->
	<xsl:variable name="RLM" select="'‏'"/> <!-- U+200F - RIGHT-TO-LEFT MARK (RLM) -->
	<xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setTextAlignment">
		<xsl:param name="default">left</xsl:param>
		<xsl:variable name="align" select="normalize-space(@align)"/>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
				<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
				<xsl:when test="$align = 'justified'">justify</xsl:when>
				<xsl:when test="$align != '' and not($align = 'indent')"><xsl:value-of select="$align"/></xsl:when>
				<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
				<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$align = 'indent'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setBlockAttributes">
		<xsl:param name="text_align_default">left</xsl:param>
		<xsl:call-template name="setTextAlignment">
			<xsl:with-param name="default" select="$text_align_default"/>
		</xsl:call-template>
		<xsl:call-template name="setKeepAttributes"/>
	</xsl:template>

	<xsl:template name="setKeepAttributes">
		<!-- https://www.metanorma.org/author/topics/document-format/text/#avoiding-page-breaks -->
		<!-- Example: keep-lines-together="true" -->
		<xsl:if test="@keep-lines-together = 'true'">
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<!-- Example: keep-with-next="true" -->
		<xsl:if test="@keep-with-next =  'true'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- insert cover page image -->
	<!-- background cover image -->
	<xsl:template name="insertBackgroundPageImage">
		<xsl:param name="number">1</xsl:param>
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:param name="suffix"/>
		<xsl:variable name="num" select="number($number)"/>
		<!-- background image -->
		<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0" id="__internal_layout__coverpage{$suffix}_{$name}_{$number}_{generate-id()}">
			<fo:block>
				<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = $name][1]/mn:value/mn:image[$num]">
					<xsl:choose>
						<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
							<fo:instream-foreign-object fox:alt-text="Image Front">
								<xsl:attribute name="content-height"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
								<xsl:call-template name="getSVG"/>
							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:when test="starts-with(@src, 'data:application/pdf;base64')">
							<fo:external-graphic src="{@src}" fox:alt-text="Image Front"/>
						</xsl:when>
						<xsl:otherwise> <!-- bitmap image -->
							<xsl:variable name="coverimage_src" select="normalize-space(@src)"/>
							<xsl:if test="$coverimage_src != ''">
								<xsl:variable name="coverpage">
									<xsl:call-template name="getImageURL">
										<xsl:with-param name="src" select="$coverimage_src"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:variable name="coverpage" select="concat('url(file:',$basepath, 'coverpage1.png', ')')"/> --> <!-- for DEBUG -->
								<fo:external-graphic src="{$coverpage}" width="{$pageWidth}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="getImageURL">
		<xsl:param name="src"/>
		<xsl:choose>
			<xsl:when test="starts-with($src, 'data:image')">
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:value-of select="concat('url(file:///', $src_external, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getSVG">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg']">
				<xsl:apply-templates select="*[local-name() = 'svg']" mode="svg_update"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="svg_content" select="document(@src)"/>
				<xsl:for-each select="xalan:nodeset($svg_content)/node()">
					<xsl:apply-templates select="." mode="svg_update"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- END: insert cover page image -->

	<!-- https://github.com/metanorma/docs/blob/main/109.adoc -->
	<xsl:variable name="regex_ja_spec_half_width_">
		\u0028  <!-- U+0028 LEFT PARENTHESIS (() -->
		\u0029 <!-- U+0029 RIGHT PARENTHESIS ()) -->
		\u007B <!-- U+007B LEFT CURLY BRACKET ({) -->
		\u007D <!-- U+007D RIGHT CURLY BRACKET (}) -->
		\uFF62 <!-- U+FF62 HALFWIDTH LEFT CORNER BRACKET (｢) -->
		\uFF63 <!-- U+FF63 HALFWIDTH RIGHT CORNER BRACKET (｣) -->
		\u005B <!-- U+005B LEFT SQUARE BRACKET ([) -->
		\u005D <!-- U+005D RIGHT SQUARE BRACKET (]) -->
	</xsl:variable>
	<xsl:variable name="regex_ja_spec_half_width" select="translate(normalize-space($regex_ja_spec_half_width_), ' ', '')"/>
	<xsl:variable name="regex_ja_spec_">[
		<!-- Rotate 90° clockwise -->
		<xsl:value-of select="$regex_ja_spec_half_width"/>
		\uFF08 <!-- U+FF08 FULLWIDTH LEFT PARENTHESIS (（) -->
		\uFF09 <!-- U+FF09 FULLWIDTH RIGHT PARENTHESIS (）) -->
		\uFF5B <!-- U+FF5B FULLWIDTH LEFT CURLY BRACKET (｛) -->
		\uFF5D <!-- U+FF5D FULLWIDTH RIGHT CURLY BRACKET (｝) -->
		\u3014 <!-- U+3014 LEFT TORTOISE SHELL BRACKET (〔) -->
		\u3015 <!-- U+3015 RIGHT TORTOISE SHELL BRACKET (〕) -->
		\u3010 <!-- U+3010 LEFT BLACK LENTICULAR BRACKET (【) -->
		\u3011 <!-- U+3011 RIGHT BLACK LENTICULAR BRACKET (】) -->
		\u300A <!-- U+300A LEFT DOUBLE ANGLE BRACKET (《) -->
		\u300B <!-- U+300B RIGHT DOUBLE ANGLE BRACKET (》) -->
		\u300C <!-- U+300C LEFT CORNER BRACKET (「) -->
		\u300D <!-- U+300D RIGHT CORNER BRACKET (」) -->
		\u300E <!-- U+300E LEFT WHITE CORNER BRACKET (『) -->
		\u300F <!-- U+300F RIGHT WHITE CORNER BRACKET (』) -->
		\uFF3B <!-- U+FF3B FULLWIDTH LEFT SQUARE BRACKET (［) -->
		\uFF3D <!-- U+FF3D FULLWIDTH RIGHT SQUARE BRACKET (］) -->
		\u3008 <!-- U+3008 LEFT ANGLE BRACKET (〈) -->
		\u3009 <!-- U+3009 RIGHT ANGLE BRACKET (〉) -->
		\u3016 <!-- U+3016 LEFT WHITE LENTICULAR BRACKET (〖) -->
		\u3017 <!-- U+3017 RIGHT WHITE LENTICULAR BRACKET (〗) -->
		\u301A <!-- U+301A LEFT WHITE SQUARE BRACKET (〚) -->
		\u301B <!-- U+301B RIGHT WHITE SQUARE BRACKET (〛) -->
		\u301C <!-- U+301C WAVE DASH (〜) -->
		\u3030 <!-- U+3030 WAVY DASH (〰 )-->
		\u30FC <!-- U+30FC KATAKANA-HIRAGANA PROLONGED SOUND MARK (ー) -->
		\u2329 <!-- U+2329 LEFT-POINTING ANGLE BRACKET (〈) -->
		\u232A <!-- U+232A RIGHT-POINTING ANGLE BRACKET (〉) -->
		\u3018 <!-- U+3018 LEFT WHITE TORTOISE SHELL BRACKET (〘) -->
		\u3019 <!-- U+3019 RIGHT WHITE TORTOISE SHELL BRACKET (〙) -->
		\u30A0 <!-- U+30A0 KATAKANA-HIRAGANA DOUBLE HYPHEN (゠) -->
		\uFE59 <!-- U+FE59 SMALL LEFT PARENTHESIS (﹙) -->
		\uFE5A <!-- U+FE5A SMALL RIGHT PARENTHESIS (﹚) -->
		\uFE5B <!-- U+FE5B SMALL LEFT CURLY BRACKET (﹛) -->
		\uFE5C <!-- U+FE5C SMALL RIGHT CURLY BRACKET (﹜) -->
		\uFE5D <!-- U+FE5D SMALL LEFT TORTOISE SHELL BRACKET (﹝) -->
		\uFE5E <!-- U+FE5E SMALL RIGHT TORTOISE SHELL BRACKET (﹞) -->
		\uFF5C <!-- U+FF5C FULLWIDTH VERTICAL LINE (｜) -->
		\uFF5F <!-- U+FF5F FULLWIDTH LEFT WHITE PARENTHESIS (｟) -->
		\uFF60 <!-- U+FF60 FULLWIDTH RIGHT WHITE PARENTHESIS (｠) -->
		\uFFE3 <!-- U+FFE3 FULLWIDTH MACRON (￣) -->
		\uFF3F <!-- U+FF3F FULLWIDTH LOW LINE (＿) -->
		\uFF5E <!-- U+FF5E FULLWIDTH TILDE (～) -->
		<!-- Rotate 180° -->
		\u309C <!-- U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜) -->
		\u3002 <!-- U+3002 IDEOGRAPHIC FULL STOP (。) -->
		\uFE52 <!-- U+FE52 SMALL FULL STOP (﹒) -->
		\uFF0E <!-- U+FF0E FULLWIDTH FULL STOP (．) -->
		]</xsl:variable>
	<xsl:variable name="regex_ja_spec"><xsl:value-of select="translate(normalize-space($regex_ja_spec_), ' ', '')"/></xsl:variable>
	<xsl:template name="insertVerticalChar">
		<xsl:param name="str"/>
		<xsl:param name="char_prev"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<xsl:choose>
			<xsl:when test="ancestor::mn:span[@class = 'norotate']">
				<xsl:value-of select="$str"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length($str) &gt; 0">

					<!-- <xsl:variable name="horizontal_mode" select="normalize-space(ancestor::mn:span[@class = 'horizontal'] and 1 = 1)"/> -->
					<xsl:variable name="char" select="substring($str,1,1)"/>
					<xsl:variable name="char_next" select="substring($str,2,1)"/>

					<xsl:variable name="char_half_width" select="normalize-space(java:matches(java:java.lang.String.new($char), concat('([', $regex_ja_spec_half_width, ']{1,})')))"/>

					<xsl:choose>
						<xsl:when test="$char_half_width = 'true'">
							<fo:inline>
								<xsl:attribute name="baseline-shift">7%</xsl:attribute>
								<xsl:value-of select="$char"/>
							</fo:inline>
						</xsl:when>
						<xsl:otherwise>
							<!--  namespace-uri(ancestor::mn:title) != '' to skip title from $contents  -->
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_prev = '' and ../preceding-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
							<fo:inline-container text-align="center" alignment-baseline="central" width="1em" margin="0" padding="0" text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP" text-align-last="center">
								<xsl:if test="normalize-space($writing-mode) != ''">
									<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
									<xsl:attribute name="reference-orientation">90</xsl:attribute>
								</xsl:if>
								<xsl:if test="normalize-space(java:matches(java:java.lang.String.new($char), concat('(', $regex_ja_spec, '{1,})'))) = 'true'">
									<xsl:attribute name="reference-orientation">0</xsl:attribute>
								</xsl:if>
								<xsl:if test="$char = '゜' or $char = '。' or $char = '﹒' or $char = '．'">
									<!-- Rotate 180°: 
										U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜)
										U+3002 IDEOGRAPHIC FULL STOP (。)
										U+FE52 SMALL FULL STOP (﹒)
										U+FF0E FULLWIDTH FULL STOP (．)
									-->
									<xsl:attribute name="reference-orientation">-90</xsl:attribute>
								</xsl:if>
								<fo:block-container width="1em" role="SKIP"><!-- border="0.5pt solid blue" -->
									<fo:block line-height="1em" role="SKIP">
										<!-- <xsl:choose>
											<xsl:when test="$horizontal_mode = 'true'">
												<xsl:value-of select="$str"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$char"/>
											</xsl:otherwise>
										</xsl:choose> -->
										<xsl:value-of select="$char"/>
									</fo:block>
								</fo:block-container>
							</fo:inline-container>
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_next != '' or ../following-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:if test="$add_zero_width_space = 'true' and ($char = ',' or $char = '.' or $char = ' ' or $char = '·' or $char = ')' or $char = ']' or $char = '}' or $char = '/')"><xsl:value-of select="$zero_width_space"/></xsl:if>
						<!-- <xsl:if test="$horizontal_mode = 'false'"> -->
							<xsl:call-template name="insertVerticalChar">
								<xsl:with-param name="str" select="substring($str, 2)"/>
								<xsl:with-param name="char_prev" select="$char"/>
								<xsl:with-param name="writing-mode" select="$writing-mode"/>
								<xsl:with-param name="reference-orientation" select="$reference-orientation"/>
								<xsl:with-param name="add_zero_width_space" select="$add_zero_width_space"/>
							</xsl:call-template>
						<!-- </xsl:if> -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertHorizontalChars">
		<xsl:param name="str"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<fo:inline-container text-align="center" alignment-baseline="central" width="1em" margin="0" padding="0" text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP">
			<xsl:if test="normalize-space($writing-mode) != ''">
				<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
				<xsl:attribute name="reference-orientation">90</xsl:attribute>
			</xsl:if>
			<fo:block-container width="1em" role="SKIP"> <!-- border="0.5pt solid green" -->
				<fo:block line-height="1em" role="SKIP">
					<xsl:value-of select="$str"/>
				</fo:block>
			</fo:block-container>
		</fo:inline-container>
	</xsl:template>

	<xsl:template name="number-to-words">
		<xsl:param name="number"/>
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
				<words>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'"> <!-- https://en.wiktionary.org/wiki/Appendix:French_numbers -->
							<word cardinal="1">Une-</word>
							<word ordinal="1">Première </word>
							<word cardinal="2">Deux-</word>
							<word ordinal="2">Seconde </word>
							<word cardinal="3">Trois-</word>
							<word ordinal="3">Tierce </word>
							<word cardinal="4">Quatre-</word>
							<word ordinal="4">Quatrième </word>
							<word cardinal="5">Cinq-</word>
							<word ordinal="5">Cinquième </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixième </word>
							<word cardinal="7">Sept-</word>
							<word ordinal="7">Septième </word>
							<word cardinal="8">Huit-</word>
							<word ordinal="8">Huitième </word>
							<word cardinal="9">Neuf-</word>
							<word ordinal="9">Neuvième </word>
							<word ordinal="10">Dixième </word>
							<word ordinal="11">Onzième </word>
							<word ordinal="12">Douzième </word>
							<word ordinal="13">Treizième </word>
							<word ordinal="14">Quatorzième </word>
							<word ordinal="15">Quinzième </word>
							<word ordinal="16">Seizième </word>
							<word ordinal="17">Dix-septième </word>
							<word ordinal="18">Dix-huitième </word>
							<word ordinal="19">Dix-neuvième </word>
							<word cardinal="20">Vingt-</word>
							<word ordinal="20">Vingtième </word>
							<word cardinal="30">Trente-</word>
							<word ordinal="30">Trentième </word>
							<word cardinal="40">Quarante-</word>
							<word ordinal="40">Quarantième </word>
							<word cardinal="50">Cinquante-</word>
							<word ordinal="50">Cinquantième </word>
							<word cardinal="60">Soixante-</word>
							<word ordinal="60">Soixantième </word>
							<word cardinal="70">Septante-</word>
							<word ordinal="70">Septantième </word>
							<word cardinal="80">Huitante-</word>
							<word ordinal="80">Huitantième </word>
							<word cardinal="90">Nonante-</word>
							<word ordinal="90">Nonantième </word>
							<word cardinal="100">Cent-</word>
							<word ordinal="100">Centième </word>
						</xsl:when>
						<xsl:when test="$lang = 'ru'">
							<word cardinal="1">Одна-</word>
							<word ordinal="1">Первое </word>
							<word cardinal="2">Две-</word>
							<word ordinal="2">Второе </word>
							<word cardinal="3">Три-</word>
							<word ordinal="3">Третье </word>
							<word cardinal="4">Четыре-</word>
							<word ordinal="4">Четвертое </word>
							<word cardinal="5">Пять-</word>
							<word ordinal="5">Пятое </word>
							<word cardinal="6">Шесть-</word>
							<word ordinal="6">Шестое </word>
							<word cardinal="7">Семь-</word>
							<word ordinal="7">Седьмое </word>
							<word cardinal="8">Восемь-</word>
							<word ordinal="8">Восьмое </word>
							<word cardinal="9">Девять-</word>
							<word ordinal="9">Девятое </word>
							<word ordinal="10">Десятое </word>
							<word ordinal="11">Одиннадцатое </word>
							<word ordinal="12">Двенадцатое </word>
							<word ordinal="13">Тринадцатое </word>
							<word ordinal="14">Четырнадцатое </word>
							<word ordinal="15">Пятнадцатое </word>
							<word ordinal="16">Шестнадцатое </word>
							<word ordinal="17">Семнадцатое </word>
							<word ordinal="18">Восемнадцатое </word>
							<word ordinal="19">Девятнадцатое </word>
							<word cardinal="20">Двадцать-</word>
							<word ordinal="20">Двадцатое </word>
							<word cardinal="30">Тридцать-</word>
							<word ordinal="30">Тридцатое </word>
							<word cardinal="40">Сорок-</word>
							<word ordinal="40">Сороковое </word>
							<word cardinal="50">Пятьдесят-</word>
							<word ordinal="50">Пятидесятое </word>
							<word cardinal="60">Шестьдесят-</word>
							<word ordinal="60">Шестидесятое </word>
							<word cardinal="70">Семьдесят-</word>
							<word ordinal="70">Семидесятое </word>
							<word cardinal="80">Восемьдесят-</word>
							<word ordinal="80">Восьмидесятое </word>
							<word cardinal="90">Девяносто-</word>
							<word ordinal="90">Девяностое </word>
							<word cardinal="100">Сто-</word>
							<word ordinal="100">Сотое </word>
						</xsl:when>
						<xsl:otherwise> <!-- default english -->
							<word cardinal="1">One-</word>
							<word ordinal="1">First </word>
							<word cardinal="2">Two-</word>
							<word ordinal="2">Second </word>
							<word cardinal="3">Three-</word>
							<word ordinal="3">Third </word>
							<word cardinal="4">Four-</word>
							<word ordinal="4">Fourth </word>
							<word cardinal="5">Five-</word>
							<word ordinal="5">Fifth </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixth </word>
							<word cardinal="7">Seven-</word>
							<word ordinal="7">Seventh </word>
							<word cardinal="8">Eight-</word>
							<word ordinal="8">Eighth </word>
							<word cardinal="9">Nine-</word>
							<word ordinal="9">Ninth </word>
							<word ordinal="10">Tenth </word>
							<word ordinal="11">Eleventh </word>
							<word ordinal="12">Twelfth </word>
							<word ordinal="13">Thirteenth </word>
							<word ordinal="14">Fourteenth </word>
							<word ordinal="15">Fifteenth </word>
							<word ordinal="16">Sixteenth </word>
							<word ordinal="17">Seventeenth </word>
							<word ordinal="18">Eighteenth </word>
							<word ordinal="19">Nineteenth </word>
							<word cardinal="20">Twenty-</word>
							<word ordinal="20">Twentieth </word>
							<word cardinal="30">Thirty-</word>
							<word ordinal="30">Thirtieth </word>
							<word cardinal="40">Forty-</word>
							<word ordinal="40">Fortieth </word>
							<word cardinal="50">Fifty-</word>
							<word ordinal="50">Fiftieth </word>
							<word cardinal="60">Sixty-</word>
							<word ordinal="60">Sixtieth </word>
							<word cardinal="70">Seventy-</word>
							<word ordinal="70">Seventieth </word>
							<word cardinal="80">Eighty-</word>
							<word ordinal="80">Eightieth </word>
							<word cardinal="90">Ninety-</word>
							<word ordinal="90">Ninetieth </word>
							<word cardinal="100">Hundred-</word>
							<word ordinal="100">Hundredth </word>
						</xsl:otherwise>
					</xsl:choose>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>

			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:variable name="value_lc" select="java:toLowerCase(java:java.lang.String.new($value))"/>
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="$value_lc"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template> <!-- number-to-words -->

	<!-- st for 1, nd for 2, rd for 3, th for 4, 5, 6, ... -->
	<xsl:template name="number-to-ordinal">
		<xsl:param name="number"/>
		<xsl:param name="curr_lang"/>
		<xsl:choose>
			<xsl:when test="$curr_lang = 'fr'">
				<xsl:choose>
					<xsl:when test="$number = '1'">re</xsl:when>
					<xsl:otherwise>e</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$number = 1">st</xsl:when>
					<xsl:when test="$number = 2">nd</xsl:when>
					<xsl:when test="$number = 3">rd</xsl:when>
					<xsl:otherwise>th</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- number-to-ordinal -->

	<!-- add the attribute fox:alt-text, required for PDF/UA -->
	<xsl:template name="setAltText">
		<xsl:param name="value"/>
		<xsl:attribute name="fox:alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space($value) != ''">
					<xsl:value-of select="$value"/>
				</xsl:when>
				<xsl:otherwise>_</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="substring-after-last">
		<xsl:param name="value"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($value, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="substring-after($value, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================= -->
	<!--  mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->
	<xsl:template match="*" mode="print_as_xml">
		<xsl:param name="level">0</xsl:param>

		<fo:block margin-left="{2*$level}mm">
			<xsl:text>
&lt;</xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:for-each select="@*">
				<xsl:text> </xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>"</xsl:text>
			</xsl:for-each>
			<xsl:text>&gt;</xsl:text>

			<xsl:if test="not(*)">
				<fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline>
				<xsl:text>&lt;/</xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>&gt;</xsl:text>
			</xsl:if>
		</fo:block>

		<xsl:if test="*">
			<fo:block>
				<xsl:apply-templates mode="print_as_xml">
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:apply-templates>
			</fo:block>
			<fo:block margin-left="{2*$level}mm">
				<xsl:text>&lt;/</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>&gt;</xsl:text>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- ============================================= -->
	<!-- END: mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->

	<!-- ============================================= -->
	<!-- mode="set_table_role_skip" -->
	<!-- ============================================= -->
	<xsl:template match="@*|node()" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(local-name(), 'table')]" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="set_table_role_skip"/>
			<xsl:attribute name="role">SKIP</xsl:attribute>
			<xsl:apply-templates select="node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>
	<!-- ============================================= -->
	<!-- END: mode="set_table_role_skip" -->
	<!-- ============================================= -->

</xsl:stylesheet>