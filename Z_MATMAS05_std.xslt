<?xml version='1.0' ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/">
        <xsl:apply-templates select="/Z_MATMAS05/IDOC/E1MARAM/E1MARCM"/>
    </xsl:template>
    <xsl:template match="/Z_MATMAS05/IDOC/E1MARAM/E1MARCM">
        <materialIn>
             <SenderBusinessSystemID>
                <xsl:call-template name="getBusinessSystem"/>
            </SenderBusinessSystemID>
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
            <multiLanguageDescriptionDTOList>
                <xsl:for-each select="../E1MAKTM">
                    <multiLanguageDescriptionDTO languageCode="{SPRAS}">
                        <xsl:value-of select="MAKTX"/>
                    </multiLanguageDescriptionDTO>
                </xsl:for-each>
            </multiLanguageDescriptionDTOList>
            <unitOfMeasure>
                <xsl:value-of select="../MEINS"/>
            </unitOfMeasure>
            <grossWeight>
                <xsl:value-of select="../BRGEW"/>
            </grossWeight>
            <netWeight>
                <xsl:value-of select="../NTGEW"/>
            </netWeight>
            <unitOfWeight>
                <xsl:value-of select="../GEWEI"/>
            </unitOfWeight>
            <ean>
                <xsl:value-of select="../EAN11"/>
            </ean>
            <eanCategory>
                <xsl:value-of select="../NUMTP"/>
            </eanCategory>
            <xsl:choose>
                <xsl:when test="XCHPF='X'">
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
            <alternateUomDTOList>
                <xsl:for-each select="../E1MARMM">
                    <alternateUomDTO>
                        <quantity unitCode="{../MEINS}">
                            <xsl:value-of select="UMREZ"/>
                        </quantity>
                        <correspondingQuantity unitCode="{MEINH}">
                            <xsl:value-of select="UMREN"/>
                        </correspondingQuantity>

                        <grossWeight>
                            <xsl:value-of select="BRGEW"/>
                        </grossWeight>

                        <unitOfWeight>
                            <xsl:value-of select="GEWEI"/>
                        </unitOfWeight>

                        <!-- Sample for parallelUom indicator, only one alternateUomDTO can have this flag set to true
                        <parallelUom>true</parallelUom>
                        -->

                        <eanList>
                            <xsl:for-each select="E1MEANM">
                                <eanDTO category="{EANTP}" mainEanIndicator="{HPEAN}">
                                    <xsl:value-of select="EAN11"/>
                                </eanDTO>
                            </xsl:for-each>
                        </eanList>
                    </alternateUomDTO>
                </xsl:for-each>
            </alternateUomDTOList>
            <serialNumbProfile>
                <xsl:value-of select="SERNP"/>
            </serialNumbProfile>
            <maxShelfLife>
                <xsl:value-of select="../MHDHB"/>
            </maxShelfLife>
            <maxShelfLifeUnitCode>
                <xsl:value-of select="../IPRKZ"/>
            </maxShelfLifeUnitCode>
            <xsl:choose>
                <xsl:when test="SBDKZ='1' or SBDKZ='2'">
                    <bomExplosionDependent>
                        <xsl:value-of select="SBDKZ"/>
                    </bomExplosionDependent>
                </xsl:when>
                <xsl:otherwise>
                    <bomExplosionDependent>0</bomExplosionDependent>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Sample for AssyDataType
            <assyDataType>NONE</assyDataType>
            <inventoryAssyDataType>NONE</inventoryAssyDataType>
            <removalAssyDataType>NONE</removalAssyDataType>
            -->
            <!-- Sample for customFieldDtoList 
            <customFieldDTOList>
                <customFieldDTO>
                    <attribute>XYZ</attribute>
                    <value>value_1</value>
                </customFieldDTO>
                <customFieldDTO>
                    <attribute>ABC</attribute>
                    <value>value_1</value>
                </customFieldDTO>
            </customFieldDTOList>
            -->
            <!-- Sample for Autocomplete and Confirm
            <autocompleteAndConfirm>true</autocompleteAndConfirm>
            -->
            <!-- Sample for Lot Size
            <lotSize>1</lotSize>
            -->
            <!-- Sample for Quantity Restriction, possible values:
                    A - Any Number
                    W - Whole Number
                    O - Only 1
            <quantityRestriction>O</quantityRestriction>
            -->
        </materialIn>
    </xsl:template>
    <xsl:template name="addMaterial">
        <xsl:param name="material" />
        <xsl:variable name="materialString" select="normalize-space($material)"/>
        <xsl:value-of select="$materialString"/>
    </xsl:template>
    <xsl:template name="getBusinessSystem">
        <xsl:value-of select="/Z_MATMAS05/IDOC/EDI_DC40/SNDPRN"/>
    </xsl:template>
</xsl:stylesheet>
