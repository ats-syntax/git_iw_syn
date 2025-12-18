<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://sap.com/xi/ME/erpcon">
    <xsl:template match="/*">
        <xsl:variable name="site">
            <xsl:call-template name="setValue">
                <xsl:with-param name="value" select="sch:site/sch:site"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="orderId">
            <xsl:call-template name="setOrder">
                <xsl:with-param name="value" select="sch:orderNumber"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="messageId">
            <xsl:value-of select="sch:messageID"/>
        </xsl:variable>
        <xsl:variable name="repStep">
            <xsl:call-template name="setValue">
                <xsl:with-param name="value" select="sch:reportingStep"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="completeDateTime" select="sch:dateTime"/>
        <CO_MES_PRODORDCONF_CREATE_TT>
            <IS_TIMETICKETS>
                <PLANT>
                    <xsl:value-of select="$site"/>
                </PLANT>
                <ORDERID>
                    <xsl:value-of select="$orderId"/>
                </ORDERID>
                <OPERATION>
                    <xsl:value-of select="$repStep"/>
                </OPERATION>
                <xsl:if test="sch:reportProcessFinishDateTime='true'">
                    <PROC_FIN_DATE>
                        <xsl:value-of select="concat(substring($completeDateTime, 1, 4), substring($completeDateTime, 6, 2), substring($completeDateTime, 9, 2))" />
                    </PROC_FIN_DATE>
                    <PROC_FIN_TIME>
                        <xsl:value-of select="concat(substring($completeDateTime, 12, 2), substring($completeDateTime, 15, 2), substring($completeDateTime, 18, 2) )" />
                    </PROC_FIN_TIME>
                </xsl:if>
                <YIELD>
                    <xsl:value-of select="sum(sch:wipIdentifier/sch:quantity)"/>
                </YIELD>
                <BATCH>
                    <xsl:call-template name="setValue">
                        <xsl:with-param name="value" select="sch:batchData/sch:batchNumber"/>
                    </xsl:call-template>
                </BATCH>
                <FIN_CONF>1</FIN_CONF>
                <CLEAR_RES>X</CLEAR_RES>
                <CONF_ID>
                    <xsl:value-of select="$messageId"/>
                </CONF_ID>
                <CONF_QUAN_UNIT_ISO>
                    <xsl:value-of select="sch:unitOfMeasure"/>
                </CONF_QUAN_UNIT_ISO>
                <xsl:if test="sch:splitId">
                    <xsl:choose>
                        <xsl:when test="sch:erpCapacityCategory">
                            <CAPA_CATEGORY>
                                <xsl:value-of select="sch:erpCapacityCategory"/>
                            </CAPA_CATEGORY>
                        </xsl:when>
                        <xsl:otherwise>
                            <CAPA_CATEGORY>001</CAPA_CATEGORY>
                        </xsl:otherwise>
                    </xsl:choose>
                    <SPLIT>
                        <xsl:value-of select="sch:splitId"/>
                    </SPLIT>
                </xsl:if>
            </IS_TIMETICKETS>
            <xsl:if test="sch:rework='true'">
                <IV_2ND_TIME_CONFIRMATION>X</IV_2ND_TIME_CONFIRMATION>
            </xsl:if>
            <xsl:if test="sch:erpComponentsOption='onlyNonBackflushed' or sch:erpComponentsOption='ONLY_NON_BACKFLUSHED'">
                <IV_PROPOSE_BACKFLUSH>X</IV_PROPOSE_BACKFLUSH>
            </xsl:if>
                <xsl:if test="(sch:batchData/sch:erpCharacteristicArray/sch:erpCharacteristic/sch:name) and (sch:batchData/sch:isLastReportingStep='true') and sch:rework!='true'">
                    <IT_CHARACTERISTICS_BATCH>
                        <xsl:for-each select="sch:batchData/sch:erpCharacteristicArray/sch:erpCharacteristic">
                            <item>
                                <CHAR_NAME>
                                    <xsl:value-of select="sch:name"/>
                                </CHAR_NAME>
                                <CHAR_VALUE>
                                    <xsl:value-of select="sch:value"/>
                                </CHAR_VALUE>
                            </item>
                        </xsl:for-each>
                    </IT_CHARACTERISTICS_BATCH>
                </xsl:if>
                <xsl:if test="(string(sch:erpComponentArray/sch:erpComponent) or ((sch:batchData/sch:isLastReportingStep='true') and sch:rework!='true'))">
                    <IT_GOODSMOVEMENTS>
                        <xsl:if test="(sch:batchData/sch:isLastReportingStep='true') and sch:rework!='true' and sch:isEwmIntegrationActive!='true'">
                            <item>
                                <xsl:call-template name="setMaterial">
                                    <xsl:with-param name="value" select="sch:item/sch:item"/>
                                </xsl:call-template>
                                <PLANT>
                                    <xsl:value-of select="$site"/>
                                </PLANT>
                                <STGE_LOC>
                                    <xsl:call-template name="setValue">
                                        <xsl:with-param name="value" select="sch:storageLocation"/>
                                    </xsl:call-template>
                                </STGE_LOC>
                                <BATCH>
                                    <xsl:call-template name="setValue">
                                        <xsl:with-param name="value" select="sch:batchData/sch:batchNumber"/>
                                    </xsl:call-template>
                                </BATCH>
                                <MOVE_TYPE>101</MOVE_TYPE>
                                <ENTRY_QNT>
                                    <xsl:value-of select="sum(sch:wipIdentifier/sch:quantity)"/>
                                </ENTRY_QNT>
                                <ENTRY_UOM_ISO>
                                    <xsl:value-of select="sch:unitOfMeasure"/>
                                </ENTRY_UOM_ISO>
                                <MVT_IND>F</MVT_IND>
                                <ORDERID>
                                    <xsl:value-of select="$orderId"/>
                                </ORDERID>
                                <CONF_ID>
                                    <xsl:value-of select="$messageId"/>
                                </CONF_ID>
                            </item>
                        </xsl:if>
                        <xsl:if test="string(sch:erpComponentArray/sch:erpComponent)">
                            <xsl:for-each select="sch:erpComponentArray/sch:erpComponent">
                                <xsl:if test="string(sch:ewmManagedComponent) = '' or sch:ewmManagedComponent != 'true'">
                                <item>
                                    <xsl:call-template name="setMaterial">
                                        <xsl:with-param name="value" select="sch:item/sch:item"/>
                                    </xsl:call-template>
                                    <PLANT>
                                        <xsl:value-of select="$site"/>
                                    </PLANT>
                                    <STGE_LOC>
                                        <xsl:call-template name="setValue">
                                            <xsl:with-param name="value" select="sch:storageLocation"/>
                                        </xsl:call-template>
                                    </STGE_LOC>
                                    <BATCH>
                                        <xsl:call-template name="setValue">
                                            <xsl:with-param name="value" select="sch:batchNumber"/>
                                        </xsl:call-template>
                                    </BATCH>
                                    <MOVE_TYPE>261</MOVE_TYPE>
                                    <ENTRY_QNT>
                                        <xsl:value-of select="sch:quantity"/>
                                    </ENTRY_QNT>
                                    <ORDERID>
                                        <xsl:value-of select="$orderId"/>
                                    </ORDERID>
                                    <CONF_ID>
                                        <xsl:value-of select="$messageId"/>
                                    </CONF_ID>
                                    <xsl:choose>
                                        <xsl:when test="sch:reportingStep and sch:reportingStep != ''">
                                            <ACTIVITY>
                                                <xsl:value-of select="sch:reportingStep"/>
                                            </ACTIVITY>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <ACTIVITY>
                                                <xsl:value-of select="$repStep"/>
                                            </ACTIVITY>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </item>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </IT_GOODSMOVEMENTS>
                    <xsl:if test="(sch:batchData/sch:erpCharacteristicArray/sch:erpCharacteristic/sch:name) and (sch:batchData/sch:isLastReportingStep='true') and sch:rework!='true'">
                        <IT_LINK_GM_CHAR_BATCH>
                            <xsl:for-each select="sch:batchData/sch:erpCharacteristicArray/sch:erpCharacteristic">
                                <item>
                                    <INDEX_GOODSMVT>1</INDEX_GOODSMVT>
                                    <INDEX_CHAR_BATCH>
                                        <xsl:value-of select="position()"/>
                                    </INDEX_CHAR_BATCH>
                                </item>
                            </xsl:for-each>
                        </IT_LINK_GM_CHAR_BATCH>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="(string(sch:erpComponentArray/sch:erpComponent) or ((sch:batchData/sch:isLastReportingStep='true') and sch:rework!='true')) and sch:isEwmIntegrationActive!='true'">
                    <IT_GOODSMVT_SERIALNUMBER>
                        <xsl:choose>
                            <xsl:when test="(sch:batchData/sch:isLastReportingStep='true' and (string(sch:wipIdentifier/sch:serialNumber)) and sch:rework!='true')">
                                <xsl:for-each select="sch:wipIdentifier">
                                    <item>
                                        <MATDOC_ITM>1</MATDOC_ITM>
                                        <xsl:choose>
                                            <xsl:when test="string(sch:serialNumber)">
                                                <SERIALNO>
                                                    <xsl:value-of select="sch:serialNumber" />
                                                </SERIALNO>
                                            </xsl:when>
                                        </xsl:choose>
                                        <UII></UII>
                                    </item>
                                </xsl:for-each>
                                <xsl:if test="string(sch:erpComponentArray/sch:erpComponent)">
                                    <xsl:for-each select="sch:erpComponentArray/sch:erpComponent">
                                        <xsl:variable name="COMPONENT_INDEX" select="position()+1" />
                                        <xsl:if test="string(sch:erpSerialNumber)">
                                            <xsl:for-each select="sch:erpSerialNumber">
                                                <item>
                                                    <MATDOC_ITM>
                                                        <xsl:value-of select="$COMPONENT_INDEX" />
                                                    </MATDOC_ITM>
                                                    <SERIALNO>
                                                        <xsl:value-of select="." />
                                                    </SERIALNO>
                                                    <UII></UII>
                                                </item>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="sch:erpComponentArray/sch:erpComponent">
                                    <xsl:variable name="COMPONENT_INDEX" select="position()" />
                                    <xsl:if test="string(sch:erpSerialNumber)">
                                        <xsl:for-each select="sch:erpSerialNumber">
                                            <item>
                                                <MATDOC_ITM>
                                                    <xsl:value-of select="$COMPONENT_INDEX" />
                                                </MATDOC_ITM>
                                                <SERIALNO>
                                                    <xsl:value-of select="." />
                                                </SERIALNO>
                                                <UII></UII>
                                            </item>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </IT_GOODSMVT_SERIALNUMBER>
                </xsl:if>
        </CO_MES_PRODORDCONF_CREATE_TT>
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
    <xsl:template name="setMaterial">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="//SupportedPlant/ErpServerMode='EXT_MAT_NUM_ON'">
                <MATERIAL_LONG>
                    <xsl:value-of select="$value"/>
                </MATERIAL_LONG>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string-length($value)>18">
                        <MATERIAL_LONG>
                            <xsl:value-of select="$value"/>
                        </MATERIAL_LONG>
                    </xsl:when>
                    <xsl:otherwise>
                        <MATERIAL>
                            <xsl:value-of select="$value"/>
                        </MATERIAL>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>