@echo off

rem canvasp v0.1.0

setlocal enabledelayedexpansion
set TEMPLATE_DIRNAME=template
set DATA_DIRNAME=data
set PAINT_APP_PATH=mspaint.exe

pushd "%~dp0"

set cnt=0
for /F "usebackq" %%i in (`dir /b %TEMPLATE_DIRNAME%\*.jpg ^| sort`) do (
	set /a cnt=!cnt!+1
	echo !cnt!: %%i
)

:select_retrying
set /p input_num="Input the number you want to use>>>";

set cnt=0
set targetfilename=NOT_FOUND
for /F "usebackq" %%i in (`dir /b %TEMPLATE_DIRNAME%\*.jpg ^| sort`) do (
	set /a cnt=!cnt!+1
	if "%input_num%"=="!cnt!" (
		set targetfilename=%%i
		break
	)
)

echo Target is %targetfilename%
if "%targetfilename%"=="NOT_FOUND" (
	goto :select_retrying
)

set /p yourcomment="Input the comment>>>";
set datebase=%date%
set timebase=%time%
set shortdate=%datebase:/=%
set shortdate=%shortdate:~2,6%
set shorttime=%timebase::=%
set shorttime=%shorttime:~0,6%
set shortdatetime=%shortdate%_%shorttime%
set filename=%shortdatetime%_%yourcomment%.jpg
copy %TEMPLATE_DIRNAME%\%targetfilename% %DATA_DIRNAME%\%filename%
start "" "%PAINT_APP_PATH%" "%DATA_DIRNAME%\%filename%"

popd
