import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helpers/responsive_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = [
    _OnboardingItem(
      icon: Icons.auto_awesome,
      title: 'Lập lịch thông minh',
      desc:
          'Dễ dàng quản lý thời gian với các gợi ý từ AI. Tổ chức cuộc sống với lịch trình linh hoạt theo nhu cầu của bạn.',
    ),
    _OnboardingItem(
      icon: Icons.notifications_active,
      title: 'Nhắc nhở thông minh',
      desc:
          'Không bao giờ bỏ lỡ sự kiện quan trọng với hệ thống nhắc nhở thông minh, tùy chỉnh theo lịch trình của bạn.',
    ),
    _OnboardingItem(
      icon: Icons.analytics,
      title: 'Phân tích hiệu suất',
      desc:
          'Theo dõi tiến độ công việc và thói quen hàng ngày với biểu đồ trực quan và báo cáo chi tiết.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
                vertical: AppDimensions.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed('/login');
                    },
                    child: Text(
                      AppStrings.skip,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.gutter,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final size = constraints.maxWidth * 0.75;
                            return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                              ),
                              child: Icon(
                                item.icon,
                                size: size * 0.4,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppDimensions.xl),
                        Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.scaleFont(context, 24).clamp(18, 32),
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          item.desc,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.scaleFont(context, 14).clamp(12, 18),
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.gutter,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _items.length - 1) {
                      Navigator.of(context)
                          .pushReplacementNamed('/login');
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusXl),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _items.length - 1
                            ? 'Bắt đầu'
                            : AppStrings.next,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_currentPage < _items.length - 1)
                        const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              'Bước ${_currentPage + 1} trên ${_items.length}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String desc;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.desc,
  });
}
