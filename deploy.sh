#!/usr/bin/env bash
set -euo pipefail
# DroidDeck 一键下载与校验脚本（第三方指南，非官方）——按官方文档封装
# 官方文档：https://github.com/Droid-Deck/DroidDeck/blob/main/README.md
# 采集日期：2026-10-24
# 类型：binary
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v curl >/dev/null 2>&1 || { echo "需要先安装 curl"; exit 1; }

mkdir -p .download
cd .download

curl -fLO https://github.com/Droid-Deck/DroidDeck/releases/download/0.6.0/DroidDeck-0.6.0.apk
curl -fLO https://github.com/Droid-Deck/DroidDeck/releases/download/0.6.0/SHA256SUMS.txt
if command -v sha256sum >/dev/null 2>&1; then grep '  DroidDeck-0.6.0.apk$' SHA256SUMS.txt | sha256sum -c -; else grep '  DroidDeck-0.6.0.apk$' SHA256SUMS.txt | shasum -a 256 -c -; fi

echo ""

echo "下载与校验完成，安装包在 .download 目录"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/Droid-Deck/DroidDeck/blob/main/README.md"
