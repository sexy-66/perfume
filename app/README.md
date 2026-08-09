# 香方簿 Android 应用

香方簿是Flutter实现的离线优先Android应用。业务数据使用Drift + SQLite，本地图片使用SHA-256内容标识，店内设备通过局域网对等同步。

## 开发前必读

按以下顺序读取项目文档：

1. `D:\Xiang\M0_PRODUCT_SPEC.md`：冻结的1.2产品需求基线；
2. `D:\Xiang\TECHNICAL_PLAN.md`：当前实现状态、架构、冻结范围和验证记录；
3. `D:\Xiang\toolchain.lock`：项目内工具链精确版本。

当前状态：M1至M5、1.2结构优化和首轮简单性能优化已完成；M6备份恢复冻结；M7正式交付未启动。不要依据旧计划继续开发M6，也不要把当前Release模式APK当作正式签名交付包。

## 项目内开发环境

工具、SDK、缓存、模拟器状态和临时文件必须留在`D:\Xiang`。不要使用全局安装器、修改全局PATH或安装全局Dart包。

```powershell
Set-Location D:\Xiang
. .\dev.ps1
Set-Location .\app
flutter devices
flutter run -d <flutter devices显示的Android设备ID>
```

日常界面迭代使用持续运行的Android模拟器和Hot Reload。相机、厂商兼容、局域网同步、升级和性能结论使用真实Android设备验证。

## 当前性能基线

提交`e4a4302`已成为后续开发基线：

- 数据库和媒体目录初始化并行；
- 首帧只构建首页，首帧后预热其他根页面和初始化同步；
- 底部导航不使用`BackdropFilter`实时背景模糊；
- 香方和推荐香方网格卡片使用`cacheWidth: 720`解码缩略图。

后续修改不得无证据撤销这些优化。滚动列表新增图片时应设置与显示尺寸匹配的解码尺寸。性能问题使用Profile或Release构建验证，Debug APK只用于功能调试。

推荐香方摘要查询的批量重构尚未实施；只有真实几十条数据仍能稳定复现慢加载时，再用Perfetto或查询计时支持后处理，避免为推测性能扩大数据库改动。

## 验证命令

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --profile
flutter build apk --release
```

当前全量测试为92项。生成文件位于`build\app\outputs\flutter-apk\`且不会提交到Git。当前Android配置仍使用占位应用ID和调试签名，正式签名与版本管理留待M7。
