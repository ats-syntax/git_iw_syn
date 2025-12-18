<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/ewmGoodsIssueRequest">
		<xsl:variable name="plant">
			<xsl:call-template name="setValue">
				<xsl:with-param name="value" select="plant"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="orderId">
			<xsl:call-template name="setOrder">
				<xsl:with-param name="value" select="orderNumber"/>
			</xsl:call-template>
		</xsl:variable>
		<_-SCWM_-MFG_CONSUME_ITEMS_EXT>
			<IV_LOGSYS>
				<xsl:choose>
					<xsl:when test="ewmProgramId">
						<xsl:call-template name="setValue">
							<xsl:with-param name="value" select="ewmProgramId"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="setValue">
							<xsl:with-param name="value" select="ewmDestination"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</IV_LOGSYS>
			<IV_ORDER_NUMBER>
				<xsl:value-of select="$orderId"/>
			</IV_ORDER_NUMBER>
			<IV_PLANT>
				<xsl:value-of select="$plant"/>
			</IV_PLANT>
			<IV_WHS_NO>
				<xsl:call-template name="setValue">
					<xsl:with-param name="value" select="warehouseNumber"/>
				</xsl:call-template>
			</IV_WHS_NO>
			<IT_ITEMS>
				<xsl:choose>
					<xsl:when test="string(components/ewmComponent)">
						<xsl:for-each select="components/ewmComponent">
							<xsl:variable name="seqCounter" select="position()"/>
							<item>
								<LINE_ID>
									<xsl:choose>
										<xsl:when test="string(lineId)">
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="lineId"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:number value="$seqCounter" format="0000000001"/>
										</xsl:otherwise>
									</xsl:choose>
								</LINE_ID>
								<MATERIAL>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="material"/>
									</xsl:call-template>
								</MATERIAL>

								<xsl:if test="string(reservationNumber) and string(reservationItemNumber)">
								<RESERVATION_NUMBER>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="reservationNumber"/>
									</xsl:call-template>
								</RESERVATION_NUMBER>
								<RESERVATION_ITEM>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="reservationItemNumber"/>
									</xsl:call-template>
								</RESERVATION_ITEM>
								</xsl:if>

								<SUPPLY_AREA>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="productionSupplyArea"/>
									</xsl:call-template>
								</SUPPLY_AREA>
								<BATCH>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="batchNumber"/>
									</xsl:call-template>
								</BATCH>
								<QUANTITY>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="quantity"/>
									</xsl:call-template>
								</QUANTITY>
								<BASE_UOM>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="unitOfMeasure"/>
									</xsl:call-template>
								</BASE_UOM>
								<BASE_UOM_ISO>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="unitOfMeasureIso"/>
									</xsl:call-template>
								</BASE_UOM_ISO>
								<GM_BIN>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="productionSupplyAreaBin"/>
									</xsl:call-template>
								</GM_BIN>
								<IS_DYNAMIC>
									<xsl:call-template name="convertODataBool">
										<xsl:with-param name="bool" select="isDynamic"/>
									</xsl:call-template>
								</IS_DYNAMIC>
								<xsl:choose>
									<xsl:when test="string(handlingUnitNumber) and string(parentHandlingUnitNumber)">
										<HU_EXID>
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="handlingUnitNumber"/>
											</xsl:call-template>
										</HU_EXID>
									</xsl:when>
									<xsl:when test="string(parentHandlingUnitNumber)">
										<HU_EXID>
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="parentHandlingUnitNumber"/>
											</xsl:call-template>
										</HU_EXID>
									</xsl:when>
									<xsl:when test="string(handlingUnitNumber)">
										<HU_EXID>
											<xsl:call-template name="setValue">
												<xsl:with-param name="value" select="handlingUnitNumber"/>
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
								<!-- Sample for <dataFields>, <CUSTOM_FIELD>
									 <xsl:if test="dataFields">
										<CUSTOM_FIELD>
											<xsl:value-of select="dataFields/CUSTOM_FIELD"/>
										</CUSTOM_FIELD>
									</xsl:if>
								-->
							</item>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</IT_ITEMS>
			<IT_SERIAL_NUMBERS>
				<xsl:choose>
					<xsl:when test="components/serialNumbers/serialNumber">
						<xsl:for-each select="components/serialNumbers/serialNumber">
							<item>
								<LINE_ID>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="lineId"/>
									</xsl:call-template>
								</LINE_ID>
								<SERIALNO>
									<xsl:call-template name="setSerialNumber">
									<xsl:with-param name="value" select="serialNumber"/>
									</xsl:call-template>
								</SERIALNO>
							</item>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="string(components/ewmComponent)">
							<xsl:for-each select="components/ewmComponent">
								<xsl:if test="string(erpSerialNumber)">
									<xsl:variable name="seqCounter" select="position()"/>
									<xsl:for-each select="erpSerialNumber">
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
					</xsl:otherwise>
				</xsl:choose>
			</IT_SERIAL_NUMBERS>
		</_-SCWM_-MFG_CONSUME_ITEMS_EXT>
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