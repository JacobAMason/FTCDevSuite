!macro FTC.sections
Section "Java 7 SDK" JavaSDK
  SetOutPath "$TEMP"
  ${If} ${RunningX64}
    File "data\jdk-7u80-windows-x64.exe"
    ExecWait '"$TEMP\jdk-7u80-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-7u80-windows-x64.exe"
  ${Else}
    File "data\jdk-7u80-windows-i586.exe"
    ExecWait '"$TEMP\jdk-7u80-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-7u80-windows-i586.exe"
  ${EndIf}
SectionEnd



Section "Android Studio" AndroidStudio
  SetOutPath "$TEMP"
  File "data\android-studio-ide-141.2456560-windows.exe"
  ExecWait '"$TEMP\android-studio-ide-141.2456560-windows.exe" /S'
  Delete "$TEMP\android-studio-ide-141.2456560-windows.exe"
SectionEnd



Section "Android SDK" AndroidSDK
  SetOutPath "$LOCALAPPDATA"
  File /r "data\android-sdk"
SectionEnd
!macroend
