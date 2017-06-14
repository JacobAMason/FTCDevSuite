!define PRODUCT_NAME "FIRST Android Studio Development Suite"
!include "x64.nsh"
!include "WordFunc.nsh"
!include "Sections.nsh"
!include "psExec.nsh"
!include "zipdll.nsh"
!ifndef INSTALL_TYPE
  !error "You must define the INSTALL_TYPE as either Full or Net"
!endif

!if ${INSTALL_TYPE} != "Full"
!if ${INSTALL_TYPE} != "Net"
  !error "You must define the INSTALL_TYPE as either Full or Net"
!endif
!endif

!addincludedir ..\common-NSIS

SetCompressor /FINAL /SOLID lzma

;--------------------------------
Name "${PRODUCT_NAME}"
Caption "Android Studio Dev Suite ${PRODUCT_VERSION}"

;The file to write
OutFile "FIRSTAndroidStudio.${INSTALL_TYPE}.${PRODUCT_VERSION}.exe"

;The default installation directory
InstallDir $DOCUMENTS
;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\FIRST Android Development Suite" ""
RequestExecutionLevel admin
ShowInstDetails show
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION} ${INSTALL_TYPE} Installer - Jacob Mason"

;--------------------------------
;Variables

Var SYSTEMDRIVE
Var JDK_VERSION
Var JDK_HOME
Var JAVA_INSTALL_DESC

;--------------------------------
;Interface Settings

!include "MUI2.nsh"

!define MUI_ICON "..\img\FIRST_logo.ico"
!define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "..\img\FIRST_Header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\img\FIRST_Wizard.bmp"
!define MUI_ABORTWARNING

;--------------------------------
;Pages

!define MUI_WELCOMEPAGE_TITLE "Welcome to the FIRST Tech Challenge Android Studio Development Suite Setup Wizard"
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of all the tools necessary to program your FIRST Tech Challenge Android Robot Controller with Android Studio.$\r$\n$\r$\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_PAGE_LICENSE "..\data\LICENSE"

!define MUI_PAGE_HEADER_TEXT "Choose FIRST Tech Challenge App Location"
!define MUI_PAGE_HEADER_SUBTEXT "Choose the folder in which to place the FIRST Tech Challenge Robot Controller App"
!define MUI_DIRECTORYPAGE_TEXT_TOP "If you chose to include the FIRST Tech Challenge Robot Controller App, this is the folder in which the App will be installed. This installer will create a folder called 'ftc_app' in the location selected below and place the source code inside."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Choose the folder in which to place the FIRST Tech Challange App"
!insertmacro MUI_PAGE_DIRECTORY

!define MUI_PAGE_HEADER_SUBTEXT "Please wait while the FIRST Tech Challenge Android Studio Development Suite is being installed."
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "${PRODUCT_NAME} Installation Complete"
!define MUI_FINISHPAGE_TEXT "The components you have selected have been installed on your computer.$\r$\n$\r$\nClick Finish to close this installer."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Launch Android Studio"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchAndroidStudio"
!define MUI_FINISHPAGE_LINK "Visit me online"
!define MUI_FINISHPAGE_LINK_LOCATION http://www.jacobmason.net/
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

!include JavaSDK.nsh
!include AndroidStudio.2.nsh
!include AndroidSDK.nsh
!include FTCapp.${INSTALL_TYPE}.nsh
!if ${INSTALL_TYPE} == "Full"
  !include Gradle.nsh
!endif

;--------------------------------
;Initialize

Function .onInit
  SetRegView 64
  ReadEnvStr $SYSTEMDRIVE "SYSTEMDRIVE"

  !insertmacro CheckJavaVersion
  !insertmacro CheckForAndroidSDK
FunctionEnd

;--------------------------------
;Section Dependency Management
Function .onSelChange
  ${If} ${SectionIsSelected} ${AndroidSDK}
  ${AndIf} ${INSTALL_TYPE} == "Net"
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_RO}
  ${EndIf}

  ${IfNot} ${SectionIsSelected} ${AndroidSDK}
  ${AndIf} ${INSTALL_TYPE} == "Net"
    !insertmacro ClearSectionFlag ${JavaSDK} ${SF_RO}
  ${EndIf}
FunctionEnd

;--------------------------------
;Launch Android Studio
Function LaunchAndroidStudio
  Exec "$PROGRAMFILES64\Android\Android Studio\bin\studio64.exe"
FunctionEnd

;--------------------------------
;Descriptions

;Language strings
LangString DESC_JavaSDK ${LANG_ENGLISH} $JAVA_INSTALL_DESC
LangString DESC_AndroidStudio ${LANG_ENGLISH} "Installs Android Studio 2.3.3"
LangString DESC_AndroidSDK ${LANG_ENGLISH} "Installs the proper SDK and API tools. You probably need this."
!if ${INSTALL_TYPE} == "Full"
  LangString DESC_FTCapp ${LANG_ENGLISH} "Installs a copy of the FIRST Tech Challenge App"
!endif
!if ${INSTALL_TYPE} == "Net"
  LangString DESC_FTCapp ${LANG_ENGLISH} "Downloads the latest stable FIRST Tech Challenge App from GitHub"
!endif

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${JavaSDK} $(DESC_JavaSDK)
  !insertmacro MUI_DESCRIPTION_TEXT ${AndroidStudio} $(DESC_AndroidStudio)
  !insertmacro MUI_DESCRIPTION_TEXT ${AndroidSDK} $(DESC_AndroidSDK)
  !insertmacro MUI_DESCRIPTION_TEXT ${FTCapp} $(DESC_FTCapp)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

