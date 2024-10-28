## Requirements to Run Powershell Scriptz, windows:

### Install the following common programs & packages:

- python (optional but come on, gotta have it). Install python 3.12 via windows store.
- Windows Terminal: Search "windows terminal" in Windows Store. (optional)
- git: [download link](https://git-scm.com/downloads/win)
  - When installing git, click option to add git bash to windows terminal.
  - Use other defaults and recommmended settings.
- Install Visual Studio Code (Windows Store) (optional but just do it).
- Chocolatey: command line package management tool. Use to install stuff via command line on windows as would do on linux/mac. [Install link.](https://chocolatey.org/install).
- ffmpeg: This is the premier open-source video manipulation library. Commmand-line tool. It is the tits. Use an LLM to help you formulate your commands and you'll have mastery over video, images and audio.
  - Site: [https://www.ffmpeg.org/]
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

### Run Script

- Running the script is simple. First set the wd to the folder containing the script:

- Run script by referenceing the file in terminal:
