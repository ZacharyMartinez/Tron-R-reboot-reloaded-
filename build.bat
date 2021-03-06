@echo off

rem add path for common tools
set PATH=%PATH%;%CD%/softwares/win-utils

rem get system architecture
set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
 
REG.exe Query %RegQry% > checkOS.txt
 
find /i "x86" < CheckOS.txt > StringCheck.txt

if %ERRORLEVEL% == 0 (
    echo This is 32 Bit Operating system.
    set architecture=32
) ELSE (
    echo This is 64 Bit Operating System.
    set architecture=64
)
del checkOS.txt
del StringCheck.txt


rem download blender
if exist blender.zip (
	echo Blender downloaded file found.
) else (
	echo Downloading blender.
	if %architecture% == 32 (
		wget -nv --progress=bar http://ftp.halifax.rwth-aachen.de/blender/release/Blender2.72/blender-2.72-windows32.zip -O blender.zip
	) else (
		wget -nv --progress=bar http://ftp.halifax.rwth-aachen.de/blender/release/Blender2.72/blender-2.72-windows64.zip -O blender.zip
	)
)
rem extract blender
7za x blender.zip -osoftwares

rem rename blender directory
cd softwares
dir /b blender-* > blendername.txt
for /f %%i in (blendername.txt) do rename %%i blender
del blendername.txt
cd ..

rem delete useless files
echo Removing useless files (developement and source files)
set extensions=*.xcf *.blend1 *.sh
dir /b /s > tree.txt
for %%e in (%extensions%) do (
	find /i %%e < tree.txt > toremovelist.txt
	for /f %%f in (toremovelist.txt) do (
		del %%f
	)
)
del tree.txt
del toremovelist.txt

for /f %%p in (projects.lst) do (
	rmdir /S %%p
)

del blender.zip
pause
