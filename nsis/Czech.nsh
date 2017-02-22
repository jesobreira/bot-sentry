;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: Czech (1029)
;;
;; Default language strings for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; Luboš Stanìk <lubek@users.sourceforge.net>, 2006.
;;

!insertmacro LANGFILE "Czech" "Cesky"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "Tento prùvodce Vás provede instalací aplikace $(^NameDA).$\r$\n$\r$\nPøed pokraèováním v instalaci je doporuèeno zavøít všechny ostatní aplikace.$\r$\n$\r$\n$_CLICK"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "Kontrola umístìní instalace"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "Zkontrolujte složku, kam bude aplikace $(^NameDA) nainstalována."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "Prùvodce nainstaluje aplikaci $(^NameDA) do následující složky. $_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT "Tento prùvodce Vás provede odinstalací aplikace $(^NameDA).$\r$\n$\r$\nPøed pokraèováním v odinstalaci je doporuèeno zavøít všechny ostatní aplikace.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING "Pidgin (nebo jiný program nekompatibilní s tímto instalátorem) právì bìží. Ukonèete prosím pøed pokraèováním tento konfliktní program."

${LangFileString} BS_NO_PERMISSION "Nemáte dostateèná oprávnìní k instalaci nebo odinstalaci aplikace $(^NameDA) na tomto poèítaèi."

${LangFileString} BS_NO_PURPLE_VERSION "Nelze nalézt nainstalovanou verzi aplikace Pidgin na tomto poèítaèi, již jste oprávnìni aktualizovat."

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "Aplikace $(^NameDA) není kompatibilní s aktuálnì nainstalovanou verzí aplikace Pidgin."

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (pouze odinstalovat)"

