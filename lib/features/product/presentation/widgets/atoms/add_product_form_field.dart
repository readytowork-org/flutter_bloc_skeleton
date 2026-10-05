import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../core/utils/typedf/index.dart';
import '../../../../../core/validators/form_validator.dart';
import '../../../../../shared/widgets/atoms/input_field.dart';

class AddEditProductFormField extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final JsonMap initialData;
  const AddEditProductFormField({
    super.key,
    required this.formKey,
    this.initialData = const {},
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      initialValue: initialData,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputField(
            name: "title",
            hint: "Enter a title",
            validator: FormValidator.required,
          ),
          InputField(
            name: "description",
            hint: "Enter a description",
            validator: FormValidator.required,
          ),
        ],
      ),
    );
  }
}
