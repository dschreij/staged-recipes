@echo off
:: MSVC library for Python 2.7 is not found automaticaly if it is 
:: installed in the user's AppData folder. Add it to PATH
setlocal EnableDelayedExpansion

if "%PY_VER%"=="2.7" (
	set VC9DIR=%LOCALAPPDATA%\Programs\Common\Microsoft\Visual C++ for Python\9.0
	IF EXIST !VC9DIR! ( 
		:: set PATH=!VC9DIR!;"%PATH%"
		if %ARCH% == 32 set VC_ARCH=x86
		if %ARCH% == 64 set VC_ARCH=amd64
		call !VC9DIR!\vcvarsall.bat !VC_ARCH!
		:: vcvarsall does something strange with PATH, preventing xcopy to be found later. Fix this
		:: set PATH=!PATH!;%SYSTEMROOT%\system32
	)
)
if errorlevel 1 exit 1

:: Go to the source folder
cd %SRC_DIR%
mkdir build
cd build

call %LIBRARY_BIN%\cmake .. -G "NMake Makefiles" -D DESTINATION:FILEPATH="%LIBRARY_PREFIX%"
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1