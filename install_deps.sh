#!/bin/sh
set -eu

PACKAGES="make clang binutils grub-common grub-pc-bin xorriso qemu-system-x86"

if ! command -v apt-get >/dev/null 2>&1; then
	echo "apt-get not found: install manually: $PACKAGES" >&2
	exit 1
fi

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
	SUDO="sudo"
fi

$SUDO apt-get update
$SUDO apt-get install -y --no-install-recommends $PACKAGES
