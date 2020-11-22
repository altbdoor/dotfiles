#Requires -RunAsAdministrator

$currentDir = (Split-Path $MyInvocation.MyCommand.Path)

# nodejs
# ========================================
$pathList = ($env:Path -split ';' | Where-Object { $_ -notlike '*nodejs*' })

mkdir -Force ~/Downloads/exe/nodejs
cd ~/Downloads/exe/nodejs

$nodeVersion = '12'
$res = Invoke-WebRequest "https://nodejs.org/download/release/latest-v$nodeVersion.x/"
$binaryName = ($res.Links | Where { $_.href -like '*-win-x64.zip' }).href
curl -o $binaryName "https://nodejs.org/download/release/latest-v$nodeVersion.x/$binaryName"
Expand-Archive $binaryName -DestinationPath .\

$folderName = $binaryName -replace ".zip", ""
$pathList += "%USERPROFILE%\Downloads\exe\nodejs\$folderName"
[System.Environment]::SetEnvironmentVariable('Path', ($pathList -join ';'), [System.EnvironmentVariableTarget]::User)

# lets go
cd "$currentDir"
choco feature enable -n allowGlobalConfirmation

# git
# ========================================
choco install git.install --params "/NoShellIntegration /NoCredentialManager /NoAutoCrlf"

# sublime text
# ========================================
choco install sublimetext3
mkdir -Force '~/AppData/Roaming/Sublime Text 3/Packages/User/'
cp sublime/settings.json '~/AppData/Roaming/Sublime Text 3/Packages/User/Preferences.sublime-settings'
cp sublime/keymaps.json '~/AppData/Roaming/Sublime Text 3/Packages/User/Default (Windows).sublime-keymap'

# conemu
# ========================================
choco install conemu
((Get-Content -path ConEmu.xml -Raw) -replace '__USERPATH__', $env:userprofile) | Set-Content -Path tmp_ConEmu.xml
cp tmp_ConEmu.xml ~/AppData/Roaming/ConEmu.xml
rm tmp_ConEmu.xml

# greenshot
# ========================================
choco install greenshot

Start-Sleep -s 5
taskkill /f /im greenshot.exe
mkdir -Force ~/Pictures/ss
((Get-Content -path Greenshot.ini -Raw) -replace '__USERPATH__', $env:userprofile) | Set-Content -Path tmp_Greenshot.ini
cp tmp_Greenshot.ini ~/AppData/Roaming/Greenshot/Greenshot.ini
rm tmp_Greenshot.ini

# paint.net
# ========================================
choco install paint.net

# mkdir -Force '~/Documents/paint.net App Files'
# mkdir -Force '~/Documents/paint.net App Files/Effects'
# mkdir -Force '~/Documents/paint.net App Files/Palettes'

# curl -o pyrochild.zip 'https://forums.getpaint.net/applications/core/interface/file/attachment.php?id=13067'
# Expand-Archive pyrochild.zip -DestinationPath pyrochild
# cp 'pyrochild/Outline Object.dll' '~/Documents/paint.net App Files/Effects'
# rm pyrochild -r
# rm pyrochild.zip

# curl -o boltbait.zip 'https://forums.getpaint.net/applications/core/interface/file/attachment.php?id=16864'
# Expand-Archive boltbait.zip -DestinationPath boltbait

# web browsers
# ========================================
choco install firefox
choco install googlechrome
choco install vscode

choco install k-litecodecpackfull

choco install 7zip
choco install python3
choco install sumatrapdf.install
choco install toggl

# choco install openvpn
# choco install autohotkey

choco feature disable -n allowGlobalConfirmation

# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost") {
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.FlushInputBuffer()   # Make sure buffered input doesn't "press a key" and skip the ReadKey().
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}
