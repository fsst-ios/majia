# Flutter Release Mechanical Preflight

Generated: 2026-09-18T11:52:36+08:00
Project: `/Users/starburst/Downloads/app-ui-atlas/trip_delta`
Mechanical verdict: `blocked`

| Status | Check | Summary | Evidence |
| --- | --- | --- | --- |
| `warning` | source_traceability | No commit-level Git identity is available. | {"is_repository": false} |
| `blocker` | bundle_identity | Missing or placeholder iOS Bundle ID. | {"identifiers": ["com.example.tripDelta", "com.example.tripDelta.RunnerTests"], "placeholders": ["com.example.tripDelta"], "expected_bundle_id": "com.example.tripDelta"} |
| `blocker` | privacy_url | Privacy Url: not provided. |  |
| `blocker` | support_url | Support Url: not provided. |  |
| `pass` | preview_labels | No common MVP/prototype/demo wording was found in the scanned app-facing source types. | {"hits": [], "scanned_suffixes": [".arb", ".dart", ".java", ".json", ".kt", ".m", ".mm", ".plist", ".strings", ".swift", ".txt", ".xcstrings", ".xml", ".yaml", ".yml"]} |
| `pass` | app_icon | 1024px AppIcon exists without alpha. | {"path": "/Users/starburst/Downloads/app-ui-atlas/trip_delta/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png", "width": 1024, "height": 1024, "has_alpha": false} |
| `pass` | archive_info | Archive Info.plist was parsed. | {"CFBundleIdentifier": "com.example.tripDelta", "CFBundleShortVersionString": "1.0.0", "CFBundleVersion": "1", "MinimumOSVersion": "15.0", "DTXcode": "2650", "DTSDKName": "iphoneos26.5", "CFBundleDevelopmentRegion": "en"} |
| `blocker` | code_signing_presence | Archive lacks a validating signature or embedded provisioning profile. | {"verify_return_code": 1, "verify_output": "/Users/starburst/Downloads/app-ui-atlas/trip_delta/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app: code object is not signed at all\nIn architecture: arm64", "details": "/Users/starburst/Downloads/app-ui-atlas/trip_delta/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app: code object is not signed at all", "embedded_mobileprovision": false} |
| `pass` | privacy_manifests | Privacy manifests were found and parsed. | [{"path": "Frameworks/Flutter.framework/PrivacyInfo.xcprivacy", "valid_plist": true}, {"path": "Frameworks/path_provider_foundation.framework/path_provider_foundation_privacy.bundle/PrivacyInfo.xcprivacy", "valid_plist": true}] |
| `info` | archive_dependencies | Recorded embedded archive frameworks for reviewer inspection. | ["App.framework", "Flutter.framework", "path_provider_foundation.framework"] |
| `pass` | archive_source_identity | Archive Bundle ID matches the selected source configuration. | {"expected": "com.example.tripDelta", "archive": "com.example.tripDelta"} |
| `pass` | archive_source_version | Archive version and build number match the expected Flutter source values. | {"expected_version": "1.0.0", "expected_build_number": "1", "archive_version": "1.0.0", "archive_build_number": "1"} |
| `warning` | screenshots | Screenshots exist but at least one has alpha or is unreadable. | [{"path": "/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/iphone16-completed-en.png", "width": 1179, "height": 2556, "has_alpha": true}, {"path": "/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/iphone16-empty-zh.png", "width": 1179, "height": 2556, "has_alpha": true}, {"path": "/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/iphone-se-stress-home-en.png", "width": 750, "height": 1334, "has_alpha": true}, {"path": "/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/ipad11-stress-home-en.png", "wid |
| `pass` | requested_artifacts | All explicitly requested artifacts exist and will be recorded. | {"requested": ["/Users/starburst/Downloads/app-ui-atlas/trip_delta/build/app/outputs/flutter-apk/app-debug.apk"], "missing": []} |

## Artifact hashes

- `/Users/starburst/Downloads/app-ui-atlas/trip_delta/build/app/outputs/flutter-apk/app-debug.apk` — SHA-256 `010b829bca165076c3c6883dc644962c99248eb29b62a82b1b333dece2d5f507`, 161204141 bytes
- `/Users/starburst/Downloads/app-ui-atlas/trip_delta/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/Runner` — SHA-256 `a66a629dc0315563efb8b8b721edaac2f3ed9aa7bb26e7118b19609a25d5d428`, 73808 bytes
- `/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/iphone16-completed-en.png` — SHA-256 `47cdad33387a8883ee0ee9cda1a3806b93389a19f14df2acd05dd13a8e391fc5`, 143948 bytes
- `/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/iphone16-empty-zh.png` — SHA-256 `b75eee0eb1243786d8012fe773176029db5e0f71122d10ae98746bcf6032e605`, 162903 bytes
- `/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/iphone-se-stress-home-en.png` — SHA-256 `46672dd6299858223b1b45210caafa5c7f432d292671ff9760e7a212cab51f7e`, 95659 bytes
- `/Users/starburst/Downloads/app-ui-atlas/trip_delta/docs/release/evidence/ipad11-stress-home-en.png` — SHA-256 `783095975c969e346b09c30b65a8cff96d17f914ea822876ddd2c2fd39b2d320`, 160000 bytes

## Required interpretation

- `review_required` is not an App Store candidate verdict; the Store Reviewer must verify current official requirements and external state.
- This script does not check trademark rights, legal sufficiency, real URL content, App Store Connect metadata, physical devices, upload processing, TestFlight, or App Review.
- This script never uploads, submits, changes certificates, or mutates external accounts.
