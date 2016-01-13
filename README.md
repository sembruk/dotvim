Based on
http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/
and
https://github.com/dudarev/dotvim

```bash
git clone http://github.com/sembruk/dotvim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
cd .vim
git submodule init
git submodule update
```

## Update all bundled modules

```bash
git submodule foreach git pull origin master
```

## Install a new bundle

```bash
git submodule add http://github.com/tpope/vim-fugitive.git bundle/fugitive
git add .
git commit -m "Install Fugitive.vim bundle as a submodule."
```

## To remove a submodule

1. Delete the relevant section from the .gitmodules file.
2. Delete the relevant section from .git/config.
3. Run git rm --cached path_to_submodule (no trailing slash).
4. Commit and delete the now untracked submodule files.

