<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/BOMMAT04">
            <xsl:variable name="businessSystem" select="IDOC/EDI_DC40/SNDPRN"/>
        <bomIn>
            <SenderBusinessSystemID>
                <xsl:value-of select="$businessSystem"/>
              </SenderBusinessSystemID>
            <plant>
                <xsl:value-of select="IDOC/E1STZUM/E1MASTM/WERKS"/>
            </plant>
            <bom>
                <xsl:call-template name="addBOMName">
                    <xsl:with-param name="material" select="IDOC/E1STZUM/E1MASTM/MATNR"/>
                    <xsl:with-param name="materialExt" select="IDOC/E1STZUM/E1MASTM/MATNR_EXTERNAL"/>
                    <xsl:with-param name="usage" select="IDOC/E1STZUM/E1MASTM/STLAN"/>
                    <xsl:with-param name="altBOM" select="IDOC/E1STZUM/E1MASTM/STLAL"/>
                </xsl:call-template>
            </bom>
            <xsl:choose>
                <xsl:when test="string-length(IDOC/E1STZUM/ZTEXT) &gt; '0'">
                    <description>
                        <xsl:value-of select="IDOC/E1STZUM/ZTEXT"/>
                    </description>
                </xsl:when>
                <xsl:when test="IDOC/E1STZUM/E1MASTM/MATNR_EXTERNAL != ''">
                    <description>
                        <xsl:value-of select="IDOC/E1STZUM/E1MASTM/MATNR_EXTERNAL"/>
                    </description>
                </xsl:when>
                <xsl:when test="IDOC/E1STZUM/E1MASTM/MATNR_LONG != ''">
                    <description>
                        <xsl:value-of select="IDOC/E1STZUM/E1MASTM/MATNR_LONG"/>
                    </description>
                </xsl:when>
                <xsl:otherwise>
                    <description>
                        <xsl:value-of select="IDOC/E1STZUM/E1MASTM/MATNR"/>
                    </description>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="IDOC/E1STZUM/E1STKOM/MSGFN='009'">
                    <action>Create</action>
                </xsl:when>
                <xsl:when test="IDOC/E1STZUM/E1STKOM/MSGFN='005'">
                    <action>Change</action>
                </xsl:when>
                <xsl:when test="IDOC/E1STZUM/E1STKOM/MSGFN='003'">
                    <action>Delete</action>
                </xsl:when>
            </xsl:choose>
            <erpBom>
                <xsl:value-of select="IDOC/E1STZUM/E1MASTM/STLNR"/>
            </erpBom>
            <xsl:choose>
                <xsl:when test="IDOC/E1STZUM/E1STKOM/STLST='02'">
                    <status>205</status>
                    <currentVersion>false</currentVersion>
                </xsl:when>
                <xsl:otherwise>
                    <status>201</status>
                    <currentVersion>true</currentVersion>
                </xsl:otherwise>
            </xsl:choose>
            <bomType>U</bomType>
            <effectivityControl>R</effectivityControl>
            <baseQuantity><xsl:value-of select="IDOC/E1STZUM/E1STKOM/BMENG_C"/></baseQuantity>
            <baseUom><xsl:value-of select="IDOC/E1STZUM/E1STKOM/BMEIN"/></baseUom>
            <bomComponentDTOList>
                <xsl:for-each select="IDOC/E1STZUM/E1STPOM">
                    <xsl:variable name="comp" select="IDNRK"/>
                    <xsl:variable name="compLong" select="*/IDNRK_LONG"/>
                    <xsl:if test="string($comp) or string($compLong)">
                        <bomComponentDTO>
                            <xsl:call-template name="bom_comp_and_ref_des"/>
                            <erpSequence>
                                <xsl:value-of select="POSNR"/>                        
                            </erpSequence>
                            <!-- Sample for component level customFieldDtoList -->
                            <!--
                            <customFieldDTOList>
                                <customFieldDTO>
                                    <attribute>XYZ</attribute>
                                    <value>value_xyz</value>
                                </customFieldDTO>
                                <customFieldDTO>
                                    <attribute>ABC</attribute>
                                    <value>value_abc</value>
                                </customFieldDTO>
                            </customFieldDTOList>
                            -->
                        </bomComponentDTO>
                    </xsl:if>
                </xsl:for-each>
            </bomComponentDTOList>
            <!-- Sample for header level customFieldDtoList -->
            <!--
            <customFieldDTOList>
                <customFieldDTO>
                    <attribute>XYZ</attribute>
                    <value>value_xyz</value>
                </customFieldDTO>
                <customFieldDTO>
                    <attribute>ABC</attribute>
                    <value>value_abc</value>
                </customFieldDTO>
            </customFieldDTOList>
            -->
        </bomIn>
    </xsl:template>
    <xsl:template match="E1STPUM">
        <bomRefDesDTO>
            <refDes>
                <xsl:value-of select="translate(EBORT,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            </refDes>
            <sequence>
                <xsl:number value="10"/>
            </sequence>
            <quantity>
                <xsl:variable name="totalQty" select="UPMNG_C"/>
                <xsl:variable name="baseQty" select="//IDOC/E1STZUM/E1STKOM/BMENG_C"/>
                <xsl:value-of select="$totalQty div $baseQty"/>
            </quantity>
            <erpRefDesSequence>
                <xsl:value-of select="number(STLKN)"/>            
            </erpRefDesSequence>
            <description>
                <xsl:value-of select="UPTXT"/>
            </description>
        </bomRefDesDTO>
    </xsl:template>
    <xsl:template name="bom_comp">
        <component>
            <material>
                <xsl:call-template name="addMaterial">
                    <xsl:with-param name="material" select="IDNRK"/>
                    <xsl:with-param name="materialExt" select="IDNRK_EXTERNAL"/>
                </xsl:call-template>
            </material>
        </component>
        <sequence>
            <xsl:value-of select="number(POSNR)"/>
        </sequence>
        <xsl:choose>
            <!-- BY PRODUCT -->
            <xsl:when test="contains(MENGE_C,'-') and string(KZKUP)=''">
                <bomComponentType>B</bomComponentType>
            </xsl:when>
            <!-- CO PRODUCT -->
            <xsl:when test="contains(MENGE_C,'-') and string(KZKUP)='X'">
                <bomComponentType>C</bomComponentType>
            </xsl:when>
            <!-- NORMAL COMPONENT -->
            <xsl:otherwise>
                <bomComponentType>N</bomComponentType>
            </xsl:otherwise>
        </xsl:choose>
        <enabled>true</enabled>
        <quantity>
             <!-- <xsl:value-of select="normalize-space(MENGE_C)"/> -->
             <xsl:variable name="totalQty" select="normalize-space(translate(MENGE_C,'-',''))"/>
             <xsl:variable name="baseQty" select="//IDOC/E1STZUM/E1STKOM/BMENG_C"/>
             <xsl:value-of select="$totalQty div $baseQty"/>
        </quantity>
        <totalQtyBaseUom><xsl:value-of select="normalize-space(translate(MENGE_C,'-',''))"/></totalQtyBaseUom>
        <useItemDefaults>false</useItemDefaults>
        <preAssembled>false</preAssembled>
        <testPart>false</testPart>
        <storageLocation>
            <xsl:value-of select="LGORT"/>
        </storageLocation>
        <unitOfMeasure>
            <xsl:value-of select="MEINS"/>
        </unitOfMeasure>
        <alternativeItemGroup><xsl:value-of select="ALPGR"/></alternativeItemGroup>
        <alternativeItemPriority><xsl:value-of select="ALPRF"/></alternativeItemPriority>
        <usageProbability><xsl:value-of select="EWAHR"/></usageProbability>
    </xsl:template>
    <xsl:template name="bom_comp_and_ref_des">
        <xsl:call-template name="bom_comp"/>
        <xsl:if test="string(E1STPUM/EBORT)">
            <bomRefDesDTOList>
                <xsl:apply-templates select="E1STPUM"/>
            </bomRefDesDTOList>
        </xsl:if>
    </xsl:template>
    <xsl:template name="addMaterial">
        <xsl:param name="material" />
        <xsl:param name="materialExt" />
        <xsl:variable name="materialString">
            <xsl:choose>
                <xsl:when test="$material!=''">
                    <xsl:value-of select="normalize-space($material)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($materialExt)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$materialString"/>
    </xsl:template>
    <xsl:template name="addBOMName">
        <xsl:param name="material" />
        <xsl:param name="materialExt" />
        <xsl:param name="usage" />
        <xsl:param name="altBOM" />
        <xsl:variable name="materialString">
            <xsl:choose>
                <xsl:when test="$material!=''">
                    <xsl:value-of select="normalize-space($material)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($materialExt)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($materialString,'-', $usage, '-', number($altBOM))"/>
    </xsl:template>
</xsl:stylesheet>