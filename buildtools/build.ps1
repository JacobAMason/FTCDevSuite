
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


$localfile = "data/android-studio-bundle-141.2456560-windows.exe"
if (!(Test-Path $localfile)) {
    echo "Couldn't find Android Studio. Downloading it now: please wait."
    $client.DownloadFile("http://dl.google.com/dl/android/studio/install/1.5.1.0/android-studio-bundle-141.2456560-windows.exe", $localfile)
} else {
    Write-Color -Text "Android Studio found." -Color "green"
}
echo "Checking sha1 hash..."
$hash = [System.BitConverter]::ToString($sha1.ComputeHash([System.IO.File]::ReadAllBytes($localfile)))
if ($hash -eq "6F-FE-60-8B-1D-D3-90-41-A5-78-01-9E-B3-FE-DB-5E-E6-2B-A5-45") {
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



$PRODUCT_VERSION = "1.0.0"

echo ""
$OUTFILE = "FTCDevSuite.Net.$PRODUCT_VERSION.exe"
Write-Color -Text "Building Net installer" -Color "magenta"
& "./buildtools/makensis.exe" /DOUTFILE=$OUTFILE /DPRODUCT_VERSION=$PRODUCT_VERSION /V2 FTCDevSuiteNet.nsi

echo ""
$OUTFILE = "FTCDevSuite.Full.$PRODUCT_VERSION.exe"
Write-Color -Text "Building Full installer (this could take a bit)" -Color "magenta"
#& "./buildtools/makensis.exe" /DOUTFILE=$OUTFILE /DPRODUCT_VERSION=$PRODUCT_VERSION /V2 FTCDevSuiteNet.nsi
