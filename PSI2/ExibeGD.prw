#INCLUDE'TOTVS.CH'
//#INCLUDE'TOPCONN.CH'
//#INCLUDE'TBICONN.CH'

/*/{Protheus.doc} User Function ExibeTP
    (Rotina Personalizada que exibe tela com Títulos a Pagar )
    @type  Function
    @author Daniele Travessa
    @since 17/08/2023
    @version version    
    /*/
User Function ExibeGD()
    
Local aArea    := FwGetArea()
Local aAreaSF1 := SF1->(FwGetArea())
/*Local aAreaSE2 := SE2->(FwGetArea())
Local aAreaSE5 := SE5->(FwGetArea())*/
Local cAlias   := GetNextAlias()
Local oGrid
Local oDlg
//Local aDados  := {}
Local cQry := Consulta()
/*Local cParcela := SE2->E2_PARCELA
Local cVencim := ''
Local cValor   := ''
Local cBaixa   := ''
Local cValorPg := ''*/
Private cNum   := SF1->F1_DOC

    DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),cAlias,.T.,.T.)

    DbSelectArea(cAlias)
    //DbSelectArea("SE2")
    //DbSelectArea("SE5")

   (cAlias)->(DbGoTop())
    If (cAlias)->(!Eof())
        While (cAlias)->(!Eof()) .and. (cAlias)->(E2_NUM) == cNum
            cParcela := (cAlias)->(E2_PARCELA)
            cVencim  := (cAlias)->(E2_VENCREA)
            cValor   := (cAlias)->(E2_VALOR)
            cBaixa   := (cAlias)->(E2_BAIXA)
            cValorPg := (cAlias)->(E5_VALOR)             
            (cAlias)->(DbSkip())
        EndDo
    EndIf
   
    /*SE5->(DbCloseArea())
    SE2->(DbCloseArea())*/

DEFINE DIALOG oDlg TITLE 'Tìtulos a Pagar' FROM 180,180 TO 550, 700 PIXEL
    
    oGrid := MsBrGetDBase():new( 0, 0, 260, 170,,,, oDlg,,,,,,,,,,,, .F., cAlias, .T.,, .F.,,, )
        // DbSelectArea(cAlias)
        (cAlias)->(DbGoTop())
    //If (cAlias)->(!Eof())
        If (cAlias)->(E2_NUM) == cNum
           // While (cAlias)->(!Eof()) 
                                                   
                oGrid:AddColumn( TCColumn():new('Parcela'   , {||(cAlias)->(E2_PARCELA)},,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Vencimento', {||(cAlias)->(E2_VENCREA)},,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Valor'     , {||(cAlias)->(E2_VALOR)}  ,,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Baixa'     , {||(cAlias)->(E2_BAIXA)}  ,,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Valor Pago', {||(cAlias)->(E5_VALOR)}  ,,,,"LEFT",,.F.,.F.,,,,.F.,))
            
             /*   (cAlias)->(DbSkip())
            EndDo*/
        EndIf

ACTIVATE DIALOG oDlg CENTERED
(cAlias)->(DbCloseArea())
/*FwRestArea(aAreaSE5)
FwRestArea(aAreaSE2)*/
FwRestArea(aAreaSF1)
FwRestArea(aArea)

Return

Static Function Consulta()    

Local cNum   := SF1->F1_DOC

    cQry := " SELECT SE2.E2_NUM, SE2.E2_PARCELA, E2_VENCREA, SE2.E2_VALOR, E2_BAIXA, SE5.E5_VALOR " + CRLF
    cQry += " FROM " + retSqlName('SE2') + " SE2 " + CRLF
    cQry += " LEFT JOIN " + retSqlName('SE5') + " SE5 " + CRLF
    cQry += " ON SE2.E2_PREFIXO = SE5.E5_PREFIXO " + CRLF
    cQry += " WHERE E2_FILIAL ='" + FWxFilial('SE2') + "'" + CRLF
    cQry += " AND SE2.D_E_L_E_T_='' " + CRLF
    cQry += " AND E2_NUM='" +cNum+ "'"
Return cQry

