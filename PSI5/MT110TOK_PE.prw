#INCLUDE 'TOTVS.CH'

User Function  MT110TOK()
    
        Local aArea := GetArea()
        Local aAreaC1 := SC1->(GetArea())
        Local lAciona := .F.
    
        If ExistBlock('VlSugSC1')
            lAciona := ExecBlock('VlSugSC1', .F., .F.)
        Endif

        RestArea(aAreaC1)
        RestArea(aArea)

Return lAciona


