Section "Ant" Ant
  AddSize 39785
  ReadEnvStr $2 "SYSTEMDRIVE"
  SetOutPath "$2\Ant"
  File /r "..\data\apache-ant-1.9.7"
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "ANT_HOME" "$2\Ant\apache-ant-1.9.7"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("ANT_HOME", "$2\Ant\apache-ant-1.9.7").r0'
SectionEnd

