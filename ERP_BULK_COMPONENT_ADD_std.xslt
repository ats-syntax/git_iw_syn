<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/*">
        <xsl:variable name="plant">
            <xsl:value-of select="sch:plant"/>
        </xsl:variable>
        <xsl:variable name="orderId">
            <xsl:call-template name="setOrder">
                <xsl:with-param name="value" select="sch:orderNumber"/>
            </xsl:call-template>
        </xsl:variable>
        <MB_MES_GOODSMVT_CREATE>
            <DETERMINE_RESERVATIONS>X</DETERMINE_RESERVATIONS>
            <GOODSMVT_CODE>
                <GM_CODE>03</GM_CODE>
            </GOODSMVT_CODE>
            <GOODSMVT_HEADER>
                <PSTNG_DATE>
                    <xsl:value-of
                            select="concat(substring(sch:dateTime, 1, 4), substring(sch:dateTime, 6, 2), substring(sch:dateTime, 9, 2))"/>
                </PSTNG_DATE>
                <DOC_DATE>
                    <xsl:value-of
                            select="concat(substring(sch:dateTime, 1, 4), substring(sch:dateTime, 6, 2), substring(sch:dateTime, 9, 2))"/>
                </DOC_DATE>
            </GOODSMVT_HEADER>
            <GOODSMVT_ITEM>
                <xsl:for-each select="sch:erpComponents/sch:erpComponent">
                    <xsl:if test="string(sch:ewmManagedComponent) = '' or sch:ewmManagedComponent != 'true'">
                        <item>
                            <xsl:call-template name="setMaterial">
                                <xsl:with-param name="value" select="sch:material/sch:material"/>
                            </xsl:call-template>
                            <PLANT>
                                <xsl:value-of select="$plant"/>
                            </PLANT>
                            <STGE_LOC>
                                <xsl:value-of select="sch:storageLocation"/>
                            </STGE_LOC>
                            <BATCH>
                                <xsl:value-of select="sch:batchNumber"/>
                            </BATCH>
                            <ENTRY_QNT>
                                <xsl:value-of select="sch:quantity"/>
                            </ENTRY_QNT>
                            <ENTRY_UOM>
                                <xsl:value-of select="sch:unitOfMeasure"/>
                            </ENTRY_UOM>
                            <ORDERID>
                                <xsl:value-of select="$orderId"/>
                            </ORDERID>
                            <MOVE_TYPE>261</MOVE_TYPE>
                            <RESERV_NO>
                                <xsl:value-of select="sch:reservationOrderNumber"/>
                            </RESERV_NO>
                            <RES_ITEM>
                                <xsl:value-of select="sch:reservationItemNumber"/>
                            </RES_ITEM>
                            <xsl:if test="string(sch:reportingStep)">
                                <ACTIVITY>
                                    <xsl:value-of select="sch:reportingStep"/>
                                </ACTIVITY>
                            </xsl:if>
                            <xsl:if test="string(sch:salesOrder)">
                                <SALES_ORD>
                                    <xsl:value-of select="sch:salesOrder"/>
                                </SALES_ORD>
                                <SPEC_STOCK>E</SPEC_STOCK>
                            </xsl:if>
                            <xsl:if test="string(sch:salesOrderItem)">
                                <S_ORD_ITEM>
                                    <xsl:value-of select="sch:salesOrderItem"/>
                                </S_ORD_ITEM>
                            </xsl:if>
                            <!-- Sample for <dataFields>, <CUSTOM_FIELD>
                                <xsl:if test="sch:dataFields">
                                    <xsl:for-each select="sch:dataFields/entry">
                                        <xsl:if test="string(key) = 'CUSTOM_FIELD'">
                                            <CUSTOM_FIELD>
                                                <xsl:value-of select="value"/>
                                            </CUSTOM_FIELD>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                             -->
                        </item>
                    </xsl:if>
                </xsl:for-each>
            </GOODSMVT_ITEM>
            <GOODSMVT_SERIALNUMBER>
                <xsl:for-each select="sch:erpComponents/sch:erpComponent">
                    <xsl:if test="string(sch:ewmManagedComponent) = '' or sch:ewmManagedComponent != 'true'">
                        <xsl:variable name="COMPONENT_INDEX" select="position()"/>
                        <xsl:if test="string(sch:erpSerialNumber)">
                            <xsl:for-each select="sch:erpSerialNumber">
                                <item>
                                    <MATDOC_ITM>
                                        <xsl:value-of select="$COMPONENT_INDEX"/>
                                    </MATDOC_ITM>
                                    <SERIALNO>
                                        <xsl:value-of select="."/>
                                    </SERIALNO>
                                    <UII/>
                                </item>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </GOODSMVT_SERIALNUMBER>
        </MB_MES_GOODSMVT_CREATE>
    </xsl:template>
    <xsl:template name="setOrder">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="string($value) and not('---'=$value)">
                <xsl:variable name="shopOrderString" select="normalize-space($value)"/>
                <xsl:variable name="shopOrderNumber" select="string(number($shopOrderString))"/>
                <xsl:choose>
                    <xsl:when test="$shopOrderNumber='NaN'">
                        <xsl:value-of select="$shopOrderString"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="POValueLong" select="concat('000000000000', $value)"/>
                        <xsl:value-of select="substring($POValueLong, (string-length($POValueLong)-11), 12)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="setMaterial">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="//SupportedPlant/ErpServerMode='EXT_MAT_NUM_ON'">
                <MATERIAL_LONG>
                    <xsl:value-of select="$value"/>
                </MATERIAL_LONG>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string-length($value)>18">
                        <MATERIAL_LONG>
                            <xsl:value-of select="$value"/>
                        </MATERIAL_LONG>
                    </xsl:when>
                    <xsl:otherwise>
                        <MATERIAL>
                            <xsl:value-of select="$value"/>
                        </MATERIAL>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
