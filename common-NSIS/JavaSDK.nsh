Section "Java 8 SDK" JavaSDK
  SetOutPath "$TEMP"
  AddSize 202784

!if ${INSTALL_TYPE} == "Net"

  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
             /caption "Java 1.8.131 SDK" \
             "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-windows-x64.exe" \
             "$TEMP\jdk-8u131-windows-x64.exe" /end
  Crypto::HashFile "SHA2-512" "$TEMP\jdk-8u131-windows-x64.exe"
  Pop $0
  ${If} "5CF787E35107526B1C951E2CA37306299810E02AA5EA178728E93AA740C6D9657711B508049AD17208D082AF595D311FFB1B1882876E8944BFD625613A02FC68" == $0
    DetailPrint "SHA512 hash for Java 8 SDK is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Java 8 SDK"
  ${Else}
    Abort "Java 8 SDK SHA512 didn't match [$0]"
  ${EndIf}

!endif
!if ${INSTALL_TYPE} == "Full"

  File "..\data\jdk-8u131-windows-x64.exe"

!endif

  ExecWait '"$TEMP\jdk-8u131-windows-x64.exe" /s ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"'
  Delete "$TEMP\jdk-8u131-windows-x64.exe"
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "JAVA_HOME" "$PROGRAMFILES64\Java\jdk1.8.0_131"
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("JAVA_HOME", "$PROGRAMFILES64\Java\jdk1.8.0_131").r0'
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

!macro CheckJavaVersion
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
    StrCpy $JAVA_INSTALL_DESC "Installs Java Development Kit 1.8.131"
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
