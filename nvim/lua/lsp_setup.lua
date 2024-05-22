local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

lspconfig.clangd.setup{}
lspconfig.lua_ls.setup({
	on_init = function(client)
	local path = client.workspace_folders[1].name
	if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
	  return
	end

	client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
		runtime = {
			-- Tell the language server which version of Lua you're using
			-- (most likely LuaJIT in the case of Neovim)
			version = 'LuaJIT'
		},
		-- Make the server aware of Neovim runtime files
		workspace = {
			checkThirdParty = false,
			library = {
				vim.env.VIMRUNTIME
				-- Depending on the usage, you might want to add additional paths here.
				-- "${3rd}/luv/library"
				-- "${3rd}/busted/library",
			}
		}
	})
  end,
  settings = {
    Lua = {}
  }
})

require('jdtls').start_or_attach({
	cmd = {'~/.local/share/nvim/mason/bin/jdtls'},
	root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
	setting = {
		java = {
			signatureHelp = {enabled = true},
		}
	}
})
