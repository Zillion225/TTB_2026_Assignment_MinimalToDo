*** Settings ***
# Import necessary libraries and resources
Resource    ../PageObjects/MinimalToDoPO.robot
Resource    ../PageObjects/DateTimeSelectorPO.robot

*** Keywords ***
Perform Add ToDo Item
    [Documentation]    Performs the complete flow of adding a ToDo item with the specified title.
    [Arguments]    ${item_title}
    MinimalToDoPO.Click Add Item
    MinimalToDoPO.Enter ToDo Item Title    ${item_title}
    MinimalToDoPO.Submit ToDo Item
    MinimalToDoPO.Verify ToDo Item Added    ${item_title}

Perform Add ToDo Item With Reminder
    [Documentation]    Performs the complete flow of adding a ToDo item with a reminder set to a future time.
    [Arguments]    ${item_title}    ${select_time}=${None}
    MinimalToDoPO.Click Add Item
    MinimalToDoPO.Enter ToDo Item Title    ${item_title}
    MinimalToDoPO.Click Remind Me
    MinimalToDoPO.Click Select Time On ToDo Reminder
    IF    $select_time != ${None}
        DateTimeSelectorPO.Select Time In Time Picker    ${select_time['hour']}    ${select_time['minute']}     ${select_time['am_pm']}
    END
    MinimalToDoPO.Submit ToDo Item

Perform Edit ToDo Item Title
    [Documentation]    Performs the complete flow of editing a ToDo item's title.
    [Arguments]    ${original_title}    ${new_title}    ${timeout}=${web_settings['long_timeout']}
    MinimalToDoPO.Click ToDo Item    ${original_title}
    MinimalToDoPO.Enter ToDo Item Title    ${new_title}  clear_text=${True}
    MinimalToDoPO.Submit ToDo Item
    MinimalToDoPO.Verify ToDo Item Added    ${new_title}

Get Future Time With Rounding
    [Documentation]    Calculates a future time based on an offset, rounded up to the next interval.
    ...                Example: If now is 10:12, offset is "5 min", and interval is 5:
    ...                1. Adds 5 mins -> 10:17
    ...                2. Rounds 17 up to next 5 -> Returns 10:20.
    [Arguments]    ${offset_string}=5 min    ${rounding_interval}=${5}
    # 1. Get the time in the future (Current Time + Offset)
    ${future_time}=    Get Current Date    increment=${offset_string}
    # 2. Extract Hour and Minute from that future time
    ${future_hour}=      Convert Date    ${future_time}    result_format=%I
    ${future_minute}=    Convert Date    ${future_time}    result_format=%M
    ${am_pm}=            Convert Date    ${future_time}    result_format=%p
    ${am_pm}=            String.Convert To Upper Case    ${am_pm}
    # 3. Calculate the remainder (How far past the grid we are)
    # Note: We use int($var) to handle potential leading zeros safely
    ${remainder}=    Evaluate    int($future_minute) % ${rounding_interval}
    # 4. Round up to the next interval
    # Logic: Minute - Remainder + Interval
    ${target_minute_int}=    Evaluate    int($future_minute) - ${remainder} + ${rounding_interval}
    IF    ${target_minute_int} >= 60
        ${target_minute_int}=    Evaluate    ${target_minute_int} - 60
        ${future_hour}=    Evaluate    int($future_hour) + 1
    END
    # 5. Format BOTH Hour and Minute to ensure 2 digits (e.g. 9 -> "09")
    ${target_minute_str}=    Evaluate    "{:02d}".format(${target_minute_int})
    ${future_hour_str}=      Evaluate    "{:01d}".format(int($future_hour))
    # 6. Create dictionary with the NEW calculated minute
    ${result_time}=    Create Dictionary    hour=${future_hour_str}    minute=${target_minute_str}    am_pm=${am_pm}
    RETURN    ${result_time}