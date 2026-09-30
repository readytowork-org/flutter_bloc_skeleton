import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/index.dart';
import '../../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../../shared/widgets/atoms/input_field.dart';
import '../../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../../domain/entities/product_entity.dart';
import '../../state_management/edit_product_bloc/edit_product_bloc.dart';
import '../../state_management/get_all_products_bloc/product_pagination_bloc.dart';
import '../../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';

class EditProductView extends StatefulWidget {
  final ProductEntity initialData;
  const EditProductView({super.key, required this.initialData});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final formKey = GlobalKey<FormBuilderState>();

  void onEditProductStateListener(
    BuildContext context,
    EditProductState state,
  ) {
    state.maybeWhen(
      success: (product) {
        context.read<GetProductByIdBloc>().add(
          GetProductByIdEvent.productUpdatedLocally(product: product),
        );
        context.read<ProductPaginationBloc>().add(
          PaginationEvent.updateLocally(data: product),
        );
        context.showSnackBar('✅ Product updated successfully!');
        context.pop();
      },
      failure: (message) => context.showSnackBar(message),
      orElse: () {},
    );
  }

  void onEditProductButtonPressed(EditProductBloc bloc) {
    if (formKey.isValid) {
      bloc.add(
        EditProductEvent.updatedProductRequested(
          productData: formKey.formValue,
          id: widget.initialData.id.toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProductBloc>();
    return BlocListener<EditProductBloc, EditProductState>(
      listener: onEditProductStateListener,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero header
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 190,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1565C0), Color(0xFF097693)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(20),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -40,
                        bottom: -40,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 110, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.edit_note_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              editProductTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              editProductSubtitle,
                              style: TextStyle(
                                color: Colors.white.withAlpha(204),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Thumbnail preview
                Positioned(
                  right: 24,
                  top: 30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(widget.initialData.thumbnail),
                        fit: BoxFit.cover,
                        onError: (e, _) {},
                      ),
                    ),
                    child: widget.initialData.thumbnail.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(Icons.image_outlined, color: AppColors.greyDark),
                          )
                        : null,
                  ),
                ),
              ],
            ),

            // Metadata chips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.category_outlined,
                    label: widget.initialData.category,
                  ),
                  _InfoChip(
                    icon: Icons.business_outlined,
                    label: widget.initialData.brand,
                  ),
                  _InfoChip(
                    icon: Icons.attach_money,
                    label: '\$${widget.initialData.price.toStringAsFixed(2)}',
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.text_fields_rounded,
                    title: 'Product Details',
                  ),
                  const SizedBox(height: 20),
                  FormBuilder(
                    key: formKey,
                    initialValue: widget.initialData.toRequest(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _FieldLabel(label: 'Title'),
                        const SizedBox(height: 8),
                        InputField(
                          name: 'title',
                          hint: 'Enter product title',
                          label: 'Product Title',
                        ),
                        const SizedBox(height: 20),
                        const _FieldLabel(label: 'Description'),
                        const SizedBox(height: 8),
                        InputField(
                          name: 'description',
                          hint: 'Enter product description',
                          label: 'Description',
                        ),
                        const SizedBox(height: 36),
                        BlocBuilder<EditProductBloc, EditProductState>(
                          builder: (context, state) {
                            final isLoading = state is EditProductLoading;
                            return SizedBox(
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : () => onEditProductButtonPressed(bloc),
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Icon(Icons.save_rounded, size: 20),
                                label: Text(
                                  isLoading ? 'Updating...' : editProductButtonText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 48,
                          child: TextButton(
                            onPressed: () => context.pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.greyDark,
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.greyDark,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    this.color = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
