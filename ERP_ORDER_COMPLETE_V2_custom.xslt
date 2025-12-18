<?xml version='1.0' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <xsl:variable name="orderId">
            <xsl:call-template name="setOrder">
                <xsl:with-param name="value" select="sch:orderNumber"/>
            </xsl:call-template>
        </xsl:variable>

        <BAPI_PRODORDCONF_CREATE_TT>
            <TIMETICKETS>
                <xsl:for-each select="sch:operation">
                    <item>
                        <PLANT>
                            <xsl:value-of select="../sch:plant"/>
                        </PLANT>
                        <ORDERID>
                            <xsl:value-of select="$orderId"/>
                        </ORDERID>
                        <SEQUENCE>
                            <xsl:call-template name="setSequence">
                                <xsl:with-param name="sequence" select="sch:erpSequence"/>
                            </xsl:call-template>
                        </SEQUENCE>
                        <OPERATION>
                            <xsl:value-of select="sch:orderOperation"/>
                        </OPERATION>
                        <FIN_CONF>X</FIN_CONF>
                        <CLEAR_RES/>
                        <PROC_FIN_DATE>
                            <xsl:call-template name="convertDateFormat">
                                <xsl:with-param name="date" select="sch:confirmedProcessingEndDateTime"/>
                            </xsl:call-template>
                        </PROC_FIN_DATE>
                        <PROC_FIN_TIME>
                            <xsl:call-template name="convertTimeFormat">
                                <xsl:with-param name="time" select="sch:confirmedProcessingEndDateTime"/>
                            </xsl:call-template>
                        </PROC_FIN_TIME>
                    </item>
                </xsl:for-each>
            </TIMETICKETS>
        </BAPI_PRODORDCONF_CREATE_TT>
    </xsl:template>

    <xsl:template name="setOrder">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="string($value) and not('---'=$value)">
                <xsl:variable name="shopOrderString" select="normalize-space($value)"/>
                <xsl:variable name="shopOrderNumber" select="string(number($shopOrderString))"/>
                <xsl:choose>
                    <xsl:when test="$shopOrderNumber='NaN'">
                        <xsl:value-of select="$shopOrderString"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="POValueLong" select="concat('000000000000', $value)"/>
                        <xsl:value-of select="substring($POValueLong, (string-length($POValueLong)-11), 12)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="convertDateFormat">
        <xsl:param name="date"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:value-of select="substring($date, 1, 10)"/>
    </xsl:template>

    <xsl:template name="convertTimeFormat">
        <xsl:param name="time"/> <!-- 2017-04-13T00:00:00 or 15:51:04 -->
        <xsl:choose>
            <xsl:when test="contains($time,'T')">
                <xsl:value-of select="substring($time,12,8)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$time"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="setSequence">
        <xsl:param name="sequence"/>
        <xsl:variable name="sequenceString" select="normalize-space($sequence)"/>
        <xsl:variable name="mask" select="'000000'"/>
        <xsl:variable name="sequenceNumber" select="string(number($sequenceString))"/>
        <xsl:choose>
            <xsl:when test="$sequenceNumber = 'NaN'">
                <xsl:value-of select="$sequenceString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number(xs:decimal($sequenceString), $mask)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>