@echo off

REM main script
SETLOCAL
SET logPath=".\logs"
SET today=%DATE%
SET logFilename=checkFolderIfEmpty-%today%.log
SET incomingFolderPath=".\incoming"

REM ECHO calling check directory is empty function
CALL :check_directory_is_empty ret_value
IF %ret_value%==empty (
    ECHO %DATE%-%TIME% : Exiting script >> %logPath%\%logFilename%
    ) ELSE (
        ECHO %DATE%-%TIME% :Do next stuff >> %logPath%\%logFilename%
    )

ENDLOCAL
rem pause

REM to exit main script
EXIT /B %ERRORLEVEL%


REM functions definitions

REM check if directory is empty
:check_directory_is_empty
SETLOCAL
SET fileFound=false
CD %incomingFolderPath%
DIR /B *.txt > tempOutput
SET /P fileFound=<tempOutput
del tempOutput
IF %fileFound%==false (
    REM ECHO "folder is empty"
    ECHO %DATE%-%TIME% : Checking if incoming folder is empty: empty >> %logPath%\%logFilename%
    ENDLOCAL
    SET %~1=empty
) ELSE (
    REM ECHO "folder is not empty"
    ECHO %DATE%-%TIME% : Checking if incoming folder is empty: Not empty >> %logPath%\%logFilename%
    FOR /F %%i IN ('DIR /B *.txt') DO MOVE %%i .\in_progress\ > NUL && ECHO %DATE%-%TIME% : Moving file %%i to in_progress folder >> %logPath%\%logFilename%
    ENDLOCAL
    SET %~1=not empty
)
CD ..
EXIT /B 0

:check_directory_is_empty_version_2
SET inPath=%~2
SET fileFound=false
CD %inPath%
FOR /F %%i IN ('DIR /B *.txt') DO SET fileFound=%%i
IF %fileFound%==false (
    REM ECHO "folder is empty"
    SET %~1=empty
) ELSE (
    REM ECHO "folder is not empty"
    SET %~1=not empty
)
CD ..
EXIT /B 0
