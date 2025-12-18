<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/wipGoodsIssueRequest">
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing" >
            <soap:Header>
                <wsa:messageId><xsl:value-of select="ewmMessageId"/></wsa:messageId>
            </soap:Header>
            <soap:Body>
                <glob:WorkInProcessGoodsIssue xmlns:glob="http://sap.com/xi/EWM/Global">
                    <MessageHeader>
                        <CreationDateTime>
                            <xsl:value-of select="creationDateTime"/>
                        </CreationDateTime>
                        <!--Optional:-->
                        <SenderBusinessSystemID>
                            <xsl:value-of select="businessSystemId"/>
                        </SenderBusinessSystemID>
                    </MessageHeader>
                    <WIPGoodsIssue>
                        <ERPLogicalSystem>
                            <xsl:value-of select="erpLogicalSystem"/>
                        </ERPLogicalSystem>
                        <Plant>
                            <xsl:value-of select="plant"/>
                        </Plant>
                        <Warehouse>
                            <xsl:value-of select="warehouseNumber"/>
                        </Warehouse>
                        <ActionCode>
                            <xsl:value-of select="actionCode"/>
                        </ActionCode>
                        <Comment/>
                        <!--1 or more repetitions:-->
                        <xsl:for-each select="items">
                            <WIPGoodsIssueItems>
                                <WorkInProcessNumber>
                                    <xsl:value-of select="sfc"/>
                                </WorkInProcessNumber>
                                <ProductionSupplyArea>
                                    <xsl:value-of select="productionSupplyArea"/>
                                </ProductionSupplyArea>
                                <HandlingUnit>
                                    <xsl:value-of select="packingUnit"/>
                                </HandlingUnit>
                                <Product>
                                    <xsl:value-of select="material"/>
                                </Product>
                                <EWMStorageBin>
                                    <xsl:value-of select="goodsMovementBin"/>
                                </EWMStorageBin>
                                <ProductQuantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:value-of select="isoUnitOfMeasure" />
                                    </xsl:attribute>
                                    <xsl:value-of select="wipGoodsIssueRequestedQuantity"/>
                                </ProductQuantity>
                                <UnitOfMeasureSAPCode>
                                    <xsl:value-of select="unitOfMeasure"/>
                                </UnitOfMeasureSAPCode>
                                <Comment/>
                            </WIPGoodsIssueItems>
                        </xsl:for-each>
                    </WIPGoodsIssue>
                </glob:WorkInProcessGoodsIssue>
            </soap:Body>
        </soap:Envelope>
    </xsl:template>
</xsl:stylesheet>
