Section "Android Studio" AndroidStudio
  AddSize 1700000
  SetOutPath "$TEMP"
  File "..\data\android-studio-ide-141.2456560-windows.exe"
  ExecWait '"$TEMP\android-studio-ide-141.2456560-windows.exe" /S'
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

