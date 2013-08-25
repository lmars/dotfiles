My collection of dotfiles.

## Installing on Ubuntu

Run the `ubuntu.sh` script:

```
wget -qO - https://raw.github.com/lmars/dotfiles/master/ubuntu.sh | bash
```

## Installing with homesick

Ensure you have the [homesick](https://github.com/technicalpickles/homesick) gem installed:

    gem install homesick

Then:

    homesick clone git://github.com/lmars/dotfiles.git
    homesick symlink dotfiles
