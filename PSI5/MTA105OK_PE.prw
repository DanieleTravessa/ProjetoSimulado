#INCLUDE 'TOTVS.CH'

User Function  MTA105OK()

Local aArea := FwGetArea()
Local aAreaCP := SCP->(FwGetArea())
Local nVlrSug    := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_ZZPRCSG'})
Local nVlrTotal  := 0
Local n := 1

    
    For n := 1 to len(aCols)
        If !(aCols[n,Len(aHeader)+1]) //If !GdDeleted(n)
            nVlrTotal += aCols[n][nVlrSug]
        EndIf
    Next

    MSGALERT('O valor total sugerido para essa solicitação é de R$' + cValToChar(nVlrTotal), 'Valor Sugerido')     

    FwRestArea(aAreaCP)
    FwRestArea(aArea)
Return




