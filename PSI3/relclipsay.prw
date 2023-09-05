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
Private cAlias    := 'SA1'
Private cProg     := 'RelCliPsay'
Private cTitulo   := 'Relatório de Clientes com PSay'
Private cDesc1    := 'Exemplo de relatório '
Private cDesc2    := 'de Cadastro de Clientes '
Private cDesc3    := 'utilizando a função SetPrint. '
Private cSize     := 'M'
Private cRel      := SetPrint(cAlias, cProg,'', @cTitulo, cDesc1, cDesc2, cDesc3, .F.,,.T.,cSize,,.F.)
Private aReturn   := {'Zebrado',1,'Administração',1,2,'','',1}

If nLastKey <> 27
    SetDefault(aReturn,cAlias)
    RptStatus({|| Imprime()},cTitulo,'Gerando Relatório...')
    //RptStatus({|lEnd| Imprime(@lEnd,cRel,cAlias,cSize,cProg)},cTitulo)
EndIf

FwRestArea(aArea)
    
Return

Static Function Imprime()

Local aArea     := FwGetArea()
Local aAreaSA1  := SA1->(FwGetArea())
Local nLinha    := 2

DbSelectArea('SA1')
SA1->(DbSetOrder(1))
DbGoTop()

While !EOF()
    @nLinha, 01 PSAY 'CÓDIGO: '     + (SA1->A1_COD)
    nLinha++
    @nLinha, 01 PSAY 'RAZÃO SOCIAL' + (SA1->A1_NOME)
    nLinha++
    @nLinha, 01 PSAY 'RNOME: '      + (SA1->A1_MUN) 
    nLinha++
    @nLinha, 01 PSAY 'ESTADO: '     + (SA1->A1_EST)
    nLinha++ 

    SA1->(DbSkip())
EndDo

SET DEVICE TO SCREEN 

If aReturn[5] == 1
    SET PRINTER TO DbCommitAll()
    OurSpool(cRel)
EndIf

MS_FLUSH()

FwRestArea(aArea)
FwRestArea(aAreaSA1)

Return
