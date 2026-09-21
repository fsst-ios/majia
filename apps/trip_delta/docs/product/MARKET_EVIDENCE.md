# 市场与参考证据（访问：2026-09-18）

| 来源 | 发布者 | 直接观察 | 推断/限制 |
| --- | --- | --- | --- |
| [071 静态设计](references/071.html) | 用户提供的概念册 | 标题“多币种旅行预算”，展示预估总额、类别预算、添加开支，页面注明 DEMO DATA 且按钮仅作展示 | 仅用于明确需求，不等于已实现产品，也不复用品牌/布局 |
| [RoamSum App Store](https://apps.apple.com/us/app/roamsum/id6803728146) | RoamSum 开发者/Apple 页面 | 商店文案描述价格扫描、汇率缓存/手动汇率、支付方式成本、DCC、行程总预算、实际记账、CSV/PDF；展示免费、无账号主张 | 商店文案未经独立运行核验；不能据此推断所有功能质量 |
| [TripCost 分支](https://github.com/CherryIce/TripCost/tree/version/v1.0.0) / [README](https://raw.githubusercontent.com/CherryIce/TripCost/refs/heads/version/v1.0.0/README.md) | CherryIce | 指定分支 HEAD 5808d20c96530b22e87bf0335d19a2476645b6e6；网站与文档使用 RoamSum 品牌；[TripModel](https://raw.githubusercontent.com/CherryIce/TripCost/refs/heads/version/v1.0.0/lib/core/domain/core_models.dart) 为 totalBudget，[汇总](https://raw.githubusercontent.com/CherryIce/TripCost/refs/heads/version/v1.0.0/lib/core/trips/domain/trip_budget.dart) 有类别支出，未见类别计划预算字段 | 与 RoamSum 是同源资料，不算第二个独立竞品；没有查看完整运行态；不借用实现 |
| [TravelSpend 官网](https://travel-spend.com/) / [App Store](https://apps.apple.com/us/app/travelspend-travel-budget-app/id1434284824) | Ori App Studio GmbH | 官网描述离线记账、自动汇率、总预算、统计、同步与 CSV | 这些是官方功能主张，未实际试用 |
| [TravelSpend 类别预算帮助](https://help.travel-spend.com/travel-budget/3shM3rgJUHqqd4VcV38Vqt/can-i-set-separate-budgets-for-individual-categories/3R7SjaJVz7GMguyAeTMKCN) / [预算帮助](https://help.travel-spend.com/travel-budget/3shM3rgJUHqqd4VcV38Vqt/how-to-create-a-travel-budget/3shM3rgJUL1iiD2EW9fQ84) | TravelSpend 帮助中心 | 明确仅设一个行程总预算，不设类别预算；建议旅行后复盘 | 只支持类别级前后对照机会；不能说它没有复盘 |
| [GitHub 许可说明](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository) | GitHub Docs | 无许可证时默认保留版权 | TripCost 根项目未见整体许可证，独立重写是安全边界 |

## 机会与不确定性

公开证据支持一个类别级计划与实付配对的空缺。RoamSum 有手动汇率与历史快照，故手动汇率不是差异点。TravelSpend 有旅行后复盘，不宣称竞品没有总结。尚无访谈、转化或留存证据证明用户愿意持续记录；MVP 的任务完成率和复盘价值需要真实用户验证。
