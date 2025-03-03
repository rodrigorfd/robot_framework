*** Settings ***
Library    ./database_service.py
Variables  ../../Data/Testdata.py
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary


*** Keywords ***
Reset Register Update
    database_service.remover_registerUpdate_by_cpf    ${User}
Cancelar Proposta de Emprestimo
    [Arguments]    ${userId}
    database_service.cancelar_proposta_emprestimo    ${userId}
Atualizar Senha de Acesso
    [Arguments]    ${cpf}    ${senha}
    database_service.atualizar_encrypted_password    ${cpf}    ${senha}    