# Atari5200PicoCart

**Copyright © 2026 Robert Dupuy.**

UF2 firmware downloads for the Retro Powerhouse Atari 5200 PicoCart.

## Download

[**Download the latest UF2**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/latest/download/RetroPowerhouse-A5200-R5.2-3-Games-and-PDF-Blank-RP2040.uf2) · [Releases](https://github.com/RobertDupuy/Atari5200PicoCart/releases)

## Optional ROM-to-CAR helper

Convert raw `.bin`, `.rom` or `.a52` files into `.CAR` files on your computer:

- [**Download for Windows (64-bit)**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/car-helper-v1.0.1/5200-CAR-Helper-Windows.zip)
- [**Download for Mac (Intel and Apple silicon)**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/car-helper-v1.0.1/5200-CAR-Helper-Mac.zip)
- [Instructions and helper source](tools/car-helper) · [Helper release](https://github.com/RobertDupuy/Atari5200PicoCart/releases/tag/car-helper-v1.0.1)

Choose the ROM, select its cartridge layout, and save a new CAR file. The original is unchanged. Some sizes have more than one layout; adding a header does not add unsupported mapper functionality to the cartridge firmware. First-launch security instructions are included in the downloads.

The **UF2 firmware remains the main/latest release**. The helper is a separate optional download.

## Optional factory reinstall

**Firmware updates are not required for normal use. All firmware versions support CAR files.** Customers who wish to reinstall can erase the cartridge and then install the factory firmware.

**Erasing removes all games, folders, and other files. Back up everything on A5200CART to your computer first.**

1. Back up the cartridge, safely eject it, and disconnect USB. Keep it removed from the Atari throughout this process.
2. Open the cartridge case to reach **BOOTSEL on the internal RP2040 board**. This is not the cartridge reset button.
3. Hold BOOTSEL while connecting USB to the computer, then release it when **RPI-RP2** appears.
4. Copy [**01-ERASE-ALL-16MiB-Verified.uf2**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/v5.2/01-ERASE-ALL-16MiB-Verified.uf2) onto RPI-RP2. Allow erasing to finish before proceeding.
5. With the cartridge back in BOOTSEL mode and RPI-RP2 available, copy the [**R5.2 factory firmware UF2**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/v5.2/RetroPowerhouse-A5200-R5.2-3-Games-and-PDF-Blank-RP2040.uf2) onto it. **Use the two UF2 files separately, in this order—not together.**
6. After installation finishes and A5200CART returns, copy your backed-up games and folders onto it. Safely eject, disconnect USB, and reassemble the case.

The erase file is for the PicoCart's **16 MB flash module**. The factory installer restores the firmware and supplied files after the erase; it is not an in-place update that preserves files.

Erase UF2 SHA-256: `596fbbd2cb17fa2eacd91810a983d67745cb5ecf3224d4c9482ec82d3de935d2`

## R5.2 factory contents

The UF2 installs:

- PickAxePete5200
- Phoenix5200
- DK35200 (v1.2)
- A 4 × 6 inch instruction PDF on the cartridge's USB drive

The instructions are deployed by the UF2 itself. Connect the cartridge's bottom USB-C port to a computer to open the PDF on `A5200CART`.

## Game recognition

The database identifies ROM contents, regardless of filename. This build includes the Beef Drop AtariMax ROM edition fingerprint; Beef Drop is not preinstalled.

Database and CAR-header recognition run first. An unidentified raw 16 KB file prompts for **1: One chip**, **2: Two chip**, or **\*: Cancel**. The choice applies to that launch. Other supported raw size fallbacks are 4, 8, 32, 64, 128, 256 and 512 KB. HYB files are not supported.

This repository distributes compiled UF2 firmware, documentation, and the CAR Helper utility with its source. Firmware source code and hardware design files are not published here.

## Verification

The release passed software checks for database recognition, the 16 KB prompt, cartridge mapping, and UF2 contents. These checks are not a physical-console gameplay test.

SHA-256:

```text
31c8f9df29327b1852ac17f482687d6cd443aa74e9e51d761e6d21c849664b7b
```

## Copyright and notices

Copyright © 2026 Robert Dupuy. All rights reserved for the original firmware, helper code and documentation. Third-party components retain their respective copyrights and license terms; see [THIRD-PARTY-NOTICES.txt](THIRD-PARTY-NOTICES.txt).
