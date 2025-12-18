<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/sch:maintainInventoryRequest">
        <xsl:variable name="site">
            <xsl:call-template name="setValue">
                <xsl:with-param name="value" select="sch:site"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="orderId">
            <xsl:call-template name="setOrder">
                <xsl:with-param name="value" select="sch:shopOrderRef/sch:shopOrder"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="salesOrderId">
            <xsl:call-template name="setSalesOrder">
                <xsl:with-param name="value" select="sch:salesOrder"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="reasonCode">
            <xsl:value-of select="sch:reasonCodeRef/sch:reasonCode"/>
        </xsl:variable>
        <xsl:variable name="inventoryId">
            <xsl:value-of select="sch:inventoryId"/>
        </xsl:variable>
        <xsl:variable name="serialNumber">
            <xsl:value-of select="sch:serialNumber"/>
        </xsl:variable>
        <xsl:variable name="moveType">
            <xsl:choose>
                <xsl:when test="starts-with($reasonCode,'RTN-')">
                    <xsl:choose>
                        <xsl:when test="string(sch:shopOrderRef/sch:shopOrder)">
                            <xsl:value-of select="262"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="312"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="starts-with($reasonCode,'SCR-')">
                    <xsl:value-of select="551"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <BAPI_GOODSMVT_CREATE>
            <GOODSMVT_CODE>
                <xsl:choose>
                    <xsl:when test="$moveType='262'">
                        <GM_CODE>06</GM_CODE>
                    </xsl:when>
                    <xsl:when test="$moveType='312'">
                        <GM_CODE>04</GM_CODE>
                    </xsl:when>
                    <xsl:when test="$moveType='551'">
                        <GM_CODE>03</GM_CODE>
                    </xsl:when>
                </xsl:choose>
            </GOODSMVT_CODE>
            <GOODSMVT_HEADER>
                <PSTNG_DATE>
                    <xsl:value-of select="sch:dateTime"/>
                </PSTNG_DATE>
                <DOC_DATE>
                    <xsl:value-of select="sch:dateTime"/>
                </DOC_DATE>
            </GOODSMVT_HEADER>
            <GOODSMVT_ITEM>
                <!-- Do GM 262 before doing 551 if shop order is present -->
                <xsl:if test="$moveType='551' and string($orderId)">
                    <item>
                        <xsl:call-template name="setMaterial">
                            <xsl:with-param name="value" select="sch:itemRef/sch:item"/>
                            <xsl:with-param name="tagName"  select="'MATERIAL'" />
                        </xsl:call-template>
                        <PLANT>
                            <xsl:value-of select="$site"/>
                        </PLANT>
                        <STGE_LOC><xsl:value-of select="sch:centralStorageLocation"/></STGE_LOC>
                        <BATCH>
                            <xsl:value-of select="sch:batchNumber"/>
                        </BATCH>
                        <ENTRY_QNT>
                            <xsl:value-of select="sch:quantity"/>
                        </ENTRY_QNT>
                        <ENTRY_UOM>
                            <xsl:value-of select="sch:unitOfMeasure"/>
                        </ENTRY_UOM>
                        <ORDERID><xsl:value-of select="$orderId"/></ORDERID>
                        <SPEC_STOCK><xsl:value-of select="sch:inventorySpecialStockType"/></SPEC_STOCK>
                        <SALES_ORD><xsl:value-of select="$salesOrderId"/></SALES_ORD>
                        <VAL_SALES_ORD><xsl:value-of select="$salesOrderId"/></VAL_SALES_ORD>
                        <S_ORD_ITEM><xsl:value-of select="sch:salesOrderItem"/></S_ORD_ITEM>
                        <VAL_S_ORD_ITEM><xsl:value-of select="sch:salesOrderItem"/></VAL_S_ORD_ITEM>
                        <MOVE_TYPE>262</MOVE_TYPE>
                    </item>
                </xsl:if>
                <item>
                    <xsl:call-template name="setMaterial">
                        <xsl:with-param name="value" select="sch:itemRef/sch:item"/>
                        <xsl:with-param name="tagName"  select="'MATERIAL'" />
                    </xsl:call-template>
                    <PLANT>
                        <xsl:value-of select="$site"/>
                    </PLANT>                        
                    <xsl:choose>
                        <xsl:when test="$moveType='312'">
                             <STGE_LOC><xsl:value-of select="sch:centralStorageLocation"/></STGE_LOC>
                        </xsl:when>
                        <xsl:when test="$moveType='551' and not(string($orderId))">
                             <STGE_LOC><xsl:value-of select="sch:floorStorageLocation"/></STGE_LOC>
                        </xsl:when>
                        <xsl:otherwise>
                             <STGE_LOC><xsl:value-of select="sch:centralStorageLocation"/></STGE_LOC>
                        </xsl:otherwise>
                    </xsl:choose>
                    <BATCH>
                        <xsl:value-of select="sch:batchNumber"/>
                    </BATCH>
                    <ENTRY_QNT>
                        <xsl:value-of select="sch:quantity"/>
                    </ENTRY_QNT>
                    <ENTRY_UOM>
                        <xsl:value-of select="sch:unitOfMeasure"/>
                    </ENTRY_UOM>
                    <SPEC_STOCK><xsl:value-of select="sch:inventorySpecialStockType"/></SPEC_STOCK>
                    <SALES_ORD><xsl:value-of select="$salesOrderId"/></SALES_ORD>
                    <VAL_SALES_ORD><xsl:value-of select="$salesOrderId"/></VAL_SALES_ORD>
                    <S_ORD_ITEM><xsl:value-of select="sch:salesOrderItem"/></S_ORD_ITEM>
                    <VAL_S_ORD_ITEM><xsl:value-of select="sch:salesOrderItem"/></VAL_S_ORD_ITEM>
                    <xsl:choose>
                        <xsl:when test="$moveType='262'">
                            <ORDERID>
                                <xsl:value-of select="$orderId"/>
                            </ORDERID>
                        </xsl:when>
                        <xsl:when test="$moveType='312'">
                            <xsl:call-template name="setMaterial">
                                <xsl:with-param name="value" select="sch:itemRef/sch:item"/>
                                <xsl:with-param name="tagName"  select="'MOVE_MAT'" />
                            </xsl:call-template>
                            <MOVE_PLANT>
                                <xsl:value-of select="$site"/>
                            </MOVE_PLANT>
                            <MOVE_STLOC><xsl:value-of select="sch:floorStorageLocation"/></MOVE_STLOC>
                        </xsl:when>
                        <xsl:when test="$moveType='551'">
                            <COSTCENTER>
                                <xsl:call-template name="setCostCenter">
                                    <xsl:with-param name="value" select="sch:costCenter"/>
                                </xsl:call-template>
                            </COSTCENTER>
                        </xsl:when>
                    </xsl:choose>
                    <MOVE_TYPE>
                        <xsl:value-of select="$moveType"/>
                    </MOVE_TYPE>
                </item>
            </GOODSMVT_ITEM>
            <EXTENSIONIN>
                <item>
                    <STRUCTURE>MKPF-MES_INVENTORY_ID</STRUCTURE>
                    <VALUEPART1><xsl:value-of select="concat(sch:dateTime, '-', sch:itemRef/sch:item)"/></VALUEPART1>
                </item>
            </EXTENSIONIN>
            <xsl:if test="string($serialNumber)">
                <GOODSMVT_SERIALNUMBER>
                    <item>
                        <MATDOC_ITM>0001</MATDOC_ITM>
                        <SERIALNO>
                            <xsl:value-of select="$serialNumber"/>
                        </SERIALNO>
                    </item>
                    <xsl:if test="$moveType='551' and string($orderId)">
                        <item>
                            <MATDOC_ITM>0002</MATDOC_ITM>
                            <SERIALNO>
                                <xsl:value-of select="$serialNumber"/>
                            </SERIALNO>
                        </item>
                    </xsl:if>
                </GOODSMVT_SERIALNUMBER>
            </xsl:if>
        </BAPI_GOODSMVT_CREATE>
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
                <xsl:variable name="POValueLong" select="concat('000000000000', $value)"/>
                <xsl:value-of select="substring($POValueLong, (string-length($POValueLong)-11), 12)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="setSalesOrder">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="string($value)">
                <xsl:variable name="salesOrderValueLong" select="concat('0000000000', $value)"/>
                <xsl:value-of select="substring($salesOrderValueLong, (string-length($salesOrderValueLong)-9), 10)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="setCostCenter">
        <xsl:param name="value" />
            <xsl:variable name="costCenterString" select="normalize-space($value)"/>
            <xsl:variable name="costCenterNumber" select="string(number($costCenterString))"/>
            <xsl:choose>
                <xsl:when test="$costCenterNumber='NaN'">
                    <xsl:value-of select="$costCenterString"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="CCValueLong" select="concat('0000000000', $costCenterNumber)"/>
                    <xsl:value-of select="substring($CCValueLong, (string-length($CCValueLong)-9), 10)"/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    <xsl:template name="setMaterial">
        <xsl:param name="value"/>
        <xsl:param name="tagName"/>
        <xsl:choose>
            <xsl:when test="//SupportedPlant/ErpServerMode='EXT_MAT_NUM_ON'">
                <xsl:element name="{concat($tagName, '_LONG')}">
                    <xsl:value-of select="$value"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string-length($value)>18">
                        <xsl:element name="{concat($tagName, '_LONG')}">
                            <xsl:value-of select="$value"/>
                        </xsl:element>                  
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{$tagName}">
                            <xsl:value-of select="$value"/>
                        </xsl:element>  
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
