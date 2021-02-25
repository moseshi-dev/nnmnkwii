#!/bin/bash -eux

ENV_FILE='.env'
SSH_REMOTE="$(jq -r .ssh_remote "${ENV_FILE}")"

./start_instance.sh

ssh "${SSH_REMOTE}" "~/exec_hook_and_shutdown.sh"
