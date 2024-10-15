#!/bin/bash

# Check if the input SRT file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_srt_file>, or use dialog to select the file"
  # Use Zenity to bring up a file selection dialog for the user to select a video file
  INPUT_SRT=$(zenity --file-selection --title="Select an SRT file, to extract text lines.")

  # Check if the user selected a file or canceled the dialog
  if [ -z "$INPUT_SRT" ]; then
    echo "No file selected, exiting."
    exit 1
  fi
else
    INPUT_SRT="$1"
fi

OUTPUT_TXT="${INPUT_SRT%.*}.txt"

# Extract text lines from the SRT file and save to the output TXT file
grep -vE '^[0-9]+$|^$|-->' "$INPUT_SRT" > "$OUTPUT_TXT"

echo "Text lines extracted to: $OUTPUT_TXT"