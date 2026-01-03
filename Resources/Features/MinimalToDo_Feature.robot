*** Settings ***
# Import necessary libraries and resources
Resource    ../PageObjects/MinimalToDoPO.robot

*** Keywords ***
Perform Add ToDo Item
    [Documentation]    Performs the complete flow of adding a ToDo item with the specified title.
    [Arguments]    ${item_title}    ${timeout}=${web_settings['long_timeout']}
    MinimalToDoPO.Click Add Item
    MinimalToDoPO.Enter ToDo Item Title    ${item_title}
    MinimalToDoPO.Submit ToDo Item
    MinimalToDoPO.Verify ToDo Item Added    ${item_title}

Perform Edit ToDo Item Title
    [Documentation]    Performs the complete flow of editing a ToDo item's title.
    [Arguments]    ${original_title}    ${new_title}    ${timeout}=${web_settings['long_timeout']}
    ${locator}=    CommonPO.Locator Builder    ${common_locator['lbl_todo_item']}    {{item_title}}    ${original_title}
    Wait Until Element Is Visible   ${locator}    timeout=${timeout}    error=ToDo item with title "${original_title}" is not present for editing.
    Click Element    ${locator}
    MinimalToDoPO.Enter ToDo Item Title    ${new_title}  clear_text=${True}
    MinimalToDoPO.Submit ToDo Item
    MinimalToDoPO.Verify ToDo Item Added    ${new_title}