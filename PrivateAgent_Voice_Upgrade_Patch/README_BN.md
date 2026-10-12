# PrivateAgent Voice Upgrade Patch (বাংলা)

## গুরুত্বপূর্ণ অবস্থা
এটি **মূল PrivateAgent repository-র সম্পূর্ণ ZIP নয়** এবং মূল project-এ merge/build করে পরীক্ষা করা হয়নি। GitHub থেকে বর্তমান source checkout করা সম্ভব না হওয়ায় এটি একটি integration patch/template pack। প্রকৃত repository-র ফাইলের সঙ্গে মিলিয়ে merge করতে হবে।

লক্ষ্য:
- `Hey PrivateAgent` wake-word detection-এর integration point
- বাংলা/ইংরেজি speech flow-এর পরিকল্পনা
- Android microphone foreground service-এর প্রয়োজনীয় manifest declarations
- GitHub Actions build step
- নিরাপত্তা ও পরীক্ষা checklist

## কী আছে
- `lib/services/wake_word_service.dart`: Porcupine Flutter-এর জন্য wake-word service wrapper
- `android/manifest_permissions.xml`: প্রয়োজনীয় manifest declarations-এর snippet
- `android/manifest_service.xml`: foreground service declaration snippet
- `.github/workflows/flutter-apk-steps.yml`: বিদ্যমান workflow-তে merge করার build steps
- `docs/INTEGRATION_GUIDE_BN.md`: beginner-friendly integration guide

## কী নেই
- Picovoice Console থেকে তৈরি করা `.ppn` custom wake-word model
- তোমার Picovoice AccessKey
- মূল PrivateAgent-এর সব Dart/Kotlin source
- তৈরি/স্বাক্ষরিত APK
- সফল build/test-এর দাবি

## প্রয়োজনীয়
1. মূল repository clone/download করে এই patch-এর ফাইল merge করো।
2. Picovoice Console-এ `Hey PrivateAgent` custom keyword তৈরি করে Android `.ppn` model `assets/hey_privateagent_android.ppn` হিসেবে রাখো।
3. `pubspec.yaml`-এ dependency যোগ করে version compatibility যাচাই করো।
4. বর্তমান `MainActivity`, package name, `AndroidManifest.xml`, এবং voice/AI handler-এর সঙ্গে service integrate করো।
5. `flutter analyze`, tests এবং release build চালাও.

## Android reality check
Screen-off listening কেবল ফোন চালু থাকা, microphone permission, user-initiated foreground service, notification, battery settings এবং OS restrictions-এর মধ্যে চেষ্টা করা যাবে। ফোন powered off থাকলে কাজ করবে না। Locked screen-এ sensitive actions-এর জন্য unlock/confirmation লাগতে পারে।
