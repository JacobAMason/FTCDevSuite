!macro FIRSTDevSuite.sections
Section "Java 7 SDK" JavaSDK
  AddSize 144000
  SetOutPath "$TEMP"
  ${If} ${RunningX64}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 7.80 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-x64.exe" \
               "$TEMP\jdk-7u80-windows-x64.exe" /end
    Crypto::HashFile "MD5" "$TEMP\jdk-7u80-windows-x64.exe"
    Pop $0
    ${If} "499B224F4DA70312DDD47C4824E83ADC" == $0
      DetailPrint "MD5 hash for Java 7 SDK is good"
    ${OrIf} "OK" == $0
      DetailPrint "Successfully downloaded Java 7 SDK"
      ExecWait '"$TEMP\jdk-7u80-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 7 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-7u80-windows-x64.exe"
    SetRegView 64
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES64\Java\jdk1.7.0_80"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES64\Java\jdk1.7.0_80").r0'
  ${Else}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 7.80 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe" \
               "$TEMP\jdk-7u80-windows-i586.exe" /end
    Crypto::HashFile "MD5" "$TEMP\jdk-7u80-windows-i586.exe"
    Pop $0
    ${If} "8C6C888993144FDBDEC6F5D4E19B57A3" == $0
      DetailPrint "MD5 hash for Java 7 SDK is good"
    ${OrIf} "OK" == $0
      DetailPrint "Successfully downloaded Java 7 SDK"
      ExecWait '"$TEMP\jdk-7u80-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 7 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-7u80-windows-i586.exe"
    SetRegView 32
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES32\Java\jdk1.7.0_80"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES32\Java\jdk1.7.0_80").r0'
  ${EndIf} 
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd



Section "Android Studio" AndroidStudio
  AddSize 1700000
  SetOutPath "$TEMP"
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android Studio 1.5.1.0" \
             "http://dl.google.com/dl/android/studio/install/1.5.1.0/android-studio-ide-141.2456560-windows.exe" \
             "$TEMP\android-studio-ide-141.2456560-windows.exe" /end
  Crypto::HashFile "SHA1" "$TEMP\android-studio-ide-141.2456560-windows.exe"
  Pop $0
  ${If} "8D016B90BF04EBAC6CE548B1976B0C8A4F46B5F9" == $0
    DetailPrint "SHA1 hash for Android Studio 1.5.1.0 is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Android Studio 1.5.1.0"
    ExecWait '"$TEMP\android-studio-ide-141.2456560-windows.exe" /S'
  ${Else}
    Abort "Android Studio 1.5.1.0 SHA1 didn't match [$0]"
  ${EndIf} 
  Delete "$TEMP\android-studio-ide-141.2456560-windows.exe"
  ${If} ${RunningX64}
    FileOpen $0 "$PROGRAMFILES64\Android\Android Studio\bin\idea.properties" a
  ${Else}
    FileOpen $0 "$PROGRAMFILES\Android\Android Studio\bin\idea.properties" a
  ${EndIf}
  FileSeek $0 0 END
  FileWrite $0 "disable.android.first.run=true"
  FileClose $0
SectionEnd



Section "Android SDK" AndroidSDK
  AddSize 316400
  SetOutPath "$TEMP"
  File "data\get_sdk_packages.bat"
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android SDK 24.4.1" \
             "http://dl.google.com/android/installer_r24.4.1-windows.exe" \
             "$TEMP\installer_r24.4.1-windows.exe" /end
  Crypto::HashFile "SHA1" "$TEMP\installer_r24.4.1-windows.exe"
  Pop $0
  ${If} "F9B59D72413649D31E633207E31F456443E7EA0B" == $0
    DetailPrint "SHA1 hash for Android SDK 24.4.1 is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Android SDK 24.4.1"
    ExecWait '"$TEMP\installer_r24.4.1-windows.exe" /S'
  ${Else}
    Abort "Android SDK 24.4.1 SHA1 didn't match [$0]"
  ${EndIf} 
  Delete "$TEMP\installer_r24.4.1-windows.exe"

  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "ANDROID_HOME" "$LOCALAPPDATA\Android\android-sdk"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("ANDROID_HOME", "$LOCALAPPDATA\Android\android-sdk").r0'

  DetailPrint "Downloading SDK packages and APIs"
  nsExec::Exec "$TEMP\get_sdk_packages.bat"
SectionEnd



Section "FIRST Tech Challenge App" FTCapp
  AddSize 71700
  SetOutPath "$INSTDIR"
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "FIRST Tech Challenge App - ftctechnh/ftc_app/master" \
             "https://github.com/ftctechnh/ftc_app/archive/master.zip" \
             "$INSTDIR\ftc_app.zip" /end
  ZipDLL::extractall "$INSTDIR\ftc_app.zip" "$INSTDIR" "<ALL>"
  Rename "$INSTDIR\ftc_app-master" "$INSTDIR\ftc_app"
  Delete "$INSTDIR\ftc_app.zip"
SectionEnd
!macroend
