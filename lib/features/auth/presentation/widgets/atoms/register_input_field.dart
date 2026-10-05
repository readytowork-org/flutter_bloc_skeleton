import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../core/validators/form_validator.dart';
import '../../../../../shared/widgets/atoms/input_field.dart';

class RegisterInputField extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const RegisterInputField({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        spacing: 10,
        mainAxisAlignment: .center,
        children: [
          InputField(
            name: "full_name",
            hint: "Enter your full name",
            validator: FormValidator.fullName,
          ),
          InputField(
            name: "email",
            hint: "Enter email address",
            validator: FormValidator.email,
          ),
          InputField(
            name: "password",
            hint: "Enter password",
            isPassword: true,
            validator: FormValidator.password,
          ),
        ],
      ),
    );
  }
}
