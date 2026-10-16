# Lance l'API accessible depuis le téléphone (0.0.0.0 = toutes les interfaces).
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$venvActivate = '.\.venv\Scripts\Activate.ps1'
if (-not (Test-Path $venvActivate)) {
  $venvActivate = '.\venv\Scripts\Activate.ps1'
}
if (-not (Test-Path $venvActivate)) {
  python -m venv .venv
  $venvActivate = '.\.venv\Scripts\Activate.ps1'
}

. $venvActivate
pip install -r requirements.txt
if (Test-Path '.\.env') {
  Get-Content '.\.env' | ForEach-Object {
    if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
    $k, $v = $_ -split '=', 2
    if ($k -and -not [string]::IsNullOrWhiteSpace($v)) {
      Set-Item -Path "Env:$($k.Trim())" -Value $v.Trim()
    }
  }
}
if (-not $env:ESP32_BASE_URL) {
  $env:ESP32_BASE_URL = "http://192.168.100.50"
}
if (-not $env:API_KEY) {
  $env:API_KEY = "rover-secret-key"
}
if (-not $env:ESP32_API_KEY) {
  $env:ESP32_API_KEY = $env:API_KEY
}
Write-Host "Backend: http://192.168.100.12:8000  (docs: /docs)"
Write-Host "ESP32_BASE_URL=$env:ESP32_BASE_URL"
Write-Host "API_KEY=$env:API_KEY"
Write-Host "ESP32_API_KEY=$env:ESP32_API_KEY"
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
