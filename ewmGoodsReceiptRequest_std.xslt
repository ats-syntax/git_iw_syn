<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/ewmGoodsReceiptRequest">
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
		<_-SCWM_-MFG_RECEIVE_HUS_EXT>
			<IV_LOGSYS>
				<xsl:value-of select="ewmProgramId"/>
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
            <!-- Sample for <additionalParameters> <customField>
	            <BAPI_FIELD1>
	            	<xsl:value-of select="additionalParameters/customField1"/>
	            </BAPI_FIELD1>
	            <BAPI_FIELD2>
	            	<xsl:value-of select="additionalParameters/customField2"/>
            	</BAPI_FIELD2>
            -->
			<IT_HANDLING_UNITS>
				<xsl:choose>
					<xsl:when test="string(itemList/item/material)">
						<xsl:for-each select="itemList/item">
							<item>
								<LINE_ID>
									<xsl:value-of select="lineId"/>
								</LINE_ID>
								<MATERIAL>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="material"/>
									</xsl:call-template>
								</MATERIAL>
								<SHIP_MAT>
									<xsl:value-of select="packingMaterial"/>
								</SHIP_MAT>
								<BATCH>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="batchNumber"/>
									</xsl:call-template>
								</BATCH>
								<PROD_DATE>
									<xsl:call-template name="setDate">
										<xsl:with-param name="value" select="manufacturingDateTime"/>
									</xsl:call-template>
								</PROD_DATE>
								<HU_EXID>
									<xsl:call-template name="setHuNumber">
										<xsl:with-param name="value" select="handlingUnitNumber"/>
									</xsl:call-template>
								</HU_EXID>
								<QUANTITY>
									<xsl:value-of select="quantity"/>
								</QUANTITY>
								<UOM>
									<xsl:value-of select="unitOfMeasure"/>
								</UOM>
								<UOM_ISO>
									<xsl:value-of select="isoUnitOfMeasure"/>
								</UOM_ISO>
								<HUTYP>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="handlingUnitType"/>
									</xsl:call-template>
								</HUTYP>
								<GM_BIN>
									<xsl:call-template name="setValue">
										<xsl:with-param name="value" select="storageBin"/>
									</xsl:call-template>
								</GM_BIN>
								<!-- Sample for <additionalParameters> <customField>
									<BAPI_FIELD1>
										<xsl:value-of select="additionalParameters/customField1"/>
									</BAPI_FIELD1>
									<BAPI_FIELD2>
										<xsl:value-of select="additionalParameters/customField2"/>
									</BAPI_FIELD2>
								-->
							</item>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</IT_HANDLING_UNITS>
			<IT_SERIAL_NUMBERS>
				<xsl:choose>
					<xsl:when test="string(wipIdentifierList/wipIdentifier/serialNumber)">
						<xsl:for-each select="wipIdentifierList/wipIdentifier">
							<item>
								<LINE_ID>
									<xsl:value-of select="lineId"/>
								</LINE_ID>
								<SERIALNO>
									<xsl:value-of select="serialNumber"/>
								</SERIALNO>
							</item>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</IT_SERIAL_NUMBERS>
		</_-SCWM_-MFG_RECEIVE_HUS_EXT>
	</xsl:template>
	<xsl:template name="setDate">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="string($value)">
				<xsl:value-of select="concat(substring($value, 1, 4), substring($value, 6, 2), substring($value, 9, 2))"/>
			</xsl:when>
		</xsl:choose>
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
	<xsl:template name="setHuNumber">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="string($value) and not('---'=$value)">
				<xsl:variable name="huNumberString" select="normalize-space($value)"/>
				<xsl:variable name="huNumber" select="string(number($huNumberString))"/>
				<xsl:choose>
					<xsl:when test="$huNumber='NaN'">
						<xsl:value-of select="$huNumberString"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="huNumberValueLong" select="concat('00000000000000000000', $value)"/>
						<xsl:value-of select="substring($huNumberValueLong, (string-length($huNumberValueLong)-19), 20)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>