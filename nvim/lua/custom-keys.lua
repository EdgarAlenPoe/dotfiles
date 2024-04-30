local map = vim.api.nvim_set_keymap
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })

-- Nvim-Tree keybinds
map('n', '<C-n>', [[:NvimTreeToggle<CR>]], {})

--BufferLine keybinds
map('n', '[b', [[:BufferLineCyclePrev<CR>]], {})
map('n', ']b', [[:BufferLineCycleNext<CR>]], {})
map('n', '<leader>bp', [[:BufferLineTogglePin<CR>]], {})

local function closeBuffer ()
  local bufferline = require('bufferline')
  local closed_buffer_id = vim.fn.bufnr()
  local index = bufferline.get_index(closed_buffer_id)
  local buffer_count = #bufferline.get_elements().elements
  if buffer_count == 1 then
    vim.cmd([[enew]])
    bufferline.cycle(1)
  elseif index == 1 then
    bufferline.cycle(1)
  elseif index == buffer_count then
    bufferline.cycle(-1)
  else
    bufferline.cycle(1)
  end
  bufferline.unpin_and_close(closed_buffer_id)
end
vim.keymap.set('n', '<leader>q', closeBuffer, {})

--floaterm keybinds
--map('n', '<leader>ft', [[:FloatermNew<CR>]], {})
map('n', '<leader>t', [[:FloatermToggle<CR>]], {})
--map('n', '<M->', [[:FloatermNext<CR>]], {})
--map('n', '<M->', [[:FloatermPrev<CR>]], {})

--Telescope keybinds
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--Leap keybinds
vim.keymap.set('n', 'S', '<Plug>(leap-backward)', {})

--TODO-Comments keybinds
vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
map('n', '<leader>ft', [[:TodoTelescope<CR>]], {})

--LSP keybinds
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = event.buf}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Display documentation of the symbol under the cursor
    bufmap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', '<leader>lg', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    -- bufmap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions)
  end
})

--dirbuf keybinds
map('n', '<leader>d', [[:Dirbuf ]], {})

