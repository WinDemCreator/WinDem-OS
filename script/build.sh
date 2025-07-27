# fonction pour récupérer l'emplacement actuelle du script de manière sûr
set -e
get_script_dir() {
  local SOURCE="${BASH_SOURCE[0]}"
  while [ -L "$SOURCE" ]; do
    local DIR="$(cd -P "$(dirname "$SOURCE")" &>/dev/null && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  done
  cd -P "$(dirname "$SOURCE")" &>/dev/null && pwd
}

# variable avec le chemin du dossier des script et le root du projet
SCRIPT_DIR="$(get_script_dir)"
PARENT_DIR="$(realpath "$SCRIPT_DIR/..")"

echo script directory : $PARENT_DIR
echo dossier root du projet : $PARENT_DIR

# Clean old files
if [ -f "$PARENT_DIR/bootloader.bin" ]; then
    rm "$PARENT_DIR/bootloader.bin"
fi

if [ -f "$PARENT_DIR/kernel.bin" ]; then
    rm "$PARENT_DIR/kernel.bin"
fi

if [ -f "$PARENT_DIR/os.img" ]; then 
    rm "$PARENT_DIR/os.img"
fi

if [ -f "$PARENT_DIR/pad.bin" ]; then
    rm "$PARENT_DIR/pad.bin"
fi

if [ -f "$PARENT_DIR/padded_kernel.bin" ]; then
    rm "$PARENT_DIR/padded_kernel.bin"
fi

# assemble le bootloader (512o)
nasm -f bin "$PARENT_DIR/bootloader.asm" -o "$PARENT_DIR/bootloader.bin"

# assemble le kernel (taille libre)
nasm -f bin "$PARENT_DIR/kernel.asm" -o "$PARENT_DIR/kernel.bin"

# créer padding pour que le kernel fasse 4 secteurs (2048o)
truncate -s 2048 "$PARENT_DIR/pad.bin"

# concaténer kernel + padding
cat "$PARENT_DIR/kernel.bin" "$PARENT_DIR/pad.bin" > "$PARENT_DIR/padded_kernel.bin"

# concaténer bootloader + kernel_padded pour créer l'image disque
cat "$PARENT_DIR/bootloader.bin" "$PARENT_DIR/padded_kernel.bin" > "$PARENT_DIR/os.img"

# nettoyer les fichier temporaires
rm "$PARENT_DIR/pad.bin"
rm "$PARENT_DIR/padded_kernel.bin"

echo Image disque créée : os.img