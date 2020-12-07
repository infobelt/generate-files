::
:: 2017Feb16 install CDF patch into IDL and ENVI
echo off
setlocal EnableDelayedExpansion
echo.   
echo This is the script to install the latest IDL patch from SPDF onto your Windows
echo You may need to enter the administrator account's password.
set CDIR=%cd%
set ftp=https://spdf.gsfc.nasa.gov/pub/software/cdf/dist/cdf38_0/idl
set IDL_Win64=%ftp%/windows/x64/idl_cdf.dll
set IDL_Win32=%ftp%/windows/x86/idl_cdf.dll
set IDL_DLM=%ftp%/idl_cdf.dlm
set LEAPS=https://cdf.gsfc.nasa.gov/html/CDFLeapSeconds.txt
set SHOWVERS=%ftp%/showcdfversion.pro
set SHOWVERS2=%ftp%/showcdfversion2.pro
set GET=%CDIR%\wget -nv --no-check-certificate
set VERSION=3.8.0
:: find all installed versions of IDL and ENVI
echo.
echo This is the list of currently available IDL version(s) installed on your 
echo Windows in c:\program files\ directory:
echo.
set ToFind="idl_cdf.dll$"
dir /s/b "c:\program files\harris" "c:\program files\exelis" "c:\program files\itt" 2> nul | findstr %ToFind% > myidl.txt
set /a fn=0
FOR /f "delims="  %%a in ('type myidl.txt') do (
  set /a fn+=1
  set "line[!fn!]=%%a"
)

rem Display array elements
For /L %%i in (1,1,%fn%) do (
  rem echo "%%i" ) "!line[%%i]!"
  echo %%i^) !line[%%i]:~0,-12!
)
set /p idlid="Select a number from above list to be replaced by the latest patch: "
if %idlid% geq 1 if %idlid% leq %fn% goto :goodone
  echo %idlid%: bad input
  goto :toend
:goodone
echo.
echo You picked !line[%idlid%]! which is number %idlid%
for /F "tokens=4 delims=\" %%a in ("!line[%idlid%]!") do (
  echo %%a
  set selected=%%a
)
set IDL_DM=%IDL_DLM%
if not x"!line[%idlid%]:x86_64=!" == x"!line[%idlid%]!" (
    set IDL_DLL=%IDL_Win64%
) else (
  if not !"%line[%idlid%]:x86=!" == x"!line[%idlid%]!" (
    set IDL_DLL=%IDL_Win32%
  ) else (
    echo Error: require IDL/ENVI bin path for Windows 32/64
    goto :toend
  )
)
for /F "tokens=2,3,4 delims=/ " %%a in ('date /t') do (
  set todayT=%%c%%a%%b
)
for /F "tokens=1,2,3 delims=: " %%a in ('time /t') do (
  set timeT=%%a%%b%%c
)
set TEMPDIRx=idl_save_%selected%_%todayT%%timeT%
echo Saving old and new files to %TEMPDIRx%
mkdir %TEMPDIRx% 
cd %TEMPDIRx%
echo %GET% %IDL_DLL%
%GET% %IDL_DLL%
if %errorlevel% neq 0 (
   echo Error: failed %GET% %IDL_DLL%
   goto :toend
)
echo. 
echo %GET% %IDL_DM%
%GET% %IDL_DM%
if %errorlevel% neq 0 (
   echo Error: failed %GET% %IDL_DM%
   goto :toend
)
echo.
echo %GET% %LEAPS%"
%GET% %LEAPS%
if %errorlevel% neq 0 (
   echo Error: failed %GET% %LEAPS%
   goto :toend
)
echo.
echo %GET% %SHOWVERS%
%GET% %SHOWVERS%
if %errorlevel% neq 0 ( 
   echo Error: failed %GET% %SHOWVERS%
   goto :toend
)
echo.
echo %GET% %SHOWVERS2%
%GET% %SHOWVERS2%
if %errorlevel% neq 0 ( 
   echo Error: failed %GET% %SHOWVERS%
   goto :toend
)
set opt=!line[%idlid%]:~0,-12!
echo dir=%opt%
cd "%opt%"
echo current dir=!cd!
set mydate=%date:~10,4%-%date:~7,2%-%date:~4,2%
if not exist idl_cdf.dll-orig-%mydate% (
   rename idl_cdf.dll idl_cdf.dll-orig-%mydate%
   rename idl_cdf.dlm idl_cdf.dlm-orig-%mydate%
)
echo copy /y "%CDIR%\%TEMPDIRx%\idl_cdf.dll" .
copy /y "%CDIR%\%TEMPDIRx%\idl_cdf.dll" .
copy /y "%CDIR%\%TEMPDIRx%\idl_cdf.dlm" .
cd "%CDIR%"
::  echo to temp: %CDIR%\%TEMPDIRx%
echo.
echo Testing the installation... for version: %VERSION%
echo.
if exist "!line[%idlid%]!\..\..\..\resource\xprinter" (
   set XPPATH="!line[%idlid%]!\..\..\..\resource\xprinter"
)
set IDL_STARTUP="%CDIR%\%TEMPDIRx%\showcdfversion2.pro"
set IDL_DIR="!line[%idlid%]!\..\..\.."
"!line[%idlid%]!\..\idl" >%CDIR%\%TEMPDIRx%\myout.txt
type %CDIR%\%TEMPDIRx%\myout.txt
echo.
echo.
echo The patch (for .dll and .dlm) is installed in %opt%
echo.
echo NOTE: The original version (.dlm and .dll) there are saved and renamed
echo       with "-orig-%mydate%" appended to the files.
echo.
del %TEMPDIRx%\showcdfversion.pro
rem %TEMPDIRx%\showcdfversion2.pro
rem %CDIR%\%TEMPDIRx%\myout.txt
del %CDIR%\myidl.txt
:toend
endlocal

