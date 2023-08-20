#INCLUDE'TOTVS.CH'

/*/{Protheus.doc} User Function MT100LOK
    (Ponto de Entrada da Rotina MATA103.Documento de Entrada)
    @type  Function
    @author Daniele Travessa
    @since 15/08/2023
    @version version
    @see (links_or_references)
    /*/
User Function MT100LOK()
    
        Local aArea := GetArea()
        Local aAreaD1 := SD1->(GetArea())
        Local lGrava := .F.
    
        If ExistBlock('VldRast')
            lGrava := ExecBlock('VldRast', .F., .F.)
        Endif

        RestArea(aAreaD1)
        RestArea(aArea)

Return lGrava
