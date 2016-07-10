Section "Python 2.7.11" Python2
  AddSize 144000
  SetOutPath $TEMP
  ${If} ${RunningX64}
    File "..\data\python-2.7.11.amd64.msi"
    ExecWait 'msiexec /i "$TEMP\python-2.7.11.amd64.msi" /qn ALLUSERS=1 ADDLOCAL=ALL'
    Delete "$TEMP\python-2.7.11.amd64.msi"
  ${Else}
    File "..\data\python-2.7.11.msi"
    ExecWait 'msiexec /i "$TEMP\python-2.7.11.msi" /qn ALLUSERS=1 ADDLOCAL=ALL'
    Delete "$TEMP\python-2.7.11.msi"
  ${EndIf}
  ReadEnvStr $0 "SYSTEMDRIVE"
  StrCpy $PYTHON_PATH "$0\Python27"
SectionEnd

!macro CheckForPython
  ClearErrors
  ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
  ReadRegStr $1 HKCU "Software\Python\PythonCore\2.7\InstallPath" ""
  ${If} $0 != ""
    StrCpy $PYTHON_PATH $0
  ${EndIf}
  ${If} $1 != ""
    StrCpy $PYTHON_PATH $1
  ${EndIf}
  ${If} $PYTHON_PATH != ""
    !insertmacro ClearSectionFlag ${Python2} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${Python2} ${SF_RO}
  ${EndIf}
!macroend

