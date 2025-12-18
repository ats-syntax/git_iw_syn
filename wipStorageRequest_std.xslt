<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/wipStorageRequest">
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing">
            <soap:Header>
                <wsa:messageId>
                    <xsl:value-of select="ewmMessageId"/>
                </wsa:messageId>
            </soap:Header>
            <soap:Body>
                <glob:WorkInProcessInboundDelivery_In xmlns:glob="http://sap.com/xi/EWM/Global">
                    <MessageHeader>
                        <CreationDateTime>
                            <xsl:value-of select="createdDateTime"/>
                        </CreationDateTime>
                        <!--Optional:-->
                        <SenderBusinessSystemID>
                            <xsl:value-of select="businessSystemId"/>
                        </SenderBusinessSystemID>
                    </MessageHeader>
                    <WorkInProcessInboundDelivery_In>
                        <ERPLogicalSystem>
                            <xsl:value-of select="erpLogicalSystem"/>
                        </ERPLogicalSystem>
                        <Plant>
                            <xsl:value-of select="plant"/>
                        </Plant>
                        <Warehouse>
                            <xsl:value-of select="warehouseNumber"/>
                        </Warehouse>
                        <PlannedDeliveryDateTime>
                            <xsl:value-of select="plannedDeliveryDateTime"/>
                        </PlannedDeliveryDateTime>
                        <!-- 1 or more repetitions: -->
                        <xsl:for-each select="items">
                            <InboundDeliveryItems>
                                <WorkInProcessNumber>
                                    <xsl:value-of select="sfc"/>
                                </WorkInProcessNumber>
                                <ProductVersion>
                                    <xsl:value-of select="productionVersion"/>
                                </ProductVersion>
                                <Routing>
                                    <xsl:value-of select="routing"/>
                                </Routing>
                                <Operation>
                                    <xsl:value-of select="operation"/>
                                </Operation>
                                <FinishedProduct>
                                    <xsl:value-of select="material"/>
                                </FinishedProduct>
                                <Quantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:value-of select="isoUnitOfMeasure" />
                                    </xsl:attribute>
                                    <xsl:value-of select="quantity"/>
                                </Quantity>
                                <UnitOfMeasureSAPCode>
                                    <xsl:value-of select="unitOfMeasure"/>
                                </UnitOfMeasureSAPCode>
                                <PackagingMaterial>
                                    <xsl:value-of select="packagingMaterial"/>
                                </PackagingMaterial>
                                <ExternalHandlingUnit>
                                    <xsl:value-of select="packingUnit"/>
                                </ExternalHandlingUnit>
                                <HandlingUnitType>
                                    <xsl:value-of select="packingUnitType"/>
                                </HandlingUnitType>
                                <StorageLocation>
                                    <xsl:value-of select="storageLocation"/>
                                </StorageLocation>
                                <Comment>
                                    <xsl:value-of select="comment"/>
                                </Comment>
                            </InboundDeliveryItems>
                        </xsl:for-each>
                    </WorkInProcessInboundDelivery_In>
                </glob:WorkInProcessInboundDelivery_In>
            </soap:Body>
        </soap:Envelope>
    </xsl:template>
</xsl:stylesheet>
