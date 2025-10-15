#!/bin/bash

################################################################################
# Project 1.2: Command-Line Log Analyzer
# 
# Description:
#   A robust log analysis tool that parses web server logs to identify and
#   rank IP addresses generating '404 Not Found' errors.
#
# Usage:
#   ./log_analyser.sh <PATH_TO_LOG_FILE>
#
# Arguments:
#   PATH_TO_LOG_FILE - Path to the web server log file to analyze
#
# Output:
#   Displays top 10 IP addresses with highest 404 error counts
#
# Example:
#   ./log_analyser.sh /var/log/apache2/access.log
#
# Author: Project 1.2
# Version: 1.0
################################################################################

# Store the log file path from the first command-line argument
LOG_FILE=$1

#------------------------------------------------------------------------------
# Input Validation
#------------------------------------------------------------------------------

# Check if a log file was provided as an argument
if [ -z "$LOG_FILE" ]; then
  echo "Error: Please provide a log file path as an argument."
  echo "Usage: ./log_analyser.sh /path/to/your/logfile.log"
  exit 1
fi

# Check if the provided file actually exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Error: File not found at '$LOG_FILE'"
  exit 1
fi

#------------------------------------------------------------------------------
# Core Analysis Pipeline
#------------------------------------------------------------------------------

echo "--- Top 10 IP Addresses with '404' Errors from $LOG_FILE ---"
echo ""

# Pipeline breakdown:
# 1. grep "404" - Filter only lines containing 404 status code
# 2. awk '{print $1}' - Extract the IP address (first field) from each line
# 3. sort - Sort IPs alphabetically to group duplicates together
# 4. uniq -c - Count occurrences of each unique IP address
# 5. sort -nr - Sort by count numerically in reverse (highest first)
# 6. head -n 10 - Display only the top 10 results

grep "404" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10

# Exit successfully
exit 0