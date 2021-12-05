@echo off

setlocal EnableDelayedExpansion

set char=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
set count=0
set "result_folder=D:\test"

for %%a in ("%result_folder%\*jpg") do (
    CALL :GetRandom %%~fa
    set buffer=
    set count=0
)
GOTO :eof

:GetRandom
:Loop
    set /a count+=1
    set /a rand=%Random%%%61
    set buffer=!buffer!!char:~%rand%,1!
if !count! leq 32 goto Loop
set filename=!buffer!.jpg
echo %filename%
ren %1 %filename%
EXIT /B

endlocal