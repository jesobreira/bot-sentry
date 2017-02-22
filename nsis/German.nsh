;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: German (1031)
;;
;; German translations for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; Jens Ibe <ibus85@web.de>, 2006.
;;

!insertmacro LANGFILE "German" "Deutsch"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "Dieser Assistent begleitet sie durch die Installation von $(^NameDA).$\r$\n$\r$\nEs empfiehlt sich das sie alle Anwendungen beenden bevor sie fortfahren.$\r$\n$\r$\n$_CLICK"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "Installationsverzeichnis ansehen"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "Zielordner von $(^NameDA) ansehen."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "Das Setup wird $(^NameDA) in den folgenden Ordner installieren. $_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT "Dieser Assistent begleitet sie durch die Deinstallation von $(^NameDA).$\r$\n$\r$\nEs empfiehlt sich das sie alle Anwendungen beenden bevor sie fortfahren.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING "Pidgin (oder ein anderes, zum Installer inkompatibles Programm) ist aktiv.  Bitte beenden sie das behindernde Programm bevor sie fortfahren."

${LangFileString} BS_NO_PERMISSION "Sie haben nicht ausreichende Berechtigungen um $(^NameDA) auf diesem Computer zu installieren und/oder es zu entfernen."

${LangFileString} BS_NO_PURPLE_VERSION "Eine installierte und zu Aktualisierungen berechtigte Version von Pidgin kann nicht gefunden werden."

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "$(^NameDA) ist nicht kompatibel zur installierten Pidgin Version."

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (Nur zum Entfernen)"

