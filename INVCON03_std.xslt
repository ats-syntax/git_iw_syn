<?xml version='1.0' ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xpath-default-namespace="urn:sap-com:document:sap:idoc:soap:messages">
	<xsl:template match="/INVCON03/IDOC">
		<xsl:apply-templates select="//E1ICHD0" />
	</xsl:template>
	<xsl:template match="//E1ICHD0">
		<inventoryReceiptIn>
			<xsl:for-each select="E1ICIT0">
				<inventoryReceiptDTO>
					<SenderBusinessSystemID>
						<xsl:call-template name="getBusinessSystem"/>
					</SenderBusinessSystemID>
					<goodsMovementType>
						<xsl:value-of select="BWART" />
					</goodsMovementType>
					<debitCreditCode>
						<xsl:value-of select="SHKZG" />
					</debitCreditCode>
					<plant>
						<xsl:value-of select="WERKS" />
					</plant>
					<xsl:if test="KDAUF">
						<salesOrder>
							<xsl:call-template name="trimOrderNumberLeadingZero">
								<xsl:with-param name="orderNumber" select="KDAUF" />
							</xsl:call-template>
						</salesOrder>
						<salesOrderItem>
							<xsl:value-of select="KDPOS" />
						</salesOrderItem>
						<inventorySpecialStockType>
							<xsl:value-of select="SOBKZ" />
						</inventorySpecialStockType>
					</xsl:if>

					<!-- Sample for custom inventoryId 
					<inventoryId>SAMPLE</inventoryId>
					-->
					<material>
						<xsl:choose>
							<xsl:when test="MATNR_EXTERNAL">
								<xsl:value-of select="MATNR_EXTERNAL" />
							</xsl:when>
							<xsl:when test="E1ICIT5/MATNR_LONG">
								<xsl:value-of select="E1ICIT5/MATNR_LONG" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="MATNR" />
							</xsl:otherwise>
						</xsl:choose>
					</material>
					<quantityOnHand>
						<xsl:value-of select="MENGE" />
					</quantityOnHand>
					<erpMaterialDocumentLineItem>
						<xsl:value-of select="ZEILE" />
					</erpMaterialDocumentLineItem>
					<xsl:if test="../MJAHR">
						<erpMaterialDocumentYear>
							<xsl:value-of select="../MJAHR" />
						</erpMaterialDocumentYear>
					</xsl:if>
					<xsl:if test="../MBLNR">
						<erpMaterialDocumentNumber>
							<xsl:value-of select="../MBLNR" />
						</erpMaterialDocumentNumber>
					</xsl:if>

					<xsl:if test="BWART='261'">
						<xsl:variable name="POValue" select="AUFNR" />
						<reservedShopOrder>
							<xsl:call-template name="trimOrderNumberLeadingZero">
								<xsl:with-param name="orderNumber" select="$POValue" />
							</xsl:call-template>
						</reservedShopOrder>
					</xsl:if>
					<xsl:if test="BWART='101' or BWART='102'">
						<manufacturingOrder>
							<xsl:call-template name="trimOrderNumberLeadingZero">
								<xsl:with-param name="orderNumber" select="AUFNR" />
							</xsl:call-template>
						</manufacturingOrder>
					</xsl:if>
					<xsl:if test="string(LGORT)">
						<receivingStorageLocation>
							<xsl:value-of select="LGORT" />
						</receivingStorageLocation>
					</xsl:if>
					<xsl:if test="string(UMLGO)">
						<sourceStorageLocation>
							<xsl:value-of select="UMLGO" />
						</sourceStorageLocation>
					</xsl:if>

					<batchNumber>
						<xsl:value-of select="CHARG" />
					</batchNumber>

					<purchaseOrder>
						<xsl:call-template name="trimOrderNumberLeadingZero">
							<xsl:with-param name="orderNumber" select="E1ICIT1/EBELN" />
						</xsl:call-template>
					</purchaseOrder>

					<xsl:if test="ZE1ICIT6">
						<xsl:for-each select="ZE1ICIT6">
							<serialNumbers>
								<xsl:value-of select="SERNR" />
							</serialNumbers>
						</xsl:for-each>
					</xsl:if>

				</inventoryReceiptDTO>
			</xsl:for-each>
		</inventoryReceiptIn>
	</xsl:template>
	<xsl:template name="trimOrderNumberLeadingZero">
		<xsl:param name="orderNumber" />
		<xsl:variable name="stringValue">
			<xsl:value-of select="normalize-space($orderNumber)"/>
		</xsl:variable>
		<xsl:variable name="numberValue" select='string(format-number($stringValue, "#"))'/>
		<xsl:choose>
			<xsl:when test="$numberValue='NaN'">
				<xsl:value-of select="$stringValue"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$numberValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getBusinessSystem">
		<xsl:value-of select="/INVCON03/IDOC/EDI_DC40/SNDPRN"/>
	</xsl:template>
</xsl:stylesheet>