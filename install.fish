#!/usr/bin/env fish
if [ -f "marks.fish" ]
    set -x FISHMARKS (readlink -f 'marks.fish' | sed "s#^$HOME#\$HOME#g")
else if [ -f "fishmarks/marks.fish" ]
    set -x FISHMARKS (readlink -f 'fishmarks/marks.fish' | sed "s#^$HOME#\$HOME#g")
else if not [ -f "$HOME/.fishmarks/marks.fish" ]
    git clone http://github.com/techwizrd/fishmarks.git $HOME/.fishmarks
    #set -x FISHMARKS (readlink -f '~/.fishmarks/marks.fish' | sed "s#^$HOME#\$HOME#g")
    set -x FISHMARKS "\$HOME/.fishmarks/marks.fish"
else
    cd $HOME/.fishmarks; and git pull
    #set -x FISHMARKS (readlink -f '~/.fishmarks/marks.fish' | sed "s#^$HOME#\$HOME#g")
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
