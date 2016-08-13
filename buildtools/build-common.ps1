$ErrorActionPreference = "Stop"

."..\buildtools\functions.ps1"

Set-Location -literalPath "..\data"

echo ""
$localfile = "jdk-7u80-windows-i586.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Java 7 SDK x86. Downloading it now: please wait." -Color "yellow"
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie")
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe", (Get-Location).Path + "\" + $localfile)
} else {
    Write-Color -Text "Java 7 SDK x86 found" -Color "green"
}
check-hash $md5 $localfile "8C-6C-88-89-93-14-4F-DB-DE-C6-F5-D4-E1-9B-57-A3" "Java 7 SDK x86"

echo ""
$localfile = "jdk-7u80-windows-x64.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Java 7 SDK x64. Downloading it now: please wait." -Color "yellow"
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie")
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-x64.exe", (Get-Location).Path + "\" + $localfile)
} else {
    Write-Color -Text "Java 7 SDK x64 found" -Color "green"
}
check-hash $md5 $localfile "49-9B-22-4F-4D-A7-03-12-DD-D4-7C-48-24-E8-3A-DC" "Java 7 SDK x64"

echo ""
$localfile = "jdk-8u92-windows-i586.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Java 8 SDK x86. Downloading it now: please wait." -Color "yellow"
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie")
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-windows-i586.exe", (Get-Location).Path + "\" + $localfile)
} else {
    Write-Color -Text "Java 8 SDK x86 found" -Color "green"
}
check-hash $sha256 $localfile "9E-5D-DC-BF-9F-6C-96-7D-38-F0-BF-B6-D6-02-09-58-74-F2-9E-61-17-92-9C-7C-F1-20-6F-56-1F-AF-DF-30" "Java 8 SDK x86"

echo ""
$localfile = "jdk-8u92-windows-x64.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Java 8 SDK x64. Downloading it now: please wait." -Color "yellow"
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie")
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-windows-x64.exe", (Get-Location).Path + "\" + $localfile)
} else {
    Write-Color -Text "Java 8 SDK x64 found" -Color "green"
}
check-hash $sha256 $localfile "15-2E-B6-62-E7-ED-E5-96-6D-FB-42-B2-B7-DF-A3-BA-6D-78-4E-AF-B3-F6-ED-22-02-39-97-F3-03-16-BD-D1" "Java 8 SDK x64"

echo ""
$localfile = "installer_r24.4.1-windows.exe"
download-file "Android SDK Exe Installer" $localfile "http://dl.google.com/android/installer_r24.4.1-windows.exe"
check-hash $sha1 $localfile "F9-B5-9D-72-41-36-49-D3-1E-63-32-07-E3-1F-45-64-43-E7-EA-0B" "Android SDK Exe Installer"

echo ""
$localfile = "android-sdk_r24.4.1-windows.zip"
download-file "Android SDK Zip" $localfile "http://dl.google.com/android/android-sdk_r24.4.1-windows.zip"
check-hash $sha1 $localfile "66-B6-A6-43-30-53-C1-52-B2-2B-F8-CA-B1-9C-0F-3F-EF-4E-BA-49" "Android SDK Zip"

$localfile = "android-sdk\tools\android.bat"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\android-sdk_r24.4.1-windows.zip")
    $destinationFolder = $shellApplication.NameSpace((Get-Location).Path)
    $destinationFolder.CopyHere($zipPackage.items(), 20)
    Rename-Item "$((Get-Location).Path)\android-sdk-windows" "android-sdk"
} else {
    Write-Color -Text "Zip appears to have already been extracted" -Color "green"
}

echo ""
Write-Color -Text "Checking SDK Tools and APIs" -Color "magenta"
if (!(Test-Path "android-sdk\build-tools\23.0.3\")) {
    Write-Color -Text "Downloading build-tools-23.0.3 ..." -Color "yellow"
    echo y | & ".\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "build-tools-23.0.3" | out-null
}
if (!(Test-Path "android-sdk\extras\google\usb_driver\")) {
    Write-Color -Text "Downloading extra-google-usb_driver ..." -Color "yellow"
    echo y | & ".\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "extra-google-usb_driver" | out-null
}
if (!(Test-Path "android-sdk\platforms\android-19\")) {
    Write-Color -Text "Downloading android-19 ..." -Color "yellow"
    echo y | & ".\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "android-19" | out-null
}
if (!(Test-Path "android-sdk\platforms\android-23\")) {
    Write-Color -Text "Downloading android-23 ..." -Color "yellow"
    echo y | & ".\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "android-23" | out-null
}
if (!(Test-Path "android-sdk\platform-tools\api")) {
    Write-Color -Text "Downloading platform-tools ..." -Color "yellow"
    echo y | & ".\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "platform-tools" | out-null
}
if (!(Test-Path "android-sdk\extras\android\m2repository\com\android\support")) {
    Write-Color -Text "Downloading extra-android-m2repository ..." -Color "yellow"
    echo y | & ".\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "extra-android-m2repository" | out-null
}
Write-Color -Text "All SDK and API dependencies present and accounted for" -Color "green"

