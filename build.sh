#!/bin/bash -e

function main() {
    local do_build=true
    if [[ "$1" == "--skip-build" ]]; then
        do_build=false
        shift
    fi
    local fe_path="${1:?No frontend path passed}"
    local be_path="${2:?No backend path passed}"
    local arch="${3}"

    if $do_build; then
        cleanup

        buildFrontend "$fe_path"

        buildBackend "$be_path"

        copyBackend "$be_path" "./src"

        copyFrontend "$fe_path" "./src/src/main/resources/static"
    fi

    buildContainer "$arch"

}

function buildContainer() {
    local arch="$1"
    podman build ${arch:+--arch=$arch} .
}

function cleanup() {
    rm -rf ./src
}

function buildFrontend() {
    local fe_path="${1:?No frontend path passed}"
    
    cd "${fe_path}"
    rm -rf node_modules
    yarn install --frozen-lockfile
    yarn run build
    cd -
}

function buildBackend() {
    local be_path="${1:?No backend path passed}"

    cd "${be_path}"
    ./gradlew build
    cd -
}

function copyBackend() {
    local be_path="${1:?No backend path passed}"
    local be_dest_path="${2:?No backend destination path passed}"

    cp -a "${be_path}" "${be_dest_path}"
}

function copyFrontend() {
    local fe_path="${1:?No frontend path passed}"
    local fe_dest_path="${2:?No frontend destination path passed}"

    cp -a "${fe_path}/build" "${fe_dest_path}"
}

main "$@"
