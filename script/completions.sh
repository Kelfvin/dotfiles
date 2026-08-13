#!/usr/bin/env bash
# ╭──────────────────────────────────────────────────────────────────╮
# │                 Completion Manifest · 补全清单                   │
# ╰──────────────────────────────────────────────────────────────────╯
# 统一为「自行安装」的工具生成 zsh / fish 补全，与安装方式、平台解耦
# （macOS / Arch / Ubuntu 同一份清单），幂等，可随时重跑。
#
# 工具分类：
#   A 生成器    工具自带补全生成命令，运行时直接生成
#               mise / uv / topgrade / herdr / bat / rg / fd / glow / yq / starship(fish)
#   B vendoring 上游无生成器，仓库内静态文件分发（离线可用、版本可控）
#               eza / fastfetch / tldr(tlrc)  →  script/completions-src/
#   C 放弃      上游无补全，不做处理
#               duf / tokei / yazi / lazygit / chafa / gdu / gping / jless / delta
#   D 已有机制  不重复处理
#               fzf（--zsh/--fish 集成）、zoxide（fish init 内联）、
#               zsh 侧 starship/zoxide（zinit atclone）、direnv（hook 自带）、
#               pacman/brew 系统补全
#
# 输出目录（均为生成物，不进 git 仓库）：
#   zsh  -> ~/.zfunc                    （fpath 已由 zsh/plugins.zsh prepend）
#   fish -> ~/.config/fish/completions  （fish 启动自动扫描）
#
# 用法：
#   bash script/completions.sh          # 幂等刷新（setup.sh / update_all 也会调用）
#
# 维护：
#   A 类：直接加一行 gen_zsh / gen_fish 调用
#   B 类：文件放入 script/completions-src/，并加 vendor_zsh / vendor_fish 调用
#         刷新文件：curl -L https://cdn.jsdelivr.net/gh/<owner>/<repo>@<ref>/<path>
set -euo pipefail

# ── 目录 ──────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZCOMP_DIR="${ZCOMP_DIR:-$HOME/.zfunc}"
FCOMP_DIR="${FISH_COMPLETIONS_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/fish/completions}"
VENDOR_ZSH="$SCRIPT_DIR/completions-src/zsh"
VENDOR_FISH="$SCRIPT_DIR/completions-src/fish"

install -d "$ZCOMP_DIR" "$FCOMP_DIR"

# ── 日志 ──────────────────────────────────────────────────────────────
ok()   { printf '  \033[32m✔\033[0m %s\n' "$*"; }
skip() { printf '  \033[33m–\033[0m %s（未安装，跳过）\n' "$*"; }
fail() { printf '  \033[31m✘\033[0m %s\n' "$*"; }

# ── A 类：生成器（命令名与补全名一致，失败时清理坏文件） ──────────────
gen_zsh() {
  local tool="$1"; shift
  if command -v "$tool" >/dev/null 2>&1; then
    if "$@" > "$ZCOMP_DIR/_$tool" 2>/dev/null; then
      ok "$tool -> ~/.zfunc/_$tool"
    else
      fail "$tool zsh 补全生成失败"; rm -f "$ZCOMP_DIR/_$tool"
    fi
  else
    skip "$tool"
  fi
}

gen_fish() {
  local tool="$1"; shift
  if command -v "$tool" >/dev/null 2>&1; then
    if "$@" > "$FCOMP_DIR/$tool.fish" 2>/dev/null; then
      ok "$tool -> fish/$tool.fish"
    else
      fail "$tool fish 补全生成失败"; rm -f "$FCOMP_DIR/$tool.fish"
    fi
  else
    skip "$tool"
  fi
}

# ── B 类：vendoring 分发 ──────────────────────────────────────────────
vendor_zsh() {
  local tool="$1"
  if command -v "$tool" >/dev/null 2>&1; then
    cp -f "$VENDOR_ZSH/_$tool" "$ZCOMP_DIR/_$tool"
    ok "$tool -> ~/.zfunc/_$tool（vendored）"
  else
    skip "$tool"
  fi
}

vendor_fish() {
  local tool="$1"
  if command -v "$tool" >/dev/null 2>&1; then
    cp -f "$VENDOR_FISH/$tool.fish" "$FCOMP_DIR/$tool.fish"
    ok "$tool -> fish/$tool.fish（vendored）"
  else
    skip "$tool"
  fi
}

# ╭──────────────────────────────────────────────────────────────────╮
# │                         执行清单                                │
# ╰──────────────────────────────────────────────────────────────────╯
printf '==> zsh 补全 → %s\n' "$ZCOMP_DIR"
gen_zsh mise     mise completion zsh
gen_zsh uv       uv generate-shell-completion zsh
gen_zsh topgrade topgrade --gen-completion zsh
gen_zsh herdr    herdr completion zsh
gen_zsh bat      bat --completion zsh
gen_zsh rg       rg --generate complete-zsh
gen_zsh fd       fd --gen-completions zsh
gen_zsh glow     glow completion zsh
gen_zsh yq       yq shell-completion zsh
vendor_zsh eza
vendor_zsh fastfetch
vendor_zsh tldr

printf '==> fish 补全 → %s\n' "$FCOMP_DIR"
gen_fish mise     mise completion fish
gen_fish uv       uv generate-shell-completion fish
gen_fish topgrade topgrade --gen-completion fish
gen_fish herdr    herdr completion fish
gen_fish bat      bat --completion fish
gen_fish rg       rg --generate complete-fish
gen_fish fd       fd --gen-completions fish
gen_fish glow     glow completion fish
gen_fish yq       yq shell-completion fish
gen_fish starship starship completions fish
vendor_fish eza
vendor_fish fastfetch
vendor_fish tldr

printf '==> 完成。zsh 重开 shell 生效；fish 下次启动自动加载。\n'
