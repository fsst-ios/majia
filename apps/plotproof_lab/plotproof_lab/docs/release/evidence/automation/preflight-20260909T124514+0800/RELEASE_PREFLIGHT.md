# Flutter Release Mechanical Preflight

Generated: 2026-09-09T12:45:14+08:00
Project: `/Users/starburst/Downloads/app-ui-atlas/plotproof_lab`
Mechanical verdict: `blocked`

| Status | Check | Summary | Evidence |
| --- | --- | --- | --- |
| `warning` | source_traceability | No commit-level Git identity is available. | {"is_repository": false} |
| `blocker` | bundle_identity | Missing or placeholder iOS Bundle ID. | {"identifiers": ["com.example.plotproofLab", "com.example.plotproofLab.RunnerTests"], "placeholders": ["com.example.plotproofLab"], "expected_bundle_id": "com.example.plotproofLab"} |
| `blocker` | privacy_url | Privacy Url: not provided. |  |
| `blocker` | support_url | Support Url: not provided. |  |
| `pass` | preview_labels | No common MVP/prototype/demo wording was found in the scanned app-facing source types. | {"hits": [], "scanned_suffixes": [".arb", ".dart", ".java", ".json", ".kt", ".m", ".mm", ".plist", ".strings", ".swift", ".txt", ".xcstrings", ".xml", ".yaml", ".yml"]} |
| `pass` | app_icon | 1024px AppIcon exists without alpha. | {"path": "/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png", "width": 1024, "height": 1024, "has_alpha": false} |
| `pass` | archive_info | Archive Info.plist was parsed. | {"CFBundleIdentifier": "com.example.plotproofLab", "CFBundleShortVersionString": "1.0.0", "CFBundleVersion": "1", "MinimumOSVersion": "13.0", "DTXcode": "2650", "DTSDKName": "iphoneos26.5", "CFBundleDevelopmentRegion": "en"} |
| `blocker` | code_signing_presence | Archive lacks a validating signature or embedded provisioning profile. | {"verify_return_code": 1, "verify_output": "/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app: code object is not signed at all\nIn architecture: arm64", "details": "/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app: code object is not signed at all", "embedded_mobileprovision": false} |
| `pass` | privacy_manifests | Privacy manifests were found and parsed. | [{"path": "Frameworks/Flutter.framework/PrivacyInfo.xcprivacy", "valid_plist": true}, {"path": "Frameworks/shared_preferences_foundation.framework/shared_preferences_foundation_privacy.bundle/PrivacyInfo.xcprivacy", "valid_plist": true}, {"path": "PrivacyInfo.xcprivacy", "valid_plist": true}] |
| `info` | archive_dependencies | Recorded embedded archive frameworks for reviewer inspection. | ["App.framework", "Flutter.framework", "shared_preferences_foundation.framework"] |
| `pass` | archive_source_identity | Archive Bundle ID matches the selected source configuration. | {"expected": "com.example.plotproofLab", "archive": "com.example.plotproofLab"} |
| `pass` | archive_source_version | Archive version and build number match the expected Flutter source values. | {"expected_version": "1.0.0", "expected_build_number": "1", "archive_version": "1.0.0", "archive_build_number": "1"} |
| `pass` | screenshots | Screenshot PNG dimensions and alpha were inspected. | [{"path": "/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/docs/release/evidence/runtime/iphone17pro-final-runtime-flat.png", "width": 1206, "height": 2622, "has_alpha": false}, {"path": "/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/docs/release/evidence/runtime/ipad-air11-zh-light-home-revised-flat.png", "width": 1640, "height": 2360, "has_alpha": false}] |
| `pass` | requested_artifacts | All explicitly requested artifacts exist and will be recorded. | {"requested": ["/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/assets/branding/app_icon_master.png", "/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/build/app/outputs/flutter-apk/app-debug.apk"], "missing": []} |

## Artifact hashes

- `/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/assets/branding/app_icon_master.png` — SHA-256 `6ea38db96670f3022c807a358fe640ceae805fe4ea70adfaadaab8e230dbbd54`, 855922 bytes
- `/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/build/app/outputs/flutter-apk/app-debug.apk` — SHA-256 `4b4ed43171edacbcc382ddf472e9eef696b942e0f36cb89fba8b4f602830c98e`, 161181388 bytes
- `/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/Runner` — SHA-256 `2a2784c473a0fe4c49b4c76952fb422b343f72d7fe93b872403b77cfe6d409a3`, 75080 bytes
- `/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/docs/release/evidence/runtime/iphone17pro-final-runtime-flat.png` — SHA-256 `0a1eab91b0bfeb889ede86a26e0fbbb97b7bbc27490838ba18fc28b03dfab398`, 224579 bytes
- `/Users/starburst/Downloads/app-ui-atlas/plotproof_lab/docs/release/evidence/runtime/ipad-air11-zh-light-home-revised-flat.png` — SHA-256 `e7caa72fa3c42335d988b9fbe6b2e901de4c35644d7ecb9286d76cb059bb4dae`, 243220 bytes

## Required interpretation

- `review_required` is not an App Store candidate verdict; the Store Reviewer must verify current official requirements and external state.
- This script does not check trademark rights, legal sufficiency, real URL content, App Store Connect metadata, physical devices, upload processing, TestFlight, or App Review.
- This script never uploads, submits, changes certificates, or mutates external accounts.
