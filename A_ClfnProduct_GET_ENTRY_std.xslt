<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/A_ClfnProduct/A_ClfnProductType">
        <urn:BAPI_OBJCL_GETCLASSES xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <xsl:choose>
                <xsl:when test="string-length(Product) &lt;= 18">
                    <OBJECTKEY_IMP>
                        <xsl:value-of select="Product"/>
                    </OBJECTKEY_IMP>
                </xsl:when>
                <xsl:otherwise>
                    <OBJECTKEY_IMP_LONG>
                        <xsl:value-of select="Product"/>
                    </OBJECTKEY_IMP_LONG>
                </xsl:otherwise>
            </xsl:choose>
            <OBJECTTABLE_IMP>MARA</OBJECTTABLE_IMP>
        </urn:BAPI_OBJCL_GETCLASSES>
    </xsl:template>
</xsl:stylesheet>