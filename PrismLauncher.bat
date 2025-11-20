::	Сделать CURL по последнему релизу
::	Сделать Удаление текущей версии с сохранением файлав пользователя
	@ECHO OFF
	CHCP 65001 > NUL
	TITLE Portable %~n0 Creator [20.11.2025]
	CD /d "%~dp0"
	IF EXIST "..\%~n0" GOTO core
		MD "%~n0"
		COPY "%~nx0" "%~n0\%~nx0"
		CD "%~n0"
		START "" "%~nx0"
		CD ..
		DEL /Q "%~nx0" && EXIT
:core
		IF EXIST "prismlauncher.exe" (
			ECHO %~n0 уже установлен ^<3 . . .
			PAUSE
			EXIT
		)
	MD "temp"
	ECHO Загрузка %~n0 . . .
		CURL -RL# -o "temp\%~n0.zip" "https://github.com/PrismLauncher/PrismLauncher/releases/download/9.4/PrismLauncher-Windows-MSVC-Portable-9.4.zip"
::	ECHO Распаковка %~n0 . . .
		TAR -xf "temp\%~n0.zip"
:userdata
::	ECHO Создание файлов настроек . . .
		IF NOT EXIST "userdata" MD "userdata"
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
	ECHO Загрузка картинок котиков . . .
		IF NOT EXIST "userdata\catpacks" MD "userdata\catpacks"
		IF NOT EXIST "userdata\catpacks\3278627.png" CURL -RL# -o "userdata\catpacks\3278627.png" "https://derpicdn.net/img/download/2024/1/11/3278627.png"
::			Проблемы с загрузкой c derpicdn.net? выполняй в powershell Remove-item alias:curl
	IF NOT EXIST "userdata\instances\bta.v7.3_04" (
		MD "userdata\instances\bta.v7.3_04"
		ECHO Загрузка Better than Adventure! . . .
			CURL -RL# -o "temp\bta.v7.3_04.mmc.zip" "https://github.com/Better-than-Adventure/bta-download-repo/releases/download/v7.3_04/bta.v7.3_04.mmc.zip"
::		ECHO Распаковка Better than Adventure! . . .
			TAR -xf "temp\bta.v7.3_04.mmc.zip" -C "userdata\instances\bta.v7.3_04"
			IF NOT EXIST "userdata\icons" MD "userdata\icons"
			IF NOT EXIST "userdata\icons\v7_3_04.png" COPY "userdata\instances\bta.v7.3_04\v7_3_04.png" "userdata\icons\v7_3_04.png" > NUL
	) ELSE ECHO Better than Adventure! уже установлен ^<3 . . .
:end
::	ECHO Очистка установочных файлов . . .
		RD /S /Q "temp"
	ECHO.
	ECHO.
	ECHO.
	ECHO Исполняемый файл: "%~n0\prismlauncher.exe"
	ECHO Русский язык применится при втором запуске
	ECHO Для запуска Better than Adventure! нужна Adoptium Java 17
	PAUSE
	START "" "https://github.com/Croupier42/Portable-installer-bat-files"
	EXIT
