@ECHO OFF
CHCP 65001 > NUL
::	Mozilla Firefox (часть 25)	https://forum.ru-board.com/topic.cgi?forum=5&topic=51478&glp
::	Дополнить user_pref https://forum.ru-board.com/topic.cgi?forum=2&topic=5924&start=0&limit=1&m=1#1
::	Zen config	https://docs.zen-browser.app/guides/about-config-flags

::	Название директории
SET DirName=ZenBrowser
::	Обновление
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
::	Удаление директории core при обновлении
IF %Update% == 0 IF EXIST "core" GOTO config
IF EXIST "core" DEL "core" /q

	ECHO Загрузка 7zr . . .
CURL -RL# "https://www.7-zip.org/a/7zr.exe" -o "7zr.exe"
	ECHO Загрузка %DirName% . . .
CURL -RL# "https://github.com/zen-browser/desktop/releases/latest/download/zen.installer.exe" -o "%DirName%.7z"
	ECHO Распаковка %DirName% . . .
"7zr.exe" x -t7z -bso0 "%DirName%.7z" -xr!setup.exe -xr!desktop-launcher -xr!uninstall -xr!application.ini -xr!*agent* -xr!*crash* -xr!*maintenance* -xr!*update* -xr!precomplete -xr!removed-files
	ECHO Загрузка libportable . . .
CURL -RL# "https://github.com/adonais/libportable/releases/latest/download/portable_bin.7z" -o "libportable.7z"
	ECHO Распаковка portable64.dll . . .
"7zr.exe" e -t7z -bso0 "libportable.7z" -o"core" "portable64.dll" -r

	ECHO Создание файла настроек libportable . . .
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

	ECHO Редактирование файла зависимостей для запуска libportable . . .
ECHO portable64.dll > "core\dependentlibs.list.new"
TYPE "core\dependentlibs.list" >> "core\dependentlibs.list.new"
MOVE /y "core\dependentlibs.list.new" "core\dependentlibs.list" > NUL

:extensions
::	Установка расширений
IF NOT EXIST "core\distribution\extensions" MD "core\distribution\extensions"
	ECHO Загрузка AdNauseam . . .
CURL -RL# "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/" -o "core\distribution\extensions\adnauseam@rednoise.org.xpi"
	ECHO Загрузка Dark Reader . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/darkreader -o "core\distribution\extensions\addon@darkreader.org.xpi"
	ECHO Загрузка I don't care about cookies . . .
CURL -RL# "https://addons.mozilla.org/firefox/downloads/latest/i-dont-care-about-cookies" -o "core\distribution\extensions\jid1-KKzOGWgsW3Ao4Q@jetpack.xpi"
	ECHO Загрузка Imagus mod . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/imagus-mod/ -o "core\distribution\extensions\{6833a9cb-d329-4d96-a062-76b1b663cd2c}.xpi"
	ECHO Загрузка Search By Image . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/search_by_image/ -o "core\distribution\extensions\{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}.xpi"
	ECHO Загрузка Simple Translate . . .
CURL -RL# https://addons.mozilla.org/firefox/downloads/latest/simple-translate/ -o "core\distribution\extensions\simple-translate@sienori.xpi"
	ECHO Загрузка SponsorBlock . . .
CURL -RL# "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/" -o "core\distribution\extensions\sponsorBlocker@ajay.app.xpi"

:clean
	ECHO Очистка установочных файлов . . .
DEL "7zr.exe" "%DirName%.7z" "libportable.7z" /q

:config
	ECHO Создание файлов настроек . . .

::	policies.json	Отключение автообновления и телеметрии
IF NOT EXIST "core\distribution" MD "core\distribution"
(
ECHO {"policies":{"DisableAppUpdate":true,"DisableTelemetry":true}}
)>"core\distribution\policies.json"

::	prefs.js	Главный файл настроек
IF NOT EXIST "userdata" MD "userdata"
(
ECHO //Настройки кеша insorg
ECHO user_pref^("browser.cache.disk.capacity", 0^);
ECHO user_pref^("browser.cache.disk.enable", false^);
ECHO user_pref^("browser.cache.disk.smart_size.enabled", false^);
ECHO user_pref^("browser.cache.disk.smart_size.first_run", false^);
ECHO user_pref^("browser.cache.disk_cache_ssl", false^);
ECHO user_pref^("browser.cache.memory.capacity", -1^);
ECHO user_pref^("browser.cache.offline.enable", false^);
ECHO user_pref^("browser.cache.offline.insecure.enable", false^);
ECHO user_pref^("browser.cache.offline.storage.enable", false^);
ECHO user_pref^("extensions.getAddons.cache.enabled", false^);
ECHO user_pref^("gfx.canvas.skiagl.dynamic-cache", false^);
ECHO user_pref^("intl.charsetmenu.browser.cache", "UTF-8"^);
ECHO user_pref^("pdfjs.enabledCache.state", false^);
ECHO //Настройки телеметрии insorg
ECHO user_pref^("browser.newtabpage.activity-stream.feeds.telemetry", false^);
ECHO user_pref^("browser.newtabpage.activity-stream.telemetry", false^);
ECHO user_pref^("browser.newtabpage.activity-stream.telemetry.ping.endpoint", ""^);
ECHO user_pref^("browser.newtabpage.activity-stream.telemetry.structuredIngestion", false^);
ECHO user_pref^("browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint", ""^);
ECHO user_pref^("browser.ping-centre.telemetry", false^);
ECHO user_pref^("browser.search.serpEventTelemetryCategorization.enabled", false^);
ECHO user_pref^("devtools.onboarding.telemetry.logged", false^);
ECHO user_pref^("media.wmf.deblacklisting-for-telemetry-in-gpu-process", false^);
ECHO user_pref^("security.app_menu.recordEventTelemetry", false^);
ECHO user_pref^("security.certerrors.recordEventTelemetry", false^);
ECHO user_pref^("security.identitypopup.recordEventTelemetry", false^);
ECHO user_pref^("security.protectionspopup.recordEventTelemetry", false^);
ECHO user_pref^("toolkit.telemetry.archive.enabled", false^);
ECHO user_pref^("toolkit.telemetry.bhrPing.enabled", false^);
ECHO user_pref^("toolkit.telemetry.cachedClientID", ""^);
ECHO user_pref^("toolkit.telemetry.enabled", false^);
ECHO user_pref^("toolkit.telemetry.firstShutdownPing.enabled", false^);
ECHO user_pref^("toolkit.telemetry.hybridContent.enabled", false^);
ECHO user_pref^("toolkit.telemetry.newProfilePing.enabled", false^);
ECHO user_pref^("toolkit.telemetry.optoutSample", false^);
ECHO user_pref^("toolkit.telemetry.pioneer-new-studies-available", false^);
ECHO user_pref^("toolkit.telemetry.reportingpolicy.firstRun", false^);
ECHO user_pref^("toolkit.telemetry.server", ""^);
ECHO user_pref^("toolkit.telemetry.shutdownPingSender.enabled", false^);
ECHO user_pref^("toolkit.telemetry.shutdownPingSender.enabledFirstSession", false^);
ECHO user_pref^("toolkit.telemetry.unified", false^);
ECHO user_pref^("toolkit.telemetry.updatePing.enabled", false^);
ECHO user_pref^("toolkit.telemetry.unifiedIsOptIn", false^);
ECHO //Мои настройки
ECHO user_pref^("toolkit.legacyUserProfileCustomizations.stylesheets", true^); //Включить .css
ECHO user_pref^("layout.testing.scrollbars.always-hidden", true^); //Скрыть скроллбар
ECHO user_pref^("browser.shell.checkDefaultBrowser", false^); //Проверять установлен ли браузер по умолчанию
ECHO user_pref^("intl.locale.requested", "ru,en-US"^); //Язык
ECHO user_pref^("browser.translations.neverTranslateLanguages", "en,ru"^); //Не переводить эти языки
ECHO user_pref^("browser.download.useDownloadDir", false^); //Спрашивать куда загружать файл
ECHO user_pref^("media.videocontrols.picture-in-picture.video-toggle.enabled", false^); //Картинка в картинке
ECHO user_pref^("signon.generation.enabled", false^); //Предлагать надёжные пароли
ECHO user_pref^("signon.firefoxRelay.feature", "disabled"^); //Предлагать псевдонимы...
ECHO user_pref^("signon.management.page.breach-alerts.enabled", false^); //Показывать уведомления...
ECHO user_pref^("extensions.formautofill.creditCards.enabled", false^); //Сохранять карты
ECHO user_pref^("permissions.default.geo", 2^); //Отключить геолокацию
ECHO user_pref^("permissions.default.camera", 2^); //Отключить камеру
ECHO user_pref^("permissions.default.microphone", 2^); //Отключить микрофон
ECHO user_pref^("permissions.default.desktop-notification", 2^); //Отключить уведомления
ECHO user_pref^("media.autoplay.default", 0^); //Включить автовоспроизведение аудио и видео
ECHO user_pref^("permissions.default.xr", 2^); //Отключить запрос к VR
ECHO user_pref^("browser.safebrowsing.malware.enabled", false^); //Блокировать опасные загрузки
ECHO user_pref^("browser.safebrowsing.phishing.enabled", false^); //Блокировать фишинговые сайты
ECHO user_pref^("dom.security.https_only_mode", true^); //Только HTTPS
ECHO user_pref^("doh-rollout.disable-heuristics", true^); //Отключить DoH
ECHO user_pref^("zen.welcome-screen.seen", true^); //Начальный экран просмотрен
ECHO user_pref^("zen.theme.content-element-separation", 0^); //Убрать рамку вокруг окна
ECHO user_pref^("zen.view.use-single-toolbar", false^); //Несколько панелей
ECHO user_pref^("zen.view.compact.enable-at-startup", true^); //Включить компактный вид
ECHO user_pref^("zen.view.compact.hide-toolbar", true^); //Скрыть обе панели
ECHO user_pref^("zen.tabs.show-newtab-vertical", false^); //Показывать иконку новой вкладки
)>"userdata\prefs.js"

::	userChrome.css	Стили
IF NOT EXIST "userdata\chrome" MD "userdata\chrome"
(
ECHO./* Убрать индикатор рабочего пространства */
ECHO .zen-current-workspace-indicator
ECHO {
ECHO display: none !important;
ECHO }
)>"userdata\chrome\userChrome.css"

ECHO Осталось вручную настроить поисковые системы, панели инструментов, тему и расширения
PAUSE