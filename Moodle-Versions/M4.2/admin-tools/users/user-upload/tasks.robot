*** Settings ***
Documentation       Robot to automatically create users by uploading users.csv

Library             RPA.Browser.Playwright
Library             RPA.FileSystem
Library             RPA.Robocorp.Vault

*** Variables ***
${site-url}        http://localhost:8000
${login-url}       login/index.php
${upload-url}      admin/tool/uploaduser/index.php

*** Tasks ***
Upload csv
   Login to site


*** Keywords ***
Login to site
    New Page    ${site-url}${/}${login-url}
    ${secret}=    Get Secret    mdl_admin
    Type Text    input#username    ${secret}[username]
    Type Text    input#password    ${secret}[password]
    Click    'Log in'
    Go To    ${site-url}${/}${upload-url}
    Close Browser
