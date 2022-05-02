local config = {
  default_theme = {
    highlights = function(highlights)
      highlights.Normal = { bg = "NONE" }
      return highlights
    end,
  },

  plugins = {
    init = {
      { "machakann/vim-highlightedyank" }
    },

    ["neo-tree"] = {
      window = {
        position = "right",
	      width = 35
      }
    }
  },

}

return config
