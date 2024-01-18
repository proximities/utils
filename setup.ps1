
cp .vimrc ~/.vimrc

function get {
    param (
        [string]$url,
        [string]$out
    )
    # if out is not specified, use the filename from the url
    if (!$out) {
        $out = $url.Split("/")[-1]
    }
    Invoke-WebRequest -Uri $url -OutFile $out
    Start-Process -FilePath $out -Wait
}

# Example usage
get "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi"
get "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user" vscode.exe
get "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
get "https://aka.ms/vs/17/release/vs_BuildTools.exe"
get "https://downloader.battle.net/download/getInstallerForGame?os=win&gameProgram=OVERWATCH&version=Live&id=775f3e8b-f0b8-43d3-9610-69849a9a0076" overwatch.exe

get "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
get "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"

expand-archive -path JetBrainsMono-2.304.zip 
Expand-Archive -Path FiraCode.zip

Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force

$pwsh = "C:/Users/pblpbl/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
new-item $pwsh -force
cp profile.ps1 $pwsh


# find ttf files in the current directory and install them
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)

$here = $MyInvocation.PSScriptRoot

$font_files = Get-ChildItem -Path $here -Recurse | Where-Object {
    $_.Extension -ilike "*.otf" -or $_.Extension -ilike "*.ttf"
}
 
foreach($f in $font_files) {
    $fname = $f.Name
    Write-Host -ForegroundColor Green "installing $fname..."
    $fonts.CopyHere($f.FullName)
}