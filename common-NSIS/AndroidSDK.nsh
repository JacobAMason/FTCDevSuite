Section "Android SDK" AndroidSDK
  AddSize 316400

!if ${INSTALL_TYPE} == "Net"

  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android SDK" \
             "https://dl.google.com/android/repository/sdk-tools-windows-3859397.zip" \
             "$TEMP\sdk-tools-windows-3859397.zip" /end
  Crypto::HashFile "SHA2-512" "$TEMP\sdk-tools-windows-3859397.zip"
  Pop $0
  ${If} "5FB73A994DD7B125C963EC8E193538C2B0C59432E991112F62EBD7308BB0E79B873AB7EC653F15255401BB5500C11AD2E6C6894BF546FCC443122B527409DA24" == $0
    DetailPrint "SHA512 hash for Android SDK is good"
  ${OrIf} "OK" == $0
    DetailPrint "Successfully downloaded Android SDK"
    DetailPrint "Installing Android SDK"
    ZipDLL::extractall "$TEMP\sdk-tools-windows-3859397.zip" "$SYSTEMDRIVE\android-sdk\"
    Rename "$SYSTEMDRIVE\sdk-tools-windows-3859397" "$SYSTEMDRIVE\android-sdk\tools"
  ${Else}
    Abort "Android SDK SHA512 didn't match [$0]"
  ${EndIf}
  Delete "$TEMP\sdk-tools-windows-3859397.zip"

!endif
!if ${INSTALL_TYPE} == "Full"
  SetOutPath "$SYSTEMDRIVE\android-sdk"
  File /r "..\data\android-sdk\tools"
!endif

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
  File /r "..\data\android-sdk\build-tools\23.0.3"

  SetOutPath "$2\extras\google"
  File /r "..\data\android-sdk\extras\google\usb_driver"

  SetOutPath "$2\platforms"
  File /r "..\data\android-sdk\platforms\android-19"

  SetOutPath "$2\platforms"
  File /r "..\data\android-sdk\platforms\android-23"

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

