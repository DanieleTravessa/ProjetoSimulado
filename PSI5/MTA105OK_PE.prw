#INCLUDE 'TOTVS.CH'

#INCLUDE 'TOTVS.CH'

User Function  MTA105OK()
    
        Local aArea := GetArea()
        Local aAreaCP := SCP->(GetArea())
        Local lAciona := .F.
    
        If ExistBlock('VlSugCP')
            lAciona := ExecBlock('VlSugCP', .F., .F.)
        Endif

        RestArea(aAreaCP)
        RestArea(aArea)

Return lAciona


