*** Settings ***
# Import required libraries for interacting with mobile apps, JSON, collections, and strings
Library     AppiumLibrary    # For interacting with mobile applications using Appium
Library     JSONLibrary    # For reading and handling JSON files
Library     Collections    # For managing collections like lists and dictionaries
Library     String    # For string manipulation
Library     DateTime
Library     ../../PyUtilitys/PyImageUtility.py
Variables   ../Locators/common_locator.yaml
Variables   ../Settings/web.yaml

*** Variables ***
# Define constants used in the tests
${APPIUM_URL}       http://127.0.0.1:4723    # URL of the Appium server
${TEXT_REGCONITION_SCREENSHOT_PATH}    ${CURDIR}/text_recognition_full_screen.png

*** Keywords ***
Launch mobile app
    [Documentation]     Launches a mobile application using Appium.
    ...                 Loads the app capabilities from a JSON file and starts the app with the provided configurations.
    [Arguments]
    ...    ${json_path}    # Path to the JSON file containing app capabilities
    ...    ${encoding}=utf8    # Encoding format for reading the JSON file (default is 'utf8')

    # Load app capabilities from the JSON file
    ${capabilities}=    Load capabilities from JSON file    json_path=${json_path}    encoding=${encoding}
    Log    Loaded capabilities: ${capabilities}    # Log loaded capabilities for debugging

    # Open the application using Appium with the provided capabilities
    Open Application    ${APPIUM_URL}    &{capabilities}

Load capabilities from JSON file
    [Documentation]
    ...    Reads app capabilities from a JSON file and returns them as a dictionary.
    ...    This is typically used to load the configuration for launching the mobile app.
    [Arguments]
    ...    ${json_path}    # Path to the JSON file containing app capabilities
    ...    ${encoding}=utf8    # Encoding format for the JSON file (default is 'utf8')

    # Read the JSON file and parse its contents into a dictionary
    ${json_data}=    Load Json From File    file_name=${json_path}    encoding=${encoding}
    RETURN    ${json_data}    # Return the loaded JSON data

Locator Builder
    [Documentation]    Constructs a locator string by replacing placeholders in a base locator with actual values.
    [Arguments]       ${locator}    ${search_for}    ${replace_with}
    ${final_locator}=    Replace String    ${locator}    ${search_for}    ${replace_with}
    RETURN    ${final_locator}

Check And Allow Permission
    [Documentation]    Checks for Android permission pop-ups and allows the permission if prompted.
    [Arguments]    ${timeout}=${web_settings['normal_timeout']}
    ${is_permission_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${common_locator['android_permission']['permission_message']}    timeout=${timeout}
    IF    ${is_permission_present}
        Click Element    ${common_locator['android_permission']['btn_allow']}
    END

Get text attribute from child
    [Documentation]    Retrieves the 'text' attribute of a child element located within a parent element.
    [Arguments]
    ...    ${parent_element}    # The parent web element
    ...    ${child_locator}    # Locator for the child element (e.g., XPath, ID)

    # Locate the child element within the parent
    ${child_element}=    Get Webelement In Webelement    element=${parent_element}    locator=${child_locator}
    # Get the 'text' attribute of the child element
    ${text}=    Get Element Attribute    ${child_element}    text
    RETURN    ${text}
    
Get numeric from text
    [Documentation]
    ...    Removes all non-numeric characters from a text string and converts the result into a number.
    ...    Useful for extracting numeric values from strings containing text and numbers.
    [Arguments]
    ...    ${text}    # Input text string containing numbers

    # Remove all non-digit characters (except '.') using regex
    ${cleaned_number_text}=    Replace String Using Regexp    string=${text}    pattern=[^0-9.]    replace_with=
    # Convert the cleaned text to a numeric value with two decimal precision
    ${result}=    Convert To Number    item=${cleaned_number_text}    precision=2
    RETURN    ${result}

Click Element From Locator
    [Documentation]    Waits for an element to be visible and clicks on it.
    [Arguments]    ${locator}   ${timeout}=${web_settings['min_timeout']}   ${error}=Element with locator "${locator}" is not visible.
    Wait Until Element Is Visible   ${locator}    timeout=${timeout}   error=${error}
    AppiumLibrary.Click Element    ${locator}

Get Text From Locator
    [Documentation]    Waits for an element to be visible and retrieves its text.
    [Arguments]    ${locator}   ${timeout}=${web_settings['min_timeout']}   ${error}=Element with locator "${locator}" is not visible.
    Wait Until Element Is Visible   ${locator}    timeout=${timeout}   error=${error}
    ${text}=  AppiumLibrary.Get Text    ${locator}
    RETURN    ${text}

Click Element With Text Regconition
    [Documentation]    Clicks an element identified by text recognition using image processing.
    [Arguments]    ${text}    ${tap_duration}=${web_settings['tap_duration']}
    # Capture screenshot of the current screen
    Capture Page Screenshot  ${TEXT_REGCONITION_SCREENSHOT_PATH}
    # Find positions of the text in the screenshot
    ${positions}=    PyImageUtility.Find Text Centers    ${TEXT_REGCONITION_SCREENSHOT_PATH}    ${text}
    # Check if any positions were found
    ${count}=    Get Length    ${positions}
    IF    ${count} > 0
        AppiumLibrary.Tap With Positions    ${tap_duration}    @{positions}
    ELSE
        Fail    Could not find text: ${text} within screenshot '${TEXT_REGCONITION_SCREENSHOT_PATH}'.
    END

Swipe Element Horizontal
    [Documentation]    Performs a horizontal swipe gesture starting from the center of the specified element.
    ...
    ...    This keyword calculates the center coordinates of the element identified by the ``locator``
    ...    and executes a swipe action along the X-axis based on the provided ``offset``.
    ...
    ...    *Arguments:*
    ...    - ``locator``: (String) The strategy to locate the element (e.g., xpath=//...).
    ...    - ``offset``: (Integer) The distance in pixels to swipe relative to the element's center.
    ...        - Positive value (>0): Swipes from **Left to Right**.
    ...        - Negative value (<0): Swipes from **Right to Left**.
    ...    - ``duration``: (Integer) Duration of the swipe action (default is from ``web_settings['swipe_duration']``).
    ...
    ...    *Example:*
    ...    | Swipe Element Horizontal | xpath=//android.view.View | -500 |  400
    [Arguments]    ${locator}    ${offset}    ${duration}=${web_settings['swipe_duration']}

    # Verify element visibility to ensure coordinates can be retrieved
    Wait Until Element Is Visible    ${locator}    timeout=10s

    # Retrieve element properties
    ${element_location}=    Get Element Location    ${locator}
    ${element_size}=        Get Element Size        ${locator}

    # Calculate the center point of the element (Safe start point)
    ${start_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=    Evaluate    ${element_location['y']} + (${element_size['height']} / 2)

    # Calculate the end point based on the offset
    # Note: Only X-axis changes for horizontal swipe
    ${end_x}=      Evaluate    ${start_x} + ${offset}
    ${end_y}=      Set Variable    ${start_y}

    # Execute the swipe action
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${duration}

Swipe Element Vertical
    [Documentation]    Performs a vertical swipe gesture starting from the center of the specified element.
    ...
    ...    This keyword calculates the center coordinates of the element identified by the ``locator``
    ...    and executes a swipe action along the Y-axis based on the provided ``offset``.
    ...
    ...    *Arguments:*
    ...    - ``locator``: (String) The strategy to locate the element.
    ...    - ``offset``: (Integer) The distance in pixels to swipe relative to the element's center.
    ...        - Positive value (>0): Swipes from **Top to Bottom** (Scroll Up).
    ...        - Negative value (<0): Swipes from **Bottom to Top** (Scroll Down).
    ...    - ``duration``: (Integer) Duration of the swipe action (default is from ``web_settings['swipe_duration']``).
    ...
    ...    *Example:*
    ...    | Swipe Element Vertical | id=com.app:id/list | -300 | 400
    [Arguments]    ${locator}    ${offset}    ${duration}=${web_settings['swipe_duration']}
    # Verify element visibility
    Wait Until Element Is Visible    ${locator}    timeout=10s

    # Retrieve element properties
    ${element_location}=    Get Element Location    ${locator}
    ${element_size}=        Get Element Size        ${locator}

    # Calculate the center point of the element
    ${start_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=    Evaluate    ${element_location['y']} + (${element_size['height']} / 2)

    # Calculate the end point based on the offset
    # Note: Only Y-axis changes for vertical swipe
    ${end_x}=      Set Variable    ${start_x}
    ${end_y}=      Evaluate    ${start_y} + ${offset}

    # Execute the swipe action
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${duration}

Capture Screenshot And Check Is Image Dark
    [Documentation]    Captures a screenshot of the current screen and checks if the image is predominantly dark.
    [Arguments]    ${screenshot_path}    ${threshold}=100
    Capture Page Screenshot    ${screenshot_path}
    ${is_dark}=    PyImageUtility.Is Image Dark    ${screenshot_path}    threshold=${threshold}
    RETURN    ${is_dark}
