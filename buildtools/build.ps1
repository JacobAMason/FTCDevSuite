
$client = New-Object System.Net.WebClient
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 


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


Write-Color -Text "Getting Dependencies" -Color "magenta"


echo ""
$localfile = "data/jdk-7u80-windows-i586.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Java 7 SDK x86. Downloading it now: please wait." -Color "yellow"
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie") 
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe", $localfile)
} else {
    Write-Color -Text "Java 7 SDK x86 found." -Color "green"
}
echo "Checking md5 hash..."
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($localfile)))
if ($hash -eq "8C-6C-88-89-93-14-4F-DB-DE-C6-F5-D4-E1-9B-57-A3") {
    Write-Color -Text "Java 7 SDK x86 hashes match" -Color "green"
} else {
    Write-Color -Text "ERROR: Java 7 SDK x86 hashes DON'T match:" -Color "red"
    echo "       [$hash]"
    bellExit
}

echo ""
$localfile = "data/jdk-7u80-windows-x64.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Java 7 SDK x64. Downloading it now: please wait." -Color "yellow"
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie") 
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-x64.exe", $localfile)
} else {
    Write-Color -Text "Java 7 SDK x64 found." -Color "green"
}
echo "Checking md5 hash..."
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($localfile)))
if ($hash -eq "49-9B-22-4F-4D-A7-03-12-DD-D4-7C-48-24-E8-3A-DC") {
    Write-Color -Text "Java 7 SDK x64 hashes match" -Color "green"
} else {
    Write-Color -Text "ERROR: Java 7 SDK x64 hashes DON'T match:" -Color "red"
    echo "       [$hash]"
    bellExit
}

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
    bellExit
}

echo ""
$localfile = "data/installer_r24.4.1-windows.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Android SDK Executable. Downloading it now: please wait." -Color "yellow"
    $client.DownloadFile("http://dl.google.com/android/installer_r24.4.1-windows.exe", $localfile)
} else {
    Write-Color -Text "Android SDK Executable found." -Color "green"
}
echo "Checking sha1 hash..."
$hash = [System.BitConverter]::ToString($sha1.ComputeHash([System.IO.File]::ReadAllBytes($localfile)))
if ($hash -eq "F9-B5-9D-72-41-36-49-D3-1E-63-32-07-E3-1F-45-64-43-E7-EA-0B") {
    Write-Color -Text "Android SDK Executable hashes match" -Color "green"
} else {
    Write-Color -Text "ERROR: Android SDK Executable hashes DON'T match:" -Color "red"
    echo "       [$hash]"
    bellExit
}


echo ""
Write-Color -Text "Getting SDK Tools and APIs" -Color "magenta"
echo y | & "./data/android-sdk/tools/android.bat" --silent update sdk --all --no-ui --filter "platform-tools,build-tools-21.1.2,android-19,extra-google-usb_driver" | out-null


echo ""
Write-Color -Text "Building Net installer" -Color "magenta"
& "./buildtools/makensis.exe" /DINSTALL_TYPE=Net /DPRODUCT_VERSION="1.0.0" /V2 FTCDevSuite.nsi

echo ""
Write-Color -Text "Building Full installer (this could take a bit)" -Color "magenta"
& "./buildtools/makensis.exe" /DINSTALL_TYPE=Full /DPRODUCT_VERSION="1.0.0" /V2 FTCDevSuite.nsi

bellExit
