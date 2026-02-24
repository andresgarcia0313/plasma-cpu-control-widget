# KDE Plasma CPU Control Widget

Widget de KDE Plasma 6 para monitorear temperatura del CPU y controlar el límite de rendimiento desde el panel.

## Características

- Temperatura real del CPU en tiempo real (detección dinámica de zona térmica)
- Limitador de CPU con botones -5% / +5% (rango 10%-100%)
- Colores dinámicos por temperatura: verde, amarillo, naranja, rojo
- Sin duplicar funcionalidad del sistema (no cambia perfiles de energía)
- Arquitectura modular por componentes

## Requisitos

- KDE Plasma 6
- CPU Intel con driver `intel_pstate`
- Node.js (para ejecutar tests)

## Instalación

```bash
chmod +x install.sh
./install.sh
kquitapp6 plasmashell && kstart plasmashell
```

Click derecho en el panel > "Add Widgets..." > Buscar "CPU Control"

## Tests

```bash
./tests/run_tests.sh
```

## Estructura

```
cpu-control-plasmoid/
├── contents/ui/
│   ├── main.qml                  # Orquestador
│   ├── CompactView.qml           # Vista del panel
│   ├── FullView.qml              # Vista expandida
│   ├── components/
│   │   ├── TemperatureDisplay.qml
│   │   └── PerfLimiter.qml
│   └── logic/
│       ├── CpuReader.js          # Lectura de sensores
│       └── CpuWriter.js          # Escritura a intel_pstate
├── system/
│   ├── cpu-perf-set              # Helper script
│   └── *.policy                  # Polkit policy
├── tests/
│   ├── test_CpuReader.js
│   ├── test_CpuWriter.js
│   └── run_tests.sh
├── metadata.json
├── metadata.desktop
└── install.sh
```

## Desinstalación

```bash
rm -rf ~/.local/share/plasma/plasmoids/org.kde.plasma.cpucontrol
sudo rm -f /usr/local/bin/cpu-perf-set
sudo rm -f /usr/share/polkit-1/actions/org.kde.plasma.cpucontrol.policy
kquitapp6 plasmashell && kstart plasmashell
```

## Licencia

MIT
