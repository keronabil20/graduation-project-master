// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/presentation/owner/owner_dashboard/cubit/dashboard_cubit.dart';

class ManagementTab extends StatefulWidget {
  final DashboardLoaded state;

  const ManagementTab({super.key, required this.state});

  @override
  State<ManagementTab> createState() => _ManagementTabState();
}

class _ManagementTabState extends State<ManagementTab> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.state.restaurantData['name']);
    _addressController =
        TextEditingController(text: widget.state.restaurantData['address']);
    _phoneController =
        TextEditingController(text: widget.state.restaurantData['phone']);
    _descriptionController =
        TextEditingController(text: widget.state.restaurantData['description']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildEditableSection(
            title: 'Restaurant Information',
            icon: Icons.restaurant,
            children: [
              _buildEditableField(
                label: 'Restaurant Name',
                controller: _nameController,
                icon: Icons.badge,
                onSaved: (value) {
                  context.read<DashboardCubit>().updateRestaurantInfo({
                    'name': value,
                  });
                },
              ),
              _buildEditableField(
                label: 'Address',
                controller: _addressController,
                icon: Icons.location_on,
                onSaved: (value) {
                  context.read<DashboardCubit>().updateRestaurantInfo({
                    'address': value,
                  });
                },
              ),
              _buildEditableField(
                label: 'Phone Number',
                controller: _phoneController,
                icon: Icons.phone,
                inputType: TextInputType.phone,
                onSaved: (value) {
                  context.read<DashboardCubit>().updateRestaurantInfo({
                    'phone': value,
                  });
                },
              ),
              _buildEditableField(
                label: 'Description',
                controller: _descriptionController,
                icon: Icons.description,
                multiline: true,
                onSaved: (value) {
                  context.read<DashboardCubit>().updateRestaurantInfo({
                    'description': value,
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildEditableSection(
            title: 'Business Hours',
            icon: Icons.access_time,
            children: [
              // Add business hours editor
              const Text('Business hours editor will be implemented here'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20.w),
                SizedBox(width: 8.w),
                Text(title, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Function(String) onSaved,
    bool multiline = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: Colors.grey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12.sp)),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: controller,
                  maxLines: multiline ? 3 : 1,
                  keyboardType: inputType,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => onSaved(controller.text),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
