@echo off

set STUDIO_PATH=%~dp0
set DOT_STUDIO="%UserProfile%\.studio"

:: Prefer bundled JRE if available
set JAVA_BIN=%STUDIO_PATH%\runtime\bin\java.exe
if not exist "%JAVA_BIN%" set JAVA_BIN=java

:: Make sure the .studio subdirectories exist
if not exist %DOT_STUDIO%\db\* mkdir %DOT_STUDIO%\db
if not exist %DOT_STUDIO%\library\* mkdir %DOT_STUDIO%\library

"%JAVA_BIN%" -Dvertx.disableDnsResolver=true -Dfile.encoding=UTF-8 ^
 -cp "%STUDIO_PATH%/${project.build.finalName}.jar";"%STUDIO_PATH%/lib/*";. ^
 io.vertx.core.Launcher run ${vertx.main.verticle}
