*** Settings ***
Documentation       Basic Boost configuration using data provided in a template

Library             RPA.Browser.Selenium
Library             RPA.Robocorp.Vault
Library             RPA.Tables
Library             RPA.Desktop
Library             RPA.JSON


*** Variables ***
${base_url}         http://localhost:8000
${theme_name}       Boost
${theme-config}     devdata/theme-config.json


*** Tasks ***
Login to site
    Open login form
    Log In

Check selected theme
    Navigate to theme page and read HTML table

Process json
    Load json and read
    Get sitename and description from json


*** Keywords ***
Open login form
    Open Available Browser    url=http://localhost:8000/login/index.php

Log In
    ${secret} =    Get Secret    mdl_admin
    Input Text    css:input#username    ${secret}[username]
    Input Password    css:input#password    ${secret}[password]
    Submit Form

Navigate to theme page and read HTML table
    Go To    ${base_url}/theme/index.php
    ${find_theme_name} =    Get Element Attribute    css:td.cell.c2.lastcol > h3    innerHTML
    IF    "${find_theme_name}" == "${theme_name}"
        Log To Console    ${find_theme_name}
    ELSE
        Log To Console    "Error, wrong theme, exiting..."
    END

Load json and read
    ${json-file} =    Load JSON from file    ${theme-config}
    RETURN    ${json-file}

Get sitename and description from json
    ${file-content} =    Load json and read
    Log To Console    ${file-content}
