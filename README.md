# Project: Command-Line Log Analyzer

> A robust and reusable Bash script for parsing web server logs to identify and rank the sources of '404 Not Found' errors.

This project builds upon foundational command-line skills by chaining together powerful text-processing utilities to create a practical data analysis pipeline.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [How It Works](#how-it-works-the-data-pipeline)
- [Example Output](#example-output)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

In any production environment, log files are the primary source of truth for diagnosing issues, understanding user behavior, and monitoring system health. However, these files are often massive, containing millions of lines of raw, unstructured text. Manually searching through them is impossible.

This script solves that problem by providing a command-line tool that can instantly parse a log file and generate a summary report of the top IP addresses responsible for generating "404 Not Found" errors. This demonstrates the power of the standard Linux text-processing tools to build a fast and efficient data analysis pipeline without writing complex code.

### Use Cases

- **Web Server Monitoring:** Identify broken links and missing resources on your website
- **Security Analysis:** Detect potential malicious scanners or bots probing for vulnerabilities
- **Traffic Analysis:** Understand which IPs are generating the most 404 errors
- **Log Auditing:** Quick forensic analysis of web server access logs

## Features

* **Reusable Tool:** Accepts a log file path as a command-line argument, making it a flexible utility for analyzing any compatible log file.
* **Robust Error Handling:** Includes checks to ensure that a file path is provided and that the file actually exists, providing helpful error messages to the user.
* **Efficient Data Pipeline:** Uses an elegant chain of standard Unix utilities (`grep`, `awk`, `sort`, `uniq`) to process data in a memory-efficient stream.
* **Insightful Reporting:** Automatically calculates and displays a "Top 10" list of the most frequent offending IP addresses, allowing for quick identification of potential issues like broken links or malicious scanners.

## Prerequisites

This script is designed to run in a standard Linux/Unix-like environment (including WSL, macOS, and Git Bash) and relies on the following common utilities:

| Utility | Purpose | Typical Availability |
|---------|---------|---------------------|
| `bash` | Shell interpreter | Pre-installed on most Unix systems |
| `grep` | Pattern matching and filtering | Standard on all Unix systems |
| `awk` | Text processing and field extraction | Standard on all Unix systems |
| `sort` | Sorting lines of text | Standard on all Unix systems |
| `uniq` | Filtering duplicate lines | Standard on all Unix systems |
| `head` | Displaying first lines of output | Standard on all Unix systems |

**System Requirements:**
- Bash version 3.0 or higher
- Read access to log files
- Minimum 512MB RAM (for processing large log files)

## Installation

1. **Clone or download this repository:**
   ```bash
   git clone <repository-url>
   cd Project_1.2
   ```

2. **Make the script executable:**
   Before its first use, you must give the script execute permissions.
   ```bash
   chmod +x log_analyser.sh
   ```

3. **Verify installation:**
   ```bash
   ./log_analyser.sh
   ```
   You should see the usage message if no arguments are provided.

## Usage

### Basic Syntax

```bash
./log_analyser.sh <PATH_TO_LOG_FILE>
```

### Examples

**Example 1: Analyze a log file in the current directory**
```bash
./log_analyser.sh access.log
```

**Example 2: Analyze a log file with absolute path**
```bash
./log_analyser.sh /var/log/apache2/access.log
```

**Example 3: Analyze the provided sample log**
```bash
./log_analyser.sh sample.log
```

**Example 4: Redirect output to a file for later analysis**
```bash
./log_analyser.sh access.log > 404_report.txt
```

### Command-Line Options

Currently, the script accepts one required argument:
- `<PATH_TO_LOG_FILE>`: Path to the web server log file to analyze

### Error Messages

- **"Error: Please provide a log file path as an argument."** - You forgot to specify a log file. Include the path as an argument.
- **"Error: File not found at '<path>'"** - The specified file doesn't exist. Check the path and try again.

## Testing with `sample.log`

A sample log file named `sample.log` is included in this repository. You can use it to test the script's functionality without needing a real server log.

**To run the test:**
```bash
./log_analyser.sh sample.log
```

This will run the analyzer on the sample data and should produce a ranked list of the IP addresses found in that file.

## How It Works: The Data Pipeline

The core of the `log_analyser.sh` script is a single, elegant command pipeline that processes the data in stages.

```bash
grep "404" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10
```

### Pipeline Breakdown

1.  **`grep "404" "$LOG_FILE"`**: First, `grep` reads the log file and acts as a filter, keeping only the lines that contain the "404" status code.

2.  **`| awk '{print $1}'`**: The remaining lines (only the error lines) are piped to `awk`, which extracts only the first column—the IP address—from each line.

3.  **`| sort`**: The resulting list of IP addresses is then sorted alphabetically. This places all identical IPs next to each other, which is required for `uniq` to work correctly.

4.  **`| uniq -c`**: The sorted list is piped to `uniq -c`, which counts the occurrences of each unique IP address and prepends the count to the line.

5.  **`| sort -nr`**: The output of counts and IPs is piped to `sort -nr` for a final sorting. `-n` sorts numerically, and `-r` sorts in reverse (descending) order, placing the highest counts at the top.

6.  **`| head -n 10`**: Finally, the fully sorted list is piped to `head -n 10`, which gives us only the top 10 lines of the output, completing our report.

## License

This project is licensed under the MIT License.

Copyright (c) 2023 Jules

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
