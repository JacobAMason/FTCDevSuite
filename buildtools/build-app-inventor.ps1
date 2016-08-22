$VERSION = Get-Content VERSION
$ErrorActionPreference = "Stop"

Set-Location -literalPath "..\data"

."..\buildtools\functions.ps1"

Try {

Write-Color -Text "Checking Dependencies" -Color "magenta"

."..\buildtools\build-common.ps1"

echo ""
$localfile = "Git-2.8.3-32-bit.exe"
download-file "Git x86" $localfile "https://github.com/git-for-windows/git/releases/download/v2.8.3.windows.1/Git-2.8.3-32-bit.exe"
check-hash $md5 $localfile "B3-E0-21-85-FD-35-27-07-54-75-54-3B-A5-6B-6B-E6" "Git x86"

echo ""
$localfile = "Git-2.8.3-64-bit.exe"
download-file "Git x64" $localfile "https://github.com/git-for-windows/git/releases/download/v2.8.3.windows.1/Git-2.8.3-64-bit.exe"
check-hash $md5 $localfile "DA-9B-B2-01-F0-A4-7A-7C-5C-67-1B-AC-B0-C5-B8-DF" "Git x64"

echo ""
$localfile = "apache-ant-1.9.7-bin.zip"
download-file "Ant Zip" $localfile "http://apache.cs.utah.edu//ant/binaries/apache-ant-1.9.7-bin.zip"
check-hash $sha1 $localfile "F6-D3-F9-AA-55-66-1A-5C-B2-DF-F3-F1-93-3C-A9-A5-99-10-20-6C" "Ant Zip"

$localfile = "apache-ant-1.9.7\bin\ant"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\apache-ant-1.9.7-bin.zip")
    $destinationFolder = $shellApplication.NameSpace((Get-Location).Path)
    $destinationFolder.CopyHere($zipPackage.items(), 20)
} else {
    Write-Color -Text "Zip appears to have already been extracted" -Color "green"
}

echo ""
$localfile = "appengine-java-sdk-1.9.27.zip"
download-file "Google App Engine SDK for Java Zip" $localfile "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.27.zip"
check-hash $sha1 $localfile "AD-60-0E-42-8B-36-EE-57-50-C3-BC-FB-D1-1B-D1-E5-87-39-39-4E" "Google App Engine SDK for Java Zip"

$localfile = "appengine-java-sdk-1.9.27\bin\dev_appserver.cmd"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\appengine-java-sdk-1.9.27.zip")
    $destinationFolder = $shellApplication.NameSpace((Get-Location).Path)
    $destinationFolder.CopyHere($zipPackage.items(), 20)
} else {
    Write-Color -Text "Zip appears to have already been extracted" -Color "green"
}

echo ""
$localfile = "python-2.7.11.msi"
download-file "Python 2.7.11 x86" $localfile "https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi"
check-hash $md5 $localfile "24-1B-F8-E0-97-AB-4E-10-47-D9-BB-4F-59-60-20-95" "Python 2.7.11 x86"

echo ""
$localfile = "python-2.7.11.amd64.msi"
download-file "Python 2.7.11 x64" $localfile "https://www.python.org/ftp/python/2.7.11/python-2.7.11.amd64.msi"
check-hash $md5 $localfile "25-AC-CA-42-66-2D-4B-02-68-2E-EE-0D-F3-F3-44-6D" "Python 2.7.11 x64"

echo ""
$localfile = "phantomjs-2.1.1-windows.zip"
download-file "PhantomJS Zip" $localfile "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip"
check-hash $md5 $localfile "41-04-47-0D-43-DD-F2-A1-95-E8-86-9D-EE-F0-AA-69" "PhantomJS Zip"

$localfile = "phantomjs-2.1.1-windows\bin\phantomjs.exe"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\phantomjs-2.1.1-windows.zip")
    $destinationFolder = $shellApplication.NameSpace((Get-Location).Path)
    $destinationFolder.CopyHere($zipPackage.items(), 20)
} else {
    Write-Color -Text "Zip appears to have already been extracted" -Color "green"
}

$localfile = "Firefox Setup 47.0.exe"
download-file "Firefox 47 x32" $localfile "https://ftp.mozilla.org/pub/firefox/releases/47.0/win32/en-US/Firefox%20Setup%2047.0.exe"
check-hash $sha512 $localfile "50-74-19-d4-fb-79-2e-a3-69-54-58-6c-42-b8-76-d6-c6-c6-0d-c0-ef-4b-60-56-15-05-78-ca-49-4c-e8-81-58-fc-7f-c5-ba-10-13-b5-37-8f-7a-c9-56-0c-bb-7c-34-c7-3f-6d-bc-ea-51-aa-2e-61-ce-d6-4a-75-f9-81" "Firefox 47 x32"

echo ""
$localfile = "Firefox Setup 47.0 x64.exe"
download-file "Firefox 47 x64" $localfile "https://ftp.mozilla.org/pub/firefox/releases/47.0/win64/en-US/Firefox%20Setup%2047.0.exe"
check-hash $sha512 $localfile "d7-0f-c9-7d-66-bf-4f-cc-8b-77-b7-15-11-b5-e6-ae-2e-0b-30-9c-9c-53-f6-d1-46-a3-42-0b-e0-0f-e8-fb-c3-18-84-f5-4a-ed-94-dc-d3-cb-b7-de-a2-f8-6b-e1-94-7b-9d-83-90-b9-0b-de-2c-2d-1e-a0-b3-02-8d-28" "Firefox 47 x64"

echo ""
$localfile = "appinventor-sources.zip"
download-file "MIT App Inventor" $localfile "https://github.com/lizlooney/appinventor-sources/archive/future.zip"

$localfile = "appinventor-sources\appinventor\buildserver\src\com\google\appinventor\buildserver\"
if (!(Test-Path $localfile)) {
    Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\appinventor-sources.zip")
    $destinationFolder = $shellApplication.NameSpace((Get-Location).Path)
    $destinationFolder.CopyHere($zipPackage.items(), 20)
    Rename-Item "$((Get-Location).Path)\appinventor-sources-future" "appinventor-sources"
} else {
    Write-Color -Text "Zip appears to have already been extracted" -Color "green"
}


echo ""
Write-Color -Text "Building Net installer" -Color "magenta"
& ".\..\buildtools\NSIS\makensis.exe" /DINSTALL_TYPE=Net /DPRODUCT_VERSION=$VERSION /V2 "..\App-Inventor\AppInventorDevSuite.nsi"

echo ""
Write-Color -Text "Building Full installer (takes ~10m)" -Color "magenta"
& ".\..\buildtools\NSIS\makensis.exe" /DINSTALL_TYPE=Full /DPRODUCT_VERSION=$VERSION /V2 "..\App-Inventor\AppInventorDevSuite.nsi"

echo ""
$time= Get-Date
Write-Host "Completed at $time"
bellExit

} Catch [Exception] {
    echo $_.Exception|format-list -force
}
