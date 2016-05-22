Section "Java 7 SDK" JavaSDK
  AddSize 144000
  SetOutPath "$TEMP"
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
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

