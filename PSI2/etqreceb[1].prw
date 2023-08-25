#include 'totvs.ch'
#include 'topconn.ch'
#INCLUDE "FWMVCDEF.CH"

#DEFINE VELOCIDADE_IMPRESSORA 4
#DEFINE POS_DESCR 3
#DEFINE POS_QUANT 5
#DEFINE POS_QUANT_PAL 6
#DEFINE POS_QUANT_ETQ 7

/*/{Protheus.doc} etqreceb
    Fonte responsável pela etiqueta de recebimento
    @type UserFunction
    @author Victor Freidinger
    @since 15/07/2022
    @see MTA103MNU, MTA140MNU
/*/

//===========================================================================================================================================================
user function etqreceb()
//===========================================================================================================================================================
	Local aParamBox	    := {}
    Local cLocImpressao := ""
    Local lContinua     := .T.
    Local cBkpMVPAR     := MV_PAR01

	aAdd(aParamBox,{1,"Impressora", Space(30)   ,"","","CB5"    ,"",40,.F.}) //--- MV_PAR01

    While lContinua
        If ParamBox(aParamBox,"Local de Impressão",,,,,,,,"ETQRECEB",.T.,.T.)

            cLocImpressao := Alltrim(MV_PAR01)

            If Empty(cLocImpressao)
                MsgStop("Não foi informado o Local de impressão!")
                Loop
            Endif

            If !CB5SetImp(cLocImpressao)
                MsgStop("Problemas no Local de impressão. Verifique!")
                Loop
            Endif

            lContinua := .F.
            fImpressao(cLocImpressao)
        Else
            lContinua := .F.    
        Endif
    Enddo

    MV_PAR01 := cBkpMVPAR
Return Nil

//===========================================================================================================================================================
Static Function fImpressao(cLocImpressao)
//===========================================================================================================================================================
    Private cTitulo			:= "Impressão de Etiqueta de Entrada"	
    Private oDlgEtq			:= Nil
    Private oGrid1			:= Nil
    Private	oObjGrid		:= Nil
    Private lRet			:= .F.
    Private aObjects		:= {}
    Private aInfo 			:= {}
    Private aPosObj			:= {}
    Private aSizeAut    	:= {}

    aSizeAut	:= MsAdvSize(,.F.)	
    AAdd( aObjects, { 100, 100, .T., .T. })
    AAdd( aObjects, { 0,    3, .T., .F. })
    aInfo 	:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
    aPosObj := MsObjSize( aInfo, aObjects )

    DEFINE MSDIALOG oDlgEtq TITLE cTitulo FROM aSizeAut[7],0 TO 300,900 PIXEL OF oMainWnd
    DEFINE Font oBold Name "Arial" Size 0, -13 Bold
                        
    createFromSql(@oGrid1, oDlgEtq)
//ativa a tela c                
    ACTIVATE MSDIALOG oDlgEtq CENTERED ON INIT (EnchoiceBar(oDlgEtq,{|| chamaEtiq(cLocImpressao), oDlgEtq:End() },{||(oDlgEtq:End() )},,))

Return Nil 

//===========================================================================================================================================================
Static Function createFromSql(oGrid1, oDlgEtq)
//===========================================================================================================================================================
	Local nCol		:= 0
	Local nRow		:= 30
	Local nWidth	:= 450
	Local nHeight	:= 120
	Local cQuery	:= getOpsQuery()
	
    oGrid1	:= IpGridObject():newIpGridObject(nCol, nRow, nWidth, nHeight, oDlgEtq)
	oGrid1:addSqlColumns(cQuery)
    oGrid1:aColumns[POS_DESCR]:SetSize(30)
    oGrid1:aColumns[POS_QUANT_PAL]:SetTitle("Qtde NF")
    oGrid1:aColumns[POS_QUANT_PAL]:SetTitle("Qtde Pallet")
    oGrid1:aColumns[POS_QUANT_ETQ]:SetTitle("Qtde Etiquetas")
    //oGrid1:aColumns[POS_QUANT_ETQ]:SetSize(5)
	
	fillSelection(@oGrid1)
	
	oGrid1:setReadOnly(.T.)
	oGrid1:setAccessMode("update")
	oGrid1:setUpdateFields({"B1_PE"})
	oGrid1:create()
	oObjGrid := oGrid1:getGrid()

Return Nil 

//===========================================================================================================================================================
Static Function getOpsQuery()
//===========================================================================================================================================================
	Local cQuery := ""

	cQuery := "   SELECT DISTINCT D1_ITEM  " + CRLF
    cQuery += "        , D1_COD " + CRLF
    cQuery += "        , B1_DESC AS DESCR " + CRLF
    cQuery += "        , D1_LOTECTL " + CRLF
    cQuery += "        , D1_QUANT " + CRLF
    cQuery += "        , 0 AS QTDPALLET " + CRLF
    cQuery += "        , 0 AS B1_PE" + CRLF
    cQuery += "     FROM " + retSqlTab("SD1") + CRLF
    cQuery += "    INNER JOIN " + retSqlTab("SB1") + CRLF 
    cQuery += "       ON D1_COD = B1_COD " + CRLF
    cQuery += "      AND " + retSqlDel("SB1") + CRLF
    cQuery += "      AND " + retSqlFil("SB1") + CRLF
    cQuery += "    INNER JOIN " + retSqlTab("SA2") + CRLF
    cQuery += "       ON D1_FORNECE = A2_COD " + CRLF
    cQuery += "      AND D1_LOJA = A2_LOJA " + CRLF
    cQuery += "      AND " + retSqlDel("SA2") + CRLF
    cQuery += "      AND " + retSqlFil("SA2") + CRLF
    cQuery += "     LEFT JOIN " + retSqlTab("SC7") + CRLF 
    cQuery += "       ON D1_PEDIDO = C7_NUM " + CRLF
    cQuery += "      AND D1_ITEM = C7_ITEM " + CRLF
    cQuery += "      AND " + retSqlDel("SC7") + CRLF
    cQuery += "      AND " + retSqlFil("SC7") + CRLF
    cQuery += "     LEFT JOIN " + retSqlTab("SC1") + CRLF 
    cQuery += "       ON C7_NUMSC = C1_NUM " + CRLF
    cQuery += "      AND C7_ITEMSC = C1_ITEM " + CRLF
    cQuery += "      AND " + retSqlDel("SC1") + CRLF
    cQuery += "      AND " + retSqlFil("SC1") + CRLF
    cQuery += "    WHERE D1_DOC = '" + SF1->F1_DOC + "'" + CRLF
    cQuery += "      AND D1_SERIE = '" + SF1->F1_SERIE + "'" + CRLF
    cQuery += "      AND D1_FORNECE = '" + SF1->F1_FORNECE + "'" + CRLF
    cQuery += "      AND D1_LOJA = '" + SF1->F1_LOJA + "'" + CRLF
    cQuery += "      AND " + retSqlDel("SD1") + CRLF
    cQuery += "      AND " + retSqlFil("SD1") + CRLF    
	
Return cQuery  

//===========================================================================================================================================================
Static Function fillSelection(oGrid1)
//===========================================================================================================================================================
	Local nRecord := 0
	
	For nRecord:= 1 to oGrid1:length()
		oGrid1:setMarkedLine(.F.,nRecord)
	Next nRecord
	
	oGrid1:refresh()    
	oDlgEtq:refresh()

Return Nil

//===========================================================================================================================================================
Static Function chamaEtiq(cLocImpressao)
//===========================================================================================================================================================
    Local lRet    := .T.
    Local nI      := 0

    IF oGrid1:length() <> 0

        If imprCabec(cLocImpressao)
            for nI := 1 to oGrid1:length()
                if oGrid1:GetValue("B1_PE", nI) > 0 //.AND. oGrid1:isMarkedLine(nI)
                    imprACD002(oGrid1:GetValue("B1_PE", nI), oGrid1:GetValue("D1_ITEM", nI))
                endif
            next nI
            MSCBCLOSEPRINTER()
        Endif

    Endif

Return lRet

//===========================================================================================================================================================
Static Function imprCabec(cLocImpressao)
//===========================================================================================================================================================    
    Local lRetorno  := .T.
    
    //---- Informacoes da Nota Fiscal e Fornecedor (capa):
    SA2->(dbSetOrder(1))
    SA2->(dbSeek( xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA ))

    MSCBBEGIN(1,VELOCIDADE_IMPRESSORA)
    MSCBWrite("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD15^JUS^LRN^CI0^XZ")
    MSCBWrite("^XA")
    MSCBWrite("^MMT")
    MSCBWrite("^PW799")
    MSCBWrite("^LL0240")
    MSCBWrite("^LS0")
    MSCBWrite("^FT31,59^A0N,31,31^FH\^FDNF: "+ SF1->F1_DOC +"^FS")
    MSCBWrite("^FT31,97^A0N,31,31^FH\^FDSERIE: "+ SF1->F1_SERIE +"^FS")
    MSCBWrite("^FT280,59^A0N,31,31^FH\^FDFORNECEDOR: "+ SF1->F1_FORNECE +" "+ SF1->F1_LOJA +"^FS")
    MSCBWrite("^FT283,97^A0N,31,31^FH\^FD"+ Alltrim(SA2->A2_NREDUZ) +"^FS")
    MSCBWrite("^BY3,3,62^FT88,187^BCN,,Y,N")
    MSCBSAYBAR(10,15,SF1->(F1_DOC+F1_SERIE+F1_FORNECE + F1_LOJA),"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
    MSCBWrite("^PQ1,0,1,Y")
    MSCBInfoEti("AC2002","100X30")

    cZPLcabec := MSCBEND()
	
Return lRetorno

//===========================================================================================================================================================    
Static Function imprACD002(nB1_PE, cItem)
//===========================================================================================================================================================    
    Local aDados := {}
    Local nI     := 0
    Private cZPL

    aDados := buscaDados(cItem)
    
    if len(aDados) > 0 .and. nB1_PE > 0
   
        For nI := 1 to nB1_PE

            MSCBBEGIN(nB1_PE,VELOCIDADE_IMPRESSORA)

            MSCBWrite("^XA")
            MSCBWrite("^CI0")
            MSCBWrite("^PW799")
            MSCBWrite("^FT18,35^A0N,25,24^FB787,1,0^FH\^FD" + SUBSTR(aDados[1], 1, 59) + "^FS")
            MSCBWrite("^FT18,75^A0N,25,24^FB585,1,0^FH\^FD" + SUBSTR(aDados[1], 60, 42) + "^FS")
            MSCBWrite("^FT18,115^A0N,25,24^FB787,1,0^FH\^FD" + aDados[7] + "^FS")
            MSCBWrite("^FT18,154^A0N,25,24^FB332,1,0^FH\^FDA/C: " + allTrim(aDados[2]) + "^FS")
            MSCBWrite("^FT18,192^A0N,25,24^FB212,1,0^FH\^FDSC: " + allTrim(aDados[3]) + "^FS")
            MSCBWrite("^FT304,192^A0N,25,24^FB288,1,0^FH\^FDRECEB: " + aDados[4] + "^FS")
            MSCBWrite("^FT18,229^A0N,25,24^FB246,1,0^FH\^FD" + allTrim(aDados[6]) +"^FS")
            MSCBWrite("^FT614,239^BQN,2,6")
            MSCBWrite("^FH\^FDLA," + AllTrim(aDados[5]) + "^FS")
            MSCBWrite("^XZ")

            MSCBInfoEti("AC2002","100X30")
            cZPL := MSCBEND()
            
        next nI
  
    endif

Return 

//===========================================================================================================================================================    
Static Function CmpctBar( cCodigo )
//===========================================================================================================================================================    
    Local cRet      := ""
    Local nX        := 0
    Local cAux      := "" 
    Local lCode128C := .T.

    For nX := 1 To Len(cCodigo)
        cAux := Substr(cCodigo,nX,1)
        If IsNumeric(cAux) .AND. cAux <> " "
            If !lCode128C
                if IsNumeric(Substr(cCodigo,nX+1,1)) .AND. Substr(cCodigo,nX+1,1) <> " "
                    lCode128C := .T.
                    cRet += ">5"
                endif
            Endif
        Else
            If lCode128C
                lCode128C := .F.
                cRet += ">6"
            Endif 
        Endif
        cRet += cAux
    Next nX

Return cRet

//===========================================================================================================================================================    
Static Function buscaDados(cItem)
//===========================================================================================================================================================    
    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local aDados := {}

    cQuery := "   SELECT * FROM " + CRLF
    cQuery += "   ( " + CRLF
    cQuery += "   SELECT " + CRLF
    cQuery += "        B1_DESC AS DESCR " + CRLF
    cQuery += "        , CASE WHEN D1_ZZMARCA <> '' " + CRLF
    cQuery += "             THEN 'MARCA: ' + RTRIM(D1_ZZMARCA) " + CRLF
    cQuery += "             ELSE '' " + CRLF
    cQuery += "          END AS MARCA " + CRLF
    cQuery += "        , CASE  WHEN 	C1_ZZSOLF = ' '  THEN B1_ZZEPAD   ELSE C1_ZZSOLF  	END  AS SOLICITANTE " + CRLF
    cQuery += "        , C1_NUM AS SOLICITACAO " + CRLF
    cQuery += "        , SUBSTRING(D1_DTDIGIT, 7, 2) + '/' + SUBSTRING(D1_DTDIGIT, 5, 2) + '/' + SUBSTRING(D1_DTDIGIT, 1, 4) AS DATADIG " + CRLF
    cQuery += "        , RTRIM(LTRIM(D1_COD))+';'+RTRIM(LTRIM(D1_LOTECTL))+';1;' AS QRCODE " + CRLF //teste joni
    cQuery += "        , RTRIM(LTRIM(B1_COD)) AS CODPRO " + CRLF
    cQuery += "     FROM " + retSqlTab("SD1") + CRLF
    cQuery += "    INNER JOIN " + retSqlTab("SA2") + CRLF
    cQuery += "       ON D1_FORNECE = A2_COD " + CRLF
    cQuery += "      AND D1_LOJA = A2_LOJA " + CRLF
    cQuery += "      AND " + retSqlDel("SA2") + CRLF
    cQuery += "      AND " + retSqlFil("SA2") + CRLF
    cQuery += "    INNER JOIN " + retSqlTab("SB1") + CRLF 
    cQuery += "       ON D1_COD = B1_COD " + CRLF
    cQuery += "      AND " + retSqlDel("SB1") + CRLF
    cQuery += "      AND " + retSqlFil("SB1") + CRLF
    cQuery += "     LEFT JOIN " + retSqlTab("SC7") + CRLF 
    cQuery += "       ON D1_PEDIDO = C7_NUM " + CRLF
    cQuery += "      AND D1_ITEMPC = C7_ITEM " + CRLF
    cQuery += "      AND " + retSqlDel("SC7") + CRLF
    cQuery += "      AND " + retSqlFil("SC7") + CRLF
    cQuery += "     LEFT JOIN " + retSqlTab("SC1") + CRLF 
    cQuery += "       ON C7_NUMSC = C1_NUM " + CRLF
    cQuery += "      AND C7_ITEMSC = C1_ITEM " + CRLF
    cQuery += "      AND " + retSqlDel("SC1") + CRLF
    cQuery += "      AND " + retSqlFil("SC1") + CRLF
    cQuery += "    WHERE D1_DOC = '" + SF1->F1_DOC + "'" + CRLF
    cQuery += "      AND D1_SERIE = '" + SF1->F1_SERIE + "'" + CRLF
    cQuery += "      AND D1_FORNECE = '" + SF1->F1_FORNECE + "'" + CRLF
    cQuery += "      AND D1_LOJA = '" + SF1->F1_LOJA + "'" + CRLF
    cQuery += "      AND D1_ITEM = '" + cItem + "'" + CRLF
    cQuery += "      AND " + retSqlDel("SD1") + CRLF
    cQuery += "      AND " + retSqlFil("SD1") + CRLF
    cQuery += "   ) X " + CRLF
    cQuery += "   GROUP BY " + CRLF
    cQuery += "     X.DESCR, " + CRLF
    cQuery += "     X.MARCA, " + CRLF
    cQuery += "     X.SOLICITANTE, " + CRLF
    cQuery += "     X.SOLICITACAO, " + CRLF
    cQuery += "     X.DATADIG, " + CRLF
    cQuery += "     X.QRCODE, " + CRLF
    cQuery += "     X.CODPRO " + CRLF

    TcQuery cQuery New Alias (cAlias)

    aAdd(aDados, (cAlias)->DESCR)         /* POSICAO 01 */
    aAdd(aDados, (cAlias)->SOLICITANTE)   /* POSICAO 02 */
    aAdd(aDados, (cAlias)->SOLICITACAO)   /* POSICAO 03 */
    aAdd(aDados, (cAlias)->DATADIG)       /* POSICAO 04 */
    aAdd(aDados, (cAlias)->QRCODE)        /* POSICAO 05 */
    aAdd(aDados, (cAlias)->CODPRO)        /* POSICAO 06 */
    aAdd(aDados, (cAlias)->MARCA)         /* POSICAO 07 */

Return aDados
