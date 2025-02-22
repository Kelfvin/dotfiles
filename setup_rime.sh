#! /bin/bash

if["$(uname)"=="Darwin"];then
  # Mac OS X 操作系统
  ln -s ./rime/default.custom.yaml ~/Library/Rime/default.custom.yaml
  ln -s ./rime/double_pinyin_flypy.custom.yaml ~/Library/Rime/double_pinyin_flypy.custom.yaml
  ln -s ./rime/squirrel.custom.yaml ~/Library/Rime/squirrel.custom.yaml.yaml
fi
