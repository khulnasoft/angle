@echo off
echo *** Angle command prompt environment ***
echo.
echo Start Angle by running
echo     angle --config config\angle.toml
echo or use
echo     angle --help
echo to get help.
cd %~dp0
cmd /k set PATH=%~dp0bin;%PATH%
