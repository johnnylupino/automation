*** Settings ***
Documentation       

Library             RPA.Browser.Selenium
Library             RPA.Robocorp.Vault

*** Variables ***
${base_url}            http://localhost:8000
${appearance}          /theme/index.php
${theme_select}        /admin/search.php#linkappearance
*** Tasks ***
Login and check selected theme
    Open Available Browser
    Open login form
    Check selected theme
*** Keywords ***
Open login form
    Go To    ${base_url}/login/index.php 
    ${secret} =    Get Secret    mdl_admin
    Input Text   css=input\#username    ${secret}[username]
    Input Text    css=input\#password    ${secret}[password]
    Submit Form

Check selected theme
    Go To    ${base_url}${appearance}
    ${selected_value}=    Get Text    xpath=//table/tbody/tr[1]/td[2]
    Log    Selected value is: ${selected_value}
    Go To     ${base_url}${theme_select}
    [Teardown]    Close Browser