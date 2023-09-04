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
Library    RPA.Images

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
    List files in sub directories    theme-new-dir=${theme-new-dir}
    List all files in template dir    theme-new-dir=${theme-new-dir}


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
    
List files in sub directories
    [Arguments]    ${theme-new-dir}
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
                Search for files in sub-directory    sub-dir=${sub-dir}
            END
        END
    END

List all files in template dir
    [Arguments]    ${theme-new-dir}
    @{files}=    RPA.Filesystem.List Files In Directory
    ...    ${theme-new-dir}
    FOR    ${file}    IN    @{files}
        Log  'Files in base dir:' ${file}
        Search for pattern    search-pattern=${search-pattern}    file=${file}
    END

Search for pattern
    [Arguments]    ${search-pattern}    ${file}
    ${file-content}=    Read File    ${file}
    ${result}=    Get Lines Containing String   ${file-content}    ${search-pattern}

Search for files in sub-directory
    [Arguments]    ${sub-dir}
    @{files}=    RPA.Filesystem.List Files In Directory    ${sub-dir}
    FOR    ${file}    IN    @{files}
      Log  'Files in sub-directories:' ${file}
        Search for pattern    search-pattern=${search-pattern}    file=${file}
    END

#Replace pattern in files
   # [Arguments]    ${search-pattern}    ${file}    ${child-theme-name}
   # Replace String    ${search-pattern}    ${file}    ${child-theme-name}
