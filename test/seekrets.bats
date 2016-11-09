#!/usr/bin/env bats

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
