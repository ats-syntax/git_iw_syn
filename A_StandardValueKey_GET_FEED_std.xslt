<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <urn:CO_MES_SVK_WITH_LANGUAGE xmlns:urn="urn:sap-com:document:sap:rfc:functions">
<!--            <IT_LANGUAGES>-->
<!--                <xsl:call-template name="splitLanguage">-->
<!--                    <xsl:with-param name="languageList" select="upper-case(//SAP_DMCSupportedLanguages)"/>-->
<!--                </xsl:call-template>-->
<!--            </IT_LANGUAGES>-->
            <IV_VALUE_KEY>
                <xsl:value-of select="//A_StandardValueKey/ValueKeyType/ValueKey"/>
            </IV_VALUE_KEY>
        </urn:CO_MES_SVK_WITH_LANGUAGE>
    </xsl:template>

    <xsl:template name="splitLanguage">
        <xsl:param name="languageList"/>

        <xsl:for-each select="tokenize(normalize-space($languageList), ',')">
            <item>
                <LANGU>
                    <xsl:value-of select="."/>
                </LANGU>
            </item>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>