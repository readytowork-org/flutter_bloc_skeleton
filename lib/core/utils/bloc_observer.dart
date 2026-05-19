import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class SkeletonBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    log("-------------Bloc Event Listener running------------");
    log("Event: $event");
    log("------------------------------------------------");

    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("-------------Bloc Change Listener running------------");
    log("Change: $change");
    log("------------------------------------------------");
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("-------------Bloc Transition Listener running------------");
    log("Transition: $transition");
    log("------------------------------------------------");
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log("-------------Bloc Error Listener running------------");
    log("Error: $error");
    log("Stack Trace: $stackTrace");
    log("------------------------------------------------");
    super.onError(bloc, error, stackTrace);
  }
}
