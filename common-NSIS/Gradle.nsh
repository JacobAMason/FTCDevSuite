Section "-Gradle" Gradle
  AddSize 28672
  SetOutPath "$SYSTEMDRIVE\GradleCache"
  File /r "..\data\gradle\*"
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "GRADLE_USER_HOME" "$SYSTEMDRIVE\GradleCache"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("GRADLE_USER_HOME", "$SYSTEMDRIVE\GradleCache").r0'
SectionEnd

