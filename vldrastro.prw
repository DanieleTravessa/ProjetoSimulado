#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 14/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function VldRastro()

Local aArea   := FwGetArea()
//Local nOper   := 
Local lVld    := .T.
Local nPLote    := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOTECTL"})
Local cLote   := acols[n][nPLote]
Local nPDtVen   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DTVALID"})
Local cDtVen  := acols[n][nPDtVen]
Local nPCod      
Private cD1Cod    := ""
Private cRastro := ""

    nPCod := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
    cD1Cod := aCols[n][nPCod]

TemRastro()

If cRastro <> 'N'
    If Empty(cLote) .and. Empty(cDtVen)
        lVld := .F.
        Help(,,"Atenção!",,"Produto informado possui controle de lote!",1,0,,,,,,{"Verifique os campos de Lote e Data de Validade para continuar."})
    EndIf
EndIf

    FwRestArea(aArea)
Return lVld

Static Function TemRastro()

Local cQry      := ""
Local aArea := GetArea()

    
    cQry := " SELECT D1_LOTECTL, D1_COD, B1_RASTRO " + CRLF
    cQry += " FROM " + RetSqlName('SD1') + CRLF
    cQry += " INNER JOIN " + RetSqlName('SB1') + " SB1 " + CRLF
    cQry += " ON B1_COD = D1_COD " + CRLF
    cQry += " WHERE D1_COD = ' " + cD1Cod + " ' " + CRLF
    cQry += " AND SB1.D_E_L_E_T_='' "
    
    TCQUERY cQry New Alias "Qry_SD1"

    While !(Qry_SD1)->(EOF())
        cRastro := (Qry_SD1)->(B1_RASTRO)
        (Qry_SD1)->(DbSkip())
    EndDo

    (Qry_SB1)->(DbCloseArea())

    RestArea(aArea)

Return cRastro
