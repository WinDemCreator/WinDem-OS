@echo off

REM Clean old files
if exist bootloader.bin del bootloader.bin
if exist kernel.bin del kernel.bin
if exist os.img del os.img
if exist pad.bin del pad.bin
if exist padded_kernel.bin del padded_kernel.bin

REM Assemble le bootloader (512 octets)
D:\NASM\nasm -f bin bootloader.asm -o bootloader.bin

REM Assemble le kernel (taille libre)
D:\NASM\nasm -f bin kernel.asm -o kernel.bin

REM Créer padding pour que kernel fasse 4 secteurs (2048 octets)
fsutil file createnew pad.bin 2048 > nul

REM Concaténer kernel + padding
copy /b kernel.bin + pad.bin padded_kernel.bin > nul

REM Concaténer bootloader + kernel padded pour créer image disque
copy /b bootloader.bin + padded_kernel.bin os.img > nul

REM Nettoyer fichiers temporaires
del pad.bin
del padded_kernel.bin

echo Image disque créée : os.img
pause
