#!/bin/bash
set -e
#--------------------------------------------------------------
# docker context set & use
#--------------------------------------------------------------
#--------------------------------------------------------------
# Varibles
#--------------------------------------------------------------

# usage function
function usage () {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    if [ -n "${1}" ]; then
        printf "%b%s%b\n" "${RED}" "${1}" "${NC}"
    fi
    cat <<EOF

This command docker context create and docket context use.

Usage:
    $(basename "${0}") -c yourcontext -u youruser -s hostname
    $(basename "${0}") -c vscode-remote-container -u ec2-user -s ec2-dev

Options:
    -c {your context}   docker context name.
    -s {hostname}       Specify the hostname configured in ~/.ssh/config.
    -u {user}           Specify the user name for SSH login.
    -h                  Usage $(basename "${0}")
EOF
    exit 1
}
while getopts c:hs:u: opt
do
    case $opt in
        c ) CONTEXT=$OPTARG ;;
        h ) usage ;;
        s ) HOST=$OPTARG ;;
        u ) USER=$OPTARG ;;
        \? ) usage ;;
    esac
done

if [ -z "${CONTEXT}" ]; then
    usage "need to set -c option"
fi

context=$(docker context list | grep ^${CONTEXT})
if [ -z "${context}" ]; then
    if [ -z "${USER}" ]; then
    usage "need to set -u option"
    fi
    if [ -z "${HOST}" ]; then
        usage "need to set -s option"
    fi
    docker context create ${CONTEXT} --docker "host=ssh://${USER}@${HOST}"
fi
docker context list
docker context use ${CONTEXT}
