<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <BAPI_ALM_CONF_CREATE>
            <TIMETICKETS>
                <item>
                    <PLANT>
                        <xsl:value-of select="sch:plant" />
                    </PLANT>
                    <POSTG_DATE>
                        <xsl:value-of select="sch:approvedAt"/>
                    </POSTG_DATE>
                    <OPERATION>
                        <xsl:value-of select="sch:operation" />
                    </OPERATION>
                    <ORDERID>
                        <xsl:value-of select="format-number(number(sch:order), '000000000000')" />
                    </ORDERID>
                    <ACT_WORK>
                        <xsl:value-of select="sch:duration" />
                    </ACT_WORK>
                    <UN_WORK>
                        <xsl:choose>
                            <xsl:when test="normalize-space(sch:uom) != ''">
                                <xsl:value-of select="sch:uom"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>S</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </UN_WORK>
                    <!-- <ACT_TYPE>
                        <xsl:value-of select="sch:timeRecordActivity" />
                    </ACT_TYPE> -->
                    <PERS_NO>
                        <xsl:value-of select="sch:erpPersonnelNumber" />
                    </PERS_NO>
                </item>
            </TIMETICKETS>
        </BAPI_ALM_CONF_CREATE>
    </xsl:template>
</xsl:stylesheet>