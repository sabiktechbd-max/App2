import 'package:porcupine_flutter/porcupine_manager.dart';

/// Wake-word wrapper for the PrivateAgent integration.
///
/// Add the Android custom keyword file at:
/// assets/hey_privateagent_android.ppn
///
/// Start this only after the app has obtained microphone permission and
/// while Android's required foreground microphone service is active.
/// This class alone does NOT provide reliable screen-off/background execution.
class WakeWordService {
  PorcupineManager? _manager;
  bool _running = false;

  bool get isRunning => _running;

  Future<void> start({
    required String accessKey,
    required void Function() onWakeWord,
    void Function(Object error)? onError,
  }) async {
    if (_running) return;
    if (accessKey.trim().isEmpty) {
      throw ArgumentError('Picovoice AccessKey is required.');
    }

    final manager = await PorcupineManager.fromKeywordPaths(
      accessKey,
      const ['assets/hey_privateagent_android.ppn'],
      (int keywordIndex) {
        onWakeWord();
      },
      errorCallback: (error) {
        onError?.call(error);
      },
    );

    _manager = manager;
    try {
      await manager.start();
      _running = true;
    } catch (_) {
      _manager = null;
      await manager.delete();
      rethrow;
    }
  }

  Future<void> stop() async {
    final manager = _manager;
    _manager = null;
    _running = false;
    if (manager == null) return;

    try {
      await manager.stop();
    } finally {
      await manager.delete();
    }
  }
}
