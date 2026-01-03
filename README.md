# Mobile Test Automation Framework (Robot Framework & Appium)

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Test Reporting](#test-reporting)
- [Example Test Case (MinimalToDo)](#example-test-case-minimaltodo)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Introduction
This repository hosts a robust mobile test automation framework built with **Robot Framework** and **Appium**. It is designed to facilitate efficient and reliable automated testing of mobile applications, exemplified here by the "MinimalToDo" application. The framework is structured for scalability and ease of maintenance, allowing for quick adaptation to various mobile testing scenarios.

## Features
- **Cross-Platform Mobile Testing**: Leverages Appium for automating iOS and Android applications.
- **Keyword-Driven Testing**: Utilizes Robot Framework for clear, readable, and maintainable test scripts.
- **Modular Design**: Separates test cases, page objects, and resources for better organization.
- **Data-Driven Capabilities**: Supports external data sources for flexible test execution.
- **Comprehensive Reporting**: Generates detailed logs and reports with screenshots and video recordings.
- **Python Integration**: Extensible with custom Python libraries for complex logic.

## Getting Started

### Prerequisites
Ensure you have the following installed on your system:
- **Python 3.x**: (e.g., Python 3.9+)
- **Node.js & npm**: Required for Appium Server.
- **Appium Server**: `npm install -g appium`
- **Java Development Kit (JDK)**: Required for Android automation.
- **Android SDK (with platform-tools)**: For Android device/emulator management.
- **(Optional) Appium Desktop**: For UI inspection and server management.

### Installation
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Zillion225/Appium_MinimalToDo.git
    cd Appium_MinimalToDo
    ```
2.  **Install Python dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

## Project Structure
The project is organized as follows:
- `PyUtilitys/`: Custom Python utility libraries.
- `Resources/`: Contains test resources, configurations, and common keywords.
    - `capabilities.json`: Appium desired capabilities.
    - `Features/`: Feature files (e.g., `.robot` files for specific functionalities).
    - `Locators/`: YAML files defining UI element locators.
    - `PageObjects/`: Robot Framework Page Object files.
    - `Settings/`: Environment-specific settings (e.g., `web.yaml`).
    - `TestData/`: Test data in YAML format.
- `Tests/`: Main test suite files (e.g., `TS001_MinimalToDo.robot`).
- `results/`: Directory for test execution reports, logs, and screenshots/videos.
- `run.bat`: Windows batch script for convenient test execution.
- `requirements.txt`: Lists Python dependencies.

## Configuration
1.  **Appium Server**: Ensure your Appium server is running. You can start it via command line (`appium`) or Appium Desktop.
2.  **Device Capabilities**: Edit `Resources/capabilities.json` to define your target device/emulator and application details. Update values such as `deviceName`, `platformVersion`, `appPackage`, and `appActivity` to match your testing environment.
3.  **Environment Settings**: Modify `Resources/Settings/web.yaml` for web-related configurations if applicable.

## Running Tests
To execute the test suite:

1.  **Using the provided script (Windows):**
    ```bash
    .\run.bat
    ```
2.  **Directly with Robot Framework:**
    ```bash
    robot -d results Tests/
    ```
    This command will run all test cases within the `Tests/` directory and output results to the `results/` folder.

## Test Reporting
Upon completion, detailed test reports will be generated in the `results/` directory, including:
- `log.html`: Detailed execution logs.
- `report.html`: Summary report of test runs.
- `output.xml`: Machine-readable test results.
- `appium-screenrecord-*.mp4`: Video recordings of test execution (if configured).

## Example Test Case (MinimalToDo)
The `TSN_001_MinimalToDo.robot` test suite, located in the `Tests/` directory, provides comprehensive examples of mobile test automation for the MinimalToDo application. It includes the following key scenarios:

-   **TS-001: Add Edit Remove ToDo Items**: Validates the core CRUD operations for ToDo items, including:
    -   Adding new ToDo items.
    -   Editing existing ToDo item titles.
    -   Removing ToDo items and verifying their absence.
-   **TS-002: Test Undo Feature After Removing ToDo Item**: Focuses on the application's undo functionality, specifically after an item removal.
-   **TS-003: Test About And Navigation Back**: Verifies navigation to the "About" page and the "Night Mode" toggle functionality within the application settings.
-   **TC-007: Remind Me Feature**: (Note: This test case is currently skipped due to identified technical limitations related to Espresso PickerActions.)

## License
This project is licensed under the MIT License. Refer to the `LICENSE` file for full details.

## Acknowledgments
This framework is built upon the excellent work of the Robot Framework and Appium communities.