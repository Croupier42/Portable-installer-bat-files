@ECHO OFF
CHCP 65001 > NUL
::	Название директории
SET DirName=Minecraft
::	Обновление core
SET Update=0

TITLE Portable %DirName% Installer [17.11.2025]
CD /d "%~dp0"
::	Создание директории если её нет и перемещение батника в неё
IF EXIST "..\%DirName%" GOTO core
MD "%DirName%"
COPY "%~nx0" "%DirName%\%~nx0"
CD "%DirName%"
START "" "%~nx0"
CD ..
DEL "%~nx0" /q && EXIT

:core
	ECHO Загрузка %DirName% . . .
CURL -RL# "https://github.com/PrismLauncher/PrismLauncher/releases/download/9.4/PrismLauncher-Windows-MinGW-w64-Portable-9.4.zip" -o "%DirName%.zip"
	ECHO Распаковка %DirName% . . .
TAR -xf "%DirName%.zip"
	ECHO Загрузка картинок котиков . . .
CURL -RL# "https://derpicdn.net/img/download/2024/1/11/3278627.png" -o "userdata\catpacks\3278627.png"

:clean
	ECHO Очистка установочных файлов . . .
DEL "%DirName%.zip" /q

:config
	ECHO Создание файлов настроек . . .
MD userdata
(
ECHO [General]
ECHO ConfigVersion=1.2
ECHO ApplicationTheme=system
ECHO IconTheme=pe_colored
ECHO BackgroundCat=3278627
ECHO Language=ru
ECHO MainWindowState="@ByteArray(AAAA/wAAAAD9AAAAAAAAAyAAAAI3AAAABAAAAAQAAAAIAAAACPwAAAADAAAAAQAAAAEAAAAeAGkAbgBzAHQAYQBuAGMAZQBUAG8AbwBsAEIAYQByAgAAAAD/////AAAAAAAAAAAAAAACAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAAAAAAD/////AAAAAAAAAAAAAAADAAAAAQAAABYAbgBlAHcAcwBUAG8AbwBsAEIAYQByAAAAAAD/////AAAAAAAAAAA=)"
ECHO MenuBarInsteadOfToolBar=true
ECHO StatusBarVisible=false
ECHO MaxMemAlloc=8192
ECHO TheCat=true
)>"userdata\prismlauncher.cfg"
attrib +R "userdata\prismlauncher.cfg"