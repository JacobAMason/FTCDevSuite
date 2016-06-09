!define PRODUCT_NAME "FIRST App Inventor Development Suite"
!include "x64.nsh"
!include "WordFunc.nsh"
!include "Sections.nsh"
!include "psExec.nsh"
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
Caption "App Inventor Dev Suite ${PRODUCT_VERSION}"

;The file to write
OutFile "FIRSTAppInventor.${INSTALL_TYPE}.${PRODUCT_VERSION}.exe"

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

!define MUI_ICON "..\img\FIRST_logo.ico"
!define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "..\img\FIRST_Header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\img\FIRST_Wizard.bmp"
!define MUI_ABORTWARNING

;--------------------------------
;Pages

!define MUI_WELCOMEPAGE_TITLE "Welcome to the FIRST Tech Challenge App Inventor Development Suite Setup Wizard"
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of all the tools necessary to program your FIRST Tech Challenge Android Robot Controller with MIT App Inventor.$\r$\n$\r$\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_PAGE_LICENSE "..\data\LICENSE"

!define MUI_PAGE_HEADER_SUBTEXT "Please wait while the FIRST Tech Challenge App Inventor Development Suite is being installed."
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "${PRODUCT_NAME} Installation Complete"
!define MUI_FINISHPAGE_TEXT "The components you have selected have been installed on your computer.$\r$\n$\r$\nClick Finish to close this installer."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Launch App Inventor"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchAppInventor"
!define MUI_FINISHPAGE_LINK "Visit me online"
!define MUI_FINISHPAGE_LINK_LOCATION http://www.jacobmason.net/
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

!include JavaSDK.7u80.${INSTALL_TYPE}.nsh
!include Firefox.${INSTALL_TYPE}.nsh
!include AndroidSDK.${INSTALL_TYPE}.nsh
!include Ant.${INSTALL_TYPE}.nsh
!include AppEngine.${INSTALL_TYPE}.nsh
!include Python2.${INSTALL_TYPE}.nsh
!include PhantomJS.${INSTALL_TYPE}.nsh
!include Git.${INSTALL_TYPE}.nsh
!include AppInventor.${INSTALL_TYPE}.nsh

;--------------------------------
;Initialize

Function .onInit
  ; Check Java Version
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
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_SELECTED}
    StrCpy $JAVA_INSTALL_DESC "Installs Java Development Kit 1.7.80"
  ${Else}    
    !insertmacro ClearSectionFlag ${JavaSDK} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${JavaSDK} ${SF_RO}
    StrCpy $JAVA_INSTALL_DESC "You already have a JDK installed"
  ${EndIf}

  ; Check for Chrome and Firefox. If Chrome exists, deselect Firefox. If Firefox exists, disable it in the installer.
  ClearErrors
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" "Path"
  ${If} $0 != ""
    MessageBox MB_OK "Found Chrome: $0"
    !insertmacro ClearSectionFlag ${Firefox} ${SF_SELECTED}
  ${EndIf}

  ClearErrors
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe" "Path"
  ${If} $0 != ""
    MessageBox MB_OK "Found Firefox: $0"
    !insertmacro ClearSectionFlag ${Firefox} ${SF_SELECTED}
    !insertmacro SetSectionFlag ${Firefox} ${SF_RO}
  ${EndIf}
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
;Launch App Inventor
Function LaunchAppInventor
  ${If} ${RunningX64}
    Exec "$PROGRAMFILES64\Android\Android Studio\bin\studio64.exe"
  ${Else}
    Exec "$PROGRAMFILES\Android\Android Studio\bin\studio.exe"
  ${EndIf}
FunctionEnd

;--------------------------------
;Descriptions

;Language strings
LangString DESC_JavaSDK ${LANG_ENGLISH} $JAVA_INSTALL_DESC
LangString DESC_Firefox ${LANG_ENGLISH} "Installs Firefox 47.0"
LangString DESC_AndroidSDK ${LANG_ENGLISH} "Installs the proper SDK and API tools. You probably need this."
LangString DESC_Ant ${LANG_ENGLISH} "Installs Ant"
LangString DESC_AppEngine ${LANG_ENGLISH} "Installs Google App Engine for Java 1.9.27"
LangString DESC_Python2 ${LANG_ENGLISH} "Installs Python 2.7.11"
LangString DESC_PhantomJS ${LANG_ENGLISH} "Installs PhantomJS 2.1.1"
LangString DESC_Git ${LANG_ENGLISH} "Installs Git 2.8.3"
LangString DESC_AppInventor ${LANG_ENGLISH} "Installs MIT App Inventor"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${JavaSDK} $(DESC_JavaSDK)
  !insertmacro MUI_DESCRIPTION_TEXT ${Firefox} $(DESC_Firefox)
  !insertmacro MUI_DESCRIPTION_TEXT ${AndroidSDK} $(DESC_AndroidSDK)
  !insertmacro MUI_DESCRIPTION_TEXT ${Ant} $(DESC_Ant)
  !insertmacro MUI_DESCRIPTION_TEXT ${AppEngine} $(DESC_AppEngine)
  !insertmacro MUI_DESCRIPTION_TEXT ${Python2} $(DESC_Python2)
  !insertmacro MUI_DESCRIPTION_TEXT ${PhantomJS} $(DESC_PhantomJS)
  !insertmacro MUI_DESCRIPTION_TEXT ${Git} $(DESC_Git)
  !insertmacro MUI_DESCRIPTION_TEXT ${AppInventor} $(DESC_AppInventor)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

