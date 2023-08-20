#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} VldRastro
    (Função Customizada para validar o preenchimento dos campos de Lote e Validade)
    @type  Function
    @author Daniele Travessa
    @since 14/08/2023
    @version 3     
    @see (links_or_references)
    /*/
User Function VldRastro()

    Local aArea   := FwGetArea()
    Local aAreaB1 := SB1->(FwGetArea())
    Local aAreaD1 := SD1->(FwGetArea())
    Local lVld    := .T.    
    Local cLote   := GdFieldGet("D1_LOTECTL")
    Local cDtVen  := GdFieldGet("D1_DTVALID")
    Local cD1Cod  := GdFieldGet("D1_COD")
    Local cRastro := Posicione("SB1",1,FWxFilial("SB1")+cD1Cod,"B1_RASTRO")
    
    If cRastro <> 'N' .and. !GDDeleted()
        If Empty(cLote) .or. Empty(cDtVen)
            lVld := .F.
            Help(,,"Atenção!",,"Produto informado possui controle de lote!",1,0,,,,,,{"Verifique os campos de Lote e Data de Validade para continuar."})
        EndIf
    EndIf

    FwRestArea(aAreaD1)
    FwRestArea(aAreaB1)
    FwRestArea(aArea)    

Return lVld
