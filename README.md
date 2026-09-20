# majia

每个应用独立放在 `apps/<应用名>/`；GitHub Actions 工作流统一放在仓库根目录的 `.github/workflows/`。

| 应用 | 目录 | 来源 |
| --- | --- | --- |
| Jufu（photo） | [`apps/photo/`](apps/photo/) | [`CherryIce/photo`](https://github.com/CherryIce/photo)，迁移基点 `295a625059f8f4102d194029ba9bc58c68e87eb6` |
| TripCost（RoamSum） | [`apps/tripcost/`](apps/tripcost/) | [`CherryIce/TripCost`](https://github.com/CherryIce/TripCost)，迁移基点 `5e8e2975d0967a31691529ef603e22e0f1cb63cb` |
| Donesome（LAURUS） | [`apps/donesome/`](apps/donesome/) | [`CherryIce/Donesome`](https://github.com/CherryIce/Donesome)，迁移基点 `ccc86d05c66935005d0db25a4c50224a07633119` |

`photo` 的 [iOS CI](.github/workflows/photo-ios-ci.yml) 进行无签名构建，并保留不可直接安装到设备的 `Runner.app` 压缩产物；它不生成已签名 IPA。正式 Release Bundle ID 为 `com.lunelle.lite`；签名发布还需要单独配置证书、描述文件和受保护的 GitHub Environment。

`tripcost` 的 [iOS Release](.github/workflows/tripcost-ios-release.yml) 可手动归档并签名 Runner 与 AppWidget，默认不上传 App Store Connect；签名材料需配置在 `tripcost-production` Environment 中。

`donesome` 的 [iOS Release](.github/workflows/donesome-ios-release.yml) 可手动归档并签名 LAURUS，默认不上传 App Store Connect；签名材料需配置在 `hearthio-production` Environment 中。
