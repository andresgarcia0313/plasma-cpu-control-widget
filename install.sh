#!/bin/bash
# Instalar CPU Control Plasmoid

PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids/org.kde.plasma.cpucontrol"

echo "Instalando CPU Control Plasmoid..."

# Crear directorio si no existe
mkdir -p "$PLASMOID_DIR"

# Copiar archivos
cp -r "$(dirname "$0")"/* "$PLASMOID_DIR/"

# Remover el script de instalación del destino
rm -f "$PLASMOID_DIR/install.sh"
rm -f "$PLASMOID_DIR/README.md"

echo "Instalado en: $PLASMOID_DIR"
echo ""
echo "Para usar:"
echo "1. Reinicia Plasma: kquitapp6 plasmashell && kstart plasmashell"
echo "2. Click derecho en panel > Add Widgets > Buscar 'CPU Control'"
echo ""
echo "O reinicia sesión para que los cambios tomen efecto."
