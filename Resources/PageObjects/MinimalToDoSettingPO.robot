*** Settings ***
# Import necessary libraries and resources
Library     AppiumLibrary    # For interacting with mobile applications
Resource    ./CommonPO.robot    # Common resource file containing reusable keywords

*** Keywords ***
Click Toggle Night Mode
    [Documentation]    Toggles the Night Mode setting in the Minimal ToDo application.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['setting_page']['ckn_night_mode']}    timeout=${timeout}   error=Night Mode checkbox is not visible.
    Click Element    ${common_locator['setting_page']['ckn_night_mode']}

Check Night Mode Description
    [Documentation]    Checks the description text for the Night Mode setting.
    [Arguments]    ${timeout}=${web_settings['min_timeout']}
    Wait Until Element Is Visible   ${common_locator['setting_page']['lbl_night_mode_desc']}    timeout=${timeout}    error=Night Mode description does not match expected text.
    ${text}=  AppiumLibrary.Get Text    ${common_locator['setting_page']['lbl_night_mode_desc']}
    RETURN    ${text}
