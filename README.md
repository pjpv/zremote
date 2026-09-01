# ZRemote

**中文** | [English](README.en.md)

ZCode 桌面端远程控制的手机伴侣 App。电脑端出示二维码，手机扫码一次导入，即可长期使用；多台设备并行管理，一个界面随时切换。

<p align="center">
  <img src="docs/screenshot.jpg" width="270" alt="ZRemote App 界面" />
  <img src="docs/screenshot-2.jpg" width="270" alt="ZRemote App 界面" />
</p>

## 功能

- **扫码 / 粘贴导入** —— 电脑端出示的远程控制链接，扫码或粘贴即可导入设备
- **多设备并行会话** —— 所有设备同时在线，切换不重连
- **会话总览面板** —— 跨项目任务卡一览：项目 · 相对时间 · 状态胶囊，按今天 / 昨天 / 更早日历分组；蓝点实时跟随正在查看的会话，点按即跳转定位
- **任务事件通知** —— 审批请求、任务完成与失败推送系统通知；类型可分开关（默认仅审批），未读徽标一目了然，后台与锁屏也不错过；桌面端解决待办后对应通知自动撤回
- **后台会话保活** —— 前台守护服务让会话在后台与息屏下持续在线；提供电池优化白名单引导，回到前台自动恢复
- **会话健康指示** —— 每台设备的连接状态实时可见（加载中 / 已连接 / 异常）
- **一键刷新与自动恢复** —— 会话异常时手动重载，连续失败交给自动重载兜底
- **生物识别门禁** —— 指纹 / 面容锁定应用，开启与关闭均需验证；锁屏采用品牌主视觉
- **中英双语** —— 应用内一键切换 中文 / English，或跟随系统语言
- **设置页** —— 通用（语言）、安全、后台与通知偏好集中管理，设备列表回归纯操作
- **深色控制台 UI** —— 低光环境友好的深色界面

## 下载与安装

到 [Releases](https://github.com/pjpv/zremote/releases) 页获取最新版：

- **Android** —— `app-release.apk`，下载后直接安装
- **iOS** —— `zremote-ios-unsigned.ipa`，**未签名包，无法直接安装**：请使用 [AltStore](https://altstore.io)、[Sideloadly](https://sideloadly.io) 或 TrollStore 等工具，用自己的 Apple ID 签名后侧载（免费账号签名有效期 7 天，到期需重新签名）

## 构建

环境要求：

- Flutter ≥ 3.38（Dart ≥ 3.10）
- JDK 17（Android 构建）
- Xcode（iOS 构建，需 macOS）

```bash
flutter pub get

# Android
flutter build apk --release

# iOS（未签名）
flutter build ios --release --no-codesign
```

## 使用

1. 电脑端 ZCode 打开远程控制，出示二维码
2. 手机 App 扫码导入（或粘贴链接）
3. 点击设备卡片进入控制会话；顶栏标题随时切换设备
4. 任务等待批准或完成时，系统通知会即时送达；相关偏好可在设置页调整

## 声明

ZRemote 是社区开发的开源项目，非官方工具，与 Z.ai 无关联。ZCode 及相关名称与商标归其各自所有者。

## License

[MIT](LICENSE)
