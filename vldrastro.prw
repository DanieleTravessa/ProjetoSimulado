#INCLUDE 'TOTVS.CH'

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

Local aArea     := FwGetArea()
//Local cRastro   := ""
Local nOper     := 
Local lVld      := .T.


If SB1->B1_Rastro <> 'N'
    If Empty(M->D1_LOTECTL) .and. Empty(M->D1_DTVALID)
        lVld := .F.
        Help(,,"Atenção!",,"Produto informado possui controle de lote!",1,0,,,,,,{"Verifique os campos de Lote e Data de Validade para continuar."})
    EndIf
EndIf

Local lRetorno

If cNumPC =' ' .And. cItemPC=' '
lRetorno:= .T.

Elseif cNumPC <>' ' .And. cItemPC<>' '
lRetorno:= .T.
Else
Alert("Favor preencher o pedido/item do pedido de compra.")
lRetorno:= .F.

EndIf


    FwRestArea(aArea)
Return lVld

Static Function TemRastro()

Local cQry      := ""
Local cD1Cod    := ""
Local nPos      := 0

    nPos := aScan(aHeader,{|x| x[2]=="D1_COD"})
    cD1Cod := aCols[n][nPos]

    cQry := " SELECT D1_LOTECTL, D1_COD, B1_RASTRO " + CRLF
    cQry += " FROM " + RetSqlName('SD1') + CRLF
    cQry += " INNER JOIN " + RetSqlName('SB1') + CRLF
    cQry += " ON B1_COD = D1_COD " + CRLF
    cQry += " WHERE D1_COD = cD1Cod "

Return cQry
