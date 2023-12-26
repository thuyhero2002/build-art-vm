Function Install-Application($Url, $flags) {
    $LocalTempDir = $env:TEMP
    $Installer = "Installer.exe"
    (new-object  System.Net.WebClient).DownloadFile($Url, "$LocalTempDir\$Installer")
    & "$LocalTempDir\$Installer" $flags
    $Process2Monitor = "Installer"
    Do {
        $ProcessesFound = Get-Process | ? { $Process2Monitor -contains $_.Name } | Select-Object -ExpandProperty Name
        If ($ProcessesFound) { Write-Host "." -NoNewline -ForegroundColor Yellow; Start-Sleep -Seconds 2 } 
        else { Write-Host "Done" -ForegroundColor Cyan; rm "$LocalTempDir\$Installer" -ErrorAction SilentlyContinue }
    } 
    Until (!$ProcessesFound)
}

function Set-Bookmarks {
    $bookmarksFile = "C:\Users\art\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
    if (-Not (Test-Path $bookmarksFile)) {
        Invoke-WebRequest "https://raw.githubusercontent.com/clr2of8/dc8-deployment-PUBLIC/master/Bookmarks" -OutFile "C:\Users\art\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
    }
    Invoke-WebRequest "https://raw.githubusercontent.com/clr2of8/dc8-deployment-PUBLIC/master/Bookmarks" -OutFile "$env:Temp\Bookmarks"

    $newJsonData = Get-Content -Raw -Path "$env:Temp\Bookmarks" | ConvertFrom-Json
    
    $labsURL = $null # This will remove the labs bookmark because it doesn't apply to the OnDemand course
    foreach ($child in $newJsonData.roots.bookmark_bar.children ) {
       if ($child.name -eq "Labs") {
            $child.url = $labsURL
       }
     }
    
    $newJsonData = $newJsonData | ConvertTo-Json -Depth 100
    Set-Content "$env:Temp\Bookmarks" $newJsonData
    # only update the bookmark file and restart Chrome if there was a change
    if ((Get-Content $bookmarksFile -raw) -ne (Get-Content "$env:Temp\Bookmarks" -raw)) {
        $newJsonData | Set-Content $bookmarksFile
        Stop-Process -Name "chrome" -Force
    } 
}
    
if (-not (Test-Path C:\Users\art)) {
    # add art user
    Write-Host "Adding 'art' user" -ForegroundColor Cyan
    $password = ConvertTo-SecureString "AtomicRedTeam1!" -AsPlainText -Force
    New-LocalUser "art" -Password $password -ErrorAction Ignore
    Add-LocalGroupMember -Group "Administrators" -Member "art" -ErrorAction Ignore
    Set-LocalUser -Name "art" -PasswordNeverExpires 1
    Read-Host -Prompt "Switch users to the 'art' user then run this script again. OK?" 
    exit
}

Remove-LocalUser -Name "IEUser"
Remove-Item 'C:\Users\art\Desktop\Microsoft Edge.lnk'

# install Chrome (must be admin)
$property = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe' -ErrorAction Ignore
if ( -not ($property -and $property.'(Default)')) {
    Write-Host "Installing Chrome" -ForegroundColor Cyan
    $flags = '/silent', '/install'
    Install-Application 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe' $flags
}

# Installing Chrome Bookmarks
start-process chrome; sleep 3 # must start chrome before bookmarks file exists
Write-Host "Installing Chrome Bookmarks" -ForegroundColor Cyan
Set-Bookmarks

# install Notepad++
if (-not (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*  | where-Object DisplayName -like 'NotePad++*')) {
    Write-Host "Installing Notepad++" -ForegroundColor Cyan
    Install-Application 'https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.3.3/npp.8.3.3.Installer.x64.exe' '/S'
}

# add Desktop shortcuts
Write-Host "Creating Desktop Shortcuts" -ForegroundColor Cyan
Copy-Item 'C:\Users\art\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk' "C:\Users\art\Desktop\PowerShell.lnk"
Copy-Item 'C:\Users\art\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk' "C:\Users\art\Desktop\Command Prompt.lnk"
Copy-Item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk' "C:\Users\art\Desktop\Notepad++.lnk"

# install SysInternal Suite
Write-Host "Installing SysInternal Suite" -ForegroundColor Cyan
New-Item -ItemType Directory -Path "C:\Users\art\Desktop\Sysinternals" -Force
Set-Location -Path "C:\Users\art\Desktop\Sysinternals"
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" -OutFile "SysinternalsSuite.zip"
Expand-Archive -Path ".\SysinternalsSuite.zip" -DestinationPath ".\"
Remove-Item -Path ".\SysinternalsSuite.zip"
Write-Host "Done" -ForegroundColor Cyan

# install config sysmon
Write-Host "Setup Sysmon" -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "C:\Windows\config.xml"
C:\Users\art\Desktop\Sysinternals\sysmon64.exe -accepteula -i c:\windows\config.xml
Write-Host "Done" -ForegroundColor Cyan

# install atomic red team
Write-Host "Installing Atomic Red Team Framework and Folders" -ForegroundColor Cyan
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
Add-MpPreference -ExclusionPath C:\AtomicRedTeam\
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics -Force
New-Item -ItemType Directory (split-path $profile) -Force
Set-Content $profile 'Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force'

# Turn off Automatic Sample Submission in Windows Defender
Write-Host "Turning off Automatic Sample Submission" -ForegroundColor Cyan
PowerShell Set-MpPreference -SubmitSamplesConsent 2

# Turn off screensaver and screen lock features for convenience
Powercfg /Change -monitor-timeout-ac 0
Powercfg /Change -standby-timeout-ac 0
