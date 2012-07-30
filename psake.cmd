@echo off

set psake=packages\psake.4.0.1.0\tools\psake.ps1

if '%1'=='/?' goto help
if '%1'=='-help' goto help
if '%1'=='-h' goto help

powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%psake%' %*; if ($psake.build_success -eq $false) { exit 1 } else { exit 0 }"
goto :eof

:help
powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%psake%' -help"
