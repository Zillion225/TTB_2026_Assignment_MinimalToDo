*** Settings ***
# Import necessary libraries and resources
Library     AppiumLibrary    # For interacting with mobile applications
Resource    ./CommonPO.robot    # Common resource file containing reusable keywords

*** Keywords ***
Click Hours Element
    [Documentation]    Clicks the hours selector in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Click Element From Locator  ${common_locator['timepicker']['btn_hours_selector']}  timeout=${timeout}   error=Hours selector is not visible within '${timeout}'.

Click Minutes Element
    [Documentation]    Clicks the minutes selector in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Click Element From Locator  ${common_locator['timepicker']['btn_minutes_selector']}  timeout=${timeout}   error=Minutes selector is not visible within '${timeout}'.

Click Change AM_PM Element
    [Documentation]    Clicks the AM/PM selector in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Click Element From Locator  ${common_locator['timepicker']['btn_am_selector']}  timeout=${timeout}   error=AM/PM selector is not visible within '${timeout}'

Click OK Button In Time Picker
    [Documentation]    Clicks the OK button to confirm time selection in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Click Element From Locator  ${common_locator['timepicker']['btn_ok']}  timeout=${timeout}   error=OK button in time picker is not visible within '${timeout}'.

Click Cancel Button In Time Picker
    [Documentation]    Clicks the Cancel button to dismiss the time picker dialog without saving changes.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    Click Element From Locator  ${common_locator['timepicker']['btn_cancel']}  timeout=${timeout}   error=Cancel button in time picker is not visible within '${timeout}'.
Select Time In Time Picker
    [Documentation]    Selects a specific time (hour, minute, AM/PM) in the time picker dialog.
    [Arguments]    ${hour_text}=${None}    ${minute_text}=${None}    ${am_pm_text}=${None}
    IF    $hour_text != ${None}
        ${current_selected_hour}  Retreive Hour Text From Time Picker
        IF    $current_selected_hour != $hour_text
            Click Hours Element
            Sleep    ${web_settings['brief_timeout']}
            CommonPO.Click Element With Text Regconition    ${hour_text}
        END
    END
    IF    $minute_text != ${None}
        Click Minutes Element
        Sleep    ${web_settings['brief_timeout']}
        CommonPO.Click Element With Text Regconition    ${minute_text}
    END
    IF    '${am_pm_text}' != '${None}'
        ${current_am_pm}=    Retreive AM_PM Text From Time Picker
        IF    "${current_am_pm}" != "${am_pm_text}"
            Click Change AM_PM Element
        END
    END
    Click OK Button In Time Picker

Retreive Hour Text From Time Picker
    [Documentation]    Retrieves the current hour text displayed in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    ${text}    CommonPO.Get Text From Locator  ${common_locator['timepicker']['btn_hours_selector']}  timeout=${timeout}   error=Hours selector is not visible within '${timeout}'.
    RETURN    ${text}

Retreive AM_PM Text From Time Picker
    [Documentation]    Retrieves the current AM/PM text displayed in the time picker dialog.
    [Arguments]   ${timeout}=${web_settings['min_timeout']}
    ${text}    CommonPO.Get Text From Locator  ${common_locator['timepicker']['btn_am_selector']}  timeout=${timeout}   error=AM/PM selector is not visible within '${timeout}'.
    RETURN    ${text}
