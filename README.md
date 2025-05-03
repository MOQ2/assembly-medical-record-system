# Medical Test Management System (MIPS Assembly)

## Project Overview
This MIPS assembly program implements a medical test management system that allows users to manage and analyze various medical test records. The system supports different types of medical tests including HGB (Hemoglobin), BGT (Blood Glucose Test), LDL (Low-Density Lipoprotein), and BPT (Blood Pressure Test).

## Authors
- Mohammad Qadi 
- Ahmad Hussin 


## Features

### 1. Test Management
- Add new medical test records
- Search for patient records by ID
- Find abnormal test results
- Calculate average test values
- Update existing test results
- Delete test records

### 2. Supported Test Types
- **HGB (Hemoglobin Test)**
  - Normal range: 13.8 - 17.2
- **BGT (Blood Glucose Test)**
  - Normal range: 70 - 99
- **LDL (Low-Density Lipoprotein)**
  - Normal value: < 100
- **BPT (Blood Pressure Test)**
  - Records both systolic and diastolic pressure
  - Normal ranges: 
    - Systolic: < 120
    - Diastolic: < 80

### 3. Data Management
- File-based storage system
- Data persistence across sessions
- Structured data format for test records

## Program Structure

### Data Format
Each test record contains:
- Patient ID (7-digit number)
- Test type (HGB/BGT/LDL/BPT)
- Date (YYYY-MM format)
- Test result(s)
  - Single value for HGB, BGT, LDL
  - Two values for BPT (systolic and diastolic)

### Menu Options
1. Add a new medical test
2. Search for a patient by ID
3. Search for abnormal tests
4. Find average test values
5. Update an existing test result
6. Delete a test
7. Exit

## Usage

### Adding a New Test
1. Select option 1
2. Enter patient ID (7 digits)
3. Enter test type (HGB/BGT/LDL/BPT)
4. Enter date (YYYY-MM)
5. Enter test result(s)

### Searching for Patient Records
1. Select option 2
2. Enter patient ID
3. Choose from sub-options:
   - View all tests
   - View abnormal tests only
   - View tests within a specific date range

### Data Storage
- Test records are stored in a text file
- Data is loaded at program start
- Changes are saved when exiting the program

## Implementation Details

### Data Structures
- Linked lists for each test type
- Separate nodes for different test types
- Special node structure for BPT (additional field for second value)

### Memory Management
- Dynamic memory allocation for test records
- Efficient linked list operations
- Memory cleanup on program exit

### Error Handling
- Input validation for all user inputs
- Date format verification
- Test type validation
- Value range checking

## File Format
```
ID: TestType, YYYY-MM, Result(s)
Example: 1234567: HGB, 2023-04, 14.5
Example: 1234567: BPT, 2023-04, 120.0, 80.0
```