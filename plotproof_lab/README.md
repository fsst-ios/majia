# PlotProof Lab / 图证实验室

An offline-first bilingual Flutter lab for learning how chart scales, outliers,
sample composition, and risk framing can change a claim.

## Product loop

1. Commit a judgment before seeing the explanation.
2. Change one experimental parameter.
3. Compare the same synthetic data under a fairer representation.
4. Read the reasoning and save the result locally.
5. Retry recent mistakes from the review queue.

The app has no account, backend, advertising, analytics, network content, or
system permissions. It stores only language preference and learning attempts in
local `SharedPreferences`. Settings includes a confirmed clear-all action.

## Run and test

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Product and release evidence is under `docs/product/` and `docs/release/`.
`com.example.plotproofLab`, public URLs, signing, physical-device evidence, and
App Store metadata are placeholders or missing release inputs, not submission
proof.
