# YouTube Audio Downloader PowerShell Script

This PowerShell script downloads audio files from YouTube URLs listed in a text file. It uses **yt-dlp** for downloading and allows you to specify an output folder for storing the audio files.

## Requirements

Before running this script, ensure that the following software and dependencies are installed:

### 1. **PowerShell 5.1 or later**

- PowerShell comes pre-installed on Windows 10. You can check the version by opening PowerShell and running:

   ```powershell
   $PSVersionTable.PSVersion
   ```

- Ensure the version is **5.1 or later**.

### 2. **yt-dlp**

- `yt-dlp` is a command-line tool used for downloading videos and audio from YouTube.
- To install it, first install **Chocolatey**, a Windows command-line installer.

#### Install Chocolatey:

- Chocolatey: command line package management tool.
- [Install link: https://chocolatey.org/install](https://chocolatey.org/install).

#### Install yt-dlp using choco:

After installing Scoop, install `yt-dlp` by running:

```powershell
choco install yt-dlp
   ```

### 3. **FFmpeg**

- `FFmpeg` is required by `yt-dlp` to extract and convert audio files.
- Install `FFmpeg` using choco:

```powershell
choco install ffmpeg
```

### 4. **.NET Framework**

The script uses Windows Forms and Drawing libraries, which require the **.NET Framework**. Windows 10 should have it installed by default. If it's missing, you can install it by downloading the installer from [Microsoft's website](https://dotnet.microsoft.com/download).

## Script Usage

### 1. **Download the Script**

Save the PowerShell script (`yt_dl_script.ps1`) to a folder of your choice.

### 2. **Prepare the Input File**

- Create a text file containing the YouTube URLs you want to download audio from.
- Ensure each URL is on a new line.

### 3. **Running the Script**

1. Open **PowerShell**.
2. Navigate to the folder where the script is saved. Best to drag and drop the script file on the terminal to print the path to that file and then remove the filename. In example below, the script ("yt_dl.ps1") is stored in directory "Powerscripts":

    ```powershell
    cd "C:\Users\SickDog\Documents\Powerscripts"
    ```

3. Run the script by executing the following command:

    ```powershell
    .\yt_dl.ps1
    ```

**Note** If you have not already done so, you may need to set script execution policy to other than "restricted" in order to run the script. This only needs to be done once for powershell on the machine for this user. [See this guide](scriptExecution.md) for how to do that

### 4. **Selecting Input and Output**

- The script will prompt you to **select the input file** (the text file with YouTube URLs).
- It will also prompt you to **select the output directory** where the downloaded audio files will be saved.

### 5. **Summary and Output**

- Once the script processes all URLs, it will display a summary showing how many downloads were successful.
- Failed downloads, if any, will be saved in a `failed_downloads.txt` file in the output directory.

## Troubleshooting

- **yt-dlp not found**: Ensure that `yt-dlp` is installed and that it is in your system's PATH.
- **Permissions issues**: If you encounter permission errors, try running PowerShell as Administrator.
