*** Settings ***
# Import necessary libraries and resources
Library     AppiumLibrary    # For interacting with mobile applications
Resource    ./CommonPO.robot    # Common resource file containing reusable keywords

*** Keywords ***
Test setup
    [Documentation]    Initializes the test by launching the mobile app, starting screen recording, and closing any popup banners.
    [Arguments]
    ...    ${capability_json_file_path}    # Path to the JSON file containing app capabilities

    # Launch the mobile application using the provided capabilities
    CommonPO.Launch mobile app    json_path=${capability_json_file_path}
    # Start recording the screen for the test session
    Start Screen Recording
    
Test stop
    [Documentation]    Stops screen recording and closes the application after the test.
    Stop Screen Recording
    Close Application

Click Add Item
    [Documentation]    Clicks the button to add a new ToDo item.
    [Arguments]  ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_add_todo_item']}    timeout=${timeout}    error=Add Item button is not visible.
    Click Element    ${common_locator['btn_add_todo_item']}

Enter ToDo Item Title
    [Documentation]    Enters the title for the new ToDo item.
    [Arguments]    ${input_text}    ${clear_text}=${False}    ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['txt_todo_item_title']}    timeout=${timeout}   error=ToDo Item Title input field is not visible.
    IF    ${clear_text}
        Clear Text    ${common_locator['txt_todo_item_title']}
    END
    Input Text    ${common_locator['txt_todo_item_title']}    ${input_text}

Click Remind Me
    [Documentation]    Clicks the 'Remind Me' toggle for the ToDo item.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['rdn_todo_remind_me']}    timeout=${timeout}   error=Remind Me option is not visible.
    Click Element    ${common_locator['rdn_todo_remind_me']}

Submit ToDo Item
    [Documentation]    Submits the new ToDo item after entering the title.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_todo_submit_item']}    timeout=${timeout}  error=Submit ToDo Item button is not visible.
    Click Element    ${common_locator['btn_todo_submit_item']}

Verify ToDo Item Added
    [Documentation]    Verifies that the ToDo item with the specified title has been added
    [Arguments]    ${item_title}    ${timeout}=${web_settings['long_timeout']}
    ${locator}=    CommonPO.Locator Builder    ${common_locator['lbl_todo_item']}    {{item_title}}    ${item_title}
    Wait Until Element Is Visible   ${locator}    timeout=${timeout}    error=ToDo item with title "${item_title}" was not added.

Verify ToDo Item Not Present
    [Documentation]    Verifies that the ToDo item with the specified title is not present.
    [Arguments]    ${item_title}    ${timeout}=${web_settings['long_timeout']}
    ${locator}=    CommonPO.Locator Builder    ${common_locator['lbl_todo_item']}    {{item_title}}    ${item_title}
    Wait Until Page Does Not Contain Element   ${locator}    timeout=${timeout}    error=ToDo item with title "${item_title}" is still present on the page.

Remove ToDo Item
    [Documentation]    Removes the ToDo item with the specified title.
    [Arguments]    ${item_title}    ${timeout}=${web_settings['long_timeout']}
    ${locator}=    CommonPO.Locator Builder    ${common_locator['lbl_todo_item']}    {{item_title}}    ${item_title}
    Wait Until Element Is Visible   ${locator}    timeout=${timeout}    error=ToDo item with title "${item_title}" is not visible for removal.
    CommonPO.Swipe Element Horizontal   ${locator}    ${web_settings['swipe_remove_todo_offset']}

Click Undo Remove Item
    [Documentation]    Clicks the 'UNDO' button to restore the last removed ToDo item.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_todo_remove_undo']}    timeout=${timeout}   error=UNDO button is not visible.
    Click Element    ${common_locator['btn_todo_remove_undo']}

Click Open Settings Menu
    [Documentation]    Clicks the button to open the settings menu.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_more_option']}    timeout=${timeout}    error=Overflow Menu button is not visible.
    Click Element    ${common_locator['btn_more_option']}
    Sleep    ${web_settings['brief_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_overflow_settings']}    timeout=${timeout}   error=Open Settings button is not visible.
    Click Element    ${common_locator['btn_overflow_settings']}

Click Open About Menu
    [Documentation]    Clicks the button to open the About menu.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_more_option']}    timeout=${timeout}    error=Overflow Menu button is not visible.
    Click Element    ${common_locator['btn_more_option']}
    Sleep    ${web_settings['brief_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_overflow_about']}    timeout=${timeout}   error=Open About button is not visible.
    Click Element    ${common_locator['btn_overflow_about']}

Click Navigate Back
    [Documentation]    Clicks the device back button to navigate back.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_navigation_back']}    timeout=${timeout}    error=Navigation Back button is not visible.
    Click Element    ${common_locator['btn_navigation_back']}

Click Select Date
    [Documentation]    Clicks the 'Select Date' option for setting a reminder.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_todo_select_date']}    timeout=${timeout}   error=Select Date option is not visible.
    Click Element    ${common_locator['btn_todo_select_date']}

Click Select Time
    [Documentation]    Clicks the 'Select Time' option for setting a reminder.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['btn_todo_select_time']}    timeout=${timeout}   error=Select Time option is not visible.
    Click Element    ${common_locator['btn_todo_select_time']}