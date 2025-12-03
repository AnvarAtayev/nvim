return {
  {
    "voldikss/vim-floaterm",
    keys = { "<leader>ft" },
    config = function()
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.8
      vim.g.floaterm_autoclose = 2
      vim.g.floaterm_keymap_toggle = "<leader>ft"

      vim.api.nvim_set_keymap("n", "t", ":FloatermToggle<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
    end,
  },
}
