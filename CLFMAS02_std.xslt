<?xml version='1.0' ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
    <xsl:template match="/CLFMAS02">
        <xsl:variable name="businessSystem" select="IDOC/EDI_DC40/SNDPRN"/>
        <classification>
            <SenderBusinessSystemID>
                <xsl:value-of select="$businessSystem"/>
            </SenderBusinessSystemID>
            <AssignmentType>
                <xsl:value-of select="IDOC/E1OCLFM/OBJECT_TABLE"/>
            </AssignmentType>
            <xsl:apply-templates select="IDOC/E1OCLFM"/>
        </classification>
    </xsl:template>
    <xsl:template match="IDOC/E1OCLFM">
        <objectKey>
            <xsl:choose>
                <xsl:when test="OBJEK_LONG != ''">
                    <xsl:value-of select="OBJEK_LONG"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="OBJEK"/>
                </xsl:otherwise>
            </xsl:choose>
        </objectKey>
        <classType>
            <xsl:value-of select="KLART"/>
        </classType>
        <classAssignment>
            <xsl:for-each select="//E1KSSKM">
                <A_Class>
                    <classInternalID>
                        <xsl:value-of select="CLASS"/>
                    </classInternalID>
                    <validFromDate>
                        <xsl:value-of select="DATUV"/>
                    </validFromDate>
                    <status>
                        <xsl:value-of select="STATU"/>
                    </status>
                    <validityStartDate/>
                    <validityEndDate/>
                    <keyDate/>
                    <charcLastChangedDateTime/>
                </A_Class>
            </xsl:for-each>
        </classAssignment>
        <assignedCharValues>
            <xsl:for-each select="//E1AUSPM">
                <assignedCharValue>
                    <characteristicName>
                        <xsl:value-of select="ATNAM"/>
                    </characteristicName>
                    <charcInternalID>
                        <xsl:value-of select="ATNAM"/>
                    </charcInternalID>
                    <validFromDate>
                        <xsl:value-of select="DATUV"/>
                    </validFromDate>
                    <characteristicValue>
                        <xsl:value-of select="ATWRT"/>
                    </characteristicValue>
                    <internalFloatValueFrom>
                        <xsl:value-of select="ATFLV"/>
                    </internalFloatValueFrom>
                    <uom>
                        <xsl:value-of select="ATAWE"/>
                    </uom>
                    <internalFloatValueTo>
                        <xsl:value-of select="ATWRT"/>
                    </internalFloatValueTo>
                    <charcValue>
                        <xsl:value-of select="ATWRT_LONG"/>
                    </charcValue>
                </assignedCharValue>
            </xsl:for-each>
        </assignedCharValues>
    </xsl:template>
</xsl:stylesheet>
