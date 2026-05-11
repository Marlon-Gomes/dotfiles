# Dotfiles

## Description

This repository manages personal configuration files, such as `.zshrc`, using
GNU Stow to create symlinks from the repository into the user's home directory.

## Usage

The `core` package is synchronized to the home directory using GNU Stow.
Preserve the desired destination path inside `core/`: top-level directories will
land in `$HOME`. For instance, XDG-style files under `.config/` will land
in `$HOME/.config/`.

Ensure GNU Stow is installed and available in your PATH. From the root of this
repository, run:

```bash
stow -t "$HOME" core
```

This tells GNU Stow to stow the `core` package into the home folder, creating
the necessary symlinks.

The core folder contains [`./core/.stow-local-ignore`][stow-ignore], an ignore
list that tells Stow to ignore certain files. You can read more about ignore
lists usage and syntax in the [GNU Stow manual][stow-manual].

> Note: GNU Stow will never edit a file it doesn't own. If you have a file in
> `$HOME` or its subdirectories you wish to overwrite with GNU Stow, you must
> delete the file (backup if necessary) and use Stow again.

## What's included

### ZSH

#### Prerequisites (MacOS)

For this config to work, you will need administrator privileges to edit
`/etc/zshenv`.

Create the following directories if not existent:

```zsh
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/state"
mkdir -p "$HOME/.config/zsh"
```

Use your preferred text editor to edit the system-wide `zsh` environment file.
Ensure permission are set to write to this file:

```zsh
sudo nano /etc/zshenv
```

On Mac, add the following to the top of this file:

```text
export XDG_BIN_HOME="$HOME/.local/bin"
export PATH="$XDG_BIN_HOME:$PATH"

export XDG_CACHE_HOME="$HOME/Library/Caches"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="$TMPDIR/runtime-$UID"
export XDG_STATE_HOME="$HOME/.local/state"

ZDOTDIR="$XDG_CONFIG_HOME"/zsh

if [ ! -d "$XDG_RUNTIME_DIR" ]; then
  mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"
fi
```

#### Prerequisites (Ubuntu)

On Ubuntu, system-wide configs are stored at `/etc/zsh/zshenv`.

Create the following directories if not existent:

```zsh
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/state"
mkdir -p "$HOME/.config/zsh"
```

Use your preferred text editor to edit the system-wide `zsh` environment file.
Ensure permission are set to write to this file:

```zsh
sudo nano /etc/zsh/zshenv
```

Append the following to the this file:

```text
# XDG Base Directories (Ubuntu/Linux standard)
export XDG_BIN_HOME="$HOME/.local/bin"
export PATH="$XDG_BIN_HOME:$PATH"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Runtime: use systemd-managed dir
export XDG_RUNTIME_DIR="/run/user/$UID"

# Zsh config relocation
ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Ensure runtime dir exists (fallback if no systemd)
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
  mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"
fi
```

#### .zshenv

Besides the global environment variables set at `/etc/zshenv`, this project
provides a sample local environment variable file at
`core/.config/zsh/.zshenv.sample` (which will be stowed at
`$ZDOTDIR/.zshenv.sample`). This file is meant to be copied and edited to
include any secrets we are not sharing in this repo:

```zsh
cp $ZDOTDIR/.zshenv.sample $ZDOTDIR/.zshenv
nano $ZDOTDIR/.zshenv # then add your secrets
```

#### .zprofile

Stored at `core/.config/zsh/.zprofile`, this file is sourced once at login and
sets up the Homebrew environment on macOS.

#### .zshrc

ZSH expects a `.zshrc` file at `$ZDOTDIR` containing user config. Ours is,
accordingly, stored at `core/.config/zsh/.zshrc`. This file sets our
Powerlevel10k config, various zinit plugins and options, certain ZSH options
related to history, auto-completion, and aliases (sourced from
`$ZDOTDIR/aliases.zsh`), `fzf`, as well as options related to `conda` and its
interaction with `brew` on macOS.

## Caution

Use `.gitignore` to ensure no secrets such as passwords, SSH keys, or API keys
are committed to this repository. A pre-commit hook can scan for secrets before
commits are created. It is up to each developer to enable the hook locally.
Assuming pre-commit is installed and available in your PATH, this can be done
with:

```bash
cd <REPOSITORY_ROOT>
pre-commit install
```

It is useful to keep the gitleaks hook up to date in `.pre-commit-config.yaml`.
You can do so by running:

```bash
cd <REPOSITORY_ROOT>
pre-commit autoupdate
```

[stow-manual]: https://www.gnu.org/software/stow/manual/html_node/Ignore-Lists.html
[stow-ignore]: ./core/.stow-local-ignore
