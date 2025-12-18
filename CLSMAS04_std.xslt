<?xml version='1.0' ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/CLSMAS04">
        <xsl:variable name="businessSystem" select="IDOC/EDI_DC40/SNDPRN"/>
        <class>
            <SenderBusinessSystemID>
                <xsl:value-of select="$businessSystem"/>
            </SenderBusinessSystemID>
            <xsl:apply-templates select="IDOC/E1KLAHM"/>
        </class>
    </xsl:template>
    <xsl:template match="IDOC/E1KLAHM">
        <messageFunction>
            <xsl:value-of select="MSGFN"/>
        </messageFunction>
        <classType>
            <xsl:value-of select="KLART"/>
        </classType>
        <classInternalID>
            <xsl:value-of select="CLASS"/>
        </classInternalID>
        <className>
            <xsl:value-of select="CLASS"/>
        </className>
        <status>
            <xsl:value-of select="STATU"/>
        </status>
        <classGroup>
            <xsl:value-of select="KLAGR"/>
        </classGroup>
        <classSearchAuthGrp>
            <xsl:value-of select="BGRSE"/>
        </classSearchAuthGrp>
        <classClassfctnAuthGrp>
            <xsl:value-of select="BGRKL"/>
        </classClassfctnAuthGrp>
        <classMaintAuthGrp>
            <xsl:value-of select="BGRKP"/>
        </classMaintAuthGrp>
        <docNumber>
            <xsl:value-of select="DOKNR"/>
        </docNumber>
        <documentType>
            <xsl:value-of select="DOKAR"/>
        </documentType>
        <documentPart>
            <xsl:value-of select="DOKTL"/>
        </documentPart>
        <documentVersion>
            <xsl:value-of select="DOKVR"/>
        </documentVersion>
        <classStandardOrgName>
            <xsl:value-of select="NNORM "/>
        </classStandardOrgName>
        <classStandardNumber>
            <xsl:value-of select="NORMN"/>
        </classStandardNumber>
        <ClassStandardStartDate>
            <xsl:call-template name="convertBAPIDateFormat">
                <xsl:with-param name="date" select="AUSGD"/>
            </xsl:call-template>
        </ClassStandardStartDate>
        <classStandardVersionStartDate>
            <xsl:call-template name="convertBAPIDateFormat">
                <xsl:with-param name="date" select="VERSI"/>
            </xsl:call-template>
        </classStandardVersionStartDate>
        <classStandardVersion>
            <xsl:value-of select="VERSI"/>
        </classStandardVersion>
        <classStandardCharcTable>
            <xsl:value-of select="LEIST"/>
        </classStandardCharcTable>
        <classIsLocal>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="LOCLA"/>
            </xsl:call-template>
        </classIsLocal>
        <validityStartDate>
            <xsl:call-template name="convertBAPIDateFormat">
                <xsl:with-param name="date" select="VONDT"/>
            </xsl:call-template>
        </validityStartDate>
        <validityEndDate>
            <xsl:call-template name="convertBAPIDateFormat">
                <xsl:with-param name="date" select="BISDT"/>
            </xsl:call-template>
        </validityEndDate>
        <sameClassificationCheck>
            <xsl:call-template name="convertBAPIBool">
                <xsl:with-param name="bool" select="PRAUS"/>
            </xsl:call-template>
        </sameClassificationCheck>
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
        <classDescriptions>
            <xsl:for-each select="//E1SWORM[KLPOS='01']">
                <classDescription>
                    <language>
                        <xsl:value-of select="SPRAS_ISO"/>
                    </language>
                    <description>
                        <xsl:value-of select="KSCHL"/>
                    </description>
                </classDescription>
            </xsl:for-each>
        </classDescriptions>

        <toClassCharacteristics>
            <xsl:for-each select="//E1KSMLM">
                <classCharacteristic>
                    <characteristic>
                        <xsl:value-of select="ATNAM"/>
                    </characteristic>
                    <position>
                        <xsl:value-of select="POSNR"/>
                    </position>
                    <characteristicOrigin>
                        <xsl:value-of select="HERKU"/>
                    </characteristicOrigin>
                    <relevancyIndicator>
                        <xsl:value-of select="RELEV"/>
                    </relevancyIndicator>
                    <validFrom>
                        <xsl:call-template name="convertBAPIDateFormat">
                            <xsl:with-param name="date" select="DATUV"/>
                        </xsl:call-template>
                    </validFrom>
                    <deletionIndicator>
                        <xsl:call-template name="convertBAPIBool">
                            <xsl:with-param name="bool" select="LKENZ "/>
                        </xsl:call-template>
                    </deletionIndicator>
                </classCharacteristic>
            </xsl:for-each>
        </toClassCharacteristics>
    </xsl:template>
    <xsl:template name="convertBAPIDateFormat">
        <xsl:param name="date"/> <!-- 20170413 -->
        <xsl:if test="$date!='' and $date!='00000000' and $date!='0000-00-00'">
            <xsl:value-of select="concat($date, 'T00:00:00')"/>  <!-- 2017-04-13T00:00:00 -->
        </xsl:if>
    </xsl:template>
    <xsl:template name="convertBAPIBool">
        <xsl:param name="bool"/> <!-- 'X' -->
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
