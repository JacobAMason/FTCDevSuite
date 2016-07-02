Section "Firefox" Firefox
  SetOutPath $TEMP
  ${If} ${RunningX64}
    AddSize 46124
    File "..\data\Firefox Setup 47.0 x64.exe"
    nsExec::Exec '"$TEMP\Firefox Setup 47.0 x64.exe" -ms'
    Delete "$TEMP\Firefox Setup 47.0 x64.exe"
  ${Else}
    AddSize 43980
    File "..\data\Firefox Setup 47.0.exe"
    nsExec::Exec '"$TEMP\Firefox Setup 47.0.exe" -ms'
    Delete "$TEMP\Firefox Setup 47.0.exe"
  ${EndIf}
SectionEnd

