local config = {
  default_theme = {
    highlights = function(highlights)
      highlights.Normal = { bg = nil }
      return highlights
    end,
  },

  plugins = {
    init = {
      { "machakann/vim-highlightedyank" },
      [ "windwp/nvim-autopairs" ] = { disable = true },
      [ "windwp/nvim-ts-autotag" ] = { disable = true },
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
