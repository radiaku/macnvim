return {
  "f-person/git-blame.nvim",
  config = function()
    vim.g.gitblame_enabled = 0
    vim.g.gitblame_message_template = '<author> • <date> • <summary>'
    vim.g.gitblame_date_format = '%Y-%b-%d %H:%M'  -- e.g. 2025-10-30 14:23
  end,
}
