# PlotProof Lab（图证实验室）证据登记

生成时间：2026-09-09T12:45:14+08:00

## 源码身份

本工程所在目录不是 Git 仓库，因此没有 branch/SHA/dirty-state 可报告。当前源码路径为 `/Users/starburst/Downloads/app-ui-atlas/plotproof_lab`；最终 `lib`、`test`、iOS/Android 主配置和产品文档的逐文件 SHA-256 清单再聚合摘要为 `fd7eecafb2a0c1f60e9d638527c3292bb3e5e40c614e710542f2ed45d261a75b`。这是本地快照替代证据，不具备提交历史与作者身份能力。

| 文件 | SHA-256 |
| --- | --- |
| `pubspec.yaml` | `2c9116a854572b3dafd94c867b4f7ee13e917e3ef94788ddd8f316d60a81546e` |
| `pubspec.lock` | `258e5fd4f53db4f8643970def4fdb7f50f19e1e144dbc2ae9e2f167e4cc4fae4` |
| 最终质量门禁 JSON | `0bf6e93592a4cb8537dd2400c0922335a8fa6c3f9566b72b64061a93f11a6e8e` |
| 机械预检 JSON | `9fb772589f0eb52e634bbf7e423ae9eea3b7f53b1857a71722dc61d4fe28fa0e` |

## 证据层

| 层级 | 命令/设备/工件 | 结果 | 证明上限 | 原始证据路径 |
| --- | --- | --- | --- | --- |
| 静态 | Dart 格式检查、Flutter analyzer、依赖与 iOS plist/工程检查 | passed | 不证明运行态 | `evidence/automation/20260909T124324+0800/` |
| 自动化 | 7 个测试文件、25 项单元/Widget 测试 | passed | 不证明平台集成或真机 | `evidence/automation/20260909T124324+0800/flutter-test.log` |
| iOS 模拟器 | iPhone 17 Pro：最终英文深色 2.5× 大字首页；iPad Air 11-inch：最终中文浅色响应式首页；此前手动跑通过判断→调参→解析→复练及中英文切换 | passed within listed paths | 手动闭环早于最后数值修订；最终截图仅证明首页视觉，不证明全部关卡 | `evidence/runtime/iphone17pro-final-runtime-flat.png`、`evidence/runtime/ipad-air11-zh-light-home-revised-flat.png` |
| 实体设备 | 未运行 | not_run | 不证明真实性能、触控、读屏或最低系统 | — |
| Android 构建 | `flutter build apk --debug --no-pub` | passed | Debug APK 不是 Play 发布候选 | `build/app/outputs/flutter-apk/app-debug.apk` |
| iOS Archive | `flutter build ipa --release --no-codesign --no-pub` | passed, unsigned | 无签名归档不证明安装、上传或 TestFlight | `build/ios/archive/Runner.xcarchive` |
| 机械预检 | Bundle/版本、签名、隐私清单、截图、图标和 URL 检查 | blocked as expected | 机械检查不是政策结论 | `evidence/automation/preflight-20260909T124514+0800/` |
| ASC/TestFlight/App Review | 未执行 | not_run | 无外部状态 | — |

## 最终工件

| 工件 | SHA-256 | 大小 | 生成时间 | 限制 |
| --- | --- | ---: | --- | --- |
| Android Debug APK | `4b4ed43171edacbcc382ddf472e9eef696b942e0f36cb89fba8b4f602830c98e` | 161,181,388 bytes | 2026-09-09T12:43:34+08:00 | debug only |
| App icon master | `6ea38db96670f3022c807a358fe640ceae805fe4ea70adfaadaab8e230dbbd54` | 855,922 bytes | 2026-09-09T12:02:51+08:00 | 原创生成资产；上线前仍需品牌/商标复核 |
| iPhone final runtime PNG | `0a1eab91b0bfeb889ede86a26e0fbbb97b7bbc27490838ba18fc28b03dfab398` | 224,579 bytes | 2026-09-09T12:44:54+08:00 | 无 alpha；内部证据，不是营销截图集 |
| iPad final runtime PNG | `e7caa72fa3c42335d988b9fbe6b2e901de4c35644d7ecb9286d76cb059bb4dae` | 243,220 bytes | 2026-09-09T12:34:45+08:00 | 无 alpha；内部证据，不是营销截图集 |
| iOS Runner binary | `2a2784c473a0fe4c49b4c76952fb422b343f72d7fe93b872403b77cfe6d409a3` | 75,080 bytes | archive generated 2026-09-09 | 未签名；还包含 Flutter/App frameworks |

## 明确缺失

- 生产 Bundle ID、Apple Team、分发证书、provisioning profile 与签名 Archive。
- 稳定公开的 Privacy Policy URL、Support URL、责任主体与联系邮箱。
- Xcode 最终 Archive Privacy Report、真实网络行为审计和 App Store Connect 隐私回答。
- 完整中英文元数据、年龄分级、价格/地区、1–10 张每设备族真实流程截图。
- 实体设备、VoiceOver/TalkBack、最大字号、横屏和最低系统证据。
- 任何上传、处理、TestFlight 或 App Review 状态；本轮明确未执行。
