#INCLUDE 'TOTVS.CH'

User Function  MT110TOK()

Local nVlrSug    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ZZPRCSG'})
Local nProduto   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nVlrTotal  := 0
Local n := 1

    dbSelectArea('SC1')
    dbSetOrder(2)
    If MsSeek(xFilial('SC1')+aCols[n][nProduto])     
        SC1->(DbGoTop())
        While !SC1->(EOF()) 
            n++
            If !Empty(aCols[n][nProduto])
                nVlrTotal += aCols[n][nVlrSug]
            EndIf
        SC1->(DbSkip())
        EndDo
    EndIf
    MSGALERT('O valor sugerido para essa solicita��o � de ' + cValToChar(nVlrTotal), 'Valor Sugerido')     

Return


