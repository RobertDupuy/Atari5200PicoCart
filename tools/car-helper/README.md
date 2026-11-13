# 5200 CAR Helper 1.0.1

Copyright © 2026 Robert Dupuy. All rights reserved.

An offline desktop utility for converting raw Atari 5200 `.bin`, `.rom` and `.a52` files to `.car`. This folder contains **helper application source only**.

Opens at 1064 × 924 with scaled text and controls, centered on the screen. On smaller screens, the starting size fits within 90% of the available work area.

## Downloads

- [Windows (64-bit)](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/car-helper-v1.0.1/5200-CAR-Helper-Windows.zip)
- [Mac (Intel and Apple silicon)](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/car-helper-v1.0.1/5200-CAR-Helper-Mac.zip)
- [Helper release and source ZIP](https://github.com/RobertDupuy/Atari5200PicoCart/releases/tag/car-helper-v1.0.1)

Choose a ROM, select its cartridge layout, and save a new CAR file. The original bytes are preserved. Existing output files are never overwritten. The helper does not include the PicoCart fingerprint database. Size narrows the choices but cannot determine every mapping: 16 KB and 40 KB require an explicit layout choice. A header cannot add firmware support for a mapper.

See [USER-GUIDE.txt](USER-GUIDE.txt) for formats, limitations and validation details. Windows is not publisher-signed; the Mac app is ad-hoc signed but not notarized. First-launch instructions are included with each download. Shared logic and file handling passed 94 automated checks on Linux; exported applications have not been launch-tested on Windows or macOS.

## Build

Use **Godot 4.6.3** with its matching Windows and macOS export templates. Open `project.godot` in Godot, or run these commands from this directory, with the Godot executable on PATH as `godot`:

```sh
godot --headless --path . --editor --import --quit
godot --headless --path . --script tests/test_car.gd
godot --headless --path . --script tests/test_ui.gd
mkdir -p ../dist/Windows ../dist/Mac
godot --headless --path . --export-release Windows
godot --headless --path . --export-release macOS
```

The export presets produce `../dist/Windows/5200-CAR-Helper.exe` and `../dist/Mac/5200-CAR-Helper.zip`. Create output directories manually when using a shell without `mkdir -p`. Package exports with the user guide and the Godot license and third-party copyright notices from the matching engine distribution.

Original helper code remains copyright Robert Dupuy, all rights reserved. Publishing this source does not grant an open-source license. Godot and its third-party components retain their own licenses. No firmware source, hardware designs or ROMs are included in this folder.
