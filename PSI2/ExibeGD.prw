#INCLUDE'TOTVS.CH'
#INCLUDE'TOPCONN.CH'
#INCLUDE'TBICONN.CH'

/*/{Protheus.doc} User Function ExibeTP
    (Rotina Personalizada que exibe tela com Títulos a Pagar )
    @type  Function
    @author user
    @since 17/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ExibeGD()
    
Local aArea    := FwGetArea()
Local aAreaSF1 := SF1->(FwGetArea())
Local aAreaSE2 := SE2->(FwGetArea())
Local aAreaSE5 := SE5->(FwGetArea())
//Local cQry     := ''
Local cNum     := SF1->F1_DOC
//Local cAlias   := GetNextAlias()
Local oGrid
Local oDlg
//Local aCampos  := {}

DEFINE DIALOG oDlg TITLE 'Tìtulos a Pagar' FROM 180,180 TO 550, 700 PIXEL

DbSelectArea("SE2")
DbSelectArea("SE5")

oGrid := MsBrGetDBase():new( 0, 0, 260, 170,,,, oDlg,,,,,,,,,,,, .F., "", .T.,, .F.,,, )
oGrid:AddColumn(TcColumn():New('Parcela'   , {||SE2->E2_PARCELA} ,,,,'LEFT',,.F.,.F.,,,,,,.F.))
oGrid:AddColumn(TcColumn():New('Vencimento', {||SE2->E2_VENCREA} ,,,,'LEFT',,.F.,.F.,,,,,,.F.))
oGrid:AddColumn(TcColumn():New('Valor'     , {||SE2->E2_VALOR}   ,,,,'LEFT',,.F.,.F.,,,,,,.F.))
oGrid:AddColumn(TcColumn():New('Baixa'     , {||SE2->E2_BAIXA}   ,,,,'LEFT',,.F.,.F.,,,,,,.F.))
oGrid:AddColumn(TcColumn():New('Valor Pago', {||SE5->E5_VALOR}   ,,,,'LEFT',,.F.,.F.,,,,,,.F.))

ACTIVATE DIALOG oDlg CENTERED

cQry := ' SELECT E2_PARCELA, E2_VENCREA, E2_VALOR, E2_BAIXA, E5_VALOR ' + CRLF
cQry += ' FROM ' + retSqlName("SE2") + CRLF
cQry += ' LEFT JOIN ' +retSqlName("SE5") + CRLF
cQry += ' ON E2_BAIXA = E5_DATA ' + CRLF
cQry += ' WHERE SE2.D_E_L_E_T_="" ' + CRLF
cQry += ' AND E2_NUM="' +cNum+ '"'

    TcQuery cQry new Alias &cAlias
    If &(cAlias)->(!Eof())
        While &(cAlias)->(!Eof())
        cParcela := SE2->E2_PARCELA
        cVencime := SE2->E2_VENCREA
        cValor   := SE2->E2_VALOR
        cBaixa   := SE2->E2_BAIXA
        cValorPg := SE5->E5_VALOR             
            &(cAlias)->(DbSkip())
        EndDo
    endIf
    (cAlias)->(DbCloseArea())
    
FwRestArea(aAreaSE5)
FwRestArea(aAreaSE2)
FwRestArea(aAreaSF1)
FwRestArea(aArea)

Return
