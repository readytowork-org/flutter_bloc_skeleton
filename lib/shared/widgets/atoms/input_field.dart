import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class InputField extends HookWidget {
  final String name;
  final String? hint;
  final String? label;
  final bool isPassword;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState<bool>(isPassword);

    return FormBuilderTextField(
      name: name,
      validator: validator,
      obscureText: obscureText.value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText.value ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  obscureText.value = !obscureText.value;
                },
              )
            : null,
      ),
    );
  }
}
