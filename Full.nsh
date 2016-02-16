!macro FTC.sections
Section "Java 7 SDK" JavaSDK
  File "data\jdk-7u80-windows-i586.exe"
  ExecWait '"$INSTDIR\jdk-7u80-windows-i586.exe" /S ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
SectionEnd



Section "Android Studio" AndroidStudio
  File "data\android-studio-ide-141.2456560-windows.exe"
  ExecWait '"$INSTDIR\android-studio-ide-141.2456560-windows.exe" /S'
SectionEnd
!macroend
