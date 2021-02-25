#!/bin/bash -eux

ENV_FILE='.env'
INSTANCE_ID="$(jq -r .instance_id "${ENV_FILE}")"
INSTANCE_REGION="$(jq -r .instance_region "${ENV_FILE}")"
BRANCH="$(jq -r .branch "${ENV_FILE}")"
SSH_REMOTE="$(jq -r .ssh_remote "${ENV_FILE}")"
GIT_DIR="$(jq -r .git_dir "${ENV_FILE}")"

aws ec2 start-instances --region "${INSTANCE_REGION}" --instance-ids "${INSTANCE_ID}"

RUNNING_INSTANCE=""

while [ -z "${RUNNING_INSTANCE}" ]
do
    sleep 5
    RUNNING_INSTANCE=$(
	aws ec2 describe-instances \
	    --region "${INSTANCE_REGION}" \
	    --instance-ids "${INSTANCE_ID}" \
	    --filters="Name=instance-state-name,Values=running" \
	    --query 'Reservations[].Instances[].[InstanceId]' \
	    --output text
    )
done
