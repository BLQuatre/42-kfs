#!/bin/sh
set -eu

APT_PACKAGES="make clang binutils grub-common grub-pc-bin xorriso qemu-system-x86"
BREW_PACKAGES="i686-elf-binutils i686-elf-grub xorriso qemu"

install_macos() {
	if ! command -v brew >/dev/null 2>&1; then
		echo "brew not found: install Homebrew (https://brew.sh) then rerun" >&2
		exit 1
	fi
	brew install $BREW_PACKAGES
}

install_debian() {
	SUDO=""
	if [ "$(id -u)" -ne 0 ]; then
		SUDO="sudo"
	fi
	$SUDO apt-get update
	$SUDO apt-get install -y --no-install-recommends $APT_PACKAGES
}

if [ "$(uname -s)" = "Darwin" ]; then
	install_macos
	exit 0
fi

if ! command -v apt-get >/dev/null 2>&1; then
	echo "apt-get not found: install manually: $APT_PACKAGES" >&2
	exit 1
fi

install_debian
