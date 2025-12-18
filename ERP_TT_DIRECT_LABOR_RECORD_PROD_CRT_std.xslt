<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <BAPI_PRODORDCONF_CREATE_TT>
            <TIMETICKETS>
                <item>
                    <PLANT>
                        <xsl:value-of select="sch:plant" />
                    </PLANT>
                    <ORDERID>
                        <xsl:value-of select="format-number(number(sch:order), '000000000000')"/>
                    </ORDERID>
                    <OPERATION>
                        <xsl:value-of select="sch:operation" />
                    </OPERATION>
                    <SUB_OPER>
                        <xsl:value-of select="sch:subOperation" />
                    </SUB_OPER>
                    <SEQUENCE>
                        <xsl:value-of select="format-number(number(sch:sequence), '000000')" />
                    </SEQUENCE>
                    <EX_CREATED_BY>
                        <xsl:value-of select="sch:timeRecordUser" />
                    </EX_CREATED_BY>
                    <POSTG_DATE>
                        <xsl:call-template name="convertDateFormat">
                            <xsl:with-param name="date" select="sch:approvedAt"/>
                        </xsl:call-template>
                    </POSTG_DATE>
                    <CONF_ACTIVITY1>
                        <xsl:value-of select="sch:standardValueQuantity1"/>
                    </CONF_ACTIVITY1>
                    <CONF_ACTI_UNIT1>
                        <xsl:value-of select="sch:standardValueUom1"/>
                    </CONF_ACTI_UNIT1>
                    <CONF_ACTIVITY2>
                        <xsl:value-of select="sch:standardValueQuantity2"/>
                    </CONF_ACTIVITY2>
                    <CONF_ACTI_UNIT2>
                        <xsl:value-of select="sch:standardValueUom2"/>
                    </CONF_ACTI_UNIT2>
                    <CONF_ACTIVITY3>
                        <xsl:value-of select="sch:standardValueQuantity3"/>
                    </CONF_ACTIVITY3>
                    <CONF_ACTI_UNIT3>
                        <xsl:value-of select="sch:standardValueUom3"/>
                    </CONF_ACTI_UNIT3>
                    <CONF_ACTIVITY4>
                        <xsl:value-of select="sch:standardValueQuantity4"/>
                    </CONF_ACTIVITY4>
                    <CONF_ACTI_UNIT4>
                        <xsl:value-of select="sch:standardValueUom4"/>
                    </CONF_ACTI_UNIT4>
                    <CONF_ACTIVITY5>
                        <xsl:value-of select="sch:standardValueQuantity5"/>
                    </CONF_ACTIVITY5>
                    <CONF_ACTI_UNIT5>
                        <xsl:value-of select="sch:standardValueUom5"/>
                    </CONF_ACTI_UNIT5>
                    <CONF_ACTIVITY6>
                        <xsl:value-of select="sch:standardValueQuantity6"/>
                    </CONF_ACTIVITY6>
                    <CONF_ACTI_UNIT6>
                        <xsl:value-of select="sch:standardValueUom6"/>
                    </CONF_ACTI_UNIT6>
                </item>
            </TIMETICKETS>
        </BAPI_PRODORDCONF_CREATE_TT>
    </xsl:template>

    <xsl:template name="convertDateFormat">
        <xsl:param name="date"/> <!-- 2024-09-23T09:14:23.456Z -->
        <xsl:value-of select="substring($date, 1, 10)"/>
    </xsl:template>
</xsl:stylesheet>