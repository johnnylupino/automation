*** Settings ***
Documentation       Basic Boost configuration using data provided in a template

Library             RPA.Browser.Selenium
Library             RPA.Robocorp.Vault
Library             RPA.Tables
Library             RPA.Desktop
Library             RPA.JSON
Library             Collections
Library             RPA.Cloud.Azure


*** Variables ***
${base_url}             http://localhost:8000
${theme_name}           Boost
${theme-config}         devdata/theme-config.json
${site-name}            $.sitename
${site-summary}         $.description[*].summary
${colors}               $.colors[*]
${css}                  $.css[*]
# collections
@{site-info} =          ${site-name}    ${site-summary}
@{css_in_json} =        ${css}
@{colors_in_json} =     ${colors}


*** Tasks ***
Login to site
    Open login form
    Log In

Check selected theme
    Navigate to theme page and read HTML table

Process json
    # Load json and read
    Loop over list of css rules
    # Process json scss variables


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
    &{json-file} =    Load JSON from file    ${theme-config}
    ${sitename} =    Get values from JSON    ${json-file}    ${site-name}
    ${summary} =    Get values from JSON    ${json-file}    ${site-summary}
    ${css} =    Get values from JSON    ${json-file}    ${css}
    RETURN    ${json-file}

Loop over list of css rules
    &{json-file} =    Load JSON from file    ${theme-config}
    FOR    ${var}    IN    @{css_in_json}
        ${result} =    Get value from JSON    ${json-file}    ${var}
        Log    \nOUTPUT IS\n ${result}    console=${True}
    END

Process json scss variables
# split the output by delimiter and insert intopreset.scss

Open preset file and insert data
