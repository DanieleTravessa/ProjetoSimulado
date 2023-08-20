#INCLUDE'TOTVS.CH'

/*/{Protheus.doc} User Function MT140LOK
    (Ponto de Entrada da Rotina MATA140.Pré-Nota)
    @type  Function
    @author Daniele Travessa Brito
    @since 14/08/2023
    @version version
    @see (links_or_references)
    /*/
User Function MT140TOK()
    
        Local aArea := GetArea()
        Local aAreaD1 := SD1->(GetArea())
        Local lGrava := .F.
    
        If ExistBlock('VldRastro')
            lGrava := ExecBlock('VldRastro', .F., .F.)
        Endif

        RestArea(aAreaD1)
        RestArea(aArea)

Return lGrava
