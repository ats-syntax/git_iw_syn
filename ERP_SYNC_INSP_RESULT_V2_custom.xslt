<?xml version='1.0' ?>
<!-- EN058 | Update Inspection Characteristics Status in ERP -->
<!-- EN060 | Adding comment -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="dmcplant"/>
  <xsl:template match="/*">
    <xsl:variable name="inspectionLot" select="sch:inspectionLot"/>
    <xsl:variable name="inspectionOperationNumber" select="sch:inspectionOperationNumber"/>
    <xsl:variable name="inspectionPointId" select="sch:inspectionPointId"/>

    <BAPI_INSPOPER_RECORDRESULTS>
      <HANDHELD_APPLICATION/>
      <INSPLOT>
        <xsl:value-of select="$inspectionLot"/>
      </INSPLOT>
      <INSPOPER>
        <xsl:value-of select="$inspectionOperationNumber"/>
      </INSPOPER>
      <INSPPOINTDATA>
        <INSPLOT>
          <xsl:value-of select="$inspectionLot"/>
        </INSPLOT>
        <INSPOPER>
          <xsl:value-of select="$inspectionOperationNumber"/>
        </INSPOPER>
        <INSPPOINT>
          <xsl:value-of select="$inspectionPointId"/>
        </INSPPOINT>
      </INSPPOINTDATA>
      <CHAR_RESULTS>
        <xsl:for-each select="sch:inspectionCharacteristic">
          <item>
            <INSPLOT>
              <xsl:value-of select="$inspectionLot"/>
            </INSPLOT>
            <INSPOPER>
              <xsl:value-of select="$inspectionOperationNumber"/>
            </INSPOPER>
            <INSPCHAR>
              <xsl:value-of select="sch:inspectionCharacteristic"/>
            </INSPCHAR>
            
            <CLOSED>X</CLOSED>
            
            <!-- EN058 | Update Inspection Characteristics Status in ERP
            <xsl:if test="$dmcplant = 'SY20'">
                <CLOSED>X</CLOSED>
            </xsl:if> -->
            <EVALUATED>E</EVALUATED>
            <CHAR_ATTR/>
            <CHAR_INVAL/>
            
            <xsl:if test="sch:inspectedNumber = sch:characteristicSampleSize">
              <EVALUATION>
                <xsl:value-of select="sch:characteristicValuationResult"/>
              </EVALUATION>
            </xsl:if>
            
            <!-- EN058 | Update Inspection Characteristics Status in ERP 
            <xsl:if test="$dmcplant = 'SY20'">
             <xsl:if test="sch:inspectedNumber != sch:characteristicSampleSize">
              <EVALUATION>
                <xsl:value-of select="sch:characteristicValuationResult"/>
              </EVALUATION>
             </xsl:if>
            </xsl:if>-->
            <INSPECTOR>
              <xsl:value-of select="sch:singleResult[1]/sch:inspector"/>
            </INSPECTOR>
            <CODE1/>
            <CODE_GRP1/>
            <!-- EN060 | Adding comment -->
            <xsl:if test="$dmcplant = 'SY20'">
             <REMARK>
              <xsl:value-of select="sch:singleResult[1]/sch:resultText"/>
             </REMARK>
            </xsl:if> 
          </item>
        </xsl:for-each>
      </CHAR_RESULTS>
      <SINGLE_RESULTS>
        <xsl:for-each select="sch:inspectionCharacteristic">
            <xsl:variable name="inspectionCharacteristic" select="sch:inspectionCharacteristic"/>
            <xsl:for-each select="sch:singleResult">
              <item>
                <INSPLOT>
                  <xsl:value-of select="$inspectionLot"/>
                </INSPLOT>
                <INSPOPER>
                  <xsl:value-of select="$inspectionOperationNumber"/>
                </INSPOPER>
                <INSPCHAR>
                  <xsl:value-of select="$inspectionCharacteristic"/>
                </INSPCHAR>
                <INSPSAMPLE>
                  <xsl:value-of select="$inspectionPointId"/>
                </INSPSAMPLE>
                <RES_NO>
                  <xsl:value-of select="sch:resultValueId"/>
                </RES_NO>
                <EXT_NO>
                  <xsl:value-of select="../../sch:serialNumber"/>
                </EXT_NO>
                <LAST_RES/>
                <RES_VALUE>
                  <xsl:value-of select="sch:measuredValue"/>
                </RES_VALUE>
                <RES_ATTR/>
                <RES_INVAL/>
                <INSPECTOR>
                  <xsl:value-of select="sch:inspector"/>
                </INSPECTOR>
                <REMARK>
                  <xsl:value-of select="sch:resultText"/>
                </REMARK>
                <CODE1>
                  <xsl:value-of select="sch:attributeCode"/>
                </CODE1>
                <CODE_GRP1>
                  <xsl:value-of select="sch:attributeCodeGroup"/>
                </CODE_GRP1>
              </item>
            </xsl:for-each>
        </xsl:for-each>
      </SINGLE_RESULTS>
      <xsl:if test="$inspectionPointId != ''">
        <SAMPLE_RESULTS>
          <xsl:for-each select="sch:inspectionCharacteristic">
            <item>
              <INSPLOT>
                <xsl:value-of select="$inspectionLot"/>
              </INSPLOT>
              <INSPOPER>
                <xsl:value-of select="$inspectionOperationNumber"/>
              </INSPOPER>
              <INSPCHAR>
                <xsl:value-of select="sch:inspectionCharacteristic"/>
              </INSPCHAR>
              <INSPSAMPLE/>
              <LAST_SMPL/>
              <CLOSED>X</CLOSED>
              <EVALUATED/>
              <SMPL_ATTR/>
              <SMPL_INVAL/>
              <xsl:if test="sch:inspectedNumber != sch:characteristicSampleSize">
                <EVALUATION>
                  <xsl:value-of select="sch:characteristicValuationResult"/>
                </EVALUATION>
              </xsl:if>
              <INSPECTOR>
                <xsl:value-of select="sch:singleResult[1]/sch:inspector"/>
              </INSPECTOR>
              <!-- EN060 | Adding comment -->
              <xsl:choose>
                <xsl:when test="$dmcplant = 'SY20'">
                <REMARK>
                    <xsl:value-of select="sch:singleResult[1]/sch:resultText"/>
                </REMARK>
                </xsl:when>
                <xsl:otherwise>
              <REMARK/>
                </xsl:otherwise>
              </xsl:choose>
              <CODE1/>
              <CODE_GRP1/>
            </item>
          </xsl:for-each>
        </SAMPLE_RESULTS>
      </xsl:if>
    </BAPI_INSPOPER_RECORDRESULTS>
  </xsl:template>
</xsl:stylesheet>