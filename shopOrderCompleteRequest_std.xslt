<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/*">
        <xsl:variable name="site">
            <xsl:call-template name="setValue">
                <xsl:with-param name="value" select="sch:site" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="orderId">
            <xsl:call-template name="setOrder">
                <xsl:with-param name="value" select="sch:orderNumber" />
            </xsl:call-template>
        </xsl:variable>
        <BAPI_PRODORDCONF_CREATE_TT>
            <TIMETICKETS>
                <xsl:for-each select="sch:operationList/sch:operation">
                    <xsl:sort select="."/>
                    <item>
                        <PLANT>
                            <xsl:value-of select="$site" />
                        </PLANT>
                        <ORDERID>
                            <xsl:value-of select="$orderId" />
                        </ORDERID>
                        <OPERATION>
                            <xsl:call-template name="setValue">
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </OPERATION>
                        <YIELD>0</YIELD>
                        <FIN_CONF>X</FIN_CONF>
                        <CLEAR_RES>X</CLEAR_RES>
                    </item>
                </xsl:for-each>
            </TIMETICKETS>
        </BAPI_PRODORDCONF_CREATE_TT>
    </xsl:template>
    <xsl:template name="setValue">
        <xsl:param name="value" />
        <xsl:choose>
            <xsl:when test="string($value) and not('---'=$value)">
                <xsl:value-of select="$value" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="setOrder">
        <xsl:param name="value" />
        <xsl:choose>
            <xsl:when test="string($value) and not('---'=$value)">
                <xsl:variable name="shopOrderString" select="normalize-space($value)" />
                <xsl:variable name="shopOrderNumber" select="string(number($shopOrderString))" />
                <xsl:choose>
                    <xsl:when test="$shopOrderNumber='NaN'">
                        <xsl:value-of select="$shopOrderString" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="POValueLong" select="concat('000000000000', $value)" />
                        <xsl:value-of select="substring($POValueLong, (string-length($POValueLong)-11), 12)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>