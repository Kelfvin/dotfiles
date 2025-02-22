#! /bin/bash

# 检查操作系统是否为 macOS
if [ "$(uname)" == "Darwin" ]; then
  # 定义 Rime 配置文件路径
  RIME_CONFIG_DIR="./rime"
  RIME_TARGET_DIR="$HOME/Library/Rime"

  # 确保 Rime 配置目录存在
  if [ ! -d "$RIME_TARGET_DIR" ]; then
    echo "$RIME_TARGET_DIR does not exist. Creating it now."
    mkdir -p "$RIME_TARGET_DIR"
  fi

  # 循环处理 rime 目录中的配置文件
  for config_file in "$RIME_CONFIG_DIR"/*.yaml; do
    # 获取文件名（去掉路径）
    filename=$(basename "$config_file")
    target_file="$RIME_TARGET_DIR/$filename"

    # 检查目标文件是否已经存在
    if [ -e "$target_file" ]; then
      echo "Skipping $target_file because it already exists."
    else
      # 创建符号链接
      ln -s "$(pwd)/$config_file" "$target_file"
      echo "Linked $config_file to $target_file"
    fi
  done

else
  echo "This script is intended for macOS only. Exiting."
fi
