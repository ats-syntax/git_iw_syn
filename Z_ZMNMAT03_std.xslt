<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/">
        <xsl:apply-templates select="/Z_ZMNMAT03/IDOC/E1MARAM/E1MARCM"/>
    </xsl:template>
    <xsl:template match="/Z_ZMNMAT03/IDOC/E1MARAM/E1MARCM">
        <materialIn>
            <plant>
                <xsl:value-of select="WERKS"/>
            </plant>
            <material>
                <xsl:choose>
                    <xsl:when test="(string(../MATNR_LONG))">
                        <xsl:call-template name="addMaterial">
                            <xsl:with-param name="material" select="../MATNR_LONG"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="addMaterial">
                            <xsl:with-param name="material" select="../MATNR"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </material>
            <xsl:choose>
                <xsl:when test="BESKZ">
                    <xsl:variable name="procurementType" select="BESKZ"/>
                    <xsl:choose>
                        <xsl:when test="$procurementType='E'">
                            <procurementType>M</procurementType>
                        </xsl:when>
                        <xsl:when test="$procurementType='F'">
                            <procurementType>P</procurementType>
                        </xsl:when>
                        <xsl:otherwise>
                            <procurementType>B</procurementType>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <procurementType>B</procurementType>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="../MTART">
                    <materialType>
                        <xsl:value-of select="../MTART"/>
                    </materialType>
                </xsl:when>
            </xsl:choose>
            <description>
                <xsl:choose>
                    <xsl:when test="(string(../E1MAKTM[SPRAS=//SupportedPlant/Language]/MAKTX))">
                        <xsl:value-of select="../E1MAKTM[SPRAS=//SupportedPlant/Language]/MAKTX"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="../E1MAKTM/MAKTX"/>
                    </xsl:otherwise>
                </xsl:choose>
            </description>
            <unitOfMeasure>
                <xsl:value-of select="../MEINS"/>
            </unitOfMeasure>
            <xsl:choose>
                <xsl:when test="../XCHPF='X'">
                    <incrementBatchNumber>ORDER</incrementBatchNumber>
                </xsl:when>
                <xsl:otherwise>
                    <incrementBatchNumber>NONE</incrementBatchNumber>
                </xsl:otherwise>
            </xsl:choose>
            <mrpController>
                <xsl:value-of select="DISPO"/>
            </mrpController>
            <xsl:choose>
                <xsl:when test="BESKZ = 'E'">
                    <putawayStorageLocation>
                        <xsl:value-of select="LGPRO"/>
                    </putawayStorageLocation>
                </xsl:when>
                <xsl:when test="BESKZ = 'F'">
                    <productionStorageLocation>
                        <xsl:value-of select="LGPRO"/>
                    </productionStorageLocation>
                </xsl:when>
                <xsl:otherwise>
                    <putawayStorageLocation>
                        <xsl:value-of select="LGPRO"/>
                    </putawayStorageLocation>
                    <productionStorageLocation>
                        <xsl:value-of select="LGPRO"/>
                    </productionStorageLocation>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="RGEKZ=1">
                    <erpBackflushing>true</erpBackflushing>
                </xsl:when>
                <xsl:otherwise>
                    <erpBackflushing>false</erpBackflushing>
                </xsl:otherwise>
            </xsl:choose>
            <documentUrl>
                <xsl:value-of select="ZEXTURL/ZURL"/>
            </documentUrl>
        </materialIn>
    </xsl:template>
    <xsl:template name="addMaterial">
        <xsl:param name="material" />
        <xsl:variable name="materialString" select="normalize-space($material)"/>
        <xsl:value-of select="$materialString"/>
    </xsl:template>
</xsl:stylesheet>
