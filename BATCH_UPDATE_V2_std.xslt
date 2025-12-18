<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/*">
        <urn:BAPI_BATCH_CHANGE xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <BATCHATTRIBUTES>
                <EXPIRYDATE>
                    <xsl:call-template name="convertDateFormat">
                        <xsl:with-param name="date" select="sch:ShelfLifeExpirationDate"/>
                    </xsl:call-template>
                </EXPIRYDATE>
                <PROD_DATE>
                    <xsl:value-of select="sch:ManufactureDate"/>
                </PROD_DATE>
            </BATCHATTRIBUTES>
            <BATCH>
                <xsl:value-of select="sch:Batch"/>
            </BATCH>
            <BATCHATTRIBUTESX>
                <EXPIRYDATE>
                    <xsl:call-template name="isDateUpdate">
                        <xsl:with-param name="data" select="sch:ShelfLifeExpirationDate"/>
                    </xsl:call-template>
                </EXPIRYDATE>
                <PROD_DATE>
                    <xsl:call-template name="isDateUpdate">
                        <xsl:with-param name="data" select="sch:ManufactureDate"/>
                    </xsl:call-template>
                </PROD_DATE>
            </BATCHATTRIBUTESX>
            <xsl:choose>
                <xsl:when test="string-length(sch:Material) &lt;= 18">
                    <MATERIAL>
                        <xsl:value-of select="sch:Material"/>
                    </MATERIAL>
                </xsl:when>
                <xsl:otherwise>
                    <MATERIAL_LONG>
                        <xsl:value-of select="sch:Material"/>
                    </MATERIAL_LONG>
                </xsl:otherwise>
            </xsl:choose>
            <PLANT>
                <xsl:value-of select="sch:BatchIdentifyingPlant"/>
            </PLANT>
        </urn:BAPI_BATCH_CHANGE>
    </xsl:template>

    <xsl:template name="convertDateFormat">
        <xsl:param name="date"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:if test="$date!=''">
            <xsl:value-of select="substring($date, 1, 10)"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="isDateUpdate">
        <xsl:param name="data"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:if test="$data!=''">
            <xsl:text>X</xsl:text>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>