; Script NSIS para TermiKAZ 🦅
!define PRODUCT_NAME "TermiKAZ"
!define PRODUCT_VERSION "1.1.0"
!define PRODUCT_PUBLISHER "Armando Soares & Kaz Community"
!define PRODUCT_WEB_SITE "https://github.com/armandosds/Kaz"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\termikaz.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKCU"

SetCompressor lzma

!include "MUI2.nsh"

; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\assets\flux.ico"
!define MUI_UNICON "..\assets\flux.ico"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\termikaz.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "English"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\dist\TermiKAZ_NSIS_Setup_v${PRODUCT_VERSION}.exe"
InstallDir "$LOCALAPPDATA\TermiKAZ"
InstallDirRegKey HKCU "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "..\target\release\termikaz.exe"
  File "..\README.md"
  
  SetOutPath "$INSTDIR\assets"
  File /r "..\assets\*.*"

  SetOutPath "$INSTDIR"
  CreateDirectory "$SMPROGRAMS\TermiKAZ"
  CreateShortcut "$SMPROGRAMS\TermiKAZ\TermiKAZ (Shell POSIX).lnk" "$INSTDIR\termikaz.exe" "" "$INSTDIR\assets\flux.ico"
  CreateShortcut "$SMPROGRAMS\TermiKAZ\TermiKAZ (Emulador GUI).lnk" "$INSTDIR\termikaz.exe" "--gui" "$INSTDIR\assets\flux.ico"
  CreateShortcut "$DESKTOP\TermiKAZ.lnk" "$INSTDIR\termikaz.exe" "" "$INSTDIR\assets\flux.ico"
  CreateShortcut "$SMPROGRAMS\TermiKAZ\Desinstalar TermiKAZ.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKCU "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\termikaz.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\assets\flux.ico"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Section Uninstall
  Delete "$INSTDIR\termikaz.exe"
  Delete "$INSTDIR\README.md"
  Delete "$INSTDIR\uninst.exe"
  RMDir /r "$INSTDIR\assets"

  Delete "$SMPROGRAMS\TermiKAZ\TermiKAZ (Shell POSIX).lnk"
  Delete "$SMPROGRAMS\TermiKAZ\TermiKAZ (Emulador GUI).lnk"
  Delete "$SMPROGRAMS\TermiKAZ\Desinstalar TermiKAZ.lnk"
  Delete "$DESKTOP\TermiKAZ.lnk"

  RMDir "$SMPROGRAMS\TermiKAZ"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKCU "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
