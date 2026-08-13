# Neovim 的配置

使用 Neovim 原生 **vim.pack**（`vim.pack.add`）进行插件管理，无需额外包管理器。

## 目录结构

```
.config/nvim/
├── init.lua               # 入口：加载基础设置、LSP、插件
├── nvim-pack-lock.json    # 插件版本锁（VimPack 生成）
├── lsp/                   # 各语言服务器的配置（vim.lsp.enable 自动发现）
│   ├── lua_ls.lua
│   ├── pyright_ls.lua
│   ├── ruff_ls.lua
│   └── clangd_ls.lua
└── lua/
    ├── config/            # options / keymaps / others
    └── plugins/           # 每个插件一个文件，init.lua 中按需 require
```

## 插件管理

- 插件声明：`vim.pack.add({ { src = "https://github.com/...", name = "..." } })`
- 安装：重启 Neovim 后，锁文件中记录的插件会自动按提交哈希安装
- 更新：`:lua vim.pack.update()` 拉取更新 → 在确认缓冲区中 `:write` 应用 → `:restart`
- 移除：从配置中删除声明后 `:restart`（残留目录可用 `vim.pack.del()` 清理）
- 版本锁定：`nvim-pack-lock.json` 记录每个插件的提交哈希，随仓库提交

## LSP

`init.lua` 中通过 `vim.lsp.enable("lua_ls")` 等启用，配置放在 `lsp/` 目录，
Neovim 0.11+ 会按约定自动加载。语言服务器本体由 `mason` 管理安装：
首次启动时会自动安装 `lua-language-server`、`pyright`、`ruff`、`clangd`、`stylua`
（见 `lua/plugins/mason.lua` 的 ensure_installed 清单），也可用 `:Mason` 手动管理。
