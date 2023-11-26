:: Set path to current dir so batch file can be doubleclicked
cd %~dp0

:: Work around Sjasmplus terminal bug
SET NO_COLOR=1

:: Assemble both programs
sjasmplus.exe PortFF.asm
sjasmplus.exe Layer12.asm

:: Skip the CSpect stuff unless you set it up yourself
goto end

:: Cppy files into CSpect SD image
hdfmonkey mkdir C:\spec\sd208\cspect-next-2gb.img Timex
hdfmonkey put C:\spec\sd208\cspect-next-2gb.img PortFF.tap Timex
hdfmonkey put C:\spec\sd208\cspect-next-2gb.img Layer12.tap Timex

:: Start CSpect with image
taskkill /F /IM cspect.exe 
start /d C:\spec\CSpect2_19_4_4 cspect -w3 -zxnext -nextrom -basickeys -exit -brk -tv -emu -mmc=C:\spec\sd208\cspect-next-2gb.img

:end

::pause