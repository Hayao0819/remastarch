#!/usr/bin/env bash

set -e

script_dir=$(cd $(dirname $0) && pwd)


make_dir() {
    local _dir
    for _dir in ${@}; do
        if [[ ! -d "${_dir}" ]]; then
            mkdir -p "${_dir}"
        fi
    done
}


if [[ -f "config" ]]; then
    source config
else
    echo "config does not exist."
    exit 1
fi

isolist=( $(ls -d "${iso_dir}"/*.iso ) )


if [[ ${#isolist[@]} = 0 ]]; then
    echo "There is not iso in ${iso_dir}"
    exit 1
elif [[ ${#isolist[@]} = 1 ]]; then
    selectediso=${isolist[@]}
else
    ask_iso() {
        local iso
        local i
        local input
        i=1
        echo "Which iso?"
        for iso in "${isolist[@]}"; do
            echo "${i}: ${iso}"
            i=$(( i + 1 ))
        done

        echo -n ": "
        read input

        selectediso=${isolist[ $(( input - 1 )) ]}
    }
    ask_iso
fi

echo "Use ${selectediso}"


# mount iso
make_dir "${work_dir}"/mount
fuseiso "${selectediso}" "${work_dir}"/mount


# Copy airootfs.sfs
cp $(find "${work_dir}"/mount -name airootfs.sfs) "${work_dir}"

# Unmount iso
fusermount -u "${work_dir}"/mount
rm -rf "${work_dir}"/mount

# Unpack airootfs.sfs
cd "${work_dir}"
sudo unsquashfs "${work_dir}"/airootfs.sfs
cd - > /dev/null


# Finish
echo "以下のコマンドを実行してカスタマイズして下さい"
echo "sudo arch-chroot \"${work_dir}\"/squashfs-root"
