# Dotfiles

## Description

This repository manages personal configuration files, such as `.zshrc`, using
GNU Stow to create symlinks from the repository into the user's home directory.

## Usage

The `core` package is synchronized to the home directory using GNU Stow.
Preserve the desired destination path inside `core/`: top-level dotfiles such
as `.zshrc` will land in `$HOME`, and XDG-style files under `.config/` will land
in `$HOME/.config/`.

Ensure GNU Stow is installed and available in your PATH. From the root of this repository, run:

```bash
stow -t "$HOME" core
```

This tells GNU Stow to stow the `core` package into the home folder, creating
the necessary symlinks.

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
