<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/Batch/BatchType">
        <urn:BAPI_BATCH_CHANGE xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <!--You may enter the following 11 items in any order-->
            <BATCHATTRIBUTES>
                <!--Optional:-->
                <AVAILABLE>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="MatlBatchAvailabilityDate"/>
                    </xsl:call-template>
                </AVAILABLE>
                <!--Optional:-->
                <EXPIRYDATE>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="ShelfLifeExpirationDate"/>
                    </xsl:call-template>
                </EXPIRYDATE>
                <!--Optional:-->
                <STATUSKEY/>
                <!--Optional:-->
                <VENDOR_NO>
                    <xsl:value-of select="Supplier"/>
                </VENDOR_NO>
                <!--Optional:-->
                <VENDRBATCH>
                    <xsl:value-of select="BatchBySupplier"/>
                </VENDRBATCH>
                <!--Optional:-->
                <VAL_TYPE/>
                <!--Optional:-->
                <LASTGRDATE/>
                <!--Optional:-->
                <FREE_DATE1>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="FreeDefinedDate1"/>
                    </xsl:call-template>
                </FREE_DATE1>
                <!--Optional:-->
                <FREE_DATE2>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="FreeDefinedDate2"/>
                    </xsl:call-template>
                </FREE_DATE2>
                <!--Optional:-->
                <FREE_DATE3>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="FreeDefinedDate3"/>
                    </xsl:call-template>
                </FREE_DATE3>
                <!--Optional:-->
                <FREE_DATE4>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="FreeDefinedDate4"/>
                    </xsl:call-template>
                </FREE_DATE4>
                <!--Optional:-->
                <FREE_DATE5>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="FreeDefinedDate5"/>
                    </xsl:call-template>
                </FREE_DATE5>
                <!--Optional:-->
                <FREE_DATE6>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="FreeDefinedDate6"/>
                    </xsl:call-template>
                </FREE_DATE6>
                <!--Optional:-->
                <COUNTRYORI>
                    <xsl:value-of select="CountryOfOrigin"/>
                </COUNTRYORI>
                <!--Optional:-->
                <COUNTRYORI_ISO/>
                <!--Optional:-->
                <REGIONORIG>
                    <xsl:value-of select="RegionOfOrigin"/>
                </REGIONORIG>
                <!--Optional:-->
                <EXPIMPGRP/>
                <!--Optional:-->
                <NEXTINSPEC/>
                <!--Optional:-->
                <PROD_DATE>
                    <xsl:value-of select="ManufactureDate"/>
                </PROD_DATE>
                <!--Optional:-->
                <DEL_FLAG>
                    <xsl:call-template name="convertODataBool">
                        <xsl:with-param name="bool" select="BatchIsMarkedForDeletion"/>
                    </xsl:call-template>
                </DEL_FLAG>
                <!--Optional:-->
                <STK_SEGMENT/>
                <!--Optional:-->
                <CERT_DATE>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="LastChangeDateTime"/>
                    </xsl:call-template>
                </CERT_DATE>
            </BATCHATTRIBUTES>
            <BATCH>
                <xsl:value-of select="Batch"/>
            </BATCH>
            <BATCHATTRIBUTESX>
                <!--Optional:-->
                <AVAILABLE>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="MatlBatchAvailabilityDate"/>
                    </xsl:call-template>
                </AVAILABLE>
                <!--Optional:-->
                <EXPIRYDATE>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="ShelfLifeExpirationDate"/>
                    </xsl:call-template>
                </EXPIRYDATE>
                <!--Optional:-->
                <STATUSKEY/>
                <!--Optional:-->
                <VENDOR_NO>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="Supplier"/>
                    </xsl:call-template>
                </VENDOR_NO>
                <!--Optional:-->
                <VENDRBATCH>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="BatchBySupplier"/>
                    </xsl:call-template>
                </VENDRBATCH>
                <!--Optional:-->
                <VAL_TYPE/>
                <!--Optional:-->
                <LASTGRDATE/>
                <!--Optional:-->
                <FREE_DATE1>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="FreeDefinedDate1"/>
                    </xsl:call-template>
                </FREE_DATE1>
                <!--Optional:-->
                <FREE_DATE2>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="FreeDefinedDate2"/>
                    </xsl:call-template>
                </FREE_DATE2>
                <!--Optional:-->
                <FREE_DATE3>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="FreeDefinedDate3"/>
                    </xsl:call-template>
                </FREE_DATE3>
                <!--Optional:-->
                <FREE_DATE4>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="FreeDefinedDate4"/>
                    </xsl:call-template>
                </FREE_DATE4>
                <!--Optional:-->
                <FREE_DATE5>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="FreeDefinedDate5"/>
                    </xsl:call-template>
                </FREE_DATE5>
                <!--Optional:-->
                <FREE_DATE6>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="FreeDefinedDate6"/>
                    </xsl:call-template>
                </FREE_DATE6>
                <!--Optional:-->
                <COUNTRYORI>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="CountryOfOrigin"/>
                    </xsl:call-template>
                </COUNTRYORI>
                <!--Optional:-->
                <COUNTRYORI_ISO/>
                <!--Optional:-->
                <REGIONORIG>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="RegionOfOrigin"/>
                    </xsl:call-template>
                </REGIONORIG>
                <!--Optional:-->
                <EXPIMPGRP/>
                <!--Optional:-->
                <NEXTINSPEC/>
                <!--Optional:-->
                <PROD_DATE>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="ManufactureDate"/>
                    </xsl:call-template>
                </PROD_DATE>
                <!--Optional:-->
                <DEL_FLAG>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="BatchIsMarkedForDeletion"/>
                    </xsl:call-template>
                </DEL_FLAG>
                <!--Optional:-->
                <STK_SEGMENT/>
                <!--Optional:-->
                <CERT_DATE>
                    <xsl:call-template name="isODataDateUpdate">
                        <xsl:with-param name="data" select="LastChangeDateTime"/>
                    </xsl:call-template>
                </CERT_DATE>
            </BATCHATTRIBUTESX>
            <!--Optional:-->
            <BATCHCONTROLFIELDS>
                <!--Optional:-->
                <BATCHLEVEL/>
                <!--Optional:-->
                <CLASS_NUM/>
                <!--Optional:-->
                <DOCLASSIFY/>
                <!--Optional:-->
                <CALLCFC_CL/>
                <!--Optional:-->
                <ORG_SYS_OF_BATCH/>
                <!--Optional:-->
                <SND_SYS_OF_BATCH/>
                <!--Optional:-->
                <NO_CFC_CALLS/>
                <!--Optional:-->
                <NOCOMMIT/>
            </BATCHCONTROLFIELDS>
            <!--Optional:-->
            <EXTENSION1>
                <!--Optional:-->
                <KDUMMY/>
            </EXTENSION1>
            <!--Optional:-->
            <INTERNALNUMBERCOM>
                <!--Optional:-->
                <VENDOR_NO/>
                <!--Optional:-->
                <VENDRBATCH/>
                <!--Optional:-->
                <PURCH_ORG/>
                <!--Optional:-->
                <ORDER_TYPE/>
                <!--Optional:-->
                <ORDER_CATG/>
                <!--Optional:-->
                <WHSE_NO/>
                <!--Optional:-->
                <WHSE_MVMT/>
                <!--Optional:-->
                <MATERIAL/>
                <!--Optional:-->
                <PLANT/>
                <!--Optional:-->
                <STGE_LOC/>
                <!--Optional:-->
                <MATL_GROUP/>
                <!--Optional:-->
                <MATL_TYPE/>
                <!--Optional:-->
                <DCINDIC/>
                <!--Optional:-->
                <VAL_CAT/>
                <!--Optional:-->
                <MOVE_TYPE/>
                <!--Optional:-->
                <SPEC_STOCK/>
                <!--Optional:-->
                <MOVE_MATL/>
                <!--Optional:-->
                <MOVE_PLANT/>
                <!--Optional:-->
                <MOVE_STLOC/>
                <!--Optional:-->
                <SPSTCK_PHY/>
                <!--Optional:-->
                <PROD_MATL/>
                <!--Optional:-->
                <PROD_PLANT/>
                <!--Optional:-->
                <SALES_ORD/>
                <!--Optional:-->
                <S_ORD_ITEM/>
                <!--Optional:-->
                <SCHED_LINE/>
                <!--Optional:-->
                <PO_NUMBER/>
                <!--Optional:-->
                <PO_ITEM/>
                <!--Optional:-->
                <DOC_CAT/>
                <!--Optional:-->
                <PO_TYPE/>
                <!--Optional:-->
                <ORDERID/>
                <!--Optional:-->
                <ORDER_ITNO/>
                <!--Optional:-->
                <MVT_IND/>
                <!--Optional:-->
                <CLSF_BATCH/>
                <!--Optional:-->
                <MATERIAL_EXTERNAL/>
                <!--Optional:-->
                <MATERIAL_GUID/>
                <!--Optional:-->
                <MATERIAL_VERSION/>
                <!--Optional:-->
                <MOVE_MATL_EXTERNAL/>
                <!--Optional:-->
                <MOVE_MATL_GUID/>
                <!--Optional:-->
                <MOVE_MATL_VERSION/>
                <!--Optional:-->
                <PROD_MATL_EXTERNAL/>
                <!--Optional:-->
                <PROD_MATL_GUID/>
                <!--Optional:-->
                <PROD_MATL_VERSION/>
                <!--Optional:-->
                <MATERIAL_LONG/>
                <!--Optional:-->
                <MOVE_MATL_LONG/>
                <!--Optional:-->
                <PROD_MATL_LONG/>
            </INTERNALNUMBERCOM>
            <!--Optional:-->
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
            <!--Optional:-->
            <PLANT>
                <xsl:value-of select="BatchIdentifyingPlant"/>
            </PLANT>
            <!--Optional:-->
            <RETURN>
                <!--Zero or more repetitions:-->
                <item>
                    <!--Optional:-->
                    <TYPE/>
                    <!--Optional:-->
                    <ID/>
                    <!--Optional:-->
                    <NUMBER/>
                    <!--Optional:-->
                    <MESSAGE/>
                    <!--Optional:-->
                    <LOG_NO/>
                    <!--Optional:-->
                    <LOG_MSG_NO/>
                    <!--Optional:-->
                    <MESSAGE_V1/>
                    <!--Optional:-->
                    <MESSAGE_V2/>
                    <!--Optional:-->
                    <MESSAGE_V3/>
                    <!--Optional:-->
                    <MESSAGE_V4/>
                    <!--Optional:-->
                    <PARAMETER/>
                    <!--Optional:-->
                    <ROW/>
                    <!--Optional:-->
                    <FIELD/>
                    <!--Optional:-->
                    <SYSTEM/>
                </item>
            </RETURN>
        </urn:BAPI_BATCH_CHANGE>
    </xsl:template>
    <xsl:template name="convertODataDateFormat">
        <xsl:param name="date"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:if test="$date!=''">
            <xsl:value-of select="substring($date, 1, 10)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="isODataDateUpdate">
        <xsl:param name="data"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:if test="$data!=''">
            <xsl:text>X</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="convertODataBool">
        <xsl:param name="bool"/>
        <xsl:choose>
            <xsl:when test="$bool='true'">
                <xsl:value-of select="'X'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="' '"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>