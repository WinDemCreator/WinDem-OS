# (FR)
Bonjour petit dévelopeur (je pense), tu va pouvoir tester WinDem OS V3.0 ! Mais avant tous, tu dois faire toutes ces étapes sinon tu ne pourra pas:

# créer l'image disk

**Etape 1:**
Avoir un disque D:\ (OBLIGATOIRE)

**Etape 2:**
Installer NASM dans ce repertoire: D:\NASM\ et installer qemu dans ce répértoire: D:\qemu\

**Etape 3:**
Lancé build.bat ou si un fichier nommé: os.img est déjà créé, ne pas lancer build.bat

**Etape 4:**
Lancer run.bat et profite de l'os WinDem !


**Lancé la VM**
Windows via cmd
``D:\qemu\qemu-system-i386 -drive format=raw,file=os.img``

Système unix via term :
``qemu-system-i386 -drive format=raw,file=os.img``

Signée: WinDem Coroperation








# (EN)

Hello, little developer (I think), you're about to be able to test WinDem OS V3.0! But first, you must complete all these steps, otherwise you won't be able to:

# create disk image

**Step 1:**
Have a D:\ drive (MANDATORY)

**Step 2:**
Install NASM in this directory: D:\NASM\ and install qemu in this directory: D:\qemu\

**Step 3:**
Run build.bat or, if a file named os.img is already created, don't run build.bat

**Step 4:**
Run run.bat and enjoy the WinDem OS!

**Start the VM**
Windows via cmd
``D:\qemu\qemu-system-i386 -drive format=raw,file=os.img``

Unix system via term :
``qemu-system-i386 -drive format=raw,file=os.img``


Signed: WinDem Corporation