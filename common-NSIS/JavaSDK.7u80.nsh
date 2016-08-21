Section "Java 7 SDK" JavaSDK
  AddSize 144000
  SetOutPath "$TEMP"

!if ${INSTALL_TYPE} == "Net"

  ${If} ${RunningX64}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 7.80 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-x64.exe" \
               "$TEMP\jdk-7u80-windows-x64.exe" /end
    Crypto::HashFile "MD5" "$TEMP\jdk-7u80-windows-x64.exe"
    Pop $0
    ${If} "499B224F4DA70312DDD47C4824E83ADC" == $0
      DetailPrint "MD5 hash for Java 7 SDK is good"
    ${OrIf} "OK" == $0
      DetailPrint "Successfully downloaded Java 7 SDK"
      ExecWait '"$TEMP\jdk-7u80-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 7 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-7u80-windows-x64.exe"
    SetRegView 64
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES64\Java\jdk1.7.0_80"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES64\Java\jdk1.7.0_80").r0'
  ${Else}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 7.80 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe" \
               "$TEMP\jdk-7u80-windows-i586.exe" /end
    Crypto::HashFile "MD5" "$TEMP\jdk-7u80-windows-i586.exe"
    Pop $0
    ${If} "8C6C888993144FDBDEC6F5D4E19B57A3" == $0
      DetailPrint "MD5 hash for Java 7 SDK is good"
    ${OrIf} "OK" == $0
      DetailPrint "Successfully downloaded Java 7 SDK"
      ExecWait '"$TEMP\jdk-7u80-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 7 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-7u80-windows-i586.exe"
    SetRegView 32
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES32\Java\jdk1.7.0_80"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES32\Java\jdk1.7.0_80").r0'
  ${EndIf}

!endif
!if ${INSTALL_TYPE} == "Full"

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

!endif
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

!macro CheckJavaVersion
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
  ClearErrors
  ReadRegStr $JDK_VERSION HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
  ReadRegStr $JDK_HOME HKLM "SOFTWARE\JavaSoft\Java Development Kit\$JDK_VERSION" "JavaHome"
  ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$JDK_VERSION" "MicroVersion"
  StrCpy $1 "$JDK_VERSION.$1"

  ;; Can't use DetailPrint before the first Page. Helpful for debugging.
  ; IfErrors +3
  ;   MessageBox MB_OK "Found JDK $1 in $JDK_HOME"
  ;   Goto +2
  ;   MessageBox MB_OK "Couldn't find an installed JDK."

  ${VersionCompare} $JDK_VERSION "1.7" $0
  ${If} $0 == "2"
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_SELECTED}
    StrCpy $JAVA_INSTALL_DESC "Installs Java Development Kit 1.7.80"
  ${Else}
    !insertmacro ClearSectionFlag ${JavaSDK} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_RO}
    StrCpy $JAVA_INSTALL_DESC "You already have a JDK installed"

    ; Adds JAVA_HOME environment variable if it doesn't exist
    ReadEnvStr $0 "JAVA_HOME"
    ${If} $0 == ""
      WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$JDK_HOME"
      System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$JDK_HOME").r0'
    ${EndIf}
  ${EndIf}
!macroend

