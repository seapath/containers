#!/bin/bash

usage()
{
    echo 'usage: check_Dockerfile.sh [-h] [--directory directory]'
    echo
    echo "Check Dockerfile syntax with hadolint of all files in the given directory"
    echo 'optional arguments:'
    echo ' -h, --help                  show this help message and exit'
    echo ' -d, --directory directory   the directory where to analyse. Default is .'
}

find_Dockerfiles()
{
    find "${1}" -type f -name Dockerfile
}

directory="."

options=$(getopt -o hd: --long directory:,help -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}

eval set -- "$options"
while true; do
    case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    -d|--directory)
        shift
        directory="$1"
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

exit_status=0
for Dockerfile in $(find_Dockerfiles "${directory}") ; do
    echo "test $Dockerfile"
    hadolint "$Dockerfile" || exit_status=1
done
exit "${exit_status}"
