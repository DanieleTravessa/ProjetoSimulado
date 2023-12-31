#INCLUDE'TOTVS.CH'

/*/{Protheus.doc} User Function ExibeTP
    (Rotina Personalizada que exibe tela com T�tulos a Pagar )
    @type  Function
    @author Daniele Travessa
    @since 17/08/2023
    @version version    
    /*/
User Function ExibeGD()

	Local aArea     := FwGetArea()
	Local aAreaSF1  := SF1->(FwGetArea())
	Local cAlias    := GetNextAlias()
	Local cQry      := Consulta()
	Local oGrid
	Local oDlg
	Private cTitulo := 'Status T�tulos a Pagar'
	Private cNum    := SF1->F1_DOC
	Private cForne  := SF1->F1_FORNECE
	Private cLoja   := SF1->F1_LOJA
	Private cSerie  := SF1->F1_SERIE

	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),cAlias,.T.,.T.)

	DEFINE MsDIALOG oDlg TITLE cTitulo FROM 180,180 TO 550, 700 PIXEL
//oBrowse := MsBrGetDBase():new( 0, 0, 260, 170,,,, oDlg,          ,         ,         ,,              ,           ,         ,           ,            ,            ,, .F.,cAlias, .T.,, .F.,,, )
	oGrid := MsBrGetDBase():new( 0, 0, 260, 170,,,, oDlg,/*cField*/,/*uVal1*/,/*uVal2*/,,/*bLDblClick*/,/*bRClick*/,/*oFont*/,/*oCursor*/,/*nClrFore*/,/*nClrBack*/,, .F.,cAlias, .T.,, .F.,,, )

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

    //oBrowse:addColumn( TCColumn():new( "Parcela"       , { || aDados[oBrowse:nAt, 1] }      ,                            ,,, "LEFT" ,, .F., .F.,,,, .F. ) )        
		oGrid:AddColumn( TCColumn():new( "Parcela"       , { || (cAlias)->(E2_PARCELA)}     ,PesqPict('SE2','E2_VENCREA'),,,"CENTER",, .F., .T.,,,, .F. ) )
        oGrid:AddColumn( TCColumn():new( "Vencimento"    , { || StoD((cAlias)->(E2_VENCREA))} ,PesqPict('SE2','E2_PARCELA'),,,"CENTER",, .F., .T.,,,, .F. ) )		
		oGrid:AddColumn( TCColumn():new( "Valor Original", { || (cAlias)->(E2_VALOR)}         ,PesqPict('SE2','E2_VALOR')  ,,,"CENTER",, .F., .T.,,,, .F. ) )
		oGrid:AddColumn( TCColumn():new( "Valor Pago"    , { || (cAlias)->(VlrPago)}          ,PesqPict('SE5','E5_VALOR')  ,,,"CENTER",, .F., .T.,,,, .F. ) )
		oGrid:AddColumn( TCColumn():new( "Data Pagamento", { || StoD((cAlias)->(E2_BAIXA))}   ,PesqPict('SE2','E2_BAIXA')  ,,,"CENTER",, .F., .T.,,,, .F. ) )        
        //oGrid:Refresh()

// Cria Bot�es com m�todos b�sicos
   	TButton():new( 172, 002, "goUp()", oDlg, { || oGrid:goUp(), oGrid:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
	TButton():new( 172, 052, "goDown()", oDlg, { || oGrid:goDown(), oGrid:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 172, 102, "goTop()", oDlg, { || oGrid:goTop(), oGrid:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
    TButton():new( 172, 152, "goBottom()", oDlg, { || oGrid:goBottom(), oGrid:setFocus() }, 40, 010,,, .F., .T., .F.,, .F.,,, .F. )
	
    ACTIVATE MsDIALOG oDlg CENTERED

	(cAlias)->(DbCloseArea())

	FwRestArea(aAreaSF1)
	FwRestArea(aArea)

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
