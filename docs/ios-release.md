# iOS release — what is needed before the App Store

The team develops on Windows. iOS builds require Xcode, which runs only on
macOS, so nothing in this document can be done from a Windows machine. CI covers
the part that can be automated; the rest needs a Mac or a paid Apple account.

## What is already done

| | Status |
|---|---|
| Bundle identifier | `com.saasproperties.saasApp` |
| Deployment target | iOS 15.0 |
| Unsigned release build in CI | runs on every push (`build-ios` job) |

The CI job builds with `--no-codesign` on a macOS runner. That catches the
failures that actually happen — Swift/ObjC compilation errors, CocoaPods
resolution conflicts, plugins with no iOS implementation, deployment target
mismatches — on the commit that introduced them, rather than months later.

It does **not** produce anything installable. An unsigned `.app` cannot run on a
physical device or be uploaded to App Store Connect.

## What is still required

### 1. Apple Developer Program membership

USD 99/year, and it must be an **Organization** account for a company app, not
an Individual one. Organization enrolment requires a D-U-N-S number for SAAS
Properties and takes days to weeks to be approved. Start this early — it is
usually the longest lead time in the whole process.

### 2. App Store Connect record

Create the app record against the bundle identifier `com.saasproperties.saasApp`.
The identifier cannot be changed after the first upload, so confirm it is what
the business wants before shipping anything.

### 3. Signing assets

- **Distribution certificate** — identifies SAAS Properties as the publisher
- **Provisioning profile** — App Store type, tied to the bundle identifier

Both are generated in the Apple Developer portal. Xcode's automatic signing can
create them for you on a Mac; for CI they must be exported and stored as
encrypted GitHub secrets.

### 4. Assets and metadata Apple requires

- App icon at 1024×1024, no alpha channel and no rounded corners (Apple applies
  the mask). The placeholder icons from `flutter create` will be rejected.
- Screenshots at the current required device sizes
- Privacy policy URL — mandatory for all apps
- Privacy nutrition labels declaring what data the app collects. This app will
  need entries once SSO and the API are wired up.

### 5. Display name

`ios/Runner/Info.plist` currently has `CFBundleDisplayName` set to `Saas App`,
left over from `flutter create`. Android's label is `saas_app` for the same
reason. Both are user-visible and should be set deliberately before release —
the design calls the product **SAAS People**.

## Building a signed IPA (on a Mac)

```sh
flutter build ipa --release
```

Output is `build/ios/ipa/*.ipa`, uploadable via Xcode's Organizer, Transporter,
or `xcrun altool`.

## Automating the signed build later

Once certificates exist, the `build-ios` job can be extended to produce a signed
IPA and upload it to TestFlight on every push to `main`. That needs these
repository secrets:

- `IOS_DISTRIBUTION_CERTIFICATE_BASE64` and its password
- `IOS_PROVISIONING_PROFILE_BASE64`
- `APP_STORE_CONNECT_API_KEY` (key id, issuer id, and the .p8 contents)

**Never commit certificates, provisioning profiles or `.p8` keys to the repo.**
Anyone with the distribution certificate can publish software as SAAS Properties.

## Known gap on Android

The Android release build still signs with debug keys — see the `TODO` in
`android/app/build.gradle.kts`. Google Play will reject that artifact. It needs
a keystore, a gitignored `key.properties`, and a real `signingConfig` before the
first Play upload. Same rule applies: the keystore never goes in the repo, and
losing it means you can never update the app again.
