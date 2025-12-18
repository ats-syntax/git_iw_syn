<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/*">
        <xsl:variable name="site">
            <xsl:value-of select="sch:site"/>
        </xsl:variable>
        <xsl:variable name="orderId">
            <xsl:call-template name="setOrder">
                <xsl:with-param name="value" select="sch:orderNumber"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dateTime">
            <xsl:value-of select="sch:dateTime"/>
        </xsl:variable>
        <MB_MES_GOODSMVT_CREATE>
            <DETERMINE_RESERVATIONS>X</DETERMINE_RESERVATIONS>
            <GOODSMVT_CODE>
                <GM_CODE>03</GM_CODE>
            </GOODSMVT_CODE>
            <GOODSMVT_HEADER>
                <PSTNG_DATE>
                    <xsl:value-of select="concat(substring($dateTime, 1, 4), substring($dateTime, 6, 2), substring($dateTime, 9, 2))"/>
                </PSTNG_DATE>
                <DOC_DATE>
                    <xsl:value-of select="concat(substring($dateTime, 1, 4), substring($dateTime, 6, 2), substring($dateTime, 9, 2))"/>
                </DOC_DATE>
            </GOODSMVT_HEADER>
            <GOODSMVT_ITEM>
                <xsl:for-each select="sch:erpComponentArray/sch:erpComponent">
                    <item>
                        <xsl:call-template name="setMaterial">
                            <xsl:with-param name="value" select="sch:item/sch:item"/>
                        </xsl:call-template>
                        <PLANT>
                            <xsl:value-of select="$site"/>
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
                        <xsl:if test="string(sch:rsNum)">
                            <RESERV_NO>
                                <xsl:value-of select="sch:rsNum"/>
                            </RESERV_NO>
                        </xsl:if>
                        <xsl:if test="string(sch:rsPos)">
                            <RES_ITEM>
                                <xsl:value-of select="sch:rsPos"/>
                            </RES_ITEM>
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
                    </item>
                </xsl:for-each>
            </GOODSMVT_ITEM>
            <GOODSMVT_SERIALNUMBER>
                <xsl:for-each select="sch:erpComponentArray/sch:erpComponent">
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
                </xsl:for-each>
            </GOODSMVT_SERIALNUMBER>
        </MB_MES_GOODSMVT_CREATE>
    </xsl:template>
    <xsl:template name="setOrder">
        <xsl:param name="value"/>
        <xsl:value-of select ="format-number(number($value), '000000000000')"/>
    </xsl:template>
    <xsl:template name="setMaterial">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="string-length($value) > 18">
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
    </xsl:template>
</xsl:stylesheet>