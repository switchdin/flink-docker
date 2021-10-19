#!/bin/bash -e

# Use this script to build the Dockerfiles against an arbitrary
# Flink distribution.
# This is exlusively for development purposes.

source "$(dirname "$0")"/generator.sh

function usage() {
    echo >&2 "usage: $0 -s server_url -b binary-download -p pyflink_whl -l pyflink_lib_whl [-n name] [-j java_version]"
}

server=
binary_download=
pyflink_whl=
pyflink_lib_whl=
name=custom
java_version=8

while getopts s:b:p:l:n:j:h arg; do
  case "$arg" in
    s)
      server=$OPTARG
      ;;
    b)
      binary_download=$OPTARG
      ;;
    p)
      pyflink_whl=$OPTARG
      ;;
    l)
      pyflink_lib_whl=$OPTARG
      ;;
    n)
      name=$OPTARG
      ;;
    j)
      java_version=$OPTARG
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      usage
      exit 1
      ;;
  esac
done

if [[ -z "${server}" ]] || [[ -z "${binary_download}" ]] || [[ -z "${pyflink_whl}" ]] || [[ -z "${pyflink_lib_whl}" ]]; then
    usage
    exit 1
fi

mkdir -p "dev"

echo -n >&2 "Generating Dockerfiles..."
for source_variant in "${SOURCE_VARIANTS[@]}"; do
  dir="dev/${name}-${source_variant}"
  rm -rf "${dir}"
  mkdir "$dir"
  generateDockerfile "${dir}" "${server}" "" "" false ${java_version} ${source_variant} "${binary_download}" "${pyflink_whl}" "${pyflink_lib_whl}"
done
echo >&2 " done."
