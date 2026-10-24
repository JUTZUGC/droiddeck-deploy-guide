# DroidDeck 一键下载与校验指南

> 第三方部署指南 · 非 DroidDeck 官方仓库。官方项目：[Droid-Deck/DroidDeck](https://github.com/Droid-Deck/DroidDeck)
> 内容来自官方文档（2026-10-24）。项目迭代快，请以[官方文档](https://github.com/Droid-Deck/DroidDeck/blob/main/README.md)为准。

## 一键下载与校验（推荐：用百度搭子）

不用自己敲命令，让 AI 帮你把安装包下载并校验好。

⚠️ 本指南在电脑上执行下载与校验；安装目标是 Android 设备（Android 9+，Adreno 730 / 8xx）。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

2. **发送部署指令**
   进入对话窗口，直接复制这一句发出去：

   ```text
   你好，帮我从 github 部署 JUTZUGC/droiddeck-deploy-guide 到我的电脑上
   ```

3. **跟着对话往下走**
   AI 会自动下载官方安装包并校验完整性，按它的提示确认即可，结束时它会告诉你结果。
   （下载地址与校验方式以官方文档为准。）



## DroidDeck 是什么？

DroidDeck 是开源的面向 Android 掌机的 SteamOS 体验项目（协议：GPL-3.0，<img src="https://img.shields.io/github/stars/Droid-Deck/DroidDeck?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

在 Adreno 掌机上运行 Valve 的 Steam 客户端（大屏模式），并借助 ARM64 Proton 运行 Windows 游戏；无需 root。

- 支持设备：Android 9+，Adreno 730 或 8xx（Adreno 6xx 为实验性；Mali / Xclipse / PowerVR / Adreno 710 不支持）
- 存储占用：运行时约 3 GB，桌面与模拟器另需约 1.1 GB
- 安装来源：仅 GitHub Releases（官方声明没有独立官网）

（来源：[官方仓库](https://github.com/Droid-Deck/DroidDeck)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 掌上运行 Steam | 在 Android 掌机上使用 Steam 大屏模式 |
| 无需 root | 官方说明无需 root |
| 能跑 Windows 游戏 | 借助 ARM64 Proton 运行 Windows 游戏 |
| 开源可自建 | GPL-3.0，可按官方构建脚本自行编译 |

| 需要注意 | 说明 |
|---|---|
| 设备门槛高 | 仅 Adreno 730 / 8xx；Adreno 6xx 实验性，Mali / Xclipse / PowerVR / Adreno 710 不支持 |
| 存储占用大 | 运行时约 3 GB，桌面与模拟器另需约 1.1 GB |
| Android 14+ 需改设置 | 要在开发者选项开启「停用子进程限制」 |
| 首次启动慢 | Steam 在首次启动时才下载 |
| 只认官方来源 | 官方声明没有独立官网，安装包只应从 Releases 获取 |

> 以上基于官方文档与社区反馈整理（2026-10-24），以官方最新文档为准。

## 官方安装方式（可手动执行）

```bash
curl -fLO https://github.com/Droid-Deck/DroidDeck/releases/download/0.6.0/DroidDeck-0.6.0.apk
curl -fLO https://github.com/Droid-Deck/DroidDeck/releases/download/0.6.0/SHA256SUMS.txt
if command -v sha256sum >/dev/null 2>&1; then grep '  DroidDeck-0.6.0.apk$' SHA256SUMS.txt | sha256sum -c -; else grep '  DroidDeck-0.6.0.apk$' SHA256SUMS.txt | shasum -a 256 -c -; fi
```

安装包来源：[https://github.com/Droid-Deck/DroidDeck/releases/tag/0.6.0](https://github.com/Droid-Deck/DroidDeck/releases/tag/0.6.0)

## 验证状态

| 场景 | 状态 |
|---|---|
| APK 下载 + SHA256 校验 | 已验证 2026-10-24 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

DroidDeck 自身不含 MCP；仓库内的 tools/droiddeckctl 通过 ADB 在真机上控制应用（启动/停止会话、启动游戏、截图、录制等），面向自动化测试。本仓库的 MCP 只提供安装步骤、设备兼容性与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-24）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由 AI 通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\droiddeck-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装到手机（可选）

本仓库不托管安装包，只指向官方 Releases。APK 下载并校验通过后，在手机打开「开发者选项 → USB 调试」，用数据线连接电脑，执行：

```powershell
adb install -r .download\DroidDeck-0.6.0.apk
```

没有 adb 时，把 `.download` 里的 `DroidDeck-0.6.0.apk` 传到手机，用文件管理器点击安装（需允许「安装未知应用」）。

## 常见坑

- Android 14+：先在开发者选项开启「停用子进程限制」，否则 Steam 启动不了（官方说明）
- 只从官方 Releases 下载 APK 与 SHA256SUMS.txt；官方声明没有独立官网，谨防声称官方的下载站
- Adreno 6xx 为实验性，DirectX 12 游戏可能崩溃；Mali / Xclipse / PowerVR / Adreno 710 不支持
- 预留约 4 GB 空间：运行时约 3 GB，桌面与模拟器另需约 1.1 GB
- 首次启动会下载 Steam，耗时取决于网络

## 免责声明

本仓库为第三方指南，与 DroidDeck 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-24），项目迭代快，请以[官方文档](https://github.com/Droid-Deck/DroidDeck/blob/main/README.md)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
