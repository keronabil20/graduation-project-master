// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/menu_item/menu_item_detaild_screen.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/home/restaurant_home_screen.dart';

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    super.key,
    required this.context,
    required this.widget,
    required this.item,
  });

  final BuildContext context;
  final RestaurantHomePage widget;
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MenuItemDetailsScreen(
              item: item,
              restaurantId: widget.restaurantId ?? '',
            ),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.08),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'menu-item-${item.id ?? UniqueKey().toString()}',
              child: AspectRatio(
                aspectRatio: 1,
                child: _MenuItemImage(item: item, colorScheme: colorScheme),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 14.sp, // Increased from default
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.description.isEmpty
                        ? S.of(context).noDescription
                        : item.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        item.price.toStringAsFixed(2),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 4.w), // Increased spacing
                      Text(
                        S.of(context).currency,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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

class _MenuItemImage extends StatelessWidget {
  final MenuItem item;
  final ColorScheme colorScheme;
  const _MenuItemImage({required this.item, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final isBase64 = item.image.isNotEmpty && !item.image.startsWith('http');
    if (isBase64) {
      try {
        return Image.memory(
          base64Decode(item.image),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (e) {
        return Container(
          color: colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.fastfood,
            size: 30,
            color: colorScheme.onSurfaceVariant,
          ),
        );
      }
    } else {
      return CachedNetworkImage(
        imageUrl: item.image,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.fastfood,
            size: 30,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
  }
}
