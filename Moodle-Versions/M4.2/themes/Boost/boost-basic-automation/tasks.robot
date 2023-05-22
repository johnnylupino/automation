*** Settings ***
Documentation       Basic Boost configuration using data provided in a template

Library             RPA.Browser.Selenium
Library             RPA.Robocorp.Vault


*** Tasks ***
Login to site
    Open login form
    Log In


*** Keywords ***
Open login form
    Open Available Browser    url=http://localhost:8000/login/index.php

Log In
    ${secret} =    Get Secret    mdl_admin
    Input Text    css:input#username    ${secret}[username]
    Input Password    css:input#password    ${secret}[password]
    Submit Form
