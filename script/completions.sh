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
# 行为保证：
#   - 生成/复制先写临时文件再原子 mv，失败不会截断已有的旧补全
#   - 工具未安装时删除上次遗留的过期补全，避免 shell 加载过期条目
#   - 任一生成失败时以非零退出码结束（setup.sh 可感知）
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

FAILURES=0

# 原子写入：先生成到同目录临时文件，成功后再覆盖目标；
# 工具未安装时清理上次遗留的补全文件。
gen_to() {
  local tool="$1" target="$2"; shift 2
  if command -v "$tool" >/dev/null 2>&1; then
    local tmp
    if tmp="$(mktemp "$target.XXXXXX")"; then
      if "$@" > "$tmp" 2>/dev/null; then
        mv -f "$tmp" "$target"
        ok "$tool -> $target"
      else
        rm -f "$tmp"
        FAILURES=$((FAILURES + 1))
        fail "$tool 补全生成失败（保留旧文件）"
      fi
    else
      FAILURES=$((FAILURES + 1))
      fail "$tool 无法创建临时文件"
    fi
  else
    skip "$tool"
    if [ -f "$target" ]; then
      rm -f "$target"
      printf '  \033[33m–\033[0m 已移除过期补全 %s\n' "$target"
    fi
  fi
}

vendor_to() {
  local tool="$1" source="$2" target="$3"
  if command -v "$tool" >/dev/null 2>&1; then
    local tmp
    if tmp="$(mktemp "$target.XXXXXX")"; then
      if cp -f "$source" "$tmp"; then
        mv -f "$tmp" "$target"
        ok "$tool -> ${target}（vendored）"
      else
        rm -f "$tmp"
        FAILURES=$((FAILURES + 1))
        fail "$tool 补全复制失败（保留旧文件）"
      fi
    else
      FAILURES=$((FAILURES + 1))
      fail "$tool 无法创建临时文件"
    fi
  else
    skip "$tool"
    if [ -f "$target" ]; then
      rm -f "$target"
      printf '  \033[33m–\033[0m 已移除过期补全 %s\n' "$target"
    fi
  fi
}

# ── A 类：生成器（命令名与补全名一致） ──────────────────────────────
gen_zsh() {
  local tool="$1"; shift
  gen_to "$tool" "$ZCOMP_DIR/_$tool" "$@"
}

gen_fish() {
  local tool="$1"; shift
  gen_to "$tool" "$FCOMP_DIR/$tool.fish" "$@"
}

# ── B 类：vendoring 分发 ──────────────────────────────────────────────
vendor_zsh() {
  vendor_to "$1" "$VENDOR_ZSH/_$1" "$ZCOMP_DIR/_$1"
}

vendor_fish() {
  vendor_to "$1" "$VENDOR_FISH/$1.fish" "$FCOMP_DIR/$1.fish"
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

if [ "$FAILURES" -gt 0 ]; then
  printf '==> 完成，但有 %d 项失败。zsh 重开 shell 生效；fish 下次启动自动加载。\n' "$FAILURES"
  exit 1
fi
printf '==> 完成。zsh 重开 shell 生效；fish 下次启动自动加载。\n'
