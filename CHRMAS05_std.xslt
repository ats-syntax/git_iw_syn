<?xml version='1.0' ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/CHRMAS05">
        <xsl:variable name="businessSystem" select="IDOC/EDI_DC40/SNDPRN"/>
        <characteristic>
            <SenderBusinessSystemID>
                <xsl:value-of select="$businessSystem"/>
            </SenderBusinessSystemID>
            <xsl:apply-templates select="IDOC/E1CABNM"/>
        </characteristic>
    </xsl:template>
    <xsl:template match="IDOC/E1CABNM">
        <messageFunction>
            <xsl:value-of select="MSGFN"/>
        </messageFunction>
        <characteristicName>
            <xsl:value-of select="ATNAM"/>
        </characteristicName>
        <charcInternalID>
            <xsl:value-of select="ATNAM"/>
        </charcInternalID>
        <dataType>
            <xsl:value-of select="ATFOR"/>
        </dataType>
        <charcLength>
            <xsl:value-of select="ANZST"/>
        </charcLength>
        <charcDecimals>
            <xsl:value-of select="ANZDZ"/>
        </charcDecimals>
        <charcWithSign>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATVOR"/>
            </xsl:call-template>
        </charcWithSign>
        <charcValueWithTemplate>
            <xsl:value-of select="ATSCH"/>
        </charcValueWithTemplate>
        <caseSensitive>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATKLE"/>
            </xsl:call-template>
        </caseSensitive>
        <entryRequired>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATERF"/>
            </xsl:call-template>
        </entryRequired>
        <singleValue>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATEIN"/>
            </xsl:call-template>
        </singleValue>
        <uom>
            <xsl:value-of select="MSEHI"/>
        </uom>
        <exponentDisplay>
            <xsl:value-of select="ATDIM"/>
        </exponentDisplay>
        <restrictableCharc>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATGLA"/>
            </xsl:call-template>
        </restrictableCharc>
        <intervalsAllowed>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATINT"/>
            </xsl:call-template>
        </intervalsAllowed>
        <additionalValuesAllowed>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATSON"/>
            </xsl:call-template>
        </additionalValuesAllowed>
        <displayAllowedValues>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATWRD"/>
            </xsl:call-template>
        </displayAllowedValues>
        <createdBy>
            <xsl:value-of select="ANAME"/>
        </createdBy>
        <creationDate>
            <xsl:call-template name="convertBAPIDateFormat">
                <xsl:with-param name="date" select="ADATU"/>
            </xsl:call-template>
        </creationDate>
        <modifiedBy>
            <xsl:value-of select="VNAME"/>
        </modifiedBy>
        <lastChangeDate>
            <xsl:call-template name="convertBAPIDateFormat">
                <xsl:with-param name="date" select="VDATU"/>
            </xsl:call-template>
        </lastChangeDate>
        <charcStatus>
            <xsl:value-of select="ATMST"/>
        </charcStatus>
        <validFromDate>
            <xsl:call-template name="convertBAPIDateFormat">
                <xsl:with-param name="date" select="DATUV"/>
            </xsl:call-template>
        </validFromDate>
        <deletionIndicator>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="LKENZ"/>
            </xsl:call-template>
        </deletionIndicator>
        <noEntryForCharc>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATINP"/>
            </xsl:call-template>
        </noEntryForCharc>
        <noDisplayForCharc>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATVIE"/>
            </xsl:call-template>
        </noDisplayForCharc>
        <internalClassNumber>
            <xsl:value-of select="CLASS"/>
        </internalClassNumber>
        <indicatorForAllowedTolerance>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="ATTOL"/>
            </xsl:call-template>
        </indicatorForAllowedTolerance>
        <sortOrder>
            <xsl:value-of select="E1CUKBM/DEP_LINENO"/>
        </sortOrder>
        <charcStatus>
            <xsl:value-of select="ATMST"/>
        </charcStatus>
        <characteristicDescriptions>
            <xsl:for-each select="//E1CABTM">
                <characteristicDescription>
                    <language>
                        <xsl:value-of select="SPRAS_ISO"/>
                    </language>
                    <description>
                        <xsl:value-of select="ATBEZ"/>
                    </description>
                </characteristicDescription>
            </xsl:for-each>
        </characteristicDescriptions>
        <characteristicValues>
            <xsl:for-each select="//E1CAWNM">
                <characteristicValue>
                    <characteristic>
                        <xsl:value-of select="ATNAM"/>
                    </characteristic>
                    <position>
                        <xsl:value-of select="ATZHL"/>
                    </position>
                    <characteristicValue>
                        <xsl:value-of select="ATWRT"/>
                    </characteristicValue>
                    <fltpValueFrom>
                        <xsl:value-of select="ATFLV"/>
                    </fltpValueFrom>
                    <fltpValueTo>
                        <xsl:value-of select="ATFLB"/>
                    </fltpValueTo>
                    <codeForValue>
                        <xsl:value-of select="ATCOD"/>
                    </codeForValue>
                    <defaultValue>
                        <xsl:call-template name="convertBAPIBool">
                            <xsl:with-param name="bool" select="ATSTD"/>
                        </xsl:call-template>
                    </defaultValue>
                    <fromValueUom>
                        <xsl:value-of select="ATAWE"/>
                    </fromValueUom>
                    <toValueUom>
                        <xsl:value-of select="ATAW1"/>
                    </toValueUom>
                    <locale>
                        <xsl:value-of select="SPRAS"/>
                    </locale>
                    <validFrom>
                        <xsl:call-template name="convertBAPIDateFormat">
                            <xsl:with-param name="date" select="DATUV"/>
                        </xsl:call-template>
                    </validFrom>
                    <deletionIndicator>
                        <xsl:call-template name="convertBAPIBool">
                            <xsl:with-param name="bool" select="LKENZ"/>
                        </xsl:call-template>
                    </deletionIndicator>
                    <toleranceFrom>
                        <xsl:value-of select="ATTLV"/>
                    </toleranceFrom>
                    <toleranceTo>
                        <xsl:value-of select="ATTLB"/>
                    </toleranceTo>
                    <toleranceShownAsPercentage>
                        <xsl:value-of select="ATPRZ"/>
                    </toleranceShownAsPercentage>
                    <incrementWithSpecificInterval>
                        <xsl:value-of select="ATINC"/>
                    </incrementWithSpecificInterval>
                </characteristicValue>
            </xsl:for-each>
        </characteristicValues>
    </xsl:template>
    <xsl:template name="convertBAPIDateFormat">
        <xsl:param name="date"/>
        <!-- 20170413 -->
        <xsl:if test="$date!='' and $date!='00000000' and $date!='0000-00-00'">
            <xsl:value-of select="concat($date, 'T00:00:00')"/>
            <!-- 2017-04-13T00:00:00 -->

        </xsl:if>
    </xsl:template>
    <xsl:template name="convertBAPIBool">
        <xsl:param name="bool"/>
        <!-- 'X' -->
        <xsl:choose>
            <xsl:when test="$bool='X'">
                <xsl:value-of select="'true'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'false'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
