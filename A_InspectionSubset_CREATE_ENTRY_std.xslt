<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/A_InspectionSubset/A_InspectionSubsetType">
        <urn:BAPI_INSPPOINT_CREATEFROMDATA xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <DATA>
                <INSPLOT>
                    <xsl:value-of select="InspectionLot"/>
                </INSPLOT>
                <INSPOPER>
                    <xsl:value-of select="InspPlanOperationInternalID"/>
                </INSPOPER>
                <INSPPOINT>
                    <xsl:value-of select="InspectionSubsetInternalID"/>
                </INSPPOINT>
                <PART_LOT>
                    <xsl:value-of select="InspectionPartialLot"/>
                </PART_LOT>
                <QUANTITY>
                    <xsl:value-of select="InspectionSubsetYieldQty"/>
                </QUANTITY>
                <UNIT>
                    <xsl:value-of select="InspectionSubsetQtyUnit"/>
                </UNIT>
                <UNITC/>
                <UNITT/>
                <EQUIPMENT>
                    <xsl:value-of select="Equipment"/>
                </EQUIPMENT>
                <FUNCT_LOC>
                    <xsl:value-of select="FunctionalLocation"/>
                </FUNCT_LOC>
                <PHYS_SMPL/>
                <USERC1>
                    <xsl:value-of select="InspectionSubsetLongCharKey"/>
                </USERC1>
                <USERC2>
                    <xsl:value-of select="InspectionSubsetShortCharKey"/>
                </USERC2>
                <USERN1>
                    <xsl:value-of select="InspSubsetLongNumericKey"/>
                </USERN1>
                <USERN2>
                    <xsl:value-of select="InspSubsetShortNumericKey"/>
                </USERN2>
                <USERD1>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="InspectionSubsetDate"/>
                    </xsl:call-template>
                </USERD1>
                <USERT1>
                    <xsl:call-template name="convertODataTimeFormat">
                        <xsl:with-param name="time" select="InspectionSubsetTime"/>
                    </xsl:call-template>
                </USERT1>
                <CAT_TYPE/>
                <PSEL_SET>
                    <xsl:value-of select="SelectedCodeSetPlant"/>
                </PSEL_SET>
                <SEL_SET>
                    <xsl:value-of select="SelectedCodeSet"/>
                </SEL_SET>
                <CODE_GRP>
                    <xsl:value-of select="InspSubsetUsageDcsnCodeGroup"/>
                </CODE_GRP>
                <CODE>
                    <xsl:value-of select="InspSubsetUsageDcsnCode"/>
                </CODE>
                <REMARK/>
                <xsl:choose>
                    <xsl:when test="string-length(MaterialSample) &lt;= 18">
                        <MATERIAL>
                            <xsl:value-of select="MaterialSample"/>
                        </MATERIAL>
                    </xsl:when>
                    <xsl:otherwise>
                        <MATERIAL_LONG>
                            <xsl:value-of select="MaterialSample"/>
                        </MATERIAL_LONG>
                    </xsl:otherwise>
                </xsl:choose>
                <BATCH/>
                <INSP_DATE>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="CreationDate"/>
                    </xsl:call-template>
                </INSP_DATE>
                <INSP_TIME>
                    <xsl:call-template name="convertODataTimeFormat">
                        <xsl:with-param name="time" select="CreationTime"/>
                    </xsl:call-template>
                </INSP_TIME>
                <INSPECTOR>
                    <xsl:value-of select="Inspector"/>
                </INSPECTOR>
                <SCRP_QUANT>
                    <xsl:value-of select="InspectionSubsetScrapQty"/>
                </SCRP_QUANT>
                <REWORK_QUANT>
                    <xsl:value-of select="InspectionSubsetReworkQty"/>
                </REWORK_QUANT>
                <SHOP_FLOOR_ITEM>
                    <xsl:value-of select="ShopFloorItem"/>
                </SHOP_FLOOR_ITEM>
            </DATA>
        </urn:BAPI_INSPPOINT_CREATEFROMDATA>
    </xsl:template>
    <xsl:template name="convertODataDateFormat">
        <xsl:param name="date"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:value-of select="substring($date, 1, 10)"/>
    </xsl:template>

    <xsl:template name="convertODataTimeFormat">
        <xsl:param name="time"/> <!-- 15:51:04 -->
        <xsl:choose>
            <xsl:when test="contains($time,'T')">
                <xsl:value-of select="substring($time,12,8)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$time"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>