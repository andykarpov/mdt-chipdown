# MicroDEXED Touch Chipdown custom edition

This is an attempt to create a custom PCB of the MicroDEXED Touch (MDT) project to satisfy my own requirements:

- No modules, all chips should be soldered on PCB
- Avoid THT components as much as possible

**Warning! Work in progress. The revB is untested and unreleased yet.**

- Current tested revision: **revA**
- Current dev revision: **revB**

## PCB changelog & ERRATA:

- revA - initial revision
    - Note: Jumpers to select MIDI IN/OUT standard should be removed, instead of them please use 0 Ohm resistors
    - Latest revA contains the following changes: jumpers replaced with solder jumpers
    - The overall display height is slightly higher than expected. Please use 8.5mm standoffs for it. Also the plastic housing from the display pin headers should be removed and the pin height should be reduced to fit the desired connection height of 8.5mm
- revB:
    - 4-layers PCB
    - Replaced teensy module with a set of chips
    - Added additional SD card
    - Added additional LED from the supplementary MCU
    - Changed USB Host power path

## Rev.A Renders

[![photo](docs/mdt-chipdown-revA-top.png)](docs/mdt-chipdown-revA-top.png?raw=true)

[![photo](docs/mdt-chipdown-revA-bottom.png)](docs/mdt-chipdown-revA-bottom.png?raw=true)

## Case for rev.A

[![photo](docs/mdt-chipdown-revA-case1.png)](docs/mdt-chipdown-revA-case1.png?raw=true)

[![photo](docs/mdt-chipdown-revA-case2.png)](docs/mdt-chipdown-revA-case2.png?raw=true)

## Rev.B Renders

[![photo](docs/mdt-chipdown-revB-top.png)](docs/mdt-chipdown-revB-top.png?raw=true)

[![photo](docs/mdt-chipdown-revB-bottom.png)](docs/mdt-chipdown-revB-bottom.png?raw=true)

