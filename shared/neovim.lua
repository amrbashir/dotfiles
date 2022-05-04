local config = {
  default_theme = {
    highlights = function(highlights)
      highlights.Normal = { bg = "NONE" }
      return highlights
    end,
  },

  plugins = {
    init = {
      { "machakann/vim-highlightedyank" },
    },

    enabled = {
      autopairs = false,
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
  }
}

return config
