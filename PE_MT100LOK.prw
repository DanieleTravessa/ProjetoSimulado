#INCLUDE'TOTVS.CH'

/*/{Protheus.doc} nomeFunction
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
User Function MT100LOK()
    
    Local lRet
    Local cParam := 'Exemplo'
    Local nParam := 100.00
    Local aParam := {cParam, nParam}
        
            If ExistBlock('u_VldRastro')
                lRet := ExecBlock('u_VldRastro', .F., .F., aParam)
            Endif

Return
