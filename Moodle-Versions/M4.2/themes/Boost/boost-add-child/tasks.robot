*** Settings ***
Documentation       Use template in devdata to create a child Boost theme 

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Robocorp.Vault
Library             RPA.FileSystem
Library             RPA.FTP


*** Variables ***
${OUTPUT_DIR}          devdata/template
${base-url}            http://localhost:8000
${theme-name}          Boost child

*** Tasks ***
Go to theme directory
    CMD checks

*** Keywords ***
CMD checks
    Pwd
    
