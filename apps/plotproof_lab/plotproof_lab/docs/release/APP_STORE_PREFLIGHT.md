# PlotProof Lab（图证实验室）App Store 预检报告

审核日期：2026-09-09

范围：本地源码、测试、iPhone/iPad 模拟器、Android Debug APK、iOS 无签名 Archive 和 Apple 当前官方规则；未访问 App Store Connect、未使用实体设备、未上传。

独立 Store Reviewer 结论：blocked / not submission candidate。MVP 功能门禁已通过，但生产身份、公开 URL、签名和商店资料未形成，不能提交。

## 阻断与风险

| 优先级 | 阻断/风险 | 当前证据 | 进入下一门禁的验收条件 | 状态 |
| --- | --- | --- | --- | --- |
| P0 | iOS Bundle ID 仍为 com.example.plotproofLab，Archive 无签名、Team 或 profile | 机械预检、Archive Info、codesign verify | 确定生产 App ID；源码/ASC/Archive 一致；Distribution 签名验证通过 | open |
| P0 | 无公开 Privacy Policy URL，App 内仅有静态摘要 | 本地隐私草案、设置页源码 | 发布真实 HTTPS 政策；App 内可打开；内容与最终数据/SDK 行为一致 | open |
| P0 | 无 Support URL 与可联系的责任主体 | 机械预检、本地草案 | 公开支持页含稳定联系方式，并填入 ASC 本地化字段 | open |
| P0 | 没有必填主设备档截图 | 现有 1206×2622 iPhone 与 1640×2360 iPad PNG 仅通过格式检查 | 按当前规范提供 6.9/6.5 英寸 iPhone；若支持 iPad，再提供 13 英寸；展示真实核心流程 | open |
| P1 | 无实体设备/系统读屏/生命周期证据 | 只有模拟器、Widget 和无签名 Archive | 在最终签名构建上验证实体 iPhone/iPad、最低系统、VoiceOver、后台恢复和低资源场景 | open |
| P1 | 八关内容仍有 4.2 耐久价值风险 | 参数实验闭环可见，但每类只有两关 | 商店材料准确突出实验闭环；建议扩展到至少 12 个原创迁移实验后再提交 | open |
| P1 | 最终隐私供应链未闭环 | 归档内 3 份 manifest 可解析；shared_preferences 声明 UserDefaults 1C8F.1 | 生成签名 Archive Privacy Report，核对依赖、实际网络和 ASC No Data Collected 回答 | open |
| P2 | 启动图仍有 Flutter 默认占位警告 | iOS 构建日志 | 替换为正式品牌启动表现并在浅/深色与设备矩阵验收 | open |
| P2 | iOS 原生工程 region 仅 en/Base | Xcode 工程配置 | 声明并验证 zh/en 商店及系统语言呈现 | open |
| P2 | 工程非 Git 仓库 | 本地源码聚合哈希 | 建立版本库并用 branch/SHA 绑定候选构建 | open |

## 规则矩阵

| 当前 Apple 规则 | 适用性与结论 | 本地证据 | 外部缺口 |
| --- | --- | --- | --- |
| [1.5 Developer Information](https://developer.apple.com/app-store/review/guidelines/) | blocked：支持联系信息未形成 | Review Notes 草案 | Support URL、责任主体、邮箱 |
| [2.1 App Completeness](https://developer.apple.com/app-store/review/guidelines/) | high risk：功能/自动化通过，但未完成真机与最终签名验证 | 25 tests、模拟器、无签名 archive | 真机、最低系统、正式 build |
| [2.3 Accurate Metadata](https://developer.apple.com/app-store/review/guidelines/) | blocked：没有完整元数据或合规设备档截图 | 两张内部运行态图，均无 alpha | 中英文元数据、核心流程截图、年龄分级 |
| [3.1 Payments](https://developer.apple.com/app-store/review/guidelines/) | not applicable：无购买、订阅或付费功能 | 源码/依赖审计 | 若商业模式变化需重审 |
| [4.1 Copycats](https://developer.apple.com/app-store/review/guidelines/) | passed at local review：未复制参考 App 品牌、内容或结构 | 差异化报告、权利台账 | 名称/商标最终检索 |
| [4.2 Minimum Functionality](https://developer.apple.com/app-store/review/guidelines/) | high risk：四类参数实验有实质互动，八关规模仍偏薄 | 判断→操作→对照→解释→复练 | 内容规模与长期价值的人审不确定性 |
| [4.3 Spam](https://developer.apple.com/app-store/review/guidelines/) | passed at local review：独立工程与产品循环；无重复 Bundle 提交证据 | 与 cleantrail 分离，原创性评分 4.0/5 | ASC 产品组合未访问 |
| [4.8 Login Services](https://developer.apple.com/app-store/review/guidelines/) | not applicable：没有账号或第三方登录 | 无登录源码/依赖 | — |
| [5.1.1 Privacy](https://developer.apple.com/app-store/review/guidelines/) | blocked：本地最小化设计良好，但缺双位置政策 URL 与最终声明 | 无账号/权限/业务网络；本地清除；Privacy manifests | 公共政策、App 内链接、Privacy Report、ASC 回答 |
| [5.2 Intellectual Property](https://developer.apple.com/app-store/review/guidelines/) | conditional pass：合成数据与文案为本项目原创记录 | CONTENT_RIGHTS.md | 名称/图标人工与商标复核、最终依赖许可包 |
| [2026 SDK baseline](https://developer.apple.com/news/upcoming-requirements/) | passed：Archive 使用 Xcode 26.5 与 iOS 26.5 SDK | Archive DTXcode 2650、DTSDKName iphoneos26.5 | 提交时再次复核 Apple 最新要求 |

## 身份、隐私与依赖观察

- Archive 版本 1.0.0 (1)，最低 iOS 13.0，arm64；Bundle ID 与源码一致但仍为 example 占位符。
- Archive 嵌入 App.framework、Flutter.framework、shared_preferences_foundation.framework；App、Flutter 和插件 PrivacyInfo.xcprivacy 均可解析。
- 应用无账号、IAP、广告、分析、系统权限或业务网络代码；仅本地保存尝试和语言偏好。该观察不等于对最终签名二进制的网络保证。
- 1024×1024 App Icon 无 alpha；两张内部证据 PNG 尺寸/alpha 合法，但不满足当前必填主设备档，也没有覆盖核心实验截图集。
- Education 类别与专项交互式学习定位相符；避免使用“自动识别真假新闻”等超出功能的名称或元数据。

## 当前官方依据

- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)（访问 2026-09-09）
- [App Store categories](https://developer.apple.com/app-store/categories/)（访问 2026-09-09）
- [App privacy details](https://developer.apple.com/app-store/app-privacy-details/) 与 [Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/)（访问 2026-09-09）
- [Third-party SDK requirements](https://developer.apple.com/support/third-party-SDK-requirements/) 与 [Required-reason APIs](https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api)（访问 2026-09-09）
- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)（访问 2026-09-09）
- [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information)、[Submit an app](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app) 与 [Age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/)（访问 2026-09-09）

## 禁止误读

质量门禁 passed 只证明本地格式、静态分析、测试及两种构建命令成功。机械预检 blocked 是发布材料不足的真实结论。无签名 Archive、模拟器截图和上传前脚本都不能证明 App Store Connect、TestFlight 或 App Review 状态；本项目没有执行任何上传。
