#!/bin/bash -eux

ENV_FILE='.env'
BRANCH="$(jq -r .branch "${ENV_FILE}")"
GIT_DIR="$(jq -r .git_dir "${ENV_FILE}")"

set -x
pushd ${GIT_DIR}
  git clean -df
  git reset --hard HEAD
  git fetch origin
  git checkout "origin/${BRANCH}" -B "${BRANCH}"

  ./hook.sh
popd

set +x
sudo shutdown -h now
