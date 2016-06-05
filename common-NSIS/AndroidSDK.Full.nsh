Section "Android SDK" AndroidSDK
  AddSize 316400
  SetOutPath "$PROGRAMFILES\Android"
  File /r "..\data\android-sdk"
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "ANDROID_HOME" "$PROGRAMFILES\Android\android-sdk"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("ANDROID_HOME", "$PROGRAMFILES\Android\android-sdk").r0'

  SetOutPath $TEMP
  File "..\data\add_sdk_to_path.ps1"
  ${PowerShellExecFile} "$TEMP\add_sdk_to_path.ps1"
SectionEnd

