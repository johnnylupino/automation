*** Settings ***
Documentation       Basic Boost configuration using data provided in a template

Library             RPA.Browser.Selenium    auto_close=${FALSE}
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
${brand_color}          $.colors[0]
${import}               $.import
${css}                  $.css[*]
${var_section}          $.variables_header
${import_section}       $.import_header
${rules_section}        $.rules_header
# collections
@{imports}              ${import}
@{css_in_json}          ${css}
@{colors_in_json}       ${colors}


*** Tasks ***
Login to site
    Open login form
    Log In

Check selected theme
    Navigate to theme page and read HTML table

Process json
    Create preset file
    Process preset file
    Upload preset file
    Save after preset upload
    Select preset file
    Set brand color


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
    ${find_theme_name} =    Get Element Attribute    css:td.cell.c1.lastcol > h3    innerHTML
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
    Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    // Preset number X \n
    Create variables section    ${json-file}
    Create import section    ${json-file}
    Create rules section    ${json-file}

Create variables section
    [Arguments]    ${json-file}
    ${var-section} =    Get value from JSON    ${json-file}    ${var_section}
    Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n${var-section}

    FOR    ${var}    IN    @{colors_in_json}
        ${result} =    Get value from JSON    ${json-file}    ${var}
    END
    FOR    ${key}    IN    @{result}
        Log    ${key} ${result}[${key}]
        Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n${key}:${result}[${key}]
    END
    Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n

Create import section
    [Arguments]    ${json-file}
    ${import-section} =    Get value from JSON    ${json-file}    ${import_section}
    Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n${import-section}

    @{list} =    Get value from JSON    ${json-file}    ${import}
    FOR    ${var}    IN    @{list}
        Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n@import "${var}";
        Log    @import "${var}"
    END
    Append To File    ${OUTPUT_DIR}${/}${OUTPUT_FILE}    \n

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

Process preset file
    Go To    ${base-url}/admin/settings.php?section=themesettingboost#theme_boost_general

Upload preset file
    ${file-uploader} =    Click Element When Visible    css:div.filemanager-toolbar a[title="Add..."]
    Wait Until Element Is Visible    css:input[type="file"]    timeout=45.0
    Choose File    css:input[type="file"]    ${OUTPUT_DIR}${/}${OUTPUT_FILE}
    Set Browser Implicit Wait    5 seconds
    Click Button    class:fp-upload-btn

Save after preset upload
    Wait Until Page Does Not Contain    class:fp-upload-btn   timeout=25.0
    Click Button When Visible    //button[text()='Save changes']

Select preset file
    Select From List By Value   name:s_theme_boost_preset    ${OUTPUT_FILE}
    Set Browser Implicit Wait    5 seconds
    Click Button When Visible    //button[text()='Save changes']
    Reload Page

Set brand color
     &{json-file} =    Load JSON from file    ${theme-config}
     Log     ${json-file}
     &{brand} =    Get value from JSON    ${json-file}     ${brand_color}
     Log    ${brand}
     #Input Text    s_theme_boost_brandcolor    ${brand}
     #Click Button When Visible    //button[text()='Save changes']
     #Reload Page
