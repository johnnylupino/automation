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

*** Variables ***
${template-dir}        devdata
${OUTPUT_DIR}          devdata/template
${base-url}            http://localhost:8000
${theme-dir}           /Users/robot/git/moodle/moodle-4.2/theme
${theme-name}          Boost child
${search-pattern}      %%theme-name%%

*** Tasks ***
Copy template under theme dir
    #Enter theme name and copy template
    #Search regex
    List all dirs

*** Keywords ***
Enter theme name and copy template
    Add heading       Enter child theme name
    Add text input    text
    ${child-theme-name}=    Ask User
    Copy Directory    ${OUTPUT_DIR}    
    ...    ${theme-dir}${/}${child-theme-name}[text]
    Log To Console    ${child-theme-name}
    RETURN    ${child-theme-name}

Search regex
    ${files}=    RPA.FileSystem.List Files In Directory   
    ...    ${CURDIR}${/}devdata${/}template
    FOR    ${file}    IN    @{files}
        Log    ${file}
        ${file-content}=    Read File    ${file}
        Get Lines Containing String   ${file-content}    ${search-pattern}
    END
    
List all dirs
    @{dirs}=    RPA.FileSystem.List Directories In Directory
    ...    ${CURDIR}${/}devdata${/}template
    @{files}=    RPA.Filesystem.List Files In Directory
    ...    ${CURDIR}${/}devdata${/}template
    FOR    ${file}    IN    @{files}
        Log    ${file}      
    END
    FOR    ${dir}    IN    @{dirs}
        ${check}=    Is Directory Not Empty    ${dir}
        ${conv}=    Convert To String    ${dir}
        ${path}    ${split}=    Split Path    ${conv}
        Log    ${dir}
        @{sub-dirs}=    RPA.FileSystem.List Directories In Directory    
            ...    ${path}${/}${split}
        IF    ${check}         
            FOR    ${sub-dir}    IN    @{sub-dirs}
                Log   'sub-directories:' ${sub-dir}
            END
        END
    END
