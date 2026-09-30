import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocExtensions<T> on BlocBase<T> {
  Listenable asListenable() {
    final notifier = ChangeNotifier();
    stream.listen((_) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      notifier.notifyListeners();
    });
    return notifier;
  }

  ValueListenable<T> asValueListenable({BlocBuilderCondition? notifyWhen}) {
    final notifier = ValueNotifier<T>(state);
    stream.listen((value) {
      if (notifyWhen == null || notifyWhen(notifier.value, value)) {
        notifier.value = value;
      }
    });
    return notifier;
  }
}
