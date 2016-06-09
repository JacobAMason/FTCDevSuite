$ErrorActionPreference = "Stop"

function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
    Write-Host
}

function bellExit {
    echo `a
    Exit
}

function download-file ($title, $localfile, $url) {
    $client = New-Object System.Net.WebClient
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Couldn't find $title. Downloading it now: please wait." -Color "yellow"
        $client.DownloadFile($url, (Get-Location).Path + "\" + $localfile)
    } else {
        Write-Color -Text "$title found" -Color "green"
    }
}

$md5 = New-Object System.Security.Cryptography.MD5CryptoServiceProvider
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
$sha512 = New-Object System.Security.Cryptography.SHA512CryptoServiceProvider
function check-hash ($checksumMethod, $localfile, $expectedHash, $title) {
    echo "Checking hash..."
    $hash = [System.BitConverter]::ToString($checksumMethod.ComputeHash([System.IO.File]::ReadAllBytes((Get-Location).Path + "\" + $localfile)))
    if ($hash -eq $expectedHash) {
        Write-Color -Text "$title hashes match" -Color "green"
    } else {
        Write-Color -Text "ERROR: $title hashes DON'T match:" -Color "red"
        echo "       [$hash]"
        bellExit
    }
}

