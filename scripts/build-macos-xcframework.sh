#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output="${repository_root}/build/JiluoyunCore.xcframework"
work_directory="$(mktemp -d "${TMPDIR:-/tmp}/jiluoyun-core-macos.XXXXXX")"
trap 'rm -rf "${work_directory}"' EXIT

go_bin="$(go env GOPATH)/bin"
gomobile="${go_bin}/gomobile"
if [[ ! -x "${gomobile}" ]]; then
  echo "gomobile is not installed; run 'make bootstrap-mobile'" >&2
  exit 1
fi

mkdir -p "${repository_root}/build"
CLANG_MODULE_CACHE_PATH="${CLANG_MODULE_CACHE_PATH:-${work_directory}/clang-cache}" \
  "${gomobile}" bind \
  -target=macos \
  -macosversion=13.0 \
  -trimpath \
  -o "${work_directory}/JiluoyunCore.xcframework" \
  "${repository_root}/mobile"

"${repository_root}/scripts/verify-macos-xcframework.sh" \
  "${work_directory}/JiluoyunCore.xcframework"

rm -rf "${output}"
mv "${work_directory}/JiluoyunCore.xcframework" "${output}"
