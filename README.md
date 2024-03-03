## x86-bootloader-experiments

### What's this about ?
I'm experimenting with x86 real-mode (16 bit) assembly code during the legacy boot sequence (BIOS).

The code is compiled as a raw binary into a Master Boot Record (MBR) - a boot sector of 512 bytes ending in 0x55, 0xAA signature.

QEMU is then used to emulate an x86_64 system. QEMU will emulate a virtual hard-drive containing the MBR raw binary generated previously.

During the system startup the BIOS goes through the list of devices, based on the configured boot order. When the boot sector (0x55 0xAA signature) is encountered, the BIOS will load it at address 0x7c00, and then start executing the code that landed there.

That's how the code from the source files ends up being executed during the sytem start-up.

Currently, the main program draws a green triangle on the screen using BIOS routines. Additional procedures related to BIOS display functions are written in src/boot-utils.s.


### How to build the sources ?
#### Docker

Make sure you have docker installed. There's a Dockerfile located in the project root that will build an image containing an x86_64-elf cross-compiler. You can use the built image to compile the sources from src folder.

To build the image run:

    docker build --tag compile-bios-examples .

This command builds the cross-compiler from scratch, so it will take a couple of minutes, however, you'll only have to execute this once.
 
After building the docker image, to compile the project sources run the following command:

    docker run --rm -v ./src:/bios-examples-src:ro -v ./bin:/bios-examples-bin:rw compile-bios-examples

This will compile the sources and write the binary file in the project's bin directory.

#### Locally

Another way is to build a local cross-compiler.

Inside build-tools dir there's a script called gen-cross-compiler.sh. On Ubuntu you can use that to build a cross-compiler for an x86-64_elf machine. The compiler will install itself under the build-tools directory.

Use the Makefile in the root of the project to build the sources using the locally generated cross-compiler: `make all`

### How to run ?
To run the resulting binary you'll need an x86-64 emulator like QEMU installed on your system. On ubuntu you can get it with:
    sudo apt install qemu-system-x86

Once you get that installed, use the run.sh script from the project root to run the program.

You should also be able to use any other x86_64 emulator to start the resulting binary.

### How to Debug ?

There's a debug.gdb file located at the project root. It helps loading the debug symbols at the appropriate addresses when debugging with GDB. To generate the debug symbols you need to run `make debug` inside the project's root. This is not supported by the Dockerfile, so you'll have to run that locally. To `make debug` locally, you'll need to build the cross-compiler locally (use something like gen-cross-compiler.sh).

Once you built the symbols just run `gdb -x debug.gdb` inside the root of the project.

### Troubleshooting

- The docker commands may fail because you don't have enough priviledges. Make sure you belong to the docker group, or else run the commands with eleveated rights.
- If you're using the docker method to build the project you may encounter priviledge issues when trying to boot the resulting binary with `run.sh`. That may be because the generated binaries are belonging to the root user as a result of running the `docker run` command with elevated rights. Just change the owner of the resulting binary with something like `chown` and try again.
