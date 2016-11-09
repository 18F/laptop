#!/usr/bin/env bats

GIT_TESTREPO="gittest"
REPO_PATH="${BATS_TMPDIR}/${GIT_TESTREPO}"

setupGitRepo() {
    git init "${REPO_PATH}"
}

cleanGitRepo() {
    (cd "${REPO_PATH}" && git reset --hard)
}

addFileWithNoSecrets() {
    local filename="${REPO_PATH}/plainfile.md"

    touch "${filename}"
    echo "Just a plain old file" >> "${filename}"
    (cd "${REPO_PATH}" && git add "${filename}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithSecrets() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    echo "SHHHH... Secrets in this file" >> "${secrets_file}"
    echo "key: $(seq -s '' 0 1 24)" >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secretsfile}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

setup() {
    setupGitRepo
}

teardown() {
    cleanGitRepo
}
