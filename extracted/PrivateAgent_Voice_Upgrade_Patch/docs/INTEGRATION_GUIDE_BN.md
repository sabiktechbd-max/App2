# Integration guide — PrivateAgent Voice Upgrade

## 1) Repository-তে কাজ শুরু
- GitHub-এ নিজের fork তৈরি করো।
- `feature/hey-privateagent` branch-এ কাজ করো; upstream `main` সরাসরি পরিবর্তন কোরো না।
- বর্তমান `pubspec.yaml`, `AndroidManifest.xml`, `MainActivity.kt`, native accessibility service, এবং `.github/workflows` আগে backup/commit করো।

## 2) Wake word model
- Picovoice Console: https://console.picovoice.ai/
- `Hey PrivateAgent` custom keyword model তৈরি করো।
- Android-এর `.ppn` ফাইল `assets/hey_privateagent_android.ppn` নামে রাখো।
- `pubspec.yaml`-এ:
  ```yaml
  dependencies:
    porcupine_flutter: <Console/docs এবং pub.dev-এ যাচাই করা compatible version>
  ```
- `flutter pub get` চালাও এবং `flutter analyze` চালাও।
- API signature package version অনুযায়ী যাচাই করো; plugin API বদলাতে পারে।

## 3) AccessKey
- Source code-এ AccessKey hardcode কোরো না।
- মনে রেখো, mobile app-এর ভেতর রাখা client key পুরোপুরি গোপন থাকে না।
- Public repository-তে `.ppn` model বা credential প্রকাশের আগে provider terms/license যাচাই করো।
- Production-grade private key protection-এর জন্য backend proxy বিবেচনা করো।

## 4) Wake word-এর পর voice flow
`onWakeWord` callback-এ:
1. Wake-word listener থামাও বা audio ownership handoff করো।
2. Existing `speech_to_text` flow দিয়ে বাংলা/ইংরেজি command নাও।
3. Existing PrivateAgent AI/task handler-এ recognized text পাঠাও।
4. Existing `flutter_tts` দিয়ে উত্তর বলো।
5. Command শেষ হলে foreground service ও listener-এর lifecycle পুনরায় শুরু করো।
একই সময়ে দুইটি engine microphone দখল করলে conflict হতে পারে; device-এ পরীক্ষা করো।

## 5) Screen-off/background listening
Flutter service wrapper নিজে Android foreground service নয়। Kotlin service-এ:
- `startForeground()` এবং ongoing notification
- microphone foreground service type
- Android 14+ service permission/type rules
- runtime RECORD_AUDIO permission
- explicit user Start Listening action
- stop action এবং `onDestroy()` cleanup
- microphone/Porcupine resources release
লাগবে। Android-এর background-start restrictions মেনে চলতে হবে। Reboot-এর পর নিজে থেকে microphone চালু হবে—এমন অনুমান কোরো না।

## 6) Device control
- Accessibility Service: screen hierarchy, tap, scroll, text input; ব্যবহারকারীকে নিজে enable করতে হবে।
- Android intents: Settings screens ও supported actions খুলতে।
- Wi-Fi/Bluetooth/airplane mode-এর direct control Android version ও privileges অনুযায়ী সীমিত।
- SMS/call/contact permissions ও Play policy প্রযোজ্য হতে পারে।
- destructive বা privacy-sensitive action-এর আগে confirmation রাখো।
- lock-screen security bypass করার চেষ্টা কোরো না।

## 7) GitHub Actions
- Workflow-তে Flutter SDK, JDK এবং Android SDK setup আগে থাকতে হবে।
- বর্তমান workflow-র `sdkmanager` version conflict থাকলে সেই অংশ আলাদা করে ঠিক করো।
- প্রথমে `flutter analyze`, `flutter test`, তারপর `flutter build apk --release` চালাও।
- Build green না হওয়া পর্যন্ত artifact-কে working release বলো না।

## 8) Device test checklist
- [ ] app foreground + wake word
- [ ] অন্য app foreground
- [ ] screen off 5/15/30 মিনিট
- [ ] battery saver enabled
- [ ] microphone permission revoked/regranted
- [ ] notification permission
- [ ] Bluetooth headset connected/disconnected
- [ ] Bengali speech and English speech
- [ ] repeated wake events / false positives
- [ ] screen lock and sensitive commands
- [ ] reboot behaviour
- [ ] no microphone leak after Stop
- [ ] GitHub Actions build and tests pass

## Official references
- Repository: https://github.com/orailnoor/private-agent
- Porcupine Flutter: https://pub.dev/packages/porcupine_flutter
- Picovoice Console: https://console.picovoice.ai/
- Android foreground services: https://developer.android.com/develop/background-work/services/foreground-services
- Android microphone restrictions: https://developer.android.com/develop/background-work/services/foreground-services#bg-access-restrictions
