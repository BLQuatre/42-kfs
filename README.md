# kfs

A minimal i386 kernel written in C and assembly, booted by GRUB through Multiboot. It prints to the screen by writing directly to VGA text memory.

## Layout

- `arch/i386/` — boot code, linker script, GRUB config
- `src/` — kernel entry, VGA driver, string lib
- `include/` — headers

## Dependencies

On Debian/Ubuntu:

```sh
./install_deps.sh
```

Installs `make`, `clang`, `binutils`, `grub-common`, `grub-pc-bin`, `xorriso` and `qemu-system-x86`.

## Build

```sh
make
```

Produces `kfs.iso` at the repo root. Intermediate files go to `build/`.

## Run

```sh
make run
```

Boots the ISO in QEMU (`qemu-system-i386`).

## Clean

```sh
make clean   # remove build/
make fclean  # also remove kfs.iso
make re      # fclean then build
```
