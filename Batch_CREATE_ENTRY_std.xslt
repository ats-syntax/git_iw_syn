<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/Batch/BatchType">
        <rfc:BAPI_BATCH_CREATE xmlns:rfc="urn:sap-com:document:sap:rfc:functions">
            <BATCH>
                <xsl:value-of select="Batch"/>
            </BATCH>
            <BATCHATTRIBUTES>
                <VENDOR_NO>
                    <xsl:value-of select="Supplier"/>
                </VENDOR_NO>
                <VENDRBATCH>
                    <xsl:value-of select="BatchBySupplier"/>
                </VENDRBATCH>
                <FREE_DATE1>
                    <xsl:value-of select="FreeDefinedDate1"/>
                </FREE_DATE1>
                <FREE_DATE2>
                    <xsl:value-of select="FreeDefinedDate2"/>
                </FREE_DATE2>
                <FREE_DATE3>
                    <xsl:value-of select="FreeDefinedDate3"/>
                </FREE_DATE3>
                <FREE_DATE4>
                    <xsl:value-of select="FreeDefinedDate4"/>
                </FREE_DATE4>
                <FREE_DATE5>
                    <xsl:value-of select="FreeDefinedDate5"/>
                </FREE_DATE5>
                <FREE_DATE6>
                    <xsl:value-of select="FreeDefinedDate6"/>
                </FREE_DATE6>
                <COUNTRYORI>
                    <xsl:value-of select="CountryOfOrigin"/>
                </COUNTRYORI>
                <REGIONORIG>
                    <xsl:value-of select="RegionOfOrigin"/>
                </REGIONORIG>
                <PROD_DATE>
                    <xsl:call-template name="formatdate">
                        <xsl:with-param name="datestr" select="ManufactureDate"/>
                    </xsl:call-template>
                </PROD_DATE>
                <DEL_FLAG>
                    <xsl:value-of select="BatchIsMarkedForDeletion"/>
                </DEL_FLAG>
                <AVAILABLE>
                    <xsl:call-template name="formatdate">
                        <xsl:with-param name="datestr" select="MatlBatchAvailabilityDate"/>
                    </xsl:call-template>
                </AVAILABLE>
                <EXPIRYDATE>
                    <xsl:call-template name="formatdate">
                        <xsl:with-param name="datestr" select="ShelfLifeExpirationDate"/>
                    </xsl:call-template>
                </EXPIRYDATE>
                <!-- <STATUSKEY>
                    <xsl:call-template name="convertODataBool">
                        <xsl:with-param name="bool" select="MatlBatchIsInRstrcdUseStock"/>
                    </xsl:call-template>
                </STATUSKEY> -->
            </BATCHATTRIBUTES>
            <xsl:choose>
                <xsl:when test="string-length(Material) &lt;= 18">
                    <MATERIAL>
                        <xsl:value-of select="Material"/>
                    </MATERIAL>
                </xsl:when>
                <xsl:otherwise>
                    <MATERIAL_LONG>
                        <xsl:value-of select="Material"/>
                    </MATERIAL_LONG>
                </xsl:otherwise>
            </xsl:choose>
            <PLANT>
                <xsl:value-of select="BatchIdentifyingPlant"/>
            </PLANT>
        </rfc:BAPI_BATCH_CREATE>
    </xsl:template>

    <!-- <xsl:template name="convertODataBool">
        <xsl:param name="bool"/>
        <xsl:choose>
            <xsl:when test="$bool='true'">
                <xsl:value-of select="'X'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="' '"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> -->
    <xsl:template name="formatdate">
        <xsl:param name="datestr" />
        <!-- input format yyyy-mm-dd -->
        <!-- output format yyyymmdd -->
        <xsl:variable name="abc">
            <xsl:if test="$datestr = '00000000'">
                <xsl:value-of select="20221001" />
            </xsl:if>
            <xsl:if test="$datestr != '00000000'">
                <xsl:value-of select="$datestr" />
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="yyyy">
            <xsl:value-of select="substring($abc,1,4)" />
        </xsl:variable>
        <xsl:variable name="mm">
            <xsl:value-of select="substring($abc,6,2)" />
        </xsl:variable>
        <xsl:variable name="dd">
            <xsl:value-of select="substring($abc,9,2)" />
        </xsl:variable>
        <xsl:value-of select="$yyyy" />
        <xsl:value-of select="$mm" />
        <xsl:value-of select="$dd" />
    </xsl:template>
</xsl:stylesheet>