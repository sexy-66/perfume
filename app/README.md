# 香方簿 Android 应用

香方簿是Flutter实现的离线优先Android应用。业务数据使用Drift + SQLite，本地图片使用SHA-256内容标识，店内设备通过局域网对等同步。

最后更新：2026-08-10；最新已提交代码基线：`ac2dd15`；M7改动尚未提交；数据库schema：9。

## 开发前必读

按以下顺序读取项目文档：

1. `D:\Xiang\README.md`：当前状态、已知限制和文档优先级；
2. `D:\Xiang\M0_PRODUCT_SPEC.md`：冻结的1.2产品需求正文；
3. `D:\Xiang\TECHNICAL_PLAN.md`：后续确认变更、当前实现、架构和验证记录；
4. `D:\Xiang\toolchain.lock`：项目内工具链精确版本。

当前状态：M1至M5及2026-08-09维护迭代已完成；M6备份恢复继续冻结；M7已启动，正在执行性能、内存、存储和交付前回归。不要依据旧计划继续开发M6，也不要把当前调试证书签名的Release APK当作正式交付包。

## 当前功能和限制

- 首页有香方、合香珠 / 香牌和调配记录入口；
- 推荐香方与普通香方共用数据和编辑流程；普通列表可查看，删除入口仅在推荐香方页开放；
- 香方、草稿和调配记录均支持长按多选删除；调配记录可按顾客姓名、电话或香方名称搜索；
- 新建香方可直接添加图片；香方图片支持全屏缩放、保存到相册和更换；图片导入支持用户拖动与双指缩放裁切；
- 首页合香珠 / 香牌和成品选择图片支持直接双指缩放；
- 局域网同步会对网络错误退避重连，遇到确定的数据或协议错误会暂停自动同步，防止重试风暴；用户可点击“立即同步”重试；
 - Mi 10与Redmi Pad当前均已保留数据覆盖安装最终源码对应的Release 4707；Mi 10 Profile真实库验证确认原设备身份、三条香料，以及Redmi Pad和Xiaomi 15 Pro授权关系仍在。Xiaomi 15 Pro当前连接序列号为`8e31d208`，数据库三件套、28个JPEG媒体、设备身份和配对信任已导出到U盘并逐文件校验。

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

提交`e4a4302`和当前M7工作区共同构成性能基线：

- 数据库和媒体目录初始化并行；
- 首帧只构建首页，其他根页面首次访问时再构建并缓存Widget实例，底栏切换只改变`IndexedStack`索引；同步在首帧后初始化，运行时状态变化只定向失效相关页面缓存；
- 底部导航不使用`BackdropFilter`实时背景模糊；
- Flutter解码图片缓存限制为200张、64 MB；
- 香料网格使用`cacheWidth: 480`，其他图片列表按实际显示尺寸设置解码宽度，详情和全屏预览保留所需清晰度；
- 三张首页背景由总计约6.95 MB的PNG改为总计约0.95 MB的JPEG，并按1024px宽度解码；
- 媒体清理删除无引用JPEG和遗留临时文件，保留当前业务、草稿、最近删除、未解决冲突、正在写入和五分钟内新写入的图片；清理失败不阻塞启动或同步；
- SQLite设置`journal_size_limit = 8388608`，限制WAL检查点后的日志保留空间。

后续修改不得无证据撤销这些优化。滚动列表新增图片时应设置与显示尺寸匹配的解码尺寸。性能问题使用Profile或Release构建验证，Debug APK只用于功能调试。

推荐香方摘要查询的批量重构尚未实施；只有真实几十条数据仍能稳定复现慢加载时，再用Perfetto或查询计时支持后处理，避免为推测性能扩大数据库改动。

M7 Profile性能用例位于`integration_test/m7_performance_test.dart`，会在隔离的内存数据库和临时媒体目录中创建60条图片香料并往返滚动。Redmi Pad第二次有效样本为499帧：Build p90 3.792 ms、p99 8.672 ms，Raster p90 7.136 ms、p99 8.779 ms，Build和Raster超预算计数均为0。Mi 10真实数据库8轮根导航切换在修复前有22个Build超预算帧；缓存根页面后Build p90 7.070 ms、p99/最慢7.987 ms，Raster p90 9.190 ms、p99/最慢13.692 ms，两个超预算计数均为0。证据位于`.qa/m7/mi10-release-4707/`。自动化只允许在模拟器或无业务数据的专用设备运行；`flutter drive`可能卸载基础应用包，有业务数据真机不得直接运行。

## 验证命令

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test -j 1
flutter build apk --profile
flutter build apk --release
```

 当前全量测试为107项，`flutter analyze`与`git diff --check`通过。最终4707 Profile和Release材料位于`.qa\m7\final-4707\`；`CN=sexy66, C=CN`正式证书已接入Gradle，Release APK已通过v2校验。用户已确认正式应用ID保持`com.example.xiangfangbu`、版本名保持`1.0.0`，当前交付构建号为4707。现有真机仍安装Android Debug证书版本，不能直接覆盖为新证书；数据保留迁移方案和密钥异地备份策略仍是M7交付门禁。
