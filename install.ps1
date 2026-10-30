<#
.SYNOPSIS
    Installs the Code Geass Rainmeter suite (GurenHoneycomb) and its layout.

.DESCRIPTION
    1. Backs up any existing GurenHoneycomb / GurenLauncher skins and Code Geass layouts.
    2. Copies Skins\GurenHoneycomb into your Rainmeter skins folder and the CodeGeass
       layout into %APPDATA%\Rainmeter\Layouts.
    3. Checks what each icon opens. If an app is installed somewhere else on this PC,
       the icon is pointed at it; anything not found is listed at the end.
    4. Restarts Rainmeter and loads the layout, which centres itself on any screen.

.EXAMPLE
    .\install.ps1
#>
[CmdletBinding()]
param(
    # Only copy the files. Rainmeter is not restarted and no layout is loaded.
    [switch]$NoLoad,

    # Don't ask before installing.
    [switch]$Yes,

    # Install somewhere other than Rainmeter's own folders (mainly for testing).
    [string]$SkinsPath,
    [string]$SettingsPath
)

$ErrorActionPreference = 'Stop'
$suite = 'GurenHoneycomb'
# GurenLauncher was merged into GurenHoneycomb, so an old copy of it is backed up and removed too.
$oldSkins = 'GurenHoneycomb', 'GurenLauncher'
$layout = 'CodeGeass'
# CodeGeass replaced the old per-screen MonitorLayout and LaptopLayout.
$oldLayouts = 'CodeGeass', 'MonitorLayout', 'LaptopLayout'

function Find-Rainmeter {
    foreach ($key in 'HKLM:\SOFTWARE\WOW6432Node\Rainmeter', 'HKLM:\SOFTWARE\Rainmeter') {
        $dir = (Get-ItemProperty $key -ErrorAction SilentlyContinue).'(default)'
        if ($dir -and (Test-Path (Join-Path $dir 'Rainmeter.exe'))) { return Join-Path $dir 'Rainmeter.exe' }
    }
    $default = Join-Path $env:ProgramFiles 'Rainmeter\Rainmeter.exe'
    if (Test-Path $default) { return $default }
}

function Write-IniFile([string]$Path, [string]$Text) {
    # Rainmeter reads ANSI or UTF-16 LE, so only fall back to UTF-16 when the text needs it.
    $encoding = if ($Text -match '[^\x00-\x7F]') { [Text.Encoding]::Unicode } else { [Text.Encoding]::ASCII }
    [IO.File]::WriteAllText($Path, $Text, $encoding)
}

# Start Menu apps by name and by ID, used to check and fix what each icon opens.
$startApps = @{}
$appIds = @{}
if (Get-Command Get-StartApps -ErrorAction SilentlyContinue) {
    foreach ($app in Get-StartApps) {
        if (-not $startApps.ContainsKey($app.Name)) { $startApps[$app.Name] = $app.AppID }
        $appIds[$app.AppID] = $true
    }
}

# True when the target of an icon's Launch= action exists on this PC.
function Test-Launch([string]$Launch) {
    if ($Launch -notmatch '^\["') { return $true }
    $target = [Environment]::ExpandEnvironmentVariables(($Launch -split '"')[1])
    if ($target -match '^shell:AppsFolder\\(.+)$') { return $appIds.ContainsKey($Matches[1]) }
    if ($target -match '^(shell:|https?:)') { return $true }
    if ($target -match '^([a-z][a-z0-9+.-]+):(?!\\)') { return Test-Path "Registry::HKEY_CLASSES_ROOT\$($Matches[1])" }
    if ([IO.Path]::IsPathRooted($target)) { return Test-Path $target }
    foreach ($root in 'HKCU:', 'HKLM:') {
        if (Test-Path "$root\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$target") { return $true }
    }
    return [bool](Get-Command $target -ErrorAction SilentlyContinue)
}

function Find-StartApp([string]$Name) {
    if ($startApps.ContainsKey($Name)) { return $startApps[$Name] }
    $match = $startApps.Keys | Where-Object { $_ -like "$Name*" } | Sort-Object Length | Select-Object -First 1
    if ($match) { return $startApps[$match] }
}

$rainmeter = Find-Rainmeter
if (-not $rainmeter -and -not $NoLoad) {
    Write-Host 'Rainmeter is not installed. Install it from https://www.rainmeter.net and run this again.' -ForegroundColor Red
    exit 1
}

if (-not $SettingsPath) { $SettingsPath = Join-Path $env:APPDATA 'Rainmeter' }
if (-not $SkinsPath) {
    $settingsFile = Join-Path $SettingsPath 'Rainmeter.ini'
    if (Test-Path $settingsFile) {
        $m = [regex]::Match([IO.File]::ReadAllText($settingsFile), '(?m)^SkinPath=(.+?)\s*$')
        if ($m.Success) { $SkinsPath = $m.Groups[1].Value }
    }
    if (-not $SkinsPath) { $SkinsPath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Rainmeter\Skins' }
}
$layoutsPath = Join-Path $SettingsPath 'Layouts'
$backup = Join-Path $SettingsPath ('Backups\CodeGeass-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))

Write-Host 'This will:'
Write-Host "  - copy $suite to $SkinsPath"
Write-Host "  - copy the $layout layout to $layoutsPath"
Write-Host "  - back up any copies already there to $backup"
if (-not $NoLoad) { Write-Host "  - restart Rainmeter and load the $layout layout" }
if (-not $Yes) {
    $answer = Read-Host 'Continue? [Y/n]'
    if ($answer -match '^\s*n') { Write-Host 'Cancelled.'; exit 0 }
}

$wasRunning = Get-Process Rainmeter -ErrorAction SilentlyContinue
if (-not $NoLoad -and $wasRunning) {
    Write-Host 'Closing Rainmeter...'
    & $rainmeter '!Quit'
    $wasRunning | Wait-Process -Timeout 15 -ErrorAction SilentlyContinue
    if (Get-Process Rainmeter -ErrorAction SilentlyContinue) {
        Write-Host 'Rainmeter did not close. Quit it from the tray icon and run this again.' -ForegroundColor Red
        exit 1
    }
}

$backedUp = $false
$existing = @($oldSkins | ForEach-Object { @{ Path = Join-Path $SkinsPath $_; Backup = "Skins\$_" } }) +
            @($oldLayouts | ForEach-Object { @{ Path = Join-Path $layoutsPath $_; Backup = "Layouts\$_" } })
foreach ($item in $existing) {
    if (-not (Test-Path $item.Path)) { continue }
    $dest = Join-Path $backup $item.Backup
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    Copy-Item $item.Path $dest -Recurse
    Remove-Item $item.Path -Recurse -Force
    $backedUp = $true
}

New-Item -ItemType Directory -Force $SkinsPath, $layoutsPath | Out-Null
Copy-Item (Join-Path $PSScriptRoot "Skins\$suite") (Join-Path $SkinsPath $suite) -Recurse
Copy-Item (Join-Path $PSScriptRoot "Layouts\$layout") (Join-Path $layoutsPath $layout) -Recurse
Write-Host 'Copied the skins and layout.'

$missing = @()
foreach ($ini in Get-ChildItem (Join-Path $SkinsPath "$suite\Icons") -Filter *.ini -Recurse) {
    $text = [IO.File]::ReadAllText($ini.FullName)
    $launch = [regex]::Match($text, '(?m)^Launch=(.*?)\r?$').Groups[1].Value
    if (-not $launch -or (Test-Launch $launch)) { continue }
    $name = [regex]::Match($text, '(?m)^StartMenuName=(.*?)\r?$').Groups[1].Value
    $id = if ($name) { Find-StartApp $name }
    if (-not $id) { $missing += $ini.Directory.Name; continue }
    $target = if ($id -match '^[a-z][a-z0-9+.-]+://') { $id } else { "shell:AppsFolder\$id" }
    Write-IniFile $ini.FullName $text.Replace("Launch=$launch", "Launch=[""$target""]")
    Write-Host "Pointed the $($ini.Directory.Name) icon at $name from your Start Menu."
}

if (-not $NoLoad) {
    Write-Host 'Starting Rainmeter...'
    Start-Process $rainmeter
    # Give Rainmeter a moment to start before sending it the layout.
    Start-Sleep -Seconds 3
    & $rainmeter '!LoadLayout' $layout
}

Write-Host ''
Write-Host 'Done.' -ForegroundColor Green
if ($backedUp) { Write-Host "Your previous copy is in $backup" }
if ($NoLoad) { Write-Host "Load the $layout layout from the Layouts tab in Rainmeter's Manage window." }
if ($missing) {
    Write-Host ''
    Write-Host 'These icons open apps that are not on this PC, so clicking them does nothing yet:' -ForegroundColor Yellow
    Write-Host ('  ' + (($missing | Sort-Object) -join ', '))
    Write-Host 'Install the app, or right-click the icon, choose Edit skin and change the Launch= line.'
}
