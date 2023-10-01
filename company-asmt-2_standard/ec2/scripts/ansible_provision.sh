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
        case ${i} in
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
            --docker_login=*)
            DOCKER_LOGIN="${i#*=}"
            echo "Defined docker login - ${DOCKER_LOGIN}"
            shift # past argument=value
            ;;
            --docker_pass=*)
            DOCKER_PASS="${i#*=}"
            shift # past argument=value
            ;;
        esac
    done

source ${ROOT_PATH}/profiles/${PROFILE}/cred.txt
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
export ANSIBLE_CONFIG="${ROOT_PATH}/ansible/ansible.cfg"
export EC2_INI_PATH="${ROOT_PATH}/ansible/.aws.ini"

chmod 600 ${ROOT_PATH}/profiles/${PROFILE}/ssh/${PREFIX}

case ${COMMAND} in
    'help')
        echo "Helpdesk"
        shift
        ;;
    'validate')
        cd ${ROOT_PATH}/ansible
        echo "Running tests"

        shift
        ;;
    'bastion')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        ansible-playbook bastion.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*_bastion_*" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'ci')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        ansible-playbook ci.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*_ci_*" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'database')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        ansible-playbook database.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*_ci_*" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'proxy')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        ansible-playbook proxy.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*_proxy_*" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'app-soft-install')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        ansible-playbook app_soft_install.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*_application_*" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'app-build')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        ansible-playbook ci_build_app.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*_ci_*" \
            -e "docker_login=${DOCKER_LOGIN}" \
            -e "docker_pass=${DOCKER_PASS}" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'app-startup')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        ansible-playbook app_startup.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*_application_*" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'instance')
        cd ${ROOT_PATH}/ansible
        PROVISION_USER="ubuntu"

        echo $(${ROOT_PATH}/ansible/aws.py --list) >> ${ROOT_PATH}/ansible/test.json
        cat ${ROOT_PATH}/ansible/test.json

        shift
        ;;
    *)
        echo "Not specified an action!"
        exit 1
esac


