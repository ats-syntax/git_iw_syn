<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="SAP_MessageProcessingLogID"/>

  <xsl:template match="/ProdnOrdConf2/ProdnOrdConf2Type">

    <xsl:variable name="orderId">
      <xsl:call-template name="setOrder">
        <xsl:with-param name="value" select="OrderID"/>
      </xsl:call-template>
    </xsl:variable>

    <urn:CO_MES_PRODORDCONF_CREATE_TT xmlns:urn="urn:sap-com:document:sap:rfc:functions">
      <IS_TIMETICKETS>
        <CONF_ID>
          <xsl:call-template name="messageId"/>
        </CONF_ID>
        <CONF_NO />
        <ORDERID>
          <xsl:value-of select="$orderId"/>
        </ORDERID>
        <SEQUENCE>
          <xsl:call-template name="setSequence">
            <xsl:with-param name="sequence" select="Sequence"/>
          </xsl:call-template>
        </SEQUENCE>
        <OPERATION>
          <xsl:value-of select="OrderOperation" />
        </OPERATION>
        <SUB_OPER>
          <xsl:value-of select="OrderSuboperation"/>
        </SUB_OPER>
        <CAPA_CATEGORY>
          <xsl:if test="CapacityRequirementSplit != ''">
            <xsl:choose>
              <xsl:when test="CapacityCategoryCode != ''">
                <xsl:value-of select="CapacityCategoryCode" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'001'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </CAPA_CATEGORY>
        <SPLIT>
          <xsl:if test="CapacityRequirementSplit != ''">
            <xsl:value-of select="CapacityRequirementSplit" />
          </xsl:if>
        </SPLIT>
        <FIN_CONF>
          <xsl:value-of select="FinalConfirmationType"/>
        </FIN_CONF>
        <CLEAR_RES>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="OpenReservationsIsCleared"/>
          </xsl:call-template>
        </CLEAR_RES>
        <POSTG_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="PostingDate"/>
          </xsl:call-template>
        </POSTG_DATE>
        <DEV_REASON>
          <xsl:value-of select="VarianceReasonCode" />
        </DEV_REASON>
        <CONF_TEXT>
          <xsl:value-of select="ConfirmationText" />
        </CONF_TEXT>
        <PLANT>
          <xsl:value-of select="Plant" />
        </PLANT>
        <WORK_CNTR>
          <xsl:value-of select="WorkCenter" />
        </WORK_CNTR>
        <RECORDTYPE />
        <CONF_QUAN_UNIT>
          <xsl:value-of select="ConfirmationUnitSAPCode" />
        </CONF_QUAN_UNIT>
        <CONF_QUAN_UNIT_ISO>
          <xsl:value-of select="ConfirmationUnitISOCode" />
        </CONF_QUAN_UNIT_ISO>
        <YIELD>
          <xsl:choose>
            <xsl:when test="ConfirmationYieldQuantity != ''">
              <xsl:value-of select="ConfirmationYieldQuantity" />
            </xsl:when>
            <xsl:otherwise>
              <!-- rework(me) -->
              <xsl:value-of select="ConfirmationReworkQuantity" />
            </xsl:otherwise>
          </xsl:choose>
        </YIELD>
        <SCRAP>
          <xsl:value-of select="ConfirmationScrapQuantity" />
        </SCRAP>
<!--        <REWORK>-->
<!--          <xsl:value-of select="ConfirmationReworkQuantity" />-->
<!--        </REWORK>-->
        <CONF_ACTI_UNIT1>
          <xsl:value-of select="OpWorkQuantityUnit1" />
        </CONF_ACTI_UNIT1>
        <CONF_ACTI_UNIT1_ISO>
          <xsl:value-of select="WorkQuantityUnit1ISOCode" />
        </CONF_ACTI_UNIT1_ISO>
        <CONF_ACTIVITY1>
          <xsl:value-of select="OpConfirmedWorkQuantity1" />
        </CONF_ACTIVITY1>
        <NO_REMN_ACTI1>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="NoFurtherOpWorkQuantity1IsExpd"/>
          </xsl:call-template>
        </NO_REMN_ACTI1>
        <CONF_ACTI_UNIT2>
          <xsl:value-of select="OpWorkQuantityUnit2" />
        </CONF_ACTI_UNIT2>
        <CONF_ACTI_UNIT2_ISO>
          <xsl:value-of select="WorkQuantityUnit2ISOCode" />
        </CONF_ACTI_UNIT2_ISO>
        <CONF_ACTIVITY2>
          <xsl:value-of select="OpConfirmedWorkQuantity2" />
        </CONF_ACTIVITY2>
        <NO_REMN_ACTI2>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="NoFurtherOpWorkQuantity2IsExpd"/>
          </xsl:call-template>
        </NO_REMN_ACTI2>
        <CONF_ACTI_UNIT3>
          <xsl:value-of select="OpWorkQuantityUnit3" />
        </CONF_ACTI_UNIT3>
        <CONF_ACTI_UNIT3_ISO>
          <xsl:value-of select="WorkQuantityUnit3ISOCode" />
        </CONF_ACTI_UNIT3_ISO>
        <CONF_ACTIVITY3>
          <xsl:value-of select="OpConfirmedWorkQuantity3" />
        </CONF_ACTIVITY3>
        <NO_REMN_ACTI3>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="NoFurtherOpWorkQuantity3IsExpd"/>
          </xsl:call-template>
        </NO_REMN_ACTI3>
        <CONF_ACTI_UNIT4>
          <xsl:value-of select="OpWorkQuantityUnit4" />
        </CONF_ACTI_UNIT4>
        <CONF_ACTI_UNIT4_ISO>
          <xsl:value-of select="WorkQuantityUnit4ISOCode" />
        </CONF_ACTI_UNIT4_ISO>
        <CONF_ACTIVITY4>
          <xsl:value-of select="OpConfirmedWorkQuantity4" />
        </CONF_ACTIVITY4>
        <NO_REMN_ACTI4>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="NoFurtherOpWorkQuantity4IsExpd"/>
          </xsl:call-template>
        </NO_REMN_ACTI4>
        <CONF_ACTI_UNIT5>
          <xsl:value-of select="OpWorkQuantityUnit5" />
        </CONF_ACTI_UNIT5>
        <CONF_ACTI_UNIT5_ISO>
          <xsl:value-of select="WorkQuantityUnit5ISOCode" />
        </CONF_ACTI_UNIT5_ISO>
        <CONF_ACTIVITY5>
          <xsl:value-of select="OpConfirmedWorkQuantity5" />
        </CONF_ACTIVITY5>
        <NO_REMN_ACTI5>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="NoFurtherOpWorkQuantity5IsExpd"/>
          </xsl:call-template>
        </NO_REMN_ACTI5>
        <CONF_ACTI_UNIT6>
          <xsl:value-of select="OpWorkQuantityUnit6" />
        </CONF_ACTI_UNIT6>
        <CONF_ACTI_UNIT6_ISO>
          <xsl:value-of select="WorkQuantityUnit6ISOCode" />
        </CONF_ACTI_UNIT6_ISO>
        <CONF_ACTIVITY6>
          <xsl:value-of select="OpConfirmedWorkQuantity6" />
        </CONF_ACTIVITY6>
        <NO_REMN_ACTI6>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="NoFurtherOpWorkQuantity6IsExpd"/>
          </xsl:call-template>
        </NO_REMN_ACTI6>
        <CONF_BUS_PROC_UNIT1>
          <xsl:value-of select="BusinessProcessEntryUnit" />
        </CONF_BUS_PROC_UNIT1>
        <CONF_BUS_PROC_UNIT1_ISO>
          <xsl:value-of select="BusProcessEntrUnitISOCode" />
        </CONF_BUS_PROC_UNIT1_ISO>
        <CONF_BUS_PROC1>
          <xsl:value-of select="BusinessProcessConfirmedQty" />
        </CONF_BUS_PROC1>
        <NO_REMN_BUS_PROC1>
          <xsl:call-template name="convertODataBool">
            <xsl:with-param name="bool" select="NoFurtherBusinessProcQtyIsExpd"/>
          </xsl:call-template>
        </NO_REMN_BUS_PROC1>
        <EXEC_START_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="ConfirmedExecutionStartDate"/>
          </xsl:call-template>
        </EXEC_START_DATE>
        <EXEC_START_TIME>
          <xsl:call-template name="convertODataTimeFormat">
            <xsl:with-param name="time" select="ConfirmedExecutionStartTime"/>
          </xsl:call-template>
        </EXEC_START_TIME>
        <SETUP_FIN_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="ConfirmedSetupEndDate"/>
          </xsl:call-template>
        </SETUP_FIN_DATE>
        <SETUP_FIN_TIME>
          <xsl:call-template name="convertODataTimeFormat">
            <xsl:with-param name="time" select="ConfirmedSetupEndTime"/>
          </xsl:call-template>
        </SETUP_FIN_TIME>
        <PROC_START_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="ConfirmedProcessingStartDate"/>
          </xsl:call-template>
        </PROC_START_DATE>
        <PROC_START_TIME>
          <xsl:call-template name="convertODataTimeFormat">
            <xsl:with-param name="time" select="ConfirmedProcessingStartTime"/>
          </xsl:call-template>
        </PROC_START_TIME>
        <PROC_FIN_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="ConfirmedProcessingEndDate"/>
          </xsl:call-template>
          <!-- YYYYMMDD -->
        </PROC_FIN_DATE>
        <PROC_FIN_TIME>
          <xsl:call-template name="convertODataTimeFormat">
            <xsl:with-param name="time" select="ConfirmedProcessingEndTime"/>
          </xsl:call-template>
          <!-- hhmmss -->
        </PROC_FIN_TIME>
        <TEARDOWN_START_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="ConfirmedTeardownStartDate"/>
          </xsl:call-template>
        </TEARDOWN_START_DATE>
        <TEARDOWN_START_TIME>
          <xsl:call-template name="convertODataTimeFormat">
            <xsl:with-param name="time" select="ConfirmedTeardownStartTime"/>
          </xsl:call-template>
        </TEARDOWN_START_TIME>
        <EXEC_FIN_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="ConfirmedExecutionEndDate"/>
          </xsl:call-template>
        </EXEC_FIN_DATE>
        <EXEC_FIN_TIME>
          <xsl:call-template name="convertODataTimeFormat">
            <xsl:with-param name="time" select="ConfirmedExecutionEndTime"/>
          </xsl:call-template>
        </EXEC_FIN_TIME>
        <FCST_FIN_DATE />
        <FCST_FIN_TIME />
        <STD_UNIT1 />
        <STD_UNIT1_ISO />
        <FORCAST_STD_VAL1 />
        <STD_UNIT2 />
        <STD_UNIT2_ISO />
        <FORCAST_STD_VAL2 />
        <STD_UNIT3 />
        <STD_UNIT3_ISO />
        <FORCAST_STD_VAL3 />
        <STD_UNIT4 />
        <STD_UNIT4_ISO />
        <FORCAST_STD_VAL4 />
        <STD_UNIT5 />
        <STD_UNIT5_ISO />
        <FORCAST_STD_VAL5 />
        <STD_UNIT6 />
        <STD_UNIT6_ISO />
        <FORCAST_STD_VAL6 />
        <FORCAST_BUS_PROC_UNIT1 />
        <FORC_BUS_PROC_UNIT1_ISO />
        <FORCAST_BUS_PROC_VAL1 />
        <PERS_NO>
          <xsl:value-of select="Personnel" />
        </PERS_NO>
        <TIMEID_NO>
          <xsl:value-of select="TimeRecording" />
        </TIMEID_NO>
        <WAGETYPE>
          <xsl:value-of select="EmployeeWageType" />
        </WAGETYPE>
        <SUITABILITY>
          <xsl:value-of select="EmployeeSuitability" />
        </SUITABILITY>
        <NO_OF_EMPLOYEE>
          <xsl:value-of select="NumberOfEmployees" />
        </NO_OF_EMPLOYEE>
        <WAGEGROUP>
          <xsl:value-of select="EmployeeWageGroup" />
        </WAGEGROUP>
        <BREAK_UNIT>
          <xsl:value-of select="BreakDurationUnit" />
        </BREAK_UNIT>
        <BREAK_UNIT_ISO>
          <xsl:value-of select="BreakDurationUnitISOCode" />
        </BREAK_UNIT_ISO>
        <BREAK_TIME>
          <xsl:value-of select="ConfirmedBreakDuration" />
        </BREAK_TIME>
        <EX_CREATED_BY>
          <xsl:value-of select="EnteredByExternalUser" />
        </EX_CREATED_BY>
        <EX_CREATED_DATE>
          <xsl:call-template name="convertODataDateFormat">
            <xsl:with-param name="date" select="ConfirmationExternalEntryDate"/>
          </xsl:call-template>
        </EX_CREATED_DATE>
        <EX_CREATED_TIME>
          <xsl:call-template name="convertODataTimeFormat">
            <xsl:with-param name="time" select="ConfirmationExternalEntryTime"/>
          </xsl:call-template>
        </EX_CREATED_TIME>
        <TARGET_ACTI1 />
        <TARGET_ACTI2 />
        <TARGET_ACTI3 />
        <TARGET_ACTI4 />
        <TARGET_ACTI5 />
        <TARGET_ACTI6 />
        <TARGET_BUS_PROC1 />
        <EX_IDENT>
          <xsl:value-of select="ExternalSystemConfirmation" />
        </EX_IDENT>
        <LOGDATE />
        <LOGTIME />
        <WIP_BATCH />
        <VENDRBATCH />
        <ME_SFC_ID />
        <ME_2ND_CONF_QTY />
      </IS_TIMETICKETS>
      <IV_2ND_TIME_CONFIRMATION>
        <xsl:if test="ConfirmationReworkQuantity != ''">
          <xsl:value-of select="'X'"/>
        </xsl:if>
      </IV_2ND_TIME_CONFIRMATION>

      <IV_CALL_ON_INBOUND_QUEUE />
      <IV_PROPOSE_ACTIVITIES />
      <IV_PROPOSE_BACKFLUSH>
        <xsl:call-template name="convertODataBool">
          <xsl:with-param name="bool" select="ProposeBackflush"/>
        </xsl:call-template>
      </IV_PROPOSE_BACKFLUSH>
      <IV_TEUN />
      <ET_DETAIL_RETURN>
        <item>
          <TYPE />
          <ID />
          <NUMBER />
          <MESSAGE />
          <LOG_NO />
          <LOG_MSG_NO />
          <MESSAGE_V1 />
          <MESSAGE_V2 />
          <MESSAGE_V3 />
          <MESSAGE_V4 />
          <PARAMETER />
          <ROW />
          <FIELD />
          <SYSTEM />
          <FLG_LOCKED />
          <CONF_NO />
          <CONF_CNT />
        </item>
      </ET_DETAIL_RETURN>
      <IT_CHARACTERISTICS_BATCH>
        <item>
          <CHAR_NAME />
          <CHAR_VALUE />
          <CHAR_VALUE_LONG />
        </item>
      </IT_CHARACTERISTICS_BATCH>
      <IT_GOODSMOVEMENTS>
        <xsl:for-each select="//ProdnOrdConfMatlDocItmType">
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
              <xsl:value-of select="Plant" />
            </PLANT>
            <STGE_LOC>
              <xsl:value-of select="StorageLocation" />
            </STGE_LOC>
            <BATCH>
              <xsl:value-of select="Batch" />
            </BATCH>
            <MOVE_TYPE>
              <xsl:value-of select="GoodsMovementType" />
            </MOVE_TYPE>
            <STCK_TYPE />
            <SPEC_STOCK>
              <xsl:value-of select="InventorySpecialStockType"/>
            </SPEC_STOCK>
            <VENDOR />
            <CUSTOMER />
            <SALES_ORD>
              <xsl:value-of select="SalesOrder" />
            </SALES_ORD>
            <S_ORD_ITEM>
              <xsl:value-of select="SalesOrderItem" />
            </S_ORD_ITEM>
            <SCHED_LINE />
            <VAL_TYPE />
            <ENTRY_QNT>
              <xsl:value-of select="QuantityInEntryUnit" />
            </ENTRY_QNT>
            <ENTRY_UOM>
              <xsl:value-of select="EntryUnitSAPCode" />
            </ENTRY_UOM>
            <ENTRY_UOM_ISO/>
            <PO_PR_QNT />
            <ORDERPR_UN />
            <ORDERPR_UN_ISO />
            <PO_NUMBER />
            <PO_ITEM />
            <SHIPPING />
            <COMP_SHIP />
            <NO_MORE_GR />
            <ITEM_TEXT />
            <GR_RCPT />
            <UNLOAD_PT />
            <COSTCENTER />
            <ORDERID>
              <xsl:value-of select="$orderId"/>
            </ORDERID>
            <ORDER_ITNO>
              <xsl:value-of select="OrderItem" />
            </ORDER_ITNO>
            <CALC_MOTIVE />
            <ASSET_NO />
            <SUB_NUMBER />
            <RESERV_NO>
              <xsl:value-of select="Reservation" />
            </RESERV_NO>
            <RES_ITEM>
              <xsl:value-of select="ReservationItem" />
            </RES_ITEM>
            <RES_TYPE />
            <WITHDRAWN />
            <MOVE_MAT />
            <MOVE_PLANT />
            <MOVE_STLOC />
            <MOVE_BATCH />
            <MOVE_VAL_TYPE />
            <MVT_IND>
              <xsl:value-of select="GoodsMovementRefDocType" />
            </MVT_IND>
            <MOVE_REAS />
            <RL_EST_KEY />
            <REF_DATE />
            <COST_OBJ />
            <PROFIT_SEGM_NO />
            <PROFIT_CTR />
            <WBS_ELEM />
            <NETWORK />
            <ACTIVITY>
              <xsl:value-of select="/ProdnOrdConf2/ProdnOrdConf2Type/OrderOperation" />
            </ACTIVITY>
            <PART_ACCT />
            <AMOUNT_LC />
            <AMOUNT_SV />
            <REF_DOC_YR>
              <xsl:value-of select="MaterialDocumentYear" />
            </REF_DOC_YR>
            <REF_DOC>
              <xsl:value-of select="MaterialDocument" />
            </REF_DOC>
            <REF_DOC_IT>
              <xsl:value-of select="MaterialDocumentItem" />
            </REF_DOC_IT>
            <EXPIRYDATE />
            <PROD_DATE />
            <FUND />
            <FUNDS_CTR />
            <CMMT_ITEM />
            <VAL_SALES_ORD />
            <VAL_S_ORD_ITEM />
            <VAL_WBS_ELEM />
            <GL_ACCOUNT />
            <IND_PROPOSE_QUANX />
            <XSTOB />
            <EAN_UPC />
            <DELIV_NUMB_TO_SEARCH />
            <DELIV_ITEM_TO_SEARCH />
            <SERIALNO_AUTO_NUMBERASSIGNMENT />
            <VENDRBATCH />
            <STGE_TYPE>
              <xsl:value-of select="StorageType" />
            </STGE_TYPE>
            <STGE_BIN>
              <xsl:value-of select="StorageBin" />
            </STGE_BIN>
            <SU_PL_STCK_1 />
            <ST_UN_QTYY_1 />
            <ST_UN_QTYY_1_ISO />
            <UNITTYPE_1 />
            <SU_PL_STCK_2 />
            <ST_UN_QTYY_2 />
            <ST_UN_QTYY_2_ISO />
            <UNITTYPE_2 />
            <STGE_TYPE_PC />
            <STGE_BIN_PC />
            <NO_PST_CHGNT />
            <GR_NUMBER />
            <STGE_TYPE_ST />
            <STGE_BIN_ST />
            <MATDOC_TR_CANCEL />
            <MATITEM_TR_CANCEL />
            <MATYEAR_TR_CANCEL />
            <NO_TRANSFER_REQ />
            <CO_BUSPROC />
            <ACTTYPE />
            <SUPPL_VEND />
            <MATERIAL_EXTERNAL />
            <MATERIAL_GUID />
            <MATERIAL_VERSION />
            <MOVE_MAT_EXTERNAL />
            <MOVE_MAT_GUID />
            <MOVE_MAT_VERSION />
            <FUNC_AREA />
            <TR_PART_BA />
            <PAR_COMPCO />
            <DELIV_NUMB />
            <DELIV_ITEM />
            <NB_SLIPS />
            <NB_SLIPSX />
            <GR_RCPTX />
            <UNLOAD_PTX />
            <SPEC_MVMT />
            <GRANT_NBR />
            <CMMT_ITEM_LONG />
            <FUNC_AREA_LONG />
            <LINE_ID />
            <PARENT_ID />
            <LINE_DEPTH />
            <QUANTITY />
            <BASE_UOM />
            <LONGNUM />
            <BUDGET_PERIOD />
            <EARMARKED_NUMBER />
            <EARMARKED_ITEM />
            <STK_SEGMENT />
            <MOVE_SEGMENT />
            <MOVE_MAT_LONG />
            <STK_SEG_LONG />
            <MOV_SEG_LONG />
            <CREATE_DELIVERY />
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
      </IT_GOODSMOVEMENTS>
      <IT_GOODSMVT_SERIALNUMBER>
        <xsl:for-each select="//MatlDocItmSerialNumberType">
          <item>
            <MATDOC_ITM>
              <xsl:value-of select="MatDocItm"/>
            </MATDOC_ITM>
            <SERIALNO>
              <xsl:value-of select="SerialNo"/>
            </SERIALNO>
            <UII>
              <xsl:value-of select="Uii"/>
            </UII>
          </item>
        </xsl:for-each>
      </IT_GOODSMVT_SERIALNUMBER>
      <IT_LINK_GM_CHAR_BATCH>
        <item>
          <INDEX_GOODSMVT />
          <INDEX_CHAR_BATCH />
        </item>
      </IT_LINK_GM_CHAR_BATCH>
    </urn:CO_MES_PRODORDCONF_CREATE_TT>
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

  <xsl:template name="convertODataDateFormat">
  	<xsl:param name="date"/> <!-- 2017-04-13T00:00:00 -->
    <xsl:value-of select="substring($date, 1, 10)"/>
  </xsl:template>

  <xsl:template name="convertODataTimeFormat">
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

  <xsl:template name="messageId">
    <xsl:variable name="dateStr" select="format-dateTime(current-dateTime(),'[Y01][d001][H01][m01][s01]')"/>
    <xsl:variable name="fullStr" select="concat($SAP_MessageProcessingLogID, $dateStr)"/>
    <xsl:value-of select="substring($fullStr, string-length($fullStr) - 39)"/> <!-- keep only last 40 chars -->
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
