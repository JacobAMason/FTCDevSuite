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

