<?xml version='1.0' ?>
<!--22.05.24, Syntax, hormann, Only add E1MARMM segment as alternateUomDTO if one of this 4 rules are true-->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/">
        <xsl:apply-templates select="/Z_MATMAS03/IDOC/E1MARAM/E1MARCM"/>
    </xsl:template>
    <xsl:template match="/Z_MATMAS03/IDOC/E1MARAM/E1MARCM">
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
				<xsl:choose>
					<xsl:when test="WERKS = 'SY20'">
						<xsl:for-each select="../E1MARMM">
							<xsl:variable name="varCurrentMEINH" select="MEINH"/>
							<xsl:variable name="varCurrentMEINH_count" select="count(//E1MARMM[MEINH = $varCurrentMEINH])"/>
							<xsl:variable name="varCurrentMEINH_validBRGEW_count" select="count(//E1MARMM[MEINH = $varCurrentMEINH][BRGEW &gt; 0])"/>
							
							<!--print out values of variables for debugging
							<currentMEINH><xsl:value-of select="$varCurrentMEINH"/></currentMEINH>
							<currentMEINH_count><xsl:value-of select="$varCurrentMEINH_count"/></currentMEINH_count>
							<currentMEINH_validBRGEW_count><xsl:value-of select="$varCurrentMEINH_validBRGEW_count"/></currentMEINH_validBRGEW_count>
							-->

							<xsl:choose>
								<!--Only add E1MARMM segment as alternateUomDTO if one of this 4 rules are true
								1. there is only one occurence of E1MARMM with the current MEINH, BRGEW not important
								2. there are multiple occurences of E1MARMM with the same MEINH but there is only one with a valid BRGEW and that is the current E1MARMM 
								3. there are multiple occurences of E1MARMM with the same MEINH and there is no valid BRGEW, then only take the first E1MARMM
								4. there are multiple occurences of E1MARMM with the same MEINH and there is are multiple valid BRGEW, then only take the first E1MARMM with a valid BRGEW	-->
								<!--NOTE for developers: all when elements have the exact same alternateUomDTO logic, it is only separated into different when blocks for better readability and maintainability of the different rules-->
								
								<!--Rule 1-->
								<xsl:when test="($varCurrentMEINH_count = 1)">
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
										<eanList>
											<xsl:for-each select="E1MEANM">
												<eanDTO category="{EANTP}" mainEanIndicator="{HPEAN}">
													<xsl:value-of select="EAN11"/>
												</eanDTO>
											</xsl:for-each>
										</eanList>
									</alternateUomDTO>								
								</xsl:when>
								
								<!--Rule 2-->
								<xsl:when test="($varCurrentMEINH_count &gt; 1 and $varCurrentMEINH_validBRGEW_count = 1 and BRGEW &gt; 0)">
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
										<eanList>
											<xsl:for-each select="E1MEANM">
												<eanDTO category="{EANTP}" mainEanIndicator="{HPEAN}">
													<xsl:value-of select="EAN11"/>
												</eanDTO>
											</xsl:for-each>
										</eanList>
									</alternateUomDTO>								
								</xsl:when>
								
								<!--Rule 3-->
								<xsl:when test="($varCurrentMEINH_count &gt; 1 and $varCurrentMEINH_validBRGEW_count = 0 and not(preceding-sibling::E1MARMM[MEINH=$varCurrentMEINH]))">
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
										<eanList>
											<xsl:for-each select="E1MEANM">
												<eanDTO category="{EANTP}" mainEanIndicator="{HPEAN}">
													<xsl:value-of select="EAN11"/>
												</eanDTO>
											</xsl:for-each>
										</eanList>
									</alternateUomDTO>								
								</xsl:when>
								
								<!--Rule 4-->
								<xsl:when test="($varCurrentMEINH_count &gt; 1 and $varCurrentMEINH_validBRGEW_count &gt; 1 and BRGEW &gt; 0 and not(preceding-sibling::E1MARMM[MEINH=$varCurrentMEINH][BRGEW &gt; 0]))">
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
										<eanList>
											<xsl:for-each select="E1MEANM">
												<eanDTO category="{EANTP}" mainEanIndicator="{HPEAN}">
													<xsl:value-of select="EAN11"/>
												</eanDTO>
											</xsl:for-each>
										</eanList>
									</alternateUomDTO>								
								</xsl:when>

								<xsl:otherwise>
									<!--redundant E1MARMM is ignored because it would lead to an exception in DM if MEINH is not unique-->
								</xsl:otherwise>
							
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
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
								<eanList>
									<xsl:for-each select="E1MEANM">
										<eanDTO category="{EANTP}" mainEanIndicator="{HPEAN}">
											<xsl:value-of select="EAN11"/>
										</eanDTO>
									</xsl:for-each>
								</eanList>
							</alternateUomDTO>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>				
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
        </materialIn>
    </xsl:template>
    <xsl:template name="addMaterial">
        <xsl:param name="material" />
        <xsl:variable name="materialString" select="normalize-space($material)"/>
        <xsl:value-of select="$materialString"/>
    </xsl:template>
    <xsl:template name="getBusinessSystem">
        <xsl:value-of select="/Z_MATMAS03/IDOC/EDI_DC40/SNDPRN"/>
    </xsl:template>
</xsl:stylesheet>
