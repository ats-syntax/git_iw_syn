<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages"
                xmlns:glob="http://sap.com/xi/SAPGlobal20/Global"
                xmlns:glob1="http://sap.com/xi/PP/Global2">

    <xsl:template match="LOIROU04/IDOC">
        <xsl:variable name="rootName">
            <xsl:choose>
                <xsl:when test="E1MAPLL/PLNTY='2'">
                    <xsl:value-of select="'glob:ManufacturingMasterRecipeInfomation'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'glob:ManufacturingRoutingInformation'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$rootName}">
            <MessageHeader>
                <ID>
                    <xsl:call-template name="generateId">
                        <xsl:with-param name="idocNo" select="EDI_DC40/DOCNUM"/>
                    </xsl:call-template>
                </ID>
                <UUID>
                    <xsl:call-template name="generateId">
                        <xsl:with-param name="idocNo" select="EDI_DC40/DOCNUM"/>
                    </xsl:call-template>
                </UUID>
                <CreationDateTime>
                    <xsl:value-of select="current-dateTime()"/>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/SNDPRN"/>
                </SenderBusinessSystemID>
            </MessageHeader>
            <xsl:apply-templates select="E1MAPLL"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="LOIROU04/IDOC/E1MAPLL">
        <BillOfOperations>
            <BillOfOperationsType>
                <xsl:value-of select="PLNTY"/>
            </BillOfOperationsType>
            <BillOfOperationsGroup>
                <xsl:value-of select="PLNNR"/>
            </BillOfOperationsGroup>
            <BillOfOperationsVariant>
                <xsl:value-of select="E1MAPAL/PLNAL"/>
            </BillOfOperationsVariant>
            <xsl:for-each select="E1MAPAL/E1PLKOL">
                <BillOfOperationsHeader glob1:ActionCode="">
                    <glob1:BillOfOperationsDesc>
                        <xsl:value-of select="KTEXT"/>
                    </glob1:BillOfOperationsDesc>
                    <glob1:BillOfOperationsStatus>
                        <xsl:value-of select="STATU"/>
                    </glob1:BillOfOperationsStatus>
                    <glob1:BillOfOperationsPlant>
                        <xsl:value-of select="../../WERKS"/>
                    </glob1:BillOfOperationsPlant>
                    <glob1:BillOfOperationsUsage>
                        <xsl:value-of select="VERWE"/>
                    </glob1:BillOfOperationsUsage>
                    <glob1:BOOMinLotSizeQuantity unitCode="{PLNME}">
                        <xsl:value-of select="../LOSBS"/>
                    </glob1:BOOMinLotSizeQuantity>
                    <glob1:BOOMaxLotSizeQuantity unitCode="{PLNME}">
                        <xsl:value-of select="../LOSVN"/>
                    </glob1:BOOMaxLotSizeQuantity>
                    <glob1:ChangeNumber/>
                    <glob1:ValidityStartDate>
                        <xsl:call-template name="convertIDocDateFormat">
                            <xsl:with-param name="date" select="DATUV"/>
                        </xsl:call-template>
                    </glob1:ValidityStartDate>
                    <glob1:ValidityEndDate>
                        <xsl:call-template name="convertIDocDateFormat">
                            <xsl:with-param name="date" select="DATUB"/>
                        </xsl:call-template>
                    </glob1:ValidityEndDate>
                    <glob1:LongText glob1:languageCode="{E1PLLTH/TDSPRAS}" glob1:MIMECode=""
                                    glob1:TextCategory="{E1PLLTH/TDTEXTTYPE}">
                    </glob1:LongText>
                </BillOfOperationsHeader>
            </xsl:for-each>
            <BillOfOperationsMaterialAssignment>
                <Material>
                    <xsl:choose>
                        <xsl:when test="MATNR_LONG != ''">
                            <xsl:value-of select="MATNR_LONG"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="MATNR"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </Material>
                <Plant>
                    <xsl:value-of select="WERKS"/>
                </Plant>
                <ChangeNumber/>
                <ValidityStartDate>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="E1MAPAL/E1PLKOL/E1PLFLL/DATUV"/>
                    </xsl:call-template>
                </ValidityStartDate>
                <ValidityEndDate>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="E1MAPAL/E1PLKOL/E1PLFLL/DATUB"/>
                    </xsl:call-template>
                </ValidityEndDate>
            </BillOfOperationsMaterialAssignment>
            <ProductionVersion/>
            <!-- Sample for Relaxed flow
            <ZRelaxedFlow>true</ZRelaxedFlow>
            -->
            <xsl:for-each select="E1MAPAL/E1PLKOL/E1PLFLL">
                <xsl:sort select="PLNFL"/>
                <xsl:if test="FLGAT = 0">
                    <xsl:for-each select="E1PLPOL">
                        <xsl:variable name="taskListType">
                            <xsl:value-of select="//LOIROU04/IDOC/E1MAPLL/PLNTY"/>
                        </xsl:variable>
                        <xsl:variable name="nodeType">
                            <xsl:call-template name="calcNodeType">
                                <xsl:with-param name="tasklistType" select="$taskListType"/>
                                <xsl:with-param name="superOpNum" select="PVZNR"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <BillOfOperationsActivityNetworkElement>
                            <BillOfOperationsNodeType>
                                <xsl:value-of select="$nodeType"/>
                            </BillOfOperationsNodeType>
                            <BillOfOperationsNodeID>
                                <xsl:call-template name="calcNodeId">
                                    <xsl:with-param name="tasklistType" select="$taskListType"/>
                                    <xsl:with-param name="actNum" select="VORNR"/>
                                    <xsl:with-param name="superOpNum" select="PVZNR"/>
                                </xsl:call-template>
                            </BillOfOperationsNodeID>
                            <BillOfOperationsActivityNetworkElementTimeSlice>
                                <Operation>
                                    <xsl:value-of select="VORNR"/>
                                </Operation>
                                <BOOOperationInternalID>
                                    <xsl:value-of select="format-number(VORNR, '00000000')"/>
                                </BOOOperationInternalID>
                                <OperationDescription>
                                    <xsl:value-of select="LTXA1"/>
                                </OperationDescription>
                                <BillOfOperationsSequence>
                                    <xsl:value-of select="../PLNFL"/>
                                </BillOfOperationsSequence>
                                <OperationControlProfile glob1:OperationControlKey="{STEUS}">
                                    <glob1:CompletionConfirmation glob1:CompletionConfirmationCode="{RUEK}">
                                        <ConfirmationIsMilestoneConf>
                                            <xsl:choose>
                                                <xsl:when test="RUEK='1'">
                                                    <xsl:value-of select="true()"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="false()"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </ConfirmationIsMilestoneConf>
                                        <ConfirmationIsRequired>
                                            <xsl:choose>
                                                <xsl:when test="RUEK='2'">
                                                    <xsl:value-of select="true()"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="false()"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </ConfirmationIsRequired>
                                        <ConfirmationIsNotPossible>
                                            <xsl:choose>
                                                <xsl:when test="RUEK='3'">
                                                    <xsl:value-of select="true()"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="false()"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </ConfirmationIsNotPossible>
                                        <ConfirmationIsOptional>
                                            <xsl:choose>
                                                <xsl:when test="RUEK=(' ','0')">
                                                    <xsl:value-of select="true()"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="false()"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </ConfirmationIsOptional>
                                    </glob1:CompletionConfirmation>
                                    <glob1:OperationIsScheduled>
                                        <xsl:call-template name="convertIDocBool">
                                            <xsl:with-param name="bool" select="TERM"/>
                                        </xsl:call-template>
                                    </glob1:OperationIsScheduled>
                                    <glob1:CapacityRequirementsAreDtmnd>
                                        <xsl:call-template name="convertIDocBool">
                                            <xsl:with-param name="bool" select="KAPA"/>
                                        </xsl:call-template>
                                    </glob1:CapacityRequirementsAreDtmnd>
                                    <glob1:GRIsPostedAutomatically>
                                        <xsl:call-template name="convertIDocBool">
                                            <xsl:with-param name="bool" select="AUTWE"/>
                                        </xsl:call-template>
                                    </glob1:GRIsPostedAutomatically>
                                    <glob1:OperationIsNotMESRelevant>
                                        <xsl:call-template name="convertIDocBool">
                                            <xsl:with-param name="bool" select="NOT_MES_REL"/>
                                        </xsl:call-template>
                                    </glob1:OperationIsNotMESRelevant>
                                </OperationControlProfile>
                                <OperationSetupType>
                                    <xsl:value-of select="RASCH"/>
                                </OperationSetupType>
                                <OperationSetupGroup>
                                    <xsl:value-of select="RFSCH"/>
                                </OperationSetupGroup>
                                <OperationSetupGroupCategory>
                                    <xsl:value-of select="RFGRP"/>
                                </OperationSetupGroupCategory>
                                <OperationStandardTextCode>
                                    <xsl:value-of select="VGW01"/>
                                </OperationStandardTextCode>
                                <WorkCenterInternalID>
                                    <xsl:value-of select="ARBID"/>
                                </WorkCenterInternalID>
                                <WorkCenter/>
                                <xsl:if test="$taskListType != '2' or $nodeType = 'Phase'">
                                    <StandardWorkFormulaParamGroup StandardWorkFormulaParamGroupID="">
                                        <xsl:if test="VGE01 != ''">
                                            <WorkCenterFormulaParam1 WorkCenterFormulaParamID="">
                                                <StandardWorkFormulaParamName languageCode="EN">
                                                    <xsl:value-of select="PAR01_LTXT"/>
                                                </StandardWorkFormulaParamName>
                                                <WorkCenterStandardWorkQty unitCode="{VGE01}">
                                                    <xsl:value-of select="VGW01"/>
                                                </WorkCenterStandardWorkQty>
                                                <CostCtrActivityType>
                                                    <xsl:value-of select="LAR01"/>
                                                </CostCtrActivityType>
                                            </WorkCenterFormulaParam1>
                                        </xsl:if>
                                        <xsl:if test="VGE02 != ''">
                                            <WorkCenterFormulaParam2 WorkCenterFormulaParamID="">
                                                <StandardWorkFormulaParamName languageCode="EN">
                                                    <xsl:value-of select="PAR02_LTXT"/>
                                                </StandardWorkFormulaParamName>
                                                <WorkCenterStandardWorkQty unitCode="{VGE02}">
                                                    <xsl:value-of select="VGW02"/>
                                                </WorkCenterStandardWorkQty>
                                                <CostCtrActivityType>
                                                    <xsl:value-of select="LAR02"/>
                                                </CostCtrActivityType>
                                            </WorkCenterFormulaParam2>
                                        </xsl:if>
                                        <xsl:if test="VGE03 != ''">
                                            <WorkCenterFormulaParam3 WorkCenterFormulaParamID="">
                                                <StandardWorkFormulaParamName languageCode="EN">
                                                    <xsl:value-of select="PAR03_LTXT"/>
                                                </StandardWorkFormulaParamName>
                                                <WorkCenterStandardWorkQty unitCode="{VGE03}">
                                                    <xsl:value-of select="VGW03"/>
                                                </WorkCenterStandardWorkQty>
                                                <CostCtrActivityType>
                                                    <xsl:value-of select="LAR03"/>
                                                </CostCtrActivityType>
                                            </WorkCenterFormulaParam3>
                                        </xsl:if>
                                        <xsl:if test="VGE04 != ''">
                                            <WorkCenterFormulaParam4 WorkCenterFormulaParamID="">
                                                <StandardWorkFormulaParamName languageCode="EN">
                                                    <xsl:value-of select="PAR04_LTXT"/>
                                                </StandardWorkFormulaParamName>
                                                <WorkCenterStandardWorkQty unitCode="{VGE04}">
                                                    <xsl:value-of select="VGW04"/>
                                                </WorkCenterStandardWorkQty>
                                                <CostCtrActivityType>
                                                    <xsl:value-of select="LAR04"/>
                                                </CostCtrActivityType>
                                            </WorkCenterFormulaParam4>
                                        </xsl:if>
                                        <xsl:if test="VGE05 != ''">
                                            <WorkCenterFormulaParam5 WorkCenterFormulaParamID="">
                                                <StandardWorkFormulaParamName languageCode="EN">
                                                    <xsl:value-of select="PAR05_LTXT"/>
                                                </StandardWorkFormulaParamName>
                                                <WorkCenterStandardWorkQty unitCode="{VGE05}">
                                                    <xsl:value-of select="VGW05"/>
                                                </WorkCenterStandardWorkQty>
                                                <CostCtrActivityType>
                                                    <xsl:value-of select="LAR05"/>
                                                </CostCtrActivityType>
                                            </WorkCenterFormulaParam5>
                                        </xsl:if>
                                        <xsl:if test="VGE06 != ''">
                                            <WorkCenterFormulaParam6 WorkCenterFormulaParamID="">
                                                <StandardWorkFormulaParamName languageCode="EN">
                                                    <xsl:value-of select="PAR06_LTXT"/>
                                                </StandardWorkFormulaParamName>
                                                <WorkCenterStandardWorkQty unitCode="{VGE06}">
                                                    <xsl:value-of select="VGW06"/>
                                                </WorkCenterStandardWorkQty>
                                                <CostCtrActivityType>
                                                    <xsl:value-of select="LAR06"/>
                                                </CostCtrActivityType>
                                            </WorkCenterFormulaParam6>
                                        </xsl:if>
                                    </StandardWorkFormulaParamGroup>
                                </xsl:if>
                                <OperationReferenceQuantity unitCode="{MEINH}">
                                    <xsl:value-of select="BMSCH"/>
                                </OperationReferenceQuantity>
                                <OpQtyToBaseQtyNmrtr>
                                    <xsl:value-of select="UMREZ"/>
                                </OpQtyToBaseQtyNmrtr>
                                <OpQtyToBaseQtyDnmntr>
                                    <xsl:value-of select="UMREN"/>
                                </OpQtyToBaseQtyDnmntr>
                                <FactoryCalendar>
                                    <xsl:value-of select="KALID"/>
                                </FactoryCalendar>
                                <StartDateOffsetDuration unitCode=""/>
                                <EndDateOffsetDuration unitCode=""/>
                                <ChangeNumber/>
                                <ValidityStartDate>
                                    <xsl:call-template name="convertIDocDateFormat">
                                        <xsl:with-param name="date" select="DATUV"/>
                                    </xsl:call-template>
                                </ValidityStartDate>
                                <ValidityEndDate>
                                    <xsl:call-template name="convertIDocDateFormat">
                                        <xsl:with-param name="date" select="DATUB"/>
                                    </xsl:call-template>
                                </ValidityEndDate>
                                <LongText glob1:languageCode="" glob1:MIMECode="" glob1:TextCategory=""/>
                            </BillOfOperationsActivityNetworkElementTimeSlice>
                            <xsl:for-each select="E1PLMZL[STLAL='1']">
                                <BillOfOperationsActivityComponentAllocation>
                                    <BillOfMaterialCategory>
                                        <xsl:value-of select="STLTY"/>
                                    </BillOfMaterialCategory>
                                    <BillOfMaterial>
                                        <xsl:value-of select="STLNR"/>
                                    </BillOfMaterial>
                                    <BillOfMaterialVariant>
                                        <xsl:value-of select="STLAL"/>
                                    </BillOfMaterialVariant>
                                    <BillOfMaterialVariantUsage>
                                        <xsl:value-of select="1"/>
                                    </BillOfMaterialVariantUsage>
                                    <BillOfMaterialItemCategory/>
                                    <BillOfMaterialItemNodeNumber>
                                        <xsl:value-of select="STLKN"/>
                                    </BillOfMaterialItemNodeNumber>
                                    <BillOfMaterialItemNumber>
                                        <xsl:value-of select="POSNR"/>
                                    </BillOfMaterialItemNumber>
                                    <BillOfMaterialComponent>
                                        <xsl:value-of select="IDNRK"/>
                                    </BillOfMaterialComponent>
                                    <BillOfMaterialItemQuantity unitCode="{MEINS}">
                                        <xsl:value-of select="MENGE"/>
                                    </BillOfMaterialItemQuantity>
                                    <MatlCompIsMarkedForBackflush/>
                                    <ChangeNumber/>
                                    <ValidityStartDate>
                                        <xsl:call-template name="convertIDocDateFormat">
                                            <xsl:with-param name="date" select="DATUV"/>
                                        </xsl:call-template>
                                    </ValidityStartDate>
                                    <ValidityEndDate>
                                        <xsl:call-template name="convertIDocDateFormat">
                                            <xsl:with-param name="date" select="DATUB"/>
                                        </xsl:call-template>
                                    </ValidityEndDate>
                                </BillOfOperationsActivityComponentAllocation>
                            </xsl:for-each>
                        </BillOfOperationsActivityNetworkElement>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="FLGAT != 0">
                    <xsl:message terminate="yes">Only SAP Standard Master Recipes are supported.</xsl:message>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="E1MAPAL/E1PLKOL/E1PLFLL">
                <xsl:sort select="PLNFL"/>
                <xsl:for-each select="E1PLPOL">
                    <xsl:choose>
                        <xsl:when test="//LOIROU04/IDOC/E1MAPLL/PLNTY='2'">
                            <!-- master recipe -->
                            <xsl:if test="PVZNR != ''">
                                <BillOfOperationsRelationship>
                                    <PredecessorBOONodeType>Operation</PredecessorBOONodeType>
                                    <PredecessorBOONodeID>
                                        <xsl:call-template name="calcNodeId">
                                            <xsl:with-param name="tasklistType" select="'2'"/>
                                            <xsl:with-param name="actNum" select="PVZNR"/>
                                            <xsl:with-param name="superOpNum" select="''"/>
                                        </xsl:call-template>
                                    </PredecessorBOONodeID>
                                    <SuccessorBOONodeType>Phase</SuccessorBOONodeType>
                                    <SuccessorBOONodeID>
                                        <xsl:call-template name="calcNodeId">
                                            <xsl:with-param name="tasklistType" select="'2'"/>
                                            <xsl:with-param name="actNum" select="VORNR"/>
                                            <xsl:with-param name="superOpNum" select="PVZNR"/>
                                        </xsl:call-template>
                                    </SuccessorBOONodeID>
                                    <BOORelationshipType>PChild</BOORelationshipType>
                                </BillOfOperationsRelationship>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:for-each>
        </BillOfOperations>
    </xsl:template>

    <xsl:template name="convertIDocDateFormat">
        <xsl:param name="date"/>
        <xsl:value-of
                select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2))"/>
    </xsl:template>

    <xsl:template name="convertIDocTimeFormat">
        <xsl:param name="time"/>
        <xsl:if test="$time != '' and $time != '000000'">
            <xsl:value-of
                    select="concat(substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2))"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generateId">
        <xsl:param name="idocNo"/>
        <xsl:variable name="dateStr"
                      select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]-[H01].[m01].[s].[f]')"/>
        <xsl:variable name="dateStrNumOnly" select="replace($dateStr, '[^0-9]', '')"/>
        <xsl:value-of select="concat($idocNo, '-', $dateStrNumOnly)"/>
    </xsl:template>

    <xsl:template name="convertIDocBool">
        <xsl:param name="bool"/> <!-- 'X' -->
        <xsl:choose>
            <xsl:when test="$bool='X'">
                <xsl:value-of select="'true'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'false'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="calcNodeType">
        <xsl:param name="tasklistType"/>
        <xsl:param name="superOpNum"/>
        <xsl:choose>
            <xsl:when test="$tasklistType = '2'"> <!-- Master Recipe -->
                <xsl:choose>
                    <xsl:when test="$superOpNum != ''"> <!-- has superordinate operation -->
                        <xsl:value-of select="'Phase'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'Operation'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="calcNodeId">
        <xsl:param name="tasklistType"/>
        <xsl:param name="actNum"/>
        <xsl:param name="superOpNum"/>
        <xsl:choose>
            <xsl:when test="$tasklistType = '2'"> <!-- Master Recipe -->
                <xsl:choose>
                    <xsl:when test="$superOpNum != ''">
                        <xsl:value-of select="concat('PH',$actNum)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('OP',$actNum)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
