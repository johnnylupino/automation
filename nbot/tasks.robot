*** Settings ***
Documentation       Robot finds pre-defined searches for stats and charting

Library             RPA.Browser.Playwright
Library             RPA.Robocorp.Vault
Library             Collections
Library             RPA.FileSystem

*** Variables ***
${source_url}            https://app.nbot.pl
${login_form}            /#/login
${dashboard}             /#/dashboard
${offers_page}           /#/base/offers
${search_page}           /#/base/search
${search_source}         devdata/search_list.txt
        

*** Tasks ***
Open Nbot
    #Open login form
    #Log In
    #Go to Search
    Search and find values
    

*** Keywords ***
Open login form
    New Browser    chromium    headless=false
    New Context
    New Page    ${source_url}${login_form}


Log In
   ${secret} =    Get Secret    nbot_makler
   ${elements1} =    Get Elements    css=input[name="login"]
   ${elem1} =    Get From List    ${elements1}    0
   ${elements2} =    Get Elements    css=input[name="password"]
   ${elem2} =    Get From List    ${elements2}    0
   ${elements3} =    Get Elements    css=button[type="button"]
   ${elem3} =    Get From List    ${elements3}    0
   Fill Text     ${elem1}   ${secret}[login]
   Fill Text     ${elem2}    ${secret}[password]
   Click    ${elem3}
    
Go to Search
    Go To    ${source_url}${search_page}
   # Search and find values


Search and find values
    ${list} =    Read File    ${search_source}
    FOR    ${element}    IN    ${list}
        Log    ${element}
        
    END


   
