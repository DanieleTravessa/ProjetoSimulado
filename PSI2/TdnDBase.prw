#include "totvs.ch"
 
user function TdnDBase()
 
  	Local aArea     := FwGetArea()
	Local aAreaSF1  := SF1->(FwGetArea())
	Local cAlias    := GetNextAlias()
	Local cQry      := Consulta()
	local aDados 	:= {}
	local oBrowse 	:= nil
	Local oDlg
	Private cTitulo := 'Status Títulos a Pagar'
	Private cNum    := SF1->F1_DOC
	Private cForne  := SF1->F1_FORNECE
	Private cLoja   := SF1->F1_LOJA
	Private cSerie  := SF1->F1_SERIE

	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),cAlias,.T.,.T.)
	    
 
  DEFINE DIALOG oDlg TITLE cTitulo FROM 180, 180 TO 550, 700 PIXEL           
 
 	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
    
	// Cria array com dados
    While !(cAlias)->(EOF())
		aAdd( aDados, { (cAlias)->(E2_PARCELA), (cAlias)->(E2_VENCREA), (cAlias)->(E2_VALOR), (cAlias)->(VlrPago), (cAlias)->(E2_BAIXA) } )
    		(cAlias)->(DbSkip())
	EndDo

    // Cria browse
    oBrowse := MsBrGetDBase():new( 0, 0, 260, 170,,,, oDlg,,,,,,,,,,,, .F.,cAlias, .T.,, .F.,,, )

    // Define vetor para a browse
    oBrowse:setArray( aDados )
 
    // Cria colunas do browse
    oBrowse:addColumn( TCColumn():new( "Parcela", { || aDados[oBrowse:nAt, 1] },PesqPict('SE2','E2_VENCREA'),,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( "Vencimento", { || aDados[oBrowse:nAt, 2] },,,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( "Valor", { || aDados[oBrowse:nAt, 3] },,,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( "Valor Pago", { || aDados[oBrowse:nAt, 4] },,,, "LEFT",, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( "Baixa", { || aDados[oBrowse:nAt, 5] },,,, "LEFT",, .F., .F.,,,, .F. ) )    
    oBrowse:Refresh()
 
    // Cria Botões com métodos básicos
    TButton():new( 172, 002, "goUp()", oDlg, { || oBrowse:goUp(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 172, 052, "goDown()", oDlg, { || oBrowse:goDown(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 172, 102, "goTop()", oDlg, { || oBrowse:goTop(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 172, 152, "goBottom()", oDlg, { || oBrowse:goBottom(), oBrowse:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
 
  ACTIVATE DIALOG oDlg CENTERED
 
 	(cAlias)->(DbCloseArea())

	FwRestArea(aAreaSF1)
	FwRestArea(aArea)

return

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
	cQry += " ON "+ CRLF
	cQry += " SE5.E5_FILIAL = '" +FWxFilial('SE5')+ "' AND " + CRLF
	cQry += " SE2.E2_PREFIXO = SE5.E5_PREFIXO AND " + CRLF
	cQry += " SE2.E2_NUM = SE5.E5_NUMERO AND " + CRLF
	cQry += " SE2.E2_PARCELA = SE5.E5_PARCELA AND " + CRLF
	cQry += " SE2.E2_TIPO = SE5.E5_TIPO AND " + CRLF
	cQry += " SE2.E2_FORNECE = SE5.E5_FORNECE AND " + CRLF
	cQry += " SE2.E2_LOJA = SE5.E5_LOJA " + CRLF
    cQry += " AND SE5.E5_RECPAG<>'R' " + CRLF
    cQry += " AND SE5.E5_DTCANBX='' " + CRLF
	cQry += " WHERE " + RetSqlCond('SE2') + CRLF
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
