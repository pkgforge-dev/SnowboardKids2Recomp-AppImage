#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	libdecor  	   \
	pipewire-audio \
	pipewire-jack  \
	sdl2	 	   \
	vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Getting app..."
echo "---------------------------------------------------------------"
case "$ARCH" in # they use X64 and ARM64 for the zip links
	x86_64)  zip_arch=Linux-X64;;
	aarch64) zip_arch=Linux-ARM64;;
esac
ZIP_LINK=$(wget -qO- https://api.github.com/repos/cdlewis/snowboardkids2-recomp/releases \
      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*SnowboardKids2Recompiled.*${zip_arch}-Release.tar.gz")
echo "$ZIP_LINK" | awk -F'/' '{gsub(/^v/, "", $(NF-1)); print $(NF-1); exit}' > ~/version
wget --retry-connrefused --tries=30 "$ZIP_LINK" -O /tmp/app.tar.gz

mkdir -p ./AppDir/bin
bsdtar -xvf /tmp/app.tar.gz -C ./AppDir/bin
wget -q -O ./AppDir/bin/recompcontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt
