$ErrorActionPreference = "Stop"

."..\buildtools\functions.ps1"

Set-Location -literalPath "..\data"

echo ""
$localfile = "jdk-8u131-windows-x64.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Couldn't find Java 8 SDK x64. Downloading it now: please wait." -Color "yellow"
    $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie")
    $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-windows-x64.exe", (Get-Location).Path + "\" + $localfile)
} else {
    Write-Color -Text "Java 8 SDK x64 found" -Color "green"
}
check-hash $sha512 $localfile "5C-F7-87-E3-51-07-52-6B-1C-95-1E-2C-A3-73-06-29-98-10-E0-2A-A5-EA-17-87-28-E9-3A-A7-40-C6-D9-65-77-11-B5-08-04-9A-D1-72-08-D0-82-AF-59-5D-31-1F-FB-1B-18-82-87-6E-89-44-BF-D6-25-61-3A-02-FC-68" "Java 8 SDK x64"

echo ""
$localfile = "sdk-tools-windows-3859397.zip"
download-file "Android SDK Zip" $localfile "https://dl.google.com/android/repository/sdk-tools-windows-3859397.zip"
check-hash $sha512 $localfile "5F-B7-3A-99-4D-D7-B1-25-C9-63-EC-8E-19-35-38-C2-B0-C5-94-32-E9-91-11-2F-62-EB-D7-30-8B-B0-E7-9B-87-3A-B7-EC-65-3F-15-25-54-01-BB-55-00-C1-1A-D2-E6-C6-89-4B-F5-46-FC-C4-43-12-2B-52-74-09-DA-24" "Android SDK Zip"

$localfile = "android-sdk\tools\bin\sdkmanager.bat"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\sdk-tools-windows-3859397.zip")
    $destinationFolder = $shellApplication.NameSpace((Get-Location).Path)
    New-Item -ItemType directory -Path ".\android-sdk" | out-null
    $destinationFolder.CopyHere($zipPackage.items(), 20)
    Move-Item ".\tools" ".\android-sdk\tools"
} else {
    Write-Color -Text "Zip appears to have already been extracted" -Color "green"
}

echo ""
Write-Color -Text "Checking SDK Tools and APIs" -Color "magenta"
if (!(Test-Path "android-sdk\build-tools\23.0.3\")) {
    Write-Color -Text "Downloading build-tools-23.0.3 ..." -Color "yellow"
    echo y| & ".\android-sdk\tools\bin\sdkmanager.bat" "build-tools;23.0.3" | out-null
}
if (!(Test-Path "android-sdk\extras\google\usb_driver\")) {
    Write-Color -Text "Downloading extra-google-usb_driver ..." -Color "yellow"
    echo y| & ".\android-sdk\tools\bin\sdkmanager.bat" "extras;google;usb_driver" | out-null
}
if (!(Test-Path "android-sdk\platforms\android-19\")) {
    Write-Color -Text "Downloading android-19 ..." -Color "yellow"
    echo y| & ".\android-sdk\tools\bin\sdkmanager.bat" "platforms;android-19" | out-null
}
if (!(Test-Path "android-sdk\platforms\android-23\")) {
    Write-Color -Text "Downloading android-23 ..." -Color "yellow"
    echo y| & ".\android-sdk\tools\bin\sdkmanager.bat" "platforms;android-23" | out-null
}
if (!(Test-Path "android-sdk\platform-tools\api")) {
    Write-Color -Text "Downloading platform-tools ..." -Color "yellow"
    echo y| & ".\android-sdk\tools\bin\sdkmanager.bat" "platform-tools" | out-null
}
Write-Color -Text "All SDK and API dependencies present and accounted for" -Color "green"

