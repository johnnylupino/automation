*** Settings ***
Documentation       This robot will convert HTML docs from a folder into PDF files

Library    RPA.Browser.Selenium
Library    RPA.PDF
Library    RPA.FileSystem


*** Variables ***
${html_folder}    /devdata/html
${pdf_output}    /devdata/pdf


*** Tasks ***
Minimal task
    #Go to folder    ${html_folder}
    Log    Done

*** Keywords ***
#Go to folder
 #   [Arguments]    ${html_folder}
    



