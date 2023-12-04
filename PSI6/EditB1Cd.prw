#include 'TOTVS.CH'

User Function EditB1Cd()

Local aArea := FwGetArea()
Local aAreaBM := SBM->(FwGetArea())
Local lZzSeq := .F.
Local cZzSeq := ""

cZzSeq := Posicione("SBM",1,FWxFilial("SBM")+M->B1_GRUPO,"BM_ZZSEQ")
If cZzSeq == "S"
    lZzSeq := .F.
Else
    lZzSeq := .T.
EndIf

RestArea(aAreaBM)
RestArea(aArea)

Return lZzSeq
