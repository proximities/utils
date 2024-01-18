oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_lean.omp.json" | Invoke-Expression
Set-PSReadLineOption -PredictionSource None
Import-Module posh-git

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