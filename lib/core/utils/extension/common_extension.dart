import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

extension BreakWord on String {
  String get breakWord {
    String breakWord = '';
    for (var element in runes) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    }
    return breakWord;
  }
}

extension ElevatedButtonLoadingExtension on ElevatedButton {
  ElevatedButton withLoading(bool loading) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const CircularProgressIndicator() : child,
    );
  }
}

extension OutlinedButtonLoadingExtension on OutlinedButton {
  OutlinedButton withLoading(bool loading) {
    return OutlinedButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const CircularProgressIndicator() : child,
    );
  }
}

extension TextButtonLoadingExtension on TextButton {
  TextButton withLoading(bool loading) {
    return TextButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const CircularProgressIndicator() : child ?? SizedBox(),
    );
  }
}

extension ApiIdExtension on String {
  String addId(dynamic id) {
    return '$this/$id';
  }
}

extension FormBuilderStateExtension on GlobalKey<FormBuilderState> {
  Map<String, dynamic> get formValue => currentState?.value ?? {};
  bool get isValid => currentState?.saveAndValidate() ?? false;
}
