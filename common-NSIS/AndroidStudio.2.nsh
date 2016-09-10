Section "Android Studio" AndroidStudio
  AddSize 290846
  SetOutPath "$TEMP"

!if ${INSTALL_TYPE} == "Net"

  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android Studio 2.1.3.0" \
             "https://dl.google.com/dl/android/studio/install/2.1.3.0/android-studio-ide-143.3101438-windows.exe" \
             "$TEMP\android-studio-ide-143.3101438-windows.exe" /end
  Crypto::HashFile "SHA1" "$TEMP\android-studio-ide-143.3101438-windows.exe"
  Pop $0
  ${If} "43F84DE7E61F37880A126C3D567B7fA6CB90C90E" == $0
    DetailPrint "SHA1 hash for Android Studio 2.1.3.0 is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Android Studio 2.1.3.0"
    ExecWait '"$TEMP\android-studio-ide-143.3101438-windows.exe" /S'
  ${Else}
    Abort "Android Studio 2.1.3.0 SHA1 didn't match [$0]"
  ${EndIf}

!endif
!if ${INSTALL_TYPE} == "Full"

  File "..\data\android-studio-ide-143.3101438-windows.exe"
  ExecWait '"$TEMP\android-studio-ide-143.3101438-windows.exe" /S'

!endif

  Delete "$TEMP\android-studio-ide-143.3101438-windows.exe"
  ${If} ${RunningX64}
    FileOpen $0 "$PROGRAMFILES64\Android\Android Studio\bin\idea.properties" a
  ${Else}
    FileOpen $0 "$PROGRAMFILES\Android\Android Studio\bin\idea.properties" a
  ${EndIf}
  FileSeek $0 0 END
  FileWrite $0 "disable.android.first.run=true"
  FileClose $0
SectionEnd

