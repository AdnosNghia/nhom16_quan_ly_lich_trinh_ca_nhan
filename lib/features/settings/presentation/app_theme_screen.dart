import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class AppThemeScreen extends StatefulWidget {
  const AppThemeScreen({super.key});

  @override
  State<AppThemeScreen> createState() => _AppThemeScreenState();
}

class _AppThemeScreenState extends State<AppThemeScreen> {
  int _selectedTheme = 0;
  int _selectedColor = 0;

  final List<Color> _colors = [
    const Color(0xFF4D41DF),
    const Color(0xFFE91E63),
    const Color(0xFF009688),
    const Color(0xFFFF9800),
    const Color(0xFF607D8B),
    const Color(0xFF673AB7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Giao diện',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryContainer,
              child: const Icon(Icons.person, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chế độ hiển thị',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            const Text(
              'Chọn cách Schedulr hiển thị trên thiết bị của bạn.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                _themeCard(Icons.light_mode, 'Sáng', 0),
                const SizedBox(width: AppDimensions.md),
                _themeCard(Icons.dark_mode, 'Tối', 1),
                const SizedBox(width: AppDimensions.md),
                _themeCard(Icons.brightness_auto, 'Hệ thống', 2),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),
            const Text(
              'Màu chủ đạo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            const Text(
              'Cá nhân hóa ứng dụng với màu sắc yêu thích của bạn.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              ),
              child: Wrap(
                spacing: AppDimensions.md,
                runSpacing: AppDimensions.md,
                children: List.generate(
                  _colors.length,
                  (index) => GestureDetector(
                    onTap: () => setState(() => _selectedColor = index),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _colors[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == index
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.transparent,
                          width: _selectedColor == index ? 4 : 0,
                        ),
                      ),
                      child: _selectedColor == index
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                  ),
                ),
                child: const Text('Áp dụng thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeCard(IconData icon, String label, int index) {
    final isSelected = _selectedTheme == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTheme = index),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.surfaceContainer
                : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
