#INCLUDE 'TOTVS.CH'

User Function  zVlrSugCP()

Local aArea := FwGetArea()
Local aAreaCP := SCP->(FwGetArea())
Local nVlrSug    := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_ZZPRCSG'})
Local nProduto   := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_PRODUTO'})
Local nVlrTotal  := 0
Local n := 1

    dbSelectArea('SCP')
    dbSetOrder(2)
    If MsSeek(xFilial('SCP')+aCols[n][nProduto])     
        SC1->(DbGoTop())
            For n := 1 to len(aCols)
                nVlrTotal += aCols[n][nVlrSug]
            Next
    EndIf
    MSGALERT('O valor total sugerido para essa solicitação é de R$' + cValToChar(nVlrTotal), 'Valor Sugerido')     

    FwRestArea(aAreaCP)
    FwRestArea(aArea)
Return


