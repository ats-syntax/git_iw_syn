<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/ewmStagingRequest">
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
                            <xsl:value-of select="wareHouseNumber"/>
                        </Warehouse>
                        <ActionCode><xsl:value-of select="actionCode"/></ActionCode>
                        <StagingRequest>
                            <xsl:value-of select="stagingRequestNumber"/>
                        </StagingRequest>
                        <Comment/>
                        <!--1 or more repetitions:-->
                        <xsl:for-each select="stagingRequestItems">
                            <StagingRequestItems>
                                <StagingRequestItem>
                                    <xsl:value-of select="requestItemNumber"/>
                                </StagingRequestItem>
                                <Reservation>
                                    <xsl:value-of select="reservation"/>
                                </Reservation>
                                <ReservationItem>
                                    <xsl:value-of select="reservationItem"/>
                                </ReservationItem>
                                <ReservationType/>
                                <Product>
                                    <xsl:value-of select="product"/>
                                </Product>
                                <!--Optional:-->
                                <Batch>
                                    <xsl:value-of select="batchNumber"/>
                                </Batch>
                                <ProductQuantity unitCode="">
                                    <xsl:call-template name="getStagingInfo">
                                        <xsl:with-param name="base" select="requestQuantity"/>
                                        <xsl:with-param name="staging" select="stagingRequestedQuantity"/>
                                    </xsl:call-template>
                                </ProductQuantity>
                                <UnitOfMeasureSAPCode>
                                    <xsl:call-template name="getStagingInfo">
                                        <xsl:with-param name="base" select="uomSapCode"/>
                                        <xsl:with-param name="staging" select="stagingUom"/>
                                    </xsl:call-template>
                                </UnitOfMeasureSAPCode>
                                <EWMDeliveryPriority/>
                                <ProductionSupplyArea>
                                    <xsl:value-of select="psa"/>
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
    <xsl:template name="getStagingInfo">
        <xsl:param name="base"/>
        <xsl:param name="staging"/>
        <xsl:choose>
            <xsl:when test="$staging!=''">
                <xsl:value-of select="$staging"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$base"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
