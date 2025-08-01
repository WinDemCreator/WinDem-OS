@echo off
setlocal EnableDelayedExpansion

REM pour utilisé le dossier root du projet (ou ce trouve les .asm et le .env)
pushd "%~dp0..\"

set "NASM="

REM Verify if NASM is in the default installation path
if exist "C:\Users\%username%\AppData\Local\bin\NASM\nasm.exe" (
    set "NASM=C:\Users\%username%\AppData\Local\bin\NASM\nasm.exe"
    echo [INFO] NASM trouvé dans AppData\Local
) else if exist "%ProgramFiles%\NASM\nasm.exe" (
  set "NASM=%ProgramFiles%\NASM\nasm.exe"
  echo [INFO] NASM trouvé dans "%ProgramFiles%\NASM\nasm.exe"
) else if exist "%ProgramFiles(x86)%\NASM\nasm.exe" (
  set "NASM=%ProgramFiles(x86)%\NASM\nasm.exe"
  echo [INFO] NASM trouvé dans "%ProgramFiles(x86)%\NASM\nasm.exe"
)


if not defined NASM (
    for /f "usebackq eol=# tokens=1* delims==" %%A in (".env") do (
        if /i "%%A"=="NASM" (
        set "tmp=%%B"
        set "tmp=!tmp:"=!"             REM supprime guillemets éventuels
        set "NASM=!tmp!"
        echo [INFO] NASM lu depuis .env : "!NASM!"
        )
    )
)

if not defined NASM (
  echo ERREUR : NASM non défini dans .env
  popd
  exit /b 1
)

if not exist "!NASM!" (
  echo ERREUR : NASM introuvable : "!NASM!"
  popd
  exit /b 2
)

echo [OK] NASM est correctement configuré : "!NASM!"

REM Clean old files
if exist bootloader.bin del bootloader.bin
if exist kernel.bin del kernel.bin
if exist os.img del os.img
if exist pad.bin del pad.bin
if exist padded_kernel.bin del padded_kernel.bin

REM Assemble le bootloader (512 octets)
call "%NASM%" -f bin bootloader.asm -o bootloader.bin

REM Assemble le kernel (taille libre)
call "%NASM%" -f bin kernel.asm -o kernel.bin

REM Créer padding pour que kernel fasse 4 secteurs (2048 octets)
fsutil file createnew pad.bin 2048 > nul

REM Concaténer kernel + padding
copy /b kernel.bin + pad.bin padded_kernel.bin > nul

REM Concaténer bootloader + kernel padded pour créer image disque
copy /b bootloader.bin + padded_kernel.bin os.img > nul

REM Nettoyer fichiers temporaires
del pad.bin
del padded_kernel.bin

REM pour retourné sur le dossier du script avant de quitté
popd

echo Image disque créée : os.img
pause

exit /b 0