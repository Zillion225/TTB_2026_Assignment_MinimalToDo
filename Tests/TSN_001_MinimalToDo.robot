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
${NIGHTMODE_SCREENSHOT_PATH}    ${CURDIR}/nightmode_full_screen.png

*** Test Cases ***
TS-001: Add Edit Remove ToDo Items _ TC-001 TC-002 TC-004
    [Documentation]    This test suite validates the core CRUD (Create, Read, Update, Delete) operations for ToDo items within the Minimal ToDo mobile application.
    ...
    ...    **TC-001: Add ToDo Item**: Verifies successful addition of ToDo items.
    ...    **TC-004: Edit ToDo Item Title**: Confirms the ability to modify existing ToDo item titles.
    ...    **TC-002: Remove ToDo Item**: Ensures proper removal of ToDo items.
    [Tags]    MinimalToDo    Regression    TS-001   TC-001    TC-002    TC-004
    ${original_item_list}   Set Variable    ${test_data_001['TS-001']['original_item']}
    ${edited_item_list}     Set Variable    ${test_data_001['TS-001']['edited_item']}
    # First, add the original items
    FOR    ${item}    IN    @{original_item_list}
        MinimalToDo_Feature.Perform Add ToDo Item    ${item['item_title']}
    END
    Log  Passed Test: TC-001
    # Now edit each item to the new title
    ${original_length}=    Get Length    ${original_item_list}
    FOR    ${index}    IN RANGE    0    ${original_length}
        ${original_title}=    Set Variable    ${original_item_list[${index}]['item_title']}
        ${new_title}=         Set Variable    ${edited_item_list[${index}]['item_title']}
        MinimalToDo_Feature.Perform Edit ToDo Item Title    ${original_title}    ${new_title}
    END
    Log  Passed Test: TC-004
    # Remove the edited items and verify they are no longer present
    FOR    ${item}    IN    @{edited_item_list}
        MinimalToDoPO.Remove ToDo Item    ${item['item_title']}
    END
    # Verify items have been removed
    FOR    ${item}    IN    @{edited_item_list}
        MinimalToDoPO.Verify ToDo Item Not Present  ${item['item_title']}
    END
    Log  Passed Test: TC-002

TS-002: Test Undo Feature After Removing ToDo Item _ TC-003
    [Documentation]    This test case validates the 'undo' functionality following the removal of ToDo items in the Minimal ToDo mobile application.
    ...
    ...    **TC-003: Undo Remove Item**: Verifies that a removed ToDo item can be successfully restored using the undo action.
    [Tags]    MinimalToDo    Regression    TS-002   TC-003
    ${test_data_list}   Set Variable    ${test_data_001['TS-002']['item_list']}
    ${test_data_after_undo_list}   Set Variable    ${test_data_001['TS-002']['expect_item_list_after_undo']}
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

TS-003: Test About And Navigation Back _ TC-005 TC-006
    [Documentation]    This test case verifies user interface interactions related to the About page and the application's theme settings.
    ...
    ...    **TC-005: Verify About Page Navigation**: Confirms correct navigation to and from the 'About' section.
    ...    **TC-006: Test Settings Night Mode Toggle**: Validates the functionality of switching between light and dark themes.
    [Tags]    MinimalToDo    Regression    TS-003    TC-005   TC-006
    ${expect_data_dict}   Set Variable    ${test_data_001['TS-003']['expect_data']}
    # Verify About Page Navigation
    Wait Until Element Is Visible   ${common_locator['lbl_empty_todo_items_text']}    timeout=${web_settings['long_timeout']}    error=Main page did not load properly.
    Page Should Contain Element    ${common_locator['lbl_empty_todo_items_text']}  
    MinimalToDoPO.Click Open About Menu
    Wait Until Element Is Visible   ${common_locator['about_page']['lbl_made_by']}    timeout=${web_settings['long_timeout']}    error=About page did not load properly.
    Page Should Contain Element    ${common_locator['about_page']['lbl_made_by']}  
    MinimalToDoPO.Click Navigate Back
    Wait Until Element Is Visible   ${common_locator['lbl_empty_todo_items_text']}    timeout=${web_settings['long_timeout']}    error=Main page did not load properly.
    Page Should Contain Element    ${common_locator['lbl_empty_todo_items_text']}
    Log  Passed Test: TC-005
    # Verify Settings Night Mode Toggle
    MinimalToDoPO.Click Open Settings Menu
    # Check initial state is 'off' and screen is light mode
    ${description_text}=    MinimalToDoSettingPO.Check Night Mode Description
    # Verify description indicates Night Mode is off
    Should Contain  ${description_text}  ${expect_data_dict['night_mode_off_text']}  msg=Expected Night Mode Description Text to indicate '${expect_data_dict['night_mode_off_text']}' state. but got: '${description_text}'
    # Verify initial screen is in light mode
    ${is_on_dark_mode}  CommonPO.Capture Screenshot And Check Is Image Dark    ${NIGHTMODE_SCREENSHOT_PATH}
    Should Be Equal    ${is_on_dark_mode}    ${False}    msg=Initial screen is not in light mode.
    # Toggle Night Mode and verify screen is in dark mode
    MinimalToDoSettingPO.Click Toggle Night Mode
    # Verify description indicates Night Mode is on
    ${description_text}=    MinimalToDoSettingPO.Check Night Mode Description
    Should Contain  ${description_text}  ${expect_data_dict['night_mode_on_text']}  msg=Expected Night Mode Description Text to indicate '${expect_data_dict['night_mode_on_text']}' state. but got: '${description_text}'
    # Verify screen is now in dark mode
    ${is_dark}=  CommonPO.Capture Screenshot And Check Is Image Dark    ${NIGHTMODE_SCREENSHOT_PATH}
    Should Be Equal    ${is_dark}    ${True}    msg=Screen is not in dark mode after toggling Night Mode.
    Log  Passed Test: TC-006

# TC-007: Remind Me Feature
#     [Documentation]    This test case is intended to validate the "Remind Me" feature, specifically its interaction with date and time pickers.
#     ...
#     ...    **Status**: Currently skipped due to technical limitations encountered with Espresso PickerActions on the testing environment, which prevents successful automation of this functionality.
#     Log  message="TC-007 is skipped due to machine limitations with Espresso PickerActions."
#     MinimalToDoPO.Click Add Item
#     MinimalToDoPO.Enter ToDo Item Title    Test Item with Reminder
#     MinimalToDoPO.Click Remind Me

