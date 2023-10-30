*** Settings ***
Documentation       

Library             RPA.Browser.Selenium    auto_close=${False}
Library             RPA.Robocorp.Vault
Library             RPA.Tables
Library             RPA.Desktop
Library             RPA.JSON
Library             Collections
Library             String
Library             RPA.FileSystem
Library             RPA.Robocorp.WorkItems
Library    RPA.Robocorp.Process

*** Variables ***


*** Tasks ***
Simple task
    Log workitem

*** Keywords ***
Log workitem
    ${item}=    Get Input Work Item
    Log    ${item}[payload]
    