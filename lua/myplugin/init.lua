-- myplugin/init.lua
local M = {}

-- Default configuration
M.config = {
	greeting_message = "Hello from MyPlugin!", -- User-configurable greeting
	log_file = vim.fn.stdpath("data") .. "/myplugin.log", -- Log file path
	enable_autocmd = false, -- Optional feature to trigger on events
}

-- Function to print a greeting
function M.hello()
    print(M.greeting_message)
	-- print("Hello from MyPlugin!")
    M.log("User executed Hello command!")
end

-- Function to log messages to a file
function M.log(message)
    local file = io.open(M.config.log_file, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n")
        file:close()
    end
end

-- Function to set up the plugin with user configurations
function M.setup(opts)
	-- Merge user options with defaults
	M.config = vim.tbl_extend("force", M.config, opts or {})

	-- Create the user command
	vim.api.nvim_create_user_command("Hello", function()
		M.hello()
	end, {})

	-- Key mappings (if the user enables them)
	vim.keymap.set("n", "<leader>h", function()
		M.hello()
	end, { noremap = true, silent = true })

	-- Optionally enable autocommand
	if M.config.enable_autocmd then
		vim.api.nvim_create_autocmd("BufRead", {
			pattern = "*",
			callback = function()
				M.log("Opened a file: " .. vim.fn.expand("%"))
			end,
		})
	end
end

return M
