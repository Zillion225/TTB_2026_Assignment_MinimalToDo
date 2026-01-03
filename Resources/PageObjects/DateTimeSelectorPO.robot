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