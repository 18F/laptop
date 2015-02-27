## Welcome!

We're so glad you're thinking about contributing to an 18F open source project!
If you're unsure or afraid of anything, just ask or submit the issue or pull
request anyways. The worst that can happen is that you'll be politely asked to
change something. We appreciate any sort of contribution, and don't want a
wall of rules to get in the way of that.

Before contributing, we encourage you to read our CONTRIBUTING policy
(you are here), our LICENSE, and our README, all of which should be in this
repository. If you have any questions, or want to read more about our
underlying policies, you can consult the 18F Open Source Policy GitHub
repository at https://github.com/18f/open-source-policy, or just shoot us an
email/official government letterhead note to [18f@gsa.gov](mailto:18f@gsa.gov).

## Contributing to the laptop script

Edit the `mac` file.
If you added or removed any tools, document your changes in the `README.md`
file.
Follow shell style guidelines by using [ShellCheck].

```sh
# Install shellcheck
brew install shellcheck

# Run shellcheck from the root of the repo
shellcheck mac
```

[ShellCheck]: http://www.shellcheck.net/about.html

## Public domain

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain dedication][CC0].

[CC0]: https://creativecommons.org/publicdomain/zero/1.0/

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
