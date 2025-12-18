<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <BAPI_CATIMESHEETMGR_DELETE>
            <CATSRECORDS>
                <item>
                    <COUNTER>
                        <xsl:value-of select="format-number(number(sch:confirmationCounter), '000000000000')" />
                    </COUNTER>
                </item>
            </CATSRECORDS>
        </BAPI_CATIMESHEETMGR_DELETE>
    </xsl:template>
</xsl:stylesheet>