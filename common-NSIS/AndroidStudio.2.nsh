Section "Android Studio" AndroidStudio
  AddSize 473299
  SetOutPath "$TEMP"

!if ${INSTALL_TYPE} == "Net"

  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android Studio 2.3.3.0" \
             "https://dl.google.com/dl/android/studio/install/2.3.3.0/android-studio-ide-162.4069837-windows.exe" \
             "$TEMP\android-studio-ide-162.4069837-windows.exe" /end
  Crypto::HashFile "SHA2-256" "$TEMP\android-studio-ide-162.4069837-windows.exe"
  Pop $0
  ${If} "F0B72473CB94BA4BCBC80EEB84F4B53364DA097EFA255F7CAB71BCB10A28775A" == $0
    DetailPrint "SHA256 hash for Android Studio 2.3.3.0 is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Android Studio 2.3.3.0"
    ExecWait '"$TEMP\android-studio-ide-162.4069837-windows.exe" /S'
  ${Else}
    Abort "Android Studio 2.3.3.0 SHA256 didn't match [$0]"
  ${EndIf}

!endif
!if ${INSTALL_TYPE} == "Full"

  File "..\data\android-studio-ide-162.4069837-windows.exe"
  ExecWait '"$TEMP\android-studio-ide-162.4069837-windows.exe" /S'

!endif

  Delete "$TEMP\android-studio-ide-162.4069837-windows.exe"
  FileOpen $0 "$PROGRAMFILES64\Android\Android Studio\bin\idea.properties" a
  FileSeek $0 0 END
  FileWrite $0 "disable.android.first.run=true"
  FileClose $0
SectionEnd

