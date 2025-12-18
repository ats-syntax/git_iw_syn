<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gl="http://sap.com/xi/SAPGlobal20/Global"
                xmlns:pp="http://sap.com/xi/PP/Global2">
    <xsl:template match="/IORDER01">
        <xsl:apply-templates select="IDOC/E1ORHDR[1]"/>
    </xsl:template>

    <xsl:template match="/IORDER01/IDOC/E1ORHDR">
        <xsl:variable name="orderNumber">
            <xsl:value-of select="AUFNR"/>
        </xsl:variable>

        <upsertOrderApiRequest>
            <SenderBusinessSystemID>
                <xsl:value-of select="../EDI_DC40/SNDPRN"/>
            </SenderBusinessSystemID>
            <idocNumber>
                <xsl:value-of select="../EDI_DC40/DOCNUM"/>
            </idocNumber>
            <orderNumber>
                <xsl:value-of select="AUFNR"/>
            </orderNumber>
            <plant>
                <xsl:value-of select="WERKS"/>
            </plant>
            <orderCategory>
                <xsl:text>SERVICE_ORDER</xsl:text>
            </orderCategory>
            <xsl:variable name="headerMaterial">
                <xsl:variable name="material">
                    <xsl:call-template name="getMaterial">
                        <xsl:with-param name="material" select="E1ORTOB/MATNR"/>
                        <xsl:with-param name="materialExt" select="E1ORTOB/MATNR_EXTERNAL"/>
                        <xsl:with-param name="materialLong" select="E1ORTOB/MATNR_LONG"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="assembly">
                    <xsl:call-template name="getMaterial">
                        <xsl:with-param name="material" select="E1ORTOB/BAUTL"/>
                        <xsl:with-param name="materialExt" select="E1ORTOB/BAUTL_EXTERNAL"/>
                        <xsl:with-param name="materialLong" select="E1ORTOB/BAUTL_LONG"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$material != ''">
                        <xsl:value-of select="$material"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$assembly"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <material>
                <xsl:value-of select="$headerMaterial"/>
            </material>
            <productionVersion/>
            <plannedQuantityInBaseUnit>1</plannedQuantityInBaseUnit>
            <baseUnit/>
            <baseIsoUnit/>
            <plannedQuantityInProductionUnit/>
            <productionUnit/>
            <productionIsoUnit/>
            <batchNumber/>
            <erpOrder>true</erpOrder>
            <erpBomId/>
            <erpBomUsage/>
            <erpAlternativeBomId/>
            <taskListType>
                <xsl:value-of select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/TASK_LIST_TYPE"/>
            </taskListType>
            <erpRoutingGroup>
                <xsl:value-of select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/TASK_LIST_GROUP"/>
            </erpRoutingGroup>
            <erpGroupCounter>
                <xsl:value-of select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/GROUP_COUNTER"/>
            </erpGroupCounter>
            <xsl:if test="PRIOK">
                <priority>
                    <xsl:value-of select="PRIOK"/>
                </priority>
            </xsl:if>
            <underdeliveryTolerance/>
            <minimumDeliveryQuantity/>
            <overdeliveryTolerance/>
            <maximumDeliveryQuantity/>
            <plannedStart>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="GSTRP"/>
                    <xsl:with-param name="time" select="GSUZP"/>
                </xsl:call-template>
            </plannedStart>
            <plannedEnd>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="GLTRP"/>
                    <xsl:with-param name="time" select="GLUZP"/>
                </xsl:call-template>
            </plannedEnd>
            <scheduledStart>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="GSTRS"/>
                    <xsl:with-param name="time" select="GSUZS"/>
                </xsl:call-template>
            </scheduledStart>
            <scheduledEnd>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="GLTRS"/>
                    <xsl:with-param name="time" select="GLUZS"/>
                </xsl:call-template>
            </scheduledEnd>
            <xsl:if test="string(//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/LACD_DATE) and string(//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/LACD_DATE) != '0000-00-00'">
                <finalDueDate>
                    <xsl:value-of
                            select="concat(//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/LACD_DATE, 'T00:00:00.000Z')"/>
                </finalDueDate>
            </xsl:if>
            <putawayStorageLocation/>
            <warehouseNumber/>
            <salesOrder/>
            <xsl:choose>
                <xsl:when test="E1ORPAR[PARVW='SP']">
                    <customerId>
                        <xsl:value-of select="E1ORPAR[PARVW='SP']/PARNR"/>
                    </customerId>
                    <customerName>
                        <xsl:value-of select="E1ORPAR[PARVW='SP']/E1ORPAR_ADR/NAME1"/>
                    </customerName>
                </xsl:when>

                <xsl:when test="E1ORTOB/E1ORTOB_PARTNR[PARVW='SP']">
                    <customerId>
                        <xsl:value-of select="E1ORTOB/E1ORTOB_PARTNR[PARVW='SP']/PARNR"/>
                    </customerId>
                    <customerName>
                        <xsl:value-of select="E1ORTOB/E1ORTOB_PARTNR[PARVW='SP']/E1ORTOB_PARTNR_ADR/NAME1"/>
                    </customerName>
                </xsl:when>
            </xsl:choose>
            <equipmentNumber>
                <xsl:value-of select="EQUNR"/>
            </equipmentNumber>
            <xsl:choose>
                <xsl:when test="//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/INGRP">
                    <plannerGroup>
                        <xsl:value-of select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/INGRP"/>
                    </plannerGroup>
                </xsl:when>
                <xsl:otherwise>
                    <plannerGroup>
                        <xsl:value-of select="(E1NTHDR/INGRP)[1]"/>
                    </plannerGroup>
                </xsl:otherwise>
            </xsl:choose>
            <maintenancePlan>
                <xsl:value-of select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ES_HEADER/MNTPLAN"/>
            </maintenancePlan>
            <xsl:choose>
                <xsl:when test="E1ORHDR_LTXT">
                    <headerText>
                        <value>
                            <xsl:for-each select="E1ORHDR_LTXT">
                                <xsl:if test="position() != 1 and TDFORMAT = '*'">
                                    <xsl:text>&#xa;</xsl:text>
                                </xsl:if>
                                <xsl:value-of select="TDLINE"/>
                            </xsl:for-each>
                        </value>
                        <language>
                            <xsl:value-of select="LANGU_ISO"/>
                        </language>
                        <mimeType>text/plain</mimeType>
                    </headerText>
                </xsl:when>
                <xsl:when test="KTEXT">
                    <headerText>
                        <value>
                            <xsl:value-of select="KTEXT"/>
                        </value>
                        <language>
                            <xsl:value-of select="LANGU_ISO"/>
                        </language>
                        <mimeType>text/plain</mimeType>
                    </headerText>
                </xsl:when>
            </xsl:choose>
            <serialNumbers>
                <xsl:if test="E1ORTOB/SERNR">
                    <serialNumber>
                        <xsl:value-of select="E1ORTOB/SERNR"/>
                    </serialNumber>
                </xsl:if>
            </serialNumbers>
            <customValues/>
            <notifications>
                <xsl:for-each select="E1NTHDR">
                    <notifications>
                        <xsl:value-of select="QMNUM"/>
                    </notifications>
                </xsl:for-each>
            </notifications>
            <bom>
                <bom>
                    <xsl:value-of select="concat($orderNumber, '-', $headerMaterial)"/>
                </bom>
                <description>
                    <xsl:value-of select="$headerMaterial"/>
                </description>
                <components>
                    <xsl:choose>
                        <xsl:when test="//BAPI_ALM_ORDER_GET_DETAIL.Response/ET_COMPONENTS">
                            <xsl:for-each
                                    select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ET_COMPONENTS/item">
                                <component>
                                    <material>
                                        <xsl:call-template name="getMaterial">
                                            <xsl:with-param name="material" select="MATERIAL"/>
                                            <xsl:with-param name="materialExt" select="MATERIAL_EXTERNAL"/>
                                            <xsl:with-param name="materialLong" select="MATERIAL_LONG"/>
                                        </xsl:call-template>
                                    </material>
                                    <sequence>
                                        <xsl:value-of select="position()"/>
                                    </sequence>
                                    <erpSequence>
                                        <xsl:value-of select="ITEM_NUMBER"/>
                                    </erpSequence>
                                    <componentType>
                                        <xsl:text>NORMAL</xsl:text>
                                    </componentType>
                                    <totalQuantityInBaseUnit>
                                        <xsl:value-of select="REQUIREMENT_QUANTITY"/>
                                    </totalQuantityInBaseUnit>
                                    <baseUnit>
                                        <xsl:value-of select="REQUIREMENT_QUANTITY_UNIT"/>
                                    </baseUnit>
                                    <baseIsoUnit>
                                        <xsl:value-of select="REQUIREMENT_QUANTITY_UNIT_ISO"/>
                                    </baseIsoUnit>
                                    <assemblyQuantityAsRequired/>
                                    <alternatesEnabled/>
                                    <alternativeItemGroup/>
                                    <assemblyDataType/>
                                    <assemblyOperationActivity>
                                        <operationActivity>
                                            <xsl:value-of select="concat($orderNumber, '-0-', ACTIVITY)"/>
                                        </operationActivity>
                                        <!-- <version/> -->
                                    </assemblyOperationActivity>
                                    <backflushEnabled/>
                                    <componentScrap/>
                                    <toleranceOver/>
                                    <toleranceUnder/>
                                    <storageLocation>
                                        <xsl:value-of select="STGE_LOC"/>
                                    </storageLocation>
                                    <batchNumber>
                                        <xsl:value-of select="BATCH"/>
                                    </batchNumber>
                                    <reservationNumber>
                                        <xsl:value-of select="RESERV_NO"/>
                                    </reservationNumber>
                                    <reservationItemNumber>
                                        <xsl:value-of select="RES_ITEM"/>
                                    </reservationItemNumber>
                                    <warehouseNumber/>
                                    <productionSupplyArea/>
                                    <!-- <alternates/> -->
                                    <!-- <refDes/> -->
                                    <customValues/>
                                </component>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each
                                    select="//E1OROPR[not(contains(STTXT, 'DLT'))]/E1OROPR_MAT[(string(MATNR) or string(MATNR_EXTERNAL) or string(MATNR_LONG))]">
                                <component>
                                    <material>
                                        <xsl:call-template name="getMaterial">
                                            <xsl:with-param name="material" select="MATNR"/>
                                            <xsl:with-param name="materialExt" select="MATNR_EXTERNAL"/>
                                            <xsl:with-param name="materialLong" select="MATNR_LONG"/>
                                        </xsl:call-template>
                                    </material>
                                    <sequence>
                                        <xsl:value-of select="position()"/>
                                    </sequence>
                                    <erpSequence>
                                        <xsl:value-of select="position()"/>
                                    </erpSequence>
                                    <componentType>
                                        <xsl:text>NORMAL</xsl:text>
                                    </componentType>
                                    <totalQuantityInBaseUnit>
                                        <xsl:value-of select="BDMNG"/>
                                    </totalQuantityInBaseUnit>
                                    <baseUnit/>
                                    <baseIsoUnit>
                                        <xsl:value-of select="MEINS"/>
                                    </baseIsoUnit>
                                    <assemblyQuantityAsRequired/>
                                    <alternatesEnabled/>
                                    <alternativeItemGroup/>
                                    <assemblyDataType/>
                                    <assemblyOperationActivity>
                                        <operationActivity>
                                            <xsl:value-of select="concat($orderNumber, '-0-', ../VORNR)"/>
                                        </operationActivity>
                                        <!-- <version/> -->
                                    </assemblyOperationActivity>
                                    <backflushEnabled/>
                                    <componentScrap/>
                                    <toleranceOver/>
                                    <toleranceUnder/>
                                    <storageLocation/>
                                    <batchNumber/>
                                    <reservationNumber>
                                        <xsl:value-of select="RSNUM"/>
                                    </reservationNumber>
                                    <reservationItemNumber/>
                                    <warehouseNumber/>
                                    <productionSupplyArea/>
                                    <!-- <alternates/> -->
                                    <!-- <refDes/> -->
                                    <customValues/>
                                </component>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </components>
                <customValues/>
            </bom>
            <routing>
                <routing>
                    <xsl:value-of select="$orderNumber"/>
                </routing>
                <routingType>
                    <xsl:text>SERVICE_ORDER_ROUTING</xsl:text>
                </routingType>
                <description>
                    <xsl:value-of select="$headerMaterial"/>
                </description>
                <xsl:variable name="firstStep">
                    <xsl:for-each select="E1OROPR[not(contains(STTXT, 'DLT'))]">
                        <xsl:if test="position() = 1">
                            <xsl:value-of select="VORNR"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <entryRoutingStepId>
                    <xsl:value-of select="$firstStep"/>
                </entryRoutingStepId>
                <quantityValidation>true</quantityValidation>
                <automaticGoodsReceipt/>
                <relaxedFlow/>
                <routingOperationGroups>
                    <xsl:for-each select="E1OROPR[not(contains(STTXT, 'DLT'))]">
                        <xsl:variable name="groupOperation">
                            <xsl:value-of select="VORNR"/>
                        </xsl:variable>
                        <routingOperationGroup>
                            <routingOperationGroup>
                                <xsl:value-of select="concat($orderNumber, '-0-', $groupOperation)"/>
                            </routingOperationGroup>
                            <operationNumber>
                                <xsl:value-of select="$groupOperation"/>
                            </operationNumber>
                            <description>
                                <xsl:value-of select="VORNR"/>
                            </description>
                            <routingStepIds>
                                <routingStepId>
                                    <xsl:value-of select="VORNR"/>
                                </routingStepId>
                            </routingStepIds>
                        </routingOperationGroup>
                    </xsl:for-each>
                </routingOperationGroups>
                <routingSteps>
                    <xsl:for-each select="E1OROPR[not(contains(STTXT, 'DLT'))]">
                        <xsl:variable name="currentPosition" select="position()"/>
                        <xsl:variable name="operation">
                            <xsl:value-of select="VORNR"/>
                        </xsl:variable>
                        <routingStep>
                            <stepId>
                                <xsl:value-of select="$operation"/>
                            </stepId>
                            <description>
                                <xsl:value-of select="LTXA1"/>
                            </description>
                            <workCenter>
                                <xsl:value-of select="ARBPL"/>
                            </workCenter>
                            <reportingStep>
                                <xsl:value-of select="$operation"/>
                            </reportingStep>
                            <erpSequence>0</erpSequence>
                            <xsl:if test="$currentPosition = 1">
                                <entry>true</entry>
                            </xsl:if>
                            <xsl:if test="$currentPosition = last()">
                                <lastReportingStep>true</lastReportingStep>
                            </xsl:if>
                            <controlKey>
                                <xsl:value-of select="STEUS"/>
                            </controlKey>
                            <nextStepIds>
                                <xsl:for-each select="../E1OROPR[not(contains(STTXT, 'DLT'))]">
                                    <xsl:if test="position() = $currentPosition + 1">
                                        <nextStepId>
                                            <xsl:value-of select="VORNR"/>
                                        </nextStepId>
                                    </xsl:if>
                                </xsl:for-each>
                            </nextStepIds>
                            <routingOperation>
                                <operationActivity>
                                    <operationActivity>
                                        <xsl:value-of select="concat($orderNumber, '-0-', $operation)"/>
                                    </operationActivity>
                                    <!-- <version/> -->
                                </operationActivity>
                                <baseQuantity/>
                                <baseQuantityUnit/>
                                <baseQuantityIsoUnit/>
                                <weighRelevant/>
                                <erpServiceActivityType>
                                    <xsl:value-of select="LARNT"/>
                                </erpServiceActivityType>
                                <serviceWork>
                                    <xsl:value-of select="ARBEI"/>
                                </serviceWork>
                                <serviceWorkUnit/>
                                <serviceWorkIsoUnit>
                                    <xsl:value-of select="ARBEH"/>
                                </serviceWorkIsoUnit>
                                <serviceDuration>
                                    <xsl:value-of select="DAUNO"/>
                                </serviceDuration>
                                <xsl:for-each
                                    select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ET_OPERATIONS/item[ACTIVITY=$operation]">
                                    <serviceDurationUnit>
                                        <xsl:value-of select="DURATION_NORMAL_UNIT"/>
                                    </serviceDurationUnit>
                                    <serviceDurationIsoUnit>
                                        <xsl:value-of select="DURATION_NORMAL_UNIT_ISO"/>
                                    </serviceDurationIsoUnit>
                                </xsl:for-each>
                                <numberOfServiceCapacities>
                                    <xsl:value-of select="ANZZL"/>
                                </numberOfServiceCapacities>
                                <customValues/>
                            </routingOperation>
                            <routingStepComponents>
                                <xsl:choose>
                                    <xsl:when test="//BAPI_ALM_ORDER_GET_DETAIL.Response/ET_COMPONENTS">
                                        <xsl:for-each
                                                select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ET_COMPONENTS/item">
                                            <xsl:if test="ACTIVITY = $operation">
                                                <routingStepComponent>
                                                    <material>
                                                        <xsl:call-template name="getMaterial">
                                                            <xsl:with-param name="material" select="MATERIAL"/>
                                                            <xsl:with-param name="materialExt" select="MATERIAL_EXTERNAL"/>
                                                            <xsl:with-param name="materialLong" select="MATERIAL_LONG"/>
                                                        </xsl:call-template>
                                                    </material>
                                                    <sequence>
                                                        <xsl:value-of select="position()"/>
                                                    </sequence>
                                                    <quantity>
                                                        <xsl:value-of select="REQUIREMENT_QUANTITY"/>
                                                    </quantity>
                                                    <toleranceUnder/>
                                                    <toleranceOver/>
                                                </routingStepComponent>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each
                                                select="//E1OROPR[not(contains(STTXT, 'DLT'))]/E1OROPR_MAT[(string(MATNR) or string(MATNR_EXTERNAL) or string(MATNR_LONG))]">
                                            <xsl:if test="../VORNR = $operation">
                                                <routingStepComponent>
                                                    <material>
                                                        <xsl:call-template name="getMaterial">
                                                            <xsl:with-param name="material" select="MATNR"/>
                                                            <xsl:with-param name="materialExt" select="MATNR_EXTERNAL"/>
                                                            <xsl:with-param name="materialLong" select="MATNR_LONG"/>
                                                        </xsl:call-template>
                                                    </material>
                                                    <sequence>
                                                        <xsl:value-of select="position()"/>
                                                    </sequence>
                                                    <quantity>
                                                        <xsl:value-of select="BDMNG"/>
                                                    </quantity>
                                                    <toleranceUnder/>
                                                    <toleranceOver/>
                                                </routingStepComponent>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </routingStepComponents>
                            <!-- <standardValueGroup/> -->
                        </routingStep>
                    </xsl:for-each>
                </routingSteps>
                <customValues/>
            </routing>
            <operationActivities>
                <xsl:for-each select="E1OROPR[not(contains(STTXT, 'DLT'))]">
                    <operationActivity>
                        <operationActivity>
                            <xsl:value-of select="concat($orderNumber, '-0-', VORNR)"/>
                        </operationActivity>
                        <!-- <resourceType/> -->
                        <!-- <resource/> -->
                        <!-- <requiredTimeInProcess/> -->
                        <customValues/>
                    </operationActivity>
                </xsl:for-each>
            </operationActivities>
            <schedules>
                <xsl:for-each select="E1OROPR[not(contains(STTXT, 'DLT'))]">
                    <xsl:call-template name="orderScheduleTemplate"/>
                </xsl:for-each>
            </schedules>
        </upsertOrderApiRequest>
    </xsl:template>

    <xsl:template name="orderScheduleTemplate">
        <xsl:variable name="operation">
            <xsl:value-of select="VORNR"/>
        </xsl:variable>
        <schedule>
            <routingStepId>
                <xsl:value-of select="VORNR"/>
            </routingStepId>
            <earliestSetupStartDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSAVD"/>
                    <xsl:with-param name="time" select="FSAVZ"/>
                </xsl:call-template>
            </earliestSetupStartDate>
            <earliestProcessingStartDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSAVD"/>
                    <xsl:with-param name="time" select="FSAVZ"/>
                </xsl:call-template>
            </earliestProcessingStartDate>
            <earliestTeardownStartDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSEDD"/>
                    <xsl:with-param name="time" select="FSEDZ"/>
                </xsl:call-template>
            </earliestTeardownStartDate>
            <earliestTeardownEndDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSEDD"/>
                    <xsl:with-param name="time" select="FSEDZ"/>
                </xsl:call-template>
            </earliestTeardownEndDate>
            <earliestWaitingEndDate/>
            <latestSetupStartDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSAVD"/>
                    <xsl:with-param name="time" select="FSAVZ"/>
                </xsl:call-template>
            </latestSetupStartDate>
            <latestProcessingStartDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSAVD"/>
                    <xsl:with-param name="time" select="FSAVZ"/>
                </xsl:call-template>
            </latestProcessingStartDate>
            <latestTeardownStartDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSEDD"/>
                    <xsl:with-param name="time" select="FSEDZ"/>
                </xsl:call-template>
            </latestTeardownStartDate>
            <latestTeardownEndDate>
                <xsl:call-template name="convertDatetime">
                    <xsl:with-param name="date" select="FSEDD"/>
                    <xsl:with-param name="time" select="FSEDZ"/>
                </xsl:call-template>
            </latestTeardownEndDate>
            <latestWaitingEndDate/>
            <!--<planSetupTime/>-->
            <!--<planTeardownTime/>-->
            <!--<setupTimeUnit/>-->
            <!--<setupTimeIsoUnit/>-->
            <xsl:choose>
                <xsl:when test="//BAPI_ALM_ORDER_GET_DETAIL.Response/ET_OPERATIONS/item">
                    <xsl:for-each
                            select="//BAPI_ALM_ORDER_GET_DETAIL.Response/ET_OPERATIONS/item[ACTIVITY = $operation]">
                        <planProcessingTime>
                            <xsl:value-of select="DURATION_NORMAL"/>
                        </planProcessingTime>
                        <processingTimeUnit>
                            <xsl:value-of select="DURATION_NORMAL_UNIT"/>
                        </processingTimeUnit>
                        <processingTimeIsoUnit>
                            <xsl:value-of select="DURATION_NORMAL_UNIT_ISO"/>
                        </processingTimeIsoUnit>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length(ARBEI) > 0 and number(ARBEI) != 0">
                        <!--planProcessingTime is mapped from 'Work involved in the activity'-->
                        <planProcessingTime>
                            <xsl:value-of select="ARBEI"/>
                        </planProcessingTime>
                    </xsl:if>
                    <processingTimeUnit/>
                    <!--The unit is mapped from 'Unit for work'-->
                    <processingTimeIsoUnit>
                        <xsl:value-of select="ARBEH"/>
                    </processingTimeIsoUnit>
                </xsl:otherwise>
            </xsl:choose>
            <!--<teardownTimeUnit/>-->
            <!--<teardownTimeIsoUnit/>-->
            <plannedQuantityInBaseUnit/>
            <minSendAheadQuantity/>
            <minSendAheadQuantityUnit/>
            <minSendAheadQuantityIsoUnit/>
            <minOverlapTime/>
            <minOverlapTimeUnit/>
            <minOverlapTimeIsoUnit/>
            <overlapping/>
        </schedule>
    </xsl:template>

    <!-- ERP time is in plant timezone. The API expects UTC timezone. It's converted via Plant Settings -->
    <xsl:template name="convertDatetime">
        <xsl:param name="date"/>
        <xsl:param name="time"/>
        <xsl:choose>
            <xsl:when test="not(string($date))">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:when test="string($time)">
                <xsl:value-of
                        select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T', substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2), '.000Z' )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                        select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00.000Z')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getMaterial">
        <xsl:param name="material"/>
        <xsl:param name="materialExt"/>
        <xsl:param name="materialLong"/>
        <xsl:variable name="materialString">
            <xsl:choose>
                <xsl:when test="$materialExt != ''">
                    <xsl:value-of select="normalize-space($materialExt)"/>
                </xsl:when>
                <xsl:when test="$materialLong != ''">
                    <xsl:value-of select="normalize-space($materialLong)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($material)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$materialString"/>
    </xsl:template>

    <xsl:template name="calculateDateTimeDuration">
        <xsl:param name="startDate" select="'00000000'"/>
        <xsl:param name="startTime" select="'000000'"/>

        <xsl:param name="endDate" select="'00000000'"/>
        <xsl:param name="endTime" select="'000000'"/>

        <xsl:value-of select="(xs:dateTime(concat(substring($endDate, 1, 4), '-', substring($endDate, 5, 2), '-', substring($endDate, 7, 2),
                    'T', substring($endTime, 1, 2), ':', substring($endTime, 3, 2), ':', substring($endTime, 5, 2))) - xs:dateTime(concat(substring($startDate, 1, 4), '-', substring($startDate, 5, 2), '-', substring($startDate, 7, 2),
                    'T', substring($startTime, 1, 2), ':', substring($startTime, 3, 2), ':', substring($startTime, 5, 2)))) div xs:dayTimeDuration('PT0.001S') div 1000 div 60"/>

    </xsl:template>

</xsl:stylesheet>