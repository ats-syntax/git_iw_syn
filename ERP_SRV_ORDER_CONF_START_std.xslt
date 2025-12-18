<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <BAPI_ALM_CONF_CREATE>
            <TIMETICKETS>
                <item>
                    <ORDERID>
                        <xsl:value-of select="format-number(number(sch:order), '000000000000')" />
                    </ORDERID>
                    <OPERATION>
                        <xsl:value-of select="sch:reportingStep"/>
                    </OPERATION>
                    <POSTG_DATE>
                        <xsl:call-template name="convertODataDateFormat">
                            <xsl:with-param name="date"  select="sch:postingDate"/>
                        </xsl:call-template>
                    </POSTG_DATE>
                    <PLANT>
                        <xsl:value-of select="sch:plant" />
                    </PLANT>
                    <WORK_CNTR>
                        <xsl:value-of select="sch:workCenter"/>
                    </WORK_CNTR>
                    <EX_CREATED_BY>
                        <xsl:value-of select="sch:postedBy" />
                    </EX_CREATED_BY>
                </item>
            </TIMETICKETS>
        </BAPI_ALM_CONF_CREATE>
    </xsl:template>
    <xsl:template name="convertODataDateFormat">
        <xsl:param name="date"/> <!-- 2024-10-17T00:00:00 -->
        <xsl:if test="$date!=''">
            <xsl:value-of select="substring($date, 1, 10)"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>