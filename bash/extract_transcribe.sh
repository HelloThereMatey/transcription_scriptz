#!/bin/bash

# Set the working directory to the directory where the script is located
cd "$(dirname "$0")"
# Path to the JSON file containing the API key
API_KEY_FILE="keyz.json"

# Check if the API key file exists
if [ ! -f "$API_KEY_FILE" ]; then
  echo "API key file not found. Please enter your OpenAI API key:"
  read -r api_key

  # Create the JSON file with the API key
  echo "{\"openai\": \"$api_key\"}" > "$API_KEY_FILE"
  echo "API key saved to $API_KEY_FILE"
else
    echo "API key file found."
fi

# Check if the JSON file exists
if [ ! -f "$API_KEY_FILE" ]; then
  echo "API key file does not exist: $API_KEY_FILE"
  exit 1
fi
# Extract the API key from the JSON file using jq
API_KEY=$(jq -r '.openai' "$API_KEY_FILE")

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
  echo "Audio extracted successfully: $OUTPUT_AUDIO"
else
  zenity --error --text="Audio extraction failed"
  exit 1
fi

######### Now use that extracted audio file to transcribe it using OpenAI Whisper API #########

# Check if the file actually exists
if [ ! -f "$OUTPUT_AUDIO" ]; then
  echo "File does not exist: $OUTPUT_AUDIO"
  exit 1
else
  echo "File exists: $OUTPUT_AUDIO"
fi

MODEL="whisper-1" # Whisper model name

# Send the audio file to OpenAI API
response=$(curl https://api.openai.com/v1/audio/transcriptions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@${OUTPUT_AUDIO}" \
  -F "model=$MODEL" \
  -F "response_format=srt")


######### Create a new directory and move files #########
# Extract the base name of the INPUT_VIDEO file (without path and extension)
BASE_NAME=$(basename "${INPUT_VIDEO%.*}")

# Save the response as an .srt file in the same folder as the audio file
OUTPUT_SRT="${BASE_NAME%.*}.srt"
echo "$response" > "$OUTPUT_SRT"
echo $response
echo "SRT file saved as: $OUTPUT_SRT"

### Also save a text file with the bare text transcription
OUTPUT_TXT="${BASE_NAME%.*}.txt"

# Extract text lines from the SRT file and save to the output TXT file
grep -vE '^[0-9]+$|^$|-->' "$OUTPUT_SRT" > "$OUTPUT_TXT"

echo "Text lines extracted to: $OUTPUT_TXT"

# Create a new directory with the base name
NEW_DIR=$(dirname "$INPUT_VIDEO")/"$BASE_NAME"
mkdir -p "$NEW_DIR"

# Move the original video, extracted audio, and SRT file to the new directory
mv "$INPUT_VIDEO" "$OUTPUT_AUDIO" "$OUTPUT_SRT" "$OUTPUT_TXT" "$NEW_DIR"

echo "Files moved to: $NEW_DIR"