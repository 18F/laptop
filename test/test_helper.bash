#!/usr/bin/env bats

REPO_PATH=$(mktemp -d "${BATS_TMPDIR}/gittest.XXXXXX")

setupGitRepo() {
    git init "${REPO_PATH}"
    (cd "${REPO_PATH}" && git-seekret rules --enable-all)
}

cleanGitRepo() {
    (cd "${REPO_PATH}" && git reset --hard)
    rm -fr "${REPO_PATH}"
}

addFalseMandrillKey() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Fake keys in this file" >> "${secrets_file}"
    echo "password: ENV['MANDRILL_API_KEY']" >> "${secrets_file}"
}

addFalseNewrelicSecrets() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "False secrets in this file" >> "${secrets_file}"
    echo "github.com/18f/#$(seq -s '' 2 1 25)" >> "${secrets_file}"
    echo "sha = $(seq -s '' 4 1 26)" >> "${secrets_file}"
    echo "revision: $(seq -s '' 6 1 27)" >> "${secrets_file}"
}

addNewrelicSecrets() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Secrets in this file" >> "${secrets_file}"
    echo "$(seq -s '' 2 1 25)" >> "${secrets_file}"
}

addFileWithNoSecrets() {
    local filename="${REPO_PATH}/plainfile.md"

    touch "${filename}"
    echo "Just a plain old file" >> "${filename}"
    (cd "${REPO_PATH}" && git add "${filename}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithAwsSecrets() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    echo "SHHHH... Secrets in this file" >> "${secrets_file}"
    echo "aws_secret_key: $(seq -s '' 8 1 28)" >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secretsfile}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithAwsAccounts() {
    local secrets_file="${REPO_PATH}/awsaccountsfile.md"

    touch "${secrets_file}"
    echo "SHHHH... Secrets in this file" >> "${secrets_file}"
    echo "aws_account_id=$(jot -s '-' 4 1024 5096)" >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secretsfile}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithNewrelicSecrets() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addNewrelicSecrets "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secretsfile}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithSomeNewrelicSecrets() {
    local secrets_file="${REPO_PATH}/somesecretsfile.md"

    touch "${secrets_file}"
    addFalseNewrelicSecrets "${secrets_file}"
    addNewrelicSecrets "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secretsfile}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithFalseNewrelicSecrets() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addFalseNewrelicSecrets "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secretsfile}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithFalseMandrillKey() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addFalseMandrillKey "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secretsfile}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

setup() {
    setupGitRepo
}

teardown() {
    cleanGitRepo
}
