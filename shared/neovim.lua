local config = {
  plugins = {
    init = {
      ["windwp/nvim-autopairs"] = { disable = true },
      ["windwp/nvim-ts-autotag"] = { disable = true },
      { "machakann/vim-highlightedyank" },
      { "jghauser/mkdir.nvim" },
      { "gpanders/editorconfig.nvim" },
      {
        "fedepujol/move.nvim",
        config = function()
          vim.api.nvim_set_keymap(
            "n",
            "<A-j>",
            ":MoveLine(1)<CR>",
            { noremap = true, silent = true }
          )
          vim.api.nvim_set_keymap(
            "n",
            "<A-k>",
            ":MoveLine(-1)<CR>",
            { noremap = true, silent = true }
          )
          vim.api.nvim_set_keymap(
            "v",
            "<A-j>",
            ":MoveBlock(1)<CR>",
            { noremap = true, silent = true }
          )
          vim.api.nvim_set_keymap(
            "v",
            "<A-k>",
            ":MoveBlock(-1)<CR>",
            { noremap = true, silent = true }
          )
        end,
      },
      {
        "amrbashir/nvim-docs-view",
        opt = true,
        cmd = { "DocsViewToggle" },
      },
      {
        "johnfrankmorgan/whitespace.nvim",
        config = function()
          require("whitespace-nvim").setup({
            highlight = "DiffDelete",
            ignored_filetypes = { "TelescopePrompt", "alpha", "neo-tree" },
          })
        end,
      },
    },

    tree_sitter = {
      ensure_installed = { "lua", "rust", "javascript", "typescript", "python", "bash" },
    },

    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua", "rust_analyzer", "tsserver", "jsonls", "bashls" },
    },

    ["neo-tree"] = {
      window = {
        position = "right",
        width = 35,
      },
    },
  },
}

if vim.fn.has("win32") == 1 then
  config["options"] = {
    opt = {
      shell = "pwsh -NoLogo",
      shellcmdflag = "-Command",
      shellquote = '\\"',
      shellxquote = "",
    },
  }
end

return config
