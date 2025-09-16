# Project: Command-Line Log Analyzer

> A robust and reusable Bash script for parsing web server logs to identify and rank the sources of '404 Not Found' errors.

This project builds upon foundational command-line skills by chaining together powerful text-processing utilities to create a practical data analysis pipeline.

## Overview

In any production environment, log files are the primary source of truth for diagnosing issues, understanding user behavior, and monitoring system health. However, these files are often massive, containing millions of lines of raw, unstructured text. Manually searching through them is impossible.

This script solves that problem by providing a command-line tool that can instantly parse a log file and generate a summary report of the top IP addresses responsible for generating "404 Not Found" errors. This demonstrates the power of the standard Linux text-processing tools to build a fast and efficient data analysis pipeline without writing complex code.

## Features

* **Reusable Tool:** Accepts a log file path as a command-line argument, making it a flexible utility for analyzing any compatible log file.
* **Robust Error Handling:** Includes checks to ensure that a file path is provided and that the file actually exists, providing helpful error messages to the user.
* **Efficient Data Pipeline:** Uses an elegant chain of standard Unix utilities (`grep`, `awk`, `sort`, `uniq`) to process data in a memory-efficient stream.
* **Insightful Reporting:** Automatically calculates and displays a "Top 10" list of the most frequent offending IP addresses, allowing for quick identification of potential issues like broken links or malicious scanners.

## Prerequisites

This script is designed to run in a standard Linux/Unix-like environment (including WSL) and relies on the following common utilities:
* `bash`
* `grep`
* `awk`
* `sort`
* `uniq`
* `head`

## Usage

1.  **Make the script executable:**
    Before its first use, you must give the script execute permissions.
    ```bash
    chmod +x log_analyzer.sh
    ```

2.  **Run the script:**
    The script requires one argument: the path to the log file you wish to analyze.

    **Syntax:**
    ```bash
    ./log_analyzer.sh <PATH_TO_LOG_FILE>
    ```

    **Example:**
    To analyze a log file named `access.log` located in the current directory, you would run:
    ```bash
    ./log_analyzer.sh access.log
    ```
    The script will then print a formatted list of the top 10 IP addresses and their error counts.

## How It Works: The Data Pipeline

The core of the `log_analyzer.sh` script is a single, elegant command pipeline that processes the data in stages.

```bash
# Inside log_analyzer.sh
grep "404" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10

Here is how this pipeline works:

grep "404" "$LOG_FILE": First, grep reads the log file and acts as a filter, keeping only the lines that contain the "404" status code.

| awk '{print $1}': The remaining lines (only the error lines) are piped to awk, which extracts only the first column—the IP address—from each line.

| sort: The resulting list of IP addresses is then sorted alphabetically. This places all identical IPs next to each other, which is required for uniq to work correctly.

| uniq -c: The sorted list is piped to uniq -c, which counts the occurrences of each unique IP address and prepends the count to the line.

| sort -nr: The output of counts and IPs is piped to sort -nr for a final sorting. -n sorts numerically, and -r sorts in reverse (descending) order, placing the highest counts at the top.

| head -n 10: Finally, the fully sorted list is piped to head -n 10, which gives us only the top 10 lines of the output, completing our report.

## License
<<<<<<< HEAD
Private
=======
this is under MIT license
>>>>>>> 1d7f411633f5a47fba5e5407597a48acc1b6dcfa
