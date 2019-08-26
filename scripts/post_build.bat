@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET CONFIGURATION=%~1
SET VERSION=%~2
SET PROJECTDIR=%CD%
SET TARGETDIR=%PROJECTDIR%\bin\%CONFIGURATION%

PUSHD ..\..
ECHO %CD%
SET ROOTDIR=%CD%
POPD

ECHO Step 1/4: Restoring original AssemblyInfo.cs...
DEL /Q "%PROJECTDIR%\Properties\AssemblyInfo.cs"
MOVE "%PROJECTDIR%\Properties\AssemblyInfo.cs.tmp" "%PROJECTDIR%\Properties\AssemblyInfo.cs"

ECHO Step 2/4: Copying language and .exe files...
XCOPY /S /Y /F "%PROJECTDIR%\Translations\*" "%TARGETDIR%\MLauncher-langs\"
XCOPY /S /Y /F "%TARGETDIR%\MLauncher.exe" "%PROJECTDIR%\"

IF NOT "%CONFIGURATION%" == "Release" (
	ECHO Detected non-release configuration.
	GOTO FINISH
)

ECHO Step 3/4: Cleaning-up TARGETDIR...
DEL /Q "%TARGETDIR%\*.?db" "%TARGETDIR%\*.xml" "%TARGETDIR%\zip\"

ECHO Step 4/4: Creating zip archive with languages...
WHERE 7z >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
	ECHO 7z not found being installed.
	GOTO FINISH
)
7z a "%TARGETDIR%\MLauncher.zip" "%TARGETDIR%\MLauncher.exe" "%TARGETDIR%\MLauncher-langs\" -r
IF NOT DEFINED DLLS (
	GOTO FINISH
)

:FINISH
ECHO Finishing script...
