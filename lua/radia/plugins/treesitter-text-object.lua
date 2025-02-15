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

            -- ["sa"] = { query = "@attribute.outer", desc = "Select outer part of a assignment" },
            -- ["si"] = { query = "@attribute.inner", desc = "Select inner part of a assignment" },
            --
            -- ["ta"] = { query = "@attribute.outer", desc = "Select outer part of a attribute" },
            -- ["ti"] = { query = "@attribute.inner", desc = "Select inner part of a attribute" },

            -- ["ga"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
            -- ["gi"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

            ["ba"] = { query = "@block.outer", desc = "Select outer part of a block" },
            ["bi"] = { query = "@block.inner", desc = "Select inner part of a block" },

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
