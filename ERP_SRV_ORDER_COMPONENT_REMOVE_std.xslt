<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon"
    xmlns:urn="urn:sap-com:document:sap:rfc:functions">
    <xsl:template match="/*">
        <BAPI_GOODSMVT_CREATE>
            <GOODSMVT_CODE>
                <GM_CODE>
                    <xsl:value-of select="sch:goodsMovementCode"/>
                </GM_CODE>
            </GOODSMVT_CODE>
            <GOODSMVT_HEADER>
                <PSTNG_DATE>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="sch:postingDate"/>
                    </xsl:call-template>
                </PSTNG_DATE>
            </GOODSMVT_HEADER>
            <GOODSMVT_ITEM>
                <xsl:for-each select="sch:toMaterialDocumentItem">
                    <item>
                        <xsl:choose>
                            <xsl:when test="string-length(sch:material) &lt;= 18">
                                <MATERIAL>
                                    <xsl:value-of select="sch:material"/>
                                </MATERIAL>
                            </xsl:when>
                            <xsl:otherwise>
                                <MATERIAL_LONG>
                                    <xsl:value-of select="sch:material"/>
                                </MATERIAL_LONG>
                            </xsl:otherwise>
                        </xsl:choose>
                        <PLANT>
                            <xsl:value-of select="sch:plant"/>
                        </PLANT>
                        <ORDERID>
                            <xsl:call-template name="setOrder">
                                <xsl:with-param name="value" select="sch:manufacturingOrder"/>
                            </xsl:call-template>
                        </ORDERID>
                        <STGE_LOC>
                            <xsl:value-of select="sch:storageLocation"/>
                        </STGE_LOC>
                        <MOVE_TYPE>
                            <xsl:value-of select="sch:goodsMovementType"/>
                        </MOVE_TYPE>
                        <ENTRY_UOM>
                            <xsl:value-of select="sch:entryUnit"/>
                        </ENTRY_UOM>
                        <ENTRY_QNT>
                            <xsl:value-of select="sch:quantityInEntryUnit"/>
                        </ENTRY_QNT>
                        <BATCH>
                            <xsl:value-of select="sch:batch"/>
                        </BATCH>
                        <RESERV_NO>
                            <xsl:value-of select="sch:reservation"/>
                        </RESERV_NO>
                        <RES_ITEM>
                            <xsl:value-of select="sch:reservationItem"/>
                        </RES_ITEM>
                    </item>
                </xsl:for-each>
            </GOODSMVT_ITEM>
        </BAPI_GOODSMVT_CREATE>
    </xsl:template>
    <xsl:template name="convertODataDateFormat">
        <xsl:param name="date"/>
        <!-- 2024-10-17T00:00:00 -->
        <xsl:if test="$date!=''">
            <xsl:value-of select="substring($date, 1, 10)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="setOrder">
        <xsl:param name="value"/>
        <xsl:value-of select ="format-number(number($value), '000000000000')"/>
    </xsl:template>
</xsl:stylesheet>