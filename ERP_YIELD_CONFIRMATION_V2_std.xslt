<?xml version='1.0' ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sch="http://sap.com/xi/ME/erpcon"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/*">
        <xsl:variable name="orderId">
            <xsl:call-template name="setOrder">
                <xsl:with-param name="value" select="sch:orderNumber"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="messageId">
            <xsl:value-of select="sch:messageID"/>
        </xsl:variable>

        <CO_MES_PRODORDCONF_CREATE_TT>
            <IS_TIMETICKETS>
                <CONF_ID>
                    <xsl:value-of select="$messageId"/>
                </CONF_ID>
                <PLANT>
                    <xsl:value-of select="sch:plant"/>
                </PLANT>
                <ORDERID>
                    <xsl:value-of select="$orderId"/>
                </ORDERID>
                <xsl:if test="string(sch:sequence) and sch:sequence != 'not_defined'">
                    <SEQUENCE>
                        <xsl:call-template name="setSequence">
                            <xsl:with-param name="sequence" select="sch:sequence"/>
                        </xsl:call-template>
                    </SEQUENCE>
                </xsl:if>
                <OPERATION>
                    <xsl:value-of select="sch:reportingStep"/>
                </OPERATION>
                <PROC_START_DATE>
                    <xsl:call-template name="convertDateFormat">
                        <xsl:with-param name="date" select="sch:startDateTime"/>
                    </xsl:call-template>
                </PROC_START_DATE>
                <PROC_START_TIME>
                    <xsl:call-template name="convertTimeFormat">
                        <xsl:with-param name="time" select="sch:startDateTime"/>
                    </xsl:call-template>
                </PROC_START_TIME>
                <PROC_FIN_DATE>
                    <xsl:call-template name="convertDateFormat">
                        <xsl:with-param name="date" select="sch:completeDateTime"/>
                    </xsl:call-template>
                </PROC_FIN_DATE>
                <PROC_FIN_TIME>
                    <xsl:call-template name="convertTimeFormat">
                        <xsl:with-param name="time" select="sch:completeDateTime"/>
                    </xsl:call-template>
                </PROC_FIN_TIME>
                <xsl:choose>
                    <xsl:when test="string(sch:itemType) = ''">
                        <!-- Finish product -->
                        <YIELD>
                            <xsl:value-of select="sch:wipIdentifier/sch:quantity"/>
                        </YIELD>
                        <CONF_QUAN_UNIT>
                            <xsl:value-of select="sch:unitOfMeasure"/>
                        </CONF_QUAN_UNIT>
                        <CONF_TEXT>
                            <xsl:call-template name="abbreviateString">
                                <xsl:with-param name="str" select="concat('SFC:', sch:wipIdentifier/sch:sfc)"/>
                                <xsl:with-param name="maxWidth" select="40"/>
                            </xsl:call-template>
                        </CONF_TEXT>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Co/By -->
                        <xsl:variable name="textPrefix">
                            <xsl:choose>
                                <xsl:when test="sch:itemType = 'C'">Co SFC:</xsl:when>
                                <xsl:when test="sch:itemType = 'B'">By SFC:</xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <CONF_TEXT>
                            <xsl:call-template name="abbreviateString">
                                <xsl:with-param name="str" select="concat($textPrefix, sch:wipIdentifier/sch:sfc)"/>
                                <xsl:with-param name="maxWidth" select="40"/>
                            </xsl:call-template>
                        </CONF_TEXT>
                    </xsl:otherwise>
                </xsl:choose>
                <BATCH>
                    <xsl:value-of select="sch:batchData/sch:batchNumber"/>
                </BATCH>
                <xsl:choose>
                    <xsl:when test="sch:confirmationType = 'FINAL'">
                        <FIN_CONF>X</FIN_CONF>
                    </xsl:when>
                    <xsl:when test="sch:confirmationType = 'AUTO'">
                        <FIN_CONF>1</FIN_CONF>
                    </xsl:when>
                    <xsl:otherwise>
                        <FIN_CONF/>
                    </xsl:otherwise>
                </xsl:choose>
                <CLEAR_RES>X</CLEAR_RES>
                <WORK_CNTR>
                    <xsl:value-of select="sch:workCenter"/>
                </WORK_CNTR>
                <EX_CREATED_BY>
                    <xsl:value-of select="sch:enteredByExternalUser"/>
                </EX_CREATED_BY>
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

            <xsl:if test="sch:rework = 'true'">
                <IV_2ND_TIME_CONFIRMATION>X</IV_2ND_TIME_CONFIRMATION>
            </xsl:if>

            <xsl:if test="sch:erpComponentsOption = 'onlyNonBackflushed' or sch:erpComponentsOption = 'ONLY_NON_BACKFLUSHED'">
                <IV_PROPOSE_BACKFLUSH>X</IV_PROPOSE_BACKFLUSH>
            </xsl:if>

            <IT_GOODSMVT_SERIALNUMBER>
                <xsl:choose>
                    <xsl:when test="string(sch:itemType) = ''">
                        <!-- Normal SFC complete -->
                        <xsl:choose>
                            <xsl:when test="(sch:batchData/sch:isLastReportingStep = 'true') and not(sch:rework = 'true') and not(sch:isEwmIntegrationActive = 'true') and not(sch:disableGoodsReceipt = 'true')">
                                <!-- Last step, goods movement will contain finish product and components -->
                                <xsl:if test="sch:wipIdentifier/sch:serialNumber != ''">
                                    <item>
                                        <MATDOC_ITM>1</MATDOC_ITM>
                                        <SERIALNO>
                                            <xsl:value-of select="sch:wipIdentifier/sch:serialNumber"/>
                                        </SERIALNO>
                                        <UII/>
                                    </item>
                                </xsl:if>
                                <!-- Index starts from 2 -->
                                <xsl:for-each select="sch:erpComponent[not(sch:ewmManagedComponent = 'true')]">
                                    <xsl:variable name="componentIndex" select="position() + 1"/>
                                    <xsl:if test="sch:erpSerialNumber != ''">
                                        <item>
                                            <MATDOC_ITM>
                                                <xsl:value-of select="$componentIndex"/>
                                            </MATDOC_ITM>
                                            <SERIALNO>
                                                <xsl:value-of select="sch:erpSerialNumber"/>
                                            </SERIALNO>
                                            <UII/>
                                        </item>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- only erpComponents are provided, index starts from 1 -->
                                <xsl:for-each select="sch:erpComponent[not(sch:ewmManagedComponent = 'true')]">
                                    <xsl:variable name="componentIndex" select="position()"/>
                                    <xsl:if test="sch:erpSerialNumber != ''">
                                        <item>
                                            <MATDOC_ITM>
                                                <xsl:value-of select="$componentIndex"/>
                                            </MATDOC_ITM>
                                            <SERIALNO>
                                                <xsl:value-of select="sch:erpSerialNumber"/>
                                            </SERIALNO>
                                            <UII/>
                                        </item>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="sch:itemType = 'C' or sch:itemType = 'B'">
                        <!-- Co/By -->
                        <xsl:if test="(sch:batchData/sch:isLastReportingStep = 'true') and not(sch:isEwmIntegrationActive = 'true') and not(sch:disableGoodsReceipt = 'true') and sch:wipIdentifier/sch:serialNumber != ''">
                            <item>
                                <MATDOC_ITM>1</MATDOC_ITM>
                                <SERIALNO>
                                    <xsl:value-of select="sch:wipIdentifier/sch:serialNumber"/>
                                </SERIALNO>
                                <UII/>
                            </item>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </IT_GOODSMVT_SERIALNUMBER>

            <IT_GOODSMOVEMENTS>
                <xsl:choose>
                    <xsl:when test="string(sch:itemType) = ''">
                        <!-- Normal SFC complete -->
                        <xsl:if test="(sch:batchData/sch:isLastReportingStep = 'true') and not(sch:rework = 'true') and not(sch:isEwmIntegrationActive = 'true') and not(sch:disableGoodsReceipt = 'true')">
                            <!-- Last step, finish product 101 -->
                            <item>
                                <CONF_ID>
                                    <xsl:value-of select="$messageId"/>
                                </CONF_ID>
                                <MVT_IND>F</MVT_IND>
                                <ORDERID>
                                    <xsl:value-of select="$orderId"/>
                                </ORDERID>
                                <ORDER_ITNO>0001</ORDER_ITNO> <!-- 0001 for finish product -->
                                <xsl:call-template name="setMaterial">
                                    <xsl:with-param name="value" select="sch:material/sch:material"/>
                                </xsl:call-template>
                                <PLANT>
                                    <xsl:value-of select="sch:plant"/>
                                </PLANT>
                                <STGE_LOC>
                                    <xsl:value-of select="sch:storageLocation"/>
                                </STGE_LOC>
                                <MOVE_TYPE>101</MOVE_TYPE>
                                <ENTRY_QNT>
                                    <xsl:value-of select="sch:wipIdentifier/sch:quantity"/>
                                </ENTRY_QNT>
                                <ENTRY_UOM>
                                    <xsl:value-of select="sch:unitOfMeasure"/>
                                </ENTRY_UOM>
                                <BATCH>
                                    <xsl:value-of select="sch:batchData/sch:batchNumber"/>
                                </BATCH>
                                <ACTIVITY>
                                    <xsl:value-of select="sch:reportingStep"/>
                                </ACTIVITY>
                            </item>
                        </xsl:if>
                        <!-- In case erpComponents are provided, good issue (261) needs to be performed -->
                        <xsl:for-each select="sch:erpComponent[not(sch:ewmManagedComponent = 'true')]">
                            <item>
                                <CONF_ID>
                                    <xsl:value-of select="$messageId"/>
                                </CONF_ID>
                                <ORDERID>
                                    <xsl:value-of select="$orderId"/>
                                </ORDERID>
                                <xsl:call-template name="setMaterial">
                                    <xsl:with-param name="value" select="sch:material/sch:material"/>
                                </xsl:call-template>
                                <PLANT>
                                    <xsl:value-of select="../sch:plant"/>
                                </PLANT>
                                <STGE_LOC>
                                    <xsl:value-of select="sch:storageLocation"/>
                                </STGE_LOC>
                                <MOVE_TYPE>261</MOVE_TYPE>
                                <ENTRY_QNT>
                                    <xsl:value-of select="sch:quantity"/>
                                </ENTRY_QNT>
                                <ENTRY_UOM>
                                    <xsl:value-of select="sch:unitOfMeasure"/>
                                </ENTRY_UOM>
                                <BATCH>
                                    <xsl:value-of select="sch:batchNumber"/>
                                </BATCH>
                                <ACTIVITY>
                                    <xsl:value-of select="sch:reportingStep"/>
                                </ACTIVITY>
                                <RES_ITEM>
                                    <xsl:value-of select="sch:reservationItemNumber"/>
                                </RES_ITEM>
                                <RESERV_NO>
                                    <xsl:value-of select="sch:reservationOrderNumber"/>
                                </RESERV_NO>
                            </item>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="sch:itemType = 'C' or sch:itemType = 'B'">
                        <!-- Co/By -->
                        <xsl:if test="(sch:batchData/sch:isLastReportingStep = 'true') and not(sch:isEwmIntegrationActive = 'true') and not(sch:disableGoodsReceipt = 'true')">
                            <item>
                                <CONF_ID>
                                    <xsl:value-of select="$messageId"/>
                                </CONF_ID>
                                <ORDERID>
                                    <xsl:value-of select="$orderId"/>
                                </ORDERID>
                                <xsl:call-template name="setMaterial">
                                    <xsl:with-param name="value" select="sch:material/sch:material"/>
                                </xsl:call-template>
                                <PLANT>
                                    <xsl:value-of select="sch:plant"/>
                                </PLANT>
                                <STGE_LOC>
                                    <xsl:value-of select="sch:storageLocation"/>
                                </STGE_LOC>
                                <ENTRY_QNT>
                                    <xsl:value-of select="sch:wipIdentifier/sch:quantity"/>
                                </ENTRY_QNT>
                                <ENTRY_UOM>
                                    <xsl:value-of select="sch:unitOfMeasure"/>
                                </ENTRY_UOM>
                                <BATCH>
                                    <xsl:value-of select="sch:batchData/sch:batchNumber"/>
                                </BATCH>
                                <xsl:choose>
                                    <xsl:when test="sch:itemType = 'C'">
                                        <MVT_IND>F</MVT_IND>
                                        <ORDER_ITNO>
                                            <xsl:value-of select="sch:itemNumber"/>
                                        </ORDER_ITNO>
                                        <MOVE_TYPE>101</MOVE_TYPE>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MOVE_TYPE>531</MOVE_TYPE>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <ACTIVITY>
                                    <xsl:value-of select="sch:reportingStep"/>
                                </ACTIVITY>
                            </item>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </IT_GOODSMOVEMENTS>

        </CO_MES_PRODORDCONF_CREATE_TT>
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
                        <xsl:value-of select="substring($POValueLong, (string-length($POValueLong) - 11), 12)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="setMaterial">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="string-length($value) > 18">
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
    </xsl:template>

    <xsl:template name="convertDateFormat">
        <xsl:param name="date"/> <!-- 2017-04-13T00:00:00 -->
        <xsl:value-of select="substring($date, 1, 10)"/>
    </xsl:template>

    <xsl:template name="convertTimeFormat">
        <xsl:param name="time"/> <!-- 15:51:04 -->
        <xsl:choose>
            <xsl:when test="contains($time,'T')">
                <xsl:value-of select="substring($time,12,8)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$time"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="abbreviateString">
        <xsl:param name="str"/>
        <xsl:param name="maxWidth"/>
        <xsl:choose>
            <xsl:when test="string-length($str) > $maxWidth">
                <xsl:value-of select="concat(substring($str, 1, $maxWidth - 3), '...')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="setSequence">
        <xsl:param name="sequence"/>
        <xsl:variable name="sequenceString" select="normalize-space($sequence)"/>
        <xsl:variable name="mask" select="'000000'"/>
        <xsl:variable name="sequenceNumber" select="string(number($sequenceString))"/>
        <xsl:choose>
            <xsl:when test="$sequenceNumber = 'NaN'">
                <xsl:value-of select="$sequenceString"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number(xs:decimal($sequenceString), $mask)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>