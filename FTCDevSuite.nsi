!define PRODUCT_NAME "FTC Android Development Suite"
!define PRODUCT_VERSION "1.0.0"

!addplugindir "plugins"

;--------------------------------
Name "${PRODUCT_NAME}"
Caption "FTC Dev Suite ${PRODUCT_VERSION}"

;The file to write
OutFile "FTCDevSuite.${PRODUCT_VERSION}.exe"

;The default installation directory
InstallDir $DESKTOP\JacobInstaller
;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\FTC Android Development Suite" ""
RequestExecutionLevel user
ShowInstDetails show
ShowUninstDetails show
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION} - Jacob Mason"

;--------------------------------
;Variables

Var StartMenuFolder

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
!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\FTC Android Development Suite"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder

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
  
;--------------------------------
;Languages
 
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Android Studio" AndroidStudio
  SetOutPath "$INSTDIR"

  File data\test.txt

  ;Store installation folder 
  WriteRegStr HKCU "Software\FTC Android Development Suite" "" $INSTDIR

SectionEnd

Section "-Get Java Version"
  ClearErrors
  ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
  ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$1" "JavaHome"
  ReadRegStr $3 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$1" "MicroVersion"
  StrCpy $1 "$1.$3"
   
  IfErrors +3
    DetailPrint "Found JDK in path $1"
    Goto +2
    DetailPrint "Couldn't find an installed JDK."     
SectionEnd

Section "Robots"
  ;"21ba308a05a1fdd485ae8e266a792adf"
  inetc::get /caption "Robots" \
                    "http://google.com/robots.txt" \
                    "$INSTDIR\robots.txt" /end
  md5dll::GetMD5File "$INSTDIR\robots.txt"
  Pop $0
  StrCmp "21ba308a05a1fdd485ae8e266a792adf" $0 +3
    MessageBox MB_OK "Download md5 didn't match"
  Goto +2
    DetailPrint "Downloaded robots.txt"
SectionEnd

Section /o "Java 7 SDK"
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
             /caption "Java 7.80 SDK" \
             "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe" \
             "$INSTDIR\jdk-7u80-windows-i586.exe" /end
  Pop $0
  MessageBox MB_OK "Install status: $0" 

  md5dll::GetMD5File "$INSTDIR\jdk-7u80-windows-i586.exe"
  Pop $0
  StrCmp "8c6c888993144fdbdec6f5d4e19b57a3" $0 +3
    MessageBox MB_OK "Download md5 didn't match"
  Goto +2
    DetailPrint "Downloaded Java 7 SDK"
SectionEnd

Section "-Write Uninstaller"
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;Creat shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" \
                   "$INSTDIR\Uninstall.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

;--------------------------------
;Descriptions

;Language strings
LangString DESC_AndroidStudio ${LANG_ENGLISH} "Install Android Studio if you haven't already"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${AndroidStudio} $(DESC_AndroidStudio)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  Delete "$INSTDIR\test.txt"

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"

  DeleteRegKey /ifempty HKCU "Software\FTC Android Development Suite"

SectionEnd
