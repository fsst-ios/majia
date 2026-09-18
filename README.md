# majia

每个应用独立放在 `apps/<应用名>/`；GitHub Actions 工作流统一放在仓库根目录的 `.github/workflows/`。

| 应用 | 目录 | 来源 |
| --- | --- | --- |
| Jufu（photo） | [`apps/photo/`](apps/photo/) | [`CherryIce/photo`](https://github.com/CherryIce/photo)，迁移基点 `295a625059f8f4102d194029ba9bc58c68e87eb6` |

`photo` 的 [iOS CI](.github/workflows/photo-ios-ci.yml) 进行无签名构建，并保留不可直接安装到设备的 `Runner.app` 压缩产物；它不生成已签名 IPA。正式 Release Bundle ID 为 `com.lunelle.lite`；签名发布还需要单独配置证书、描述文件和受保护的 GitHub Environment。
