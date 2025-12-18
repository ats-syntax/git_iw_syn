<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/Z_batchUpdateShopOrderSchedulesRequest">
        <soapenv:Envelope 
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
            xmlns:mep="mepapi:com:sap:me:demand" 
            xmlns:dem="http://www.sap.com/me/demand">
            <soapenv:Header/>
            <soapenv:Body>
                <mep:updateShopOrderSchedules>
                    <!--Optional:-->
                    
                        <mep:Site>
                            <xsl:value-of select="plant"/>
                        </mep:Site>
                    
                    
                        <!--Optional:-->
                        <mep:RequestContext>
                            <xsl:value-of select="updateShopOrderSchedulesRequest/requestContext"/>
                        </mep:RequestContext>
                        <!--Optional:-->
                    
                    <mep:Request>
                        <!--1 or more repetitions:-->
                        <xsl:for-each select="updateShopOrderSchedulesRequest/shopOrderSchedule">
                            <dem:shopOrderScheduleList>
                                <xsl:if test="routerStepRef">
                                    <dem:routerStepRef>
                                        <xsl:value-of select="routerStepRef"/>
                                    </dem:routerStepRef>
                                </xsl:if>
                                <xsl:if test="sequence">
                                    <dem:sequence>
                                        <xsl:value-of select="sequence"/>
                                    </dem:sequence>
                                </xsl:if>
                                <!--Optional:-->
                                <xsl:if test="resourceRef">
                                    <dem:resourceRef>
                                        <xsl:value-of select="resourceRef"/>
                                    </dem:resourceRef>
                                </xsl:if>
                                <!--Optional:-->
                                <xsl:if test="splitId">
                                    <dem:splitId>
                                        <xsl:value-of select="splitId"/>
                                    </dem:splitId>
                                </xsl:if>
                                <xsl:if test="plannedQuantity">
                                    <dem:plannedQuantity>
                                        <xsl:value-of select="plannedQuantity"/>
                                    </dem:plannedQuantity>
                                </xsl:if>
                                <!--Optional:-->
                                <xsl:if test="confirmedQuantity">
                                    <dem:confirmedQuantity>
                                        <xsl:value-of select="confirmedQuantity"/>
                                    </dem:confirmedQuantity>
                                </xsl:if>
                                <xsl:if test="startDate">
                                    <dem:startDate>
                                        <xsl:value-of select="startDate"/>
                                    </dem:startDate>
                                </xsl:if>
                                <xsl:if test="endDate">
                                    <!--Optional:-->
                                    <dem:endDate>
                                        <xsl:value-of select="endDate"/>
                                    </dem:endDate>
                                </xsl:if>
                                <!--Optional:-->
                                <xsl:if test="resourceErpInternalId">
                                    <dem:resourceErpInternalId>
                                        <xsl:value-of select="resourceErpInternalId"/>
                                    </dem:resourceErpInternalId>
                                </xsl:if>
                            </dem:shopOrderScheduleList>
                        </xsl:for-each>
                        
                            <dem:shopOrderRef>
                                <xsl:value-of select="updateShopOrderSchedulesRequest/shopOrderRef"/>
                            </dem:shopOrderRef>
                        
                    </mep:Request>
                </mep:updateShopOrderSchedules>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>