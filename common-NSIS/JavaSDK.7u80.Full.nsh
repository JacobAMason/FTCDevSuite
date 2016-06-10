Section "Java 7 SDK" JavaSDK
  AddSize 144000
  SetOutPath "$TEMP"
  ${If} ${RunningX64}
    File "..\data\jdk-7u80-windows-x64.exe"
    ExecWait '"$TEMP\jdk-7u80-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-7u80-windows-x64.exe"
    SetRegView 64
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES64\Java\jdk1.7.0_80"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES64\Java\jdk1.7.0_80").r0'
  ${Else}
    File "..\data\jdk-7u80-windows-i586.exe"
    ExecWait '"$TEMP\jdk-7u80-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-7u80-windows-i586.exe"
    SetRegView 32
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES32\Java\jdk1.7.0_80"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES32\Java\jdk1.7.0_80").r0'
  ${EndIf}
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

