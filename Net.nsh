!macro FTC.sections
Section "Java 7 SDK" JavaSDK
  ${If} ${RunningX64}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 7.80 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-x64.exe" \
               "$TEMP\jdk-7u80-windows-x64.exe" /end
    DetailPrint "Checking SHA1 hash for Java 7 SDK"
    Crypto::HashFile "MD5" "$INSTDIR\jdk-7u80-windows-x64.exe"
    Pop $0
    ${If} "499B224F4DA70312DDD47C4824E83ADC" == $0
      DetailPrint "Successfully downloaded Java 7 SDK"
      ExecWait '"$TEMP\jdk-7u80-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 7 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-7u80-windows-x64.exe"
  ${Else}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 7.80 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe" \
               "$TEMP\jdk-7u80-windows-i586.exe" /end
    DetailPrint "Checking SHA1 hash for Java 7 SDK"
    Crypto::HashFile "MD5" "$INSTDIR\jdk-7u80-windows-i586.exe"
    Pop $0
    ${If} "8C6C888993144FDBDEC6F5D4E19B57A3" == $0
      DetailPrint "Successfully downloaded Java 7 SDK"
      ExecWait '"$TEMP\jdk-7u80-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 7 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-7u80-windows-i586.exe"
  ${EndIf} 
SectionEnd



Section "Android Studio" AndroidStudio
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android Studio 1.5.1.0" \
             "http://dl.google.com/dl/android/studio/install/1.5.1.0/android-studio-ide-141.2456560-windows.exe" \
             "$TEMP\android-studio-ide-141.2456560-windows.exe" /end
  DetailPrint "Checking SHA1 hash for Android Studio 1.5.1.0"
  Crypto::HashFile "SHA1" "$INSTDIR\android-studio-ide-141.2456560-windows.exe"
  Pop $0
  ${If} "8D016B90BF04EBAC6CE548B1976B0C8A4F46B5F9" == $0
    DetailPrint "Successfully downloaded Android Studio 1.5.1.0"
    ExecWait '"$TEMP\android-studio-ide-141.2456560-windows.exe" /S'
  ${Else}
    DetailPrint "Android Studio 1.5.1.0 SHA1 didn't match [$0]"
  ${EndIf} 
  Delete "$TEMP\android-studio-ide-141.2456560-windows.exe"
SectionEnd



Section "Android SDK" AndroidSDK
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android SDK 24.4.1" \
             "http://dl.google.com/android/installer_r24.4.1-windows.exe" \
             "$TEMP\installer_r24.4.1-windows.exe" /end
  DetailPrint "Checking SHA1 hash for Android SDK 24.4.1"
  Crypto::HashFile "SHA1" "$INSTDIR\installer_r24.4.1-windows.exe"
  Pop $0
  ${If} "F9B59D72413649D31E633207E31F456443E7EA0B" == $0
    DetailPrint "Successfully downloaded Android SDK 24.4.1"
    ExecWait '"$TEMP\installer_r24.4.1-windows.exe" /S'
  ${Else}
    DetailPrint "Android SDK 24.4.1 SHA1 didn't match [$0]"
  ${EndIf} 
  Delete "$TEMP\installer_r24.4.1-windows.exe"
SectionEnd
!macroend
