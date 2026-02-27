#!/usr/bin/env bash
set -euo pipefail

build_type="${1:-Release}"

conan profile detect --force
conan install . --build=missing -s build_type="${build_type}"

cmake --build build/${build_type} -j "$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)"
