#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} VldRastro
    (Função Customizada para validar o preenchimento dos campos de Lote e Validade)
    @type  Function
    @author Daniele Travessa
    @since 14/08/2023
    @version 2 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function VldRastro()

    Local aArea   := FwGetArea()  
    Local lVld    := .T.
    Local nPLote  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOTECTL"})
    Local cLote   := acols[n][nPLote]
    Local nPDtVen := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DTVALID"})
    Local cDtVen  := acols[n][nPDtVen]
    Local nPCod   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})   
    Local cD1Cod  := aCols[n][nPCod]
    Local cRastro 
    
        cRastro := Posicione("SB1",1,FWxFilial("SB1")+cD1Cod,"B1_RASTRO")

    If cRastro <> 'N'
        If Empty(cLote) .or. Empty(cDtVen)
            lVld := .F.
            Help(,,"Atenção!",,"Produto informado possui controle de lote!",1,0,,,,,,{"Verifique os campos de Lote e Data de Validade para continuar."})
        EndIf
    EndIf

    FwRestArea(aArea)

Return lVld

/*Static Function TemRastro()

Local cQry      := ""
Local aArea := FwGetArea()
Local cAliasSB1 := GetNextAlias()
        
    cQry := " SELECT B1_RASTRO " + CRLF
    cQry += " FROM " + RetSqlName('SB1') + CRLF    
    cQry += " WHERE B1_COD ='" + cD1Cod + "' " + CRLF
    cQry += " AND SB1.D_E_L_E_T_='' "
    
    TCQUERY cQry NEW Alias (cAliasSB1)
    
    dbSelectArea(cAliasSB1)

    While !(cAliasSB1)->(EOF())
        cRastro := (cAliasSB1)->(B1_RASTRO)
        (cAliasSB1)->(DbSkip())
    EndDo

    (cAliasSB1)->(DbCloseArea())

    FwRestArea(aArea)

Return cRastro*/
