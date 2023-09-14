*** Settings ***
Documentation       Use template in devdata to create a child Boost theme. 
...    Requires robotframework extensions added in conda.yaml (e.g SSHLibrary)

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Robocorp.Vault
Library             RPA.FileSystem   
Library             SSHLibrary 
Library             RPA.Assistant
Library             String
Library             OperatingSystem
Library             Collections
Library             Process

*** Variables ***
${template-dir}        devdata
${OUTPUT_DIR}          devdata/template
${base-url}            http://localhost:8000
${theme-dir}           /Users/robot/git/moodle/moodle-4.2/theme
${search-pattern}      %%theme-name%%

*** Tasks ***
Copy template under theme dir
    ${child-theme-name}=    Enter theme name and copy template
    ${theme-new-dir}=    Copy template    ${child-theme-name}
    ${confirm}=    Confirm theme name replaced in template dir    ${theme-new-dir}
    #${cond}=    Should Not Be Empty    ${confirm}
    #Pass Execution If    ${cond}   Theme name already replaced
    Search all files in sub directories    theme-new-dir=${theme-new-dir}    child-theme-name=${child-theme-name}
    Search all files in template dir    theme-new-dir=${theme-new-dir}   child-theme-name=${child-theme-name} 


*** Keywords ***
Enter theme name and copy template
    Add heading       Enter child theme name
    Add text input    text
    ${child-theme-name}=    Ask User
    RETURN    ${child-theme-name}

Copy template
    [Arguments]    ${child-theme-name}
    RPA.FileSystem.Copy Directory    ${OUTPUT_DIR}    
    ...    ${theme-dir}${/}${child-theme-name}[text]
    ${theme-new-dir}=    Set Variable    ${theme-dir}${/}${child-theme-name}[text]
    RETURN    ${theme-new-dir}
    
Search all files in sub directories
    [Arguments]    ${theme-new-dir}    ${child-theme-name}
    @{dirs}=    RPA.FileSystem.List Directories In Directory
    ...    ${theme-new-dir}
    FOR    ${dir}    IN    @{dirs}
        ${check}=    Is Directory Not Empty    ${dir}
        ${conv}=    Convert To String    ${dir}
        ${path}    ${split}=    Split Path    ${conv}
        Log    ${dir}
        @{sub-dirs}=    RPA.FileSystem.List Directories In Directory    
            ...    ${path}${/}${split}
        IF    ${check}         
            FOR    ${sub-dir}    IN    @{sub-dirs}
                Log   'Available sub-directories:' ${sub-dir}
                Search for files in sub-directory    sub-dir=${sub-dir}    child-theme-name=${child-theme-name}
            END
        END
    END

Search all files in template dir
    [Arguments]    ${theme-new-dir}    ${child-theme-name}
    @{files}=    RPA.Filesystem.List Files In Directory
    ...    ${theme-new-dir}
    FOR    ${file}    IN    @{files}
        Run    sed -i '' 's/${search-pattern}/${child-theme-name}[text]/g' ${file}
    END

Search for pattern
    [Arguments]    ${search-pattern}    ${file}
    ${file-content}=    Read File    ${file}
    ${result}=    Get Lines Containing String   ${file-content}    ${search-pattern}
    RETURN    ${result}

Search for files in sub-directory
    [Arguments]    ${sub-dir}   ${child-theme-name} 
    @{files}=    RPA.Filesystem.List Files In Directory    ${sub-dir}
    FOR    ${file}    IN    @{files}
        Run   rename 's/${search-pattern}/${child-theme-name}[text]/' ${file}
        Run    sed -i '' 's/${search-pattern}/${child-theme-name}[text]/g' ${file}
    END

Confirm theme name replaced in template dir
    [Arguments]    ${theme-new-dir}
    @{files}=    RPA.Filesystem.List Files In Directory
    ...    ${theme-new-dir}
    FOR    ${file}    IN    @{files}
        Log  'Files in base dir:' ${file}
        ${result}=    Search for pattern    search-pattern=${search-pattern}    file=${file}
    END
    RETURN    ${result}


    #need function for en/ directory - name not replaced - available subdirectories!