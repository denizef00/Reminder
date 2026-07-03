import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reminder/services/gemini_services.dart';

final geminiServiceProvider = Provider<GeminiServices>(
  (ref) => GeminiServices(),
);

class GeminiProvider extends StateNotifier<bool> {
  GeminiProvider() : super(false);

  bool _isCanceled = false;
  bool get isCanceled => _isCanceled;

  void setLoading(bool value) {
    state = value;
    if (value == true) {
      _isCanceled = false;
    }
  }

  void cancelOperation() {
    _isCanceled = true;
    state = false;
  }
}

final geminiLoadingProvider = StateNotifierProvider<GeminiProvider, bool>((
  ref,
) {
  return GeminiProvider();
});
