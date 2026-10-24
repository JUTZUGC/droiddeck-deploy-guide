# DroidDeck 一键下载与校验脚本（第三方指南，非官方）——按官方文档封装
# 官方文档：https://github.com/Droid-Deck/DroidDeck/blob/main/README.md
# 更新日期：2026-10-24
# 类型：binary
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) { throw '需要先安装 curl（Windows 10+ 自带 curl.exe）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

curl.exe -fLO https://github.com/Droid-Deck/DroidDeck/releases/download/0.6.0/DroidDeck-0.6.0.apk
curl.exe -fLO https://github.com/Droid-Deck/DroidDeck/releases/download/0.6.0/SHA256SUMS.txt
$expected = ((Select-String -Path SHA256SUMS.txt -Pattern 'DroidDeck-0.6.0.apk$').Line -split '\s+')[0].ToLower()
$actual = (Get-FileHash -Algorithm SHA256 -Path DroidDeck-0.6.0.apk).Hash.ToLower()
if ($actual -ne $expected) { throw 'SHA256 校验失败，请重新下载' }
Write-Host 'SHA256 校验通过'

Write-Host ''

Write-Host '下载与校验完成，安装包在 .download 目录'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/Droid-Deck/DroidDeck/blob/main/README.md'
