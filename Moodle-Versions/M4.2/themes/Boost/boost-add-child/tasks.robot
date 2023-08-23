*** Settings ***
Documentation       Use template in devdata to create a child Boost theme. 
...    Requires robotframework extensions added in conda.yaml (e.g SSHLibrary)

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Robocorp.Vault
Library             RPA.FileSystem   
Library             SSHLibrary 
Library             RPA.Assistant

*** Variables ***
${OUTPUT_DIR}          devdata/template
${base-url}            http://localhost:8000
${theme-dir}           /Users/robot/git/moodle/moodle-4.2/theme
${theme-name}          Boost child
${test-dir}            /Users/robot/test-dir

*** Tasks ***
Copy template under theme dir
    Enter theme name and copy template

*** Keywords ***
Enter theme name and copy template
    Add heading       Enter child theme name
    Add text input    text
    ${child-theme-name}=    Ask User
    Copy Directory    ${OUTPUT_DIR}    
    ...    ${test-dir}${/}${child-theme-name}[text]

    
