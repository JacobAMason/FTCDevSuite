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
  ClearErrors
  IfFileExists "$SYSTEMDRIVE\Program Files\Git\bin\git.exe" 0 CheckForGit_done
    !insertmacro ClearSectionFlag ${Git} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${Git} ${SF_RO}
  CheckForGit_done:
!macroend
