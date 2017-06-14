$VERSION = Get-Content VERSION
$ErrorActionPreference = "Stop"

Set-Location -literalPath "..\data"

."..\buildtools\functions.ps1"

Try {

Write-Color -Text "Checking Dependencies" -Color "magenta"

."..\buildtools\build-common.ps1"

echo ""
$localfile = "android-studio-ide-162.4069837-windows.exe"
download-file "Android Studio 2.2.3.0" $localfile "https://dl.google.com/dl/android/studio/install/2.3.3.0/android-studio-ide-162.4069837-windows.exe"
check-hash $sha256 $localfile "F0-B7-24-73-CB-94-BA-4B-CB-C8-0E-EB-84-F4-B5-33-64-DA-09-7E-FA-25-5F-7C-AB-71-BC-B1-0A-28-77-5A" "Android Studio"

echo ""
$localfile = "ftc_app.zip"
download-file "FTC app" $localfile "https://github.com/ftctechnh/ftc_app/archive/master.zip"

$localfile = "ftc_app\FtcRobotController\src\main\java\org\firstinspires\ftc\robotcontroller\"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\ftc_app.zip")
    $destinationFolder = $shellApplication.NameSpace((Get-Location).Path)
    $destinationFolder.CopyHere($zipPackage.items(), 20)
    Rename-Item "$((Get-Location).Path)\ftc_app-master" "ftc_app"
} else {
    Write-Color -Text "Zip appears to have already been extracted" -Color "green"
}


echo ""
Write-Color -Text "Building Net installer" -Color "magenta"
& ".\..\buildtools\NSIS\makensis.exe" /DINSTALL_TYPE=Net /DPRODUCT_VERSION=$VERSION /V2 "..\Android-Studio\AndroidStudioDevSuite.nsi"

echo ""
Write-Color -Text "Building Full installer (takes ~10m)" -Color "magenta"
& ".\..\buildtools\NSIS\makensis.exe" /DINSTALL_TYPE=Full /DPRODUCT_VERSION=$VERSION /V2 "..\Android-Studio\AndroidStudioDevSuite.nsi"

echo ""
$time= Get-Date
Write-Host "Completed at $time"
bellExit

} Catch [Exception] {
    echo $_.Exception|format-list -force
}
