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
User Function ExibeTP()
    
Local aArea    := FwGetArea()
Local aAreaSF1 := SF1->(FwGetArea())
Local cQry     := ''
Local cNum     := SF1->F1_DOC
Local cAlias   := GetNextAlias()

cQry := ' SELECT E2_PARCELA, E2_VENCREA, E2_VALOR, E2_BAIXA, E5_VALOR ' + CRLF
cQry += ' FROM ' + retSqlName("SE2") + CRLF
cQry += ' LEFT JOIN ' +retSqlName("SE5") + CRLF
cQry += ' ON E2_BAIXA = E5_DATA ' + CRLF
cQry += ' WHERE SE2.D_E_L_E_T_="" ' + CRLF
cQry += ' AND E2_NUM="' +cNum+ '"'

    TcQuery cQry new Alias &cAlias
    If &(cAlias)->(!Eof())
        While &(cAlias)->(!Eof())
        //TODO implemente seu codigo aqui
        Alert(&(cAlias)->E2_PARCELA)

            &(cAlias)->(DbSkip())
        EndDo
    endIf
    (cAlias)->(DbCloseArea())



FwRestArea(aAreaSF1)
FwRestArea(aArea)

Return
