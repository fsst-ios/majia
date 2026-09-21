# Trip Delta / 旅程差额

离线优先的中英文旅行预算应用。用户可在出发前按类别规划预算，旅行中快速记录当地币种支出，并在结束后比较计划、估算折算和最终入账金额。

## 产品边界

- Flutter，iOS / Android
- 本地 Application Support 文件持久化
- 无账号、后台、广告或分析 SDK
- 手填汇率可按旅程复用，不依赖在线汇率
- 中文和英文

## 本地验证

```bash
flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign
flutter build apk --debug
```

当前 App Store 预检仍有占位 Bundle ID、默认图标/启动图、公开隐私与支持 URL、签名和真机验证等阻断。详见 [`docs/release/APP_STORE_PREFLIGHT.md`](docs/release/APP_STORE_PREFLIGHT.md)。
