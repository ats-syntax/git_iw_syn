<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <urn:BAPI_GOODSMVT_CREATE xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <GOODSMVT_CODE>
                <GM_CODE>
                    <xsl:value-of select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/GoodsMovementCode"/>
                </GM_CODE>
            </GOODSMVT_CODE>
            <GOODSMVT_HEADER>
                <PSTNG_DATE>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date"
                                        select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/PostingDate"/>
                    </xsl:call-template>
                </PSTNG_DATE>
                <DOC_DATE>
                    <xsl:call-template name="convertODataDateFormat">
                        <xsl:with-param name="date"
                                        select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/DocumentDate"/>
                    </xsl:call-template>
                </DOC_DATE>
                <REF_DOC_NO>
                    <xsl:value-of select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/ReferenceDocument"/>
                </REF_DOC_NO>
                <BILL_OF_LADING/>
                <GR_GI_SLIP_NO/>
                <PR_UNAME>
                    <xsl:value-of select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/CreatedByUser"/>
                </PR_UNAME>
                <HEADER_TXT>
                    <xsl:value-of
                            select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/MaterialDocumentHeaderText"/>
                </HEADER_TXT>
                <VER_GR_GI_SLIP>
                    <xsl:value-of
                            select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/VersionForPrintingSlip"/>
                </VER_GR_GI_SLIP>
                <VER_GR_GI_SLIPX/>
                <EXT_WMS/>
                <REF_DOC_NO_LONG>
                    <xsl:value-of select="A_MaterialDocumentHeader/A_MaterialDocumentHeaderType/ReferenceDocument"/>
                </REF_DOC_NO_LONG>
                <BILL_OF_LADING_LONG/>
                <BAR_CODE/>
            </GOODSMVT_HEADER>
            <GOODSMVT_REF_EWM>
                <REF_DOC_EWM/>
                <LOGSYS/>
                <GTS_SCRAP_NO/>
            </GOODSMVT_REF_EWM>
            <TESTRUN/>
            <EXTENSIONIN>
                <xsl:for-each select="/">
                    <item>
                        <STRUCTURE/>
                        <VALUEPART1/>
                        <VALUEPART2/>
                        <VALUEPART3/>
                        <VALUEPART4/>
                    </item>
                </xsl:for-each>
            </EXTENSIONIN>
            <GOODSMVT_ITEM>
                <xsl:for-each select="//A_MaterialDocumentItemType">
                    <item>
                        <xsl:choose>
                            <xsl:when test="string-length(Material) &lt;= 18">
                                <MATERIAL>
                                    <xsl:value-of select="Material"/>
                                </MATERIAL>
                            </xsl:when>
                            <xsl:otherwise>
                                <MATERIAL_LONG>
                                    <xsl:value-of select="Material"/>
                                </MATERIAL_LONG>
                            </xsl:otherwise>
                        </xsl:choose>
                        <PLANT>
                            <xsl:value-of select="Plant"/>
                        </PLANT>
                        <STGE_LOC>
                            <xsl:value-of select="StorageLocation"/>
                        </STGE_LOC>
                        <BATCH>
                            <xsl:value-of select="Batch"/>
                        </BATCH>
                        <MOVE_TYPE>
                            <xsl:value-of select="GoodsMovementType"/>
                        </MOVE_TYPE>
                        <STCK_TYPE>
                            <xsl:value-of select="InventoryStockType"/>
                        </STCK_TYPE>
                        <SPEC_STOCK>
                            <xsl:value-of select="InventorySpecialStockType"/>
                        </SPEC_STOCK>
                        <VENDOR>
                            <xsl:value-of select="Supplier"/>
                        </VENDOR>
                        <CUSTOMER>
                            <xsl:value-of select="Customer"/>
                        </CUSTOMER>
                        <SALES_ORD>
                            <xsl:value-of select="SalesOrder"/>
                        </SALES_ORD>
                        <S_ORD_ITEM>
                            <xsl:value-of select="SalesOrderItem"/>
                        </S_ORD_ITEM>
                        <SCHED_LINE>
                            <xsl:value-of select="SalesOrderScheduleLine"/>
                        </SCHED_LINE>
                        <VAL_TYPE>
                            <xsl:value-of select="InventoryValuationType"/>
                        </VAL_TYPE>
                        <ENTRY_QNT>
                            <xsl:value-of select="QuantityInEntryUnit"/>
                        </ENTRY_QNT>
                        <ENTRY_UOM>
                            <xsl:value-of select="EntryUnit"/>
                        </ENTRY_UOM>
                        <ENTRY_UOM_ISO/>
                        <PO_PR_QNT/>
                        <ORDERPR_UN/>
                        <ORDERPR_UN_ISO/>
                        <PO_NUMBER>
                            <xsl:value-of select="PurchaseOrder"/>
                        </PO_NUMBER>
                        <PO_ITEM>
                            <xsl:value-of select="PurchaseOrderItem"/>
                        </PO_ITEM>
                        <SHIPPING/>
                        <COMP_SHIP/>
                        <NO_MORE_GR>
                            <xsl:value-of select="IsCompletelyDelivered"/>
                        </NO_MORE_GR>
                        <ITEM_TEXT>
                            <xsl:value-of select="MaterialDocumentItemText"/>
                        </ITEM_TEXT>
                        <GR_RCPT/>
                        <UNLOAD_PT>
                            <xsl:value-of select="UnloadingPointName"/>
                        </UNLOAD_PT>
                        <COSTCENTER>
                            <xsl:value-of select="CostCenter"/>
                        </COSTCENTER>
                        <ORDERID>
                            <xsl:call-template name="setOrder">
                                <xsl:with-param name="value" select="ManufacturingOrder"/>
                            </xsl:call-template>
                        </ORDERID>
                        <ORDER_ITNO>
                            <xsl:value-of select="ManufacturingOrderItem"/>
                        </ORDER_ITNO>
                        <CALC_MOTIVE/>
                        <ASSET_NO/>
                        <SUB_NUMBER/>
                        <RESERV_NO>
                            <xsl:value-of select="Reservation"/>
                        </RESERV_NO>
                        <RES_ITEM>
                            <xsl:value-of select="ReservationItem"/>
                        </RES_ITEM>
                        <RES_TYPE/>
                        <WITHDRAWN>
                            <xsl:value-of select="ReservationIsFinallyIssued"/>
                        </WITHDRAWN>
                        <MOVE_MAT>
                            <xsl:value-of select="IssgOrRcvgMaterial"/>
                        </MOVE_MAT>
                        <MOVE_PLANT>
                            <xsl:value-of select="IssuingOrReceivingPlant"/>
                        </MOVE_PLANT>
                        <MOVE_STLOC>
                            <xsl:value-of select="IssuingOrReceivingStorageLoc"/>
                        </MOVE_STLOC>
                        <MOVE_BATCH>
                            <xsl:value-of select="IssgOrRcvgBatch"/>
                        </MOVE_BATCH>
                        <MOVE_VAL_TYPE>
                            <xsl:value-of select="IssuingOrReceivingValType"/>
                        </MOVE_VAL_TYPE>
                        <MVT_IND>
                            <xsl:value-of select="GoodsMovementRefDocType"/>
                        </MVT_IND>
                        <MOVE_REAS>
                            <xsl:value-of select="GoodsMovementReasonCode"/>
                        </MOVE_REAS>
                        <RL_EST_KEY/>
                        <REF_DATE/>
                        <COST_OBJ>
                            <xsl:value-of select="CostObject"/>
                        </COST_OBJ>
                        <PROFIT_SEGM_NO>
                            <xsl:value-of select="ProfitabilitySegment"/>
                        </PROFIT_SEGM_NO>
                        <PROFIT_CTR>
                            <xsl:value-of select="ProfitCenter"/>
                        </PROFIT_CTR>
                        <WBS_ELEM>
                            <xsl:value-of select="WBSElement"/>
                        </WBS_ELEM>
                        <NETWORK/>
                        <ACTIVITY/>
                        <PART_ACCT/>
                        <AMOUNT_LC>
                            <xsl:value-of select="GdsMvtExtAmtInCoCodeCrcy"/>
                        </AMOUNT_LC>
                        <AMOUNT_SV>
                            <xsl:value-of select="SlsPrcAmtInclVATInCoCodeCrcy"/>
                        </AMOUNT_SV>
                        <REF_DOC_YR/>
                        <REF_DOC/>
                        <REF_DOC_IT/>
                        <EXPIRYDATE>
                            <xsl:call-template name="convertODataDateFormat">
                                <xsl:with-param name="date"
                                                select="ShelfLifeExpirationDate"/>
                            </xsl:call-template>
                        </EXPIRYDATE>
                        <PROD_DATE>
                            <xsl:call-template name="convertODataDateFormat">
                                <xsl:with-param name="date"
                                                select="ManufactureDate"/>
                            </xsl:call-template>
                        </PROD_DATE>
                        <FUND/>
                        <FUNDS_CTR/>
                        <CMMT_ITEM/>
                        <VAL_SALES_ORD>
                            <xsl:value-of select="SpecialStockIdfgSalesOrder"/>
                        </VAL_SALES_ORD>
                        <VAL_S_ORD_ITEM>
                            <xsl:value-of select="SpecialStockIdfgSalesOrderItem"/>
                        </VAL_S_ORD_ITEM>
                        <VAL_WBS_ELEM>
                            <xsl:value-of select="SpecialStockIdfgWBSElement"/>
                        </VAL_WBS_ELEM>
                        <GL_ACCOUNT>
                            <xsl:value-of select="GLAccount"/>
                        </GL_ACCOUNT>
                        <IND_PROPOSE_QUANX/>
                        <XSTOB>
                        	<xsl:if test="GoodsMovementType = '261'">X</xsl:if>
                        </XSTOB>
                        <EAN_UPC/>
                        <DELIV_NUMB_TO_SEARCH/>
                        <DELIV_ITEM_TO_SEARCH/>
                        <SERIALNO_AUTO_NUMBERASSIGNMENT/>
                        <VENDRBATCH/>
                        <STGE_TYPE/>
                        <STGE_BIN/>
                        <SU_PL_STCK_1/>
                        <ST_UN_QTYY_1/>
                        <ST_UN_QTYY_1_ISO/>
                        <UNITTYPE_1/>
                        <SU_PL_STCK_2/>
                        <ST_UN_QTYY_2/>
                        <ST_UN_QTYY_2_ISO/>
                        <UNITTYPE_2/>
                        <STGE_TYPE_PC/>
                        <STGE_BIN_PC/>
                        <NO_PST_CHGNT/>
                        <GR_NUMBER/>
                        <STGE_TYPE_ST/>
                        <STGE_BIN_ST/>
                        <MATDOC_TR_CANCEL>
                            <xsl:value-of select="ReversedMaterialDocument"/>
                        </MATDOC_TR_CANCEL>
                        <MATITEM_TR_CANCEL>
                            <xsl:value-of select="ReversedMaterialDocumentItem"/>
                        </MATITEM_TR_CANCEL>
                        <MATYEAR_TR_CANCEL>
                            <xsl:value-of select="ReversedMaterialDocumentYear"/>
                        </MATYEAR_TR_CANCEL>
                        <NO_TRANSFER_REQ/>
                        <CO_BUSPROC/>
                        <ACTTYPE/>
                        <SUPPL_VEND/>
                        <MOVE_MAT_EXTERNAL/>
                        <MOVE_MAT_GUID/>
                        <MOVE_MAT_VERSION/>
                        <FUNC_AREA>
                            <xsl:value-of select="FunctionalArea"/>
                        </FUNC_AREA>
                        <TR_PART_BA/>
                        <PAR_COMPCO/>
                        <DELIV_NUMB/>
                        <DELIV_ITEM/>
                        <NB_SLIPS/>
                        <NB_SLIPSX/>
                        <GR_RCPTX/>
                        <UNLOAD_PTX/>
                        <SPEC_MVMT/>
                        <GRANT_NBR/>
                        <CMMT_ITEM_LONG/>
                        <FUNC_AREA_LONG/>
                        <LINE_ID>
                            <xsl:value-of select="MaterialDocumentLine"/>
                        </LINE_ID>
                        <PARENT_ID>
                            <xsl:value-of select="MaterialDocumentParentLine"/>
                        </PARENT_ID>
                        <LINE_DEPTH>
                            <xsl:value-of select="HierarchyNodeLevel"/>
                        </LINE_DEPTH>
                        <QUANTITY>
                            <xsl:value-of select="QuantityInBaseUnit"/>
                        </QUANTITY>
                        <BASE_UOM>
                            <xsl:value-of select="MaterialBaseUnit"/>
                        </BASE_UOM>
                        <LONGNUM/>
                        <BUDGET_PERIOD/>
                        <EARMARKED_NUMBER/>
                        <EARMARKED_ITEM/>
                        <STK_SEGMENT/>
                        <MOVE_SEGMENT/>
                        <MOVE_MAT_LONG/>
                        <STK_SEG_LONG/>
                        <MOV_SEG_LONG/>
                        <CREATE_DELIVERY/>
                        <!-- Sample for <DataFields>, <CUSTOM_FIELD>
                            <xsl:if test="DataFields">
                                <xsl:for-each select="DataFields/DataField">
                                    <xsl:if test="string(FieldName) = 'CUSTOM_FIELD'">
                                        <CUSTOM_FIELD>
                                            <xsl:value-of select="FieldValue"/>
                                        </CUSTOM_FIELD>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                        -->
                    </item>
                </xsl:for-each>
            </GOODSMVT_ITEM>
            <GOODSMVT_SERIALNUMBER>
                <xsl:for-each
                        select="//A_SerialNumberMaterialDocumentType">
                    <item>
                        <MATDOC_ITM>
                            <xsl:value-of select="MaterialDocumentItem"/>
                        </MATDOC_ITM>
                        <SERIALNO>
                            <xsl:value-of select="SerialNumber"/>
                        </SERIALNO>
                        <UII/>
                    </item>
                </xsl:for-each>
            </GOODSMVT_SERIALNUMBER>
            <GOODSMVT_SERV_PART_DATA>
                <xsl:for-each select="/">
                    <item>
                        <LINE_ID/>
                        <RET_AUTH_NUMBER/>
                        <DELIV_NUMBER/>
                        <DELIV_ITEM/>
                        <HU_NUMBER/>
                        <INSPOUT_GUID/>
                        <EVENT/>
                        <DATE/>
                        <TIME/>
                        <ZONLO/>
                        <TIMESTAMP/>
                        <SCRAP_INDICATOR/>
                        <KEEP_QUANTITY/>
                        <GTS_STOCK_TYPE/>
                        <MOVE_GTS_STOCK_TYPE/>
                        <KEEP_QUANTITY_CONVERSION/>
                        <ZERO_QUANTITY/>
                        <NUMERATOR/>
                        <DENOMINATR/>
                        <INSP_DOC_NUMB/>
                        <PCHG_TYPE/>
                    </item>
                </xsl:for-each>
            </GOODSMVT_SERV_PART_DATA>
            <RETURN>
                <xsl:for-each select="/">
                    <item>
                        <TYPE/>
                        <ID/>
                        <NUMBER/>
                        <MESSAGE/>
                        <LOG_NO/>
                        <LOG_MSG_NO/>
                        <MESSAGE_V1/>
                        <MESSAGE_V2/>
                        <MESSAGE_V3/>
                        <MESSAGE_V4/>
                        <PARAMETER/>
                        <ROW/>
                        <FIELD/>
                        <SYSTEM/>
                    </item>
                </xsl:for-each>
            </RETURN>
        </urn:BAPI_GOODSMVT_CREATE>
    </xsl:template>
    <xsl:template name="convertODataDateFormat">
        <xsl:param name="date"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:value-of select="substring($date, 1, 10)"/>
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