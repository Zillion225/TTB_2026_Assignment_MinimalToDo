*** Settings ***
# Import libraries and resources
Library             AppiumLibrary    # For interacting with mobile applications
Resource            ../Resources/PageObjects/CommonPO.robot
Resource            ../Resources/Features/MinimalToDo_Feature.robot
Resource            ../Resources/PageObjects/MinimalToDoSettingPO.robot
Variables           ../Resources/TestData/data_0001.yaml

# Define test setup and teardown
Test Setup          MinimalToDoPO.Test setup    capability_json_file_path=${CAPABILITY_JSON_FILE}
Test Teardown       MinimalToDoPO.Test stop


*** Variables ***
# Define constants for the test
${CAPABILITY_JSON_FILE}     Resources/Capabilities.json    # Path to JSON file containing capabilities
${SCREENSHOT_PATH}    ${CURDIR}/full_screen.png

*** Test Cases ***
TC-001: Add ToDo Item
    [Documentation]    Test Case to add ToDo items to the Minimal ToDo mobile application.
    [Tags]    MinimalToDo    Smoke    Regression    TC-001
    ${test_data_list}   Set Variable    ${test_data_001['TC001']['item_list']}
    FOR    ${item}    IN    @{test_data_list}
        MinimalToDo_Feature.Perform Add ToDo Item    ${item['item_title']}
    END
    Log  Passed Test: TC-001

TC-002: Add ToDo Item And Remove Item
    [Documentation]    Test Case to add and then remove ToDo items from the Minimal ToDo mobile application.
    [Tags]    MinimalToDo    Regression    TC-002
    ${test_data_list}   Set Variable    ${test_data_001['TC002']['item_list']}
    # First, add the items
    FOR    ${item}    IN    @{test_data_list}
        MinimalToDo_Feature.Perform Add ToDo Item    ${item['item_title']}
    END
    # Now remove the added items and verify they are no longer present
    FOR    ${item}    IN    @{test_data_list}
        MinimalToDoPO.Remove ToDo Item    ${item['item_title']}
    END
    # Verify items have been removed
    FOR    ${item}    IN    @{test_data_list}
        MinimalToDoPO.Verify ToDo Item Not Present  ${item['item_title']}
    END
    Log  Passed Test: TC-002

TC-003: Test Undo Feature After Removing ToDo Item
    [Documentation]   Test Case to add ToDo items, remove them, and then undo the removal in the Minimal ToDo mobile application.
    [Tags]    MinimalToDo    Regression    TC-003
    ${test_data_list}   Set Variable    ${test_data_001['TC003']['item_list']}
    ${test_data_after_undo_list}   Set Variable    ${test_data_001['TC003']['expect_item_list_after_undo']}
    # First, add the items
    FOR    ${item}    IN    @{test_data_list}
        MinimalToDo_Feature.Perform Add ToDo Item    ${item['item_title']}
    END
    # Now remove the added items and verify they are no longer present
    FOR    ${item}    IN    @{test_data_list}
        MinimalToDoPO.Remove ToDo Item    ${item['item_title']}
    END
    MinimalToDoPO.Click Undo Remove Item
    FOR    ${item}    IN    @{test_data_after_undo_list}
        MinimalToDoPO.Verify ToDo Item Added    ${item['item_title']}
    END
    Log  Passed Test: TC-003

TC-004: Edit ToDo Item Title
    [Documentation]    Test Case to add a ToDo item and then edit its title in the Minimal ToDo mobile application.
    [Tags]    MinimalToDo    Regression    TC-004
    ${original_item_list}   Set Variable    ${test_data_001['TC004']['original_item']}
    ${edited_item_list}     Set Variable    ${test_data_001['TC004']['edited_item']}
    # First, add the original items
    FOR    ${item}    IN    @{original_item_list}
        MinimalToDo_Feature.Perform Add ToDo Item    ${item['item_title']}
    END
    # Now edit each item to the new title
    ${original_length}=    Get Length    ${original_item_list}
    FOR    ${index}    IN RANGE    0    ${original_length}
        ${original_title}=    Set Variable    ${original_item_list[${index}]['item_title']}
        ${new_title}=         Set Variable    ${edited_item_list[${index}]['item_title']}
        MinimalToDo_Feature.Perform Edit ToDo Item Title    ${original_title}    ${new_title}
    END
    Log  Passed Test: TC-004

TC-005: Test About And Navigation Back
    [Documentation]    Test Case to verify the About page and navigation back functionality in the Minimal ToDo mobile application.
    [Tags]    MinimalToDo    Regression    TC-005
    Wait Until Element Is Visible   ${common_locator['lbl_empty_todo_items_text']}    timeout=${web_settings['long_timeout']}    error=Main page did not load properly.
    Page Should Contain Element    ${common_locator['lbl_empty_todo_items_text']}  
    MinimalToDoPO.Click Open About Menu
    Wait Until Element Is Visible   ${common_locator['about_page']['lbl_made_by']}    timeout=${web_settings['long_timeout']}    error=About page did not load properly.
    Page Should Contain Element    ${common_locator['about_page']['lbl_made_by']}  
    MinimalToDoPO.Click Navigate Back
    Wait Until Element Is Visible   ${common_locator['lbl_empty_todo_items_text']}    timeout=${web_settings['long_timeout']}    error=Main page did not load properly.
    Page Should Contain Element    ${common_locator['lbl_empty_todo_items_text']}
    Log  Passed Test: TC-005

TC-006: Test Settings Night Mode Toggle
    [Tags]    MinimalToDo    Regression    TC-006
    MinimalToDoPO.Click Open Settings Menu
    # Check initial state is 'off' and screen is light mode
    ${description_text}=    MinimalToDoSettingPO.Check Night Mode Description
    # Verify description indicates Night Mode is off
    Should Contain  ${description_text}  off  msg=Night Mode Description Text does not indicate 'off' state.
    # Verify initial screen is in light mode
    ${is_on_dark_mode}  CommonPO.Capture Screenshot And Check Is Image Dark    ${SCREENSHOT_PATH}
    Should Be Equal    ${is_on_dark_mode}    ${False}    msg=Initial screen is not in light mode.
    # Toggle Night Mode and verify screen is in dark mode
    MinimalToDoSettingPO.Click Toggle Night Mode
    # Verify description indicates Night Mode is on
    ${description_text}=    MinimalToDoSettingPO.Check Night Mode Description
    Should Contain  ${description_text}  on  msg=Night Mode Description Text does not indicate 'on' state.
    # Verify screen is now in dark mode
    ${is_dark}=  CommonPO.Capture Screenshot And Check Is Image Dark    ${SCREENSHOT_PATH}
    Should Be Equal    ${is_dark}    ${True}    msg=Screen is not in dark mode after toggling Night Mode.
    Log  Passed Test: TC-006

TC-007: Remind Me Feature
    # This test case is skipped due to machine limitations.
    # This app uses Espresso PickerActions for the DatePicker, but my phone is having trouble with them. 
    # This is blocking me from completing the automation.
    Log  message="TC-007 is skipped due to machine limitations with Espresso PickerActions."
