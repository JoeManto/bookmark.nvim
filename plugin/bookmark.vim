if exists("g:loaded_boomark")
    finish
endif
let g:loaded_bookmark = 1

command! -nargs=0 AddBookmark lua require("bookmark").addBookmark()
command! -nargs=0 Bookmarks lua require("bookmark").readBookmarks(true)
command! -nargs=1 DeleteBookmark lua require("bookmark").deleteBookmark(<f-args>)
