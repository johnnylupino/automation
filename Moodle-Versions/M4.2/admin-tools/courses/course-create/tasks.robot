*** Settings ***
Documentation       Robot to create a Moodle course without resources and activities

Library             RPA.Browser.Playwright
Library             RPA.HTTP
Library             RPA.Robocorp.Vault
Library             RPA.Assistant         
Library    RPA.MSGraph

*** Variables ***
${base_url}            http://localhost:8000
*** Tasks ***
Create a course
    Open login form
    Log In
    Check default format


*** Keywords ***
Open login form
    New Browser    chromium    headless=false
    New Context
    New Page    ${base_url}/login/index.php 


Log In
    ${secret} =    Get Secret    mdl_admin
    Fill Text    css=input\#username    ${secret}[username]
    Fill Text    css=input\#password    ${secret}[password]
    Click    css=\#loginbtn

Check default format
    Go To    ${base_url}/admin/settings.php?section=coursesettings
    ${format_selector} =    Get Element    id=id_s_moodlecourse_format
    @{get_selected} =     Get Selected Options    ${format_selector}    label    ==    Topics format
    Confirmation dialog    @{get_selected}
Confirmation dialog
    [Arguments]    @{get_selected}
    Add heading   Happy to use @{get_selected} as default course format?
    Add submit buttons    buttons=No,Yes    default=Yes
    ${result}=    Run dialog
    #IF   $result.submit == "Yes"
    #    Delete user    ${username}
    #END 

   




