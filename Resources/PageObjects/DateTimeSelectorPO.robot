*** Settings ***
# Import necessary libraries and resources
Library     AppiumLibrary    # For interacting with mobile applications
Resource    ./CommonPO.robot    # Common resource file containing reusable keywords

*** Keywords ***
# Select Time
#     [Documentation]    Selects a time in the time picker of the mobile application.
#     [Arguments]    ${hour}    ${minute}    ${am_pm}
#     # # Open the time picker
#     # Click Element    id=time_picker_button
#     # # Set the hour
#     # Select From List By Value    id=hour_picker    ${hour}
#     # # Set the minute
#     # Select From List By Value    id=minute_picker    ${minute}
#     # # Set AM/PM
#     # Select From List By Value    id=am_pm_picker    ${am_pm}
#     # # Confirm the selection
#     # Click Element    id=confirm_time_button

Click Hours Element
    [Documentation]    Clicks the hours selector in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    CommonPO.Click Element  ${common_locator['btn_hours_selector']}  timeout=${timeout}   error=Hours selector is not visible within '${timeout}'.

Click Minutes Element
    [Documentation]    Clicks the minutes selector in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    CommonPO.Click Element  ${common_locator['btn_minutes_selector']}  timeout=${timeout}   error=Minutes selector is not visible within '${timeout}'.

Click AMPM Element
    [Documentation]    Clicks the AM/PM selector in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    CommonPO.Click Element  ${common_locator['btn_am_selector']}  timeout=${timeout}   error=AMPM selector is not visible within '${timeout}'
    Click Element    ${common_locator['btn_am_selector']}
