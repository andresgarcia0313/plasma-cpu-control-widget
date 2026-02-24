# KDE Plasma CPU Control Widget

Widget de KDE Plasma 6 para monitorear y controlar el rendimiento del CPU Intel desde el panel.

## Características

- Temperatura del CPU en tiempo real en el panel
- Porcentaje de rendimiento y estado del turbo boost
- Cambio de perfil con un click:
  - **Performance**: Máximo rendimiento (videollamadas, compilación)
  - **Balanced**: Equilibrio rendimiento/consumo (uso general)
  - **Power Saver**: Bajo consumo (batería, temperaturas altas)
- Usa `powerprofilesctl` (estándar del sistema, sin sudo)
- Colores indicadores de temperatura y estado

## Requisitos

- KDE Plasma 6
- CPU Intel con driver `intel_pstate`
- `power-profiles-daemon` (incluido por defecto en Kubuntu)

## Instalación

```bash
chmod +x install.sh
./install.sh
kquitapp6 plasmashell && kstart plasmashell
```

Click derecho en el panel > "Add Widgets..." > Buscar "CPU Control"

## Desinstalación

```bash
rm -rf ~/.local/share/plasma/plasmoids/org.kde.plasma.cpucontrol
kquitapp6 plasmashell && kstart plasmashell
```

## Estructura

```
cpu-control-plasmoid/
├── metadata.json
├── metadata.desktop
├── contents/
│   └── ui/
│       └── main.qml
├── install.sh
└── README.md
```

## Licencia

MIT
