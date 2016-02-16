
$client = New-Object System.Net.WebClient
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 


function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
    Write-Host
}


Write-Color -Text "Getting Dependencies" -Color "magenta"
echo ""


$localfile = "data/android-studio-ide-141.2456560-windows.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Android Studio. Downloading it now: please wait." -Color "yellow"
    $client.DownloadFile("http://dl.google.com/dl/android/studio/install/1.5.1.0/android-studio-ide-141.2456560-windows.exe", $localfile)
} else {
    Write-Color -Text "Android Studio found." -Color "green"
}
echo "Checking sha1 hash..."
$hash = [System.BitConverter]::ToString($sha1.ComputeHash([System.IO.File]::ReadAllBytes($localfile)))
if ($hash -eq "8D-01-6B-90-BF-04-EB-AC-6C-E5-48-B1-97-6B-0C-8A-4F-46-B5-F9") {
    Write-Color -Text "Android Studio hashes match" -Color "green"
} else {
    Write-Color -Text "ERROR: Android Studio hashes DON'T match:" -Color "red"
    echo "       [$hash]"
}

echo ""

$localfile = "data/jdk-7u80-windows-i586.exe"
if (!(Test-Path $localfile)) {
    echo "Couldn't find Java 7 SDK. Downloading it now: please wait."
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie") 
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe", $localfile)
} else {
    Write-Color -Text "Java 7 SDK found." -Color "green"
}
echo "Checking md5 hash..."
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($localfile)))
if ($hash -eq "8C-6C-88-89-93-14-4F-DB-DE-C6-F5-D4-E1-9B-57-A3") {
    Write-Color -Text "Java 7 SDK hashes match" -Color "green"
} else {
    Write-Color -Text "ERROR: Java 7 SDK hashes DON'T match:" -Color "red"
    echo "       [$hash]"
}



echo ""
Write-Color -Text "Building Net installer" -Color "magenta"
& "./buildtools/makensis.exe" /DINSTALLER_TYPE=Net /DPRODUCT_VERSION="1.0.0" /V2 FTCDevSuite.nsi

echo ""
Write-Color -Text "Building Full installer (this could take a bit)" -Color "magenta"
& "./buildtools/makensis.exe" /DINSTALLER_TYPE=Full /DPRODUCT_VERSION="1.0.0" /V2 FTCDevSuite.nsi
