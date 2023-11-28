#INCLUDE 'TOTVS.CH'

User Function  MT110TOK()

Local aArea     := FWGetArea()
Local aAreaC1   := SC1->(FWGetArea())
Local nVlrSug   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ZZPRCSG'})
Local nVlrTotal := 0
Local n := 0


    For n := 1 to len(aCols)
        If !(aCols[n,Len(aHeader)+1]) //If !GdDeleted(n)
            nVlrTotal += aCols[n][nVlrSug]
        EndIf
    Next
       
    MSGALERT('O valor total sugerido para essa solicitação é de R$' + cValToChar(nVlrTotal), 'Valor Sugerido')     

    FwRestArea(aAreaC1)
    FwRestArea(aArea)

Return




