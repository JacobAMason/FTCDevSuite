!macro FTC.sections
Section "Java 7 SDK" JavaSDK
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
             /caption "Java 7.80 SDK" \
             "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe" \
             "$INSTDIR\jdk-7u80-windows-i586.exe" /end
  DetailPrint "Checking SHA1 hash for Java 7 SDK"
  Crypto::HashFile "MD5" "$INSTDIR\jdk-7u80-windows-i586.exe"
  Pop $0
  ${If} "8C6C888993144FDBDEC6F5D4E19B57A3" == $0
    DetailPrint "Successfully downloaded Java 7 SDK"
  ${Else}
    DetailPrint "Java 7 SDK md5 didn't match [$0]"
  ${EndIf} 
SectionEnd



Section "Android Studio" AndroidStudio
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android Studio 1.5.1.0" \
             "http://dl.google.com/dl/android/studio/install/1.5.1.0/android-studio-ide-141.2456560-windows.exe" \
             "$INSTDIR\android-studio-ide-141.2456560-windows.exe" /end
  DetailPrint "Checking SHA1 hash for Android Studio 1.5.1.0"
  Crypto::HashFile "SHA1" "$INSTDIR\android-studio-ide-141.2456560-windows.exe"
  Pop $0
  ${If} "8D016B90BF04EBAC6CE548B1976B0C8A4F46B5F9" == $0
    DetailPrint "Successfully downloaded Android Studio 1.5.1.0"
  ${Else}
    DetailPrint "Android Studio 1.5.1.0 SHA1 didn't match [$0]"
  ${EndIf} 
SectionEnd
!macroend
