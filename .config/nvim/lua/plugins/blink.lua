local blink_build_group = vim.api.nvim_create_augroup("blink_cmp_build", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
  group = blink_build_group,
  callback = function(ev)
    local data = ev.data or {}
    local spec = data.spec or {}
    if spec.name ~= "blink.cmp" then
      return
    end

    if data.kind ~= "install" and data.kind ~= "update" then
      return
    end

    vim.system({ "cargo", "build", "--release" }, { cwd = data.path }, function(result)
      vim.schedule(function()
        if result.code == 0 then
          vim.notify("blink.cmp fuzzy 库构建完成", vim.log.levels.INFO)
        else
          local stderr = (result.stderr or ""):gsub("%s+$", "")
          vim.notify(
            "blink.cmp fuzzy 库构建失败\n" .. stderr,
            vim.log.levels.ERROR
          )
        end
      end)
    end)
  end,
})

vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", name = "blink.cmp" },
})

require("blink.cmp").setup({
  fuzzy = {
    implementation = "prefer_rust",
  },
  completion = {
    documentation = {
      auto_show = true,
    },
  },
  keymap = {
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    preset = "super-tab",
  },
  signature = {
    enabled = true,
  },
  cmdline = {
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  sources = {
    providers = {
      snippets = { score_offset = 1000 },
    },
  },
})
