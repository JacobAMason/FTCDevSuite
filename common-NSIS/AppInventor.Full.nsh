Section "MIT App Inventor" AppInventor
  AddSize 342049
  SetOutPath $PROFILE
  File /r "..\data\appinventor-sources"

  SetOutPath "$PROFILE\appinventor-sources"
  File "..\data\run_App_Inventor.py"

  ReadEnvStr $R0 "PATH"
  StrCpy $R0 "$R0;$PROGRAMFILES\Git\cmd"
  System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("PATH", R0).r0'
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
  nsExec::Exec '"C:\Python27\python.exe" "$PROFILE\appinventor-sources\run_App_Inventor.py" --build'
SectionEnd

