# lets go
choco feature enable -n allowGlobalConfirmation

# git
# ========================================
choco install git.install --params "/NoShellIntegration /NoCredentialManager /NoAutoCrlf"

# Invoke-WebRequest -Uri https://gist.github.com/altbdoor/a521f5fe062d45fbf4962edc7b14ca90/raw/654cfacdfcd1b86d88482b3f7e8b1850f53e76c9/.gitconfig -OutFile ~/.gitconfig

# sublime text
# ========================================
choco install sublimetext3

cp sublime/settings.json '~/AppData/Roaming/Sublime Text 3/Packages/User/Preferences.sublime-settings'
cp sublime/keymaps.json '~/AppData/Roaming/Sublime Text 3/Packages/User/Default (Windows).sublime-keymap'

# conemu
# ========================================
choco install conemu

cp ConEmu.xml ~/AppData/Roaming/ConEmu.xml

# greenshot
# ========================================
choco install greenshot

mkdir ~/Pictures/ss
((Get-Content -path Greenshot.ini -Raw) -replace '__USERPATH__', $env:userprofile) | Set-Content -Path greenshot.ini
cp greenshot.ini ~/AppData/Roaming/Greenshot/Greenshot.ini

choco install k-litecodecpackfull
choco install paint.net
choco install vscode

choco install 7zip
choco install python3
choco install sumatrapdf.install
choco install autohotkey
choco install toggl

choco feature disable -n allowGlobalConfirmation
