# Copyright 2013 Kunal Sarkhel
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a copy
# of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.

# Fishmarks:
# Save and jump to commonly used directories
#
# Fishmarks is a a clone of bashmarks for the Fish shell. Fishmarks is
# compatible with your existing bashmarks and bookmarks added using fishmarks
# are also available in bashmarks.

if not set -q SDIRS
    set -gx SDIRS $HOME/.sdirs
end
touch $SDIRS

if not set -q NO_FISHMARKS_COMPAT_ALIASES
    alias s save_bookmark
    alias g go_to_bookmark
    alias p print_bookmark
    alias d delete_bookmark
    alias l list_bookmarks
end

function save_bookmark --description "Save the current directory as a bookmark"
    set -l bn $argv[1]
    if [ (count $argv) -lt 1 ]
        set bn (string replace -r [^a-zA-Z0-9] _ (basename (pwd)))
    end
    if not echo $bn | grep -q "^[a-zA-Z0-9_]*\$";
        echo -e "\033[0;31mERROR: Bookmark names may only contain alphanumeric characters and underscores.\033[00m"
        return 1
    end
    if _valid_bookmark $bn;
        sed -i='' "/DIR_$bn=/d" $SDIRS
    end
    set -l pwd (pwd | sed "s#^$HOME#\$HOME#g")
    echo "export DIR_$bn=\"$pwd\"" >> $SDIRS
    _update_completions
    return 0
end

function go_to_bookmark --description "Go to (cd) to the directory associated with a bookmark"
    if [ (count $argv) -lt 1 ]
        echo -e "\033[0;31mERROR: '' bookmark does not exist\033[00m"
        return 1
    end
    if not _check_help $argv[1];
        cat $SDIRS | grep "^export DIR_" | sed "s/^export /set -x /" | sed "s/=/ /" | .
        set -l target (env | grep "^DIR_$argv[1]=" | cut -f2 -d "=")
        if [ ! -n "$target" ]
            echo -e "\033[0;31mERROR: '$argv[1]' bookmark does not exist\033[00m"
            return 1
        end
        if [ -d "$target" ]
            cd "$target"
            return 0
        else
            echo -e "\033[0;31mERROR: '$target' does not exist\033[00m"
            return 1
        end
    end
end

function print_bookmark --description "Print the directory associated with a bookmark"
    if [ (count $argv) -lt 1 ]
        echo -e "\033[0;31mERROR: bookmark name required\033[00m"
        return 1
    end
    if not _check_help $argv[1];
        cat $SDIRS | grep "^export DIR_" | sed "s/^export /set -x /" | sed "s/=/ /" | .
        env | grep "^DIR_$argv[1]=" | cut -f2 -d "="
    end
end

function delete_bookmark --description "Delete a bookmark"
    if [ (count $argv) -lt 1 ]
        echo -e "\033[0;31mERROR: bookmark name required\033[00m"
        return 1
    end
    if not _valid_bookmark $argv[1];
        echo -e "\033[0;31mERROR: bookmark '$argv[1]' does not exist\033[00m"
        return 1
    else
        sed --follow-symlinks -i='' "/DIR_$argv[1]=/d" $SDIRS
        _update_completions
    end
end

function list_bookmarks --description "List all available bookmarks"
    if not _check_help $argv[1];
        cat $SDIRS | grep "^export DIR_" | sed "s/^export /set -x /" | sed "s/=/ /" | .
        env | sort | awk '/DIR_.+/{split(substr($0,5),parts,"="); printf("\033[0;33m%-20s\033[0m %s\n", parts[1], parts[2]);}'
    end
end

function _check_help
    if [ (count $argv) -lt 1 ]
        return 1
    end
    if begin; [ "-h" = $argv[1] ]; or [ "-help" = $argv[1] ]; or [ "--help" = $argv[1] ]; end
        echo ''
        echo 's <bookmark_name> - Saves the current directory as "bookmark_name"'
        echo 'g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
        echo 'p <bookmark_name> - Prints the directory associated with "bookmark_name"'
        echo 'd <bookmark_name> - Deletes the bookmark'
        echo 'l - Lists all available bookmarks'
        echo ''
        return 0
    end
    return 1
end

function _valid_bookmark
    if begin; [ (count $argv) -lt 1 ]; or not [ -n $argv[1] ]; end
        return 1
    else
        cat $SDIRS | grep "^export DIR_" | sed "s/^export /set -x /" | sed "s/=/ /" | .
        set -l bookmark (env | grep "^DIR_$argv[1]=" | cut -f1 -d "=" | cut -f2 -d "_" )
        if begin; not [ -n "$bookmark" ]; or not [ $bookmark=$argv[1] ]; end
            return 1
        else
            return 0
        end
    end
end

function _update_completions
    cat $SDIRS | grep "^export DIR_" | sed "s/^export /set -x /" | sed "s/=/ /" | .
    set -x _marks (env | grep "^DIR_" | sed "s/^DIR_//" | cut -f1 -d "=" | tr '\n' ' ')
    complete -c print_bookmark -a $_marks -f
    complete -c delete_bookmark -a $_marks -f
    complete -c go_to_bookmark -a $_marks -f
    if not set -q NO_FISHMARKS_COMPAT_ALIASES
        complete -c p -a $_marks -f
        complete -c d -a $_marks -f
        complete -c g -a $_marks -f
    end
end
_update_completions
