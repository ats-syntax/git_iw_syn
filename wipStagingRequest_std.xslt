<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/wipStagingRequest">
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing" >
            <soap:Header>
                <wsa:messageId><xsl:value-of select="ewmMessageId"/></wsa:messageId>
            </soap:Header>
            <soap:Body>
                <glob:WarehouseStagingRequest_In xmlns:glob="http://sap.com/xi/EWM/Global">
                    <MessageHeader>
                        <CreationDateTime>
                            <xsl:value-of select="creationDateTime"/>
                        </CreationDateTime>
                        <!--Optional:-->
                        <SenderBusinessSystemID>
                            <xsl:value-of select="businessSystemId"/>
                        </SenderBusinessSystemID>
                    </MessageHeader>
                    <WarehouseRequest>
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
                        <StagingRequest>
                            <xsl:value-of select="stagingRequestNumber"/>
                        </StagingRequest>
                        <Comment/>
                        <!--1 or more repetitions:-->
                        <xsl:for-each select="items">
                            <StagingRequestItems>
                                <StagingRequestItem>
                                    <xsl:value-of select="requestItemNumber"/>
                                </StagingRequestItem>
                                <WorkInProcessNumber>
                                    <xsl:value-of select="sfc"/>
                                </WorkInProcessNumber>
                                <HandlingUnit>
                                    <xsl:value-of select="packingUnit"/>
                                </HandlingUnit>
                                <IsWorkInProcessStaging>true</IsWorkInProcessStaging>
                                <ReservationType/>
                                <Product>
                                    <xsl:value-of select="material"/>
                                </Product>
                                <Batch>
                                    <xsl:value-of select="batchNumber"/>
                                </Batch>
                                <ProductQuantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:value-of select="isoUnitOfMeasure" />
                                    </xsl:attribute>
                                    <xsl:value-of select="stagingRequestedQuantity"/>
                                </ProductQuantity>
                                <UnitOfMeasureSAPCode>
                                    <xsl:value-of select="unitOfMeasure"/>
                                </UnitOfMeasureSAPCode>
                                <EWMDeliveryPriority/>
                                <ProductionSupplyArea>
                                    <xsl:value-of select="productionSupplyArea"/>
                                </ProductionSupplyArea>
                                <EWMStorageBin/>
                                <EWMStagingMethod>
                                    <xsl:value-of select="stagingMethod"/>
                                </EWMStagingMethod>
                                <StorageLocation>
                                    <xsl:value-of select="storageLocation"/>
                                </StorageLocation>
                                <PlannedSupplyDateTime>
                                    <xsl:value-of select="plannedSupplyDateTime"/>
                                </PlannedSupplyDateTime>
                                <Comment/>
                            </StagingRequestItems>
                        </xsl:for-each>
                    </WarehouseRequest>
                </glob:WarehouseStagingRequest_In>
            </soap:Body>
        </soap:Envelope>
    </xsl:template>
</xsl:stylesheet>
