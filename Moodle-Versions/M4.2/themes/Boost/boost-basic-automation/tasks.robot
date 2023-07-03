*** Settings ***
Documentation       Basic Boost configuration using data provided in a template

Library             RPA.Browser.Selenium
Library             RPA.Robocorp.Vault
Library             RPA.Tables
Library             RPA.Desktop
Library             RPA.JSON
Library             Collections
Library             String
Library             RPA.FileSystem


*** Variables ***
${OUTPUT_FILE}          preset.scss
${base-url}             http://localhost:8000
${theme-name}           Boost
${theme-config}         devdata/theme-config.json
${site-name}            $.sitename
${site-summary}         $.description[*].summary
${colors}               $.colors[*]
${import}               $.import
${css}                  $.css[*]
${var_section}          $.variables_header
${import_section}       $.import_header
${rules_section}        $.rules_header
# collections
@{imports} =            ${import}
@{css_in_json} =        ${css}
@{colors_in_json} =     ${colors}


*** Tasks ***
Login to site
    Open login form
    Log In

Check selected theme
    Navigate to theme page and read HTML table

Process json
    Create preset file


*** Keywords ***
Open login form
    Open Available Browser    url=http://localhost:8000/login/index.php

Log In
    ${secret} =    Get Secret    mdl_admin
    Input Text    css:input#username    ${secret}[username]
    Input Password    css:input#password    ${secret}[password]
    Submit Form

Navigate to theme page and read HTML table
    Go To    ${base-url}/theme/index.php
    ${find_theme_name} =    Get Element Attribute    css:td.cell.c2.lastcol > h3    innerHTML
    IF    "${find_theme_name}" == "${theme-name}"
        Log To Console    ${find_theme_name}
    ELSE
        Log To Console    "Error, wrong theme, exiting..."
    END

Load json and read
    &{json-file} =    Load JSON from file    ${theme-config}
    ${sitename} =    Get values from JSON    ${json-file}    ${site-name}
    ${summary} =    Get values from JSON    ${json-file}    ${site-summary}
    RETURN    ${json-file}

Create preset file
    &{json-file} =    Load JSON from file    ${theme-config}
    Create File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    overwrite=True
    Create import section    ${json-file}
    Create rules section    ${json-file}

Create import section
    [Arguments]    ${json-file}
    ${import-section} =    Get value from JSON    ${json-file}    ${import_section}
    Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n${import-section}

    @{list} =    Get value from JSON    ${json-file}    ${import}
    FOR    ${var}    IN    @{list}
        Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n@import "${var}";
        Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n
        Log    @import "${var}"
    END

Create rules section
    [Arguments]    ${json-file}
    ${rules-section} =    Get value from JSON    ${json-file}    ${rules_section}
    Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n${rules-section}

    FOR    ${var}    IN    @{css_in_json}
        ${result} =    Get value from JSON    ${json-file}    ${var}
    END
    FOR    ${key}    IN    @{result}
        Log    ${key} ${result}[${key}]
        Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n${key}${result}[${key}]
    END
