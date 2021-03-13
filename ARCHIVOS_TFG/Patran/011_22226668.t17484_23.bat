@rem  BAT file generated from the d:/program files/mscnastran/patran/mscnastran_files/20191/servermode/msc20191/win64i4/nastran.srv
@rem  template file for Windows NT/2K/XP/.NET 2003/...
@rem  for Server Job processing
@rem
@rem Run MSC Nastran in Server node.
@rem
@rem THIS PROGRAM IS CONFIDENTIAL AND A TRADE SECRET OF THE MSC.SOFTWARE
@rem CORPORATION.  THE RECEIPT OR POSSESSION OF THIS PROGRAM DOES NOT CONVEY ANY
@rem RIGHTS TO REPRODUCE OR DISCLOSE ITS CONTENTS, SELL, LEASE, OR OTHERWISE
@rem TRANSFER IT TO ANY THIRD PARTY, IN WHOLE OR IN PART, WITHOUT THE SPECIFIC
@rem WRITTEN CONSENT OF THE MSC.SOFTWARE CORPORATION.
@rem
@setlocal
@echo off
set outnt=./011_22226668
set outnt=%outnt:/=\%
set archdir=d:/program files/mscnastran/patran/mscnastran_files/20191/servermode/msc20191/win64i4
set archdir=%archdir:/=\%
set datecmd=d:/program files/mscnastran/patran/mscnastran_files/20191/servermode/msc20191/win64i4/mscdate
set datecmd=%datecmd:/=\%
set exedir=
set jobnt=./011_22226668.T17484_23
set jobnt=%jobnt:/=\%
set lognt=./011_22226668.log
set lognt=%lognt:/=\%
set modedir=
set nastcmd=d:/program files/mscnastran/patran/mscnastran_files/20191/servermode/msc20191/win64i4/nastran.exe
set nastcmd=%nastcmd:/=\%
set sdirnt=c:/users/vtech/appdata/local/temp
set sdirnt=%sdirnt:/=\%
set solver=d:/program files/mscnastran/patran/mscnastran_files/20191/servermode/msc20191/win64i4/analysis.exe
set solver=%solver:/=\%
set tcmd=d:/program files/mscnastran/patran/mscnastran_files/20191/servermode/msc20191/win64i4/msctime
set tcmd=%tcmd:/=\%
set user=vtech
set MSC_BASE=d:/program files/mscnastran/patran/mscnastran_files/20191/servermode
set MSC_VERSD=msc20191
set MSC_ARCH=win64i4
set MSC_BASE=%MSC_BASE:/=\%
set MSC_VERSD=%MSC_VERSD:/=\%
set MSC_ARCH=%MSC_ARCH:/=\%
if "%archdir%" == "%MSC_BASE%" goto :minimal
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
goto :scaset
:minimal
if "%MSC_SQAS_MESSAGE_FILE%" == "" (
   set MSC_SQAS_MESSAGE_FILE=%MSC_BASE%\analysis.msg
)
if "%SCA_SERVICE_CATALOG%" == "" (
  set SCA_SERVICE_CATALOG=%MSC_BASE%\res\SCAServiceCatalog.xml
) else (
  set SCA_SERVICE_CATALOG=%SCA_SERVICE_CATALOG%;%MSC_BASE%\res\SCAServiceCatalog.xml
)
if "%SCA_RESOURCE_DIR%" == "" (
  set SCA_RESOURCE_DIR=%MSC_BASE%\res
) else (
  set SCA_RESOURCE_DIR=%SCA_RESOURCE_DIR%;%MSC_BASE%\res
)
:scaset
set findstr="%windir%\system32\findstr.exe"
set DBSDIR=.
set JIDDIR=d:/aegis/documents/tfg/testfea/patr
set MSC_APP=no
set MSC_AUTH=EDU
set MSC_BASE=d:/program files/mscnastran/patran/mscnastran_files/20191/servermode
set MSC_DBS=./011_22226668
set MSC_EXE='d:/program files/mscnastran/patran/mscnastran_files/20191/servermode/msc20191/win64i4/analysis.exe'
set MSC_ISHELLPATH=D:\Program Files\MSCNastran\Patran\mscnastran_files\20191\servermode\msc20191\actran\win64\Actran_20.0.b.124632\bin;D:\Program Files\MSCNastran\Patran\mscnastran_files\20191\servermode\msc20191\nast
set MSC_ISHELLEXT=
set MSC_JID=d:/aegis/documents/tfg/testfea/patr/011_22226668.bdf
set MSC_JIDPATH=;D:\Program Files\MSCNastran\Patran\mscnastran_files\20191\servermode\msc20191\\nast\\tpl\include;D:\Program Files\MSCNastran\Patran\mscnastran_files\20191\servermode\msc20191\\nast\\tpl\include
set MSC_JIDTYPE=.bdf
set MSC_MEM=740MB
set MSC_OLD=no
set MSC_OUT=./011_22226668
set MSC_SCR=no
set MSC_SDIR=c:/users/vtech/appdata/local/temp
set MSC_VERSD=msc20191
set OUTDIR=.
set TMP=c:/users/vtech/appdata/local/temp
set MSC_SQAS_MESSAGE_FILE='d:/program files/mscnastran/patran/mscnastran_files/20191/servermode\msc20191\win64i4\\analysis.msg'
set ACTRAN_PATH='d:/program files/mscnastran/patran/mscnastran_files/20191/servermode\msc20191\actran\win64'
set ACTRAN_PRODUCTLINE='d:/program files/mscnastran/patran/mscnastran_files/20191/servermode\msc20191\actran\win64\Actran_20.0.b.124632'
set ACTRAN_AFFINITY=reset
set MSC_MSG=stderr
set MSC_SRV=y
set PWD=D:\aegis\Documents\TFG\TESTFEA\PATR
set PWD=%PWD:/=\%
cd /d %PWD%
@rem
@rem Delete the old output files.
@rem
for %%f in (f06 f04 log ndb op2 pch plt acg h5 mtx.h5 mdl.h5 asm becho marc.dat marc.log marc.out marc.sts marc.t16 marc.t19 des mnf PCS aeso sts out) do (
  if exist "%outnt%.%%f" del /f "%outnt%.%%f" 1>nul: 2>nul:
)
set asgf=%jobnt%.rcf
set PATH=%archdir%;%PATH%
if exist "%archdir%\lib\*.dll" set PATH=%archdir%\lib;%PATH%
if exist "%archdir%\lib\win32\*.dll" set PATH=%archdir%\lib\win32;%PATH%
if exist "%archdir%\lib\win64i4\*.dll" set PATH=%archdir%\lib\win64i4;%PATH%
if not "%SCA_LIBRARY_PATH%" == "" set PATH=%SCA_LIBRARY_PATH%;%PATH%
if not exist "%solver%" goto :jobdone
set MSC_ASG=%asgf%
set MSC_MEM=740MB
"%solver%"  FPE=yes
@rem
@rem
if exist "%sdirnt%\011_22226668.T17484_23.*" del /f "%sdirnt%\011_22226668.T17484_23.*" 1>nul: 2>nul:
for %%f in (ndb op2 pch plt xdb acg h5 mtx.h5 mdl.h5 asm becho marc.dat marc.log marc.out marc.sts marc.t16 marc.t19 des mnf PCS aeso sts) do call :remove_0_file %%f
for %%f in (yes) do if exist "%outnt%.%%f" del /f "%outnt%.%%f"
@rem Delete job utility files
for %%f in ("%jobnt%*") do call :delete_job_file "%%f"
:jobdone
endlocal
goto :eof
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
@rem   Function:  getvariableval
@rem
:getvariableval
if not {%3} == {} goto :getvariableval_multiple
set %1=%2
goto :eof
:getvariableval_multiple
setlocal
set bldvar=%2
:getvariableval_loop
set bldvar=%bldvar% %3
shift /3
if not {%3} == {} goto :getvariableval_loop
endlocal && set %1=%bldvar%
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
