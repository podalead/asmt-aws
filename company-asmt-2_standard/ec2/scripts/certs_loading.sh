#!/usr/bin/env bash

#!/usr/bin/env bash

set -e

ROOT_PATH=$(pwd)

if [[ "${ROOT_PATH}" =~ "scripts" ]];
 then
    ROOT_PATH="${ROOT_PATH}/.."
fi

echo "Defined path - ${ROOT_PATH}"

if [[ -n $1 ]]; then
    COMMAND=$1
    echo $1
fi

for i in "$@"
    do
        case $i in
            --prefix=*)
            PREFIX="${i#*=}"
            echo "Defined command - ${COMMAND}"
            shift # past argument=value
            ;;
            --profile=*)
            PROFILE="${i#*=}"
            echo "Defined prefix - ${PREFIX} and profile - ${PROFILE}"
            shift # past argument=value
            ;;
        esac
    done

source ${ROOT_PATH}/profiles/${PROFILE}/cred.txt
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

case ${COMMAND} in
    'help')
        echo "Helpdesk"
        shift
        ;;
    'test')
        cd ${ROOT_PATH}/ansible
        echo "Running tests"

        shift
        ;;
    'deploy')
        cd ${ROOT_PATH}/ansible
        echo "Upload certs"

        export EC2_INI_PATH="$(pwd)/.aws.ini"
        export ANSIBLE_CONFIG="$(pwd)/ansible.cfg"

        ansible-playbook aws_certs.yml \
            -i aws.py \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    *)
        echo "Not specified an action!"
        exit 1
esac


