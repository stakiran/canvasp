@echo off

rem canvasp v0.1.0

setlocal enabledelayedexpansion
set TEMPLATE_DIRNAME=template
set DATA_DIRNAME=data
set PAINT_APP_PATH=mspaint.exe

pushd "%~dp0"

rem Display selections of template
rem ------------------------------

set cnt=0
for /F "usebackq" %%i in (`dir /b %TEMPLATE_DIRNAME%\*.jpg ^| sort`) do (
	set /a cnt=!cnt!+1
	echo !cnt!: %%i
)
echo c: Clone from the latest previous image

rem Prompt
rem ------

:select_retrying
set /p input_num="Input the number you want to use>>>";

set cnt=0
set targetfilename=NOT_FOUND
set copysource_targetdir=%TEMPLATE_DIRNAME%

rem Determin useee image file from your input
rem -----------------------------------------

for /F "usebackq" %%i in (`dir /b %TEMPLATE_DIRNAME%\*.jpg ^| sort`) do (
	set /a cnt=!cnt!+1
	if "%input_num%"=="!cnt!" (
		set targetfilename=%%i
		break
	)
)

rem But if clone mode, use from tha latest image file
rem ----

if "%input_num%"=="c" (
	set cnt_for_break_instantly=0
	for /F "usebackq" %%i in (`dir /b %DATA_DIRNAME%\*.jpg ^| sort /r`) do (
		set /a cnt_for_break_instantly=!cnt_for_break_instantly!+1
		if "!cnt_for_break_instantly!"=="1" (
			set targetfilename=%%i
			set copysource_targetdir=%DATA_DIRNAME%
			break
		)
	)
)

rem Check invalid selection and retry if invalid
rem --------------------------------------------

echo Target is %targetfilename%
if "%targetfilename%"=="NOT_FOUND" (
	goto :select_retrying
)

rem Construct pathes and open!
rem --------------------------

set /p yourcomment="Input the comment>>>";
set datebase=%date%
set timebase=%time%
set shortdate=%datebase:/=%
set shortdate=%shortdate:~2,6%
set shorttime=%timebase::=%
set shorttime=%shorttime:~0,6%
set shortdatetime=%shortdate%_%shorttime%
set filename=%shortdatetime%_%yourcomment%.jpg
copy %copysource_targetdir%\%targetfilename% %DATA_DIRNAME%\%filename%
rem If use start command, the paint app window does not on top somewhy.
rem So, use 2-step execution with another batchfile.
remstart "" "%PAINT_APP_PATH%" "%DATA_DIRNAME%\%filename%"
call open_image.bat "%DATA_DIRNAME%\%filename%"

popd
