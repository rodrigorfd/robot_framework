*** Variables ***
${PLATFORM}  ${PLATFORM}
@{BACK_PAGES}    ${BACK_PAGE}    ${BACK_PAGE1}    ${BACK_PAGE2}    ${BACK_PAGE3}    ${BACK_PAGE4}

*** Settings ***
Library    AppiumLibrary    60
Library    OperatingSystem
Variables  ../Locators/Locators-${PLATFORM}.py

*** Keywords ***
Fechar Teclado    
    Set Appium Timeout    1
    IF    '${PLATFORM}' == 'ios'
        Run Keyword And Ignore Error    Click Element    ${KEYBOARD_DONE}
        Run Keyword And Ignore Error    Click Element    ${KEYBOARD_FECHAR}
    END
    Sleep    1
    Set Appium Timeout    60

Back Page

    FOR    ${back_page}    IN    @{BACK_PAGES}
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${back_page}    0.5
        IF    ${status}
            Click Element    ${back_page}
            Exit For Loop
        END
    END
Esperar Elemento
    [Arguments]    ${identifier}

    IF    '${PLATFORM}' == 'android'
        ${locator}=    Set Variable    xPath=//*[@resource-id="${identifier}"] 
    ELSE IF    '${PLATFORM}' == 'ios'
        ${locator}=    Set Variable    accessibility_id=${identifier}
    END
    Wait until Element is Visible   ${locator}
    
    [Return]    ${locator}

Clicar Elemento
    [Arguments]    ${identifier}
    ${locator}=    Esperar Elemento    ${identifier}
    Click Element    ${locator}
    [Return]    ${locator}

Escrever Texto
    [Arguments]    ${identifier}    ${text}
    ${locator}=    Clicar Elemento    ${identifier}
    Input Text    ${locator}    ${text}
    [Return]    ${locator}

Inserir Senha do Cartão
    [Arguments]    ${identifier}    ${text}
    ${locator}=    Esperar Elemento    ${identifier}
    Input Text    ${locator}    ${text}
    [Return]    ${locator}

Abrir uma nova sessão
    # Fecha o aplicativo
    Quit Application
    Sleep    2
    # Abre o aplicativo
    Launch Application
    Sleep    2
    # Seleciona entrar com outra conta
    Run Keyword If    '${PLATFORM}' == 'ios'    Fazer Login com outra conta
    Sleep    2
Esperar Loader iOS
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${LOADER_iOS}    2
    
    IF    ${status}
        Wait Until Page Does Not Contain Element    ${LOADER_iOS}    
    END
Fechar extrato pix
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${TITLE_EXTRATO_PIX}    2

    IF    ${status}
        Click Element    ${VOLTAR_EXTRATO}
    END

Skip device pix
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${CONTINUAR_SEM_AUTORIZAR}    2
    
    IF    ${status}
        Click Element    ${CONTINUAR_SEM_AUTORIZAR}
        Sleep    1
    END

Scroll Up To
    [Arguments]    ${locator}

    ${eixo_x}    Get Window Width
    ${eixo_y}    Get Window Height

    ${start_x}    Evaluate    ${eixo_x} / 2
    ${start_y}    Evaluate    ${eixo_y} / 2

    WHILE    ${True}
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    1
        IF    ${status}
            Exit For Loop
        END

        Swipe
        ...    start_x=${start_x}
        ...    start_y=${start_y}
        ...    offset_x=${start_x}
        ...    offset_y=${eixo_y}
        ...    duration=200
    END

Scroll Down To
    [Arguments]    ${locator}

    ${eixo_x}    Get Window Width
    ${eixo_y}    Get Window Height

    ${start_x}    Evaluate    ${eixo_x} / 2
    ${start_y}    Evaluate    ${eixo_y} / 2

    WHILE    ${True}
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    1
        IF    ${status}
            Exit For Loop
        END

        Swipe
        ...    start_x=${start_x}
        ...    start_y=${start_y}
        ...    offset_x=${start_x}
        ...    offset_y=0
        ...    duration=200
    END

Submit SMS Code
    [Arguments]    ${code}

    Wait Until Element Is Visible    ${TITLE_MODAL_SMS}
    Wait Until Element Is Visible    ${INSERIR_CODIGO_SMS}
    Click Element                    ${INSERIR_CODIGO_SMS}
    Input Text                       ${INSERIR_CODIGO_SMS}    ${code}
    Fechar Teclado
    Sleep    2
    Wait Until Element Is Visible    ${CONFIRMAR_CODIGO_SMS}
    Click Element                    ${CONFIRMAR_CODIGO_SMS}

Autorizar dispositivo caso necessario
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${CONTINUAR_SEM_AUTORIZAR}    20
    IF     ${status}    
        Clicar Elemento                  ${AUTORIZAR_DISPOSITIVO}
        Wait Until Element Is Visible    ${AUTORIZAR_DISPOSITIVO_DETALHE}
        Click Element                    ${AUTORIZAR_DISPOSITIVO_DETALHE}
        Clicar Elemento                  ${VOLTAR}
        Sleep    2    
        Run Keyword And Ignore Error    Wait Until Element Is Visible    ${PIX_HOME}
    ELSE
        Skip device pix
    END