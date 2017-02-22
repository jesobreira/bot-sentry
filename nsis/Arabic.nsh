;; vim:fileencoding=latin1:fileformat=dos
;;
;; Language: Arabic (1025)
;;
;; Default language strings for bot-sentry nsis installer.
;; Copyright (C) 2006 David Everly <deckrider@users.sourceforge.net>
;; This file is distributed under the same license as the bot-sentry package.
;; David Everly <deckrider@users.sourceforge.net>, 2006.
;; Translator Nowar Al-Naffouri, naffouri@cmu.edu
;;

!insertmacro LANGFILE "Arabic" "Arabic"

;; MUI Wizard Text
;; Install


${LangFileString} BS_PAGE_WELCOME_TEXT "��� �������� ������� ������ �� ����� $(^NameDA).$\r$\n$\r$\n������ �� ���� �� ��������� ��� ���������$\r$\n$\r$\n$_CLICK"


${LangFileString} BS_PAGE_DIRECTORY_HEADER_TEXT "������ ���� �������"

${LangFileString} BS_PAGE_DIRECTORY_HEADER_SUBTEXT "������ ���� ����� �������� $(^NameDA)."

${LangFileString} BS_PAGE_DIRECTORY_TEXT_TOP "���� ����� ������ $(^NameDA) �� ������ ������ $_CLICK"


;; MUI Wizard Text
;; Uninstall


${LangFileString} BS_UNPAGE_WELCOME_TEXT " ��� �������� ������� ������ �� ����� ������$(^NameDA).$\r$\n$\r$\n����� �� ���� �� ��������� ��� ���������.$\r$\n$\r$\n$_CLICK"


;; MessageBox Error Text


${LangFileString} BS_PIDGIN_IS_RUNNING " .�� ������ ��� ��� ������ �� ������ ������� ���� ����. ������ ����� ���� ������� ��� ��������� ��� ����� ������� Pidgin  "

${LangFileString} BS_NO_PERMISSION "�� ���� ���� ������ ������  �� ����� $(^NameDA) ��� ��� ������"

${LangFileString} BS_NO_PURPLE_VERSION ".��� ��� ������ ���� ���� �������� ������� Pidgin �� ��� ����� ������ ������� ��"

${LangFileString} BS_INCOMPATIBLE_PURPLE_VERSION "$(^NameDA) Pidgin ��� ������ �� ������ ������� ������ ��"

${LangFileString} BS_UNINSTALL_DESC "$(^NameDA) (��� ���)"

