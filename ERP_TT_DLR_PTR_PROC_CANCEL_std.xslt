<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <BAPI_PROCORDCONF_CANCEL>
            <CONFIRMATION>
                <xsl:value-of select="format-number(number(sch:confirmationNumber), '0000000000')" />
            </CONFIRMATION>
            <CONFIRMATIONCOUNTER>
                <xsl:value-of select="format-number(number(sch:confirmationCounter), '00000000')"/>
            </CONFIRMATIONCOUNTER>
            <POSTG_DATE>
                <xsl:call-template name="convertDateFormat">
                    <xsl:with-param name="date" select="sch:cancelledAt"/>
                </xsl:call-template>
            </POSTG_DATE>
        </BAPI_PROCORDCONF_CANCEL>
    </xsl:template>

    <xsl:template name="convertDateFormat">
        <xsl:param name="date"/> <!-- 2024-09-23T09:14:23.456Z -->
        <xsl:value-of select="substring($date, 1, 10)"/>
    </xsl:template>
</xsl:stylesheet>