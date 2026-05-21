import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../shared/providers/theme_provider.dart';

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
  void initState() {
    super.initState();
    final themeProvider = context.read<ThemeProvider>();
    _selectedTheme = themeProvider.themeMode == ThemeMode.dark ? 1 : themeProvider.themeMode == ThemeMode.system ? 2 : 0;
    _selectedColor = _colors.indexWhere((c) => c.toARGB32() == themeProvider.colorSeed);
    if (_selectedColor == -1) _selectedColor = 0;
  }

  void _applyChanges() {
    final themeProvider = context.read<ThemeProvider>();
    switch (_selectedTheme) {
      case 0:
        themeProvider.setThemeMode(ThemeMode.light);
        break;
      case 1:
        themeProvider.setThemeMode(ThemeMode.dark);
        break;
      case 2:
        themeProvider.setThemeMode(ThemeMode.system);
        break;
    }
    themeProvider.setColorSeed(_colors[_selectedColor].toARGB32());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã áp dụng thay đổi giao diện!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Giao diện',
          style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.person, size: 20, color: cs.onPrimaryContainer),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chế độ hiển thị', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: AppDimensions.xs),
            Text('Chọn cách Schedulr hiển thị trên thiết bị của bạn.', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                _themeCard(cs, Icons.light_mode, 'Sáng', 0),
                const SizedBox(width: AppDimensions.md),
                _themeCard(cs, Icons.dark_mode, 'Tối', 1),
                const SizedBox(width: AppDimensions.md),
                _themeCard(cs, Icons.brightness_auto, 'Hệ thống', 2),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),
            Text('Màu chủ đạo', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: AppDimensions.xs),
            Text('Cá nhân hóa ứng dụng với màu sắc yêu thích của bạn.', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
            const SizedBox(height: AppDimensions.md),
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
              child: Wrap(
                spacing: AppDimensions.md,
                runSpacing: AppDimensions.md,
                children: List.generate(
                  _colors.length,
                  (index) => GestureDetector(
                    onTap: () => setState(() => _selectedColor = index),
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: _colors[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == index ? cs.primary.withValues(alpha: 0.3) : Colors.transparent,
                          width: _selectedColor == index ? 4 : 0,
                        ),
                      ),
                      child: _selectedColor == index ? const Icon(Icons.check, color: Colors.white) : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
                ),
                child: const Text('Áp dụng thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeCard(ColorScheme cs, IconData icon, String label, int index) {
    final isSelected = _selectedTheme == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTheme = index),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: isSelected ? cs.surfaceContainerHigh : cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: isSelected ? cs.primary : Colors.transparent, width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: isSelected ? cs.primary : cs.onSurfaceVariant),
              const SizedBox(height: AppDimensions.sm),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, color: isSelected ? cs.primary : cs.onSurfaceVariant)),
              if (isSelected) Padding(padding: const EdgeInsets.only(top: 4), child: Icon(Icons.check_circle, color: cs.primary, size: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
