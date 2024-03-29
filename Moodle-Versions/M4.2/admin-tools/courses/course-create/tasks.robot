*** Settings ***
Documentation       Robot to create a Moodle course without resources and activities

Library             RPA.Browser.Playwright
Library             RPA.HTTP
Library             RPA.Robocorp.Vault
Library             RPA.Assistant         
Library             Collections

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
${TD_LOCATOR}    td.cell.c0
@{avail_course_formats}
@{avail_activities_resources}    assign    label    quiz

*** Tasks ***
Create a course
    Open login form
    Log In
    Check default format
    #Find available and enabled course formats


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
    ELSE
        Find available and enabled course formats
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
        ${cells}=    Get Elements   ${row} >> ${TD_LOCATOR}
        FOR    ${cell}    IN    @{cells}
        ${cell_text}=    Get Text    ${cell}
        Append To List    ${avail_course_formats}    ${cell_text}
        END
    END
    Confirmation dialog2    ${avail_course_formats}

Confirmation dialog2
    [Arguments]    ${avail_course_formats}
    Add heading   Select course formats  size=Small
    Add Radio Buttons
    ...    name=new_course_format
    ...    options=${avail_course_formats}
    Add Text    Ensure selected format is enabled on the site
    Add submit buttons    buttons=Cancel,Submit    default=Submit
     ${result} =    Run dialog
    IF   $result.submit == "Submit"
        Select activities and resources    @{avail_activities_resources}
    END 

Select activities and resources
    [Arguments]    @{avail_activities_resources}
    Add heading   Enable activity/resource  size=Small
    FOR    ${element}    IN    @{avail_activities_resources}
        Add checkbox    name=${element}      label=${element}
    END
    Add Text    This automation task will create empty activities/resources
    Add submit buttons    buttons=Cancel,Submit    default=Submit
     ${result} =    Run dialog
         #IF    $result.vault
    #    Enable vault
    #END