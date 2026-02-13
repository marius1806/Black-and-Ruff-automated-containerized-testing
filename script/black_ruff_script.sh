#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)

parsed="$(
../../../docopts/docopts_linux_amd64 -V -h -V "$@" << EOF
Usage: black_ruff_script [options]...

Options:
  --black-version=<black>        Choose black package version
  --ruff-version=<ruff>          Choose ruff package version
  --mount-path=<path>            Choose source code path
  -h, --help                     Show help options
  -v, --version                  Print program version
....

black_ruff_script 1.0.0
Copyright (C) 2025
Created by Gabriel Marius Stancu
License PROPRIETARY
EOF
)"

blackVersion=24.8.0  # default black version
ruffVersion=0.5.7    # default ruff version
mountPath=/src       # default source code mount path

eval "$parsed"

if [[ $black_version ]]; then blackVersion=$black_version; fi
if [[ $ruff_version ]]; then ruffVersion=$ruff_version; fi
if [[ $mount_path ]]; then mountPath=$mount_path; fi

podman build -t black_ruff_image $SCRIPT_DIR

podman run --name black_ruff_container -v ../../:$mountPath -d black_ruff_image

podman exec -it black_ruff_container pip install black==$blackVersion
if [[ $? -ne 0 ]]; then
    podman image rm black_ruff_image --force
    echo "Installation error!"
    exit 1
else
    echo "Black succesfully installed!"
fi

podman exec -it black_ruff_container pip install ruff==$ruffVersion
if [[ $? -ne 0 ]]; then
    podman image rm black_ruff_image --force
    echo "Installation error!"
    exit 1
else
    echo "Ruff succesfully installed!"
fi
