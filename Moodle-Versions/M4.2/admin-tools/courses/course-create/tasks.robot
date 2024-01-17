*** Settings ***
Documentation       Robot to create a Moodle course without resources and activities

Library             RPA.Browser.Playwright
Library             RPA.HTTP
Library             RPA.Robocorp.Vault


*** Tasks ***
Log in
    Open login form
    Log In


*** Keywords ***
Open login form
    New Browser    chromium    headless=false
    New Context
    New Page    http://localhost:8000/login/index.php 


Log In
    ${secret} =    Get Secret    mdl_admin
    Fill Text    css=input\#username    ${secret}[username]
    Fill Text    css=input\#password    ${secret}[password]
    Click    css=\#loginbtn
