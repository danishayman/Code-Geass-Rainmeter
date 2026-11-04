<#
.SYNOPSIS
    Builds CodeGeass.rmskin, the package Rainmeter's own skin installer opens.

.DESCRIPTION
    Packs Skins\GurenHoneycomb and the CodeGeass layout with an RMSKIN.ini and the
    installer's header image (assets\RMSKIN.bmp). Double-clicking the .rmskin on a PC
    with Rainmeter opens its skin installer, which copies the skins and layout into
    Rainmeter and applies the layout.

    An .rmskin is a zip file followed by a 16-byte footer: the zip's size as a 64-bit
    number, a flags byte (0) and "RMSKIN" with a closing zero byte.

.EXAMPLE
    .\build-rmskin.ps1 -Version 1.0.0
    Writes dist\CodeGeass.rmskin.
#>
[CmdletBinding()]
param(
    [string]$Version = '1.0.0',
    # Defaults to dist\CodeGeass.rmskin next to this script.
    [string]$OutFile
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $OutFile) { $OutFile = Join-Path $root 'dist\CodeGeass.rmskin' }
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

$suite = 'GurenHoneycomb'
$layout = 'CodeGeass'
$options = @(
    '[rmskin]'
    'Name=Code Geass'
    'Author=danishayman'
    "Version=$Version"
    'MinimumRainmeter=4.5.0'
    'LoadType=Layout'
    "Load=$layout"
) -join "`r`n"

$OutFile = [IO.Path]::GetFullPath($OutFile)
New-Item -ItemType Directory -Force (Split-Path $OutFile) | Out-Null
if (Test-Path $OutFile) { Remove-Item $OutFile }

$stream = [IO.File]::Open($OutFile, [IO.FileMode]::CreateNew)
try {
    $zip = New-Object IO.Compression.ZipArchive($stream, [IO.Compression.ZipArchiveMode]::Create, $true)
    try {
        $entry = $zip.CreateEntry('RMSKIN.ini')
        $writer = New-Object IO.StreamWriter($entry.Open(), [Text.Encoding]::ASCII)
        $writer.Write($options + "`r`n")
        $writer.Dispose()

        $files = @(Get-Item (Join-Path $root 'assets\RMSKIN.bmp')) +
                 @(Get-ChildItem (Join-Path $root "Skins\$suite") -Recurse -File) +
                 @(Get-ChildItem (Join-Path $root "Layouts\$layout") -Recurse -File)
        foreach ($file in $files) {
            $name = $file.FullName.Substring($root.Length + 1)
            # The header image goes in the root of the package; everything else keeps
            # its Skins\... or Layouts\... path.
            if ($name -eq 'assets\RMSKIN.bmp') { $name = 'RMSKIN.bmp' }
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.FullName, $name.Replace('\', '/'), 'Optimal') | Out-Null
        }
    }
    finally {
        $zip.Dispose()
    }

    # Footer: the zip's size, a flags byte, then "RMSKIN" and a zero byte.
    $size = $stream.Length
    $stream.Seek(0, [IO.SeekOrigin]::End) | Out-Null
    $footer = New-Object IO.BinaryWriter($stream)
    $footer.Write([long]$size)
    $footer.Write([byte]0)
    $footer.Write([Text.Encoding]::ASCII.GetBytes("RMSKIN`0"))
    $footer.Flush()
}
finally {
    $stream.Dispose()
}

Write-Host ("Built {0} ({1} files, {2:N1} MB)" -f $OutFile, ($files.Count + 1), ((Get-Item $OutFile).Length / 1MB))
