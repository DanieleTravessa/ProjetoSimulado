#INCLUDE'TOTVS.CH'

/*/{Protheus.doc} User Function MTA103MNU
    (Ponto de entrada para criação de botão a rotina MATA103 - Documento de Entrada)
    @type  Function
    @author user
    @since 17/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MTA103MNU()

    Local aArea := GetArea()

    aAdd(aRotina, {"ConsultaTP", "u_ExibeGD", 0, 4, 0, Nil})

    RestArea(aArea)
    
Return
