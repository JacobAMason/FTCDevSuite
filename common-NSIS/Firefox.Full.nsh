Section "Firefox" Firefox
  SetOutPath $TEMP
  ${If} ${RunningX64}
    File "..\data\Firefox Setup 47.0 x64.exe"
    nsExec::Exec '"$TEMP\Firefox Setup 47.0 x64.exe" -ms'
    Delete "$TEMP\Firefox Setup 47.0 x64.exe"
  ${Else}
    File "..\data\Firefox Setup 47.0.exe"
    nsExec::Exec '"$TEMP\Firefox Setup 47.0.exe" -ms'
    Delete "$TEMP\Firefox Setup 47.0.exe"
  ${EndIf}
SectionEnd

