<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages"
                xmlns:gl="http://sap.com/xi/SAPGlobal20/Global"
                xmlns:pp="http://sap.com/xi/PP/Global2">

    <xsl:template match="/LOIPRO05/IDOC">
        <gl:ManufacturingOrderExecuteRequest>
            <MessageHeader>
                <!-- <xsl:variable name="uuid" select="string(uuid:randomUUID())"/> -->
                <ID>
                    <xsl:call-template name="generateId">
                        <xsl:with-param name="idocNo" select="EDI_DC40/DOCNUM"/>
                    </xsl:call-template>
                    <!-- <xsl:value-of select="replace(upper-case($uuid), '-', '')"/> -->
                </ID>
                <UUID>
                    <xsl:call-template name="generateId">
                        <xsl:with-param name="idocNo" select="EDI_DC40/DOCNUM"/>
                    </xsl:call-template>
                    <!-- <xsl:value-of select="$uuid"/> -->
                </UUID>
                <CreationDateTime>
                    <xsl:value-of select="current-dateTime()"/>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/SNDPRN"/>
                </SenderBusinessSystemID>
            </MessageHeader>
            <xsl:apply-templates select="E1AFKOL[1]"/>
        </gl:ManufacturingOrderExecuteRequest>
    </xsl:template>

    <xsl:template match="/LOIPRO05/IDOC/E1AFKOL">
        <ManufacturingOrder>
            <ManufacturingOrder>
                <xsl:value-of select="AUFNR"/>
            </ManufacturingOrder>
            <ManufacturingOrderCategory>
                <xsl:value-of select="AUTYP"/>
            </ManufacturingOrderCategory>
            <ManufacturingOrderType>
                <xsl:value-of select="AUART"/>
            </ManufacturingOrderType>
            <ProductionPlant>
                <xsl:value-of select="WERKS"/>
            </ProductionPlant>
            <Material>
                <xsl:call-template name="getMaterial">
                    <xsl:with-param name="material" select="MATNR"/>
                    <xsl:with-param name="materialExt" select="MATNR_EXTERNAL"/>
                    <xsl:with-param name="materialLong" select="MATNR_LONG"/>
                </xsl:call-template>
            </Material>
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
                <xsl:value-of select="STLAN"/>
            </BillOfMaterialVariantUsage>
            <BillOfOperationsType>
                <xsl:value-of select="PLNTY"/>
            </BillOfOperationsType>
            <BillOfOperationsGroup>
                <xsl:value-of select="PLNNR"/>
            </BillOfOperationsGroup>
            <BillOfOperationsVariant>
                <xsl:value-of select="PLNAL"/>
            </BillOfOperationsVariant>
            <MfgOrderPlannedTotalQty unitCode="{GMEIN}">
                <xsl:value-of select="GAMNG"/>
            </MfgOrderPlannedTotalQty>
            <MfgOrdPlndTotQtyInBaseUnit unitCode="{BMEINS}">
                <xsl:value-of select="BMENGE"/>
            </MfgOrdPlndTotQtyInBaseUnit>
            <BOOMinLotSizeQuantity unitCode="{PLNME}">
                <xsl:value-of select="PLSVN"/>
            </BOOMinLotSizeQuantity>
            <BOOMaxLotSizeQuantity unitCode="{PLNME}">
                <xsl:value-of select="PLSVB"/>
            </BOOMaxLotSizeQuantity>
            <MfgOrderPlannedStartDate>
                <xsl:call-template name="convertIDocDateFormat">
                    <xsl:with-param name="date" select="GSTRP"/>
                </xsl:call-template>
            </MfgOrderPlannedStartDate>
            <MfgOrderPlannedStartTime>
                <xsl:call-template name="convertIDocTimeFormat">
                    <xsl:with-param name="time" select="GSUZP"/>
                </xsl:call-template>
            </MfgOrderPlannedStartTime>
            <MfgOrderPlannedEndDate>
                <xsl:call-template name="convertIDocDateFormat">
                    <xsl:with-param name="date" select="GLTRP"/>
                </xsl:call-template>
            </MfgOrderPlannedEndDate>
            <MfgOrderPlannedEndTime>
                <xsl:call-template name="convertIDocTimeFormat">
                    <xsl:with-param name="time" select="GLUZP"/>
                </xsl:call-template>
            </MfgOrderPlannedEndTime>
            <MfgOrderScheduledStartDate>
                <xsl:call-template name="convertIDocDateFormat">
                    <xsl:with-param name="date" select="GSTRS"/>
                </xsl:call-template>
            </MfgOrderScheduledStartDate>
            <MfgOrderScheduledStartTime>
                <xsl:call-template name="convertIDocTimeFormat">
                    <xsl:with-param name="time" select="GSUZS"/>
                </xsl:call-template>
            </MfgOrderScheduledStartTime>
            <MfgOrderScheduledEndDate>
                <xsl:call-template name="convertIDocDateFormat">
                    <xsl:with-param name="date" select="GLTRS"/>
                </xsl:call-template>
            </MfgOrderScheduledEndDate>
            <MfgOrderScheduledEndTime>
                <xsl:call-template name="convertIDocTimeFormat">
                    <xsl:with-param name="time" select="GLUZS"/>
                </xsl:call-template>
            </MfgOrderScheduledEndTime>
            <InspectionLot>
                <xsl:if test="PRUEFLOS != '' and number(PRUEFLOS) != 0">
                    <xsl:value-of select="substring(concat('000000000000',PRUEFLOS),string-length(PRUEFLOS)+1)"/>
                </xsl:if>
            </InspectionLot>
            <LongText pp:MIMECode="text/plain" pp:TextCategory="{E1AFLTH[1]/TDTEXTTYPE}">
                <xsl:call-template name="convertLanguageCode">
                    <xsl:with-param name="spras" select="E1AFLTH[1]/TDSPRAS"/>
                </xsl:call-template>
                <xsl:for-each select="E1AFLTH[1]/E1AFLTP">
                    <xsl:value-of select="TDLINE"/>
                </xsl:for-each>
            </LongText>
            <ManufacturingOrderSystemStatus>
                <xsl:if test="E1JSTKL[STAT='I0328']">
                    <pp:OrderHasGeneratedOperations>true</pp:OrderHasGeneratedOperations>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0046']">
                    <pp:OrderIsClosed>true</pp:OrderIsClosed>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0009']">
                    <pp:OrderIsConfirmed>true</pp:OrderIsConfirmed>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0001']">
                    <pp:OrderIsCreated>true</pp:OrderIsCreated>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0013']">
                    <pp:OrderIsDeleted>true</pp:OrderIsDeleted>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0012']">
                    <pp:OrderIsDelivered>true</pp:OrderIsDelivered>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0043']">
                    <pp:OrderIsLocked>true</pp:OrderIsLocked>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0076']">
                    <pp:OrderIsMarkedForDeletion>true</pp:OrderIsMarkedForDeletion>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0010']">
                    <pp:OrderIsPartiallyConfirmed>true</pp:OrderIsPartiallyConfirmed>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0074']">
                    <pp:OrderIsPartiallyDelivered>true</pp:OrderIsPartiallyDelivered>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0042']">
                    <pp:OrderIsPartiallyReleased>true</pp:OrderIsPartiallyReleased>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0016']">
                    <pp:OrderIsPreCosted>true</pp:OrderIsPreCosted>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0007']">
                    <pp:OrderIsPrinted>true</pp:OrderIsPrinted>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0002']">
                    <pp:OrderIsReleased>true</pp:OrderIsReleased>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0117']">
                    <pp:OrderIsScheduled>true</pp:OrderIsScheduled>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0045']">
                    <pp:OrderIsTechnicallyCompleted>true</pp:OrderIsTechnicallyCompleted>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0369']">
                    <pp:OrderIsToBeHandledInBatches>true</pp:OrderIsToBeHandledInBatches>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0028']">
                    <pp:SettlementRuleIsCreated>true</pp:SettlementRuleIsCreated>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0102']">
                    <pp:SettlementRuleIsCrtedManually>true</pp:SettlementRuleIsCrtedManually>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0420']">
                    <pp:MaterialAvailyIsNotChecked>true</pp:MaterialAvailyIsNotChecked>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0667']">
                    <pp:OrderChangeIsRestricted>true</pp:OrderChangeIsRestricted>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0239']">
                    <pp:OrderHasNoMaterialComponents>true</pp:OrderHasNoMaterialComponents>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0321']">
                    <pp:OrderHasPostedGoodsMovements>true</pp:OrderHasPostedGoodsMovements>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0048']">
                    <pp:OrderIsDistributedToMES>true</pp:OrderIsDistributedToMES>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0666']">
                    <pp:OrderIsHandedOverToProduction>true</pp:OrderIsHandedOverToProduction>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0665']">
                    <pp:OrderIsShopFloorOrder>true</pp:OrderIsShopFloorOrder>
                </xsl:if>
                <xsl:if test="E1JSTKL[STAT='I0340']">
                    <pp:MaterialIsCommitted>true</pp:MaterialIsCommitted>
                </xsl:if>
            </ManufacturingOrderSystemStatus>

            <xsl:for-each select="E1AFPOL">
                <ManufacturingOrderItem>
                    <ManufacturingOrderItem>
                        <xsl:value-of select="POSNR"/>
                    </ManufacturingOrderItem>
                    <Material>
                        <xsl:call-template name="getMaterial">
                            <xsl:with-param name="material" select="MATNR"/>
                            <xsl:with-param name="materialExt" select="MATNR_EXTERNAL"/>
                            <xsl:with-param name="materialLong" select="MATNR_LONG"/>
                        </xsl:call-template>
                    </Material>
                    <MfgOrderItemPlannedTotalQty unitCode="{AMEIN}">
                        <xsl:value-of select="PSMNG"/>
                    </MfgOrderItemPlannedTotalQty>
                    <Batch>
                        <xsl:value-of select="CHARG"/>
                    </Batch>
                    <ProductionVersion>
                        <xsl:value-of select="VERID"/>
                    </ProductionVersion>
                    <StorageLocation>
                        <xsl:value-of select="LGORT"/>
                    </StorageLocation>
                    <WarehouseNumber>
                        <xsl:value-of select="LGNUM"/>
                    </WarehouseNumber>


                    <xsl:if test="E1AFSER">
                        <MfgOrderSerialNumbers>
                            <xsl:for-each select="E1AFSER">
                                <MfgOrderSerialNumber>
                                    <SerialNumber>
                                        <xsl:value-of select="SERNR"/>
                                    </SerialNumber>
                                    <UniqueItemIdentifier>
                                        <xsl:value-of select="UII"/>
                                    </UniqueItemIdentifier>
                                </MfgOrderSerialNumber>
                            </xsl:for-each>
                        </MfgOrderSerialNumbers>
                    </xsl:if>

                    <GoodsReceiptTolerances>
                        <pp:UnderdelivTolrtdLmtRatioInPct>
                            <xsl:value-of select="UNTTO"/>
                        </pp:UnderdelivTolrtdLmtRatioInPct>
                        <pp:UnlimitedOverdeliveryIsAllowed>
                            <xsl:value-of select="UEBTK"/>
                        </pp:UnlimitedOverdeliveryIsAllowed>
                        <pp:OverdelivTolrtdLmtRatioInPct>
                            <xsl:value-of select="UEBTO"/>
                        </pp:OverdelivTolrtdLmtRatioInPct>
                    </GoodsReceiptTolerances>
                </ManufacturingOrderItem>
            </xsl:for-each>

            <xsl:apply-templates select="E1AFFLL"/>
            <!-- <xsl:apply-templates select="E1AFABL"/> -->

            <xsl:if test="E1VCCHR">
                <ManufacturingOrderVariantConfiguration>
                    <xsl:apply-templates select="E1VCCHR"/>
                </ManufacturingOrderVariantConfiguration>
            </xsl:if>

            <!-- Sample for customFieldDtoList
            <CustomFieldList>
                <CustomField>
                    <Attribute>XYZ</Attribute>
                    <Value>value_1</Value>
                </CustomField>
                <CustomField>
                    <Attribute>ABC</Attribute>
                    <Value>value_1</Value>
                </CustomField>
            </CustomFieldList>
            -->
            <xsl:if test="E1AFPOL[POSNR='0001']/KUNAG != '' and E1AFPOL[POSNR='0001']/NAME1 != ''">
                <ErpCustomer>
                    <Customer>
                        <xsl:value-of select="E1AFPOL[POSNR='0001']/KUNAG"/>
                    </Customer>
                    <CustomerName>
                        <xsl:value-of select="E1AFPOL[POSNR='0001']/NAME1"/>
                    </CustomerName>
                </ErpCustomer>
            </xsl:if>
            <xsl:if test="E1AFPOL[POSNR='0001']/KDAUF">
                <ErpCustomerOrder>
                    <CustomerOrder>
                        <xsl:value-of select="E1AFPOL[POSNR='0001']/KDAUF"/>
                    </CustomerOrder>
                    <CustomerOrderItem>
                        <xsl:value-of select="E1AFPOL[POSNR='0001']/KDPOS"/>
                    </CustomerOrderItem>
                </ErpCustomerOrder>
            </xsl:if>
        </ManufacturingOrder>
    </xsl:template>

    <xsl:template match="/LOIPRO05/IDOC/E1AFKOL/E1AFFLL">
        <xsl:for-each select="E1AFVOL[E1JSTVL[last()]/STAT!='I0013']">
            <ManufacturingOrderActivityNetworkElement>
                <pp:MfgOrderNodeType>
                    <xsl:call-template name="calcNodeType">
                        <xsl:with-param name="orderType" select="../../AUTYP"/>
                        <xsl:with-param name="superOpNum" select="PVZNR"/>
                    </xsl:call-template>
                </pp:MfgOrderNodeType>
                <pp:MfgOrderNodeID>
                    <xsl:call-template name="calcNodeId">
                        <xsl:with-param name="orderType" select="../../AUTYP"/>
                        <xsl:with-param name="actNum" select="VORNR"/>
                        <xsl:with-param name="superOpNum" select="PVZNR"/>
                    </xsl:call-template>
                </pp:MfgOrderNodeID>
                <pp:OrderInternalBillOfOperations></pp:OrderInternalBillOfOperations>
                <pp:OrderIntBillOfOperationsItem>
                    <xsl:value-of select="VORNR"/>
                </pp:OrderIntBillOfOperationsItem>
                <pp:ManufacturingOrderOperation>
                    <xsl:value-of select="VORNR"/>
                </pp:ManufacturingOrderOperation>
                <pp:ManufacturingOrderSequence>
                    <xsl:value-of select="../PLNFL"/>
                </pp:ManufacturingOrderSequence>
                <pp:WorkCenter>
                    <xsl:value-of select="ARBPL"/>
                </pp:WorkCenter>
                <pp:WorkCenterInternalID>
                    <xsl:value-of select="ARBID"/>
                </pp:WorkCenterInternalID>
                <pp:OpPlannedTotalQuantity unitCode="{MEINH}">
                    <xsl:value-of select="MGVRG"/>
                </pp:OpPlannedTotalQuantity>
                <pp:OperationReferenceQuantity unitCode="{MEINH}">
                    <xsl:value-of select="BMSCH"/>
                </pp:OperationReferenceQuantity>
                <pp:MfgOrderOperationText>
                    <xsl:value-of select="LTXA1"/>
                </pp:MfgOrderOperationText>
                <pp:MfgOrderSequenceText>
                    <xsl:value-of select="../LTXA1"/>
                </pp:MfgOrderSequenceText>
                <pp:FactoryCalendar>
                    <xsl:value-of select="KALID"/>
                </pp:FactoryCalendar>
                <pp:OpErlstSchedldExecStrtDte>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="FSAVD"/>
                    </xsl:call-template>
                </pp:OpErlstSchedldExecStrtDte>
                <pp:OpErlstSchedldExecStrtTme>
                    <xsl:call-template name="convertIDocTimeFormat">
                        <xsl:with-param name="time" select="FSAVZ"/>
                    </xsl:call-template>
                </pp:OpErlstSchedldExecStrtTme>
                <pp:OpErlstSchedldExecEndDte>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="FSEDD"/>
                    </xsl:call-template>
                </pp:OpErlstSchedldExecEndDte>
                <pp:OpErlstSchedldExecEndTme>
                    <xsl:call-template name="convertIDocTimeFormat">
                        <xsl:with-param name="time" select="FSEDZ"/>
                    </xsl:call-template>
                </pp:OpErlstSchedldExecEndTme>
                <pp:OpLtstSchedldExecStrtDte>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="SSAVD"/>
                    </xsl:call-template>
                </pp:OpLtstSchedldExecStrtDte>
                <pp:OpLtstSchedldExecStrtTme>
                    <xsl:call-template name="convertIDocTimeFormat">
                        <xsl:with-param name="time" select="SSAVZ"/>
                    </xsl:call-template>
                </pp:OpLtstSchedldExecStrtTme>
                <pp:OpLtstSchedldExecEndDte>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="SSEDD"/>
                    </xsl:call-template>
                </pp:OpLtstSchedldExecEndDte>
                <pp:OpLtstSchedldExecEndTme>
                    <xsl:call-template name="convertIDocTimeFormat">
                        <xsl:with-param name="time" select="SSEDZ"/>
                    </xsl:call-template>
                </pp:OpLtstSchedldExecEndTme>
                <pp:EarliestFinishOfOperationDate>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="FSEVD"/>
                    </xsl:call-template>
                </pp:EarliestFinishOfOperationDate>
                <pp:EarliestFinishOfOperationTime>
                    <xsl:call-template name="convertIDocTimeFormat">
                        <xsl:with-param name="time" select="FSEVZ"/>
                    </xsl:call-template>
                </pp:EarliestFinishOfOperationTime>
                <pp:OpErlstSchedldProcgStrtDte>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="FSSBD"/>
                    </xsl:call-template>
                </pp:OpErlstSchedldProcgStrtDte>
                <pp:OpErlstSchedldProcgStrtTme>
                    <xsl:call-template name="convertIDocTimeFormat">
                        <xsl:with-param name="time" select="FSSBZ"/>
                    </xsl:call-template>
                </pp:OpErlstSchedldProcgStrtTme>
                <pp:OpLtstSchedldProcgStrtDte>
                    <xsl:call-template name="convertIDocDateFormat">
                        <xsl:with-param name="date" select="SSSBD"/>
                    </xsl:call-template>
                </pp:OpLtstSchedldProcgStrtDte>
                <pp:OpLtstSchedldProcgStrtTme>
                    <xsl:call-template name="convertIDocTimeFormat">
                        <xsl:with-param name="time" select="SSSBZ"/>
                    </xsl:call-template>
                </pp:OpLtstSchedldProcgStrtTme>
                <pp:OpPlannedProcessingDurn unitCode="{BEAZE}">
                    <xsl:value-of select="BEARZ"/>
                </pp:OpPlannedProcessingDurn>
                <pp:MfgOrderConfirmationGroup></pp:MfgOrderConfirmationGroup>
                <pp:OperationControlProfile pp:OperationControlKey="{STEUS}">
                    <pp:CompletionConfirmation pp:CompletionConfirmationCode="{RUEK}">
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
                                <xsl:when test="RUEK=(' ','0','') or empty(RUEK)">
                                    <xsl:value-of select="true()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="false()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ConfirmationIsOptional>
                    </pp:CompletionConfirmation>
                    <pp:OperationIsScheduled>
                        <xsl:call-template name="convertToBool">
                            <xsl:with-param name="bool" select="E1AFVOL2/TERM"/>
                        </xsl:call-template>
                    </pp:OperationIsScheduled>
                    <pp:CapacityRequirementsAreDtmnd>
                        <xsl:call-template name="convertToBool">
                            <xsl:with-param name="bool" select="E1AFVOL2/KAPA"/>
                        </xsl:call-template>
                    </pp:CapacityRequirementsAreDtmnd>
                    <pp:GRIsPostedAutomatically>
                        <xsl:call-template name="convertToBool">
                            <xsl:with-param name="bool" select="E1AFVOL2/AUTWE"/>
                        </xsl:call-template>
                    </pp:GRIsPostedAutomatically>
                    <pp:OperationIsNotMESRelevant>
                        <xsl:call-template name="convertToBool">
                            <xsl:with-param name="bool" select="E1AFVOL2/NOT_MES_REL"/>
                        </xsl:call-template>
                    </pp:OperationIsNotMESRelevant>
                </pp:OperationControlProfile>
                <pp:StandardWorkFormulaParamGroup StandardWorkFormulaParamGroupID="{VGWTS}">
                    <xsl:if test="VGE01 != ''">
                        <WorkCenterFormulaParam1 WorkCenterFormulaParamID="">
                            <StandardWorkFormulaParamName languageCode="">
                                <xsl:value-of select="E1AFVOL2/PAR01_LTXT"/>
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
                            <StandardWorkFormulaParamName languageCode="">
                                <xsl:value-of select="E1AFVOL2/PAR02_LTXT"/>
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
                            <StandardWorkFormulaParamName languageCode="">
                                <xsl:value-of select="E1AFVOL2/PAR03_LTXT"/>
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
                            <StandardWorkFormulaParamName languageCode="">
                                <xsl:value-of select="E1AFVOL2/PAR04_LTXT"/>
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
                            <StandardWorkFormulaParamName languageCode="">
                                <xsl:value-of select="E1AFVOL2/PAR05_LTXT"/>
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
                            <StandardWorkFormulaParamName languageCode="">
                                <xsl:value-of select="E1AFVOL2/PAR06_LTXT"/>
                            </StandardWorkFormulaParamName>
                            <WorkCenterStandardWorkQty unitCode="{VGE06}">
                                <xsl:value-of select="VGW06"/>
                            </WorkCenterStandardWorkQty>
                            <CostCtrActivityType>
                                <xsl:value-of select="LAR06"/>
                            </CostCtrActivityType>
                        </WorkCenterFormulaParam6>
                    </xsl:if>
                </pp:StandardWorkFormulaParamGroup>
                <xsl:for-each select="E1RESBL">
                    <pp:ManufacturingOrderComponent>
                        <RequirementType>
                            <xsl:value-of select="BDART"/>
                        </RequirementType>
                        <RequiredQuantityInBaseUnit unitCode="{MEINS}">
                            <xsl:value-of select="BDMNG"/>
                        </RequiredQuantityInBaseUnit>
                        <MatlCompRequirementDate>
                            <xsl:call-template name="convertIDocDateFormat">
                                <xsl:with-param name="date" select="BDTER"/>
                            </xsl:call-template>
                        </MatlCompRequirementDate>
                        <Batch>
                            <xsl:value-of select="CHARG"/>
                        </Batch>
                        <Material>
                            <xsl:call-template name="getMaterial">
                                <xsl:with-param name="material" select="MATNR"/>
                                <xsl:with-param name="materialExt" select="MATNR_EXTERNAL"/>
                                <xsl:with-param name="materialLong" select="MATNR_LONG"/>
                            </xsl:call-template>
                        </Material>
                        <Reservation>
                            <xsl:value-of select="RSNUM"/>
                        </Reservation>
                        <ReservationItem>
                            <xsl:value-of select="RSPOS"/>
                        </ReservationItem>
                        <GoodsMovementType>
                            <xsl:value-of select="BWART"/>
                        </GoodsMovementType>
                        <BillOfMaterialItemNumber>
                            <xsl:value-of select="POSNR"/>
                        </BillOfMaterialItemNumber>
                        <BillOfMaterialItemCategory>
                            <xsl:value-of select="POSTP"/>
                        </BillOfMaterialItemCategory>
                        <ManufacturingOrderItem>
                            <xsl:value-of select="AFPOS"/>
                        </ManufacturingOrderItem>
                        <BillOfMaterial>
                            <xsl:value-of select="STLNR"/>
                        </BillOfMaterial>
                        <BillOfMaterialItemNodeNumber>
                            <xsl:value-of select="STLKN"/>
                        </BillOfMaterialItemNodeNumber>
                        <SupplyArea>
                            <xsl:value-of select="PRVBE"/>
                        </SupplyArea>
                        <StorageLocation>
                            <xsl:value-of select="LGORT"/>
                        </StorageLocation>
                        <MatlCompIsMarkedForBackflush>
                            <xsl:value-of select="RGEKZ"/>
                        </MatlCompIsMarkedForBackflush>
                        <MaterialIsCoProduct>
                            <xsl:value-of select="KZKUP"/>
                        </MaterialIsCoProduct>
                        <DebitCreditCode>
                            <xsl:value-of select="SHKZG"/>
                        </DebitCreditCode>
                        <InventorySpecialStockType>
                            <xsl:value-of select="SOBKZ"/>
                        </InventorySpecialStockType>
                        <AlternativeItemGroup>
                            <xsl:value-of select="ALPGR"/>
                        </AlternativeItemGroup>
                        <AlternativeItemPriority>
                            <xsl:value-of select="ALPRF"/>
                        </AlternativeItemPriority>
                        <UsageProbabilityPercent>
                            <xsl:value-of select="EWAHR"/>
                        </UsageProbabilityPercent>
                        <WarehouseNumber>
                            <xsl:value-of select="LGNUM"/>
                        </WarehouseNumber>
                    </pp:ManufacturingOrderComponent>
                </xsl:for-each>
                <xsl:for-each select="E1QAMVL">
                    <pp:ManufacturingOrderInspCharc>
                        <InspectionCharacteristic>
                            <xsl:value-of select="INSPCHAR"/>
                        </InspectionCharacteristic>
                        <InspectionSpecificationText>
                            <xsl:value-of select="CHAR_DESCR"/>
                        </InspectionSpecificationText>
                        <InspSpecCharacteristicType>
                            <xsl:value-of select="CHAR_TYPE"/>
                        </InspSpecCharacteristicType>
                        <InspSpecCharcCategory>
                            <xsl:value-of select="OBLIGATORY"/>
                        </InspSpecCharcCategory>
                        <InspSpecRecordingType>
                            <xsl:value-of select="SINGLE_RES"/>
                        </InspSpecRecordingType>
                        <InspCharacteristicSampleSize unitCode="{SMPL_UNIT}">
                            <xsl:value-of select="SCOPE"/>
                        </InspCharacteristicSampleSize>
                        <InspectionScope>
                            <xsl:value-of select="SCOPE_IND"/>
                        </InspectionScope>
                        <InspResultIsDocumentationRqd>
                            <xsl:value-of select="DOCU_REQU"/>
                        </InspResultIsDocumentationRqd>
                        <InspSpecDecimalPlaces>
                            <xsl:value-of select="DEC_PLACES"/>
                        </InspSpecDecimalPlaces>
                        <InspSpecTargetValue unitCode="{MEAS_UNIT}">
                            <xsl:value-of select="TARGET_VAL"/>
                        </InspSpecTargetValue>
                        <InspSpecLowerLimit unitCode="{MEAS_UNIT}">
                            <xsl:value-of select="LW_TOL_LMT"/>
                        </InspSpecLowerLimit>
                        <InspSpecUpperLimit unitCode="{MEAS_UNIT}">
                            <xsl:value-of select="UP_TOL_LMT"/>
                        </InspSpecUpperLimit>
                        <InspSpecLowerPlausibilityLimit unitCode="{MEAS_UNIT}">
                            <xsl:value-of select="LW_PLS_LMT"/>
                        </InspSpecLowerPlausibilityLimit>
                        <InspSpecUpperPlausibilityLimit unitCode="{MEAS_UNIT}">
                            <xsl:value-of select="UP_PLS_LMT"/>
                        </InspSpecUpperPlausibilityLimit>
                        <CharacteristicAttributeCatalog>
                            <xsl:value-of select="CAT_TYPE1"/>
                        </CharacteristicAttributeCatalog>
                        <SelectedCodeSet>
                            <xsl:value-of select="SEL_SET1"/>
                        </SelectedCodeSet>
                        <SelectedCodeSetPlant>
                            <xsl:value-of select="PSEL_SET1"/>
                        </SelectedCodeSetPlant>
                        <InspSpecInformationField1>
                            <xsl:value-of select="INFOFIELD1"/>
                        </InspSpecInformationField1>
                        <InspSpecInformationField2>
                            <xsl:value-of select="INFOFIELD2"/>
                        </InspSpecInformationField2>
                        <InspSpecInformationField3>
                            <xsl:value-of select="INFOFIELD3"/>
                        </InspSpecInformationField3>
                        <InspSpecIsDefectsRecgAutomatic>
                            <xsl:value-of select="FEHLREC"/>
                        </InspSpecIsDefectsRecgAutomatic>
                        <InspLotIsSerialNumberRequired>
                            <xsl:value-of select="SERIALREQU"/>
                        </InspLotIsSerialNumberRequired>
                        <InspCharcSampleValuationType>
                            <xsl:value-of select="VALN_TYPE"/>
                        </InspCharcSampleValuationType>
                    </pp:ManufacturingOrderInspCharc>
                </xsl:for-each>

                <pp:LongText pp:languageCode="" pp:MIMECode="text/plain" pp:TextCategory=""></pp:LongText>

                <pp:ActivityNetworkElementSystemStatus>
                    <xsl:if test="E1JSTVL[STAT='I0001']">
                        <pp:CreatedStatusIsActive>true</pp:CreatedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0002']">
                        <pp:ReleasedStatusIsActive>true</pp:ReleasedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0007']">
                        <pp:PrintedStatusIsActive>true</pp:PrintedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0009']">
                        <pp:ConfirmedStatusIsActive>true</pp:ConfirmedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0010']">
                        <pp:PrtlyConfirmedStatusIsActive>true</pp:PrtlyConfirmedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0013']">
                        <pp:DeletedStatusIsActive>true</pp:DeletedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0045']">
                        <pp:TechlyCompletedStatusIsActive>true</pp:TechlyCompletedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0046']">
                        <pp:ClosedStatusIsActive>true</pp:ClosedStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0117']">
                        <pp:ScheduledStatusIsActive>true</pp:ScheduledStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0074']">
                        <pp:PrtlyDeliveredStatusIsActive>true</pp:PrtlyDeliveredStatusIsActive>
                    </xsl:if>
                    <xsl:if test="E1JSTVL[STAT='I0012']">
                        <pp:DeliveredStatusIsActive>true</pp:DeliveredStatusIsActive>
                    </xsl:if>
                </pp:ActivityNetworkElementSystemStatus>
            </ManufacturingOrderActivityNetworkElement>
        </xsl:for-each>
        <xsl:if test="../../AUTYP = '10'">
            <xsl:if test="not(PLNFL=('000000','0')) and FLGAT='1'">
                <!-- parallel sequence -->
                <ManufacturingOrderActivityNetworkElement>
                    <!-- TODO: confirm this is the right type name -->
                    <pp:MfgOrderNodeType>StartParallelEvent</pp:MfgOrderNodeType>
                    <!-- TODO: what should be the ID? -->
                    <pp:MfgOrderNodeID>
                        <xsl:value-of select="concat(/LOIPRO05/IDOC/E1AFKOL/AUFNR,'SPEVT')"/>
                    </pp:MfgOrderNodeID>
                    <pp:ManufacturingOrderOperation>
                        <xsl:value-of select="VORNR1"/>
                    </pp:ManufacturingOrderOperation>
                </ManufacturingOrderActivityNetworkElement>

                <ManufacturingOrderActivityNetworkElement>
                    <!-- TODO: confirm this is the right type name -->
                    <pp:MfgOrderNodeType>EndParallelEvent</pp:MfgOrderNodeType>
                    <!-- TODO: what should be the ID? -->
                    <pp:MfgOrderNodeID>
                        <xsl:value-of select="concat(/LOIPRO05/IDOC/E1AFKOL/AUFNR,'EPEVT')"/>
                    </pp:MfgOrderNodeID>
                    <pp:ManufacturingOrderOperation>
                        <xsl:value-of select="VORNR2"/>
                    </pp:ManufacturingOrderOperation>
                </ManufacturingOrderActivityNetworkElement>
            </xsl:if>
            <xsl:if test="not(PLNFL=('000000','0')) and FLGAT='2'">
                <!-- alternative sequence -->
                <ManufacturingOrderActivityNetworkElement>
                    <!-- TODO: confirm this is the right type name -->
                    <pp:MfgOrderNodeType>StartAlternativeEvent</pp:MfgOrderNodeType>
                    <!-- TODO: what should be the ID? -->
                    <pp:MfgOrderNodeID>
                        <xsl:value-of select="concat(/LOIPRO05/IDOC/E1AFKOL/AUFNR,'SAEVT')"/>
                    </pp:MfgOrderNodeID>
                    <pp:ManufacturingOrderOperation>
                        <xsl:value-of select="VORNR1"/>
                    </pp:ManufacturingOrderOperation>
                </ManufacturingOrderActivityNetworkElement>

                <ManufacturingOrderActivityNetworkElement>
                    <!-- TODO: confirm this is the right type name -->
                    <pp:MfgOrderNodeType>EndAlternativeEvent</pp:MfgOrderNodeType>
                    <!-- TODO: what should be the ID? -->
                    <pp:MfgOrderNodeID>
                        <xsl:value-of select="concat(/LOIPRO05/IDOC/E1AFKOL/AUFNR,'EAEVT')"/>
                    </pp:MfgOrderNodeID>
                    <pp:ManufacturingOrderOperation>
                        <xsl:value-of select="VORNR2"/>
                    </pp:ManufacturingOrderOperation>
                </ManufacturingOrderActivityNetworkElement>
            </xsl:if>
        </xsl:if>

        <xsl:for-each select="E1AFVOL[E1JSTVL[last()]/STAT!='I0013']">
            <xsl:sort select="VORNR"/>
            <xsl:choose>
                <xsl:when test="../../AUTYP = '40'">
                    <!-- process order -->
                    <xsl:if test="PVZNR != ''">
                        <ManufacturingOrderRelationship>
                            <PredecessorMfgOrderNodeType>Operation</PredecessorMfgOrderNodeType>
                            <PredecessorMfgOrderNodeID>
                                <xsl:call-template name="calcNodeId">
                                    <xsl:with-param name="orderType" select="'40'"/>
                                    <xsl:with-param name="actNum" select="PVZNR"/>
                                    <xsl:with-param name="superOpNum" select="''"/>
                                </xsl:call-template>
                            </PredecessorMfgOrderNodeID>
                            <PredecessorOrder>
                                <xsl:value-of select="../../AUFNR"/>
                            </PredecessorOrder>
                            <PredecessorOrderOperation>
                                <xsl:value-of select="PVZNR"/>
                            </PredecessorOrderOperation>
                            <SuccessorMfgOrderNodeType>Phase</SuccessorMfgOrderNodeType>
                            <SuccessorMfgOrderNodeID>
                                <xsl:call-template name="calcNodeId">
                                    <xsl:with-param name="orderType" select="'40'"/>
                                    <xsl:with-param name="actNum" select="VORNR"/>
                                    <xsl:with-param name="superOpNum" select="PVZNR"/>
                                </xsl:call-template>
                            </SuccessorMfgOrderNodeID>
                            <SuccessorOrder>
                                <xsl:value-of select="../../AUFNR"/>
                            </SuccessorOrder>
                            <SuccessorOrderOperation>
                                <xsl:value-of select="VORNR"/>
                            </SuccessorOrderOperation>
                            <NetworkActivityRelationType>PChild</NetworkActivityRelationType>
                        </ManufacturingOrderRelationship>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <!-- production order -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- <xsl:template match="/LOIPRO05/IDOC/E1AFKOL/E1AFABL">
        <ManufacturingOrderRelationship>
            <PredecessorMfgOrderNodeType></PredecessorMfgOrderNodeType>
            <PredecessorMfgOrderNodeID></PredecessorMfgOrderNodeID>
            <PredecessorOrder>
                <xsl:value-of select="AUFNR_VOR"/>
            </PredecessorOrder>
            <PredecessorOrderOperation>
                <xsl:value-of select="VORNR_VOR"/>
            </PredecessorOrderOperation>
            <SuccessorMfgOrderNodeType/>
            <SuccessorMfgOrderNodeID/>
            <SuccessorOrder>
                <xsl:value-of select="AUFNR_NCH"/>
            </SuccessorOrder>
            <SuccessorOrderOperation>
                <xsl:value-of select="VORNR_NCH"/>
            </SuccessorOrderOperation>
            <NetworkActivityRelationType>
                <xsl:value-of select="AOBAR"/>
            </NetworkActivityRelationType>
            <WorkCenterInternalID>
                <xsl:value-of select="ARBID"/>
            </WorkCenterInternalID>
            <WorkCenter></WorkCenter>
            <WorkCenterPlant></WorkCenterPlant>
            <FactoryCalender>
                <xsl:value-of select="KALID"/>
            </FactoryCalender>
            <TimeIntvlBtwnRelshpNode>
                <TimeIntvlBtwnRelshpControl TimeIntvlBtwnRelshpControl="{PROVG}">
                    <TimeIntvlIsAbsolute></TimeIntvlIsAbsolute>
                    <TimeIntvlIsPctOfPrdcssrDurn></TimeIntvlIsPctOfPrdcssrDurn>
                    <TimeIntvlIsPctOfSuccssrDurn></TimeIntvlIsPctOfSuccssrDurn>
                </TimeIntvlBtwnRelshpControl>
                <TimeIntvlBtwnRelshp unitCode="{ZEINH}">
                    <xsl:value-of select="DAUER"/>
                </TimeIntvlBtwnRelshp>
                <MaxTimeIntvlBtwnRelshp unitCode="">
                    <xsl:value-of select="DAUERMAX"/>
                </MaxTimeIntvlBtwnRelshp>
                <TimeIntvlBtwnRelshpInPct>
                    <xsl:value-of select="PRZNT"/>
                </TimeIntvlBtwnRelshpInPct>
            </TimeIntvlBtwnRelshpNode>
            <PredecessorProjNtwkIntID>
                <xsl:value-of select="AUFNR_VOR"/>
            </PredecessorProjNtwkIntID>
            <PredecessorNtwkActyIntID>
                <xsl:value-of select="VORNR_VOR"/>
            </PredecessorNtwkActyIntID>
            <SuccessorProjNtwkIntID>
                <xsl:value-of select="AUFNR_NCH"/>
            </SuccessorProjNtwkIntID>
            <SuccessorNtwkActyIntID>
                <xsl:value-of select="VORNR_NCH"/>
            </SuccessorNtwkActyIntID>
        </ManufacturingOrderRelationship>
    </xsl:template> -->

    <xsl:template match="/LOIPRO05/IDOC/E1AFKOL/E1VCCHR">
        <CharacteristicValuationOutb>
            <Characteristic>
                <xsl:value-of select="ATNAM"/>
            </Characteristic>
            <CharcValue>
                <xsl:value-of select="ATWRT"/>
            </CharcValue>
        </CharacteristicValuationOutb>
    </xsl:template>

    <xsl:template name="convertIDocDateFormat">
        <xsl:param name="date"/>
        <xsl:value-of
                select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2))"/>
    </xsl:template>

    <xsl:template name="convertIDocTimeFormat">
        <xsl:param name="time"/>
        <xsl:value-of
                select="concat(substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2))"/>
    </xsl:template>

    <xsl:template name="generateId">
        <!-- IDOC Number + TS -->
        <xsl:param name="idocNo"/>
        <xsl:variable name="dateStr"
                      select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]-[H01].[m01].[s].[f]')"/>
        <xsl:variable name="dateStrNumOnly" select="replace($dateStr, '[^0-9]', '')"/>
        <xsl:value-of select="concat($idocNo, '-', $dateStrNumOnly)"/>
    </xsl:template>

    <xsl:template name="convertLanguageCode">
        <xsl:param name="spras"/>
        <xsl:attribute name="languageCode" namespace="http://sap.com/xi/PP/Global2">
            <xsl:choose>
                <!-- SPRAS refer to DB table T002 -->
                <!-- ISO code refer to http://www.lingoes.net/en/translator/langcode.htm -->
                <xsl:when test="$spras='E'">
                    <xsl:value-of select="'EN'"/>
                </xsl:when>
                <xsl:when test="$spras='1'">
                    <xsl:value-of select="'zh-CN'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="calcNodeType">
        <xsl:param name="orderType"/>
        <xsl:param name="superOpNum"/>
        <xsl:choose>
            <xsl:when test="$orderType = '40'"> <!-- process order -->
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
        <xsl:param name="orderType"/>
        <xsl:param name="actNum"/>
        <xsl:param name="superOpNum"/>
        <xsl:choose>
            <xsl:when test="$orderType = '40'"> <!-- process order -->
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

    <xsl:template name="getMaterial">
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
                <xsl:when test="string-length($materialExt) > 18">
                    <xsl:value-of select="'0000000000000000000000000000000000000000'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'000000000000000000'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="materialNumber" select="string(number($materialString))"/>
        <xsl:choose>
            <xsl:when test="$materialNumber='NaN'">
                <xsl:value-of select="$materialString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number(number($materialNumber), $materialMask)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="convertToBool">
        <xsl:param name="bool"/> <!-- 'X' -->
        <xsl:choose>
            <xsl:when test="$bool='X'">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>