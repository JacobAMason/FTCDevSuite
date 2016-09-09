$VERSION = Get-Content VERSION
$ErrorActionPreference = "Stop"

Set-Location -literalPath "..\data"

."..\buildtools\functions.ps1"

Try {

Write-Color -Text "Checking Dependencies" -Color "magenta"

."..\buildtools\build-common.ps1"

echo ""
$localfile = "android-studio-ide-143.2915827-windows.exe"
download-file "Android Studio 2.1.2.0" $localfile "https://dl.google.com/dl/android/studio/install/2.1.2.0/android-studio-ide-143.2915827-windows.exe"
check-hash $sha1 $localfile "E9-BB-11-E3-48-63-96-37-E4-41-37-E3-0F-77-A4-B1-E8-78-3E-B0" "Android Studio"

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
