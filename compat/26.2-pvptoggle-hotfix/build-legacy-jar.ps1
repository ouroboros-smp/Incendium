[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $BaseJar,

    [string] $OutputJar = (Join-Path (Get-Location) "Incendium_Legacy_26.2_5.5.0-ouroboros-ranged-hotfix.1.jar")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$expectedBaseSha256 = "1626bcced55d5baa3a9c7c3526c830880cbd828bd8793a3cfc60f713479fcc34"
$expectedOutputSha256 = "194020e5674afbc46e4ec3d061268e9a003a96fd2675bccd893f1f7809fd0dda"
$hotfixVersion = "5.5.0+ouroboros.rangedhotfix.1"
$fixedTimestamp = [DateTimeOffset]::new(2026, 8, 4, 0, 0, 0, [TimeSpan]::Zero)

$basePath = (Resolve-Path -LiteralPath $BaseJar).Path
$outputPath = [IO.Path]::GetFullPath($OutputJar)
$dataRoot = Join-Path $PSScriptRoot "data"

if ([StringComparer]::OrdinalIgnoreCase.Equals($basePath, $outputPath)) {
    throw "Output jar must not overwrite the upstream base jar."
}
if ([IO.File]::Exists($outputPath)) {
    throw "Output already exists: $outputPath"
}

$baseSha256 = (Get-FileHash -LiteralPath $basePath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($baseSha256 -ne $expectedBaseSha256) {
    throw "Unexpected base jar SHA256: $baseSha256 (expected $expectedBaseSha256)"
}

$outputDirectory = Split-Path -Parent $outputPath
[IO.Directory]::CreateDirectory($outputDirectory) | Out-Null

$overrides = [Collections.Generic.Dictionary[string, string]]::new([StringComparer]::Ordinal)
Get-ChildItem -LiteralPath $dataRoot -File -Recurse | ForEach-Object {
    $entryName = [IO.Path]::GetRelativePath($PSScriptRoot, $_.FullName).Replace("\", "/")
    $overrides.Add($entryName, $_.FullName)
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$source = [IO.Compression.ZipFile]::OpenRead($basePath)
try {
    $sourceEntries = [Collections.Generic.Dictionary[string, IO.Compression.ZipArchiveEntry]]::new([StringComparer]::Ordinal)
    foreach ($entry in $source.Entries) {
        if ($sourceEntries.ContainsKey($entry.FullName)) {
            throw "Base jar contains duplicate entry: $($entry.FullName)"
        }
        $sourceEntries.Add($entry.FullName, $entry)
    }

    $entryNames = @($sourceEntries.Keys) + @($overrides.Keys) |
        Sort-Object -Unique -CaseSensitive

    $destination = [IO.Compression.ZipFile]::Open($outputPath, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($entryName in $entryNames) {
            $destinationEntry = $destination.CreateEntry($entryName, [IO.Compression.CompressionLevel]::Optimal)
            $destinationEntry.LastWriteTime = $fixedTimestamp

            if ($entryName.EndsWith("/", [StringComparison]::Ordinal)) {
                continue
            }

            $destinationStream = $destinationEntry.Open()
            try {
                if ($entryName -eq "fabric.mod.json") {
                    $sourceStream = $sourceEntries[$entryName].Open()
                    $reader = [IO.StreamReader]::new($sourceStream, [Text.UTF8Encoding]::new($false), $true)
                    try {
                        $manifest = $reader.ReadToEnd()
                    }
                    finally {
                        $reader.Dispose()
                    }

                    $replacements = [ordered]@{
                        '"version": "5.5.0"' = '"version": "' + $hotfixVersion + '"'
                        '"sources": "https://github.com/Stardust-Labs-MC/Incendium"' = '"sources": "https://github.com/ouroboros-smp/Incendium"'
                        '"issues": "https://github.com/Stardust-Labs-MC/Incendium/issues"' = '"issues": "https://github.com/ouroboros-smp/Incendium/issues"'
                    }
                    foreach ($replacement in $replacements.GetEnumerator()) {
                        if ($manifest.IndexOf($replacement.Key, [StringComparison]::Ordinal) -lt 0) {
                            throw "Expected fabric.mod.json field was not found: $($replacement.Key)"
                        }
                        $manifest = $manifest.Replace($replacement.Key, $replacement.Value)
                    }

                    $writer = [IO.StreamWriter]::new($destinationStream, [Text.UTF8Encoding]::new($false), 1024, $true)
                    try {
                        $writer.Write($manifest)
                    }
                    finally {
                        $writer.Dispose()
                    }
                }
                elseif ($overrides.ContainsKey($entryName)) {
                    $overrideStream = [IO.File]::OpenRead($overrides[$entryName])
                    try {
                        $overrideStream.CopyTo($destinationStream)
                    }
                    finally {
                        $overrideStream.Dispose()
                    }
                }
                else {
                    $sourceStream = $sourceEntries[$entryName].Open()
                    try {
                        $sourceStream.CopyTo($destinationStream)
                    }
                    finally {
                        $sourceStream.Dispose()
                    }
                }
            }
            finally {
                $destinationStream.Dispose()
            }
        }
    }
    finally {
        $destination.Dispose()
    }
}
catch {
    if ([IO.File]::Exists($outputPath)) {
        [IO.File]::Delete($outputPath)
    }
    throw
}
finally {
    $source.Dispose()
}

$built = [IO.Compression.ZipFile]::OpenRead($outputPath)
try {
    $builtNames = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($entry in $built.Entries) {
        if (-not $builtNames.Add($entry.FullName)) {
            throw "Built jar contains duplicate entry: $($entry.FullName)"
        }
    }

    foreach ($override in $overrides.GetEnumerator()) {
        $entry = $built.GetEntry($override.Key)
        if ($null -eq $entry) {
            throw "Built jar is missing override: $($override.Key)"
        }
        $entryStream = $entry.Open()
        $fileStream = [IO.File]::OpenRead($override.Value)
        try {
            if ($entry.Length -ne $fileStream.Length) {
                throw "Built override length mismatch: $($override.Key)"
            }
            for ($index = 0; $index -lt $entry.Length; $index++) {
                if ($entryStream.ReadByte() -ne $fileStream.ReadByte()) {
                    throw "Built override content mismatch: $($override.Key)"
                }
            }
        }
        finally {
            $entryStream.Dispose()
            $fileStream.Dispose()
        }
    }
}
finally {
    $built.Dispose()
}

& jar --validate --file $outputPath
if ($LASTEXITCODE -ne 0) {
    throw "jar --validate failed with exit code $LASTEXITCODE"
}

$outputSha256 = (Get-FileHash -LiteralPath $outputPath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($outputSha256 -ne $expectedOutputSha256) {
    throw "Unexpected output jar SHA256: $outputSha256 (expected $expectedOutputSha256)"
}

[pscustomobject]@{
    Output = $outputPath
    Version = $hotfixVersion
    BaseSha256 = $baseSha256
    OutputSha256 = $outputSha256
    OverrideFiles = $overrides.Count
}
