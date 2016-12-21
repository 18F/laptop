Testing for the `git-seekrets` is performed via a testing framework called
[BATS](https://github.com/sstephenson/bats).  To create an associated test
for new seekrets rulesets, it is necessary to install BATS.   More
information on installation is located in the `seekrets.bats` script.

Below is an example invocation for running the seekrets test with
BATS:

        bats --tap seekrets.bat


More information on the TAP format is available at the following
address http://testanything.org/

## Adding new tests

The tests for `git-seekret` are located in `seekrets.bats`.  The following would describe a test case for a matching a new secret:

```shell
@test "git-seekrets finds a new type of secret"
    run addFileWithNewTypeOfSecret
    [ $status -gt 0 ]
}
```

Helper and test function definitons are located in `test_helper.bash` in the test directory of this repository.  An associated test function for the above example test could be structured like:

```shell
addFileWithNewTypeOfSecret() {
    local secrets_file="${REPO_PATH}/newsecretfile.md"

    touch "${secrets_file}"
    echo "new secret: SOME_SECRET_ACCESS_INFO" >> "${secrets_file}"
    (cd "${REPO_PATH}" && git add "${secrets_file}")
    (cd ${REPO_PATH} && git commit -m 'test commit')
}
```

A test case for a false positive match (with associated test function in `test_helper.bash`) would be structured as:

```shell
@test "git-seekrets does not find false positives for a new type of secret"
    run addFileWithFalseNewTypeOfSecret
    [ $status -eq 0 ]
}
```


