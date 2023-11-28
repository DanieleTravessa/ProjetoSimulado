#INCLUDE'totvs.ch'

/*/{Protheus.doc} RelCliPsay
    (Relatório de Clientes utilizando a função SetPrint)
    @type User Function
    @author Daniele Travessa
    @since 04/09/2023
    @example
    (examples)
    @see (TDN:https://tdn.totvs.com/pages/releaseview.action?pageId=6815081)
    /*/
User Function RelCliPR()

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

IF Pergunte('ZRELCLIPR',.T.)

    wnRel := SetPrint(cAlias, cProg,'', @cTitulo, cDesc1, cDesc2, cDesc3, .F.,,.T.,cSize,,.F.)

    If nLastKey <> 27
        SetDefault(aReturn,cAlias)
        RptStatus({|lEnd| Imprime(@lEnd,wnRel,cAlias,cTitulo)},cTitulo)
    EndIf
EndIf

FwRestArea(aArea)
    
Return .T. 

Static Function Imprime(lEnd,wnRel,cAlias,cTitulo)

Local aArea     := FwGetArea()
Local aAreaSA1  := SA1->(FwGetArea())
Local nLinha    := 00
Local cabec1    := ''
Local cabec2    := ''
Local nTipo := 0
Local nCntImpr

nCntImpr := 0
m_pag := 1
nTipo := If(aReturn[4]==1,15,18)


cabec(cTitulo,cabec1,cabec2,cProg,cSize,nTipo,,.F.)
nLinha := 08


DbSelectArea('SA1')
SA1->(DbSetOrder(1))
DbGoTop()

While !EOF()
    
    If SA1->A1_EST == MV_PAR01
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
    EndIF

    If nLinha > 60
        cabec(cTitulo,cabec1,cabec2,cProg,cSize,nTipo,,.F.)
        nLinha := 08
    EndIf
    
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
