#!/usr/bin/env bats

setup() {
    # Preserve enabled rulesets before each test
    BATS_SEEKRETS_SAVED_RULES=$(git-seekret rules | grep '\[x\] '| awk ' { print $2 } ')
}

teardown() {
    # Re-enable preserved rulesets post test
    for seeketrule in $BATS_SEEKRETS_SAVED_RULES
    do
	git-seekret rule --enable "${seekretrule}"
    done
}
