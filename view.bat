@echo off
setlocal
set DATA_DIRNAME=data
set ENTRYPOINT_FILENAME=0_1x1.jpg
set ENTRYPOINT_LOCATION=%DATA_DIRNAME%\%ENTRYPOINT_FILENAME%

start "" "%~dp0%ENTRYPOINT_LOCATION%"
