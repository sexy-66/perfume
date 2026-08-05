$root = $PSScriptRoot

$paths = @(
    '.toolchain', '.cache\pub', '.cache\gradle', '.android\avd',
    '.home\AppData\Roaming', '.home\AppData\Local', '.tmp', '.secrets'
)
foreach ($path in $paths) {
    New-Item -ItemType Directory -Force -Path (Join-Path $root $path) | Out-Null
}

$env:HOME = Join-Path $root '.home'
$env:USERPROFILE = $env:HOME
$env:APPDATA = Join-Path $env:HOME 'AppData\Roaming'
$env:LOCALAPPDATA = Join-Path $env:HOME 'AppData\Local'
$env:JAVA_HOME = Join-Path $root '.toolchain\jdk'
$env:ANDROID_HOME = Join-Path $root '.toolchain\android-sdk'
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:ANDROID_USER_HOME = Join-Path $root '.android'
$env:ANDROID_AVD_HOME = Join-Path $env:ANDROID_USER_HOME 'avd'
$env:ANDROID_EMULATOR_HOME = $env:ANDROID_USER_HOME
$env:ADB_VENDOR_KEYS = $env:ANDROID_USER_HOME
$env:PUB_CACHE = Join-Path $root '.cache\pub'
$env:GRADLE_USER_HOME = Join-Path $root '.cache\gradle'
$env:TEMP = Join-Path $root '.tmp'
$env:TMP = $env:TEMP

$toolPaths = @(
    (Join-Path $root '.toolchain\flutter\bin')
    (Join-Path $env:ANDROID_HOME 'cmdline-tools\latest\bin')
    (Join-Path $env:ANDROID_HOME 'platform-tools')
    (Join-Path $env:ANDROID_HOME 'emulator')
    (Join-Path $env:JAVA_HOME 'bin')
)
$env:Path = ($toolPaths + @($env:Path -split [IO.Path]::PathSeparator | Where-Object { $_ -and $_ -notin $toolPaths })) -join [IO.Path]::PathSeparator

Write-Host 'Xiang development environment active for this PowerShell process.'
