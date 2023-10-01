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
        cd ${ROOT_PATH}/terraform/aws
        echo "Running tests"
        terraform init \
            -reconfigure \
            -backend-config="path=${ROOT_PATH}/state/${PROFILE}/${PREFIX}/ec2_backend.tfstate"

        terraform plan \
            -out=tfplan \
            -input=false \
            -refresh=true \
            -var-file="${ROOT_PATH}/profiles/${PROFILE}/tf_vars.tfvars" \
            -var="prefix=${PREFIX}" \
            -var="profile=${PROFILE}" \
            -var="pipe_root=${ROOT_PATH}"

        terraform-compliance -f ${ROOT_PATH}/tests \
                             -p ${ROOT_PATH}/terraform/aws/tfplan
        shift
        ;;
    'deploy' | 'cleanup')
        cd ${ROOT_PATH}/terraform/aws

        terraform init \
            -reconfigure \
            -backend-config="path=${ROOT_PATH}/state/${PROFILE}/${PREFIX}/ec2_backend.tfstate"

        if [[ "deploy" == "${COMMAND}"  ]]; then
                    terraform plan \
                        -out=${ROOT_PATH}/terraform/aws/tfplan \
                        -input=false \
                        -refresh=true \
                        -var-file="${ROOT_PATH}/profiles/${PROFILE}/tf_vars.tfvars" \
                        -var="prefix=${PREFIX}" \
                        -var="profile=${PROFILE}" \
                        -var="pipe_root=${ROOT_PATH}"

                    terraform apply \
                        -input=false \
                        tfplan

        elif [[ "${COMMAND}" == "cleanup" ]]; then
                    terraform destroy \
                        -input=false \
                        -refresh=true \
                        -auto-approve \
                        -var-file="${ROOT_PATH}/profiles/${PROFILE}/tf_vars.tfvars" \
                        -var="prefix=${PREFIX}" \
                        -var="profile=${PROFILE}" \
                        -var="pipe_root=${ROOT_PATH}"
            fi
        shift
        ;;
    *)
        echo "Not specified an action!"
        exit 1
esac


