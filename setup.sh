#!/bin/bash

# 切换到脚本所在的目录
cd "$(dirname "$0")"

# 配置~/.config
CONFIG_DIR="./config"
TARGET_DIR="$HOME/.config"

# 确保 .config 目录存在
if [ ! -d "$TARGET_DIR" ]; then
  echo "$TARGET_DIR does not exist. Creating it now."
  mkdir -p "$TARGET_DIR"
fi

# 循环处理config中的每个子目录
for config in "$CONFIG_DIR"/*; do
  # 只处理目录
  if [ -d "$config" ]; then
    # 获取子目录的名称（例如 aerospace, btop等）
    dir_name=$(basename "$config")
    target_path="$TARGET_DIR/$dir_name"
    
    # 检查目标路径是否已存在
    if [ -e "$target_path" ]; then
      echo "Skipping $target_path because it already exists."
    else
      # 创建符号链接
      ln -s "$(pwd)/$config" "$target_path"
      echo "Linked $config to $target_path"
    fi
  fi
done

# 配置 tmux
if [ ! -e "$HOME/.tmux.conf" ]; then
  ln -s "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
  echo "Linked .tmux.conf to $HOME/.tmux.conf"
else
  echo "$HOME/.tmux.conf already exists. Skipping."
fi

# 配置 .zshrc
if [ ! -e "$HOME/.zshrc" ]; then
  ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"
  echo "Linked .zshrc to $HOME/.zshrc"
else
  echo "$HOME/.zshrc already exists. Skipping."
fi
