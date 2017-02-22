;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: English (1033)
;;
;; Default language strings for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; David Everly <deckrider@users.sourceforge.net>, 2006.
;;

!insertmacro LANGFILE "English" "English"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "This wizard will guide you through the installation of $(^NameDA).$\r$\n$\r$\nIt is recommended that you close all other applications before continuing.$\r$\n$\r$\n$_CLICK"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "Review Install Location"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "Review the folder in which to install $(^NameDA)."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "Setup will install $(^NameDA) in the following folder. $_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT "This wizard will guide you through the uninstallation of $(^NameDA).$\r$\n$\r$\nIt is recommended that you close all other applications before continuing.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING "Pidgin (or another program incompatible with this installer) is running.  Please shut down the offending program before proceeding."

${LangFileString} BS_NO_PERMISSION "You do not have sufficient permission to install and/or remove $(^NameDA) on this computer."

${LangFileString} BS_NO_PURPLE_VERSION "Unable to find an installed version of Pidgin on this computer that you have permission to update."

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "$(^NameDA) is not compatible with the currently installed version of Pidgin."

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (remove only)"

