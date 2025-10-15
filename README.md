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

## How It Works: The Data Pipeline

The core of the `log_analyser.sh` script is a single, elegant command pipeline that processes the data in stages.

```bash
grep "404" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10
```

### Pipeline Breakdown

Here is how each stage of the pipeline works:

1. **`grep "404" "$LOG_FILE"`**
   - **Purpose:** Filter log entries containing 404 errors
   - **Input:** Complete log file
   - **Output:** Only lines with "404" status code
   - **Why:** Reduces data volume by eliminating irrelevant log entries

2. **`| awk '{print $1}'`**
   - **Purpose:** Extract IP addresses from filtered log lines
   - **Input:** Lines containing 404 errors
   - **Output:** First field (IP address) from each line
   - **Why:** Isolates the data we need for analysis

3. **`| sort`**
   - **Purpose:** Alphabetically sort IP addresses
   - **Input:** List of IP addresses (with duplicates)
   - **Output:** Sorted list of IP addresses
   - **Why:** Groups identical IPs together (required for `uniq` to work)

4. **`| uniq -c`**
   - **Purpose:** Count occurrences of each unique IP
   - **Input:** Sorted list of IP addresses
   - **Output:** Count followed by IP address (e.g., "5 192.168.1.1")
   - **Why:** Aggregates data to show how many 404s each IP generated

5. **`| sort -nr`**
   - **Purpose:** Sort by count in descending order
   - **Input:** Counts and IP addresses
   - **Output:** List sorted by count (highest first)
   - **Flags:** `-n` for numerical sort, `-r` for reverse (descending)
   - **Why:** Places the worst offenders at the top

6. **`| head -n 10`**
   - **Purpose:** Limit output to top 10 results
   - **Input:** Full sorted list
   - **Output:** Only the first 10 lines
   - **Why:** Provides a focused, actionable report

### Performance Characteristics

- **Time Complexity:** O(n log n) due to sorting operations
- **Space Complexity:** O(n) for storing unique IP addresses
- **Scalability:** Can efficiently process multi-gigabyte log files
- **Streaming:** Processes data in a pipeline without loading entire file into memory

## Example Output

```
--- Top 10 IP Addresses with '404' Errors from sample.log ---
     15 192.168.1.100
     12 10.0.0.5
      8 172.16.0.23
      6 192.168.1.101
      5 10.0.0.15
      4 192.168.2.50
      3 172.16.1.10
      3 10.0.0.25
      2 192.168.1.200
      1 172.16.0.100
```

**Interpretation:**
- The leftmost column shows the count of 404 errors
- The rightmost column shows the IP address
- IP `192.168.1.100` generated 15 "404 Not Found" errors (the most)
- This could indicate a bot, broken link, or legitimate user encountering missing resources

## Troubleshooting

### Common Issues

**Problem:** "Permission denied" when running the script
```bash
bash: ./log_analyser.sh: Permission denied
```
**Solution:** Make the script executable:
```bash
chmod +x log_analyser.sh
```

**Problem:** Script reports "File not found" for an existing file
**Solution:** 
- Verify the file path is correct (use absolute path if unsure)
- Check you have read permissions: `ls -l <filename>`
- Ensure you're in the correct directory: `pwd`

**Problem:** No output or empty results
**Solution:**
- Verify the log file contains 404 errors: `grep 404 <logfile> | head`
- Check log file format matches expected structure (IP address as first field)
- Ensure log file is not empty: `wc -l <logfile>`

**Problem:** Script runs but shows incorrect results
**Solution:**
- Verify log format: Different servers may use different log formats
- The script expects Apache/Nginx Common Log Format with IP as the first field
- Modify the `awk` command if your logs use a different format

### Supported Log Formats

This script works best with **Common Log Format (CLF)** and **Combined Log Format**, including:
- Apache HTTP Server logs
- Nginx access logs
- Most standard web server logs

**Example compatible log line:**
```
192.168.1.100 - - [15/Oct/2025:18:27:04 +0000] "GET /missing-page.html HTTP/1.1" 404 1234
```

## Contributing

Contributions are welcome! Here are some ideas for enhancements:

- Add support for different log formats
- Allow customization of top N results (not just top 10)
- Add date range filtering
- Generate visual reports or charts
- Support for other HTTP error codes (403, 500, etc.)
- Add option to output JSON or CSV format

To contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

na