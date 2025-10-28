local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim....")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- local themesname = "cyberdream"
-- local themesname = "tokyonight"
-- local themesname = "sonokai"
local themesname = _G.themesname
require("lazy").setup({
  { import = "radia.plugins" },
  { import = "radia.plugins.ui" },
  { import = "radia.plugins.editing" },
  { import = "radia.plugins.search" },
  { import = "radia.plugins.git" },
  { import = "radia.plugins.themes" },
  { import = "radia.plugins.lsp" },
  { import = "radia.plugins.tools" },
  { import = "radia.plugins.notes" },
  { import = "radia.plugins.perf" },
  { import = "radia.plugins.util" },
}, {
  install = {
    colorscheme = { themesname },
  },
  checker = {
    enabled = false,
    notify = false,
  },
  change_detection = {
    notify = true,
  },
  ui = {
    border = "rounded",
  },

})
