#INCLUDE'totvs.ch'

/*/{Protheus.doc} nomeFunction
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
User Function RelCliPsay()

Local aArea     := FWGetArea()
Local wnRel     
Private cAlias    := 'SA1'
Private cProg     := 'RelCliPsay'
Private cTitulo   := 'Relatório de Clientes com PSay'
Private cDesc1    := 'Exemplo de relatório '
Private cDesc2    := 'de Cadastro de Clientes '
Private cDesc3    := 'utilizando a função SetPrint. '
Private cSize     := 'M'
Private aReturn   := {'Zebrado',1,'Administracao',1,2,1,'',1}
Private nLastKey

wnRel := SetPrint(cAlias, cProg,'', @cTitulo, cDesc1, cDesc2, cDesc3, .F.,,.T.,cSize,,.F.)

If nLastKey <> 27
    SetDefault(aReturn,cAlias)
    //RptStatus({|| Imprime()},cTitulo,'Gerando Relatório...')
    RptStatus({|lEnd| Imprime(@lEnd,wnRel,cAlias,cTitulo)},cTitulo)
EndIf

FwRestArea(aArea)
    
Return .T. 

Static Function Imprime(lEnd,wnRel,cAlias,cTitulo)

Local aArea     := FwGetArea()
Local aAreaSA1  := SA1->(FwGetArea())
Local nLinha    := 2
//Local aReturn   := {'Zebrado',1,'Administracao',1,2,1,'',1}

DbSelectArea('SA1')
SA1->(DbSetOrder(1))
DbGoTop()

While !EOF()
    @nLinha, 01 PSAY TitSX3('A1_COD')[1]+':' + (SA1->A1_COD)
    nLinha++
    @nLinha, 01 PSAY TitSX3('A1_NOME')[1]+':'+ (SA1->A1_NOME)
    nLinha++
    @nLinha, 01 PSAY TitSX3('A1_MUN')[1]+':'+ (SA1->A1_MUN) 
    nLinha++
    @nLinha, 01 PSAY TitSX3('A1_EST')[1]+':' + (SA1->A1_EST)
    nLinha++ 
    @nLinha, 00 PSAY __PrtThinLine()
    nLinha++

    SA1->(DbSkip())
EndDo

SET DEVICE TO SCREEN 

If aReturn[5] == 1
    SET PRINTER TO DbCommitAll()
    OurSpool(wnRel)
EndIf

MS_FLUSH()

FwRestArea(aArea)
FwRestArea(aAreaSA1)

Return
