## Requirements to Run Powershell Scriptz, windows:

Below is a list of required and recommended packages to install. Some are not actually required (such as python) but are just recommended if you want to get into doing development and automation on your PC.

### Install the following common programs & packages:

- **Python**: This is not required to run these powershell scripts. Everyone should have Python though.
  - Install python 3.12 via windows store.
- **Windows Terminal**:
  - This is the terminal to rule them all. You can run powershell, git bash, cmd prompt, zsh, ... every different shell can be run in this tool in different tabs.
  - Search "windows terminal" in Windows Store. (optional, could use powershell or command prompt instead)
- **git**. git is required, gotta have git.
  - [download link](https://git-scm.com/downloads/win)
  - When installing git, click option to add git bash to windows terminal.
  - Use other defaults and recommmended settings.
- Install **Visual Studio Code** (use Windows Store) (optional but should certainly be done).
- **Chocolatey:** command line package management tool. Use to install stuff via command line on windows as would do on linux/mac. [Install link](https://chocolatey.org/install).
- **ffmpeg**: This is the premier open-source video manipulation library. Commmand-line tool. It is the tits. Use an LLM to help you formulate your commands and you'll have mastery over video, images and audio.
  - *Site*: [https://www.ffmpeg.org/]
  - Install via chocolatey. Using command line (cmd prompt, powershell or git bash - use windows terminal). First check that chocolatey is installed, enter these commands into terminal one at a time:
  
    ```powershell
    choco
    ```

  - That should print something like:

    ```powershell
        Chocolatey v2.3.0
        Please run 'choco -?' or 'choco <command> -?' for help menu.
    ```

  - Then to install ffmpeg:

    ```powershell
    choco install ffmpeg
    ```

- **Open AI API key:** You need an API key for open ai to use the whisper api. It is free though. Login at the link below using you open ai account and follow the instructions.
  - [[open ai API keys](https://platform.openai.com/api-keys)]

### Run extract_transcribe Script

- Running the script is simple. First set the working directory (wd) to the folder containing the script, e.g:
  ```powershell
  cd c"c:\Users\Purpy Catatity\Documents\Code\Powershell"
  ```
- Run script by referencing the file in terminal ('.\' indicates that the file is in the current wd):
  ```powershell
  .\extract_transcribe.ps1
  ```
- On the first run you will be prompted in the terminal to enter your open AI API key. Copy and paste it into the terminal when prompted and hit enter.
- Subsequent runs will not need you to paste the key. It is saved to "keyz.json" file when you paste it the first time.
