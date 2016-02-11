!define PRODUCT_NAME "FTC Android Development Suite"
!define PRODUCT_VERSION "1.0.0"

!include x64.nsh
!include "WordFunc.nsh"
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
!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
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



Section "Android Studio" AndroidStudio
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /caption "Android Studio 1.5.1.0" \
             "http://dl.google.com/dl/android/studio/install/1.5.1.0/android-studio-bundle-141.2456560-windows.exe" \
             "$INSTDIR\android-studio-bundle-141.2456560-windows.exe" /end
  DetailPrint "Checking SHA1 hash for Android Studio 1.5.1.0"
  Crypto::HashFile "SHA1" "$INSTDIR\android-studio-bundle-141.2456560-windows.exe"
  Pop $0
  ${If} "6FFE608B1DD39041A578019EB3FEDB5EE62BA545" == $0
    DetailPrint "Successfully downloaded Android Studio 1.5.1.0"
  ${Else}
    DetailPrint "Android Studio 1.5.1.0 SHA1 didn't match [$0]"
  ${EndIf} 
SectionEnd



Section "Java 7 SDK" JavaSDK
  inetc::get /WEAKSECURITY /NOCOOKIES /RESUME "" \
             /HEADER "Cookie: oraclelicense=accept-securebackup-cookie" \
             /caption "Java 7.80 SDK" \
             "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-windows-i586.exe" \
             "$INSTDIR\jdk-7u80-windows-i586.exe" /end
  DetailPrint "Checking SHA1 hash for Java 7 SDK"
  Crypto::HashFile "MD5" "$INSTDIR\jdk-7u80-windows-i586.exe"
  Pop $0
  ${If} "8C6C888993144FDBDEC6F5D4E19B57A3" == $0
    DetailPrint "Successfully downloaded Java 7 SDK"
  ${Else}
    DetailPrint "Java 7 SDK md5 didn't match [$0]"
  ${EndIf} 
SectionEnd



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