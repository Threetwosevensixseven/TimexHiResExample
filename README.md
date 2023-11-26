# TimexHiResExample
Simple examples for enabling Timex HiRes mode and `LAYER 1,2` on Spectrum Next from asm.

Next-only examples would more typically be created as .NEX files or dot commands, but the former adds a layer of complexity to using the NextZXOS API, and the latter is more complex all round. Also, it's beneficial if the `PortFF.tap` example can be demonstrated to work equally well on standard Timex hardware and other emulators.

## PortFF

This assembles to `PortFF.tap`, and runs in both SpecEmu, Next, and CSpect with SD image.

### SpecEmu
Just set model to Timex TC 2048, and drop `PortFF.tap` onto the emulator.

![SpecEmu PortFF.tap](https://github.com/Threetwosevensixseven/TimexHiResExample/blob/main/img/portff-specemu.png)

### Next or CSpect

Open `PortFF.tap` from the NextZXOS browser, and choose `N` to start in Next/+3 mode.

![SpecEmu PortFF.tap](https://github.com/Threetwosevensixseven/TimexHiResExample/blob/main/img/portff-cspect.png)

## LAYER 1,2

This assembles to `Layer12.tap`, and runs in Next, and CSpect with SD image.

Open `PortFF.tap` from the NextZXOS browser, and choose `N` to start in Next/+3 mode.

![SpecEmu PortFF.tap](https://github.com/Threetwosevensixseven/TimexHiResExample/blob/main/img/layer12-cspect.png)


