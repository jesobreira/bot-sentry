;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: Spanish (1034)
;;
;; Spanish translations for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; Fredo <fredoguy@users.sourceforge.net>, 2006.
;;

!insertmacro LANGFILE "Spanish" "Español"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "Este mago le dirigirá a través de la instalación de $(^NameDA).$\r$\n$\r$\nSe recomienda que usted cierra el resto de los usos.$\r$\n$\r$\n$_CLICK"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "Repase localización de la instalación"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "Repase la carpeta en la cual instalar $(^NameDA)."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "La disposición instalará $(^NameDA) en la carpeta siguiente.$_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT "Este mago le dirigirá a través de la instalación de $(^NameDA).$\r$\n$\r$\nSe recomienda que usted cierra el resto de los usos.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING "Pidgin (u otro programa incompatible con este instalador) está funcionando.  Cierre por favor el programa que ofende antes de proceder."

${LangFileString} BS_NO_PERMISSION "Usted no tiene suficiente permiso que instalar y/o quitar $(^NameDA) en esta computadora."

${LangFileString} BS_NO_PURPLE_VERSION "Incapaz de encontrar una versión instalada Pidgin en esta computadora que usted tiene permiso que ponerse al día."

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "$(^NameDA) no es compatible con la versión actualmente instalada de Pidgin."

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (quite solamente)"


