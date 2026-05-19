import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../core/validators/form_validator.dart';
import '../../../../../l10n/s.dart';
import '../../../../../shared/widgets/atoms/input_field.dart';

class LoginInputField extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  const LoginInputField({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputField(
            name: "username",
            hint: S.of(context).authName,
            validator: FormValidator.fullName,
          ),
          InputField(
            name: "password",
            hint: S.of(context).authPassword,
            isPassword: true,
            validator: FormValidator.password,
          ),
        ],
      ),
    );
  }
}
