Section "FIRST Tech Challenge App" FTCapp
  AddSize 71700
  SetOutPath "$INSTDIR"
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "FIRST Tech Challenge App - ftctechnh/ftc_app/beta" \
             "https://github.com/ftctechnh/ftc_app/archive/beta.zip" \
             "$INSTDIR\ftc_app.zip" /end
  ZipDLL::extractall "$INSTDIR\ftc_app.zip" "$INSTDIR" "<ALL>"
  Rename "$INSTDIR\ftc_app-beta" "$INSTDIR\ftc_app"
  Delete "$INSTDIR\ftc_app.zip"
SectionEnd

