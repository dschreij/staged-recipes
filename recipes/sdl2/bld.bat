:: MSVC library for Python 2.7 is not found automaticaly if it is 
:: installed in the user's AppData folder. Add it to PATH
setlocal EnableDelayedExpansion

set TARGET=Release
:: Set target back to Debug for 64-bits builds with VS2008 and VS2010
if %VS_MAJOR% LSS 14 (
	if %ARCH% == 64 (
		set TARGET=Debug
	)
)

:: When installing Visual C++ compiler tools for Python 2.7, all files are placed in the users AppData folder
:: conda-bld tries to call vcvarsall at its classic location, which of course fails, so we have to call it from its
:: new location in the the users appdata folder manually, but only if this folder exists of course.
if "%PY_VER%"=="2.7" (
	set VC9DIR="%LOCALAPPDATA%\Programs\Common\Microsoft\Visual C++ for Python\9.0"
	:: set DXSDK_DIR="%programfiles(x86)%\Microsoft SDKs\Windows\v7.1A" :: Doesn't really work, only finds directx partially
	IF EXIST !VC9DIR! ( 
		if %ARCH% == 32 set VC_ARCH=x86
		if %ARCH% == 64 set VC_ARCH=amd64
		call !VC9DIR!\vcvarsall.bat !VC_ARCH!
	)
	set DIRECTX_FLAG="-DDIRECTX=OFF "
)
if errorlevel 1 exit 1

:: Go to the source folder
cd %SRC_DIR%
mkdir build
cd build

call %LIBRARY_BIN%\cmake -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" -DCMAKE_BUILD_TYPE:STRING=!TARGET! !DIRECTX_FLAG! .. 
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1