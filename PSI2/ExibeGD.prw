#INCLUDE'TOTVS.CH'

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
    Local cAlias   := GetNextAlias()
    Local cQry     := Consulta()
    Local oGrid
    Local oDlg
    Private cNum   := SF1->F1_DOC

    DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),cAlias,.T.,.T.)
          
    DEFINE MsDIALOG oDlg TITLE 'Status Títulos a Pagar' FROM 180,180 TO 550, 700 PIXEL
    
    oGrid := MsBrGetDBase():new( 0, 0, 260, 170,,,, oDlg,,,,,,,,,,,, .F., cAlias, .T.,, .F.,,, )
   
    DbSelectArea(cAlias)
        (cAlias)->(DbGoTop())
    
        If (cAlias)->(E2_NUM) == cNum
                                                              
                oGrid:AddColumn( TCColumn():new('Parcela'       , {||(cAlias)->(E2_PARCELA)},,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Vencimento'    , {||(cAlias)->(E2_VENCREA)},,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Valor Original', {||(cAlias)->(E2_VALOR)}  ,,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Valor Pago'    , {||(cAlias)->(E5_VALOR)}  ,,,,"LEFT",,.F.,.F.,,,,.F.,))
                oGrid:AddColumn( TCColumn():new('Data Pagamento', {||(cAlias)->(E2_BAIXA)}  ,,,,"LEFT",,.F.,.F.,,,,.F.,))
     
        EndIf

    ACTIVATE MsDIALOG oDlg CENTERED

    (cAlias)->(DbCloseArea())

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
