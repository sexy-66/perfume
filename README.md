# 香方簿

[![CI](https://github.com/sexy-66/perfume/actions/workflows/ci.yml/badge.svg)](https://github.com/sexy-66/perfume/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform: Android](https://img.shields.io/badge/platform-Android-green.svg)](https://www.android.com/)

香方簿是一款面向店内工作的离线优先 Android 应用，用于管理香料资料、香方、顾客、资产和调配记录。它不依赖云服务器，店内设备可以通过局域网进行配对和数据同步。

## 功能

- 香料、香料分类、推荐比例区间和图片管理
- 香方草稿、正式版本、比例计算和实际调配记录
- 顾客档案、顾客历史和调配记录搜索
- 合香珠 / 香牌目录与制作记录
- 资产分类、状态和库存清点
- 最近删除、撤销和冲突保留
- 设备配对、加密会话、局域网对等同步和图片同步
- 手机、平板、横屏和竖屏自适应布局
- 图片裁切、压缩、去重和本地存储

## 技术栈

- Flutter + Dart
- Drift + SQLite
- `dart:io` UDP 发现与 HTTP 批次传输
- Flutter 原生状态管理和导航
- Android 10（API 29）及以上

## 快速开始

需要 Flutter stable、Android SDK 和 JDK 17 或更高版本。

```bash
git clone https://github.com/sexy-66/perfume.git
cd perfume/app
flutter pub get
flutter run
```

在 Android Studio 或 VS Code 中打开 `app` 目录也可以直接运行。应用首次启动使用空库，业务数据保存在设备本地。

## 常用命令

在 `app` 目录执行：

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test -j 1
flutter build apk --release
```

公开检出不包含正式发布签名密钥，`flutter build apk --release` 会使用本机调试签名，仅用于本地测试。正式分发请使用自己的签名密钥，并妥善保管密钥和密码。

## 项目结构

```text
app/
├── lib/data/            # Drift 数据库、迁移和本地媒体
├── lib/features/        # 首页、香料、香方、顾客、资产和设置页面
├── lib/services/        # 计算、发现、配对和同步服务
├── integration_test/    # 设备级流程测试
└── test/                # 单元测试和 Widget 测试
```

## 数据与隐私

应用默认完全离线运行，不上传业务数据，也不需要账号。局域网同步只在已配对设备之间进行；图片和数据库保存在应用私有目录中。请勿在 Issue、Pull Request 或日志中上传真实顾客资料、设备密钥、签名文件或业务图片。

## 贡献

欢迎修复问题、改进文档和提交小而清晰的功能改动。请先阅读 [贡献指南](CONTRIBUTING.md)，并在提交前运行格式检查、静态分析和测试。

## 安全问题

不要在公开 Issue 中提交安全漏洞或私密配对信息，请阅读 [安全政策](SECURITY.md) 获取报告方式。

## 许可证

本项目以 [MIT License](LICENSE) 发布。
