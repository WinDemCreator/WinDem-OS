# (FR)
Bonjour petit développeur (je pense), tu vas pouvoir tester WinDem OS V3.6 ! Mais avant tout, tu dois suivre toutes ces étapes, sinon tu ne pourras pas :

## Créer l'image disque

**Étape 1 :**  
Installer NASM et QEMU. Si vous utilisez le répertoire par défaut, il devrait être détecté automatiquement ; sinon, indiquez le chemin d'accès précis de l'exécutable `qemu-system-i386.exe` dans le fichier `.env` du projet.

**Étape 2 :**  
Lancez le script `build.bat` sur Windows ou `build.sh` sur Linux pour créer l'image.

**Étape 3 :**  
Lancez `run.bat` sur Windows ou `run.sh` sur Linux et profitez de l'OS WinDem !

## Lancer la VM

Les scripts contiennent simplement cette commande pour lancer la VM via le terminal de l'OS :

**Windows :**
``%QEMU% -drive format=raw,file=os.img``


**Système Unix :**  
``qemu-system-i386 -drive format=raw,file=os.img``








# (EN)  
Hello little developer (I think), you are about to test WinDem OS V3.6! But first, you need to follow all these steps, otherwise you won’t be able to:

# create the disk image

**Step 1:**  
Install NASM and QEMU. If you use the default directory, it should be detected automatically; otherwise, set the exact path to the executable `qemu-system-i386.exe` in the project’s `.env` file.

**Step 2:**  
Run the `build.bat` script on Windows or `build.sh` on Linux to create the image.

**Step 3:**  
Run `run.bat` on Windows or `run.sh` on Linux and enjoy the WinDem OS!

**Starting the VM**  
The scripts simply contain this command to launch the VM via the OS terminal:  

**Windows:**
``%QEMU% -drive format=raw,file=os.img``

**Unix systems:**  
``qemu-system-i386 -drive format=raw,file=os.img``