*** Settings ***
Documentation       Robot to create a Moodle course without resources and activities

Library             RPA.Browser.Playwright
Library             RPA.HTTP
Library             RPA.Robocorp.Vault
Library             RPA.Assistant         
Library             RPA.Tables

*** Variables ***
${base_url}            http://localhost:8000
${course_categories}   /course/management.php
${category_id}         categoryid=1
${fullname_sel}        id_fullname
${fullname_txt}        Test
${shortname_sel}       id_shortname
${shortname_txt}       Test
${course_save}         id_saveandreturn
${course_formats_list}     /admin/settings.php?section=manageformats
${FORMATS_TABLE_LOCATOR}    xpath=//table[contains(@class, 'manageformattable')]
${TD_LOCATOR}    cell.c0

*** Tasks ***
Create a course
    Open login form
    Log In
    #Check default format
    Find available and enabled course formats


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
    ${get_selected} =     Get Selected Options    ${format_selector}    label    ==    Topics format
    Confirmation dialog    @{get_selected}

Confirmation dialog
    [Arguments]    ${get_selected}
    Add heading   Happy to use ${get_selected} as default course format?    size=Small
    Add submit buttons    buttons=No,Yes    default=Yes
    ${result} =    Run dialog
    IF   $result.submit == "Yes"
        Navigate to course management page
    END 
Navigate to course management page
    Go To    ${base_url}${course_categories}?${category_id}
    Click    text=Create new course
    Fill Text    id=${fullname_sel}    ${fullname_txt}
    Fill Text    id=${shortname_sel}    ${shortname_txt}
    Click    id=${course_save}
    Find course ID by name
    Find available and enabled course formats

Find course ID by name
    ${course_link} =     Get Element    xpath=//a[contains(@class, 'coursename') and text()='${fullname_txt}']

Find available and enabled course formats
    Go To    ${base_url}${course_formats_list}      
    ${table}=    Set Variable    xpath=//table[contains(\@class, 'manageformattable')]
    ${e}=    Get Table Cell Element    ${table}    0  1   
    @{rows}=    Get Elements    ${FORMATS_TABLE_LOCATOR}
    FOR    ${row}    IN    @{rows}
        ${cells}=    Get Elements   ${row} >> td.cell.c0
        FOR    ${cell}    IN    @{cells}
        ${cell_text}=    Get Text    ${cell}
        Log    ${cell_text}
        END
    END