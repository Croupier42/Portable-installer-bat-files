::	Mozilla Firefox (часть 25)	https://forum.ru-board.com/topic.cgi?forum=5&topic=51478&glp
::	Дополнить user_pref https://forum.ru-board.com/topic.cgi?forum=2&topic=5924&start=0&limit=1&m=1#1
::	Zen config	https://docs.zen-browser.app/guides/about-config-flags
::	Добавить настройки поисковых систем, панели инструментов, расширений если возможно
::	Файлов с настройками расширений не нашёл, наверно через мини гайд внутри батника
::	Убрать из распаковки ненужные файлы
::	Добаваить функцию "Сделать браузером по умолчанию"
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
	IF EXIST "core" (
		ECHO Удаление ранее установленного %~n0 . . .
		RD /S /Q "core"
	)
	MD "temp"
	ECHO Загрузка 7zr . . .
		CURL -RL# -o "temp\7zr.exe" "https://www.7-zip.org/a/7zr.exe"
	ECHO Загрузка %~n0 . . .
		CURL -RL# -o "temp\%~n0.7z" "https://github.com/zen-browser/desktop/releases/latest/download/zen.installer.exe"
::	ECHO Распаковка %~n0 . . .
		temp\7zr x -t7z -bso0 "temp\%~n0.7z" -xr!setup.exe -xr!desktop-launcher -xr!uninstall -xr!application.ini -xr!*agent* -xr!*crash* -xr!*maintenance* -xr!*update* -xr!precomplete -xr!removed-files
::	ECHO Создание файла политик policies.json для отключения автообновлений и телеметрии
		IF NOT EXIST "core\distribution" MD "core\distribution"
		ECHO {"policies":{"DisableAppUpdate":true,"DisableTelemetry":true}}>"core\distribution\policies.json"
	ECHO Загрузка libportable . . .
		CURL -RL# -o "temp\libportable.7z" "https://github.com/adonais/libportable/releases/latest/download/portable_bin.7z"
::	ECHO Распаковка portable64.dll . . .
		temp\7zr e -t7z -bso0 "temp\libportable.7z" -o"core" "portable64.dll" -r
::	ECHO Создание файла настроек libportable . . .
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
::	ECHO Редактирование файла зависимостей для запуска libportable . . .
		ECHO portable64.dll > "core\dependentlibs.list.new"
		TYPE "core\dependentlibs.list" >> "core\dependentlibs.list.new"
		MOVE /y "core\dependentlibs.list.new" "core\dependentlibs.list" > NUL
:extensions
	IF NOT EXIST "core\distribution\extensions" MD "core\distribution\extensions"
	ECHO Загрузка AdNauseam . . .
		CURL -RL# -o "core\distribution\extensions\adnauseam@rednoise.org.xpi" "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/"
	ECHO Загрузка Dark Reader . . .
		CURL -RL# -o "core\distribution\extensions\addon@darkreader.org.xpi" "https://addons.mozilla.org/firefox/downloads/latest/darkreader"
	ECHO Загрузка I don't care about cookies . . .
		CURL -RL# -o "core\distribution\extensions\jid1-KKzOGWgsW3Ao4Q@jetpack.xpi" "https://addons.mozilla.org/firefox/downloads/latest/i-dont-care-about-cookies"
	ECHO Загрузка Imagus mod . . .
		CURL -RL# -o "core\distribution\extensions\{6833a9cb-d329-4d96-a062-76b1b663cd2c}.xpi" "https://addons.mozilla.org/firefox/downloads/latest/imagus-mod/"
	ECHO Загрузка Search By Image . . .
		CURL -RL# -o "core\distribution\extensions\{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}.xpi" "https://addons.mozilla.org/firefox/downloads/latest/search_by_image/"
	ECHO Загрузка Simple Translate . . .
		CURL -RL# -o "core\distribution\extensions\simple-translate@sienori.xpi" "https://addons.mozilla.org/firefox/downloads/latest/simple-translate/"
	ECHO Загрузка SponsorBlock . . .
		CURL -RL# -o "core\distribution\extensions\sponsorBlocker@ajay.app.xpi" "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/"
:userdata
::	ECHO Создание главного файла настроек prefs.js . . .
		IF NOT EXIST "userdata" MD "userdata"
		(
			ECHO // Настройки кеша insorg
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
			ECHO // Настройки телеметрии insorg
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
			ECHO // Мои настройки
			ECHO // Интерфейс
			ECHO user_pref^("zen.welcome-screen.seen", true^); // Начальный экран просмотрен
			ECHO user_pref^("zen.theme.content-element-separation", 0^); // Убрать рамку вокруг окна
			ECHO user_pref^("zen.view.experimental-no-window-controls", true^); // Убрать верхнюю панель
			ECHO user_pref^("zen.view.compact.enable-at-startup", true^); // Включить компактный вид
			ECHO user_pref^("zen.view.compact.hide-toolbar", true^); // Скрыть обе панели
			ECHO user_pref^("zen.tabs.show-newtab-vertical", false^); // Показывать иконку новой вкладки
			ECHO user_pref^("toolkit.legacyUserProfileCustomizations.stylesheets", true^); // Включить userChrome.css
			ECHO user_pref^("layout.testing.scrollbars.always-hidden", true^); // Скрыть скроллбар
			ECHO user_pref^("intl.locale.requested", "ru,en-US"^); // Язык
			ECHO user_pref^("browser.translations.neverTranslateLanguages", "en,ru"^); // Не переводить эти языки
			ECHO user_pref^("media.videocontrols.picture-in-picture.video-toggle.enabled", false^); // Картинка в картинке
			ECHO // Разрешения
			ECHO user_pref^("permissions.default.geo", 2^); // Отключить геолокацию
			ECHO user_pref^("permissions.default.camera", 2^); // Отключить камеру
			ECHO user_pref^("permissions.default.microphone", 2^); // Отключить микрофон
			ECHO user_pref^("permissions.default.desktop-notification", 2^); // Отключить уведомления
			ECHO // Остальное
			ECHO user_pref^("browser.aboutConfig.showWarning", false^); // Предупреждение about:config
			ECHO user_pref^("browser.shell.checkDefaultBrowser", false^); // Проверять установлен ли браузер по умолчанию
			ECHO user_pref^("browser.download.useDownloadDir", false^); // Спрашивать куда загружать файл
			ECHO user_pref^("signon.generation.enabled", false^); // Предлагать надёжные пароли
			ECHO user_pref^("signon.firefoxRelay.feature", "disabled"^); // Предлагать псевдонимы...
			ECHO user_pref^("signon.management.page.breach-alerts.enabled", false^); // Показывать уведомления...
			ECHO user_pref^("extensions.formautofill.creditCards.enabled", false^); // Сохранять карты
			ECHO user_pref^("browser.safebrowsing.malware.enabled", false^); // Блокировать опасные загрузки
			ECHO user_pref^("browser.safebrowsing.phishing.enabled", false^); // Блокировать фишинговые сайты
			ECHO user_pref^("dom.security.https_only_mode", true^); // Только HTTPS
			ECHO user_pref^("doh-rollout.disable-heuristics", true^); // Отключить DoH
		)>"userdata\prefs.js"
::	ECHO Создание  файла стилей userChrome.css . . .
		IF NOT EXIST "userdata\chrome" MD "userdata\chrome"
		(
			ECHO .zen-current-workspace-indicator { display: none !important; } /* Убрать индикатор рабочего пространства */
			ECHO #TabsToolbar { -moz-window-dragging: no-drag !important; } /* Отключить перетаскивание окна */
		)>"userdata\chrome\userChrome.css"
:end
::	ECHO Очистка установочных файлов . . .
		RD /S /Q "temp"
	ECHO.
	ECHO.
	ECHO.
	ECHO Исполняемый файл: "%~n0\core\zen.exe"
	ECHO Осталось вручную настроить поисковые системы, панели инструментов и расширения
	PAUSE
	START "" "https://github.com/Croupier42/Portable-installer-bat-files"
	EXIT