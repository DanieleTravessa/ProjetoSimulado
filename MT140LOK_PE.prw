#INCLUDE'TOTVS.CH'

/*/{Protheus.doc} User Function MT140LOK
    (long_description)
    @type  Function
    @author user
    @since 15/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MT140LOK()
    
        Local aArea := GetArea()
        Local aAreaD1 := SD1->(GetArea())
        Local lGrava := .F.
    
        If ExistBlock('VldRastro')
            lGrava := ExecBlock('VldRastro', .F., .F.)
        Endif

        RestArea(aAreaD1)
        RestArea(aArea)

Return lGrava
