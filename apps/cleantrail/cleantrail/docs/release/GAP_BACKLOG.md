# 差距与发布待办

## P0 — 发布前必须完成

1. 由开发者确定并持有生产 Bundle ID、Apple Developer Team 与 App Store 分发配置；替换 `com.example.cleantrail`。
2. 发布中英文隐私政策和支持页到稳定 HTTPS URL；用真实法律主体与联系方式替换草稿占位。
3. 在 App Store Connect 创建版本元数据，完成隐私问卷、年龄评级、类别、描述、关键词、版权和 Review Notes。
4. 用最终签名构建拍摄无 alpha 的 6.9/6.5-inch iPhone 与 13-inch iPad 截图集。

## P1 — candidate 门禁

1. 在真实 iPhone/iPad 与最低 iOS 13 测试 Files provider、取消/失败、5 MB 与组合规模边界、重启恢复、清除、分享双附件和临时文件清理。
2. 覆盖深色冷启动、横竖屏、2× Dynamic Type、VoiceOver、后台/前台和低存储失败。
3. 从最终签名 archive 导出 Privacy Report，核对主 App/Flutter/插件 manifests、required-reason API 和 SDK 签名。
4. 记录可复现 branch/SHA 或源码快照；当前父目录不是 Git 仓库，无法提供提交级追溯。

## P2 — 提交质量

1. 检索 CleanTrail/清迹商标、App Store 名称与域名；形成资产与依赖权利台账。
2. 用目标用户 CSV 做可用性测试，验证 500 问题上限、日期地域歧义与质量分解释是否清楚。
3. 明确免费策略；任何 IAP、订阅、云同步、分析或崩溃上传都会触发支付与隐私重新审核。

本轮明确不执行上传、TestFlight、ASC 提交或审核。
