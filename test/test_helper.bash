#!/usr/bin/env bats
REPO_PATH=$(mktemp -d "${BATS_TMPDIR}/gittest.XXXXXX")
LOCAL_SEEKRETS="$(dirname $BATS_TEST_DIRNAME)/seekret-rules"

setupGitRepo() {
    git init "${REPO_PATH}"
    git config --local gitseekret.rulespath "$LOCAL_SEEKRETS"
    git config --global gitseekret.rulespath "$LOCAL_SEEKRETS"
    (cd "${REPO_PATH}" && \
        git config user.email "example@example.com" && \
        git config user.name "Example User" && \
        git-seekret rules --enable-all)
}

cleanGitRepo() {
    (cd "${REPO_PATH}" && git reset --hard)
    rm -fr "${REPO_PATH}"
}

enableOnlyRuleFile() {
    local rule_file="$1"
    local rule_file_rules=$(cd "${REPO_PATH}" && git-seekret rules | grep "$1\." | awk ' { print $2 } ')

    (cd "${REPO_PATH}" && git-seekret rules --disable-all)
    for rf in $rule_file_rules; do
	(cd "${REPO_PATH}" && git-seekret rules --enable "${rf}")
    done
}

addFalseMandrillKey() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Fake keys in this file" >> "${secrets_file}"
    echo "MANDRILL_API_KEY => ENV['MANDRILL_API_KEY']" >> "${secrets_file}"
    echo "mandrill_api_key: ENV['MANDRILL_API_KEY']" >> "${secrets_file}"
}

addFalseMandrillPassword() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Fake passwords in this file" >> "${secrets_file}"
    echo "MANDRILL_PASSWORD: ENV['MANDRILL_PASSWORD']" >> "${secrets_file}"
    echo "MANDRILL_PASSWORD: ''" >> "${secrets_file}"
    echo "address\":smtp.mandrillaapp.compassword:1234" >> "${secrets_file}"
}

addFalseNewrelicSecrets() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "False secrets in this file" >> "${secrets_file}"
    echo "github.com/18f/#$(seq -s '' 2 1 25)" >> "${secrets_file}"
    echo "sha = $(seq -s '' 4 1 26)" >> "${secrets_file}"
    echo "revision: $(seq -s '' 6 1 27)" >> "${secrets_file}"
}

addMandrillKey() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Keys in this file" >> "${secrets_file}"
    echo "mandrill_api_key: p$(jot -s '' -w p%c 11 c)" >> "${secrets_file}"
}

addMandrillPassword() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Secrets in this file" >> "${secrets_file}"
    echo "MANDRILL_PASSWORD: pa+$(jot -s '' -w K%c 5 c)-$(jot -s '' -w K%c 5 c)%" >> "${secrets_file}"
    printf "export MANDRILL_PASSWORD" >> "${secrets_file}"
    echo "='TNT42__H1_18fZbbT+c41A'" >> "${secrets_file}"
}

addMandrillUsername() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Secrets in this file" >> "${secrets_file}"
    printf "MANDRILL_USERNAME"  >> "${secrets_file}"
    echo ": notauser@example.com" >> "${secrets_file}"
}

addNewrelicSecrets() {
    local secrets_file="$1"

    touch "${secrets_file}"
    echo "Secrets in this file" >> "${secrets_file}"
    printf "NEW_RELIC_LICENSE_KEY" >> "${secrets_file}"
    echo ": 6333476647d1758c8fe524655342a3c561ff45ac"  >> "${secrets_file}"
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
    printf "AWS_SECRET_ACCESS_KEY" >> "${secrets_file}"
    echo ": fhhlE5DalovdNsSVY3Zu0D/oi9RZF5gvEt6h7ofU" >> "${secrets_file}"
    printf "secretKey" >> "${secrets_file}"
    echo ":  fqhl4EDajovdNsSVV3Zu0F/oi9RZF5qvEt6h7bfU" >> "${secrets_file}"
    printf "key_id" >> "${secrets_file}"
    echo ": AKIALLVCLLYFEWP5MWXA" >> "${secrets_file}"
    printf "secret_key" >> "${secrets_file}"
    echo ": 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" >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithAwsAccounts() {
    local secrets_file="${REPO_PATH}/awsaccountsfile.md"

    touch "${secrets_file}"
    echo "SHHHH... Secrets in this file" >> "${secrets_file}"
    echo "aws_account_id=$(jot -s '-' 4 1024 5096)" >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithAwsAccessKey() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    echo "SHHHH... Secrets in this file" >> "${secrets_file}"
    echo "aws_key: $(seq -s '' 8 1 28)" >> "${secrets_file}"
    printf "AWS_ACCESS_KEY_ID" >> "${secrets_file}"
    echo ": AKIAJLLCKKYFEWP5MWXA    " >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithNewrelicSecrets() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addNewrelicSecrets "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithSomeNewrelicSecrets() {
    local secrets_file="${REPO_PATH}/somesecretsfile.md"

    touch "${secrets_file}"
    addFalseNewrelicSecrets "${secrets_file}"
    addNewrelicSecrets "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithFalseNewrelicSecrets() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addFalseNewrelicSecrets "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithFalseMandrillKey() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addFalseMandrillKey "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithFalseMandrillPassword() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addFalseMandrillPassword "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithMandrillKey() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addMandrillKey "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithMandrillPassword() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addMandrillPassword "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithMandrillUsername() {
    local secrets_file="${REPO_PATH}/secretsfile.md"

    touch "${secrets_file}"
    addMandrillUsername "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

addFileWithSlackAPIToken() {
    local secrets_file="${REPO_PATH}/slacktokenfile.md"

    touch "${secrets_file}"
    echo "SHHHH... Secrets in this file" >> "${secrets_file}"
    echo "slack_api_token=xoxo-11111111111-222222222222-333333333333-0123456789abcdef0123456789abcdef" >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}

setup() {
    setupGitRepo
}

teardown() {
    cleanGitRepo
}
