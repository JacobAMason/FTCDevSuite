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
SectionEnd

