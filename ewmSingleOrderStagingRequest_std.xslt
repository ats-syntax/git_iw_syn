<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<xsl:variable name="plant">
			<xsl:call-template name="setValue">
				<xsl:with-param name="value" select="plant"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="shopOrder">
			<xsl:call-template name="setOrder">
				<xsl:with-param name="value" select="shopOrder"/>
			</xsl:call-template>
		</xsl:variable>
	<_-SCWM_-MFG_STAGE_EXT>
		<IV_LOGSYS>
			<xsl:value-of select="ewmProgramId" />
		</IV_LOGSYS>
		<IV_PLANT>
			<xsl:value-of select="$plant" />
		</IV_PLANT>
		<IV_WHS_NO>
			<xsl:call-template name="setValue">
				<xsl:with-param name="value" select="warehouseNumber" />
			</xsl:call-template>
		</IV_WHS_NO>
		<IT_STAGE_SINGLE>
			<xsl:choose>
				<xsl:when test="string(ewmStagingComponents/ewmStagingComponent)">
					<xsl:for-each select="ewmStagingComponents/ewmStagingComponent">
						<item>
							<ORDER_NUMBER>
								<xsl:value-of select="$shopOrder" />
							</ORDER_NUMBER>
							<RESERVATION_ITEM>
								<xsl:call-template name="setValue">
									<xsl:with-param name="value" select="reservationItemNumber" />
								</xsl:call-template>
							</RESERVATION_ITEM>
							<QUANTITY>
								<xsl:call-template name="setValue">
									<xsl:with-param name="value" select="quantity" />
								</xsl:call-template>
							</QUANTITY>
							<UOM>
								<xsl:value-of select="unitOfMeasure" />
							</UOM>
						</item>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</IT_STAGE_SINGLE>
	</_-SCWM_-MFG_STAGE_EXT>
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
</xsl:stylesheet>
