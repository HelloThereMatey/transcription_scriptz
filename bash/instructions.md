# Extract and Transcribe Script

This script extracts audio from a video file and transcribes it using the OpenAI Whisper API. It supports both macOS and Linux.

## Requirements

### Dependencies

1. **jq**: A lightweight and flexible command-line JSON processor.
2. **ffmpeg**: A complete, cross-platform solution to record, convert and stream audio and video.
3. **zenity**: A tool that allows you to display GTK dialog boxes from the command line or a shell script.
4. **curl**: A command-line tool for transferring data with URLs.

### Installation

#### macOS

1. **Install Homebrew** (if not already installed):
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install dependencies using Homebrew**:
   ```sh
   brew install jq ffmpeg zenity curl
   ```

#### Linux

1. **Install dependencies using your package manager**:
   - For Debian/Ubuntu-based distributions:
     ```sh
     sudo apt-get update
     sudo apt-get install jq ffmpeg zenity curl
     ```
   - For Red Hat/CentOS-based distributions:
     ```sh
     sudo yum install epel-release
     sudo yum install jq ffmpeg zenity curl
     ```

## Usage

1. **Clone the repository**:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Set the working directory to the directory where the script is located**:
   ```sh
   cd "$(dirname "$0")"
   ```

3. **Run the script**:
   ```sh
   ./extract_transcribe.sh
   ```

4. **Follow the prompts**:
   - If the API key file (`keyz.json`) does not exist, you will be prompted to enter your OpenAI API key. The key will be saved in a JSON file.
   - Use the Zenity dialog to select a video file for processing.

5. **Script Execution**:
   - The script will extract audio from the selected video file and save it as a `.wav` file.
   - The extracted audio file will be sent to the OpenAI Whisper API for transcription.
   - The transcription will be saved as an `.srt` file and a plain text `.txt` file.
   - The original video, extracted audio, and transcription files will be moved to a new directory named after the base name of the input video file.

## Example

```sh
./extract_transcribe.sh
```

- **Select a video file**: Use the Zenity dialog to select the video file you want to process.
- **Wait for processing**: The script will extract audio, transcribe it, and save the results.
- **Check the output**: The output files will be moved to a new directory named after the base name of the input video file.

## Notes

- Ensure that you have a valid OpenAI API key and that it is saved in the `keyz.json` file in the same directory as the script.
- The script uses `jq` to parse the JSON file containing the API key.
- The script uses `ffmpeg` to extract audio from the video file.
- The script uses `zenity` to display file selection dialogs.
- The script uses `curl` to send the audio file to the OpenAI Whisper API for transcription.
