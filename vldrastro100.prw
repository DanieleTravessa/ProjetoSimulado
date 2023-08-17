#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function VldRast
    (Função Customizada para validar o preenchimento dos campos de Lote e Validade)
    @type  Function
    @author Daniele Travessa
    @since 14/08/2023
    @version 2    
    @see (links_or_references)
    /*/
User Function VldRast()

Local aArea   := FwGetArea()
Local lVld    := .T.
Local cLote   := GdFieldGet("D1_LOTECTL")
Local cDtVen  := GdFieldGet("D1_DTVALID")
Private cD1Cod  := GdFieldGet("D1_COD")
Private cRastro := Posicione("SB1",1,FWxFilial("SB1")+cD1Cod,"B1_RASTRO")

If cRastro <> 'N' .and. !GdDeleted()
    If Empty(cLote) .or. Empty(cDtVen)
        lVld := .F.
        Help(,,"Atenção!",,"Produto informado possui controle de lote!",1,0,,,,,,{"Verifique os campos de Lote e Data de Validade para continuar."})
    EndIf
EndIf

    FwRestArea(aArea)
Return lVld





//Local nPLote  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOTECTL"})
