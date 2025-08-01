@echo off
setlocal EnableDelayedExpansion
pushd "%~dp0..\"

set "QEMU="
for /f "usebackq eol=# tokens=1* delims==" %%A in (".env") do (
  REM Clé=%%A, Valeur=%%B (tout après le premier '=')
  if /i "%%A"=="QEMU" (
    set "tmp=%%B"
    set "tmp=!tmp:"=!"      REM enlève tous les guillemets
    set "QEMU=!tmp!"
    echo [info] QEMU trouvé : !QEMU!
  )
)

if not defined QEMU (
  echo ERREUR : .env ne contient pas de QEMU=…
  popd
  exit /b 1
)

REM Vérifie que le fichier existe (utile pour QEMU Windows .exe)
if not exist "!QEMU!" (
  echo ERREUR : exécutable introuvable : "!QEMU!"
  popd
  exit /b 2
)

echo Lancement : "!QEMU!"
"%QEMU%" -drive format=raw,file=os.img

popd
pause
