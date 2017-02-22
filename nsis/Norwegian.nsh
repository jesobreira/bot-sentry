;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: Norwegian (2068)
;;
;; Norwegian translations for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; I. O. Karlsen <arcusc@users.sourceforge.net>, 2006.
;;

!insertmacro LANGFILE "Norwegian" "Norwegian"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "Denne guiden vil hjelpe deg gjennom installasjonen av $(^NameDA).$\r$\n$\r$\nDet anbefales at du lukker alle andre program f�r du fortsetter.$\r$\n$\r$\n$_CLICK"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "Velg installasjonsm�l"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "Velg mappe for installasjonen av $(^NameDA)."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "Setup vil installere $(^NameDA) i f�lgende mappe. $_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT "Denne guiden vil hjelpe deg gjennom avinstallasjonen av $(^NameDA).$\r$\n$\r$\nDet anbefales at du lukker alle andre program f�r du fortsetter.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING "Pidgin (eller et annet program som ikke er kompatibelt med dette installasjonsprogrammet) er �pent. Vennligst lukk programmet f�r du fortsetter."

${LangFileString} BS_NO_PERMISSION "Du har ikke brukertilgang til � installere og/eller fjerne $(^NameDA) p� denne maskinen."

${LangFileString} BS_NO_PURPLE_VERSION "Finner ikke noen installert utgave av Pidgin p� denne maskinen som du har tilgang til � oppdatere."

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "$(^NameDA) er ikke kompatibel med den installerte utgaven av Pidgin."

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (kun fjerning)"

