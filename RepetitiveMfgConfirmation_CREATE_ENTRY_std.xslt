<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/RepetitiveMfgConfirmation/RepetitiveMfgConfirmationType">
        <rfc:BAPI_REPMANCONF1_CREATE_MTS xmlns:rfc="urn:sap-com:document:sap:rfc:functions">
            <BFLUSHDATAGEN>
                <xsl:choose>
                    <xsl:when test="string-length(Product) &lt;= 18">
                        <MATERIALNR>
                            <xsl:value-of select="Product" />
                        </MATERIALNR>
                    </xsl:when>
                    <xsl:otherwise>
                        <MATERIALNR_LONG>
                            <xsl:value-of select="Product" />
                        </MATERIALNR_LONG>
                    </xsl:otherwise>
                </xsl:choose>
                <PRODPLANT>
                    <xsl:value-of select="ProductionPlant" />
                </PRODPLANT>
                <PLANPLANT>
                    <xsl:value-of select="PlanningPlant" />
                </PLANPLANT>
                <PRODVERSION>
                    <xsl:value-of select="ProductionVersion" />
                </PRODVERSION>
                <STORAGELOC>
                    <xsl:value-of select="ReceivingStorageLocation" />
                </STORAGELOC>
                <BATCH>
                    <xsl:call-template name="setValue">
                        <xsl:with-param name="value" select="ReceivingBatch" />
                    </xsl:call-template>
                </BATCH>
                <xsl:choose>
                    <xsl:when test="VarianceReasonCode='01'">
                        <SCRAPQUANT>
                            <xsl:value-of select="ConfirmationEntryQuantity"/>
                        </SCRAPQUANT>
                    </xsl:when>
                    <xsl:otherwise>
                        <BACKFLQUANT>
                            <xsl:value-of select="ConfirmationEntryQuantity"/>
                        </BACKFLQUANT>
                    </xsl:otherwise>
                </xsl:choose>
                <UNITOFMEASURE>
                    <xsl:value-of select = "ConfirmationUnitSAPCode"/>
                </UNITOFMEASURE>
                <POSTDATE>
                    <!-- <xsl:value-of select="PostingDate"/> -->
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="PostingDateTime"/>
                    </xsl:call-template>
                </POSTDATE>
                <DOCDATE>
                    <!-- <xsl:value-of select="DocumentDate"/> -->
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date" select="DocumentDateTime"/>
                    </xsl:call-template>
                </DOCDATE>
                <PLANORDER>
                    <xsl:value-of select="PlannedOrder" />
                </PLANORDER>
            </BFLUSHDATAGEN>
            <BFLUSHFLAGS>
                <BCKFLTYPE>
                    <xsl:value-of select="RptvMfgConfProcessingType"/>
                </BCKFLTYPE>
            </BFLUSHFLAGS>
            <xsl:if test="string(_RptvMfgConfGRBatchCharc/RptvMfgConfGRBatchCharcType[1]) and VarianceReasonCode='01'">
                <CHARACTERISTICS_BATCH>
                    <xsl:for-each select="_RptvMfgConfGRBatchCharc/RptvMfgConfGRBatchCharcType">
                        <item>
                            <CHAR_NAME>
                                <xsl:value-of select="Characteristic" />
                            </CHAR_NAME>
                            <CHAR_VALUE>
                                <xsl:value-of select="CharcValue" />
                            </CHAR_VALUE>
                        </item>
                    </xsl:for-each>
                </CHARACTERISTICS_BATCH>
            </xsl:if>
            <!--
                <xsl:if test="string(sch:erpComponentArray/sch:erpComponent)">
                    <GOODSMOVEMENTS>
                        <xsl:for-each select="sch:erpComponentArray/sch:erpComponent">                        
                            <item>
								<xsl:call-template name="setMaterial">
									<xsl:with-param name="value" select="sch:item/sch:item"/>
									<xsl:with-param name="tagName" select="'MATERIAL'" />
								</xsl:call-template>
                                <PLANT>
                                    <xsl:value-of select="$site"/>
                                </PLANT>
                                <STGE_LOC>
                                    <xsl:call-template name="setValue">
                                        <xsl:with-param name="value" select="sch:storageLocation"/>
                                    </xsl:call-template>
                                </STGE_LOC>
                                <BATCH>
                                    <xsl:call-template name="setValue">
                                        <xsl:with-param name="value" select="sch:batchNumber"/>
                                    </xsl:call-template>
                                </BATCH>
                                <MOVE_TYPE>261</MOVE_TYPE>
                                <ENTRY_QNT>
                                    <xsl:value-of select="sch:quantity"/>
                                </ENTRY_QNT>		                                     
                                <ORDERID>
                                    <xsl:value-of select="$orderId"/>
                                </ORDERID>
                           		<xsl:if test="string(sch:rsNum)">
									<RESERV_NO>
										<xsl:value-of select="sch:rsNum"/>
									</RESERV_NO>
								</xsl:if>
								<xsl:if test="string(sch:rsPos)">
									<RES_ITEM>
										<xsl:value-of select="sch:rsPos"/>
									</RES_ITEM>
								</xsl:if>
                            </item>                        
                        </xsl:for-each>
                    </GOODSMOVEMENTS>
                </xsl:if>
                -->
        </rfc:BAPI_REPMANCONF1_CREATE_MTS>
    </xsl:template>
    <xsl:template name="setValue">
        <xsl:param name="value" />
        <xsl:choose>
            <xsl:when test="string($value) and not('---'=$value)">
                <xsl:value-of select="$value" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="convertODataDateFormat">
        <xsl:param name="date"/>
        <!-- 2017-04-13T00:00:00 -->
        <xsl:value-of select="substring($date, 1, 10)"/>
    </xsl:template>
</xsl:stylesheet>