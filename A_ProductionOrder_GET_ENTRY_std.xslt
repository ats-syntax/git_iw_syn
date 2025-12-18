<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/A_ProductionOrder/A_ProductionOrder_2Type">
        <urn:BAPI_PRODORD_GET_DETAIL xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <!--You may enter the following 10 items in any order-->
            <!--Optional:-->
            <COLLECTIVE_ORDER/>
            <NUMBER>
                <xsl:call-template name="getOrder">
                    <xsl:with-param name="original" select="ManufacturingOrder"/>
                </xsl:call-template>
            </NUMBER>
            <ORDER_OBJECTS>
                <!--Optional:-->
                <HEADER>X</HEADER>
                <!--Optional:-->
                <POSITIONS/>
                <!--Optional:-->
                <SEQUENCES/>
                <!--Optional:-->
                <OPERATIONS>X</OPERATIONS>
                <!--Optional:-->
                <COMPONENTS/>
                <!--Optional:-->
                <PROD_REL_TOOLS>X</PROD_REL_TOOLS>
                <!--Optional:-->
                <TRIGGER_POINTS/>
                <!--Optional:-->
                <SUBOPERATIONS/>
            </ORDER_OBJECTS>
        </urn:BAPI_PRODORD_GET_DETAIL>
    </xsl:template>
    <xsl:template name="getOrder">
        <xsl:param name="original"/>
        <xsl:choose>
            <xsl:when test="number($original)">
                <xsl:value-of select="format-number(number($original), '000000000000')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$original"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>