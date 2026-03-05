# Copyright 2013-present Kunal Sarkhel
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

# Fishmarks compatibility loader.

set -l fishmarks_root (path dirname -- (status filename))

if test "$fishmarks_root" = /; and test -f './functions/save_bookmark.fish'
    set fishmarks_root '.'
end

if not test -f "$fishmarks_root/functions/save_bookmark.fish"
    return 0
end

for function_file in \
    _fishmarks_ensure_sdirs \
    _fishmarks_print_error \
    _fishmarks_encode_path \
    _fishmarks_decode_path \
    _fishmarks_entries \
    _fishmarks_find_path \
    _fishmarks_valid_name \
    _fishmarks_write_entries \
    _fishmarks_complete \
    _check_help \
    _valid_bookmark \
    save_bookmark \
    go_to_bookmark \
    print_bookmark \
    delete_bookmark \
    list_bookmarks
    source "$fishmarks_root/functions/$function_file.fish"
end

source "$fishmarks_root/conf.d/fishmarks.fish"
