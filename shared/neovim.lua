local config = {
  plugins = {
    init = {
      { "machakann/vim-highlightedyank" },
      [ "windwp/nvim-autopairs" ] = { disable = true },
      [ "windwp/nvim-ts-autotag" ] = { disable = true },
      { "amrbashir/nvim-docs-view" },
    },

    tree_sitter = {
      ensure_installed = { "lua", "rust", "javascript", "typescript", "python", "bash" }
    },

    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua", "rust_analyzer", "tsserver", "jsonls", "bashls" },
    },

    ["neo-tree"] = {
      window = {
        position = "right",
	      width = 35
      }
    }
  },
}

if vim.fn.has("win32") == 1 then
  config["options"] = {
    opt = {
      shell = "pwsh -NoLogo"
    }
  }
end

return config
