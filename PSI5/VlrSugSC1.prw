#INCLUDE 'TOTVS.CH'

User Function  VlrSugC1()

Local aArea := FWGetArea()
Local aAreaC1 := SC1->(FWGetArea())
Local nVlrSug    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ZZPRCSG'})
Local nProduto   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nVlrTotal  := 0
Local n := 1

    dbSelectArea('SC1')
    dbSetOrder(2)
    If MsSeek(xFilial('SC1')+aCols[n][nProduto])     
        SC1->(DbGoTop())
        //While !SC1->(EOF()) 
            For n := 1 to len(aCols)
                nVlrTotal += aCols[n][nVlrSug]
            Next
        //SC1->(DbSkip())
        //EndDo
    EndIf
    MSGALERT('O valor total sugerido para essa solicitação é de R$' + cValToChar(nVlrTotal), 'Valor Sugerido')     

    FwRestArea(aAreaC1)
    FwRestArea(aArea)

Return


