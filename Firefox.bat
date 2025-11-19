@ECHO OFF
TITLE Portable Firefox Installer [08.11.2025]
CD /d "%~dp0"
::	Mozilla Firefox (часть 25)	https://forum.ru-board.com/topic.cgi?forum=5&topic=51478&glp
::	Использовать метод портабелизации libportable, при изменении нужна переустановка
SET libportable=1
::	Обновление firefox
SET Update_core=0
::	Создание директории firefox если её нет и перемещение батника в неё
IF EXIST "../Firefox" GOTO core
MD "Firefox"
COPY "%~nx0" "Firefox/%~nx0"
START Firefox/"%~nx0"
DEL "%~nx0" /q && EXIT

:core
::	Запуск через этот же батник, если используется метод батника
IF %libportable% == 0 IF EXIST "core\firefox.exe" START core\firefox.exe -no-remote -profile userdata && EXIT

::	Удаление директории core при обновлении
IF %Update_core% == 0 IF EXIST "core" GOTO config
IF EXIST "core" DEL "core" /q

::	Скачивание и распаковка 7zr и firefox
	ECHO Downloading 7zr . . .
CURL -RL# "https://www.7-zip.org/a/7zr.exe" -o "7zr.exe"
	ECHO Downloading Firefox . . .
CURL -RL# "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=ru" -o "Firefox.7z"
	ECHO Extracting Firefox . . .
"7zr.exe" x -t7z -bso0 "Firefox.7z" -xr!setup.exe -xr!desktop-launcher -xr!uninstall -xr!application.ini -xr!*agent* -xr!*crash* -xr!*maintenance* -xr!*update* -xr!precomplete -xr!removed-files

:libportable
::	Скачивание и распаковка libportable
IF %libportable% == 0 GOTO extensions
	ECHO Downloading libportable . . .
CURL -RL# "https://github.com/adonais/libportable/releases/latest/download/portable_bin.7z" -o "libportable.7z"
	ECHO Extracting portable64.dll . . .
"7zr.exe" e -t7z -bso0 "libportable.7z" -o"core" "portable64.dll" -r

::	Создание файла настроек libportable
	ECHO Creating portable.ini . . .
(
ECHO [General]
ECHO Portable=1
ECHO PortableDataPath=../userdata
ECHO CreateCrashDump=0
ECHO GdiBatchLimit=0
ECHO ProcessAffinityMask=0
ECHO Update=0
ECHO DisDedicate=1
ECHO [env]
ECHO MOZ_LEGACY_PROFILES=1
ECHO TmpDataPath=..
)>"core\portable.ini"

::	Редактирование файла зависимостей для запуска libportable
	ECHO Editing dependentlibs.list . . .
ECHO portable64.dll > "core\dependentlibs.list.new"
TYPE "core\dependentlibs.list" >> "core\dependentlibs.list.new"
MOVE /y "core\dependentlibs.list.new" "core\dependentlibs.list" > NUL

:extensions
::	Установка расширений
IF NOT EXIST "core\distribution\extensions" MD "core\distribution\extensions"
	ECHO Downloading AdNauseam . . .
CURL -RL# "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/" -o "core\distribution\extensions\adnauseam@rednoise.org.xpi"
	ECHO Downloading Dark Reader . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/darkreader -o "core\distribution\extensions\addon@darkreader.org.xpi"
	ECHO Downloading Imagus mod . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/imagus-mod/ -o "core\distribution\extensions\{6833a9cb-d329-4d96-a062-76b1b663cd2c}.xpi"
::	ECHO Downloading NoScript . . .
::CURL -RL# "https://addons.mozilla.org/firefox/downloads/latest/noscript/" -o "core\distribution\extensions\{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
	ECHO Downloading Search By Image . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/search_by_image/ -o "core\distribution\extensions\{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}.xpi"
	ECHO Downloading Simple Translate . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/simple-translate/ -o "core\distribution\extensions\simple-translate@sienori.xpi"
	ECHO Downloading SponsorBlock . . .
CURL -RL# "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/" -o "core\distribution\extensions\sponsorBlocker@ajay.app.xpi"

:clean
::	Очистка установочных файлов
	ECHO Deleting downloaded files . . .
DEL "7zr.exe" "Firefox.7z" "libportable.7z" /q

:config
ECHO Creating preference files . . .

::	policies.json	Отключение автообновления и телеметрии
IF NOT EXIST "core\distribution" MD "core\distribution"
(
ECHO {"policies":{"DisableAppUpdate":true,"DisableTelemetry":true}}
)>"core\distribution\policies.json"

::	prefs.js	Главный файл настроек
::	Дополнить https://forum.ru-board.com/topic.cgi?forum=2&topic=5924&start=0&limit=1&m=1#1
IF NOT EXIST "userdata" MD "userdata"
(
ECHO user_pref^("toolkit.legacyUserProfileCustomizations.stylesheets", true^);
)>"userdata\prefs.js"

::	userChrome.css	Стили
IF NOT EXIST "userdata\chrome" MD "userdata\chrome"
CURL -RL# "https://raw.githubusercontent.com/MrOtherGuy/firefox-csshacks/refs/heads/master/chrome/autohide_toolbox.css" -o "userdata\chrome\userChrome.css"
(
@echo.
@echo.
@echo.
@echo.
@echo./* Tab's corners */
@echo.@-moz-document url^("chrome://browser/content/browser.xhtml"^) { :root {
@echo. --tab-block-margin:0px !important ;
@echo. --tab-border-radius:0px !important ;
@echo. --toolbarbutton-outer-padding:1px !important ;
@echo. --toolbarbutton-inner-padding:4px !important ;
@echo. --toolbar-start-end-padding:1px !important ;
@echo. --bookmark-block-padding:1px !important ;
@echo. --urlbar-min-height:24px !important ;
@echo. --urlbar-icon-padding:3px !important ;
@echo.} }
)>>"chrome\userChrome.css"
