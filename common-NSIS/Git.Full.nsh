Section "Git" Git
  AddSize 30564
  SetOutPath $TEMP
  ${If} ${RunningX64}
    File "..\data\Git-2.8.3-64-bit.exe"
    ExecWait '"$TEMP\Git-2.8.3-64-bit.exe" /verysilent'
  ${Else}
    File "..\data\Git-2.8.3-32-bit.exe"
    ExecWait '"$TEMP\Git-2.8.3-32-bit.exe" /verysilent'
  ${EndIf}
SectionEnd

!macro CheckForGit
  ReadEnvStr $0 "SYSTEMDRIVE"
  ClearErrors
  IfFileExists "$0\Program Files\Git\bin\git.exe" 0 notFound
    MessageBox MB_OK "Found Git"
    !insertmacro ClearSectionFlag ${Git} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${Git} ${SF_RO}
  GOTO done
  notFound:
    MessageBox MB_OK "Didn't Find Git"
  done:
!macroend
