Laptop
======
[![Build Status](https://circleci.com/gh/18F/laptop.svg)](https://circleci.com/gh/18F/laptop)

Laptop is a script to set up an OS X computer for web development, and to keep
it up to date.

It can be run multiple times on the same machine safely.
It installs, upgrades, or skips packages
based on what is already installed on the machine.

Requirements
------------

We support:

* [macOS Sierra (10.12)](https://www.apple.com/osx/)
* OS X El Capitan (10.11)
* OS X Yosemite (10.10)
* OS X Mavericks (10.9)

Older versions may work but aren't regularly tested. Bug reports for older
versions are welcome.

Install
-------

Begin by opening the Terminal application on your Mac. The easiest way to open
an application in OS X is to search for it via [Spotlight]. The default
keyboard shortcut for invoking Spotlight is `command-Space`. Once Spotlight
is up, just start typing the first few letters of the app you are looking for,
and once it appears, press `return` to launch it.

In your Terminal window, copy and paste the command below, then press `return`.

```sh
bash <(curl -s https://raw.githubusercontent.com/18F/laptop/master/laptop)
```
The [script](https://github.com/18F/laptop/blob/master/mac) itself is
available in this repo for you to review if you want to see what it does
and how it works.

Note that the script will ask you to enter your OS X password at various
points. This is the same password that you use to log in to your Mac.
If you don't already have it installed, GitHub for Mac will launch
automatically at the end of the script so you can set up everything you'll
need to push code to GitHub.

**Once the script is done, make sure to quit and relaunch Terminal.**

More [detailed instructions with a video][video] are available in the Wiki.

It is highly recommended to run the script regularly to keep your computer
up to date. Once the script has been installed, you'll be able to run it
at your convenience by typing `laptop` and hitting `return` in your Terminal.

[Spotlight]: https://support.apple.com/en-us/HT204014
[video]: https://github.com/18F/laptop/wiki/Detailed-installation-instructions-with-video

### Want to install just git-seekret?
In your terminal window, copy and paste the following line, and press `return`:
```sh
curl -s https://raw.githubusercontent.com/18F/laptop/master/seekrets-install | bash -
```
Note that the script may ask you to enter your password. This is the same password that you use to log in to your computer.

**git-seekret will install global git hooks into ~/.git-support/hooks.   To restore pre-existing git hooks, it is recommended to save pre-existing hooks into a separate directory and to copy those hooks into ~/.git-support/hooks after git-seekret is installed.**

Development
-----------

### Git Seekret

This section covers contributing and developing new rulesets for `git-seekrets`.

The rules installed by the `seekret-install` script are located in the `seekret-rules` directory at the root of this repository.  Inside each rule file is a list of rules.  The rule file can be considered a tree with the rules as the leaves of the tree.

An example rule file is below:

```yaml
thing_to_match:
  match: r[egx]{2,}p?
  unmatch:
    - some_prefix\s*r[egx]{2,}p?
    - r[egx]{2,}p?\s*some_suffix
```

Using the example above, let's break down each stanza:

- `thing_to_match` : The name of the rule we'd like to match / unmatch. This can be anything that makes sense for the `.rule` file being created / edited.
- `match` : A single regular expression which will be used to match any rules for the name above.
- `unmatch` : A list of regular expressions which will be used to unmatch anything that the `match` rule matches.

Feel free to submit an issue/create a pull request in order to submit a new ruleset or to apply a modifification to an existing ruleset.

#### Testing Git Seekrets

You can test secret rulesets using BATS for automated testing and manually using the installation script.

##### Let's talk about BATS

Please read the [local BATS documentation](./test).

##### Let's talk about local manual testing

To install the `*.rule` files located in the repo, just run the installation script locally. This will update your local `~/.git-support/seekret-rules` directory with the changes in this repository.

```shell
./seekrets-install
```

You should now be able to run the check within any repository on your machine.

```shell
git seekret check -c 0 # check for secrets within commit history
```

```shell
git seekret check -s # check for secrets within staged files
```

**Don't forget to add the rule to `SEEKRET_DEFAULT_RULES` if your PR for a new rule is accepted**

```shell
SEEKRET_DEFAULT_RULES=" # <= default ruleset if installed via curl
 aws.rule
 newrelic.rule
 mandrill.rule
 new.rule"
```

Debugging
---------

Your last Laptop run will be saved to `~/laptop.log`. Read through it to see if
you can debug the issue yourself. If not, copy and paste the entire log into a
[new GitHub Issue](https://github.com/18F/laptop/issues/new) for us.

#### Git Seekrets False Positives

Sometimes the `git-seekrets` rules may indicate a false positive and match
things that aren't actually secrets. This can happen if the regular
expressions used to `match` and `unmatch` are too strict.

Make sure you have [the latest rulesets from this repository by running the
git-seekrets installation script](#want-to-install-just-git-seekret).

If the ruleset is still triggering a false positive, please open an issue
(or a pull request if you know how to fix the regular expression), and
include the text that is being treated as a false positive, along with the
rules installed on your computer. Please run this command to output
your current rules, then copy and paste them into the GitHub issue:

```shell
cat ~/.git-support/seekret-rules/*.rule
```

What it sets up
---------------

* [chruby] for managing [Ruby] versions
* [CloudApp] for sharing screenshots and making an animated GIF from a video
* [Cloud Foundry CLI] for command line access to 18F's Cloud Foundry-based application platform
* [Flux] for adjusting your Mac's display color so you can sleep better
* [git-seekret] for preventing you from committing passwords and other sensitive information to a git repository
* [GitHub Desktop] for setting up your SSH keys automatically
* [Homebrew] for managing operating system libraries
* [Homebrew Cask] for quickly installing Mac apps from the command line
* [Homebrew Services] so you can easily stop, start, and restart services
* [hub] for interacting with the GitHub API
* [MySQL] for storing relational data
* [nvm] for managing Node.js versions if you do not have [Node.js] already installed (Includes latest [Node.js] and [NPM], for running apps and installing JavaScript packages)
* [PhantomJS] for headless website testing
* [Postgres] for storing relational data
* [pyenv] for managing Python versions if you do not have [Python] already installed (includes the latest 3.x [Python])
* [Redis] for storing key-value data
* [ruby-install] for installing different versions of Ruby
* [Slack] for communicating with your team
* [Sublime Text 3] for coding all the things
* [The Silver Searcher] for finding things in files
* [Virtualenv] for creating isolated Python environments (via [pyenv] if it is installed)
* [Virtualenvwrapper] for extending Virtualenv (via [pyenv] if it is installed)
* [VSCode] also for coding all the things
* [Zsh] as your shell


[Bundler]: http://bundler.io/
[chruby]: https://github.com/postmodern/chruby
[CloudApp]: http://getcloudapp.com/
[Cloud Foundry CLI]: https://github.com/cloudfoundry/cli
[Flux]: https://justgetflux.com/
[git-seekret]: https://github.com/18F/git-seekret
[GitHub Desktop]: https://desktop.github.com/
[Homebrew]: http://brew.sh/
[Homebrew Cask]: http://caskroom.io/
[Homebrew Services]: https://github.com/Homebrew/homebrew-services
[hub]: https://github.com/github/hub
[MySQL]: https://www.mysql.com/
[n]: https://github.com/tj/n
[Node.js]: http://nodejs.org/
[NPM]: https://www.npmjs.org/
[PhantomJS]: http://phantomjs.org/
[Postgres]: http://www.postgresql.org/
[Python]: https://www.python.org/
[pyenv]: https://github.com/yyuu/pyenv/
[Redis]: http://redis.io/
[Ruby]: https://www.ruby-lang.org/en/
[ruby-install]: https://github.com/postmodern/ruby-install
[Slack]: https://slack.com/
[Sublime Text 3]: http://www.sublimetext.com/3
[The Silver Searcher]: https://github.com/ggreer/the_silver_searcher
[Virtualenv]: https://virtualenv.pypa.io/en/latest/
[Virtualenvwrapper]: http://virtualenvwrapper.readthedocs.org/en/latest/#
[VSCode]: https://code.visualstudio.com/
[Zsh]: http://www.zsh.org/

It should take less than 15 minutes to install (depends on your machine and
internet connection).

Customize in `~/.laptop.local` and `~/Brewfile.local`
-----------------------------------------------------

Your `~/.laptop.local` is run at the end of the `mac` script.
Put your customizations there. If you want to install additional
tools or Mac apps with Homebrew, add them to your `~/Brewfile.local`.
This repo already contains a [.laptop.local] and [Brewfile.local]
you can use to get started.

```sh
# Go to your OS X user's root directory
cd ~

# Download the sample files to your computer
curl --remote-name https://raw.githubusercontent.com/18F/laptop/master/.laptop.local
curl --remote-name https://raw.githubusercontent.com/18F/laptop/master/Brewfile.local
```

It lets you install the following tools and apps:

* [Atom] - GitHub's open source text editor
* [Exuberant Ctags] for indexing files for vim tab completion
* [Firefox] for testing your website on a browser other than Chrome
* [iTerm2] - an awesome replacement for the OS X Terminal
* [reattach-to-user-namespace] to allow copy and paste from Tmux
* [Tmux] for saving project state and switching between projects
* [Vim] for those who prefer the command line
* [Spectacle] - automatic window manipulation

[.laptop.local]: https://github.com/18F/laptop/blob/master/.laptop.local
[Brewfile.local]: https://github.com/18F/laptop/blob/master/Brewfile.local
[Atom]: https://atom.io/
[Exuberant Ctags]: http://ctags.sourceforge.net/
[Firefox]: https://www.mozilla.org/en-US/firefox/new/
[iTerm2]: http://iterm2.com/
[reattach-to-user-namespace]: https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
[Tmux]: https://tmux.github.io/
[Vim]: http://www.vim.org/
[Spectacle]: https://www.spectacleapp.com/

Write your customizations such that they can be run safely more than once.
See the `mac` script for examples.

Laptop functions such as `fancy_echo` and `gem_install_or_update` can be used
in your `~/.laptop.local`.

How to manage background services (Redis, Postgres, MySQL)
----------------------------------------------------------
The script does not automatically launch these services after installation
because you might not need or want them to be running. With Homebrew Services,
starting, stopping, or restarting these services is as easy as:

```
brew services start|stop|restart [name of service]
```

For example:

```
brew services start redis
```

To see a list of all installed services:

```
brew services list
```

To start all services at once:

```
brew services start --all
```

How to switch your shell back to bash from zsh (or vice versa)
--------------------------------------------------------------
1. Find out which shell you're currently running: `echo $SHELL`
2. Find out the location of the shell you want to switch to. For example, if
   you want to switch to `bash`, run `which bash`.
3. Verify if the shell location is included in `/etc/shells`.
   Run `cat /etc/shells` to see the contents of the file.
4. If the location of the shell is included, run
   `chsh -s [the location of the shell]`.
   For example, if `which bash` returned `/bin/bash`, you would run
  `chsh -s /bin/bash`.

   If the location of the shell is not in `/etc/shells`, add it, then run the
   `chsh` command.
   If you have Sublime Text, you can open the file by running
   `subl /etc/shells`.
5. Quit and restart Terminal (or iTerm2), or open a new tab for the new shell
   to take effect.

Whether you're using bash or zsh, we recommend installing the latest versions
with Homebrew because the versions that came with your Mac are really old.
```
brew install bash
```
or
```
brew install zsh
```

Credits
-------

The 18F laptop script is based on and inspired by
[thoughtbot's laptop](https://github.com/thoughtbot/laptop) script.

### Public domain

thoughtbot's original work remains covered under an [MIT License](https://github.com/thoughtbot/laptop/blob/c997c4fb5a986b22d6c53214d8f219600a4561ee/LICENSE).

18F's work on this project is in the worldwide [public domain](LICENSE.md), as are contributions to our project. As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
