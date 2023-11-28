#INCLUDE 'TOTVS.CH'

User Function  MT110TOK()

Local nVlrSug    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ZZPRCSG'})
Local nProduto   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nVlrTotal  := 0

    dbSelectArea('SC1')
    dbSetOrder(2)
    If MsSeek(xFilial('SC1')+aCols[n][nProduto])     
        SC1->(DbGoTop())
        While !SC1->(EOF())
            nVlrTotal += aCols[n][nVlrSug]
            n++
        SC1->(DbSkip())
        EndDo
    EndIf
    MSGALERT('O valor sugerido para essa solicitação é de ' + cValToChar(nVlrTotal), 'Valor Sugerido')     

Return


