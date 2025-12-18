<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/*">
        <urn:BAPI_GOODSMVT_CREATE xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <GOODSMVT_CODE>
                <GM_CODE>
                    <xsl:value-of select="sch:goodsMovementCode"/>
                </GM_CODE>
            </GOODSMVT_CODE>
            <GOODSMVT_HEADER>
                <PSTNG_DATE>
                    <xsl:call-template name="convertDateFormat">
                        <xsl:with-param name="date"
                                        select="sch:postingDate"/>
                    </xsl:call-template>
                </PSTNG_DATE>
            </GOODSMVT_HEADER>
            <GOODSMVT_ITEM>
                <xsl:for-each select="/sch:erpGoodsReceiptRequest/sch:materialDocumentItem">
                    <item>
                        <xsl:choose>
                            <xsl:when test="string-length(sch:material) &lt;= 18">
                                <MATERIAL>
                                    <xsl:value-of select="sch:material"/>
                                </MATERIAL>
                            </xsl:when>
                            <xsl:otherwise>
                                <MATERIAL_LONG>
                                    <xsl:value-of select="sch:material"/>
                                </MATERIAL_LONG>
                            </xsl:otherwise>
                        </xsl:choose>
                        <PLANT>
                            <xsl:value-of select="sch:plant"/>
                        </PLANT>
                        <STGE_LOC>
                            <xsl:value-of select="sch:storageLocation"/>
                        </STGE_LOC>
                        <BATCH>
                            <xsl:value-of select="sch:batch"/>
                        </BATCH>
                        <MOVE_TYPE>
                            <xsl:value-of select="sch:goodsMovementType"/>
                        </MOVE_TYPE>
                        <SPEC_STOCK>
                            <xsl:value-of select="sch:inventorySpecialStockType"/>
                        </SPEC_STOCK>
                        <RESERV_NO>
                            <xsl:value-of select="sch:reservation"/>
                        </RESERV_NO>
                        <RES_ITEM>
                            <xsl:value-of select="sch:reservationItem"/>
                        </RES_ITEM>
                        <SALES_ORD>
                            <xsl:value-of select="sch:SalesOrder"/>
                        </SALES_ORD>
                        <S_ORD_ITEM>
                            <xsl:value-of select="sch:SalesOrderItem"/>
                        </S_ORD_ITEM>
                        <ENTRY_QNT>
                            <xsl:value-of select="sch:quantityInEntryUnit"/>
                        </ENTRY_QNT>
                        <ENTRY_UOM>
                            <xsl:value-of select="sch:entryUnit"/>
                        </ENTRY_UOM>
                        <ITEM_TEXT>
                            <xsl:value-of select="sch:materialDocumentItemText"/>
                        </ITEM_TEXT>
                        <ORDERID>
                            <xsl:call-template name="setOrder">
                                <xsl:with-param name="value" select="sch:manufacturingOrder"/>
                            </xsl:call-template>
                        </ORDERID>
                        <ORDER_ITNO>
                            <xsl:value-of select="sch:manufacturingOrderItem"/>
                        </ORDER_ITNO>
                        <MVT_IND>
                            <xsl:value-of select="sch:goodsMovementRefDocType"/>
                        </MVT_IND>
                        <PROD_DATE>
                            <xsl:call-template name="convertDateFormat">
                                <xsl:with-param name="date"
                                                select="sch:manufactureDate"/>
                            </xsl:call-template>
                        </PROD_DATE>
                        <XSTOB>
                            <xsl:if test="sch:goodsMovementType = '261'">X</xsl:if>
                        </XSTOB>
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

                        <!-- Sample for <PARALLEL_UNIT>, <QUANTITY_IN_PARALLEL_UNIT>, <TRANSACTIONID> only if you want to use a second Unit of Measure                        
                        <xsl:if test="normalize-space(//sch:quantityInParallelUnit) != ''">
                            <QUANTITY_IN_PARALLEL_UNIT>
                                <xsl:value-of select="sch:quantityInParallelUnit"/>
                            </QUANTITY_IN_PARALLEL_UNIT>
                        </xsl:if>

                        <xsl:if test="normalize-space(//sch:parallelUnit) != ''">
                            <PARALLEL_UNIT>
                                <xsl:value-of select="sch:parallelUnit"/>
                            </PARALLEL_UNIT>
                        </xsl:if>

                        <xsl:if test="normalize-space(//sch:transactionId) != ''">
                            <TRANSACTIONID>
                                <xsl:value-of select="sch:transactionId"/>
                            </TRANSACTIONID>
                        </xsl:if> -->

                    </item>
                </xsl:for-each>
            </GOODSMVT_ITEM>
            <GOODSMVT_SERIALNUMBER>
                <xsl:for-each
                        select="/sch:erpGoodsReceiptRequest/sch:materialDocumentItem/sch:serialNumber">
                    <item>
                        <MATDOC_ITM>
                            <xsl:value-of select="sch:materialDocumentItem"/>
                        </MATDOC_ITM>
                        <SERIALNO>
                            <xsl:value-of select="sch:serialNumber"/>
                        </SERIALNO>
                        <UII/>
                    </item>
                </xsl:for-each>
            </GOODSMVT_SERIALNUMBER>
        </urn:BAPI_GOODSMVT_CREATE>
    </xsl:template>
    <xsl:template name="convertDateFormat">
        <xsl:param name="date"/> <!-- 2024-12-12T23:00:00.000Z -->
        <xsl:value-of select="substring($date, 1, 10)"/>
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