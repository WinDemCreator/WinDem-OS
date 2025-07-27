@echo off
REM pour utilisé le dossier root du projet (ou ce trouve les .asm)
pushd "%~dp0..\"
D:\qemu\qemu-system-i386 -drive format=raw,file=os.img
popd