<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/*">
        <urn:BAPI_GOODSMVT_CANCEL xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <MATERIALDOCUMENT>
                <xsl:value-of select="sch:materialDocument"/>
            </MATERIALDOCUMENT>
            <MATDOCUMENTYEAR>
                <xsl:value-of select="sch:materialDocumentYear"/>
            </MATDOCUMENTYEAR>
        </urn:BAPI_GOODSMVT_CANCEL>
    </xsl:template>
</xsl:stylesheet>