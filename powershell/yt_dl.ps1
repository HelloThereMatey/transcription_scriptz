# Add Windows Forms assembly for file dialogs
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Select-OutputDirectory {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Where you wanna save your ripped audio files bruh!?"
    $folderBrowser.SelectedPath = [System.Environment]::GetFolderPath('MyDocuments')

    if ($folderBrowser.ShowDialog() -eq 'OK') {
        return $folderBrowser.SelectedPath
    }
    else {
        Write-Host "No directory selected. Exiting..." -ForegroundColor Red
        exit
    }
}

function Select-InputFile {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*"
    $openFileDialog.Title = "Select a text file containing YouTube URLs"

    if ($openFileDialog.ShowDialog() -eq 'OK') {
        return $openFileDialog.FileName
    }
    else {
        Write-Host "No file selected. Exiting..." -ForegroundColor Red
        exit
    }
}

function Create-OutputDirectory {
    param (
        [string]$dirName
    )
    
    try {
        if ($dirName) {
            $basePath = [System.Environment]::GetFolderPath('MyDocuments')
            $outputPath = Join-Path $basePath $dirName
        }
        else {
            $outputPath = Select-OutputDirectory
        }

        $outputPath = [System.IO.Path]::GetFullPath($outputPath)

        if (-not (Test-Path $outputPath)) {
            New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
        }
        
        $testFile = Join-Path $outputPath "test.txt"
        try {
            [System.IO.File]::WriteAllText($testFile, "test")
            Remove-Item $testFile -Force
        }
        catch {
            throw "No write permission in selected directory: $outputPath"
        }

        return $outputPath
    }
    catch {
        Write-Host "Error creating output directory: $_" -ForegroundColor Red
        exit
    }
}

function Download-Audio {
    param (
        [string]$url,
        [string]$outputDir,
        [int]$iterator
    )
    
    try {
        Write-Host "Starting download for URL: $url" -ForegroundColor Yellow
        
        $arguments = @(
            $url,
            '--no-playlist',
            '--extract-audio',
            '--audio-format', 'mp3',
            '--audio-quality', '0',
            '--output', "`"$outputDir\$iterator`_%(title)s.%(ext)s`"",
            '--format', 'bestaudio',
            '--windows-filenames'
        )
        
        Write-Host "yt-dlp arguments: $($arguments -join ' ')" -ForegroundColor Cyan
        
        # Use Start-Process instead of System.Diagnostics.Process
        $result = Start-Process -FilePath "yt-dlp" -ArgumentList $arguments -NoNewWindow -Wait -PassThru
        
        Write-Host "yt-dlp process completed with exit code: $($result.ExitCode)" -ForegroundColor Cyan
        
        if ($result.ExitCode -eq 0) {
            Write-Host "Successfully downloaded audio from: $url" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "Failed to download audio from: $url" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Error downloading $url : $_" -ForegroundColor Red
        return $false
    }
}

function Main {
    param (
        [string]$outputDirName
    )

    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        Write-Host "Note: Running without admin rights. Some locations might be inaccessible." -ForegroundColor Yellow
    }

    try {
        $null = Get-Command yt-dlp -ErrorAction Stop
    }
    catch {
        Write-Host "yt-dlp is not installed or not in PATH. Please install it first." -ForegroundColor Red
        Write-Host "You can install it using: scoop install yt-dlp" -ForegroundColor Yellow
        exit
    }

    $outputDir = Create-OutputDirectory -dirName $outputDirName
    Write-Host "Audio files will be saved to: $outputDir" -ForegroundColor Cyan

    $filePath = Select-InputFile
    
    try {
        $urls = Get-Content $filePath | Where-Object { $_.Trim() -ne "" }
    }
    catch {
        Write-Host "Error reading file: $_" -ForegroundColor Red
        exit
    }

    if ($urls.Count -eq 0) {
        Write-Host "No URLs found in the file. Exiting..." -ForegroundColor Yellow
        exit
    }

    $total = $urls.Count
    $successful = 0
    $failed = @()

    Write-Host "`nFound $total URLs to process" -ForegroundColor Cyan
    
    foreach ($i in 0..($total - 1)) {
        $url = $urls[$i]
        Write-Host "`nProcessing URL $($i + 1)/$total" -ForegroundColor Yellow
        
        if (Download-Audio -url $url -outputDir $outputDir -iterator ($i + 1)) {
            $successful++
        }
        else {
            $failed += $url
        }
        
        Write-Progress -Activity "Downloading YouTube Audio" -Status "$($i + 1) of $total completed" -PercentComplete ((($i + 1) / $total) * 100)
    }

    Write-Host "`nDownload complete!" -ForegroundColor Green
    Write-Host "Successfully downloaded: $successful/$total audio files" -ForegroundColor Cyan
    Write-Host "Files saved to: $outputDir" -ForegroundColor Cyan

    if ($failed.Count -gt 0) {
        $failedPath = Join-Path $outputDir "failed_downloads.txt"
        $failed | Out-File -FilePath $failedPath
        Write-Host "`nFailed downloads have been saved to: $failedPath" -ForegroundColor Yellow
    }
}

# Run the script
Main