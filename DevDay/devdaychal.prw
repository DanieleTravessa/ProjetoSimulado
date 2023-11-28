#INCLUDE 'TOTVS.CH'

User Function DevDayCh1()

    Local cPalavraSecreta := u_IpDevDayCheckPassword(cPassword)

    Local cSecretPassword := ''
    Local aCaracteres := {'a','e','i','o','u','0','1','2','3','4','5','6','7','8','9'}
    Local cSenha := ""
    Local nI, nJ, nK, nL, nM, nN

    for nI := 1 to len(aCaracteres)
        for nJ := 1 to len(aCaracteres)
            for nK := 1 to len(aCaracteres)
                for nL := 1 to len(aCaracteres)
                    for nM := 1 to len(aCaracteres)
                        for nN := 1 to len(aCaracteres)
                            cSenha := aCaracteres[nI]+aCaracteres[nJ]+aCaracteres[nK]+aCaracteres[nL]+aCaracteres[nM]+aCaracteres[nN]
                        next 
                    next
                next
            next
        next
    next

Return
