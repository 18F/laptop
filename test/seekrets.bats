#!/usr/bin/env bats
#
# bats test file for testing git seekrets and
# seekrets rulesets
#
# Prerequisites:
#     * git seekrets is installed (cf. seekrets-install)
#
# Installation:
#     * Use the laptop script via ~/.laptop.local
#
#              echo 'bats' >> ~/.laptop.local
#
#     * homebrew method
#
#              brew install bats
#
# Running Tests:
#
#              bats seekrets.bat

load test_helper

@test "no args gives usage instructions" {
    run git-seekret
    [ $status -eq 0 ]
    [ $(expr "${lines[2]}" : "USAGE:") -ne 0 ]
}

@test "option --version prints version number" {
    run git-seekret --version
    [ $status -eq 0 ]
    [ $(expr "$output" : "git-seekret version [0-9][0-9.]*") -ne 0 ]
}

@test "config command with no options shows config" {
    run git-seekret rules
    [ $status -eq 0 ]
    [ $(expr "${lines[0]}" : "List of rules:") -ne 0 ]
}

@test "rules command with no options gives a listing of rules" {
    run git-seekret rules
    [ $status -eq 0 ]
    [ $(expr "${lines[0]}" : "List of rules:") -ne 0 ]
}

@test "git-seekrets does find aws secrets in test repo" {
    run addFileWithAwsSecrets
    [ $(echo "$output" | grep -c 'Found Secrets: 2') -eq 1 ]
}

@test "git-seekrets does find aws accounts in test repo" {
    run addFileWithAwsAccounts
    [ $(echo "$output" | grep -c 'Found Secrets: 1') -eq 1 ]
}

@test "git-seekrets does find aws access keys in test repo" {
    run addFileWithAwsAccessKey
    [ $(echo "$output" | grep -c 'Found Secrets: 2') -eq 1 ]
}

@test "git-seekrets does not find newrelic keys as aws keys in test repo" {
    enableOnlyRuleFile "aws"
    run addFileWithNewrelicSecrets
    [ $(echo "$output" | grep -c 'Found Secrets: 0') -eq 1 ]
}

@test "git-seekrets does find newrelic secrets in test repo" {
    run addFileWithNewrelicSecrets
    [ $(echo "$output" | grep -c 'Found Secrets: 1') -eq 1 ]
}

@test "git-seekrets does not find newrelic false positives in test repo" {
    run addFileWithFalseNewrelicSecrets
    [ $(echo "$output" | grep -c 'Found Secrets: 0') -eq 1 ]
}

@test "git-seekrets only matches newrelic secrets in test repo" {
    run addFileWithSomeNewrelicSecrets
    [ $(echo "$output" | grep -c 'Found Secrets: 1') -eq 1 ]
}

@test "git-seekrets does find mandrill keys in test repo" {
    run addFileWithMandrillKey
    [ $(echo "$output" | grep -c 'Found Secrets: 1') -eq 1 ]
}

@test "git-seekrets does not find mandrill key false positives in test repo" {
    run addFileWithFalseMandrillKey
    [ $(echo "$output" | grep -c 'Found Secrets: 0') -eq 1 ]
}

@test "git-seekrets does find mandrill passwords in test repo" {
    run addFileWithMandrillPassword
    [ $(echo "$output" | grep -c 'Found Secrets: 2') -eq 1 ]
}

@test "git-seekrets does not find mandrill password false positives in test repo" {
    run addFileWithFalseMandrillPassword
    [ $(echo "$output" | grep -c 'Found Secrets: 0') -eq 1 ]
}

@test "git-seekrets does find mandrill usernames in test repo" {
    run addFileWithMandrillUsername
    [ $(echo "$output" | grep -c 'Found Secrets: 1') -eq 1 ]
}

@test "git-seekrets does find slack api token in test repo" {
    run addFileWithSlackAPIToken
    [ $(echo "$output" | grep -c 'Found Secrets: 1') -eq 1 ]
}

@test "git-seekrets does not find secrets in test repo" {
    run addFileWithNoSecrets
    [ $(echo "$output" | grep -c 'Found Secrets: 0') -eq 1 ]
}

@test "git-seekrets can disable all rulesets" {
    run git-seekret rules --disable-all
    [ $status -eq 0 ]
    [ $(echo "$output" | grep -c '\[x\]') -eq 0 ]
}

@test "git-seekrets can enable all rulesets" {
    run git-seekret rules --enable-all
    [ $status -eq 0 ]
    [ $(echo "$output" | grep -c '\[x\]') -gt 0 ]
}
