# Dotfiles

## Description

Dotfiles is a repository to manage my personal configuration files, such as
".zshrc". This project uses GNU stow to manage symlinks between this repository
and my home folder.

## Usage

Ensure GNU stow is installed and in your PATH. From the root of this repository,
run

```bash
stow -d . -t $HOME
```

This will create the necessary symlinks.

## Caution

Ensure no secrets such as passwords, ssh keys, or API keys are are committed to
this repository if its visibility is public. You should keep your secrets hidden
and not check them into source control. A pre-commit hook can be set up to scan
for secrets before signing commits. It is up to developers to enable the hook
locally, however. Assuming pre-commit (the package, not the sample hook from
Git) is installed and in your PATH, this can be done with

```bash
cd <REPOSITORY_ROOT>
pre-commit install
```

It is useful to ensure that at least the gitleaks commit autoupdates

```bash
cd <REPOSITORY_ROOT>
pre-commit autoupdate --repo https://github.com/gitleaks/gitleaks
```
