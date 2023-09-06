#INCLUDE'TOTVS.CH'
#INCLUDE'RWMAKE.CH'

#DEFINE cCod 'A1_COD'
#DEFINE cNom 'A1_NOME'
#DEFINE cMun 'A1_MUN'
#DEFINE cUF  'A1_EST'

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
User Function RelCliTR()

    Local aArea     := FwGetArea()
    Local aAreaSA1  := SA1->(FwGetArea())
    
    Private oReport

    oReport := GeraReport()

    oReport :PrintDialog()
    
    FwRestArea(aAreaSA1)
    FwRestArea(aArea)
    

Return 

Static Function GeraReport()

    Local cAlias    := 'SA1'
    Local cRepName  := 'RelCliTrep'
    Local cTitulo   := 'Relatório de Clientes'
    Local oReport
    /*Local cCod    := 'A1_COD'
    Local cNom    := 'A1_NOME'
    Local cMun    := 'A1_MUN'
    Local cUF     := 'A1_EST' */
    Local oSection

    oReport := TReport():New(cRepName,cTitulo,,{|oReport| Imprime(oReport, cAlias)}, 'Esse relatório imprimirá os clientes cadastrados.',.F.,,,,.T.,.T.)
    oReport:SetPortrait()
    //oReport:SetPaperSize(9) 
    oReport:ShowHeader()
    
    oSection := TRSection():New(oReport,'Clientes Cadastrados',,,.F.,.T.)

    TRCell():New(oSection, cCod,cAlias, TitSX3('A1_COD')[1] , PesqPict('SA1','A1_COD') ,TamSX3('A1_COD')[1] ,,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)
    TRCell():New(oSection, cNom,cAlias, TitSX3('A1_NOME')[1], PesqPict('SA1','A1_NOME'),TamSX3('A1_NOME')[1],,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)
    TRCell():New(oSection, cMun,cAlias, TitSX3('A1_MUN')[1] , PesqPict('SA1','A1_MUN') ,TamSX3('A1_MUN')[1],,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)
    TRCell():New(oSection, cUF, cAlias, TitSx3('A1_EST')[1] , PesqPict('SA1','A1_EST') ,TamSx3('A1_EST')[1],,,'CENTER',.T.,'CENTER',,,.T.,,,.T.)
    
Return oReport

Static Function Imprime(oReport, cAlias)

    Local oSection := oReport:Section(1)

    oReport:StartPage()
    oSection:Init()

    //oSection:SetHeaderSection(.T)

    DbSelectArea(cAlias)
    (cAlias)->(dbGoTop())

    While !(cAlias)->(EOF())
        
        oSection:Cell(cCod):SetValue((cAlias)->A1_COD)
        oSection:PrintLine()

        (cAlias)->(dbSkip())
    EndDo
    oSection:Finish()
    oReport:EndPage()
Return
