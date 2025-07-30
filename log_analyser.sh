#!/bin/bash

# Project 1.2: A simple log analyzer script.
# This script takes a log file as an argument and shows the top 10 IP addresses that caused a '404' error.

LOG_FILE=$1

# Check if a log file was provided as an argument.
if [ -z "$LOG_FILE" ]; then
  echo "Error: Please provide a log file path as an argument."
  echo "Usage: ./log_analyser.sh /path/to/your/logfile.log"
  exit 1
fi

# Check if the provided file actually exists.
if [ ! -f "$LOG_FILE" ]; then
  echo "Error: File not found at '$LOG_FILE'"
  exit 1
fi


# --- Core Logic ---
echo "--- Top 10 IP Addresses with '404' Errors from $LOG_FILE ---"

grep "404" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10