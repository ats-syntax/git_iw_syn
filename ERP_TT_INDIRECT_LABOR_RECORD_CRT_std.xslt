<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <BAPI_CATIMESHEETMGR_INSERT>
            <CATSRECORDS_IN>
                <item>
                    <PLANT>
                        <xsl:value-of select="sch:plant" />
                    </PLANT>
                    <WORKDATE>
                        <xsl:value-of select="sch:workDate"/>
                    </WORKDATE>
                    <EMPLOYEENUMBER>
                        <xsl:value-of select="sch:erpPersonnelNumber" />
                    </EMPLOYEENUMBER>
                    <!-- <WORK_CNTR>
                        <xsl:value-of select="sch:workCenter" />
                    </WORK_CNTR> -->
                    <REC_ORDER>
                        <xsl:value-of select="format-number(number(sch:internalOrder), '000000000000')" />
                    </REC_ORDER>
                    <CO_AREA>
                        <xsl:value-of select="sch:controllingArea" />
                    </CO_AREA>
                    <SEND_CCTR>
                        <xsl:choose>
                            <xsl:when test="number(sch:senderCostCenter) = number(sch:senderCostCenter)">
                                <xsl:value-of select="format-number(number(sch:senderCostCenter), '0000000000')" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="sch:senderCostCenter" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </SEND_CCTR>
                    <ACTTYPE>
                        <xsl:value-of select="sch:erpActivityType" />
                    </ACTTYPE>
                    <CATSHOURS>
                        <xsl:value-of select="sch:duration" />
                    </CATSHOURS>
                </item>
            </CATSRECORDS_IN>
        </BAPI_CATIMESHEETMGR_INSERT>
    </xsl:template>

    <xsl:template name="convertTimeFormat">
        <xsl:param name="time" /> <!-- 2017-04-13T00:00:00 or 15:51:04 -->
        <xsl:choose>
            <xsl:when test="contains($time,'T')">
                <xsl:value-of select="substring($time,12,8)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$time" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>