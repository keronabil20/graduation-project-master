// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_item_event.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_item_state.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/utils/widgets/image_upload_widget.dart';
import 'bloc/menu_item_bloc.dart';

class MenuItemFormScreen extends StatefulWidget {
  final MenuItem? menuItem;

  const MenuItemFormScreen({super.key, this.menuItem});

  @override
  State<MenuItemFormScreen> createState() => _MenuItemFormScreenState();
}

class _MenuItemFormScreenState extends State<MenuItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    if (widget.menuItem != null) {
      _nameController.text = widget.menuItem!.name;
      _priceController.text = widget.menuItem!.price.toString();
      _categoryController.text = widget.menuItem!.category;
      _descriptionController.text = widget.menuItem!.description;
      _imageBase64 = widget.menuItem!.image;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuItemFormBloc, MenuItemFormState>(
      listener: (context, state) {
        if (state is MenuItemFormSaved) {
          Navigator.pop(context, true);
        } else if (state is MenuItemFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.menuItem == null ? 'Create Menu Item' : 'Edit Menu Item'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ImageUploadWidget(
                  storagePath: 'menu_items',
                  label: 'Item Image',
                  onImageSelected: (base64) =>
                      setState(() => _imageBase64 = base64),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nameController,
                  label: 'Name*',
                  icon: Icons.restaurant,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
                        label: 'Price*',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Required';
                          if (double.tryParse(value!) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _categoryController,
                        label: 'Category*',
                        icon: Icons.category,
                        validator: (value) =>
                            value?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                BlocBuilder<MenuItemFormBloc, MenuItemFormState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is MenuItemFormSaving
                          ? null
                          : () => _saveMenuItem(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deeporange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is MenuItemFormSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.menuItem == null
                                  ? 'Create Item'
                                  : 'Update Item',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  void _saveMenuItem(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<MenuItemFormBloc>();
    bloc.add(SaveMenuItemEvent(
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      category: _categoryController.text,
      image: _imageBase64 ?? '',
    ));
  }
}
