import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../providers/auth_provider.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Chào buổi sáng,';
    if (hour >= 12 && hour < 18) {
      greeting = 'Chào buổi chiều,';
    } else if (hour >= 18) {
      greeting = 'Chào buổi tối,';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.marginMobile,
        vertical: AppDimensions.sm,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            child: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: AppDimensions.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  context.watch<AuthProvider>().user?.name ?? 'Alex',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            onPressed: () {
              Navigator.of(context).pushNamed('/notification_history');
            },
          ),
        ],
      ),
    );
  }
}
