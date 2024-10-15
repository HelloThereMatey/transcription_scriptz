#!/bin/bash

# Set the working directory to the directory where the script is located
cd "$(dirname "$0")"
# Path to the JSON file containing the API key
API_KEY_FILE="keyz.json"

# Check if the JSON file exists
if [ ! -f "$API_KEY_FILE" ]; then
  echo "API key file does not exist: $API_KEY_FILE"
  exit 1
fi
# Extract the API key from the JSON file using jq
API_KEY=$(jq -r '.openai' "$API_KEY_FILE")

# Use Zenity to bring up a file selection dialog for the user to select a video file
FILE_PATH=$(zenity --file-selection --title="Select an audio file to transcribe...")

# Check if the user selected a file or canceled the dialog
if [ -z "$FILE_PATH" ]; then
  echo "No file selected, exiting."
  exit 1
else
  echo "Selected file: $FILE_PATH"
fi

MODEL="whisper-1" # Whisper model name

# Send the audio file to OpenAI API
response=$(curl https://api.openai.com/v1/audio/transcriptions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@${FILE_PATH}" \
  -F "model=$MODEL" \
  -F "response_format=srt")

# Save the response as an .srt file in the same folder as the audio file
OUTPUT_SRT="${FILE_PATH%.*}.srt"
echo "$response" > "$OUTPUT_SRT"
echo $response
echo "SRT file saved as: $OUTPUT_SRT"