#!/bin/bash

# Use Zenity to bring up a file selection dialog for the user to select a video file
INPUT_VIDEO=$(zenity --file-selection --title="Select a video file")

# Check if the user selected a file or canceled the dialog
if [ -z "$INPUT_VIDEO" ]; then
  echo "No file selected, exiting."
  exit 1
fi

# Set the output file name (same name as input but with .wav extension)
OUTPUT_AUDIO="${INPUT_VIDEO%.*}.wav"

# Extract audio from the selected video and save it as .wav
ffmpeg -i "$INPUT_VIDEO" -vn -acodec libmp3lame -b:a 128k "$OUTPUT_AUDIO"

# Check if the extraction was successful
if [ $? -eq 0 ]; then
  zenity --info --text="Audio extracted successfully: $OUTPUT_AUDIO"
else
  zenity --error --text="Audio extraction failed"
fi