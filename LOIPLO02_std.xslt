<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/LOIPLO02/IDOC">
        <repetitiveOrder>
            <SenderBusinessSystemID>
                <xsl:value-of select="//IDOC/EDI_DC40/SNDPRN"/>
            </SenderBusinessSystemID>

            <!-- order header -->
            <xsl:apply-templates select="E1PLAFL"/>
        </repetitiveOrder>
    </xsl:template>

    <xsl:template match="/LOIPLO02/IDOC/E1PLAFL">
        <orderNumber>
            <xsl:call-template name="addOrder">
                <xsl:with-param name="order" select="PLNUM"/>
            </xsl:call-template>
        </orderNumber>
        <orderType>
            <xsl:value-of select="PAART"/>
        </orderType>
        <productionPlant>
            <xsl:value-of select="PLWRK"/>
        </productionPlant>
        <material>
            <xsl:call-template name="addMaterial">
                <xsl:with-param name="material" select="MATNR"/>
                <xsl:with-param name="materialExt" select="MATNR_EXTERNAL"/>
                <xsl:with-param name="materialLong" select="MATNR_LONG"/>
            </xsl:call-template>
        </material>
        <billOfMaterialCategory/>
        <billOfMaterial>
            <xsl:value-of select="STLNR"/>
        </billOfMaterial>
        <alternativeBillOfMaterial>
            <xsl:value-of select="STALT"/>
        </alternativeBillOfMaterial>
        <billOfMaterialVariant>
            <xsl:value-of select="STALT"/>
        </billOfMaterialVariant>
        <billOfMaterialVariantUsage>
            <xsl:value-of select="STLAN"/>
        </billOfMaterialVariantUsage>
        <billOfOperationsType>
            <xsl:value-of select="PLNTY"/>
        </billOfOperationsType>
        <billOfOperationsGroup>
            <xsl:value-of select="PLNNR"/>
        </billOfOperationsGroup>
        <billOfOperationsVariant>
            <xsl:value-of select="PLNAL"/>
        </billOfOperationsVariant>
        <totalPlannedQuantityInBaseUnit>
            <value>
                <xsl:value-of select="GSMNG"/>
            </value>
            <isoUnitCode>
                <xsl:value-of select="MEINS"/>
            </isoUnitCode>
        </totalPlannedQuantityInBaseUnit>
        <totalConfirmedQuantityInBaseUnit>
            <value>
                <xsl:value-of select="CNFQTY"/>
            </value>
            <isoUnitCode>
                <xsl:value-of select="MEINS"/>
            </isoUnitCode>
        </totalConfirmedQuantityInBaseUnit>
        <scheduledStartDate>
            <xsl:call-template name="convertIDocDate">
                <xsl:with-param name="date" select="GSTRS"/>
                <xsl:with-param name="time" select="GSUZS"/>
            </xsl:call-template>
        </scheduledStartDate>
        <scheduledCompletionDate>
            <xsl:call-template name="convertIDocDate">
                <xsl:with-param name="date" select="GLTRS"/>
                <xsl:with-param name="time" select="GLUZS"/>
            </xsl:call-template>
        </scheduledCompletionDate>
        <plannedStartDate>
            <xsl:call-template name="convertIDocDate">
                <xsl:with-param name="date" select="PSTTR"/>
                <xsl:with-param name="time" select="'000000'"/>
            </xsl:call-template>
        </plannedStartDate>
        <plannedCompletionDate>
            <xsl:call-template name="convertIDocDate">
                <xsl:with-param name="date" select="PEDTR"/>
                <xsl:with-param name="time" select="'235959'"/>
            </xsl:call-template>
        </plannedCompletionDate>
        <priority>500</priority>
        <erpPutawayStorageLocation>
            <xsl:value-of select="LGORT"/>
        </erpPutawayStorageLocation>
        <batchNumber/>
        <productionVersion>
            <xsl:value-of select="VERID"/>
        </productionVersion>
        <salesOrder>
            <xsl:value-of select="KDAUF"/>
        </salesOrder>
        <salesOrderItem>
            <xsl:value-of select="KDPOS"/>
        </salesOrderItem>
        <orderSteps>
            <xsl:for-each select="E1PLOPL[FLGAT='0']">
                <xsl:sort select="VORNR"/>
                <orderStep>
                    <stepId>
                        <xsl:value-of select="VORNR"/>
                    </stepId>
                    <erpStepType>Operation</erpStepType>
                    <operationText>
                        <xsl:value-of select="LTXA1"/>
                    </operationText>
                    <sequence>
                        <xsl:value-of select="PLNFL"/>
                    </sequence>
                    <erpWorkCenterId>
                        <xsl:value-of select="ARBID"/>
                    </erpWorkCenterId>

                    <earliestExecutionStartDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="FSAVD"/>
                            <xsl:with-param name="time" select="FSAVZ"/>
                        </xsl:call-template>
                    </earliestExecutionStartDate>

                    <!--
                    Sample code to calculate start date if field in IDoc is empty
                    Sample logic: execution start = processing start - standard value 02
                    -->
                    <!--
                    <earliestExecutionStartDate>
                        <xsl:call-template name="dateTimeReduceDuration">
                            <xsl:with-param name="date" select="FSSBD"/>
                            <xsl:with-param name="time" select="FSSBZ"/>
                            <xsl:with-param name="num" select="VGW02"/>
                            <xsl:with-param name="unit" select="VGE02"/>
                        </xsl:call-template>
                    </earliestExecutionStartDate>
                    -->

                    <earliestProcessingStartDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="FSSBD"/>
                            <xsl:with-param name="time" select="FSSBZ"/>
                        </xsl:call-template>
                    </earliestProcessingStartDate>
                    <earliestTeardownStartDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="FSSAD"/>
                            <xsl:with-param name="time" select="FSSAZ"/>
                        </xsl:call-template>
                    </earliestTeardownStartDate>
                    <earliestExecutionEndDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="FSEDD"/>
                            <xsl:with-param name="time" select="FSEDZ"/>
                        </xsl:call-template>
                    </earliestExecutionEndDate>
                    <latestExecutionStartDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="SSAVD"/>
                            <xsl:with-param name="time" select="SSAVZ"/>
                        </xsl:call-template>
                    </latestExecutionStartDate>
                    <latestProcessingStartDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="SSSBD"/>
                            <xsl:with-param name="time" select="SSSBZ"/>
                        </xsl:call-template>
                    </latestProcessingStartDate>
                    <latestTeardownStartDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="SSSAD"/>
                            <xsl:with-param name="time" select="SSSAZ"/>
                        </xsl:call-template>
                    </latestTeardownStartDate>
                    <latestExecutionEndDate>
                        <xsl:call-template name="convertIDocDate">
                            <xsl:with-param name="date" select="SSEDD"/>
                            <xsl:with-param name="time" select="SSEDZ"/>
                        </xsl:call-template>
                    </latestExecutionEndDate>

                    <!--
                    Sample code to calculate planned setup duration
                    Sample logic: planned setup duration = standard value 02
                    -->
                    <!--
                    <plannedSetupDuration>
                        <value>
                            <xsl:value-of select="VGW02"/>
                        </value>
                        <isoUnitCode>
                            <xsl:value-of select="VGE02"/>
                        </isoUnitCode>
                    </plannedSetupDuration>
                    -->

                    <!--
                    Sample code to calculate planned processing duration
                    Sample logic: planned processing duration = teardown start - processing start
                    -->
                    <!--
                    <plannedProcessingDuration>
                        <value>
                            <xsl:call-template name="calculateDateTimeDuration">
                                <xsl:with-param name="date2" select="FSSBD"/>
                                <xsl:with-param name="time2" select="FSSBZ"/>
                                <xsl:with-param name="date1" select="FSSAD"/>
                                <xsl:with-param name="time1" select="FSSAZ"/>
                            </xsl:call-template>
                        </value>
                        <isoUnitCode>MIN</isoUnitCode>
                    </plannedProcessingDuration>
                    -->

                    <orderComponents>
                        <xsl:for-each select="E1RESBAS">
                            <xsl:variable name="targetReservation" select="RSNUM"/>
                            <xsl:variable name="targetReservationItem" select="RSPOS"/>
                            <xsl:for-each
                                    select="//IDOC/E1PLAFL/E1RESBL[RSNUM=$targetReservation and RSPOS=$targetReservationItem]">
                                <orderComponent>
                                    <requirementType>
                                        <xsl:value-of select="BDART"/>
                                    </requirementType>
                                    <orderItem>
                                        <xsl:value-of select="AFPOS"/>
                                    </orderItem>
                                    <billOfMaterial>
                                        <xsl:value-of select="STLNR"/>
                                    </billOfMaterial>
                                    <billOfMaterialItemCategory>
                                        <xsl:value-of select="POSTP"/>
                                    </billOfMaterialItemCategory>
                                    <billOfMaterialItemNumber>
                                        <xsl:value-of select="POSNR"/>
                                    </billOfMaterialItemNumber>
                                    <billOfMaterialItemNodeNumber>
                                        <xsl:value-of select="STLKN"/>
                                    </billOfMaterialItemNodeNumber>
                                    <supplyArea>
                                        <xsl:value-of select="PRVBE"/>
                                    </supplyArea>
                                    <requiredQuantityInBaseUnit>
                                        <value>
                                            <xsl:value-of select="BDMNG"/>
                                        </value>
                                        <isoUnitCode>
                                            <xsl:value-of select="MEINS"/>
                                        </isoUnitCode>
                                    </requiredQuantityInBaseUnit>
                                    <reservation>
                                        <xsl:value-of select="RSNUM"/>
                                    </reservation>
                                    <reservationItem>
                                        <xsl:value-of select="RSPOS"/>
                                    </reservationItem>
                                    <warehouseNumber>
                                        <xsl:value-of select="LGNUM"/>
                                    </warehouseNumber>
                                    <alternativeItemGroup>
                                        <xsl:value-of select="ALPGR"/>
                                    </alternativeItemGroup>
                                    <alternativeItemPriority>
                                        <xsl:value-of select="ALPRF"/>
                                    </alternativeItemPriority>
                                    <alternativeItemStrategy>
                                        <xsl:value-of select="ALPST"/>
                                    </alternativeItemStrategy>
                                    <material>
                                        <xsl:call-template name="addMaterial">
                                            <xsl:with-param name="material" select="MATNR"/>
                                            <xsl:with-param name="materialExt" select="MATNR_EXTERNAL"/>
                                            <xsl:with-param name="materialLong" select="MATNR_LONG"/>
                                        </xsl:call-template>
                                    </material>
                                    <batch>
                                        <xsl:value-of select="CHARG"/>
                                    </batch>
                                    <goodsMovementType>
                                        <xsl:value-of select="BWART"/>
                                    </goodsMovementType>
                                    <materialCompIsAlternativeItem>
                                        <xsl:call-template name="convertToBool">
                                            <xsl:with-param name="bool" select="ALPOS"/>
                                        </xsl:call-template>
                                    </materialCompIsAlternativeItem>
                                    <materialCompIsMarkedForBackflush>
                                        <xsl:call-template name="convertToBool">
                                            <xsl:with-param name="bool" select="BACKFLUSH"/>
                                        </xsl:call-template>
                                    </materialCompIsMarkedForBackflush>
                                    <materialIsCoProduct>
                                        <xsl:call-template name="convertToBool">
                                            <xsl:with-param name="bool" select="KZKUP"/>
                                        </xsl:call-template>
                                    </materialIsCoProduct>
                                    <storageLocation>
                                        <xsl:value-of select="LGORT"/>
                                    </storageLocation>
                                    <debitCreditCode>
                                        <xsl:value-of select="SHKZG"/>
                                    </debitCreditCode>
                                </orderComponent>
                            </xsl:for-each>
                        </xsl:for-each>
                    </orderComponents>

                    <!-- Sample to customizing resource type -->
                    <!--
                    <resourceType>CUST_RES_TYPE</resourceType>
                    -->
                </orderStep>
            </xsl:for-each>
        </orderSteps>

        <orderStepRelationships>
            <xsl:for-each select="E1PLOPL[FLGAT='0']">
                <xsl:sort select="VORNR"/>
                <xsl:if test="position() > 1">
                    <orderStepRelationship>
                        <predecessorStepId>
                            <xsl:value-of select="preceding-sibling::E1PLOPL/VORNR"/>
                        </predecessorStepId>
                        <predecessorStepType>Operation</predecessorStepType>
                        <successorStepId>
                            <xsl:value-of select="VORNR"/>
                        </successorStepId>
                        <successorStepType>Operation</successorStepType>
                        <relationType>SucRel</relationType>
                    </orderStepRelationship>
                </xsl:if>
            </xsl:for-each>
        </orderStepRelationships>
    </xsl:template>

    <xsl:template name="addOrder">
        <xsl:param name="order"/>
        <xsl:variable name="orderString" select="normalize-space($order)"/>
        <xsl:variable name="orderNumber" select="format-number(number($orderString), '#')"/>
        <xsl:choose>
            <xsl:when test="$orderNumber='NaN'">
                <xsl:value-of select="$orderString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$orderNumber"/>
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

    <xsl:template name="convertIDocDate">
        <xsl:param name="date" select="'00000000'"/>
        <xsl:param name="time" select="'000000'"/>
        <xsl:choose>
            <xsl:when test="$date = '00000000'">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2),
                'T', substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="dateTimeReduceDuration">
        <xsl:param name="date" select="'00000000'"/>
        <xsl:param name="time" select="'000000'"/>

        <xsl:param name="num" select="'00000000'"/>
        <xsl:param name="unit" select="'000000'"/>
        <xsl:choose>
            <xsl:when test="$date = '00000000'">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$unit = 'MIN'">
                    <xsl:value-of select="xs:dateTime(concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2),
                    'T', substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2))) - xs:dayTimeDuration(concat('P0DT0H',format-number($num,'0000'),'M'))"/>
                </xsl:if>
                <xsl:if test="$unit = 'HUR'">
                    <xsl:value-of select="xs:dateTime(concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2),
                    'T', substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2))) - xs:dayTimeDuration(concat('P0DT',format-number($num,'0000'),'H0M'))"/>
                </xsl:if>
                <xsl:if test="$unit = 'DAY'">
                    <xsl:value-of select="xs:dateTime(concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2),
                    'T', substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2))) - xs:dayTimeDuration(concat('P',format-number($num,'0000'),'DT0H0M'))"/>
                </xsl:if>
                <xsl:if test="$unit = 'SEC'">
                    <xsl:value-of select="xs:dateTime(concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2),
                    'T', substring($time, 1, 2), ':', substring($time, 3, 2), ':', substring($time, 5, 2))) - xs:dayTimeDuration(concat('P0DT0H0M',format-number($num,'0000'),'S'))"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="calculateDateTimeDuration">
        <xsl:param name="date1" select="'00000000'"/>
        <xsl:param name="time1" select="'000000'"/>

        <xsl:param name="date2" select="'00000000'"/>
        <xsl:param name="time2" select="'000000'"/>

        <xsl:value-of select="(xs:dateTime(concat(substring($date1, 1, 4), '-', substring($date1, 5, 2), '-', substring($date1, 7, 2),
                    'T', substring($time1, 1, 2), ':', substring($time1, 3, 2), ':', substring($time1, 5, 2))) - xs:dateTime(concat(substring($date2, 1, 4), '-', substring($date2, 5, 2), '-', substring($date2, 7, 2),
                    'T', substring($time2, 1, 2), ':', substring($time2, 3, 2), ':', substring($time2, 5, 2)))) div xs:dayTimeDuration('PT0.001S') div 1000 div 60"/>

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