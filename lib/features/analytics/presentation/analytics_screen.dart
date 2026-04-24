import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.marginMobile),
              height: 64,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryContainer,
                    child: const Icon(Icons.person_outline, size: 18),
                  ),
                  const SizedBox(width: AppDimensions.sm + 4),
                  const Text('Schedulr', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.notifications_outlined), color: AppColors.onSurfaceVariant, onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.marginMobile),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.lg),
                            decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.weeklyOverview, style: TextStyle(fontSize: 12, color: AppColors.onPrimaryContainer)),
                                const SizedBox(height: AppDimensions.xs),
                                Text('Tiến độ tuyệt vời, Alex!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onPrimaryContainer)),
                                const SizedBox(height: AppDimensions.sm),
                                Text('Bạn đã hoàn thành nhiều hơn 12% công việc so với trung bình 30 ngày qua.', style: TextStyle(fontSize: 14, color: AppColors.onPrimaryContainer)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.lg),
                            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.productivityScore, style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                const SizedBox(height: AppDimensions.sm),
                                Text.rich(TextSpan(text: '84', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.primary), children: [TextSpan(text: '/100', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))])),
                                const SizedBox(height: AppDimensions.sm),
                                ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusFull), child: LinearProgressIndicator(value: 0.84, backgroundColor: AppColors.surfaceContainer, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _buildBarChart(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildDistributionRow(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildHeatmap(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildSuggestions(),
                    const SizedBox(height: AppDimensions.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0: Navigator.of(context).pushReplacementNamed('/dashboard'); break;
            case 1: Navigator.of(context).pushReplacementNamed('/calendar'); break;
            case 2: Navigator.of(context).pushReplacementNamed('/tasks'); break;
            case 3: break;
            case 4: Navigator.of(context).pushReplacementNamed('/settings'); break;
          }
        },
      ),
    );
  }

  Widget _buildBarChart() {
    final days = ['T', 'H', 'B', 'N', 'S', 'B', 'C'];
    final values = [0.45, 0.70, 0.20, 0.85, 0.55, 0.30, 0.15];
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.tasksCompleted, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
              Container(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: 4), decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)), child: Text('Tuần này', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(height: 180 * values[index], decoration: BoxDecoration(color: AppColors.primary, borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMd)))),
                        const SizedBox(height: 8),
                        Text(days[index], style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.timeDistribution, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: AppDimensions.lg),
                _donutChart(),
                const SizedBox(height: AppDimensions.md),
                _legendItem('Công việc', 45, AppColors.primary),
                _legendItem('Sức khỏe', 25, AppColors.secondary),
                _legendItem('Cá nhân', 20, AppColors.tertiary),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.focusStats, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: AppDimensions.lg),
                _statCard('Làm việc sâu', '12.5 giờ', AppColors.primary),
                const SizedBox(height: AppDimensions.sm),
                _statCard('Thời gian tập trung TB', '45 phút', AppColors.secondary),
                const SizedBox(height: AppDimensions.sm),
                _statCard('Chuỗi ngày', '5 ngày', AppColors.tertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmap() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.activity30Days, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
          const SizedBox(height: AppDimensions.xs),
          Text('Trực quan hóa sự kiên trì trong việc hoàn thành công việc.', style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Text('Ít', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
              const SizedBox(width: AppDimensions.sm),
              ...[0.0, 0.2, 0.4, 0.6, 1.0].map((opacity) => Container(
                width: 12, height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: opacity), borderRadius: BorderRadius.circular(AppDimensions.radiusXs)),
              )),
              const SizedBox(width: AppDimensions.sm),
              Text('Nhiều', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.smartSuggestions, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
        const SizedBox(height: AppDimensions.sm),
        _suggestionCard(Icons.lightbulb, 'Đỉnh cao buổi sáng', 'Bạn có khả năng hoàn thành công việc cao hơn 40% trước 11:00 sáng.', AppColors.primary),
        const SizedBox(height: AppDimensions.sm),
        _suggestionCard(Icons.warning_amber, 'Công việc sức khỏe đang chậm lại', 'Bạn đã bỏ lỡ 3 block Tập thể dục tuần này.', AppColors.secondary),
      ],
    );
  }

  Widget _donutChart() {
    return SizedBox(
      width: 120, height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(120, 120), painter: _DonutPainter()),
          Text('100%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _legendItem(String label, int percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: AppDimensions.sm), Text(label, style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))]),
          Text('$percent%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.sm + 4),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _suggestionCard(IconData icon, String title, String desc, Color accent) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(AppDimensions.radiusXl), border: Border(left: BorderSide(color: accent, width: 4))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 24),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)), Text(desc, style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant))])),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 24;
    paint.color = AppColors.surfaceContainerHigh;
    canvas.drawCircle(center, radius, paint);
    _drawArc(canvas, center, radius, 0, 162, AppColors.primary);
    _drawArc(canvas, center, radius, 162, 90, AppColors.secondary);
    _drawArc(canvas, center, radius, 252, 72, AppColors.tertiary);
  }

  void _drawArc(Canvas canvas, Offset center, double radius, double start, double sweep, Color color) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 24..color = color;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start * 0.0174533, sweep * 0.0174533, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
