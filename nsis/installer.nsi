; vim:fileencoding=latin1:fileformat=dos
;
; NSIS Script for the bot-sentry plugin
; Uses NSIS v2.37

Name "Bot Sentry ${VERSION}"

;Output File Name
OutFile "${OUTFILE}"

; Oldest registry keys
!define GAIM_BS_REG_KEY       "SOFTWARE\gaim-bs"
!define GAIM_BS_UNINST_EXE    "gaim-bs-uninst.exe"
!define GAIM_BS_UNINSTALL_LNK "Gaim-BS Uninstall.lnk"
!define GAIM_BS_UNINSTALL_KEY \
    "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\gaim-bs"

; Old registry keys
!define PIDGIN_BS_REG_KEY       "SOFTWARE\pidgin-bs"
!define PIDGIN_BS_UNINST_EXE    "pidgin-bs-uninst.exe"
!define PIDGIN_BS_UNINSTALL_LNK "pidgin-bs Uninstall.lnk"
!define PIDGIN_BS_UNINSTALL_KEY \
    "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\pidgin-bs"

; Current Registry keys:
!define BOT_SENTRY_REG_KEY       "SOFTWARE\${PACKAGE}"
!define BOT_SENTRY_UNINST_EXE    "${PACKAGE}-uninst.exe"
!define BOT_SENTRY_UNINSTALL_LNK "${PACKAGE} Uninstall.lnk"
!define BOT_SENTRY_UNINSTALL_KEY \
    "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PACKAGE}"

; nsis includes
!include "WinMessages.nsh"
!include "LogicLib.nsh"
!include "StrFunc.nsh"
!include "MUI2.nsh"

; from "StrFunc.nsh"
; have to declare ${StrTok} before I use it in a function
${StrTok}

; global settings
CRCCheck force
ShowInstDetails show
ShowUnInstDetails show
SetCompressor /SOLID /FINAL lzma

; global variables
Var "USER_CONTEXT"

; global MUI settings
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

; Installer Welcome Page
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE VerifyContinue
!define MUI_WELCOMEPAGE_TEXT $(BS_PAGE_WELCOME_TEXT)
!insertmacro MUI_PAGE_WELCOME

; Installer License Page
!insertmacro MUI_PAGE_LICENSE "${TOP_SRCDIR}\COPYING"

; Installer Directory Page
!define MUI_PAGE_CUSTOMFUNCTION_SHOW CustomizeMuiPageDirectory
!define MUI_PAGE_HEADER_TEXT $(BS_PAGE_DIRECTORY_HEADER_TEXT)
!define MUI_PAGE_HEADER_SUBTEXT $(BS_PAGE_DIRECTORY_HEADER_SUBTEXT)
!define MUI_DIRECTORYPAGE_TEXT_TOP $(BS_PAGE_DIRECTORY_TEXT_TOP)
!insertmacro MUI_PAGE_DIRECTORY

; Installer Files Page
!insertmacro MUI_PAGE_INSTFILES

; Installer Finish Page
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_LINK ${PACKAGE_BUGREPORT}
!define MUI_FINISHPAGE_LINK_LOCATION ${PACKAGE_BUGREPORT}
!insertmacro MUI_PAGE_FINISH

; Uninstaller Welcome Page
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE un.VerifyContinue
!define MUI_WELCOMEPAGE_TEXT $(BS_UNPAGE_WELCOME_TEXT)
!insertmacro MUI_UNPAGE_WELCOME

; Uninstaller Confirm Page
!insertmacro MUI_UNPAGE_CONFIRM

; Uninstaller Files Page
!insertmacro MUI_UNPAGE_INSTFILES

; Uninstaller Finish Page
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_LINK ${PACKAGE_BUGREPORT}
!define MUI_FINISHPAGE_LINK_LOCATION ${PACKAGE_BUGREPORT}
!insertmacro MUI_UNPAGE_FINISH


; Translations

; Warn about missing strings
!macro BS_CHECKSTRING BS_SYMBOL
  !ifndef "${BS_SYMBOL}"
    !warning "${BS_SYMBOL} not found for ${LANGUAGE}, using default."
  !endif
!macroend

; lightly adapted from "/usr/share/nsis/Include/LangFile.nsh"
!macro BS_LANGFILE_INCLUDE_WITHDEFAULT FILENAME FILENAME_DEFAULT BS_FILENAME BS_FILENAME_DEFAULT

  ;Called from script: include a langauge file
  ;Obtains missing strings from a default file

  !ifdef LangFileString
    !undef LangFileString
  !endif

  !define LangFileString "!insertmacro LANGFILE_SETSTRING"

  !define LANGFILE_SETNAMES
  !include "${FILENAME}"
  !include /NONFATAL "${BS_FILENAME}"
  !undef LANGFILE_SETNAMES

  ;Warn about missing strings
  !insertmacro BS_CHECKSTRING BS_PIDGIN_IS_RUNNING
  !insertmacro BS_CHECKSTRING BS_INCOMPATIBLE_PURPLE_VERSION
  !insertmacro BS_CHECKSTRING BS_NO_PURPLE_VERSION
  !insertmacro BS_CHECKSTRING BS_NO_PERMISSION
  !insertmacro BS_CHECKSTRING BS_PAGE_DIRECTORY_HEADER_SUBTEXT
  !insertmacro BS_CHECKSTRING BS_PAGE_DIRECTORY_HEADER_TEXT
  !insertmacro BS_CHECKSTRING BS_PAGE_DIRECTORY_TEXT_TOP
  !insertmacro BS_CHECKSTRING BS_PAGE_WELCOME_TEXT
  !insertmacro BS_CHECKSTRING BS_UNINSTALL_DESC
  !insertmacro BS_CHECKSTRING BS_UNPAGE_WELCOME_TEXT

  ;Include default language for missing strings
  !include "${FILENAME_DEFAULT}"
  !include "${BS_FILENAME_DEFAULT}"

  ;Create language strings
  !undef LangFileString
  !define LangFileString "!insertmacro LANGFILE_LANGSTRING"
  !include "${FILENAME_DEFAULT}"
  !include "${BS_FILENAME_DEFAULT}"

!macroend

; lightly adapted from "/usr/share/nsis/Contrib/Modern UI 2/Localization.nsh"
!macro BS_LANGUAGE LANGUAGE

  ;Include a language

  !verbose push
  !verbose ${MUI_VERBOSE}

  !insertmacro MUI_INSERT

  LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LANGUAGE}.nlf"

  ;Include language file
  !insertmacro BS_LANGFILE_INCLUDE_WITHDEFAULT "${NSISDIR}\Contrib\Language files\${LANGUAGE}.nsh" "${NSISDIR}\Contrib\Language files\English.nsh" "${TOP_SRCDIR}\nsis\${LANGUAGE}.nsh" "${TOP_SRCDIR}\nsis\English.nsh"

  ;Add language to list of languages for selection dialog
  !ifndef MUI_LANGDLL_LANGUAGES
    !define MUI_LANGDLL_LANGUAGES "'${LANGFILE_${LANGUAGE}_NAME}' '${LANG_${LANGUAGE}}' "
    !define MUI_LANGDLL_LANGUAGES_CP "'${LANGFILE_${LANGUAGE}_NAME}' '${LANG_${LANGUAGE}}' '${LANG_${LANGUAGE}_CP}' "
  !else
    !ifdef MUI_LANGDLL_LANGUAGES_TEMP
      !undef MUI_LANGDLL_LANGUAGES_TEMP
    !endif
    !define MUI_LANGDLL_LANGUAGES_TEMP "${MUI_LANGDLL_LANGUAGES}"
    !undef MUI_LANGDLL_LANGUAGES

    !ifdef MUI_LANGDLL_LANGUAGES_CP_TEMP
      !undef MUI_LANGDLL_LANGUAGES_CP_TEMP
    !endif
    !define MUI_LANGDLL_LANGUAGES_CP_TEMP "${MUI_LANGDLL_LANGUAGES_CP}"
    !undef MUI_LANGDLL_LANGUAGES_CP

    !define MUI_LANGDLL_LANGUAGES "'${LANGFILE_${LANGUAGE}_NAME}' '${LANG_${LANGUAGE}}' ${MUI_LANGDLL_LANGUAGES_TEMP}"
    !define MUI_LANGDLL_LANGUAGES_CP "'${LANGFILE_${LANGUAGE}_NAME}' '${LANG_${LANGUAGE}}' '${LANG_${LANGUAGE}_CP}' ${MUI_LANGDLL_LANGUAGES_CP_TEMP}"
  !endif

  !verbose pop

!macroend

; All the languages in the NSI Package
; The first is the default

!insertmacro BS_LANGUAGE "English"
!insertmacro BS_LANGUAGE "Afrikaans"
!insertmacro BS_LANGUAGE "Albanian"
!insertmacro BS_LANGUAGE "Arabic"
!insertmacro BS_LANGUAGE "Basque"
!insertmacro BS_LANGUAGE "Belarusian"
!insertmacro BS_LANGUAGE "Bosnian"
!insertmacro BS_LANGUAGE "Breton"
!insertmacro BS_LANGUAGE "Bulgarian"
!insertmacro BS_LANGUAGE "Catalan"
!insertmacro BS_LANGUAGE "Croatian"
!insertmacro BS_LANGUAGE "Czech"
!insertmacro BS_LANGUAGE "Danish"
!insertmacro BS_LANGUAGE "Dutch"
!insertmacro BS_LANGUAGE "Estonian"
!insertmacro BS_LANGUAGE "Farsi"
!insertmacro BS_LANGUAGE "Finnish"
!insertmacro BS_LANGUAGE "French"
!insertmacro BS_LANGUAGE "Galician"
!insertmacro BS_LANGUAGE "German"
!insertmacro BS_LANGUAGE "Greek"
!insertmacro BS_LANGUAGE "Hebrew"
!insertmacro BS_LANGUAGE "Hungarian"
!insertmacro BS_LANGUAGE "Icelandic"
!insertmacro BS_LANGUAGE "Indonesian"
!insertmacro BS_LANGUAGE "Irish"
!insertmacro BS_LANGUAGE "Italian"
!insertmacro BS_LANGUAGE "Japanese"
!insertmacro BS_LANGUAGE "Korean"
!insertmacro BS_LANGUAGE "Kurdish"
!insertmacro BS_LANGUAGE "Latvian"
!insertmacro BS_LANGUAGE "Lithuanian"
!insertmacro BS_LANGUAGE "Luxembourgish"
!insertmacro BS_LANGUAGE "Macedonian"
!insertmacro BS_LANGUAGE "Malay"
!insertmacro BS_LANGUAGE "Mongolian"
!insertmacro BS_LANGUAGE "Norwegian"
!insertmacro BS_LANGUAGE "NorwegianNynorsk"
!insertmacro BS_LANGUAGE "Polish"
!insertmacro BS_LANGUAGE "PortugueseBR"
!insertmacro BS_LANGUAGE "Portuguese"
!insertmacro BS_LANGUAGE "Romanian"
!insertmacro BS_LANGUAGE "Russian"
!insertmacro BS_LANGUAGE "SerbianLatin"
!insertmacro BS_LANGUAGE "Serbian"
!insertmacro BS_LANGUAGE "SimpChinese"
!insertmacro BS_LANGUAGE "Slovak"
!insertmacro BS_LANGUAGE "Slovenian"
!insertmacro BS_LANGUAGE "SpanishInternational"
!insertmacro BS_LANGUAGE "Spanish"
!insertmacro BS_LANGUAGE "Swedish"
!insertmacro BS_LANGUAGE "Thai"
!insertmacro BS_LANGUAGE "TradChinese"
!insertmacro BS_LANGUAGE "Turkish"
!insertmacro BS_LANGUAGE "Ukrainian"
!insertmacro BS_LANGUAGE "Uzbek"
!insertmacro BS_LANGUAGE "Welsh"


Section "Install"
    Push $0
    Push $1

    ; set the context
    ${If} $USER_CONTEXT == "all"
        SetShellVarContext "all"
    ${Else}
        SetShellVarContext "current"
    ${EndIf}

    ; If there was a previous gaim-bs installation, run its uninstaller
    ReadRegStr $0 SHCTX "${GAIM_BS_REG_KEY}" ""
    ReadRegStr $1 SHCTX "${GAIM_BS_UNINSTALL_KEY}" "UninstallString"

    ${If}    $0 != ""
    ${AndIf} $1 != ""
        Delete "$TEMP\${GAIM_BS_UNINST_EXE}"
        ClearErrors
        CopyFiles $1 "$TEMP\${GAIM_BS_UNINST_EXE}"
        ExecWait '"$TEMP\${GAIM_BS_UNINST_EXE}" /S _?=$0'
        Delete "$TEMP\${GAIM_BS_UNINST_EXE}"
    ${EndIf}

    ; If there was a previous pidgin-bs installation, run its uninstaller
    ReadRegStr $0 SHCTX "${PIDGIN_BS_REG_KEY}" ""
    ReadRegStr $1 SHCTX "${PIDGIN_BS_UNINSTALL_KEY}" "UninstallString"

    ${If}    $0 != ""
    ${AndIf} $1 != ""
        Delete "$TEMP\${PIDGIN_BS_UNINST_EXE}"
        ClearErrors
        CopyFiles $1 "$TEMP\${PIDGIN_BS_UNINST_EXE}"
        ExecWait '"$TEMP\${PIDGIN_BS_UNINST_EXE}" /S _?=$0'
        Delete "$TEMP\${PIDGIN_BS_UNINST_EXE}"
    ${EndIf}

    ; If there was a previous bot-sentry installation, run its uninstaller
    ReadRegStr $0 SHCTX "${BOT_SENTRY_REG_KEY}" ""
    ReadRegStr $1 SHCTX "${BOT_SENTRY_UNINSTALL_KEY}" "UninstallString"

    ${If}    $0 != ""
    ${AndIf} $1 != ""
        Delete "$TEMP\${BOT_SENTRY_UNINST_EXE}"
        ClearErrors
        CopyFiles $1 "$TEMP\${BOT_SENTRY_UNINST_EXE}"
        ExecWait '"$TEMP\${BOT_SENTRY_UNINST_EXE}" /S _?=$0'
        Delete "$TEMP\${BOT_SENTRY_UNINST_EXE}"
    ${EndIf}

    ${If} ${Errors}
        Call UninstallCommon
    ${EndIf}

    ; Write the uninstaller
    WriteUninstaller "$INSTDIR\${BOT_SENTRY_UNINST_EXE}"

    ; Write the uninstaller shortcut
    CreateShortCut \
        "$SMPROGRAMS\Pidgin\${BOT_SENTRY_UNINSTALL_LNK}" \
        "$INSTDIR\${BOT_SENTRY_UNINST_EXE}"

    ; Write the required uninstall keys for Windows
    WriteRegStr SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "DisplayName" \
        "$(BS_UNINSTALL_DESC)"
    WriteRegStr SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "UninstallString" \
        "$INSTDIR\${BOT_SENTRY_UNINST_EXE}"

    ; Write the optional uninstall keys for Windows
    WriteRegStr SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "InstallLocation" \
        "$INSTDIR"
    WriteRegStr SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "HelpLink" \
        "${PACKAGE_BUGREPORT}"
    WriteRegStr SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "URLUpdateInfo" \
        "${PACKAGE_BUGREPORT}"
    WriteRegStr SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "URLInfoAbout" \
        "${PACKAGE_BUGREPORT}"
    WriteRegStr SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "DisplayVersion" \
        "${VERSION}"
    WriteRegDWORD SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "VersionMajor" \
        "${VERSION_MAJOR}"
    WriteRegDWORD SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "VersionMinor" \
        "${VERSION_MINOR}"
    WriteRegDWORD SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "NoModify" \
        "1"
    WriteRegDWORD SHCTX \
        ${BOT_SENTRY_UNINSTALL_KEY} \
        "NoRepair" \
        "1"

    ; Write the version registry keys:
    WriteRegStr SHCTX ${BOT_SENTRY_REG_KEY} "" "$INSTDIR"
    WriteRegStr SHCTX ${BOT_SENTRY_REG_KEY} "Version" "${VERSION}"

    ; Write the files
    SetOutPath "$INSTDIR\plugins"
    File /r "${LIBDIR}\*"

    SetOutPath "$INSTDIR\locale"
    File /r "${LOCALEDIR}\*"

    ; delete the old conflicting plugin
    Delete "$INSTDIR\plugins\libbot-challenger.dll"
        
    Pop $1
    Pop $0
SectionEnd


Section "Uninstall"
    Call un.UninstallCommon
SectionEnd


Function .onInit
    !insertmacro MUI_LANGDLL_DISPLAY

    ${If} ${Silent}
        Call VerifyContinue
        Call .onVerifyInstDir
    ${EndIf}
FunctionEnd


Function un.onInit
    !insertmacro MUI_LANGDLL_DISPLAY

    ${If} ${Silent}
        Call un.VerifyContinue
    ${EndIf}
FunctionEnd


Function .onVerifyInstDir
    ${If} ${FileExists} "$INSTDIR\pidgin.exe"
        ; good, do nothing
    ${Else}
        Abort
    ${EndIf}
FunctionEnd


Function VerifyContinue
    Push $0
    Push $1

    Call GetUserContextCommon

    ; If "all" doesn't find pidgin, downgrade to "current"
    ${If} $USER_CONTEXT == "all"
        SetShellVarContext "all"
        ClearErrors
        ReadRegStr $INSTDIR SHCTX "SOFTWARE\pidgin" ""
        ${If} ${Errors}
             StrCpy $USER_CONTEXT "current"
        ${EndIf}
    ${EndIf}

    ; If "current" doesn't find pidgin, downgrade to "nokey"
    ${If} $USER_CONTEXT == "current"
        SetShellVarContext "current"
        ClearErrors
        ReadRegStr $INSTDIR SHCTX "SOFTWARE\pidgin" ""
        ${If} ${Errors}
             StrCpy $USER_CONTEXT "nokey"
        ${EndIf}
    ${EndIf}
    ClearErrors

    Call VerifyContinueCommon

    ; do not proceed if installed pidgin version
    ; is incompatible with plugin pidgin version

    ; set the context
    ${If} $USER_CONTEXT == "all"
        SetShellVarContext "all"
    ${Else}
        SetShellVarContext "current"
    ${EndIf}

    ; Get the installed version of Pidgin
    ClearErrors
    ReadRegStr $0 SHCTX "SOFTWARE\pidgin" "Version"

    ${If} ${Errors}
    ${OrIf} $0 == ""
        MessageBox MB_OK|MB_ICONEXCLAMATION $(BS_NO_PURPLE_VERSION) \
            /SD IDOK
        Abort
    ${EndIf}

    ; Pidgin versions are in the format X.Y.Z.  For this plugin to work 
    ; with the installed version of Pidgin, it must have been compiled
    ; with version X equal to the installed Pidgin

    ; Installed Pidgin X = $1
    ${StrTok} $1 $0 "." "0" "1"

    ${If} $1 == ${PURPLE_MAJOR_VERSION}
        ; we are compatible with the installed version of pidgin
    ${Else}
        ; FIXME insert the version numbers and/or explain which
        ; versions might be compatible
        MessageBox MB_OK|MB_ICONEXCLAMATION $(BS_INCOMPATIBLE_PURPLE_VERSION) \
            /SD IDOK
        Abort
    ${EndIf}

    Pop $1 
    Pop $0 
FunctionEnd


Function un.VerifyContinue
    Push $0

    Call un.GetUserContextCommon

    ; If "all" doesn't find the matching path, downgrade to "current"
    ${If} $USER_CONTEXT == "all"
        SetShellVarContext "all"
        ReadRegStr $0 SHCTX "${BOT_SENTRY_REG_KEY}" ""
        ${If} $0 != $INSTDIR
            StrCpy $USER_CONTEXT "current"
        ${EndIf}
    ${EndIf}

    ; If "current" doesn't find the matching path, downgrade to "nokey"
    ${If} $USER_CONTEXT == "current"
        SetShellVarContext "current"
        ReadRegStr $0 SHCTX "${BOT_SENTRY_REG_KEY}" ""
        ${If} $0 != $INSTDIR
            StrCpy $USER_CONTEXT "nokey"
        ${EndIf}
    ${EndIf}

    Call un.VerifyContinueCommon

    Pop $0
FunctionEnd


Function CustomizeMuiPageDirectory
    Push $0
    Push $1

    FindWindow $0 "#32770" "" $HWNDPARENT

    ; readonly path text
    GetDlgItem $1 $0 1019
    SendMessage $1 ${EM_SETREADONLY} 1 0

    ; disable browse button
    GetDlgItem $1 $0 1001
    EnableWindow $1 0

    Pop $1
    Pop $0
FunctionEnd


!macro UninstallMacro UN
Function ${UN}UninstallCommon
    push $0
    push $1

    ; set the context
    ${If} $USER_CONTEXT == "all"
        SetShellVarContext "all"
    ${Else}
        SetShellVarContext "current"
    ${EndIf}

    ; delete the plugin
    Delete "$INSTDIR\plugins\${PACKAGE}.*"

    ; translations - loop through and try to delete any present
    ClearErrors
    FindFirst $0 $1 "$INSTDIR\locale\*"
    ${Unless} ${Errors}
        ${Do}
            ${If} $1 == "."
                ; skip
            ${ElseIf} $1 == ".."
                ; skip
            ${ElseIf} \
            ${FileExists} "$INSTDIR\locale\$1\LC_MESSAGES\${PACKAGE}.mo"
                Delete "$INSTDIR\locale\$1\LC_MESSAGES\${PACKAGE}.mo"
                RMDir  "$INSTDIR\locale\$1\LC_MESSAGES"
                RMDir  "$INSTDIR\locale\$1"
                ClearErrors
            ${EndIf}
            FindNext $0 $1
        ${LoopUntil} ${Errors}
        FindClose $0
        RMDir "$INSTDIR\locale"
        ClearErrors
    ${EndUnless}

    ; gaim-bs registry keys
    DeleteRegKey SHCTX "${GAIM_BS_REG_KEY}"
    DeleteRegKey SHCTX "${GAIM_BS_UNINSTALL_KEY}"

    ; pidgin-bs registry keys
    DeleteRegKey SHCTX "${PIDGIN_BS_REG_KEY}"
    DeleteRegKey SHCTX "${PIDGIN_BS_UNINSTALL_KEY}"

    ; bot-sentry registry keys
    DeleteRegKey SHCTX "${BOT_SENTRY_REG_KEY}"
    DeleteRegKey SHCTX "${BOT_SENTRY_UNINSTALL_KEY}"

    ; gaim-bs uninstaller shortcut
    Delete "$SMPROGRAMS\Gaim\${GAIM_BS_UNINSTALL_LNK}"

    ; pidgin-bs uninstaller shortcut
    Delete "$SMPROGRAMS\Pidgin\${PIDGIN_BS_UNINSTALL_LNK}"

    ; bot-sentry uninstaller shortcut
    Delete "$SMPROGRAMS\Pidgin\${BOT_SENTRY_UNINSTALL_LNK}"

    ; bot-sentry uninstaller
    Delete "$INSTDIR\${BOT_SENTRY_UNINST_EXE}"

    ; try to delete the Gaim directories, in case Gaim was removed earlier
    RMDir "$SMPROGRAMS\Gaim"

    ; try to delete the Pidgin directories, in case Pidgin was removed earlier
    RMDir "$INSTDIR\plugins"
    RMDir "$INSTDIR"
    RMDir "$SMPROGRAMS\Pidgin"

    Pop $1
    Pop $0
FunctionEnd
!macroend
!insertmacro UninstallMacro ""
!insertmacro UninstallMacro "un."


!macro VerifyContinueCommonMacro UN
Function ${UN}VerifyContinueCommon
    Push $0

    ; do not proceed without the key
    ${If} $USER_CONTEXT == "nokey"
        MessageBox MB_OK|MB_ICONEXCLAMATION $(BS_NO_PURPLE_VERSION) \
            /SD IDOK
        Abort
    ${EndIf}

    ; do not proceed without authority
    ${If} $USER_CONTEXT == "noperm"
        MessageBox MB_OK|MB_ICONEXCLAMATION $(BS_NO_PERMISSION) \
            /SD IDOK
        Abort
    ${EndIf}

    ; do not proceed if pidgin is running
    FindWindow $0 "gdkWindowToplevel"
    ${If} $0 != 0
        MessageBox MB_OK|MB_ICONEXCLAMATION $(BS_PIDGIN_IS_RUNNING) \
            /SD IDOK
        Abort
    ${EndIf}

    Pop $0 
FunctionEnd
!macroend
!insertmacro VerifyContinueCommonMacro ""
!insertmacro VerifyContinueCommonMacro "un."


!macro GetUserContextMacro UN
Function ${UN}GetUserContextCommon
    Push $0
    Push $1

    ClearErrors
    UserInfo::GetName
    Pop $0
    ${If} ${Errors}
        ; Win9x
        StrCpy $USER_CONTEXT "all"
    ${Else}
        UserInfo::GetAccountType
        Pop $1
        ${If} $1 == "Admin"
            StrCpy $USER_CONTEXT "all"
        ${ElseIf} $1 == "Power"
            StrCpy $USER_CONTEXT "all"
        ${ElseIf} $1 == "User"
            StrCpy $USER_CONTEXT "current"
        ${Else}
            StrCpy $USER_CONTEXT "noperm"
        ${EndIf}
    ${EndIf}
    ClearErrors

    Pop $1
    Pop $0
FunctionEnd
!macroend
!insertmacro GetUserContextMacro ""
!insertmacro GetUserContextMacro "un."


; vim:tabstop=4:shiftwidth=4:expandtab:

