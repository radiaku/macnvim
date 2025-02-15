return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,

          lookahead = true,

          keymaps = {

            ["pa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
            ["pi"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

            ["la"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["li"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

            ["ca"] = { query = "@conditional.outer", desc = "Select outer part of a conditional definition" },
            ["ci"] = { query = "@conditional.inner", desc = "Select inner part of a conditional definition" },

            ["fa"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
            ["fi"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

          },
        },
      },
    })

  end,
}
