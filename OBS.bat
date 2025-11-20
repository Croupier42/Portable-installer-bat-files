::	Сделать CURL по последнему релизу
::	Добавить настройки OBS
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
	IF EXIST "bin" (
		ECHO Удаление ранее установленного %~n0 . . .
		RD /S /Q "bin"
	)
		IF EXIST "data" RD /S /Q "data"
		IF EXIST "obs-plugins" RD /S /Q "obs-plugins"
	MD "temp"
	ECHO Загрузка %~n0 . . .
		CURL -RL# -o "temp\%~n0.zip" "https://github.com/obsproject/obs-studio/releases/download/32.0.2/OBS-Studio-32.0.2-Windows-x64.zip"
::	ECHO Распаковка %~n0 . . .
		TAR -xf "temp\%~n0.zip"
	ECHO Загрузка win-capture-audio . . .
		CURL -RL# -o "temp\win-capture-audio.zip" "https://github.com/bozbez/win-capture-audio/releases/download/v2.2.3-beta/win-capture-audio-2.2.3-beta.zip"
::	ECHO Распаковка portable64.dll . . .
		TAR -xf "temp\win-capture-audio.zip"
::	ECHO Создание файла portable_mode.txt для работы OBS в портативном режиме . . .
	IF NOT EXIST "portable_mode.txt" BREAK > "portable_mode.txt"
:clean
::	ECHO Очистка установочных файлов . . .
		RD /S /Q "temp"
:userdata
	ECHO.
	ECHO.
	ECHO.
	ECHO Исполняемый файл браузера: "%~n0\bin\64bit\obs64.exe"
	ECHO Автор скрипта не умеет в настройки OBS через файлы, так что придётся это делать ручками
	ECHO Пы.Сы. научите в настройки, очень хочется ^<3
:end
	PAUSE
	START "" "https://github.com/Croupier42/Portable-installer-bat-files"
	EXIT