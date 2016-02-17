
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

Try {
    $client = New-Object System.Net.WebClient
    $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 


    Write-Color -Text "Checking Dependencies" -Color "magenta"

    echo ""
    $localfile = "data\jdk-7u80-windows-i586.exe"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Couldn't find Java 7 SDK x86. Downloading it now: please wait." -Color "yellow"
        $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie") 
        $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe", $localfile)
    } else {
        Write-Color -Text "Java 7 SDK x86 found" -Color "green"
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
    $localfile = "data\jdk-7u80-windows-x64.exe"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Couldn't find Java 7 SDK x64. Downloading it now: please wait." -Color "yellow"
        $client.Headers.Add("Cookie: oraclelicense=accept-securebackup-cookie") 
        $client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-x64.exe", $localfile)
    } else {
        Write-Color -Text "Java 7 SDK x64 found" -Color "green"
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
    $localfile = "data\android-studio-ide-141.2456560-windows.exe"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Couldn't find Android Studio. Downloading it now: please wait." -Color "yellow"
        $client.DownloadFile("http://dl.google.com/dl/android/studio/install/1.5.1.0/android-studio-ide-141.2456560-windows.exe", $localfile)
    } else {
        Write-Color -Text "Android Studio found" -Color "green"
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
    $localfile = "data\installer_r24.4.1-windows.exe"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Couldn't find Android SDK Executable. Downloading it now: please wait." -Color "yellow"
        $client.DownloadFile("http://dl.google.com/android/installer_r24.4.1-windows.exe", $localfile)
    } else {
        Write-Color -Text "Android SDK Executable found" -Color "green"
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
    $localfile = "data\android-sdk_r24.4.1-windows.zip"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Couldn't find Android SDK Zip. Downloading it now: please wait." -Color "yellow"
        $client.DownloadFile("http://dl.google.com/android/android-sdk_r24.4.1-windows.zip", $localfile)
    } else {
        Write-Color -Text "Android SDK Zip found" -Color "green"
    }
    echo "Checking sha1 hash..."
    $hash = [System.BitConverter]::ToString($sha1.ComputeHash([System.IO.File]::ReadAllBytes($localfile)))
    if ($hash -eq "66-B6-A6-43-30-53-C1-52-B2-2B-F8-CA-B1-9C-0F-3F-EF-4E-BA-49") {
        Write-Color -Text "Android SDK Zip hashes match" -Color "green"
    } else {
        Write-Color -Text "ERROR: Android SDK Zip hashes DON'T match:" -Color "red"
        echo "       [$hash]"
        bellExit
    }

    $localfile = "data\android-sdk\tools\android.bat"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
        $shellApplication = new-object -com shell.application
        $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\data\android-sdk_r24.4.1-windows.zip")
        $destinationFolder = $shellApplication.NameSpace((Get-Location).Path + "\data\")
        $destinationFolder.CopyHere($zipPackage.items(), 20)
        Rename-Item "$((Get-Location).Path)\data\android-sdk-windows" "android-sdk"
    } else {
        Write-Color -Text "Zip appears to have already been extracted" -Color "green"
    }

    echo ""
    $localfile = "data\ftc_app.zip"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Couldn't find FTC App. Downloading it now: please wait." -Color "yellow"
        $client.DownloadFile("https://github.com/ftctechnh/ftc_app/archive/master.zip", $localfile)
    } else {
        Write-Color -Text "FTC App found" -Color "green"
    }
    
    $localfile = "data\ftc_app\FtcRobotController\src\main\java\com\qualcomm\ftcrobotcontroller\"
    if (!(Test-Path $localfile)) {
        Write-Color -Text "Not sure if the zip is extracted. Doing that now..." -Color "yellow"
        $shellApplication = new-object -com shell.application
        $zipPackage = $shellApplication.NameSpace((Get-Location).Path + "\data\ftc_app.zip")
        $destinationFolder = $shellApplication.NameSpace((Get-Location).Path + "\data\")
        $destinationFolder.CopyHere($zipPackage.items(), 20)
        Rename-Item "$((Get-Location).Path)\data\ftc_app-master" "ftc_app"
    } else {
        Write-Color -Text "Zip appears to have already been extracted" -Color "green"
    }

    echo ""
    Write-Color -Text "Checking SDK Tools and APIs" -Color "magenta"
    if (!(Test-Path "data\android-sdk\build-tools\21.1.2\")) {
        Write-Color -Text "Downloading build-tools-21.1.2 ..." -Color "yellow"
        echo y | & ".\data\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "build-tools-21.1.2" | out-null
    }
    if (!(Test-Path "data\android-sdk\extras\google\usb_driver\")) {
        Write-Color -Text "Downloading extra-google-usb_driver ..." -Color "yellow"
        echo y | & ".\data\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "extra-google-usb_driver" | out-null
    }
    if (!(Test-Path "data\android-sdk\platforms\android-19\")) {
        Write-Color -Text "Downloading android-19 ..." -Color "yellow"
        echo y | & ".\data\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "android-19" | out-null
    }
    if (!(Test-Path "data\android-sdk\platform-tools\api")) {
        Write-Color -Text "Downloading platform-tools ..." -Color "yellow"
        echo y | & ".\data\android-sdk\tools\android.bat" --silent update sdk --all --no-ui --filter "platform-tools" | out-null
    }
    Write-Color -Text "All SDK and API dependencies present and accounted for" -Color "green"



    echo ""
    Write-Color -Text "Building Net installer" -Color "magenta"
    & "./buildtools/makensis.exe" /DINSTALL_TYPE=Net /DPRODUCT_VERSION="1.0.0" /V2 FTCDevSuite.nsi

    echo ""
    Write-Color -Text "Building Full installer (this could take a bit)" -Color "magenta"
    & "./buildtools/makensis.exe" /DINSTALL_TYPE=Full /DPRODUCT_VERSION="1.0.0" /V2 FTCDevSuite.nsi

    echo ""
    $time= Get-Date
    Write-Host "Completed at $time"
    
} Catch [Exception] {
    echo $_.Exception|format-list -force
}
