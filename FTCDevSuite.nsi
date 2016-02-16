!define PRODUCT_NAME "FTC Android Development Suite"
!include "x64.nsh"
!include "WordFunc.nsh"
!ifndef INSTALLER_TYPE
  Abort "You must define the INSTALLER_TYPE as either Full or Net"
!endif

!if ${INSTALLER_TYPE} != "Full"
!if ${INSTALLER_TYPE} != "Net"
  !error "You must define the INSTALLER_TYPE as either Full or Net"
!endif
!endif

!include "${INSTALLER_TYPE}.nsh"

SetCompressor /FINAL /SOLID lzma

;--------------------------------
Name "${PRODUCT_NAME}"
Caption "FTC Dev Suite ${PRODUCT_VERSION}"

;The file to write
OutFile "FTCDevSuite.${INSTALLER_TYPE}.${PRODUCT_VERSION}.exe"

;The default installation directory
InstallDir $DESKTOP\JacobInstaller
;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\FTC Android Development Suite" ""
RequestExecutionLevel user
ShowInstDetails show
ShowUninstDetails show
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION} ${INSTALLER_TYPE} Installer - Jacob Mason"

;--------------------------------
;Variables

Var START_MENU_FOLDER
Var JDK_VERSION
Var JDK_HOME
Var JAVA_INSTALL_DESC

;--------------------------------
;Interface Settings

!include "MUI2.nsh"

!define MUI_WELCOMEFINISHPAGE_BITMAP "img\FIRST_Wizard.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "img\FIRST_Wizard.bmp"
!define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "img\FIRST_Header.bmp"

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING

;--------------------------------
;Pages

!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${PRODUCT_NAME} Setup Wizard"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "data\LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\FTC Android Development Suite"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !insertmacro MUI_PAGE_STARTMENU Application $START_MENU_FOLDER

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "${PRODUCT_NAME} Installation Complete"
!define MUI_FINISHPAGE_LINK "Visit me online"
!define MUI_FINISHPAGE_LINK_LOCATION http://www.jacobmason.net/
!insertmacro MUI_PAGE_FINISH

!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${PRODUCT_NAME} Uninstall Wizard"
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "${PRODUCT_NAME} Uninstalled"
!define MUI_FINISHPAGE_LINK "Visit me online"
!define MUI_FINISHPAGE_LINK_LOCATION http://www.jacobmason.net/
!insertmacro MUI_UNPAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "-Setup Output Path"
   SetOutPath "$INSTDIR"
   WriteRegStr HKCU "Software\FTC Android Development Suite" "" $INSTDIR
SectionEnd



Section "Test Text" testText
  File data\test.txt
SectionEnd


!insertmacro "FTC.sections"


Section "-Write Uninstaller and Shortcuts"
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;Creat shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory "$SMPROGRAMS\$START_MENU_FOLDER"
    CreateShortCut "$SMPROGRAMS\$START_MENU_FOLDER\Uninstall.lnk" \
                   "$INSTDIR\Uninstall.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  Delete "$INSTDIR\test.txt"

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

  !insertmacro MUI_STARTMENU_GETFOLDER Application $START_MENU_FOLDER
  Delete "$SMPROGRAMS\$START_MENU_FOLDER\Uninstall.lnk"
  RMDir "$SMPROGRAMS\$START_MENU_FOLDER"

  DeleteRegKey /ifempty HKCU "Software\FTC Android Development Suite"

SectionEnd

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
   
  IfErrors +3
    MessageBox MB_OK "Found JDK $1 in $JDK_HOME"
    Goto +2
    MessageBox MB_OK "Couldn't find an installed JDK."

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
LangString DESC_AndroidStudio ${LANG_ENGLISH} "Install Android Studio if you haven't already"
LangString DESC_JavaSDK ${LANG_ENGLISH} $JAVA_INSTALL_DESC

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${AndroidStudio} $(DESC_AndroidStudio)
  !insertmacro MUI_DESCRIPTION_TEXT ${JavaSDK} $(DESC_JavaSDK)
!insertmacro MUI_FUNCTION_DESCRIPTION_END