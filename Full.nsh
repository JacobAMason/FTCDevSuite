!macro FTC.sections
Section "Java 7 SDK" JavaSDK
  AddSize 144000
  SetOutPath "$TEMP"
  ${If} ${RunningX64}
    File "data\jdk-7u80-windows-x64.exe"
    ExecWait '"$TEMP\jdk-7u80-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-7u80-windows-x64.exe"
    SetRegView 64
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES64\Java\jdk1.7.0_80"
  ${Else}
    File "data\jdk-7u80-windows-i586.exe"
    ExecWait '"$TEMP\jdk-7u80-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-7u80-windows-i586.exe"
    SetRegView 32
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES32\Java\jdk1.7.0_80"
  ${EndIf}
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd



Section "Android Studio" AndroidStudio
  AddSize 1700000
  SetOutPath "$TEMP"
  File "data\android-studio-ide-141.2456560-windows.exe"
  ExecWait '"$TEMP\android-studio-ide-141.2456560-windows.exe" /S'
  Delete "$TEMP\android-studio-ide-141.2456560-windows.exe"
SectionEnd



Section "Android SDK" AndroidSDK
  AddSize 316400
  SetOutPath "$LOCALAPPDATA\Android"
  File /r "data\android-sdk"
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "ANDROID_HOME" "$LOCALAPPDATA\Android\android-sdk"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd



Section "FTC App" FTCapp
  AddSize 71700
  SetOutPath "$INSTDIR"
  File /r "data\ftc_app"
SectionEnd
!macroend
