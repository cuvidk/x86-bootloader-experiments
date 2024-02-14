## x86-bootloader-experiments

I'm experimenting with x86 real-mode (16 bit) assembly code during the legacy boot sequence (BIOS).

The code is compiled as a raw binary into a Master Boot Record (MBR) - a boot sector of 512 bytes ending in 0x55, 0xAA signature.

QEMU is then used to emulate an x86_64 system. QEMU will emulate a virtual hard-drive containing the MBR raw binary generated previously.

During the system startup the BIOS goes through the list of devices, based on the configured boot order. When the boot sector (0x55 0xAA signature) is encountered, the BIOS will load it at address 0x7c00, and then start executing the code that landed there.

That's how my code ends up being executed during the sytem start-up.
