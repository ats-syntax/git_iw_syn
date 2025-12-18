<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/A_EwmGoodsMovementDocument/A_EwmGoodsMovementDocumentType">
		<xsl:variable name="plant">
			<xsl:call-template name="setValue">
				<xsl:with-param name="value" select="Plant"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="orderId">
			<xsl:call-template name="setOrder">
				<xsl:with-param name="value" select="OrderNumber"/>
			</xsl:call-template>
		</xsl:variable>
		<_-SCWM_-MFG_REVERSE_ITEMS_EXT>
			<IV_LOGSYS>
				<xsl:call-template name="setValue">
					<xsl:with-param name="value" select="LogicalSystemId"/>
				</xsl:call-template>
			</IV_LOGSYS>
			<IV_ORDER_NUMBER>
				<xsl:value-of select="$orderId"/>
			</IV_ORDER_NUMBER>
			<IV_PLANT>
				<xsl:value-of select="$plant"/>
			</IV_PLANT>
			<IV_WHS_NO>
				<xsl:call-template name="setValue">
					<xsl:with-param name="value" select="WarehouseNumber"/>
				</xsl:call-template>
			</IV_WHS_NO>
			<IT_ITEMS>
				<xsl:choose>
					<xsl:when test="string(EwmGoodsMovementDocumentItems/A_EwmGoodsMovementDocumentItemType)">
						<xsl:for-each select="EwmGoodsMovementDocumentItems/A_EwmGoodsMovementDocumentItemType">
							<xsl:variable name="seqCounter" select="position()"/>
							<item>
								<LINE_ID>
									<xsl:number value="$seqCounter" format="0000000001"/>
								</LINE_ID>
								<MATERIAL>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="Material"/>
									</xsl:call-template>
								</MATERIAL>

								<xsl:if test="string(ReservationItem) and string(ReservationNumber)">
								<RESERVATION_NUMBER>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="ReservationNumber"/>
									</xsl:call-template>
								</RESERVATION_NUMBER>
								<RESERVATION_ITEM>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="ReservationItem"/>
									</xsl:call-template>
								</RESERVATION_ITEM>
								</xsl:if>

								<SUPPLY_AREA>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="ProductionSupplyArea"/>
									</xsl:call-template>
								</SUPPLY_AREA>
								<BATCH>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="Batch"/>
									</xsl:call-template>
								</BATCH>
								<QUANTITY>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="Quantity"/>
									</xsl:call-template>
								</QUANTITY>
								<BASE_UOM>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="Uom"/>
									</xsl:call-template>
								</BASE_UOM>
								<BASE_UOM_ISO>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="Uom"/>
									</xsl:call-template>
								</BASE_UOM_ISO>
								<GM_BIN>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="ProductionSupplyAreaBin"/>
									</xsl:call-template>
								</GM_BIN>
								<xsl:if test="IsDynamic">
									<IS_DYNAMIC>
										<xsl:call-template name="convertODataBool">
											<xsl:with-param name="bool" select="IsDynamic"/>
										</xsl:call-template>
									</IS_DYNAMIC>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="string(HandlingUnit) and string(ParentHandlingUnitNumber)">
										<HU_EXID>
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="HandlingUnit"/>
											</xsl:call-template>
										</HU_EXID>
									</xsl:when>
									<xsl:when test="string(ParentHandlingUnitNumber)">
										<HU_EXID>
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="parentHandlingUnitNumber"/>
											</xsl:call-template>
										</HU_EXID>
									</xsl:when>
									<xsl:when test="string(HandlingUnit)">
										<HU_EXID>
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="HandlingUnit"/>
											</xsl:call-template>
										</HU_EXID>
									</xsl:when>
									<xsl:otherwise>
										<HU_EXID>
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="parentHandlingUnitNumber"/>
											</xsl:call-template>
										</HU_EXID>
									</xsl:otherwise>
								</xsl:choose>
							</item>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</IT_ITEMS>
			<IT_SERIAL_NUMBERS>
				<xsl:if test="string(SerialNumbers/A_SerialNumberMaterialDocumentType)">
					<xsl:for-each select="SerialNumbers/A_SerialNumberMaterialDocumentType">
						<xsl:if test="string(SerialNumber)">
							<xsl:variable name="seqCounter" select="position()"/>
							<xsl:for-each select="SerialNumber">
								<item>
									<LINE_ID>
										<xsl:number value="$seqCounter" format="0000000001"/>
									</LINE_ID>
									<SERIALNO>
										<xsl:call-template name="setSerialNumber">
											<xsl:with-param name="value" select="."/>
										</xsl:call-template>
									</SERIALNO>
								</item>
							</xsl:for-each>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</IT_SERIAL_NUMBERS>
		</_-SCWM_-MFG_REVERSE_ITEMS_EXT>
	</xsl:template>
	<xsl:template name="setValue">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="string($value) and not('---'=$value)">
				<xsl:value-of select="$value"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="setOrder">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="string($value) and not('---'=$value)">
				<xsl:variable name="shopOrderString" select="normalize-space($value)"/>
				<xsl:variable name="shopOrderNumber" select="string(number($shopOrderString))"/>
				<xsl:choose>
					<xsl:when test="$shopOrderNumber='NaN'">
						<xsl:value-of select="$shopOrderString"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="POValueLong" select="concat('000000000000', $value)"/>
						<xsl:value-of select="substring($POValueLong, (string-length($POValueLong)-11), 12)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="setSerialNumber">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="string($value) and not('---'=$value)">
				<xsl:variable name="serialNumberString" select="normalize-space($value)"/>
				<xsl:variable name="serialNumber" select="string(number($serialNumberString))"/>
				<xsl:choose>
					<xsl:when test="$serialNumber='NaN'">
						<xsl:value-of select="$serialNumberString"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="serialNumberValueLong" select="$value"/>
						<xsl:value-of select="substring($serialNumberValueLong, (string-length($serialNumberValueLong)-17))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="convertODataBool">
		<xsl:param name="bool"/>
		<xsl:choose>
			<xsl:when test="$bool='true'">
				<xsl:value-of select="'X'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="' '"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>