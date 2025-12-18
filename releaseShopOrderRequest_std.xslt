<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="releaseShopOrderRequest">
        <soapenv:Envelope 
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
            xmlns:mep="mepapi:com:sap:me:demand" 
            xmlns:dem="http://www.sap.com/me/demand">
            <soapenv:Header/>
            <soapenv:Body>
                <mep:releaseShopOrder>
                    <!--Optional:-->
                    <xsl:if test="plant">
                        <mep:Site>
                            <xsl:value-of select="plant"/>
                        </mep:Site>
                    </xsl:if>
                    <xsl:if test="requestContext">
                        <!--Optional:-->
                        <mep:RequestContext>
                            <xsl:value-of select="requestContext"/>
                        </mep:RequestContext>
                        <!--Optional:-->
                    </xsl:if>
                    <mep:Request>
                        <xsl:if test="shopOrderRef">
                            <dem:shopOrderRef>
                                <xsl:value-of select="shopOrderRef"/>
                            </dem:shopOrderRef>
                        </xsl:if>
                        <xsl:if test="quantityToRelease">
                            <dem:quantityToRelease>
                                <xsl:value-of select="quantityToRelease"/>
                            </dem:quantityToRelease>
                        </xsl:if>
                        <!--Optional:-->
                        <xsl:if test="workCenterRef">
                            <dem:workCenterRef>
                                <xsl:value-of select="workCenterRef"/>
                            </dem:workCenterRef>
                        </xsl:if>
                        <!--Optional:-->
                        <xsl:if test="addToNewLot">
                            <dem:addToNewLot>
                                <xsl:value-of select="addToNewLot"/>
                            </dem:addToNewLot>
                        </xsl:if>
                        <!--Optional:-->
                        <xsl:if test="allowRmaRelease">
                            <dem:allowRmaRelease>
                                <xsl:value-of select="allowRmaRelease"/>
                            </dem:allowRmaRelease>
                        </xsl:if>
                        <!--Optional:-->
                        <xsl:if test="laborChargeCodeRef">
                            <dem:laborChargeCodeRef>
                                <xsl:value-of select="laborChargeCodeRef"/>
                            </dem:laborChargeCodeRef>
                        </xsl:if>
                        <!--Zero or more repetitions:-->
                        <xsl:for-each select="newSfcList">
                            <dem:newSfcList>
                                <xsl:if test="id">
                                    <dem:id>
                                        <xsl:value-of select="id"/>
                                    </dem:id>
                                </xsl:if>
                            </dem:newSfcList>
                        </xsl:for-each>
                    </mep:Request>
                </mep:releaseShopOrder>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>