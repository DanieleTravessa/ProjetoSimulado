#include 'totvs.ch'
#include 'topconn.ch'
#INCLUDE "FWMVCDEF.CH"

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
Static Function fImpressao(cLocImpressao)
//===========================================================================================================================================================
    Private cTitulo			:= "Impressão de Etiqueta de Entrada"	
    Private oDlg			:= Nil
    Private oGrid			:= Nil
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

    DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSizeAut[7],0 TO 300,900 PIXEL OF oMainWnd
    DEFINE Font oBold Name "Arial" Size 0, -13 Bold
                        
    createFromSql(@oGrid, oDlg)
                
    ACTIVATE MSDIALOG oDlg CENTERED

Return  

//===========================================================================================================================================================
Static Function createFromSql(oGrid, oDlg)
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
    TcQuery cQuery New Alias (cAlias)

    aAdd(aDados, (cAlias)->DESCR)         /* POSICAO 01 */
    aAdd(aDados, (cAlias)->SOLICITANTE)   /* POSICAO 02 */
    aAdd(aDados, (cAlias)->SOLICITACAO)   /* POSICAO 03 */
    aAdd(aDados, (cAlias)->DATADIG)       /* POSICAO 04 */
    aAdd(aDados, (cAlias)->QRCODE)        /* POSICAO 05 */
    aAdd(aDados, (cAlias)->CODPRO)        /* POSICAO 06 */
    aAdd(aDados, (cAlias)->MARCA)         /* POSICAO 07 */

Return aDados
