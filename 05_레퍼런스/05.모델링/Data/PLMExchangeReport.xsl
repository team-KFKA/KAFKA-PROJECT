<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">

	<xsl:output method="html" indent="yes" encoding="UTF-8"/>

	<!-- COPYRIGHT DASSAULT SYSTEMES 2025 -->
	<!-- @fullreview	SKR104	23:01:25 -->

	<xsl:variable name="ProcessName">
		<xsl:value-of select="Execution/@Name"/>
	</xsl:variable>
	<xsl:variable name="ExecutionStatus">
		<xsl:value-of select="Execution/@status"/>
	</xsl:variable>

	<xsl:variable name="IconSize">18</xsl:variable>
	<xsl:variable name="COLORFatal">#FF0000</xsl:variable>
	<xsl:variable name="COLORError">#FF9900</xsl:variable>
	<xsl:variable name="COLORWarning">#CCFF00</xsl:variable>
 <xsl:variable name="COLORInfo">#FCDF8E</xsl:variable>
	<xsl:variable name="COLORDefault"></xsl:variable>

	<xsl:variable name="ObjExchangeResult">
		<xsl:choose>
			<xsl:when test="$ExecutionStatus='Error' or count(Execution/Notification[@Sev='Error' or @Sev='Fatal'])!=0">1</xsl:when>
			<xsl:otherwise>2</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ObjStatusIcon">
		<xsl:if test="$ObjExchangeResult=1">Data\Infra_Icon_Error.gif</xsl:if>
		<xsl:if test="$ObjExchangeResult=2">Data\Infra_Icon_Success.gif</xsl:if>
	</xsl:variable>
	<xsl:variable name="ObjStatusCellBGCOLOR">
		<xsl:if test="$ObjExchangeResult=1"><xsl:copy-of select="$COLORError"/></xsl:if>
		<xsl:if test="$ObjExchangeResult=2"><xsl:copy-of select="$COLORDefault"/></xsl:if>
	</xsl:variable>
	<xsl:variable name="ReportName">
		<xsl:value-of select=".//Option[@Name='PLMExchangeExperienceReportServices.Option.Report.Name']/@value"/>
	</xsl:variable>
	<xsl:variable name="CompatibilityOption">
		<xsl:value-of select=".//Option[@Name='PLMExport3DXMLDesign.3DXML.Option.Compatibility']/@value"/>
	</xsl:variable>
	<xsl:variable name="SplitOption">
		<xsl:value-of select=".//Option[@Name='PLMExport3DXMLDesign.3DXML.Option.ExportSplit']/@value"/>
	</xsl:variable>

	<!-- ============================================= -->
	<!--  Template corresponding to root Execution node  -->
	<!-- ============================================= -->
	<!-- <Execution Id="2" Name="Report" version="0.1" status="Succeeded"> -->

	<xsl:template match="Execution">
		<html>
			<head>
				<link rel="stylesheet" type="text/css" href="Data/Report3DXML.css"/>
				<script id="scripttag" type="text/javascript" src="Data/Report3DXML.js"></script>
			</head>

			<!--   1-  Initialization (HTML header and style-sheet) -->
			<xsl:call-template name="ReportHeader"/>

			<!--   2- Generate report for each execution -->
			<xsl:call-template name="ReportExecution"/>

			<!--   3- HTML footer -->
			<xsl:call-template name="ReportFooter"/>
		</html>
	</xsl:template>
	<!-- End of 'Session' template -->


	<!-- ==============================================	-->
	<!--  ReportHeader template							-->
	<!-- ==============================================	-->

	<xsl:template name="ReportHeader">
		<!--   1- HTML header -->
		<body link="#0000FF" vlink="#800080" BGCOLOR="white" background="Data/PLMBatch_DSBackground.jpg" bgproperties="fixed">
			<style>
				.Entete {font: 40 pt bold; color: blue; text-align: center}
				.Menu {font: 20 pt; text-align: right; text-align: bottom}
				.Normal {font: 12pt bold;	text-align: left;color: red; text-align: bottom}
				.Normal2 {font: 20pt bold;	text-align: left; color: green; text-align: bottom}
				.Parameter {font: 14pt; color:red; text-align: left;font-style:italic}
				.Input { font-weight:bold;font-family="Arial";color:#314292;font-size=15;background-color: #D8D8D8;}
				.Comment { font-weight:bold;font-family="Arial";color:blue;font-size=15;background-color: #D8D8D8;}
				.hyperlink{font-weight:bold;font-family="Arial";color:blue;font-size=12}
			</style>
		</body>
		<table border="0" width="100%" height="80" cellpadding="0" cellspacing="0" background="Data/PLMBatch_DSBanner.jpg">
			<tr>
				<td width="100"></td>
				<td width="1000">
					<i>
						<b>
							<xsl:choose>
								<xsl:when test="$ProcessName='Downward 3DXML Export'">
									<font SIZE="+2" COLOR="WHITE">Downward Export Report</font>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$ProcessName='PLMImportExperience3DXMLRev' or $ProcessName='PLMImportExperience3DXMLAuth'">
											<font SIZE="+2" COLOR="WHITE">Interactive Import Report</font>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$ProcessName='UUE_3DXMLCustomization'or $ProcessName='UUE_3DXMLReviewCustomization'">
													<font SIZE="+2" COLOR="WHITE">Interactive Export Report</font>
												</xsl:when>
												<xsl:otherwise>
													<font size="+2" COLOR="WHITE">Interactive Exchange Report</font>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</b>
					</i>
				</td>
				<td width="45">
					<xsl:if test="$ExecutionStatus='Succeeded'">
						<img align="right" height="50" src="Data/Infra_Icon_Success.gif" border="0"></img>
					</xsl:if>
					<xsl:if test="$ExecutionStatus='Error'">
						<img align="right" height="50" src="Data/Infra_Icon_Error.gif" border="0"></img>
					</xsl:if>
				</td>
				<td align="center" width="100">
					<font size="-1" COLOR="WHITE">
						Version <xsl:value-of select="@version"/>
					</font>
				</td>
				<td width="25"></td>
			</tr>
		</table>
	</xsl:template>
	<!-- End of 'ReportHeader' template -->


	<!-- ==============================================	-->
	<!--  ReportFooter template							-->
	<!-- ==============================================	-->

	<xsl:template name="ReportFooter">
		<HR COLOR="orange"></HR>
		<P align="right">
			<I>Copyright Dassault Systèmes (DSSL) 2025 - Visit us at:
				<A href="http://www.3ds.com">www.3ds.com</A>
			</I>
		</P>
	</xsl:template>
	<!-- End of 'ReportFooter' template -->


	<!-- ================================================ -->
	<!--  Template corresponding to root Execution node   -->
	<!-- ================================================ -->

	<xsl:template name="ReportExecution">
		<xsl:if test="count(./Notification)!=0">
			<h2>Notifications:</h2>
			<table border="1" width="100%" cellpadding="5" cellspacing="0">
				<tr align="center" bgcolor="000080">
					<td>
						<b>
							<font COLOR="white" FACE="Arial">Severity</font>
						</b>
					</td>
					<td>
						<b>
							<font COLOR="white" FACE="Arial">Type</font>
						</b>
					</td>
					<td>
						<b>
							<font COLOR="white" FACE="Arial">Message</font>
						</b>
					</td>
				</tr>
				<xsl:apply-templates select="./Notification"/>
			</table>
		</xsl:if>
		<br></br>
		<table border="2" bordercolor="darkblue" width="100%" cellpadding="5" cellspacing="0">
			<tr>
				<td><b>Exchange Execution</b></td>
				<td><xsl:value-of select="@Name"/></td>
			</tr>
			<xsl:if test="count(.//DataSource)!=0">
				<tr>
					<td><b>Data source</b></td>
					<td><xsl:value-of select="./DataSource[@Name='DefaultDataSource']/@type"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="$CompatibilityOption='T' and $SplitOption='F'">
				<xsl:if test="$ProcessName!='Downward 3DXML Export'">
					<tr>
						<td><b>Downward compatibility report</b></td>
						<td><a href="{$ReportName}_Dw.html">Downward report</a></td>
					</tr>
				</xsl:if>
			</xsl:if>
		</table>
		<br></br>
		<xsl:if test="count(.//Option[@Name!='Briefcase'])!=0">
			<tr>
				<th align="left">
					<table class="IteractiveFrame" width="95%">
						<tr>
							<th class="titleMode" onmouseover="this.className='highlightTitleMode clickable';"
									  onmouseout="this.className='titleMode clickable';"
									  onclick="toggle_visibility_by_id('InteractiveOptions','plusminusInteractiveOptions')">
								Options:&#160;
								<img src="Data\Minus.gif" class="clickable" id="plusminusInteractiveOptions">
									<xsl:attribute name="height">
										<xsl:copy-of select="$IconSize" />
									</xsl:attribute>
								</img>
							</th>
						</tr>
						<tr>
							<td>
								<span id="InteractiveOptions" class="xdisplayHide">
									<dd>
										<table border="1" width="100%" align="right" cellpadding="1" cellspacing="0" class="objectTableIE">
											<tr align="center" bgcolor="000080">
												<th class="defaultMode">
													<b>
														<font COLOR="white" FACE="Arial">
															Name
														</font>
													</b>
												</th>
												<th class="defaultMode">
													<b>
														<font COLOR="white" FACE="Arial">
															Value
														</font>
													</b>
												</th>
											</tr>
											<xsl:apply-templates select=".//Option[@Name!='Briefcase']"/>
										</table>
									</dd>
								</span>
							</td>
						</tr>
					</table>
				</th>
			</tr>
		</xsl:if>
		<br></br>
		<xsl:if test="count(.//Option[@Name='Briefcase'])!=0">
			<tr>

			</tr>
		</xsl:if>
		<xsl:if test="count(.//Object)!=0">
			<tr>
				<th align="left">
					<table class="IteractiveFrame" width="95%" >
						<tr>
							<th class="titleMode" onmouseover="this.className='highlightTitleMode clickable';"
											onmouseout="this.className='titleMode clickable';"
											onclick="toggle_visibility_by_id('Objects','plusminusObjects')">
								Detail for&#160;<xsl:value-of select="count(.//Object)"/>&#160;Objects&#160;
								<img src="Data\Minus.gif" class="clickable" id="plusminusObjects">
									<xsl:attribute name="height">
										<xsl:copy-of select="$IconSize" />
									</xsl:attribute>
								</img>
							</th>
						</tr>
						<tr>
							<td colspan="2">
								<span id="Objects" class="xdisplayHide">
									<xsl:call-template name="ObjectTypeStat"/>
									<br></br>
									<xsl:call-template name="ObjectExchangeStat"/>
									<br></br>
									<xsl:call-template name="ExportImportObjectResultTab"/>
									<br></br>
								</span>
							</td>
						</tr>
					</table>
				</th>
			</tr>
		</xsl:if>
	</xsl:template>


	<!-- ==============================================	-->
	<!--  ObjectTypeStat template						-->
	<!-- ==============================================	-->
	<xsl:template name="ObjectTypeStat">
		<xsl:if test="count(.//Object)!=0">
			<dd>
				<table class="IteractiveFrame" width="100%">
					<tr>
						<th class="titleMode" onmouseover="this.className='highlightTitleMode clickable';"
										  onmouseout="this.className='titleMode clickable';"
										  onclick="toggle_visibility_by_id('StatisticsObjects','plusminusStatisticsObjects')">
							Statistics for&#160;<xsl:value-of select="count(.//Object)"/>&#160;Objects (Type)&#160;
							<img src="Data\Plus.gif" class="clickable" id="plusminusStatisticsObjects">
								<xsl:attribute name="height">
									<xsl:copy-of select="$IconSize" />
								</xsl:attribute>
							</img>
						</th>
					</tr>
					<tr>
						<td>
							<span id="StatisticsObjects" class="displayHide">
								<dd>
									<table border="1" bordercolor="lightgray" cellpadding="5" cellspacing="0">
										<xsl:if test="count(.//Object[@type='Reference'])!=0">
											<tr>
												<td>
													<u># of References:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='Reference'])"/>
												</td>
											</tr>
										</xsl:if>
										<xsl:if test="count(.//Object[@type='Representation'])!=0">
											<tr>
												<td>
													<u># of Representations:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='Representation'])"/>
												</td>
											</tr>
										</xsl:if>
										<xsl:if test="count(.//Object[@type='Instance'])!=0">
											<tr>
												<td>
													<u># of Instances:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='Instance'])"/>
												</td>
											</tr>
										</xsl:if>
										<xsl:if test="count(.//Object[@type='RepInstance'])!=0">
											<tr>
												<td>
													<u># of RepInstances:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='RepInstance'])"/>
												</td>
											</tr>
										</xsl:if>
										<xsl:if test="count(.//Object[@type='Entity'])!=0">
											<tr>
												<td>
													<u># of Entities:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='Entity'])"/>
												</td>
											</tr>
										</xsl:if>
										<xsl:if test="count(.//Object[@type='Relation'])!=0">
											<tr>
												<td>
													<u># of Relations:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='Relation'])"/>
												</td>
											</tr>
										</xsl:if>
										<xsl:if test="count(.//Object[@type='Port'])!=0">
											<tr>
												<td>
													<u># of Port:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='Port'])"/>
												</td>
											</tr>
										</xsl:if>
										<xsl:if test="count(.//Object[@type='Connection'])!=0">
											<tr>
												<td>
													<u># of Connection:</u>
												</td>
												<td>
													<xsl:value-of select="count(.//Object[@type='Connection'])"/>
												</td>
											</tr>
										</xsl:if>
									</table>
								</dd>
							</span>
						</td>
					</tr>
				</table>
			</dd>
		</xsl:if>
	</xsl:template>
	<!-- End of 'ObjectTypeStat' template -->


	<!-- ==============================================	-->
	<!--  ObjectExchangeStat template					-->
	<!-- ==============================================	-->

	<xsl:template name="ObjectExchangeStat">
		<xsl:if test="count(.//Object)!=0">
			<dd>
				<table class="IteractiveFrame" width="100%">
					<tr>
						<th class="titleMode" onmouseover="this.className='highlightTitleMode clickable';"
										  onmouseout="this.className='titleMode clickable';"
										  onclick="toggle_visibility_by_id('ObjectExchangeStat','plusminusObjectExchangeStat')">
							Exchange Statistics for&#160;<xsl:value-of select="count(.//Object)"/>&#160;Objects&#160;
							<img src="Data\Minus.gif" class="clickable" id="plusminusObjectExchangeStat">
								<xsl:attribute name="height">
									<xsl:copy-of select="$IconSize" />
								</xsl:attribute>
							</img>
						</th>
					</tr>
					<tr>
						<td>
							<span id="ObjectExchangeStat" class="xdisplayHide">
								<dd>
									<table border="1" bordercolor="lightgray" cellpadding="5" cellspacing="0">
										<xsl:choose>
											<xsl:when test="count(.//Notification[@Sev='Error' or @Sev='Fatal'])=0">
												<xsl:if test="count(.//Object[@oper='Create'])!=0">
													<tr>
														<td>
															<u># of creation request:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Create'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Synchronize_Create'])!=0">
													<tr>
														<td>
															<u># of creation request:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Synchronize_Create'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Synchronize_Delete'])!=0">
													<tr>
														<td>
															<u># of deletion request:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Synchronize_Delete'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Publish_Reference'])!=0">
													<tr>
														<td>
															<u># of referenced object:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Publish_Reference'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Synchronize_Update'])!=0">
													<tr>
														<td>
															<u># of update request:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Synchronize_Update'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Synchronize_Ignore'])!=0">
													<tr>
														<td>
															<u># of not modified object:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Synchronize_Ignore'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Publish'])!=0">
													<tr>
														<td>
															<u># of published object:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Publish'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Publish_Delete'])!=0">
													<tr>
														<td>
															<u># of deleted object:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Publish_Delete'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Publish_Filtered'])!=0">
													<tr>
														<td>
															<u># of filtered object:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Publish_Filtered'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Downward'])!=0">
													<tr>
														<td>
															<u># of degraded object:</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Downward'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='Downward_Filtered'])!=0">
													<tr>
														<td>
															<u># of filtered object (Downward):</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='Downward_Filtered'])"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="count(.//Object[@oper='To be exported'])!=0">
													<tr>
														<td>
															<u># of published object (for Review):</u>
														</td>
														<td>
															<xsl:value-of select="count(.//Object[@oper='To be exported'])"/>
														</td>
													</tr>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<th class="titleMode">
													<xsl:attribute name="bgcolor">
														<xsl:copy-of select="$COLORError"/>
													</xsl:attribute>
													3DXML Exchange Failed
												</th>
											</xsl:otherwise>
										</xsl:choose>
									</table>
								</dd>
							</span>
						</td>
					</tr>
				</table>
			</dd>
		</xsl:if>
	</xsl:template>
	<!-- End of 'ObjectExchangeStat' template -->


	<!-- ==============================================	-->
	<!--  ExportImportObjectResultTab template			-->
	<!-- ==============================================	-->

	<xsl:template name="ExportImportObjectResultTab">
		<dd>
			<table class="IteractiveFrame" width="100%">
				<tr>
					<th class="titleMode" onmouseover="this.className='highlightTitleMode clickable';"
							  onmouseout="this.className='titleMode clickable';"
							  onclick="toggle_visibility_by_id('ResultObjects','plusminusResultObjects')">
						Result for&#160;<xsl:value-of select="count(.//Object)"/>&#160;Objects&#160;
						<img src="Data\Minus.gif" class="clickable" id="plusminusResultObjects">
							<xsl:attribute name="height">
								<xsl:copy-of select="$IconSize" />
							</xsl:attribute>
						</img>
					</th>
				</tr>
				<tr>
					<td>
						<span id="ResultObjects" class="xdisplayHide">
							<dd>
								<table border="1" width="97.5%" cellpadding="5" cellspacing="0" class="objectTableIE">
									<xsl:call-template name="ExportImportObjectHeader"/>
									<xsl:for-each select="//Object">
										<xsl:call-template name="ExportImportObject"/>
									</xsl:for-each>
								</table>
							</dd>
						</span>
					</td>
				</tr>
			</table>
		</dd>
	</xsl:template>
	<!-- End of 'ExportImportObjectResultTab' template -->


	<!-- ==============================================	-->
	<!--  ExportImportObjectHeader template				-->
	<!-- ==============================================	-->

	<xsl:template name="ExportImportObjectHeader">
		<tr align="center" bgcolor="000080">
			<th class="defaultMode">
				<b>
					<font COLOR="white" FACE="Arial">
						Operation
					</font>
				</b>
			</th>
			<th class="defaultMode">
				<b>
					<xsl:choose>
						<xsl:when test ="$ProcessName='UUE_3DXMLReviewCustomization'">
							<font COLOR="white" FACE="Arial">
								Type
							</font>
						</xsl:when>
						<xsl:otherwise>
							<font COLOR="white" FACE="Arial">
								Type (Core Type - Modeller Type - Custo Type)
							</font>
						</xsl:otherwise>
					</xsl:choose>
				</b>
			</th>
			<th class="defaultMode">
				<b>
					<font COLOR="white" FACE="Arial">
						PhysicalID
					</font>
				</b>
			</th>
			<th class="defaultMode">
				<b>
					<font COLOR="white" FACE="Arial">
						Attributes
					</font>
				</b>
			</th>
			<th class="defaultMode">
				<b>
					<font COLOR="white" FACE="Arial">
						Status
					</font>
				</b>
			</th>
		</tr>
	</xsl:template>
	<!-- End of 'ExportImportObjectHeader' template -->


	<!-- ==============================================	-->
	<!--  ExportImportObject template					-->
	<!-- ==============================================	-->

	<xsl:template name="ExportImportObject">
		<tr>
			<xsl:call-template name="Object_Operation_Cell"/>
			<td align="left">
				<xsl:choose>
					<xsl:when test="$ProcessName='UUE_3DXMLReviewCustomization'">
						<b>
							<xsl:value-of select="@type"/>
						</b>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@type='Unknown'">
								<b>
									<xsl:value-of select="@Name"/>
								</b>
							</xsl:when>
							<xsl:otherwise>
								<b>
									<xsl:value-of select="@type"/> - <xsl:value-of select="@Name"/>
								</b>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td align="left">
				<xsl:value-of select="@Oid"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count(./Attribute[string-length(@value)&gt;0])!=0">
						<sl>
							<xsl:apply-templates select="./Attribute[@Name!='File']"/>
						</sl>
					</xsl:when>
					<xsl:otherwise>
						<!-- Case where no attribute is valuated -->
						<xsl:value-of select="@oper"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:choose>
				<xsl:when test="count(./Notification)!=0">
					<xsl:variable name="rowIndex" select="position()"/>
					<th class="titleMode" onmouseover="this.className='highlightTitleMode clickable';"
						onmouseout="this.className='titleMode clickable';"
						onclick="toggle_visibility_by_id('Information{$rowIndex}','plusminusInformation{$rowIndex}')">
						<xsl:choose>
							<xsl:when test="count(./Notification[@Sev='Warning'])!=0">
								<xsl:attribute name="bgcolor">
									<xsl:copy-of select="$COLORWarning" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="bgcolor">
									<xsl:copy-of select="$ObjStatusCellBGCOLOR" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<center>
							<xsl:choose>
								<xsl:when test="count(./Notification[@Sev='Warning'])!=0">
									<img src="Data\Infra_Icon_Warning.gif">
										<xsl:attribute name="height">
											<xsl:copy-of select="$IconSize" />
										</xsl:attribute>
									</img>&#160;
								</xsl:when>
								<xsl:otherwise>
									<img>
										<xsl:attribute name="src">
											<xsl:copy-of select="$ObjStatusIcon" />
										</xsl:attribute>
										<xsl:attribute name="height">
											<xsl:copy-of select="$IconSize" />
										</xsl:attribute>
									</img>&#160;
								</xsl:otherwise>
							</xsl:choose>
							<img src="Data\Minus.gif" class="clickable" id="plusminusInformation{$rowIndex}">
								<xsl:attribute name="height">
									<xsl:copy-of select="$IconSize" />
								</xsl:attribute>
							</img>
						</center>
					</th>
					<tr>
						<th colspan="5">
							<span id="Information{$rowIndex}" class="xdisplayHide">
								<table border="1" width="100%" cellpadding="1" cellspacing="0">
									<xsl:call-template name="ObjectNotification"/>
								</table>
							</span>
						</th>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<th class="titleMode">
						<xsl:attribute name="bgcolor">
							<xsl:copy-of select="$ObjStatusCellBGCOLOR" />
						</xsl:attribute>
						<center>
							<img>
								<xsl:attribute name="src">
									<xsl:copy-of select="$ObjStatusIcon" />
								</xsl:attribute>
								<xsl:attribute name="height">
									<xsl:copy-of select="$IconSize" />
								</xsl:attribute>
							</img>
						</center>
					</th>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>
	<!-- End of 'ExportImportObject' template -->


	<!-- ==============================================	-->
	<!--  Object_Operation_Cell template (@oper)		-->
	<!-- ==============================================	-->

	<xsl:template name="Object_Operation_Cell" >
		<!--	Display inside one cell operation name		-->
		<!--	List of known Synchronize operations: Synchronize_Create, Synchronize_Update, Synchronize_Delete, Synchronize_Ignore & Synchronize_TSO				-->
		<!--	List of known Publish operations: Publish, Publish_filtered, Publish_Delegate, Publish_ForUpdate, Publish_Waive, Publish_Reference & Publish_TSO	-->
		<!--	List of known Downward operations: Downward & Downward_Filtered																						-->
		<xsl:choose>
			<xsl:when test="@oper='Publish'">
				<td>
					<b>Extracted</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Publish_filtered'">
				<td>
					<b>Filtered</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Publish_Delegate'">
				<td>
					<b>Extracted with Delegation</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Publish_ForUpdate'">
				<td>
					<b>Extracted for update</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Publish_Waive'">
				<td>
					<b>Extracted with waive</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Publish_TSO'">
				<td>
					<b>Extracted with TSO</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Synchronize_Create' or @oper='Create'">
				<td>
					<b>Created</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Synchronize_Update'">
				<td>
					<b>Updated</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Synchronize_Delete' or @oper='Publish_Delete'">
				<td bgcolor="FF0000">
					<b>Deleted</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Synchronize_Ignore'">
				<td>
					<b>Up to date</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Synchronize_TSO'">
				<td>
					<b>TSO</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Publish_Reference'">
				<td bgcolor="FFFF00">
					<b>Referenced</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Downward'">
				<td>
					<b>Degraded</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='Downward_Filtered'">
				<td>
					<b>Filtered (Downward)</b>
				</td>
			</xsl:when>
			<xsl:when test="@oper='To be exported'">
				<td>
					<b>Extracted (for Review)</b>
				</td>
			</xsl:when>
			<xsl:when test="string-length(@oper)=0">
				<td>.</td>
			</xsl:when>
			<xsl:otherwise>
				<td>
					<xsl:value-of select="@oper"/>
				</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End of Object_Operation_Cell template -->


	<!-- ==============================================	-->
	<!--  Attribute template							-->
	<!-- ==============================================	-->

	<!--	<Attribute Id="48" Name="PLM_ExternalID" value="Representation22828" isSet="T" type="string"/>	-->
	<xsl:template match="Attribute">
		<xsl:choose>
			<xsl:when test="count(./value)!=0">
				<li>
					<b>
						<xsl:value-of select="@Name"/>
					</b> :
					<ol>
						<xsl:apply-templates select="./value"/>
					</ol>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length(@value)&gt;0">
					<li>
						<b>
							<xsl:value-of select="@Name"/>
						</b> =
						<xsl:value-of select="@value"/>
					</li>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End of 'Attribute' template -->


	<!-- ==============================================	-->
	<!--  value template (as list of elements)			-->
	<!-- ==============================================	-->

	<!--  <value value="The exchange file requires minor/major functionality to be activated on server.&quot;/&gt;"/> -->

	<xsl:template match="value">
		<li>
			<xsl:value-of select="@value"/>
		</li>
	</xsl:template>
	<!-- End of 'value' template -->


	<!-- ==============================================	-->
	<!--  ObjectNotification template					-->
	<!-- ==============================================	-->

	<xsl:template name="ObjectNotification">
		<xsl:apply-templates select="./Object"/>
		<xsl:if test="count(./Notification)!=0">
			<xsl:for-each select="./Notification">
				<xsl:if test="@Sev='Fatal'">
					<tr>
						<xsl:attribute name="bgcolor">
							<xsl:copy-of select="$COLORFatal" />
						</xsl:attribute>
						<td valign="top">
							<b>
								<xsl:value-of select="@Sev"/>
							</b>
						</td>
						<td valign="top">
							<b>
								<xsl:value-of select="@Name"/>
							</b>
						</td>
						<td valign="top">
							<b>
								<xsl:value-of select="@msg"/>
							</b>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@Sev='Error'">
					<tr>
						<xsl:attribute name="bgcolor">
							<xsl:copy-of select="$COLORError" />
						</xsl:attribute>
						<td valign="top">
							<b>
								<xsl:value-of select="@Sev"/>
							</b>
						</td>
						<td valign="top">
							<b>
								<xsl:value-of select="@Name"/>
							</b>
						</td>
						<td valign="top">
							<b>
								<xsl:value-of select="@msg"/>
							</b>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@Sev='Warning'">
					<tr>
						<xsl:attribute name="bgcolor">
							<xsl:copy-of select="$COLORWarning" />
						</xsl:attribute>
						<td valign="top">
							<b>
								<xsl:value-of select="@Sev"/>
							</b>
						</td>
						<td valign="top">
							<b>
								<xsl:value-of select="@Name"/>
							</b>
						</td>
						<td valign="top">
							<b>
								<xsl:value-of select="@msg"/>
							</b>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="@Sev='Info' or @Sev='Debug' or @Sev='Trace'">
					<tr bgcolor="#FFFFFF">
						<td colspan="1" valign="top" width="10%">
							<xsl:value-of select="@Name"/>
						</td>
						<td colspan="2" valign="top" xwidth="10%">
							<xsl:value-of select="@msg"/>
						</td>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- End of 'ObjectNotification' template -->


	<!-- ==============================================	-->
	<!--  Option template								-->
	<!-- ==============================================	-->

	<!-- <Option Id="10" Name="TransferOption" value="Streams migration mode is VISUALIZATION ONLY." isSet="T" type="string"/> -->
	<xsl:template match="Option">
		<xsl:variable name ="optionNls" select="@nls"/>
		<tr>
			<td valign="top">
				<b>
					<xsl:choose>
						<xsl:when test ="string-length($optionNls) !=0">
							<xsl:value-of select="$optionNls"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@Name"/>
						</xsl:otherwise>
					</xsl:choose>
				</b>
			</td>
			<xsl:choose>
				<xsl:when test="@isSet='T'">
					<td>
						<xsl:choose>
							<xsl:when test="count(./value)!=0">
								<ol>
									<xsl:apply-templates select="./value"/>
								</ol>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test ="string-length(@local) !=0">
										<xsl:value-of select="@local"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@value"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<i>No value set</i>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>
	<!-- End of 'Option' template -->

	<!-- ==============================================	-->
	<!--  Option Briefcase template						-->
	<!-- ==============================================	-->

	<!--  <Option Id="7" Name="Briefcase" type="file" isSet="T" value="E:\users\jlm\Temp\ExtractFromPod\ExtractDataFromPod-y15m12d15_h09m09s54-1.3dxml" nls="Briefcase"/> -->
	<xsl:template match="Option[@Name='Briefcase']">
		<li>
			<xsl:value-of select="@value"/>
		</li>
	</xsl:template>
	<!-- End of 'Option' Briefcase template -->


	<!-- ==============================================	-->
	<!--  Notification template							-->
	<!-- ==============================================	-->

	<!-- <Notification Id="40" Name="Server" Sev="Info" msg="ERROR: The exch..."/> -->
	<xsl:template match="Notification">
		<xsl:choose>
			<xsl:when test="@Sev='Fatal'">
				<tr>
					<xsl:attribute name="bgcolor">
						<xsl:copy-of select="$COLORFatal" />
					</xsl:attribute>
					<xsl:call-template name="Notification_Row"/>
				</tr>
			</xsl:when>
			<xsl:when test="@Sev='Error'">
				<tr>
					<xsl:attribute name="bgcolor">
						<xsl:copy-of select="$COLORError" />
					</xsl:attribute>
					<xsl:call-template name="Notification_Row"/>
				</tr>
			</xsl:when>
			<xsl:when test="@Sev='Warning'">
				<tr>
					<xsl:attribute name="bgcolor">
						<xsl:copy-of select="$COLORWarning" />
					</xsl:attribute>
					<xsl:call-template name="Notification_Row"/>
				</tr>
			</xsl:when>
   <xsl:when test="@Sev='Info'">
     <tr>
       <xsl:attribute name="bgcolor">
         <xsl:copy-of select="$COLORInfo" />
       </xsl:attribute>
       <xsl:call-template name="Notification_Row"/>
     </tr>
   </xsl:when>
			<xsl:otherwise>
				<!-- For Trace, Debug & Info -->
				<tr bgcolor="#D0D0D0">
					<xsl:call-template name="Notification_Row"/>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End of 'Notification' template -->

	<!-- ==============================================	-->
	<!--  To display Notification row content			-->
	<!-- ==============================================	-->

	<!-- Print Severity, Name and Message  -->
	<xsl:template name="Notification_Row" >
		<td>
			<b>
				<xsl:value-of select="@Sev"/>
			</b>
		</td>
		<td>
			<b>
				<xsl:value-of select="@Name"/>
			</b>
		</td>
		<td>
			<xsl:value-of select="@msg"/>
		</td>
	</xsl:template>
	<!-- End of template named Notification_Row -->

</xsl:stylesheet>
