#!/usr/bin/env bash

set -e

script_dir=$(cd $(dirname $0) && pwd)

if [[ -f "config" ]]; then
    source config
else
    echo "config does not exist."
    exit 1
fi

make_dir() {
    local _dir
    for _dir in ${@}; do
        if [[ ! -d "${_dir}" ]]; then
            mkdir -p "${_dir}"
        fi
    done
}


make_dir "${iso_dir}"
make_dir "${out_dir}"
make_dir "${work_dir}"
make_dir "${work_dir}"/mount

