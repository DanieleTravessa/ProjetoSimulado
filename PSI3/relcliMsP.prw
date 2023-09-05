#INCLUDE'TOTVS.CH'
#INCLUDE'FWPRINTSETUP.CH'
#INCLUDE'TOPCONN.CH'
#INCLUDE'RPTDEF.CH'

#DEFINE PRETO RGB(000,000,000)
#DEFINE VERMELHO RGB(255,000,000)
#DEFINE AZUL RGB(000,000,255)

/*/{Protheus.doc} User Function RelCliMsP
    (Exemplo de Relatório com uso de FwMsPrinter
    @type  Function
    @author user
    @since 04/09/2023
    @version version
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RelCliMsP()

Local aArea     := FwGetArea()
Local aAreaSA1  := SA1->(FwGetArea())

//Local cAlias := fConsulta()
    If MsgYesNo('Deseja imprimir o relatório de produtos?','Imprime relatório?')
        Processa({||fMontaRel()}, 'Aguarde por favor','Processando...',.F.)
    else
        FwAlertError('Ação cancelada pelo usuário.','Atenção!')
    EndIf

FwRestArea(aArea)
FwRestArea(aAreaSA1)
    
Return

Static Function fMontaRel()
    Local cCaminho  := GetTempPath()
    Local cArquivo  := 'relcliMsp.pdf'

    Private nLinIni := 085
    Private nTamLin := 010
    Private nLinFim := 820
    Private nColIni := 020
    Private nColFim := 550
    Private oPrint

    Private cFont   := 'Arial'
    Private oFont10 := TFont():New(cFont, 9, -10, .T., .F., 5,.T.,5,.T.,.F.,.F.)
    Private oFont12 := TFont():New(cFont, 9, -12, .T., .F., 5,.T.,5,.T.,.F.,.F.)
    Private oFont14 := TFont():New(cFont, 9, -14, .T., .F., 5,.T.,5,.T.,.F.,.F.)
    Private oFont16 := TFont():New(cFont, 9, -16, .T., .F., 5,.T.,5,.T.,.F.,.F.)

    oPrint := FwMsPrinter():New(cArquivo, IMP_PDF,.F.,'',.T.,,@oPrint,'',,,,.T.)
    oPrint:cPathPDF := cCaminho
    oPrint:Setup()
    oPrint:SetPortrait()
    oPrint:SetPaperSize(DMPAPER_A4)
    oPrint:SetMargin(60,60,60,60)

    oPrint:StartPage()

    fCabec()
    fImpDados()

    oPrint:EndPage()
    oPrint:Preview()

    
Return

Static Function fCabec()

    Local nLinCab := 050
    oPrint:Box(nLinIni-055,nColIni,nLinFim, nColFim, '-8')
    oPrint:Say(nLinCab, (nColFim/3)+050,'Relatório de Clientes', oFont16,,PRETO)
    oPrint:Line(nLinIni-020,nColIni,nLinIni-020, nColFim, AZUL, '-6')
    oPrint:Line(nLinIni+005,nColIni,nLinIni+005,nColFim,AZUL,'-6')

    nColIni := nColIni + 010

    oPrint:Say(nLinIni, nColIni,     'CÓDIGO'       , oFont12,,PRETO)
    oPrint:Say(nLinIni, nColIni+100, 'RAZÃO SOCIAL' , oFont12,,PRETO)
    oPrint:Say(nLinIni, nColIni+200, 'MUNICÍPIO'    , oFont12,,PRETO)
    oPrint:Say(nLinIni, nColIni+350, 'ESTADO'       , oFont12,,PRETO)
    
    nLinIni += 005
    
Return

Static Function fImpDados()

    DbSelectArea('SA1')
    ('SA1')->(DbGoTop())
    
    nLinIni := nLinIni + 020

    While !('SA1')->(EOF())
        oPrint:Say(nLinIni, nColIni,     AllTrim(('SA1')->A1_COD),  oFont10,,PRETO)
        oPrint:Say(nLinIni, nColIni+100, AllTrim(('SA1')->A1_NOME), oFont10,,PRETO)
        oPrint:Say(nLinIni, nColIni+200, AllTrim(('SA1')->A1_MUN),  oFont10,,PRETO)
        oPrint:Say(nLinIni, nColIni+350, AllTrim(('SA1')->A1_EST),  oFont10,,PRETO)
        nLinIni:= nLinIni+nTamLin
        ('SA1')->(DbSkip())
    EndDo

    ('SA1')->(DbCloseArea())
    
    ++nLinIni

    oPrint:Line(nLinIni+005,nColIni-010,nLinIni+005,nColFim,AZUL,'-6')

Return

/*Static Function fConsulta()
Return*/

