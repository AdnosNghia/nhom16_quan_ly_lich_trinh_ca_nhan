import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

class AppToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppToggle({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value ? cs.primary : cs.outlineVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.all(2),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: value ? cs.onPrimary : cs.surface,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
