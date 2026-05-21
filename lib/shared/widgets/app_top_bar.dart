import 'package:flutter/material.dart';
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
    final cs = Theme.of(context).colorScheme;
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
              backgroundColor: cs.surfaceContainer,
            ),
          if (leading == null && showNotification)
            const SizedBox(width: AppDimensions.sm + 4),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ),
          if (showNotification)
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: cs.primary,
              onPressed: () {},
            ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
