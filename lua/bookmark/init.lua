local popup = require("plenary.popup")

local Module = {}

BookmarksFile = "/tmp/bookmarks"
local popoverWindowId

function Module.addBookmark()
	local file = io.open(BookmarksFile, "a")
	io.output(file)

	local currentPath = vim.loop.cwd()
	io.write(currentPath, "\n")
	io.close()
end

function Module.deleteBookmark(targetIndex)
	local bookmarks = Module.readBookmarks(false)
	local file = io.open(BookmarksFile, "w")
	io.output(file)
	
    for i = 1, table.getn(bookmarks) do
		if i ~= targetIndex + 1 then
            io.write(bookmarks[i], "\n")
		end 
    end
	io.close()
end

function Module.readBookmarks(shows)
	local file = io.open(BookmarksFile, "r")
	io.input(file)

	local bookmarks = {}
	local displayBookmarks = {}
	local bookmark = io.read()

	local index = 0
	while bookmark do
		table.insert(bookmarks, bookmark)
		table.insert(displayBookmarks, index..": "..bookmark)
		bookmark = io.read()
		index = index + 1
	end

	if shows then
		ShowBookmarks(displayBookmarks)
	end

	return bookmarks
end

function ShowBookmarks(opts)
	local height = 20
	local width = 30
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	local onSelection = function(_, selection)
		if selection == nil or selection == "" then
			return
		end

		local prefixEnd = 0
		for i = 1, #selection do
			local char = selection:sub(i,i)
			if char == ':' then
				prefixEnd = i
				break
			end
		end

		-- Exclude the ":" and space after
		prefixEnd = prefixEnd + 2

		local output = string.sub(selection, prefixEnd, string.len(selection))
		-- Copy the selection path to the clip board
		os.execute("echo \""..output.."\" | pbcopy")
		-- vim.api.nvim_set_current_dir(output)
	end

	popoverWindowId = popup.create(opts, {
        title = "Bookmarks",
        highlight = "Bookmarks",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
		callback = onSelection,
	})

	local bufnr = vim.api.nvim_win_get_buf(popoverWindowId)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseBookmarks()<CR>", { silent=false })
end

function CloseBookmarks()
	vim.api.nvim_win_close(popoverWindowId, true)
end

return Module
