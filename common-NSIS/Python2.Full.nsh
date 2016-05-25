Section "Python 2.7.11" Python2
  AddSize 144000
  SetOutPath $TEMP
  ${If} ${RunningX64}
    File "..\data\python-2.7.11.amd64.exe"
    ExecWait 'msiexec /i "$TEMP\python-2.7.11.amd64.exe" /qn ALLUSERS=1 ADDLOCAL=ALL'
    Delete "$TEMP\python-2.7.11.amd64.exe"
  ${Else}
    File "..\data\python-2.7.11.exe"
    ExecWait 'msiexec /i "$TEMP\python-2.7.11.exe" /qn ALLUSERS=1 ADDLOCAL=ALL'
    Delete "$TEMP\python-2.7.11.exe"
  ${EndIf}
SectionEnd

