;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: Czech (1029)
;;
;; Default language strings for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; Lubo� Stan�k <lubek@users.sourceforge.net>, 2006.
;;

!insertmacro LANGFILE "Czech" "Cesky"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "Tento pr�vodce V�s provede instalac� aplikace $(^NameDA).$\r$\n$\r$\nP�ed pokra�ov�n�m v instalaci je doporu�eno zav��t v�echny ostatn� aplikace.$\r$\n$\r$\n$_CLICK"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "Kontrola um�st�n� instalace"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "Zkontrolujte slo�ku, kam bude aplikace $(^NameDA) nainstalov�na."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "Pr�vodce nainstaluje aplikaci $(^NameDA) do n�sleduj�c� slo�ky. $_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT "Tento pr�vodce V�s provede odinstalac� aplikace $(^NameDA).$\r$\n$\r$\nP�ed pokra�ov�n�m v odinstalaci je doporu�eno zav��t v�echny ostatn� aplikace.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING "Pidgin (nebo jin� program nekompatibiln� s t�mto instal�torem) pr�v� b��. Ukon�ete pros�m p�ed pokra�ov�n�m tento konfliktn� program."

${LangFileString} BS_NO_PERMISSION "Nem�te dostate�n� opr�vn�n� k instalaci nebo odinstalaci aplikace $(^NameDA) na tomto po��ta�i."

${LangFileString} BS_NO_PURPLE_VERSION "Nelze nal�zt nainstalovanou verzi aplikace Pidgin na tomto po��ta�i, ji� jste opr�vn�ni aktualizovat."

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "Aplikace $(^NameDA) nen� kompatibiln� s aktu�ln� nainstalovanou verz� aplikace Pidgin."

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (pouze odinstalovat)"

