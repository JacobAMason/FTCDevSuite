!define PRODUCT_NAME "FTC Android Development Suite"
!include "x64.nsh"
!include "WordFunc.nsh"
!ifndef INSTALL_TYPE
  !error "You must define the INSTALL_TYPE as either Full or Net"
!endif

!if ${INSTALL_TYPE} != "Full"
!if ${INSTALL_TYPE} != "Net"
  !error "You must define the INSTALL_TYPE as either Full or Net"
!endif
!endif

!include "${INSTALL_TYPE}.nsh"

SetCompressor /FINAL /SOLID lzma

;--------------------------------
Name "${PRODUCT_NAME}"
Caption "FTC Development Suite ${PRODUCT_VERSION}"

;The file to write
OutFile "FTCDevSuite.${INSTALL_TYPE}.${PRODUCT_VERSION}.exe"

;The default installation directory
InstallDir $DOCUMENTS
;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\FTC Android Development Suite" ""
RequestExecutionLevel admin
ShowInstDetails show
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION} ${INSTALL_TYPE} Installer - Jacob Mason"

;--------------------------------
;Variables

Var JDK_VERSION
Var JDK_HOME
Var JAVA_INSTALL_DESC

;--------------------------------
;Interface Settings

!include "MUI2.nsh"

!define MUI_ICON "img\FIRST_logo.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "img\FIRST_Wizard.bmp"
!define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "img\FIRST_Header.bmp"

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING

;--------------------------------
;Pages

!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${PRODUCT_NAME} Setup Wizard"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "data\LICENSE"
!insertmacro MUI_PAGE_COMPONENTS

!define MUI_DIRECTORYPAGE_TEXT_TOP "Choose the folder in which to install the FTC App"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "If you chose to install the FTC App, this is the folder in which the App will be installed. Do NOT create a new folder to store the App in. The App will create a folder called 'ftc_app' in which the application will be installed."
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "${PRODUCT_NAME} Installation Complete"
!define MUI_FINISHPAGE_LINK "Visit me online"
!define MUI_FINISHPAGE_LINK_LOCATION http://www.jacobmason.net/
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections


!insertmacro "FTC.sections"


;--------------------------------
;Initialize

; Check Java Version
Function .onInit
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf} 
  ClearErrors
  ReadRegStr $JDK_VERSION HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
  ReadRegStr $JDK_HOME HKLM "SOFTWARE\JavaSoft\Java Development Kit\$JDK_VERSION" "JavaHome"
  ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$JDK_VERSION" "MicroVersion"
  StrCpy $1 "$JDK_VERSION.$1"
   
  ;; Can't use DetailPrint before the first Page. Helpful for debugging.
  ; IfErrors +3
  ;   MessageBox MB_OK "Found JDK $1 in $JDK_HOME"
  ;   Goto +2
  ;   MessageBox MB_OK "Couldn't find an installed JDK."

  ${VersionCompare} $JDK_VERSION "1.7" $0
  ${If} $0 == "2"
    SectionSetFlags ${JavaSDK} ${SF_SELECTED}
    StrCpy $JAVA_INSTALL_DESC "Installs Java Development Kit 1.7.80"
  ${Else}    
    SectionSetFlags ${JavaSDK} ${SF_RO}
    StrCpy $JAVA_INSTALL_DESC "You already have a JDK installed"
  ${EndIf}

FunctionEnd

;--------------------------------
;Descriptions

;Language strings
LangString DESC_JavaSDK ${LANG_ENGLISH} $JAVA_INSTALL_DESC
LangString DESC_AndroidStudio ${LANG_ENGLISH} "Installs Android Studio 1.5.1"
LangString DESC_AndroidSDK ${LANG_ENGLISH} "Installs the proper SDK and API tools. You probably need this."
!if ${INSTALL_TYPE} == "Full"
  LangString DESC_FTCapp ${LANG_ENGLISH} "Installs a copy of the FTC App"
!endif
!if ${INSTALL_TYPE} == "Net"
  LangString DESC_FTCapp ${LANG_ENGLISH} "Downloads the latest stable FTC App from GitHub"
!endif

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${JavaSDK} $(DESC_JavaSDK)
  !insertmacro MUI_DESCRIPTION_TEXT ${AndroidStudio} $(DESC_AndroidStudio)
  !insertmacro MUI_DESCRIPTION_TEXT ${AndroidSDK} $(DESC_AndroidSDK)
  !insertmacro MUI_DESCRIPTION_TEXT ${FTCapp} $(DESC_FTCapp)
!insertmacro MUI_FUNCTION_DESCRIPTION_END