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

