#INCLUDE'TOTVS.CH'

 /*/{Protheus.doc} RelCliTrep
    (long_description)
    @type  Function
    @author user
    @since 04/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RelCliTrep()
    
    Private oReport

    oReport := GeraReport()

    oReport :PrintDialog()
    
Return 

Static Function GeraReport()

    Local aArea     := FwGetArea()
    Local aAreaSA1  := SA1->(FwGetArea())
    Local cAlias    := 'SA1'
    Private oSection

    oReport := TReport():New('RelCliTrep','Relatório de Clientes',,{|oReport| Imprime(oReport, cAlias)}, 'Esse relatório imprimirá os clientes cadastrados.',.F.,,,,.T.,.T.)
    oSection := TRSection():New(oReport,'Clientes Cadastrados',,,.F.,.T.)

    TRCell():New(oSection, 'A1_COD' ,'SA1','Código'      , PesqPict('SA1','A1_COD') ,08,,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)
    TRCell():New(oSection, 'A1_NOME','SA1','Razão Social', PesqPict('SA1','A1_NOME'),20,,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)
    TRCell():New(oSection, 'A1_MUN' ,'SA1','Município'   , PesqPict('SA1','A1_MUN') ,20,,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)
    TRCell():New(oSection, 'A1_EST' ,'SA1','Estado'      , PesqPict('SA1','A1_EST') ,08,,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)

    FwRestArea(aArea)
    FwRestArea(aAreaSA1)
Return oReport

Static Function Imprime(oReport, cAlias)

3456789=
Return
