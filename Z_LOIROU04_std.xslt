<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
	<xsl:template match="/Z_LOIROU04">
		<xsl:variable name="plant" select="IDOC/E1MAPLL/WERKS"/>
		<xsl:variable name="businessSystem" select="IDOC/EDI_DC40/SNDPRN"/>
		<xsl:variable name="routing" select="concat(IDOC/E1MAPLL/PLNNR,'-',IDOC/E1MAPLL/E1MAPAL/PLNAL)"/>
		<xsl:variable name="subOperationExists" select="boolean(IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL[FLGAT=0]/E1PLPOL[E1PLUPL])"/>
		<xsl:variable name="multiSequenceRouting" select="boolean(IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL[FLGAT!=0])"/>
		<routingIn>
			<SenderBusinessSystemID>
				<xsl:value-of select="$businessSystem"/>
			</SenderBusinessSystemID>
			<plant>
				<xsl:value-of select="$plant"/>
			</plant>
			<routing>
				<xsl:value-of select="$routing"/>
			</routing>
			<routingType>U</routingType>
			<xsl:variable name="materialNumber">
				<xsl:call-template name="trimMaterialLeadingZeros">
					<xsl:with-param name="material" select="IDOC/E1MAPLL/MATNR"/>
					<xsl:with-param name="materialExt" select="IDOC/E1MAPLL/MATNR_EXTERNAL"/>
					<xsl:with-param name="materialLong" select="IDOC/E1MAPLL/MATNR_LONG"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="routingDesc">
				<xsl:value-of select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/KTEXT"/>
			</xsl:variable>
			<description>
				<xsl:value-of select="$routingDesc"/>
			</description>
			<xsl:choose>
				<xsl:when test="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/STATU='1'">
					<status>205</status>
					<currentVersion>false</currentVersion>
				</xsl:when>
				<xsl:otherwise>
					<status>201</status>
					<currentVersion>true</currentVersion>
				</xsl:otherwise>
			</xsl:choose>
			<material>
				<xsl:choose>
					<xsl:when test="IDOC/E1MAPLL/MATNR_LONG != ''">
						<xsl:value-of select="IDOC/E1MAPLL/MATNR_LONG"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="IDOC/E1MAPLL/MATNR"/>
					</xsl:otherwise>
				</xsl:choose>
			</material>
			<effectivityControl>R</effectivityControl>
			<temporaryRouting>false</temporaryRouting>
			<!-- Sample for Relaxed flow
			<relaxedFlow>true</relaxedFlow>
			-->
			<!--<generateIsLastReportingStep>true</generateIsLastReportingStep>-->
			<entryRoutingStepDTO>
				<routingDTO>
					<routing>
						<xsl:value-of select="$routing"/>
					</routing>
					<routingType>U</routingType>
				</routingDTO>
				<stepId>
					<!-- use the smallest operation -->
					<xsl:for-each select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL[FLGAT=0]/E1PLPOL[not(NOT_MES_REL = 'X')]">
						<xsl:sort select="VORNR"/>
						<xsl:if test="position() = 1">
							<xsl:choose>
								<xsl:when test="$subOperationExists or $multiSequenceRouting">
									<xsl:choose>
										<xsl:when test="count(E1PLUPL)>0">
											<xsl:for-each select="E1PLUPL">
												<xsl:sort select="UVORN"/>
												<xsl:if test="position() = 1">
													<xsl:call-template name="addStepId">
														<xsl:with-param name="stepId" select="concat(../VORNR, '-',  UVORN)"/>
														<xsl:with-param name="sequenceId" select="../../PLNFL"/>
														<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="addStepId">
												<xsl:with-param name="stepId" select="VORNR"/>
												<xsl:with-param name="sequenceId" select="../PLNFL"/>
												<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>10</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</stepId>
			</entryRoutingStepDTO>
			<routingStepDTOList>
				<xsl:for-each select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL">
					<xsl:sort select="PLNFL"/>
					<xsl:variable name="currentPLFLL" select="."/>
					<xsl:variable name="sortedE1PLPOLNodes">
						<xsl:for-each select="E1PLPOL[not(NOT_MES_REL = 'X')]">
							<xsl:sort select="VORNR"/>
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="$sortedE1PLPOLNodes/E1PLPOL">
						<xsl:variable name="seqCounter" select="position()"/>
						<xsl:variable name="stepId">
							<xsl:choose>
								<xsl:when test="$subOperationExists or $multiSequenceRouting">
									<xsl:call-template name="addStepId">
										<xsl:with-param name="stepId" select="VORNR"/>
										<xsl:with-param name="sequenceId" select="$currentPLFLL/PLNFL"/>
										<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number value="$seqCounter*10"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<!-- no subOperations -->
						<xsl:if test="count(E1PLUPL)=0">
							<routingStepDTO>
								<xsl:choose>
									<xsl:when test="RUEK">
										<xsl:if test="RUEK!='3'">
											<reportingStep>
												<xsl:value-of select="VORNR"/>
											</reportingStep>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<reportingStep>
											<xsl:value-of select="VORNR"/>
										</reportingStep>
									</xsl:otherwise>
								</xsl:choose>
								<!-- not supported in 1905 release -->
								<!--<erpOperation>
									<xsl:value-of select="VORNR"/>
								</erpOperation>-->
								<rework>false</rework>
								<routingStepRef>
									<stepId>
										<xsl:value-of select="$stepId"/>
									</stepId>
								</routingStepRef>
								<erpSequence>
									<xsl:call-template name="removeLeadingZeros">
										<xsl:with-param name="erpSequence" select="$currentPLFLL/PLNFL"/>
									</xsl:call-template>
								</erpSequence>
								<erpInternalID>
									<xsl:value-of select="ARBID"/>
								</erpInternalID>
								<queueDecisionType>C</queueDecisionType>
								<xsl:choose>
									<xsl:when test="$seqCounter=count($sortedE1PLPOLNodes/E1PLPOL)">
										<erpInspectionComplete>true</erpInspectionComplete>
									</xsl:when>
									<xsl:otherwise>
										<erpInspectionComplete>false</erpInspectionComplete>
									</xsl:otherwise>
								</xsl:choose>
								<sequence>
									<xsl:number value="$seqCounter" format="1"/>
								</sequence>
								<description>
									<xsl:value-of select="LTXA1"/>
								</description>
								<controlKey>
									<xsl:value-of select="STEUS"/>
								</controlKey>
								<routingStepAttachmentDTOList>
									<xsl:for-each select="E1PLDOC/E1PLDPO">
										<xsl:variable name="documentType" select="../DOKAR"/>
										<xsl:if test="$documentType='PRT'">
											<routingStepAttachmentDTO>
												<attachedMaterial>
													<xsl:call-template name="addWorkInstructionName">
														<xsl:with-param name="docName" select="../DOKNR"/>
														<xsl:with-param name="docType" select="../DOKAR"/>
														<xsl:with-param name="docPart" select="../DOKTL"/>
														<xsl:with-param name="docOriginal" select="ORIGINAL"/>
													</xsl:call-template>
												</attachedMaterial>
												<version>
													<xsl:value-of select="../DOKVR"/>
												</version>
												<attachmentType>W</attachmentType>
												<selectionRuleList>
													<xsl:for-each select="../E1ODEPD">
														<xsl:variable name="dependType" select="KNART"/>
														<xsl:if test="$dependType='5'">
															<selectionRuleDetail>
																<selectionRule>
																	<xsl:value-of select="KNNAM"/>
																</selectionRule>
															</selectionRuleDetail>
														</xsl:if>
													</xsl:for-each>
												</selectionRuleList>
											</routingStepAttachmentDTO>
										</xsl:if>
									</xsl:for-each>
								</routingStepAttachmentDTOList>
								<routingStepComponentDTOList>
									<xsl:for-each select="E1PLMZL">
										<routingStepComponentDTO>
											<materialDTO>
												<material>
													<xsl:choose>
														<xsl:when test="IDNRK_LONG != ''">
															<xsl:value-of select="IDNRK_LONG"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="IDNRK"/>
														</xsl:otherwise>
													</xsl:choose>
												</material>
												<version>#</version>
											</materialDTO>
											<erpSequence>
												<xsl:value-of select="number(POSNR)"/>
											</erpSequence>
											<quantity>
												<xsl:value-of select="MENGE"/>
											</quantity>
										</routingStepComponentDTO>
									</xsl:for-each>
								</routingStepComponentDTOList>
								<routingOperationDTOList>
									<routingOperationDTO>
										<operationDTO>
											<xsl:choose>
												<xsl:when test="ME_OPERATION_ID">
													<operation>
														<xsl:value-of select="ME_OPERATION_ID"/>
													</operation>
													<version>
														<xsl:value-of select="ME_REVISION"/>
													</version>
												</xsl:when>
												<xsl:otherwise>
													<operation>
														<xsl:value-of select="$routing"/>-<xsl:value-of select="$currentPLFLL/PLNFL"/>-<xsl:value-of select="VORNR"/>
													</operation>
													<version>
														<xsl:value-of select="ME_REVISION"/>
													</version>
												</xsl:otherwise>
											</xsl:choose>
										</operationDTO>
										<maxLoop>0</maxLoop>
										<stepType>N</stepType>
										<!-- Sample for customFieldDtoList on Step level
										<customFieldDTOList>
											<customFieldDTO>
												<attribute>XYZ</attribute>
												<value>value_xyz</value>
											</customFieldDTO>
											<customFieldDTO>
												<attribute>ABC</attribute>
												<value>value_abc</value>
											</customFieldDTO>
										</customFieldDTOList>
										-->
									</routingOperationDTO>
								</routingOperationDTOList>
								<routingCompDTO>
									<routingOperationDTO>
										<routingStepRef>
											<stepId>
												<xsl:value-of select="$stepId"/>
											</stepId>
										</routingStepRef>
									</routingOperationDTO>
								</routingCompDTO>
								<stepId>
									<xsl:value-of select="$stepId"/>
								</stepId>
								<xsl:if test="not($multiSequenceRouting)">
									<routingNextStepDTOList>
										<xsl:variable name="nextE1PLPOL" select="$sortedE1PLPOLNodes/E1PLPOL[position() = ($seqCounter + 1)]"/>
										<xsl:if test="$nextE1PLPOL">
											<routingNextStepDTO>
												<nextStepDTO>
													<stepId>
														<xsl:choose>
															<xsl:when test="$subOperationExists">
																<xsl:choose>
																	<xsl:when test="count($nextE1PLPOL/E1PLUPL)>0">
																		<xsl:for-each select="$nextE1PLPOL/E1PLUPL">
																			<xsl:sort select="UVORN"/>
																			<xsl:if test="position() = 1">
																				<xsl:value-of select="concat(../VORNR, '-',  UVORN)"/>
																			</xsl:if>
																		</xsl:for-each>
																	</xsl:when>
																	<xsl:otherwise><xsl:value-of select="$nextE1PLPOL/VORNR"/></xsl:otherwise>
																</xsl:choose>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="($seqCounter + 1)*10"/>
															</xsl:otherwise>
														</xsl:choose>
													</stepId>
												</nextStepDTO>
												<failurePath>false</failurePath>
											</routingNextStepDTO>
										</xsl:if>
									</routingNextStepDTOList>
								</xsl:if>
								<standardWorkFormulaParamGroupDTO>
									<workCenterFormulaParam1>
										<standardWorkFormulaParamName>
											<xsl:value-of select="PAR01_LTXT"/>
										</standardWorkFormulaParamName>
										<workCenterStandardWorkQty unitCode="{VGE01}">
											<xsl:value-of select="VGW01"/>
										</workCenterStandardWorkQty>
									</workCenterFormulaParam1>
									<workCenterFormulaParam2>
										<standardWorkFormulaParamName>
											<xsl:value-of select="PAR02_LTXT"/>
										</standardWorkFormulaParamName>
										<workCenterStandardWorkQty unitCode="{VGE02}">
											<xsl:value-of select="VGW02"/>
										</workCenterStandardWorkQty>
									</workCenterFormulaParam2>
									<workCenterFormulaParam3>
										<standardWorkFormulaParamName>
											<xsl:value-of select="PAR03_LTXT"/>
										</standardWorkFormulaParamName>
										<workCenterStandardWorkQty unitCode="{VGE03}">
											<xsl:value-of select="VGW03"/>
										</workCenterStandardWorkQty>
									</workCenterFormulaParam3>
									<workCenterFormulaParam4>
										<standardWorkFormulaParamName>
											<xsl:value-of select="PAR04_LTXT"/>
										</standardWorkFormulaParamName>
										<workCenterStandardWorkQty unitCode="{VGE04}">
											<xsl:value-of select="VGW04"/>
										</workCenterStandardWorkQty>
									</workCenterFormulaParam4>
									<workCenterFormulaParam5>
										<standardWorkFormulaParamName>
											<xsl:value-of select="PAR05_LTXT"/>
										</standardWorkFormulaParamName>
										<workCenterStandardWorkQty unitCode="{VGE05}">
											<xsl:value-of select="VGW05"/>
										</workCenterStandardWorkQty>
									</workCenterFormulaParam5>
									<workCenterFormulaParam6>
										<standardWorkFormulaParamName>
											<xsl:value-of select="PAR06_LTXT"/>
										</standardWorkFormulaParamName>
										<workCenterStandardWorkQty unitCode="{VGE06}">
											<xsl:value-of select="VGW06"/>
										</workCenterStandardWorkQty>
									</workCenterFormulaParam6>
								</standardWorkFormulaParamGroupDTO>
							</routingStepDTO>
						</xsl:if>

						<!-- Routing steps from SubOperations-->
						<xsl:if test="count(E1PLUPL)>0">
							<!--Sort subOperations. Workaround for next-sibling-->
							<xsl:variable name="sortedSubOperations">
								<xsl:element name="E1PLUPLcount"
											 namespace="urn:sap-com:document:sap:idoc:soap:messages">
									<xsl:value-of select="count(E1PLUPL)"/>
								</xsl:element>
								<xsl:for-each select="E1PLUPL">
									<xsl:sort select="UVORN"/>
									<xsl:element name="operationContainer"
												 namespace="urn:sap-com:document:sap:idoc:soap:messages">
										<xsl:copy-of select="."/>
										<xsl:copy-of select="../VORNR"/>
										<xsl:copy-of select="../../../E1PLFLL/E1PLPOL"/>
										<xsl:copy-of select="../E1PLDOC"/>
										<xsl:copy-of select="../E1PLMZL"/>
										<xsl:copy-of select="$currentPLFLL/PLNFL"/>
										<xsl:copy-of select=".."/>
									</xsl:element>
								</xsl:for-each>
							</xsl:variable>
							<xsl:for-each select="$sortedSubOperations//operationContainer">
								<xsl:variable name="subSeqCounter" select="position()"/>
								<xsl:variable name="currentE1PLPOLVORNR" select="VORNR"/>

								<xsl:variable name="currentUVORN" select="E1PLUPL/UVORN"/>
								<routingStepDTO>
									<xsl:if test="$subSeqCounter = ../E1PLUPLcount">
										<!-- set reporting step to the last sub-operation -->
										<reportingStep>
											<xsl:value-of select="$currentE1PLPOLVORNR"/>
										</reportingStep>
									</xsl:if>
									<rework>false</rework>
									<routingStepRef>
										<stepId>
											<xsl:call-template name="addStepId">
												<xsl:with-param name="stepId" select="concat($currentE1PLPOLVORNR, '-', $currentUVORN)"/>
												<xsl:with-param name="sequenceId" select="$currentPLFLL/PLNFL"/>
												<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
											</xsl:call-template>
										</stepId>
									</routingStepRef>
									<erpSequence>
										<xsl:call-template name="removeLeadingZeros">
											<xsl:with-param name="erpSequence" select="$currentPLFLL/PLNFL"/>
										</xsl:call-template>
									</erpSequence>
									<erpInternalID>
										<xsl:value-of select="E1PLUPL/ARBID"/>
									</erpInternalID>
									<queueDecisionType>C</queueDecisionType>

									<xsl:choose>
										<xsl:when test="($seqCounter = count($sortedE1PLPOLNodes/E1PLPOL)) and ($subSeqCounter = ../E1PLUPLcount)">
											<erpInspectionComplete>true</erpInspectionComplete>
										</xsl:when>
										<xsl:otherwise>
											<erpInspectionComplete>false</erpInspectionComplete>
										</xsl:otherwise>
									</xsl:choose>
									<sequence>
										<xsl:number value="concat($seqCounter, $subSeqCounter)"/>
									</sequence>
									<description>
										<xsl:value-of select="E1PLUPL/LTXA1"/>
									</description>
									<controlKey>
										<xsl:value-of select="E1PLUPL/STEUS"/>
									</controlKey>

									<xsl:if test="$subSeqCounter = 1">
										<routingStepAttachmentDTOList>
											<xsl:for-each select="E1PLDOC/E1PLDPO">
												<xsl:variable name="documentType" select="DOKAR"/>
												<xsl:if test="$documentType='PRT'">
													<routingStepAttachmentDTO>
														<attachedMaterial>
															<xsl:call-template name="addWorkInstructionName">
																<xsl:with-param name="docName" select="../DOKNR"/>
																<xsl:with-param name="docType" select="../DOKAR"/>
																<xsl:with-param name="docPart" select="../DOKTL"/>
																<xsl:with-param name="docOriginal" select="ORIGINAL"/>
															</xsl:call-template>
														</attachedMaterial>
														<version>
															<xsl:value-of select="../DOKVR"/>
														</version>
														<attachmentType>W</attachmentType>
														<selectionRuleList>
															<xsl:for-each select="../E1ODEPD">
																<xsl:variable name="dependType" select="KNART"/>
																<xsl:if test="$dependType='5'">
																	<selectionRuleDetail>
																		<selectionRule>
																			<xsl:value-of select="KNNAM"/>
																		</selectionRule>
																	</selectionRuleDetail>
																</xsl:if>
															</xsl:for-each>
														</selectionRuleList>
													</routingStepAttachmentDTO>
												</xsl:if>
											</xsl:for-each>
										</routingStepAttachmentDTOList>
									</xsl:if>

									<xsl:if test="$subSeqCounter = 1">
										<!-- set components to the first sub-operation -->
										<routingStepComponentDTOList>
											<xsl:for-each select="E1PLMZL">
												<routingStepComponentDTO>
													<materialDTO>
														<material>
															<xsl:choose>
																<xsl:when test="IDNRK_LONG != ''">
																	<xsl:value-of select="IDNRK_LONG"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="IDNRK"/>
																</xsl:otherwise>
															</xsl:choose>
														</material>
														<version>#</version>
													</materialDTO>
													<erpSequence>
														<xsl:value-of select="number(POSNR)"/>
													</erpSequence>
													<quantity>
														<xsl:value-of select="MENGE"/>
													</quantity>
												</routingStepComponentDTO>
											</xsl:for-each>
										</routingStepComponentDTOList>
									</xsl:if>

									<routingOperationDTOList>
										<routingOperationDTO>
											<operationDTO>
												<xsl:choose>
													<xsl:when test="E1PLUPL/ME_OPERATION_ID">
														<operation>
															<xsl:value-of select="E1PLUPL/ME_OPERATION_ID"/>
														</operation>
														<version>
															<xsl:value-of select="E1PLUPL/ME_REVISION"/>
														</version>
													</xsl:when>
													<xsl:otherwise>
														<operation>
															<xsl:value-of select="$routing"/>-<xsl:value-of select="PLNFL"/>-<xsl:value-of select="VORNR"/>-<xsl:value-of select="E1PLUPL/UVORN"/>
														</operation>
														<version>
															<xsl:value-of select="E1PLUPL/ME_REVISION"/>
														</version>
													</xsl:otherwise>
												</xsl:choose>
											</operationDTO>
											<maxLoop>0</maxLoop>
											<stepType>N</stepType>
											<!-- Sample for customFieldDtoList on Step level (for sub-operations)
											<customFieldDTOList>
												<customFieldDTO>
													<attribute>XYZ</attribute>
													<value>value_xyz</value>
												</customFieldDTO>
												<customFieldDTO>
													<attribute>ABC</attribute>
													<value>value_abc</value>
												</customFieldDTO>
											</customFieldDTOList>
											-->
										</routingOperationDTO>
									</routingOperationDTOList>
									<routingCompDTO/>
									<stepId>
										<xsl:call-template name="addStepId">
											<xsl:with-param name="stepId" select="concat($currentE1PLPOLVORNR, '-', $currentUVORN)"/>
											<xsl:with-param name="sequenceId" select="$currentPLFLL/PLNFL"/>
											<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
										</xsl:call-template>
									</stepId>
									<xsl:if test="not($multiSequenceRouting)">
										<routingNextStepDTOList>
											<xsl:choose>
												<xsl:when test="./following-sibling::operationContainer[1]/E1PLUPL">
													<routingNextStepDTO>
														<nextStepDTO>
															<stepId>
																<xsl:call-template name="addStepId">
																	<xsl:with-param name="stepId" select="concat(./following-sibling::operationContainer[1]/VORNR, '-',  ./following-sibling::operationContainer[1]/E1PLUPL/UVORN)"/>
																	<xsl:with-param name="sequenceId" select="$currentPLFLL/PLNFL"/>
																	<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
																</xsl:call-template>
															</stepId>
														</nextStepDTO>
														<failurePath>false</failurePath>
													</routingNextStepDTO>
												</xsl:when>
												<xsl:when test="$subSeqCounter = ../E1PLUPLcount">
													<xsl:variable name="nextE1PLPOL" select="$sortedE1PLPOLNodes/E1PLPOL[position() = ($seqCounter + 1)]"/>
													<xsl:if test="$nextE1PLPOL">
														<routingNextStepDTO>
															<nextStepDTO>
																<stepId>
																	<xsl:choose>
																		<xsl:when test="count($nextE1PLPOL/E1PLUPL)>0">
																			<xsl:for-each select="$nextE1PLPOL/E1PLUPL">
																				<xsl:sort select="UVORN"/>
																				<xsl:if test="position() = 1">
																					<xsl:value-of select="concat(../VORNR, '-',  UVORN)"/>
																				</xsl:if>
																			</xsl:for-each>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$nextE1PLPOL/VORNR"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</stepId>
															</nextStepDTO>
															<failurePath>false</failurePath>
														</routingNextStepDTO>
													</xsl:if>
												</xsl:when>
											</xsl:choose>
										</routingNextStepDTOList>
									</xsl:if>

									<standardWorkFormulaParamGroupDTO>
										<workCenterFormulaParam1>
											<standardWorkFormulaParamName/>
											<workCenterStandardWorkQty unitCode="{E1PLUPL/VGE01}">
												<xsl:value-of select="E1PLUPL/VGW01"/>
											</workCenterStandardWorkQty>
										</workCenterFormulaParam1>
										<workCenterFormulaParam2>
											<standardWorkFormulaParamName/>
											<workCenterStandardWorkQty unitCode="{E1PLUPL/VGE02}">
												<xsl:value-of select="E1PLUPL/VGW02"/>
											</workCenterStandardWorkQty>
										</workCenterFormulaParam2>
										<workCenterFormulaParam3>
											<standardWorkFormulaParamName/>
											<workCenterStandardWorkQty unitCode="{E1PLUPL/VGE03}">
												<xsl:value-of select="E1PLUPL/VGW03"/>
											</workCenterStandardWorkQty>
										</workCenterFormulaParam3>
										<workCenterFormulaParam4>
											<standardWorkFormulaParamName/>
											<workCenterStandardWorkQty unitCode="{E1PLUPL/VGE04}">
												<xsl:value-of select="E1PLUPL/VGW04"/>
											</workCenterStandardWorkQty>
										</workCenterFormulaParam4>
										<workCenterFormulaParam5>
											<standardWorkFormulaParamName/>
											<workCenterStandardWorkQty unitCode="{E1PLUPL/VGE05}">
												<xsl:value-of select="E1PLUPL/VGW05"/>
											</workCenterStandardWorkQty>
										</workCenterFormulaParam5>
										<workCenterFormulaParam6>
											<standardWorkFormulaParamName/>
											<workCenterStandardWorkQty unitCode="{E1PLUPL/VGE06}">
												<xsl:value-of select="E1PLUPL/VGW06"/>
											</workCenterStandardWorkQty>
										</workCenterFormulaParam6>
									</standardWorkFormulaParamGroupDTO>
								</routingStepDTO>
							</xsl:for-each>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</routingStepDTOList>
			<!-- Sample for customFieldDtoList on Routing header level
			<customFieldDTOList>
				<customFieldDTO>
					<attribute>XYZ</attribute>
					<value>value_xyz</value>
				</customFieldDTO>
				<customFieldDTO>
					<attribute>ABC</attribute>
					<value>value_abc</value>
				</customFieldDTO>
			</customFieldDTOList>
			-->


			<routingOperationGroupDTOList>
				<xsl:for-each select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL">
					<xsl:sort select="PLNFL"/>
					<xsl:for-each select="E1PLPOL[not(NOT_MES_REL = 'X')]">
						<xsl:sort select="VORNR"/>
						<xsl:variable name="seqCounter" select="position()"/>
						<xsl:variable name="stepId">
							<xsl:choose>
								<xsl:when test="$subOperationExists or $multiSequenceRouting">
									<xsl:call-template name="addStepId">
										<xsl:with-param name="stepId" select="VORNR"/>
										<xsl:with-param name="sequenceId" select="../PLNFL"/>
										<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="addStepId">
										<xsl:with-param name="stepId" select="$seqCounter*10"/>
										<xsl:with-param name="sequenceId" select="../PLNFL"/>
										<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<routingOperationGroupDTO>
							<routingOperationGroup>
								<xsl:choose>
									<xsl:when test="ME_OPERATION_ID">
										<xsl:value-of select="ME_OPERATION_ID"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$routing"/>-<xsl:value-of select="../PLNFL"/>-<xsl:value-of select="VORNR"/>
									</xsl:otherwise>
								</xsl:choose>
							</routingOperationGroup>
							<description><xsl:value-of select="LTXA1"/></description>
							<erpOperationNumber><xsl:value-of select="VORNR"/></erpOperationNumber>

							<routingOperationGroupStepDTOList>
								<xsl:if test="count(E1PLUPL)=0">
									<routingOperationGroupStepDTO>
										<stepId><xsl:value-of select="$stepId"/></stepId>
									</routingOperationGroupStepDTO>
								</xsl:if>
								<xsl:if test="count(E1PLUPL)>0">
									<xsl:for-each select="E1PLUPL">
										<xsl:sort select="UVORN"/>
										<routingOperationGroupStepDTO>
											<stepId>
												<xsl:call-template name="addStepId">
													<xsl:with-param name="stepId" select="concat(../VORNR, '-', UVORN)"/>
													<xsl:with-param name="sequenceId" select="../../PLNFL"/>
													<xsl:with-param name="multiSequenceRouting" select="$multiSequenceRouting"/>
												</xsl:call-template>
											</stepId>
										</routingOperationGroupStepDTO>
									</xsl:for-each>
								</xsl:if>
							</routingOperationGroupStepDTOList>
						</routingOperationGroupDTO>
					</xsl:for-each>
				</xsl:for-each>
			</routingOperationGroupDTOList>

			<xsl:if test="$multiSequenceRouting">
				<routingErpSequenceDTOList>
					<xsl:for-each select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL">
						<routingErpSequenceDTO>
							<erpSequence>
								<xsl:call-template name="removeLeadingZeros">
									<xsl:with-param name="erpSequence" select="PLNFL"/>
								</xsl:call-template>
							</erpSequence>
							<description><xsl:value-of select="LTXA1"/></description>
							<category><xsl:value-of select="FLGAT"/></category>
							<xsl:if test="FLGAT != 0">
								<referenceSequence>0</referenceSequence>
								<branchOperation><xsl:value-of select="concat('0-',  VORNR1)"/></branchOperation>
								<returnOperation><xsl:value-of select="concat('0-',  VORNR2)"/></returnOperation>
							</xsl:if>
						</routingErpSequenceDTO>
					</xsl:for-each>
				</routingErpSequenceDTOList>
			</xsl:if>


			<xsl:variable name="validityFrom" select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL[FLGAT='0']/DATUV"/>
			<xsl:variable name="validityTo" select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL[FLGAT='0']/DATUB"/>
			<xsl:variable name="lotSizeFrom" select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL[FLGAT='0']/LOSVN"/>
			<xsl:variable name="lotSizeTo" select="IDOC/E1MAPLL/E1MAPAL/E1PLKOL/E1PLFLL[FLGAT='0']/LOSBS"/>
		</routingIn>
	</xsl:template>
	<xsl:template name="addWorkInstructionName">
		<xsl:param name="docName"/>
		<xsl:param name="docType"/>
		<xsl:param name="docPart"/>
		<xsl:param name="docOriginal"/>
		<xsl:variable name="materialNumber" select="string(number($docName))"/>
		<xsl:choose>
			<xsl:when test="$materialNumber='NaN'">
				<xsl:value-of select="$docName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$materialNumber"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="concat('-', $docType,'-',  $docPart,'-', $docOriginal)"/>
	</xsl:template>
	<xsl:template name="trimMaterialLeadingZeros">
		<xsl:param name="material"/>
		<xsl:param name="materialExt"/>
		<xsl:param name="materialLong"/>
		<xsl:variable name="materialString">
			<xsl:choose>
				<xsl:when test="$materialExt!=''">
					<xsl:value-of select="normalize-space($materialExt)"/>
				</xsl:when>
				<xsl:when test="$materialLong!=''">
					<xsl:value-of select="normalize-space($materialLong)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($material)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="materialNumber" select="string(number($materialString))"/>
		<xsl:choose>
			<xsl:when test="$materialNumber='NaN'">
				<xsl:value-of select="$materialString"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$materialNumber"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="addMaterial">
		<xsl:param name="material"/>
		<xsl:param name="materialExt"/>
		<xsl:param name="materialLong"/>
		<xsl:variable name="materialString">
			<xsl:choose>
				<xsl:when test="$materialExt!=''">
					<xsl:value-of select="normalize-space($materialExt)"/>
				</xsl:when>
				<xsl:when test="$materialLong!=''">
					<xsl:value-of select="normalize-space($materialLong)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($material)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="materialMask">
			<xsl:choose>
				<xsl:when test="$materialExt!=''">
					<xsl:value-of select="'0000000000000000000000000000000000000000'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'000000000000000000'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="materialNumber" select="number($materialString)"/>
		<xsl:choose>
			<xsl:when test="format-number($materialNumber, '#') = $materialString">
				<!-- material is number -->
				<xsl:value-of select="format-number($materialNumber, $materialMask)"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- material contains letter -->
				<xsl:value-of select="$materialString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="addTimeUnits">
		<xsl:param name="erpTimeUnits"/>
		<xsl:choose>
			<xsl:when test="$erpTimeUnits ='HUR'">H</xsl:when>
			<xsl:when test="$erpTimeUnits ='MIN'">M</xsl:when>
			<xsl:when test="$erpTimeUnits ='SEC'">S</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="addStepId">
		<xsl:param name="stepId"/>
		<xsl:param name="sequenceId"/>
		<xsl:param name="multiSequenceRouting"/>
		<xsl:choose>
			<xsl:when test="$multiSequenceRouting">
				<xsl:value-of select="concat($sequenceId, '-', $stepId)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stepId"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="removeLeadingZeros">
		<xsl:param name="erpSequence"/>

		<xsl:value-of select="
			if (matches($erpSequence, '^\d+$'))
			then replace($erpSequence, '^0+(\d+)$', '$1')
			else $erpSequence
		"/>
	</xsl:template>

</xsl:stylesheet>