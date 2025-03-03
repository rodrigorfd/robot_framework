*** Variables ***
${PLATFORM}  ${PLATFORM}
*** Settings ***
Library    AppiumLibrary    60
Variables   ../Data/Testdata.py
Variables   ../Locators/Locators-${PLATFORM}.py
Resource    ../KeywordDefinationFiles/GlobalKeywords.robot


*** Test Cases ***
Validar o app
    [tags]  Smoke

    Scroll Down To