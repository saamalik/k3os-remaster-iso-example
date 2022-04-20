#!/bin/bash
set -eo pipefail

: "${K3OS_ISO:?}"
: "${K3OS_CONFIG:?}"
K3OS_REMASTERED_FILENAME="k3os-custom.iso"

COLOR_CYAN="\033[1;36m"
COLOR_WHITE="\033[1;37m"
COLOR_RED="\033[0;31m"
NO_COLOR="\033[0m"

create_iso () {
    echo
    echo -e "${COLOR_CYAN}###################################################################################################################${NO_COLOR}"
    echo -e "${COLOR_WHITE}Creating remastered k3os ${K3OS_RELEASE_VERSION} ISO file ${NO_COLOR}"
    echo

    mkdir -p /source
    mkdir -p /iso/boot/grub
    mount -o loop "$K3OS_ISO" /source

    cp -rf /source/k3os /iso/
    cp -f "$K3OS_CONFIG" /iso/k3os/system/config.yaml
    cp -f grub.cfg /iso/boot/grub/grub.cfg
    grub-mkrescue -o ${K3OS_REMASTERED_FILENAME} /iso/ -- -volid K3OS

    if [[ ! -f ./${K3OS_REMASTERED_FILENAME} ]]; then
        echo -e "${COLOR_RED}Remastered ISO file could not be created. ${NO_COLOR}"
        exit 1
    fi

    echo
    echo -e "${COLOR_CYAN}###################################################################################################################${NO_COLOR}"
    echo -e "${COLOR_WHITE}Remastered k3os ISO file ${K3OS_REMASTERED_FILENAME} successfully created. ${NO_COLOR}"
    echo
}

echo
echo -e "${COLOR_CYAN}###################################################################################################################${NO_COLOR}"
echo -e "${COLOR_WHITE}Check k3os release version ${NO_COLOR}"
echo


if [[ ! -f $K3OS_ISO ]]; then
    echo -e "${COLOR_RED}File ${K3OS_ISO} could not be found. ${NO_COLOR}"
    exit 1
fi

if [[ ! -f $K3OS_CONFIG ]]; then
    echo -e "${COLOR_RED}File ${K3OS_CONFIG} could not be found. ${NO_COLOR}"
    exit 1
fi

create_iso
