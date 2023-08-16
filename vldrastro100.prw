#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} User Function VldRast
    (Função Customizada para validar o preenchimento dos campos de Lote e Validade)
    @type  Function
    @author Daniele Travessa
    @since 14/08/2023
    @version version 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function VldRast()

Local aArea   := FwGetArea()
//Local nOper   := 
Local lVld    := .T.
Local nPLote  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOTECTL"})
Local cLote   := acols[n][nPLote]
Local nPDtVen := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DTVALID"})
Local cDtVen  := acols[n][nPDtVen]
Local nPCod      
Private cD1Cod  := ""
Private cRastro 

    nPCod := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
    cD1Cod := aCols[n][nPCod]

TemRastro()

    cRastro := Alltrim(cRastro)

If cRastro <> 'N'
    If Empty(cLote) .or. Empty(cDtVen)
        lVld := .F.
        Help(,,"Atenção!",,"Produto informado possui controle de lote!",1,0,,,,,,{"Verifique os campos de Lote e Data de Validade para continuar."})
    EndIf
EndIf

    FwRestArea(aArea)
Return lVld

Static Function TemRastro()

Local cQry      := ""
Local aArea := FwGetArea()
Local cAliasSB1 := GetNextAlias()
        
    cQry := " SELECT D1_LOTECTL, D1_COD, SB1.B1_RASTRO " + CRLF
    cQry += " FROM " + RetSqlName('SD1') + CRLF
    cQry += " INNER JOIN " + RetSqlName('SB1') + " SB1 " + CRLF
    cQry += " ON B1_COD = D1_COD " + CRLF
    cQry += " WHERE D1_COD ='" + cD1Cod + "' " + CRLF
    cQry += " AND SB1.D_E_L_E_T_='' "
    
    TCQUERY cQry NEW Alias (cAliasSB1)
    
    dbSelectArea(cAliasSB1)

    While !(cAliasSB1)->(EOF())
        cRastro := (cAliasSB1)->(B1_RASTRO)
        (cAliasSB1)->(DbSkip())
    EndDo

    (cAliasSB1)->(DbCloseArea())

    FwRestArea(aArea)

Return cRastro
