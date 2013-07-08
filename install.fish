#!/usr/bin/env fish
set -x required_version 2
set -x fish_version (fish --version ^| cut -d ' ' -f 3 | cut -d . -f 1)
if [ $required_version -gt $fish_version ]
    echo "Fish shell version $required_version is require for this script. You can obtain the latest version at http://fishshell.com/"
    exit 1
end
if [ -f "marks.fish" ]
    set -x FISHMARKS (readlink -f 'marks.fish' | sed "s#^$HOME#\$HOME#g")
else if [ -f "fishmarks/marks.fish" ]
    set -x FISHMARKS (readlink -f 'fishmarks/marks.fish' | sed "s#^$HOME#\$HOME#g")
else if not [ -f "$HOME/.fishmarks/marks.fish" ]
    git clone http://github.com/techwizrd/fishmarks.git $HOME/.fishmarks
    set -x FISHMARKS "\$HOME/.fishmarks/marks.fish"
else
    cd $HOME/.fishmarks; and git pull
    set -x FISHMARKS "\$HOME/.fishmarks/marks.fish"
end
mkdir -p ~/.config/fish
touch ~/.config/fish/config.fish
if grep -Fxq ". $FISHMARKS" $HOME/.config/fish/config.fish
    echo "Fishmarks has already been installed"
else
    echo '' >> $HOME/.config/fish/config.fish
    echo "# Load fishmarks (http://github.com/techwizrd/fishmarks)" >> $HOME/.config/fish/config.fish
    echo ". $FISHMARKS" >> $HOME/.config/fish/config.fish
    echo "Fishmarks has been installed"
end
