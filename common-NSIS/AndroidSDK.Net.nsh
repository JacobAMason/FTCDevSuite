Section "Android SDK" AndroidSDK
  AddSize 316400
  SetOutPath "$TEMP"
  File "..\data\get_sdk_packages.bat"
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android SDK 24.4.1" \
             "http://dl.google.com/android/installer_r24.4.1-windows.exe" \
             "$TEMP\installer_r24.4.1-windows.exe" /end
  Crypto::HashFile "SHA1" "$TEMP\installer_r24.4.1-windows.exe"
  Pop $0
  ${If} "F9B59D72413649D31E633207E31F456443E7EA0B" == $0
    DetailPrint "SHA1 hash for Android SDK 24.4.1 is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Android SDK 24.4.1"
    ExecWait '"$TEMP\installer_r24.4.1-windows.exe" /S'
  ${Else}
    Abort "Android SDK 24.4.1 SHA1 didn't match [$0]"
  ${EndIf} 
  Delete "$TEMP\installer_r24.4.1-windows.exe"

  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "ANDROID_HOME" "$LOCALAPPDATA\Android\android-sdk"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("ANDROID_HOME", "$LOCALAPPDATA\Android\android-sdk").r0'

  DetailPrint "Downloading SDK packages and APIs"
  nsExec::Exec "$TEMP\get_sdk_packages.bat"
SectionEnd

