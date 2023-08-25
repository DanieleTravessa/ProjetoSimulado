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

Return
    
Static Function Consulta()

	Local cNum := SF1->F1_DOC
	Local cForne := SF1->F1_FORNECE
	Local cLoja := SF1->F1_LOJA
	Local cSerie := SF1->F1_SERIE

	cQry := " SELECT " + CRLF	
	cQry += " SE2.E2_PARCELA, " + CRLF
	cQry += " SE2.E2_VENCREA, " + CRLF
	cQry += " SE2.E2_VALOR, " + CRLF
	cQry += " SE2.E2_BAIXA, " + CRLF	
	cQry += " SUM(SE5.E5_VALOR) AS VlrPago " + CRLF
	cQry += " FROM " + RetSqlName('SE2') + " SE2 " + CRLF
	cQry += " LEFT JOIN " + RetSqlName('SE5') + " SE5 " + CRLF
	cQry += " ON "/*SE2.E2_FILIAL = '" +FWxFilial('SE2')+ "' AND " */+ CRLF
	cQry += " SE5.E5_FILIAL = '" +FWxFilial('SE5')+ "' AND " + CRLF
	cQry += " SE2.E2_PREFIXO = SE5.E5_PREFIXO AND " + CRLF
	cQry += " SE2.E2_NUM = SE5.E5_NUMERO AND " + CRLF
	cQry += " SE2.E2_PARCELA = SE5.E5_PARCELA AND " + CRLF
	cQry += " SE2.E2_TIPO = SE5.E5_TIPO AND " + CRLF
	cQry += " SE2.E2_FORNECE = SE5.E5_FORNECE AND " + CRLF
	cQry += " SE2.E2_LOJA = SE5.E5_LOJA " + CRLF
    cQry += " AND SE5.E5_RECPAG<>'R' " + CRLF
    cQry += " AND SE5.E5_DTCANBX='' " + CRLF
	cQry += " WHERE " + RetSqlCond('SE2') /*+ "AND" + RetSqlCond('SE5') */+ CRLF
	cQry += " AND SE2.E2_NUM='" +cNum+ "' " + CRLF
	cQry += " AND SE2.E2_PREFIXO='" +cSerie+ "' " + CRLF
	cQry += " AND SE2.E2_FORNECE='" +cForne+ "' " + CRLF
	cQry += " AND SE2.E2_LOJA='" +cLoja+ "' " + CRLF
    cQry += " GROUP BY " + CRLF
    cQry += " SE2.E2_PARCELA, " + CRLF
    cQry += " SE2.E2_VENCREA,  " + CRLF
    cQry += " SE2.E2_VALOR, " + CRLF
    cQry += " SE2.E2_BAIXA "
    
Return cQry
