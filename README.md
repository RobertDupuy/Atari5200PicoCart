# Atari5200PicoCart

**Copyright © 2026 Robert Dupuy.**

UF2 firmware downloads for the Retro Powerhouse Atari 5200 PicoCart.

## Download

[**Download the latest UF2**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/latest/download/RetroPowerhouse-A5200-R5.2-3-Games-and-PDF-Blank-RP2040.uf2) · [Releases](https://github.com/RobertDupuy/Atari5200PicoCart/releases)

## Optional ROM-to-CAR helper

Convert raw `.bin`, `.rom` or `.a52` files into `.CAR` files on your computer:

- [**Download for Windows (64-bit)**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/car-helper-v1.0/5200-CAR-Helper-Windows.zip)
- [**Download for Mac (Intel and Apple silicon)**](https://github.com/RobertDupuy/Atari5200PicoCart/releases/download/car-helper-v1.0/5200-CAR-Helper-Mac.zip)
- [Instructions and helper source](tools/car-helper) · [Helper release](https://github.com/RobertDupuy/Atari5200PicoCart/releases/tag/car-helper-v1.0)

Choose the ROM, select its cartridge layout, and save a new CAR file. The original is unchanged. Some sizes have more than one layout; adding a header does not add unsupported mapper functionality to the cartridge firmware. First-launch security instructions are included in the downloads.

The **UF2 firmware remains the main/latest release**. The helper is a separate optional download.

## R5.2 — initial installation

This installer is for a **blank RP2040 module with 16 MB flash**. It programs only the sectors needed for firmware and the included files. It is not an in-place firmware updater for a cartridge that already contains files.

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
