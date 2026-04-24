import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showNotification;

  const AppTopBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.marginMobile,
      ),
      height: 64,
      child: Row(
        children: [
          if (leading != null) leading!,
          if (leading != null) const SizedBox(width: AppDimensions.sm),
          if (leading == null && showNotification)
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceContainer,
            ),
          if (leading == null && showNotification)
            const SizedBox(width: AppDimensions.sm + 4),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          if (showNotification)
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: AppColors.primary,
              onPressed: () {},
            ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
