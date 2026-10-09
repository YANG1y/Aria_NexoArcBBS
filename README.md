# NexoArcBBS 二次开发变更说明

## 项目信息

- 基础项目：Aria
- 二次开发名称：NexoArcBBS
- 固定服务器：`https://bbs.ccoz.top`
- Android 应用名称：`NexoArcBBS`
- Android applicationId：`com.nexoarc.bbs`
- 当前版本：`1.5.15 (113)`
- 联系方式：<https://home.ccoz.top>
- 原Aria项目地址：https://github.com/poppingmoon/aria

## 登录与启动

- 登录服务器固定为 `bbs.ccoz.top`。
- 删除服务器搜索、选择和输入控件。
- 登录页隐藏域名，显示 `NexoArcBBS` 标题。
- 登录页图标背景容器调整为 64 x 64，图标居中显示。
- App 启动时读取账号和 Token：未登录进入登录页，已登录进入时间线首页。
- 登录成功后立即补充默认标签，不需要重启 App。

## 默认标签页

没有已有标签配置时，创建以下三个标签：

1. 首页：底层使用原“社交时间线”，默认开启“显示对他人的回复”。
2. 通知。
3. 社交：底层使用原“全局时间线”。

显示名称调整：

- 原“社交”显示为“首页”。
- 原“全局”显示为“社交”。
- 顶部标签图标栏保持显示，并继续受标签页设置管理。
- 已有用户标签配置不会被强制覆盖。

## 首页与动态页

- 系统状态栏使用与标签栏一致的背景色。
- Android 开启 edge-to-edge，背景可延伸到前置摄像头或刘海区域。
- 状态栏图标颜色根据亮暗主题自动调整。
- 标签展开菜单使用紧凑布局，每行 7 个按钮。
- 展开菜单按钮圆角为 25。
- “服务器信息”按钮显示名缩短为“信息”。
- 底部按钮大小和方形样式重新由“外观 -> 动态页按钮”设置控制。
- 默认开启小按钮和方形按钮。
- 默认底部按钮顺序为：首页、频道、发布栏、发帖、发现、消息、个人资料。
- 发布栏展开后，纵向滑动帖子列表会先取消输入焦点、收起键盘，再播放向下滑出和渐隐动画。
- 横向切换标签不会触发发布栏收起。

## 频道

- 进入频道详情时默认打开“时间线”，不再默认打开“概览”。

## 私信错误提示

- 识别服务端返回的 `recipient is cannot chat (mutual)` 错误。
- 改为显示中文提示：“对方仅允许互相关注的用户发送私信，请先与对方互相关注。”
- 发送失败后保留消息草稿。
- 互相关注限制由服务器执行，客户端不会绕过服务器权限。

## 声音默认值

- 新配置默认开启提示音。
- 已经保存过的用户设置保持原值。

## 品牌与关于页

- 侧边栏“关于 Aria”改为“关于NexoArcBBS”。
- 关于页标题和应用名称改为 `NexoArcBBS`。
- 项目说明改为“NexoArcBBS是基于Aria的二次开发项目。”
- 删除原 Aria 图标作者及许可证署名段落。
- 客户端信息中的应用名称同步改为 `NexoArcBBS`。
- 更新源代码和联系方式链接。"APP-仓库-源项目地址"。

## Android 包配置

- Gradle namespace 改为 `com.nexoarc.bbs`。
- Android applicationId 改为 `com.nexoarc.bbs`。
- Android Manifest 应用标签改为 `NexoArcBBS`。
- MainActivity 的 Kotlin package 改为 `com.nexoarc.bbs`。
- 最终安装包文件名使用 `NexoArcBBS.apk`。
- 包名变化后会作为新应用安装，不能覆盖旧包名 `com.poppingmoon.aria`。

## 归档文件说明

本目录仅复制人工修改或新增的源文件，并保留其项目相对目录结构。

未包含以下内容：

- `build/` 下的 APK 和其他构建产物。
- `.dart_tool/`、`.gradle/`、`.toolchains/` 等缓存、工具链及本地依赖。
- 自动生成的 `*.g.dart`、`*.freezed.dart` 等文件。
- 为离线构建临时使用的依赖覆盖和 Rust 构建调整。
- 未发生二次开发改动的原项目文件。

修改模型源文件后，应在完整项目中重新运行代码生成：


## 文件清单

- `lib/constant/app_server.dart`
- `lib/main.dart`
- `lib/model/general_settings.dart`
- `lib/model/sound_settings.dart`
- `lib/provider/accounts_notifier_provider.dart`
- `lib/provider/boot_state_provider.dart`
- `lib/provider/timeline_tabs_notifier_provider.dart`
- `lib/router/router.dart`
- `lib/view/dialog/note_drafts_dialog.dart`
- `lib/view/page/about_aria_page.dart`
- `lib/view/page/channel/channel_page.dart`
- `lib/view/page/login_page.dart`
- `lib/view/page/timelines_page.dart`
- `lib/view/widget/error_message.dart`
- `lib/view/widget/general_settings_navigation.dart`
- `lib/view/widget/tab_type_widget.dart`
- `lib/view/widget/timeline_header.dart`
- `lib/view/widget/timeline_menu.dart`
- `android/app/build.gradle.kts`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/poppingmoon/aria/MainActivity.kt`
