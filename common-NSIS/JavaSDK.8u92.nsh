Section "Java 8 SDK" JavaSDK
  SetOutPath "$TEMP"
  ${If} ${RunningX64}
    AddSize 193660
  ${Else}
    AddSize 188430
  ${EndIf}

!if ${INSTALL_TYPE} == "Net"

  ${If} ${RunningX64}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 1.8.92 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-windows-x64.exe" \
               "$TEMP\jdk-8u92-windows-x64.exe" /end
    Crypto::HashFile "MD5" "$TEMP\jdk-8u92-windows-x64.exe"
    Pop $0
    ${If} "D4FF7E90EADC8C08F3882535C7E63ECC" == $0
      DetailPrint "MD5 hash for Java 8 SDK is good"
    ${OrIf} "OK" == $0
      DetailPrint "Successfully downloaded Java 8 SDK"
      ExecWait '"$TEMP\jdk-8u92-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 8 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-8u92-windows-x64.exe"
    SetRegView 64
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES64\Java\jdk1.8.0_92"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES64\Java\jdk1.8.0_92").r0'
  ${Else}
    inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
               /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
               /caption "Java 1.8.92 SDK" \
               "http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-windows-i586.exe" \
               "$TEMP\jdk-8u92-windows-i586.exe" /end
    Crypto::HashFile "MD5" "$TEMP\jdk-8u92-windows-i586.exe"
    Pop $0
    ${If} "C1F56BD1308B6DE650BEE222EE182ADB" == $0
      DetailPrint "MD5 hash for Java 8 SDK is good"
    ${OrIf} "OK" == $0
      DetailPrint "Successfully downloaded Java 8 SDK"
      ExecWait '"$TEMP\jdk-8u92-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    ${Else}
      Abort "Java 8 SDK md5 didn't match [$0]"
    ${EndIf}
    Delete "$TEMP\jdk-8u92-windows-i586.exe"
    SetRegView 32
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES32\Java\jdk1.8.0_92"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES32\Java\jdk1.8.0_92").r0'
  ${EndIf}

!endif
!if ${INSTALL_TYPE} == "Full"

  ${If} ${RunningX64}
    File "..\data\jdk-8u92-windows-x64.exe"
    ExecWait '"$TEMP\jdk-8u92-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-8u92-windows-x64.exe"
    SetRegView 64
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES64\Java\jdk1.8.0_92"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES64\Java\jdk1.8.0_92").r0'
  ${Else}
    File "..\data\jdk-8u92-windows-i586.exe"
    ExecWait '"$TEMP\jdk-8u92-windows-i586.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
    Delete "$TEMP\jdk-8u92-windows-i586.exe"
    SetRegView 32
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES32\Java\jdk1.8.0_92"
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES32\Java\jdk1.8.0_92").r0'
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

  ${VersionCompare} $JDK_VERSION "1.8" $0
  ${If} $0 == "2"
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_SELECTED}
    StrCpy $JAVA_INSTALL_DESC "Installs Java Development Kit 1.8.92"
  ${Else}
    !insertmacro ClearSectionFlag ${JavaSDK} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_RO}
    StrCpy $JAVA_INSTALL_DESC "You already have a JDK installed"
  ${EndIf}
!macroend

