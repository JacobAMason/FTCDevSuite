Section "Google Chrome" Chrome
  SetOutPath $TEMP
  ${If} ${RunningX64}
    File "..\data\ChromeStandaloneSetup64.exe"
    ExecWait '"$TEMP\ChromeStandaloneSetup64.exe" /silent /install'
    Delete "$TEMP\ChromeStandaloneSetup64.exe"
  ${Else}
    File "..\data\ChromeStandaloneSetup.exe"
    ExecWait '"$TEMP\ChromeStandaloneSetup.exe" /silent /install'
    Delete "$TEMP\ChromeStandaloneSetup.exe"
  ${EndIf}
SectionEnd

