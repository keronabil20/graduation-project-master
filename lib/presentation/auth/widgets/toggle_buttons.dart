// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/utils/constants/constants.dart';

class SlidingToggleButtons extends StatefulWidget {
  final ToggleButtonDelegate delegate;
  final ValueChanged<int> onToggle;

  const SlidingToggleButtons({
    super.key,
    required this.delegate,
    required this.onToggle,
  });

  @override
  State<SlidingToggleButtons> createState() => _SlidingToggleButtonsState();
}

class _SlidingToggleButtonsState extends State<SlidingToggleButtons> {
  int _selectedIndex = 0;
  double _sliderPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final options = widget.delegate.getOptions(context);
    final width = MediaQuery.of(context).size.width * 0.75;
    final buttonWidth = width / options.length;

    // Check if the current locale is RTL (e.g., Arabic)
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sliderPosition += details.delta.dx;
          _sliderPosition = _sliderPosition.clamp(0.0, width - buttonWidth);
        });
      },
      onHorizontalDragEnd: (details) {
        final newIndex = (_sliderPosition / buttonWidth).round();
        setState(() {
          _selectedIndex = newIndex;
          _sliderPosition = isRTL
              ? width - (buttonWidth * (_selectedIndex + 1))
              : newIndex * buttonWidth;
        });
        widget.onToggle(_selectedIndex);
      },
      child: Container(
        width: width,
        height: 40.h,
        decoration: BoxDecoration(
          color: widget.delegate.inactiveColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Stack(
          children: [
            // Sliding background
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isRTL
                  ? width - (buttonWidth * (_selectedIndex + 1))
                  : _sliderPosition,
              child: Container(
                width: buttonWidth,
                height: 40.h,
                decoration: BoxDecoration(
                  color: widget.delegate.activeColor,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: widget.delegate.activeColor.withOpacity(0.3),
                      blurRadius: 8.w,
                      spreadRadius: 1.w,
                      offset: Offset(0, 2.h),
                    )
                  ],
                ),
              ),
            ),
            // Buttons
            Row(
              children: List.generate(options.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _sliderPosition = isRTL
                            ? width - (buttonWidth * (_selectedIndex + 1))
                            : index * buttonWidth;
                      });
                      widget.onToggle(index);
                    },
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: _selectedIndex == index
                                  ? widget.delegate.sliderColor
                                  : widget.delegate.activeColor,
                              fontWeight: FontWeight.w600,
                            ),
                        child: Text(options[index]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class ToggleButtonDelegate {
  List<String> getOptions(BuildContext context);
  Color get activeColor;
  Color get inactiveColor;
  Color get sliderColor;
}

class DefaultToggleButtonDelegate implements ToggleButtonDelegate {
  @override
  List<String> getOptions(BuildContext context) {
    return [
      S.of(context).login,
      S.of(context).signUp,
    ];
  }

  @override
  Color get activeColor => Colors.deepOrange;

  @override
  Color get inactiveColor => white;

  @override
  Color get sliderColor => Colors.white;
}
