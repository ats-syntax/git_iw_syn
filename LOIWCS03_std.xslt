<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
  <xsl:template match="/LOIWCS03">
    <workCenterIn>
      <SenderBusinessSystemID>
        <xsl:value-of select="IDOC/EDI_DC40/SNDPRN"/>
      </SenderBusinessSystemID>
      <plant>
        <xsl:value-of select="IDOC/E1CRHDL/WERKS" />
      </plant>
      <workCenter>
        <xsl:value-of select="IDOC/E1CRHDL/ARBPL" />
      </workCenter>
      <description>
        <xsl:choose>
          <xsl:when	test="(string(IDOC/E1CRHDL/E1CRTXL[SPRAS=//SupportedPlant/Language]/KTEXT))">
            <xsl:value-of	select="IDOC/E1CRHDL/E1CRTXL[SPRAS=//SupportedPlant/Language]/KTEXT" />
          </xsl:when>
          <xsl:when	test="(string(IDOC/E1CRHDL/E1CRTXL[SPRAS='E']/KTEXT))">
            <xsl:value-of select="IDOC/E1CRHDL/E1CRTXL[SPRAS='E']/KTEXT" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="IDOC/E1CRHDL/E1CRTXL/KTEXT" />
          </xsl:otherwise>
        </xsl:choose>
      </description>
      <xsl:for-each select="IDOC/E1CRHDL/E1CRCAL/E1KAKOL">
        <capacityCategoryIn>
          <erpInternalId>
            <xsl:value-of select="KAPID"/>
          </erpInternalId>
          <category>
            <xsl:value-of select="KAPAR"/>
          </category>
          <description>
            <xsl:value-of select="E1KAKTL/KTEXT"/>
          </description>
          <xsl:for-each select="E1KAKOIL">
            <capacityIn>
              <erpInternalId>
                <xsl:value-of select="KAPID"/>
              </erpInternalId>
              <category>
                <xsl:value-of select="KAPAR"/>
              </category>
              <name>
                <xsl:value-of select="NAME"/>
              </name>
              <description>
                <xsl:value-of select="E1KAKTL2/KTEXT"/>
              </description>
            </capacityIn>
          </xsl:for-each>
          <xsl:for-each select="E1KAZYL[VERSN = max(../E1KAZYL/VERSN)]">
            <capacityShiftIn>
              <beginDate>
                <xsl:choose>
                  <xsl:when test="string(DATUV) != '00000000'">
                    <xsl:value-of select="DATUV"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="'19000101'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </beginDate>
              <endDate>
                <xsl:value-of select="DATUB"/>
              </endDate>
              <shiftNumber>
                <xsl:value-of select="ANZSH"/>
              </shiftNumber>
              <version>
                <xsl:value-of select="VERSN"/>
              </version>
              <cycleLength>
                <xsl:value-of select="ANZTG"/>
              </cycleLength>
              <standardCapacity>
                <xsl:value-of select="KKOPF"/>
              </standardCapacity>
              <xsl:for-each select="E1KAPAL">
                <capacityOverrideIn>
                  <shiftNumber>
                    <xsl:value-of select="SCHNR"/>
                  </shiftNumber>
                  <weekDayNumber>
                    <xsl:value-of select="TAGNR"/>
                  </weekDayNumber>
                  <beginTime>
                    <xsl:value-of select="BEGZT"/>
                  </beginTime>
                  <endTime>
                    <xsl:value-of select="ENDZT"/>
                  </endTime>
                </capacityOverrideIn>
              </xsl:for-each>
            </capacityShiftIn>
          </xsl:for-each>
        </capacityCategoryIn>
      </xsl:for-each>
      <erpInternalId>
        <xsl:value-of select="IDOC/E1CRHDL/OBJID" />
      </erpInternalId>
      <supplyArea>
        <xsl:value-of select="IDOC/E1CRHDL/PRVBE" />
      </supplyArea>
      <standardValueKey>
        <xsl:value-of select="IDOC/E1CRHDL/VGWTS"/>
      </standardValueKey>
      <xsl:for-each select="IDOC/E1CRHDL/E1CRCOL[FORML!='']">
        <xsl:sort select="LANUM"/>
        <standardValueIn>
          <sequence>
            <xsl:value-of select="LANUM"/>
          </sequence>
          <standardValue>
            <xsl:value-of select="FORML"/>
          </standardValue>
        </standardValueIn>
      </xsl:for-each>
    </workCenterIn>
  </xsl:template>
</xsl:stylesheet>
