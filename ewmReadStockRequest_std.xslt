<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/ewmReadStockRequest">
		<_-SCWM_-MFG_READ_STOCK_EXT xmlns="http://sap.com/xi/ME/erpcon">
			<IV_HU_EXID>
				<xsl:value-of select="handlingUnitNumber"/>
			</IV_HU_EXID>
			<IV_LOGSYS>
				<xsl:value-of select="erpLogicalSystem"/>
			</IV_LOGSYS>
			<IV_PLANT>
				<xsl:value-of select="plant"/>
			</IV_PLANT>
			<IV_ORDER_NUMBER>
				<xsl:value-of select="shopOrder"/>
			</IV_ORDER_NUMBER>
			<IV_SUPPLY_AREA>
				<xsl:value-of select="productionSupplyArea"/>
			</IV_SUPPLY_AREA>
			<IV_WHS_NO>
				<xsl:value-of select="warehouseNumber"/>
			</IV_WHS_NO>
			<IV_MATNR>
				<xsl:value-of select="material"/>
			</IV_MATNR>
		</_-SCWM_-MFG_READ_STOCK_EXT>
	</xsl:template>
</xsl:stylesheet>