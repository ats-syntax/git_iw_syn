<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/Batch/BatchType">
        <rfc:BAPI_BATCH_GET_DETAIL xmlns:rfc="urn:sap-com:document:sap:rfc:functions">
            <BATCH>
                <xsl:value-of select="Batch"/>
            </BATCH>
            <xsl:choose>
                <xsl:when test="string-length(Material) &lt;= 18">
                    <MATERIAL>
                        <xsl:value-of select="substring(concat(Material, '                  '), 1, 18)"/>
                    </MATERIAL>
                </xsl:when>
                <xsl:otherwise>
                    <MATERIAL_LONG>
                        <xsl:value-of select="Material"/>
                    </MATERIAL_LONG>
                </xsl:otherwise>
            </xsl:choose>
            <MATERIAL_EVG>
                <MATERIAL_EXT/>
                <MATERIAL_VERS/>
                <MATERIAL_GUID/>
            </MATERIAL_EVG>
            <PLANT>
                <xsl:value-of select="substring(concat(BatchIdentifyingPlant, '    '), 1, 4)"/>
            </PLANT>
            <RETURN>
                <xsl:for-each select="/">
                    <item>
                        <TYPE/>
                        <ID/>
                        <NUMBER/>
                        <MESSAGE/>
                        <LOG_NO/>
                        <LOG_MSG_NO/>
                        <MESSAGE_V1/>
                        <MESSAGE_V2/>
                        <MESSAGE_V3/>
                        <MESSAGE_V4/>
                        <PARAMETER/>
                        <ROW/>
                        <FIELD/>
                        <SYSTEM/>
                    </item>
                </xsl:for-each>
            </RETURN>
        </rfc:BAPI_BATCH_GET_DETAIL>
    </xsl:template>
</xsl:stylesheet>