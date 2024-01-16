" Title:        Example Plugin
" Description:  A plu:gin to provide an example for creating Neovim plugins.
" Last Change:  8 November 2021
" Maintainer:   Example User <https://github.com/example-user>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_boomark")
    finish
endif
let g:loaded_bookmark = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
" let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/example-plugin/deps"
" exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 AddBookmark lua require("bookmark").addBookmark()
command! -nargs=0 Bookmarks lua require("bookmark").readBookmarks(true)
command! -nargs=1 DeleteBookmark lua require("bookmark").deleteBookmark(<f-args>)
