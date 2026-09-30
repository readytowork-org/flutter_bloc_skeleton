import 'package:flutter/material.dart' show FormFieldValidator;
import 'package:form_builder_validators/form_builder_validators.dart'
    show FormBuilderValidators;

class FormValidator {
  static final FormFieldValidator<String> fullName =
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "full name is required"),
      ]);
  static final FormFieldValidator<String> email = FormBuilderValidators.compose(
    [FormBuilderValidators.required(errorText: "email is required")],
  );
  static final FormFieldValidator<String> password =
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "password is required"),
      ]);
  static final FormFieldValidator<String> required =
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "Please enter"),
      ]);
}
