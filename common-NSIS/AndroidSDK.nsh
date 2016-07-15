Section "Android SDK" AndroidSDK
  AddSize 316400

!if ${INSTALL_TYPE} == "Net"

  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android SDK 24.4.1" \
             "http://dl.google.com/android/android-sdk_r24.4.1-windows.zip" \
             "$TEMP\android-sdk_r24.4.1-windows.zip" /end
  Crypto::HashFile "SHA1" "$TEMP\android-sdk_r24.4.1-windows.zip"
  Pop $0
  ${If} "66B6A6433053C152B22BF8CAB19C0F3FEF4EBA49" == $0
    DetailPrint "SHA1 hash for Android SDK 24.4.1 is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Android SDK 24.4.1"
    DetailPrint "Installing Android SDK 24.4.1"
    ZipDLL::extractall "$TEMP\android-sdk_r24.4.1-windows.zip" "$SYSTEMDRIVE"
    Rename "$SYSTEMDRIVE\android-sdk-windows" "$SYSTEMDRIVE\android-sdk"
  ${Else}
    Abort "Android SDK 24.4.1 SHA1 didn't match [$0]"
  ${EndIf}
  Delete "$TEMP\android-sdk_r24.4.1-windows.zip"

!endif
!if ${INSTALL_TYPE} == "Full"
  SetOutPath "$SYSTEMDRIVE\android-sdk"
  File "..\data\android-sdk\AVD Manager.exe"
  File "..\data\android-sdk\SDK Manager.exe"
  File "..\data\android-sdk\SDK Readme.txt"
  File /r "..\data\android-sdk\tools"
!endif

  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "ANDROID_HOME" "$SYSTEMDRIVE\android-sdk"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("ANDROID_HOME", "$SYSTEMDRIVE\android-sdk").r0'

  SetOutPath $TEMP
  File "..\data\add_sdk_to_path.ps1"
  ${PowerShellExecFile} "$TEMP\add_sdk_to_path.ps1"

SectionEnd

Section "-Android SDK packages"
!if ${INSTALL_TYPE} == "Net"
  SetOutPath $TEMP
  File "..\data\get_sdk_packages.bat"
  DetailPrint "Downloading SDK packages and APIs"
  nsExec::Exec "$TEMP\get_sdk_packages.bat"
!endif
!if ${INSTALL_TYPE} == "Full"
  ReadEnvStr $2 "ANDROID_HOME"
  SetOutPath "$2\build-tools"
  File /r "..\data\android-sdk\build-tools\21.1.2"

  SetOutPath "$2\extras\google"
  File /r "..\data\android-sdk\extras\google\usb_driver"

  SetOutPath "$2\platforms"
  File /r "..\data\android-sdk\platforms\android-19"

  SetOutPath $2
  File /r "..\data\android-sdk\platform-tools"
!endif
SectionEnd


!macro CheckForAndroidSDK
  ReadEnvStr $0 "ANDROID_HOME"
  IfFileExists "$0\tools\android.bat" 0 CheckForAndroidSDK_done
    !insertmacro ClearSectionFlag ${AndroidSDK} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${AndroidSDK} ${SF_RO}
  CheckForAndroidSDK_done:
!macroend

