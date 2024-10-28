# Set the working directory to the directory where the script is located
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

# Path to the JSON containing the API key
$API_KEY_FILE = "keyz.json"

# Check if the API key file exists
if (-Not (Test-Path $API_KEY_FILE)) {
    Write-Host "API key file not found. Please enter your OpenAI API key:"
    $api_key = Read-Host

    # Create the JSON file with the API key
    $jsonContent = @{ openai = $api_key } | ConvertTo-Json
    $jsonContent | Out-File -FilePath $API_KEY_FILE
    Write-Host "API key saved to $API_KEY_FILE"
} else {
    Write-Host "API key file found."
}

# Check if the JSON file exists
if (-Not (Test-Path $API_KEY_FILE)) {
    Write-Host "API key file does not exist: $API_KEY_FILE"
    exit 1
}

# Extract the API key from the JSON file
$jsonContent = Get-Content -Path $API_KEY_FILE | ConvertFrom-Json
$API_KEY = $jsonContent.openai

# Use Windows Forms to bring up a file selection dialog for the user to select a video file
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Title = "Select a video file"
$OpenFileDialog.Filter = "Video Files|*.mp4;*.mkv;*.avi;*.mov;*.flv;*.wmv"

if ($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $INPUT_VIDEO = $OpenFileDialog.FileName
} else {
    Write-Host "No file selected, exiting."
    exit 1
}

# Set the output file name (same name as input but with .wav extension)
$OUTPUT_AUDIO = [System.IO.Path]::ChangeExtension($INPUT_VIDEO, ".wav")

# Extract audio from the selected video and save it as .wav
$ffmpegCommand = "ffmpeg -i `"$INPUT_VIDEO`" -vn -acodec libmp3lame -b:a 128k `"$OUTPUT_AUDIO`""
Write-Host "Running command: $ffmpegCommand"
Invoke-Expression $ffmpegCommand

# Check if the extraction was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Audio extracted successfully: $OUTPUT_AUDIO"
} else {
    [System.Windows.Forms.MessageBox]::Show("Audio extraction failed", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}

######### Now use that extracted audio file to transcribe it using OpenAI Whisper API #########

# Check if the file actually exists
if (-Not (Test-Path $OUTPUT_AUDIO)) {
    Write-Host "File does not exist: $OUTPUT_AUDIO"
    exit 1
} else {
    Write-Host "File exists: $OUTPUT_AUDIO"
}

$MODEL = "whisper-1" # Whisper model name

# Load the necessary .NET assemblies
Add-Type -AssemblyName "System.Net.Http"

# Create the multipart form data content
$multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
$fileContent = [System.Net.Http.StreamContent]::new([System.IO.File]::OpenRead($OUTPUT_AUDIO))
$fileContent.Headers.ContentDisposition = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
$fileContent.Headers.ContentDisposition.Name = '"file"'
$fileContent.Headers.ContentDisposition.FileName = '"' + [System.IO.Path]::GetFileName($OUTPUT_AUDIO) + '"'
$multipartContent.Add($fileContent)
$multipartContent.Add([System.Net.Http.StringContent]::new($MODEL), "model")
$multipartContent.Add([System.Net.Http.StringContent]::new("srt"), "response_format")

# Send the audio file to OpenAI API
$httpClient = [System.Net.Http.HttpClient]::new()
$httpClient.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new("Bearer", $API_KEY)
$response = $httpClient.PostAsync("https://api.openai.com/v1/audio/transcriptions", $multipartContent).Result

if ($response.IsSuccessStatusCode) {
    $responseContent = $response.Content.ReadAsStringAsync().Result
    Write-Host "Transcription successful"
} else {
    Write-Host "Transcription failed: $($response.StatusCode) $($response.ReasonPhrase)"
    exit 1
}

######### Create a new directory and move files #########
# Extract the base name of the INPUT_VIDEO file (without path and extension)
$BASE_NAME = [System.IO.Path]::GetFileNameWithoutExtension($INPUT_VIDEO)

# Save the response as an .srt file in the same folder as the audio file
$OUTPUT_SRT = [System.IO.Path]::ChangeExtension($INPUT_VIDEO, ".srt")
$responseContent | Out-File -FilePath $OUTPUT_SRT
Write-Host "SRT file saved as: $OUTPUT_SRT"

### Also save a text file with the bare text transcription
$OUTPUT_TXT = [System.IO.Path]::ChangeExtension($INPUT_VIDEO, ".txt")

# Extract text lines from the SRT file and save to the output TXT file
Select-String -Pattern '^[0-9]+$|^$|-->' -NotMatch -Path $OUTPUT_SRT | ForEach-Object { $_.Line } | Out-File -FilePath $OUTPUT_TXT

Write-Host "Text lines extracted to: $OUTPUT_TXT"

# Create a new directory with the base name
$NEW_DIR = Join-Path -Path (Get-Item -Path $INPUT_VIDEO).DirectoryName -ChildPath $BASE_NAME
New-Item -ItemType Directory -Path $NEW_DIR -Force

# Move the original video, extracted audio, and SRT file to the new directory
Move-Item -Path $INPUT_VIDEO, $OUTPUT_AUDIO, $OUTPUT_SRT, $OUTPUT_TXT -Destination $NEW_DIR

Write-Host "Files moved to: $NEW_DIR"