;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: Italian (1040)
;;
;; Italian language strings for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; Meo Bogliolo <meo@bogliolo.name>, 2006.
;;

!insertmacro LANGFILE "Italian" "Italiano"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "Questo wizard guidera' durante l'installazione di $(^NameDA).$\r$\n$\r$\nE' consigliato chiudere tutte le altre applicazioni prima di continuare.$\r$\n$\r$\n$_CLICK"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "Definizione Cartella di installazione"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "Definire la cartella in cui installare $(^NameDA)."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "Il wizard instellera' $(^NameDA) nella seguente cartella. $_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT "Questo wizard guidera' durante la disinstallazione $(^NameDA).$\r$\n$\r$\nE' consigliato chiudere le applicazioni prima di continuare.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING "Pidgin (o un altro programma incompatibile con l'installazione) e' attivo. Terminare il programma prima di proseguire."

${LangFileString} BS_NO_PERMISSION "Non disponi di diritti sufficenti per installare e/o rimuovere $(^NameDA) su questo computer."

${LangFileString} BS_NO_PURPLE_VERSION "Impossibile trovare una versione di Pidgin con il diritto di modifica su questo computer."

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "$(^NameDA) non e' compatibile con la versione di Pidgin installata."

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (cancella solo)"
