// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';

class UserTypeSelector extends StatelessWidget {
  final bool isRestaurantOwner;
  final void Function(bool isRestaurantOwner, bool showRestaurantFields)
      onTypeChanged;

  const UserTypeSelector({
    super.key,
    required this.isRestaurantOwner,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          _buildTypeOption(
            context,
            label: S.of(context).regularUser,
            selected: !isRestaurantOwner,
            icon: Icons.person_outline,
            onTap: () => onTypeChanged(false, false),
          ),
          Container(
            width: 1.w,
            height: 24.h,
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          _buildTypeOption(
            context,
            label: S.of(context).restaurantOwner,
            selected: isRestaurantOwner,
            icon: Icons.restaurant_outlined,
            onTap: () => onTypeChanged(true, true),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(
    BuildContext context, {
    required String label,
    required bool selected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.horizontal(
          left: label == S.of(context).regularUser
              ? Radius.circular(12.r)
              : Radius.zero,
          right: label == S.of(context).restaurantOwner
              ? Radius.circular(12.r)
              : Radius.zero,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: label == S.of(context).regularUser
                  ? Radius.circular(12.r)
                  : Radius.zero,
              right: label == S.of(context).restaurantOwner
                  ? Radius.circular(12.r)
                  : Radius.zero,
            ),
            border: selected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.w,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.r,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
