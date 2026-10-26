# Run CRUD regression tests for tsqldep.ps1.
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$script = Join-Path $root "tsqldep.ps1"
$failed = 0

foreach ($case in Get-ChildItem (Join-Path $PSScriptRoot "crud") -Filter "*.sql" | Sort-Object Name) {
    $content = Get-Content $case.FullName -Raw
    $match = [regex]::Match($content, "-- EXPECT: (.+)")
    if (-not $match.Success) {
        Write-Host "[FAIL] $($case.Name): EXPECT line not found"
        $failed++
        continue
    }

    $expected = @{}
    foreach ($part in $match.Groups[1].Value.Split(";")) {
        $kv = $part.Trim().Split("=", 2)
        $expected[$kv[0].Trim()] = if ($kv.Count -gt 1) { $kv[1].Trim() } else { "" }
    }

    $output = & $script -c $case.FullName 2>&1 | Out-String
    $actual = @{}
    foreach ($line in $output -split "\r?\n") {
        $m = [regex]::Match($line, "^([CRUD])\s*:\s*(.*)$")
        if ($m.Success) {
            $actual[$m.Groups[1].Value] = $m.Groups[2].Value.Trim()
        }
    }

    $caseFailed = $false
    foreach ($kind in @("C","R","U","D")) {
        $e = @($expected[$kind] -split "," | Where-Object { $_ -ne "" } | Sort-Object -Unique) -join ","
        $a = @($actual[$kind] -split "," | Where-Object { $_ -ne "" } | Sort-Object -Unique) -join ","
        if ($e -ne $a) {
            Write-Host "[FAIL] $($case.Name): $kind expected='$e' actual='$a'"
            $caseFailed = $true
        }
    }

    if (-not $caseFailed) {
        Write-Host "[PASS] $($case.Name)"
    } else {
        $failed++
    }
}

if ($failed -ne 0) {
    Write-Host "$failed test case(s) failed."
    exit 1
}

Write-Host "All CRUD tests passed."
