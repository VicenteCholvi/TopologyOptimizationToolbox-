@rem  BAT file generated from the d:/program files/mscnastran/nastran/msc20191/win64i8/nastran.lcl
@rem  template file for Windows NT/2K/XP/.NET 2003/...
@rem  for Local Job processing
@rem
@rem Run MSC Nastran on the local node.
@rem
@rem THIS PROGRAM IS CONFIDENTIAL AND A TRADE SECRET OF THE MSC.SOFTWARE
@rem CORPORATION.  THE RECEIPT OR POSSESSION OF THIS PROGRAM DOES NOT CONVEY ANY
@rem RIGHTS TO REPRODUCE OR DISCLOSE ITS CONTENTS, SELL, LEASE, OR OTHERWISE
@rem TRANSFER IT TO ANY THIRD PARTY, IN WHOLE OR IN PART, WITHOUT THE SPECIFIC
@rem WRITTEN CONSENT OF THE MSC.SOFTWARE CORPORATION.
@rem
@setlocal
@echo off
set outnt=./011
set outnt=%outnt:/=\%
set archdir=d:/program files/mscnastran/nastran/msc20191/win64i8
set archdir=%archdir:/=\%
set archdir=%archdir:win64i4=win64i8%
set MKL_INTERFACE_LAYER=ILP64 
set datecmd=d:/program files/mscnastran/nastran/msc20191/win64i8/mscdate
set datecmd=%datecmd:/=\%
set exedir=
set jobnt=./011.T5952_37
set jobnt=%jobnt:/=\%
set lognt=./011.log
set lognt=%lognt:/=\%
set modedir=
set nastcmd=d:/program files/mscnastran/nastran/msc20191/win64i8/nastran.exe
set nastcmd=%nastcmd:/=\%
set nastcmd=%nastcmd:win64i4=win64i8%
set sdirnt=d:/scratch
set sdirnt=%sdirnt:/=\%
set solver=d:/program files/mscnastran/nastran/msc20191/win64i8/analysis.exe
set solver=%solver:/=\%
set tcmdopt=
set tcmd=d:/program files/mscnastran/nastran/msc20191/win64i8/msctime
set tcmd=%tcmd:/=\%
set user=vtech
set MSC_BASE=d:/program files/mscnastran/nastran
set MSC_VERSD=msc20191
set MSC_ARCH=win64i8
set MSC_BASE=%MSC_BASE:/=\%
set MSC_VERSD=%MSC_VERSD:/=\%
set MSC_ARCH=%MSC_ARCH:/=\%
set MSC_ARCH=%MSC_ARCH:win64i4=win64i8%
set MSC_LICENSE_FILE=edu
set MSC_LICENSE_FILE=%MSC_LICENSE_FILE:/=\%
set DBSDIR=d:/scratch
set JIDDIR=d:/aegis/documents/tfg/testfea/patr
set MSC_APP=no
set MSC_AUTH=edu
set MSC_BASE=d:/program files/mscnastran/nastran
set MSC_DBS=d:/scratch/011.T5952_37
set MSC_EXE='d:/program files/mscnastran/nastran/msc20191/win64i8/analysis.exe'
set MSC_ISHELLPATH=d:/aegis/documents/tfg/testfea/patr
set MSC_ISHELLEXT=
set MSC_JID=D:\aegis\Documents\TFG\TESTFEA\PATR\011.bdf
set MSC_JIDPATH=
set MSC_JIDTYPE=.bdf
set MSC_MEM=527MB
set MSC_OLD=yes
set MSC_OUT=./011
set MSC_SCR=yes
set MSC_SDIR=d:/scratch
set MSC_VERSD=msc20191
set OUTDIR=.
set TMP=c:/users/vtech/appdata/local/temp
set MSC_SQAS_MESSAGE_FILE='d:/program files/mscnastran/nastran\msc20191\win64i8\analysis.msg'
if not "%DBSDIR%" == "" set DBSDIR=%DBSDIR:/=\%
if not "%JIDDIR%" == "" set JIDDIR=%JIDDIR:/=\%
if not "%MSC_BASE%" == "" set MSC_BASE=%MSC_BASE:/=\%
if not "%MSC_DBS%" == "" set MSC_DBS=%MSC_DBS:/=\%
if not "%MSC_EXE%" == "" set MSC_EXE=%MSC_EXE:/=\%
if not "%MSC_ISHELLPATH%" == "" set MSC_ISHELLPATH=%MSC_ISHELLPATH:/=\%
if not "%MSC_JID%" == "" set MSC_JID=%MSC_JID:/=\%
if not "%MSC_JIDPATH%" == "" set MSC_JIDPATH=%MSC_JIDPATH:/=\%
if not "%MSC_OUT%" == "" set MSC_OUT=%MSC_OUT:/=\%
if not "%MSC_SDIR%" == "" set MSC_SDIR=%MSC_SDIR:/=\%
if not "%OUTDIR%" == "" set OUTDIR=%OUTDIR:/=\%
if not "%TMP%" == "" set TMP=%TMP:/=\%
set MSC_ARCHD=%MSC_ARCH%
set MSC_ARCHM=%MSC_ARCH%
set HDF5_DISABLE_VERSION_CHECK=1
set MKL_PARDISO_OOC_CFG_PATH=%MSC_SDIR%
set MKL_PARDISO_OOC_CFG_FILE_NAME=
for %%f in (%MSC_DBS%) do set MKL_PARDISO_OOC_CFG_FILE_NAME=%%~nxf
set MKL_PARDISO_OOC_PATH=%MSC_SDIR%\%MKL_PARDISO_OOC_CFG_FILE_NAME%_ooc
set MKL_PARDISO_OOC_CFG_FILE_NAME=%MKL_PARDISO_OOC_CFG_FILE_NAME%_ooc.cfg
if "%MSC_SQAS_MESSAGE_FILE%" == "" (
   set MSC_SQAS_MESSAGE_FILE=%MSC_BASE%\%MSC_VERSD%\%MSC_ARCH%\analysis.msg
)
if "%SCA_SERVICE_CATALOG%" == "" (
  set SCA_SERVICE_CATALOG=%MSC_BASE%\%MSC_VERSD%\res\SCAServiceCatalog.xml
) else (
  set SCA_SERVICE_CATALOG=%SCA_SERVICE_CATALOG%;%MSC_BASE%\%MSC_VERSD%\res\SCAServiceCatalog.xml
)
if "%SCA_RESOURCE_DIR%" == "" (
  set SCA_RESOURCE_DIR=%MSC_BASE%\%MSC_VERSD%\res
) else (
  set SCA_RESOURCE_DIR=%SCA_RESOURCE_DIR%;%MSC_BASE%\%MSC_VERSD%\res
)
set dashes=-----------------------------------------------------------------
set findstr="%windir%\system32\findstr.exe"
set stars= ****************
set MSC_MSG=stderr
set MSC_SRV=
for /f "tokens=*" %%g in ('cd') do set CPWD=%%g
set PWD=D:\aegis\Documents\TFG\TESTFEA\PATR
set PWD=%PWD:/=\%
cd /d %PWD%
for /f "tokens=*" %%g in ('"%datecmd%"') do set startdate=%%g
@rem
@rem Save the old output files.
@rem
set /a maxvernum = -1
for %%f in (f06 f04 log ndb op2 pch plt acg h5 mtx.h5 mdl.h5 asm becho marc.dat marc.log marc.out marc.sts marc.t16 marc.t19 des mnf PCS aeso sts out) do (
   for /f "tokens=*" %%g in ('^( dir /b "%outnt%.%%f*" 2^>nul: ^| %findstr% /r /i "\.%%f\.[0-9][0-9]*$" ^)') do call :getvernum %%g
)
if /i %maxvernum% lss 0 set /a maxvernum = 0
set /a maxvernum = %maxvernum% + 1
for %%f in (f06 f04 log ndb op2 pch plt acg h5 mtx.h5 mdl.h5 asm becho marc.dat marc.log marc.out marc.sts marc.t16 marc.t19 des mnf PCS aeso sts out) do (
  if exist "%outnt%.%%f" move /y "%outnt%.%%f" "%outnt%.%%f.%maxvernum%" 1>nul: 2>nul:
)
for %%f in (op2) do (
  setlocal EnableDelayedExpansion
  for %%i in (%outnt%) do set fname=%%~ni
  for %%i in (%outnt%) do set dpname=%%~dpi
  set /a maxvernum = 0
  for /f "tokens=*" %%g in ('^( dir /b "%outnt%.%%f.*" 2^>nul: ^| %findstr% /r /i "!fname!-[0-9][0-9]*\.%%f\.[0-9][0-9]*$" ^)') do (
    call :getvernum %%g
  )
  set /a maxvernum = !maxvernum! + 1
  for /f "tokens=*" %%g in ('^( dir /b "%outnt%.%%f" 2^>nul: ^| %findstr% /r /i "!fname!-[0-9][0-9]*\.%%f" ^)') do (
    if exist "!dpname!%%g" move /y "!dpname!%%g" "!dpname!%%g.!maxvernum!" 1>nul: 2>nul:
  )  
  endlocal
)
set /a maxvernum = 0
for %%f in (log) do (
   for /f "tokens=*" %%g in ('^( dir /b "%outnt%.digimat.%%f*" 2^>nul: ^| %findstr% /r /i "\.%%f\.[0-9][0-9]*$" ^)') do call :getvernum %%g
)
if /i %maxvernum% lss 0 set /a maxvernum = 0
set /a maxvernum = %maxvernum% + 1
for %%f in (log) do (
  if exist "%outnt%.digimat.%%f" move /y "%outnt%.digimat.%%f" "%outnt%.digimat.%%f.%maxvernum%" 1>nul: 2>nul:
)
@rem
if ""==""    goto rcfile 
if ""=="yes" goto rcfile
@REM echo "j.ext_xdb=xdb xdbold="
@rem
for %%f in (xdb) do (
)
:rcfile
set asgf=%jobnt%.rcf
set PRINTLOC=^1^>^>"%lognt%" ^2^>^&^1
set PATH=%archdir%;%PATH%
if exist "%archdir%\lib\*.dll" set PATH=%archdir%\lib;%PATH%
if exist "%archdir%\nvidia\*.dll" set PATH=%archdir%\nvidia;%PATH%
if exist "%archdir%\nCode\bin\*.dll" set PYTHONPATH=%PYTHONPATH%;%archdir%\nCode\bin
if exist "%archdir%\nCode\bin\*.dll" set PATH=%archdir%\nCode\bin;%PATH%
if exist "%archdir%\lib\win32\*.dll" set PATH=%archdir%\lib\win32;%PATH%
if exist "%archdir%\lib\win64i4\*.dll" set PATH=%archdir%\lib\win64i4;%PATH%
if exist "%archdir%i8\lib\*.dll" set PATH=%archdir%i8\lib;%PATH%
if not "%SCA_LIBRARY_PATH%" == "" set PATH=%SCA_LIBRARY_PATH%;%PATH%
if not "%LD_LIBRARY_PATH_PRE%" == "" set PATH=%LD_LIBRARY_PATH_PRE%;%PATH%
set VersionLocal=2019.1
set MAIN=%VersionLocal:~0,4%
set SUB=%VersionLocal:~4,2%
set NEW=%VersionLocal:.=FP%
if NOT %SUB%==.0 set VersionLocal=%NEW%
if     %SUB%==.0 set VersionLocal=%MAIN%
echo MSC Nastran V%VersionLocal% (AMD Windows 10 Home 6.2 9200) Control File: %PRINTLOC%
echo %dashes% %PRINTLOC%
type "%asgf%" %PRINTLOC%
echo %dashes% %PRINTLOC%
echo MSC_ISHELLPATH=%MSC_ISHELLPATH% %PRINTLOC%
echo MSC_JIDPATH=%MSC_JIDPATH% %PRINTLOC%
echo PATH=%PATH% %PRINTLOC%
if not "%SCA_LIBRARY_PATH%" == "" (
  echo SCA_LIBRARY_PATH=%SCA_LIBRARY_PATH% %PRINTLOC%
)
echo SCA_SERVICE_CATALOG=%SCA_SERVICE_CATALOG% %PRINTLOC%
echo SCA_RESOURCE_DIR=%SCA_RESOURCE_DIR% %PRINTLOC%
set SOL700=no
set mksol700=no
if "%SOL700%" == "yes" (
   if not exist "./011.sol700.pth" (
      set mksol700=yes
      echo  "%MSC_BASE%\%MSC_VERSD%\dyna\win64\bin\dytrandmp.py" nastran > ./011.sol700.pth
      set  LSTC_VER=""
   )
)
set cmdline=d:\Program Files\MSCNastran\Nastran\msc20191\win64i8\nastran.exe 011.bdf prog=edu auth=edu bat=no
set cmdline=%cmdline:win64i4=win64i8%
echo Cmd Line:    %cmdline% %PRINTLOC%
echo Current Dir: %PWD% %PRINTLOC%
set tcmd=%tcmd:win64i4=win64i8%
echo Time Cmd:    %tcmd%%tcmdopt% %PRINTLOC%
echo Executable:  %solver% %PRINTLOC%
if not "%MSC_USER_ARCH%" == "" echo Arch= Kywd:  %MSC_USER_ARCH%  %PRINTLOC%
if "%MSC_USER_ARCH%" == "" echo Arch= Kywd:  [Not specified]  %PRINTLOC%
echo MSC_MSG:     stderr  %PRINTLOC%
echo FPE:         yes  %PRINTLOC%
echo %dashes% %PRINTLOC%
set modeinfo=
if exist "%nastcmd%" (
   "%nastcmd%" -a0 -c0 limits %modeinfo% %PRINTLOC%
   echo %dashes% %PRINTLOC%
   "%nastcmd%" -a0 -c0 system %modeinfo% %PRINTLOC%
) else (
   echo.
   echo *** ERROR ***
   
   
   echo MODE=I8 was specified, but not found.  Perhaps only the I4 version was installed
   echo MODE=I8 was specified, but not found.  Perhaps only the I4 version was installed >> %lognt%
   echo.
   echo Resource information data not available. %PRINTLOC%
)
echo %dashes% %PRINTLOC%
if not exist "%solver%" (
   echo Executable "%solver%" not found or not executable. %PRINTLOC%
   goto :jobdone
)
echo MSC Nastran started  %startdate% %PRINTLOC%
echo MSC Nastran started  %startdate%
set MSC_ASG=%asgf%
set MSC_MEM=527MB
"%tcmd%"%tcmdopt%    "%solver%"  FPE=yes   %PRINTLOC%
if exist "011.perf" "d:/program files/mscnastran/nastran/bin/msc20191" mscsystem 011.perf >> %lognt%
if exist "%sdirnt%\011.T5952_37.perf" "d:/program files/mscnastran/nastran/bin/msc20191" mscsystem %sdirnt%\011.T5952_37.perf >> %lognt%
@rem
set /a f98 = 0
call :get_file_size  "%sdirnt%\011.T5952_37.f98"
if /i %FILE_SIZE% gtr 0 set /a f98 = 1
set /a f99 = 0
call :get_file_size  "%sdirnt%\011.T5952_37.f99"
if /i %FILE_SIZE% gtr 0 set /a f99 = 1
set /a i = %f98% + %f99%
if /i %i% neq 0 (
   for /F "tokens=*" %%f in ('^(type "%lognt%" ^| %findstr% /L NSEXIT ^)') do set fexit=%%f
   if not "%fexit%" == "" for /f "tokens=*" %%f in ('^( echo "%fexit%" ^| %findstr% /L "(0)" ^)') do set %ferr%=%%f
   if "%ferr%" == "" (
      if /i %f98% neq 0 (
         if /i %f99% neq 0 copy /f /y "%sdirnt%\011.T5952_37.f99"+"%sdirnt%\011.T5952_37.f98" "%outnt%.acms_out"
         if /i %f99% equ 0 copy /f /y "%sdirnt%\011.T5952_37.f98" "%outnt%.acms_out"
      ) else (
         copy /f /y "%sdirnt%\011.T5952_37.f99" "%outnt%.acms_out"
      )
   )
)
@rem
for %%f in ("%sdirnt%\011*_ts_*.dac") do call :delete_job_file "%%f"
for %%f in (dtout msg config) do call :concat_job_file %%f
for %%f in ("%sdirnt%\011.T5952_37.*") do call :delete_job_file "%%f"
for /f "tokens=*" %%g in ('"%datecmd%"') do set enddate=%%g
echo MSC Nastran finished %enddate% %PRINTLOC%
echo MSC Nastran finished %enddate%
for %%f in (ndb op2 pch plt xdb acg h5 mtx.h5 mdl.h5 asm becho marc.dat marc.log marc.out marc.sts marc.t16 marc.t19 des mnf PCS aeso sts) do call :remove_0_file %%f
if exist "%MKL_PARDISO_OOC_CFG_FILE_NAME%" del /f "%MKL_PARDISO_OOC_CFG_FILE_NAME%"
if exist "%MKL_PARDISO_OOC_PATH%.sin" del /f "%MKL_PARDISO_OOC_PATH%.*"
if exist "011.perf" del /f "011.perf"
if "%mksol700%" == "yes" (
   if exist ./011.sol700.pth del /f ./011.sol700.pth
)
@rem Delete job utility files
for %%f in ("%jobnt%*") do call :delete_job_file "%%f"
:jobdone
endlocal
goto :eof
@rem
@rem //////////////////////////////////////////////////////////////////
@rem
@rem   Function:  concat_job_file
@rem
:concat_job_file
setlocal
set ext=%~x1
type "011_SN_*.%1" > 011.%1 2>nul
del /f "011_SN_*.%1" 2>nul:
>nul findstr "^" "011.%1" || del "011.%1"
endlocal
goto :eof
@rem
@rem
@rem //////////////////////////////////////////////////////////////////
@rem
@rem   Function:  delete_job_file
@rem
:delete_job_file
setlocal
set ext=%~x1
if "%ext%" == ".bat" goto :delete_job_file_done
if "%ext%" == ".rcf" goto :delete_job_file_done
del /f "%1" 2>nul:
:delete_job_file_done
endlocal
goto :eof
@rem
@rem
@rem //////////////////////////////////////////////////////////////////
@rem
@rem   Function:  get_file_size
@rem
:get_file_size
setlocal
set /a i = -1
if not %1 == "" for /f "tokens=4" %%f in ('^dir /-c %1 2^>nul:^)') do set i="%%f"
endlocal && set FILE_SIZE=%i%
goto :eof
@rem
@rem //////////////////////////////////////////////////////////////////
@rem
@rem   Function:  getvernum
@rem
:getvernum
setlocal
set /a k = %maxvernum%
set j=%~x1
if "%j%" == "" goto :getvernum_done
set j=%j:.=%
set /a j = %j% + 0
if "%j%" == "0" goto :getvernum_done
if /i %j% gtr %maxvernum% set /a k = %j%
:getvernum_done
endlocal && set /a maxvernum = %k%
goto :eof
@rem
@rem //////////////////////////////////////////////////////////////////
@rem
@rem   Function:  remove_0_file
@rem
:remove_0_file
if not exist "%outnt%.%1" goto :remove_0_file_done
call :get_file_size "%outnt%.%1"
if /i "%FILE_SIZE%" equ 0 del /f "%outnt%.%1" 2>nul:
:remove_0_file_done
goto :eof
@rem
@rem //////////////////////////////////////////////////////////////////
