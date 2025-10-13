#!/bin/bash

# =================================================================================================
#
# Project: Command-Line Log Analyzer
#
# Description:
#   A simple but powerful Bash script that analyzes a web server log file to identify the
#   top 10 IP addresses that have triggered a "404 Not Found" error. This tool is designed
#   for quick, real-time analysis directly from the command line.
#
# Usage:
#   ./log_analyzer.sh <PATH_TO_LOG_FILE>
#
# Author:
#   Jules
#
# =================================================================================================

# --- 1. Argument Validation ---

# The script requires exactly one argument: the path to the log file.
# We assign the first command-line argument ($1) to a more readable variable.
LOG_FILE=$1

# Check if the LOG_FILE variable is empty ("-z").
# This happens if the user forgets to provide a file path.
if [ -z "$LOG_FILE" ]; then
  # If no argument is provided, print an error message and the correct usage syntax.
  echo "Error: Please provide a log file path as an argument."
  echo "Usage: ./log_analyser.sh /path/to/your/logfile.log"
  # Exit the script with a status code of 1 to indicate an error.
  exit 1
fi

# Check if the provided path actually points to a regular file ("! -f").
# This prevents errors if the path is a directory or does not exist.
if [ ! -f "$LOG_FILE" ]; then
  # If the file doesn't exist, print a clear error message.
  echo "Error: File not found at '$LOG_FILE'"
  # Exit with an error status.
  exit 1
fi


# --- 2. Core Logic: The Data Pipeline ---

# If the file exists and is valid, proceed with the analysis.
# This section prints a clear header for the report.
echo "--- Top 10 IP Addresses with '404' Errors from $LOG_FILE ---"

# This is the core of the script—a chain of commands that work together.
# The output of each command is "piped" (|) as the input to the next.
#
# 1. grep "404" "$LOG_FILE":
#    - Reads the specified log file.
#    - Filters the file, keeping only the lines that contain the string "404".
#
# 2. | awk '{print $1}':
#    - Takes the "404" lines from grep.
#    - For each line, it prints only the first column ('$1'), which is the IP address.
#
# 3. | sort:
#    - Takes the list of IP addresses.
#    - Sorts them alphabetically, which is necessary for `uniq` to count them correctly.
#
# 4. | uniq -c:
#    - Takes the sorted list of IPs.
#    - Collapses adjacent duplicate lines and counts how many times each IP appeared (`-c`).
#    - The output format is: " count IP_address".
#
# 5. | sort -nr:
#    - Takes the list of "count IP_address".
#    - Sorts this list numerically (`-n`) and in reverse (descending) order (`-r`).
#    - This places the IP addresses with the highest counts at the top.
#
# 6. | head -n 10:
#    - Takes the final sorted list.
#    - Displays only the first 10 lines, giving us the top 10 results.
#
grep "404" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10