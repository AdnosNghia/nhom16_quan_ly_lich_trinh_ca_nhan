import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helpers/responsive_helper.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/providers/event_provider.dart';
import '../../shared/providers/task_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().ensureLoaded();
      context.read<TaskProvider>().ensureLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.marginMobile),
              height: AppDimensions.headerHeight(context),
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
              child: Consumer2<TaskProvider, EventProvider>(
                builder: (context, taskProvider, eventProvider, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.marginMobile),
                    child: Column(
                      children: [
                        _buildHeader(context, taskProvider),
                        const SizedBox(height: AppDimensions.lg),
                        _buildBarChart(context, taskProvider),
                        const SizedBox(height: AppDimensions.lg),
                        _buildDistributionRow(context, eventProvider),
                        const SizedBox(height: AppDimensions.lg),
                        _buildHeatmap(context),
                        const SizedBox(height: AppDimensions.lg),
                        _buildSuggestions(context, taskProvider),
                        const SizedBox(height: AppDimensions.xxl),
                      ],
                    ),
                  );
                },
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

  Widget _buildHeader(BuildContext context, TaskProvider taskProvider) {
    final total = taskProvider.tasks.length;
    final completed = taskProvider.tasks.where((t) => t.isCompleted).length;
    final productivity = total > 0 ? (completed / total * 100).toInt() : 0;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.weeklyOverview, style: const TextStyle(fontSize: 12, color: AppColors.onPrimaryContainer)),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Tiến độ tuyệt vời!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onPrimaryContainer),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Bạn đã hoàn thành $completed trên $total công việc.',
                  style: const TextStyle(fontSize: 14, color: AppColors.onPrimaryContainer),
                ),
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
                Text(AppStrings.productivityScore, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: AppDimensions.sm),
                Text.rich(
                  TextSpan(
                    text: '$productivity',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.primary),
                    children: const [TextSpan(text: '/100', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))],
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: total > 0 ? completed / total : 0,
                    backgroundColor: AppColors.surfaceContainer,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context, TaskProvider taskProvider) {
    final now = DateTime.now();
    final days = ['T', 'H', 'B', 'N', 'S', 'B', 'C'];
    final values = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      final dayTasks = taskProvider.tasks.where((t) {
        if (t.dueDate == null) return false;
        return t.dueDate!.day == date.day;
      }).length;
      return dayTasks > 0 ? dayTasks / 5.0 : 0.1;
    });

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(AppStrings.tasksCompleted, style: TextStyle(fontSize: ResponsiveHelper.scaleFont(context, 18).clamp(14, 22), fontWeight: FontWeight.w600, color: AppColors.onSurface)),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                child: Text('Tuần này', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          SizedBox(
            height: ResponsiveHelper.scaleHeight(context, 180).clamp(120, 280),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (ResponsiveHelper.scaleHeight(context, 180).clamp(120, 280)) * values[index].clamp(0.0, 1.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMd)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(days[index], style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
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

  Widget _buildDistributionRow(BuildContext context, EventProvider eventProvider) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    if (isSmall) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.timeDistribution, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: AppDimensions.lg),
                _donutChart(),
                const SizedBox(height: AppDimensions.md),
                _legendItem('Công việc', 45, AppColors.primary),
                _legendItem('Sức khỏe', 25, AppColors.secondary),
                _legendItem('Cá nhân', 20, AppColors.tertiary),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.focusStats, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: AppDimensions.lg),
                _statCard('Tổng sự kiện', '${eventProvider.events.length} sự kiện', AppColors.primary),
                const SizedBox(height: AppDimensions.sm),
                _statCard('Đã hoàn thành', '${eventProvider.events.where((e) => e.isCompleted).length}', AppColors.secondary),
                const SizedBox(height: AppDimensions.sm),
                _statCard('Còn lại', '${eventProvider.events.where((e) => !e.isCompleted).length}', AppColors.tertiary),
              ],
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.timeDistribution, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
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
                Text(AppStrings.focusStats, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: AppDimensions.lg),
                _statCard('Tổng sự kiện', '${eventProvider.events.length} sự kiện', AppColors.primary),
                const SizedBox(height: AppDimensions.sm),
                _statCard('Đã hoàn thành', '${eventProvider.events.where((e) => e.isCompleted).length}', AppColors.secondary),
                const SizedBox(height: AppDimensions.sm),
                _statCard('Còn lại', '${eventProvider.events.where((e) => !e.isCompleted).length}', AppColors.tertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmap(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.activity30Days, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
          const SizedBox(height: AppDimensions.xs),
          Text('Trực quan hóa sự kiên trì trong việc hoàn thành công việc.', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Text('Ít', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
              const SizedBox(width: AppDimensions.sm),
              ...[0.0, 0.2, 0.4, 0.6, 1.0].map((opacity) => Container(
                width: 12, height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: opacity),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
              )),
              const SizedBox(width: AppDimensions.sm),
              Text('Nhiều', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, TaskProvider taskProvider) {
    final total = taskProvider.tasks.length;
    final completed = taskProvider.tasks.where((t) => t.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.smartSuggestions, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
        const SizedBox(height: AppDimensions.sm),
        _suggestionCard(
          Icons.lightbulb,
          'Đỉnh cao buổi sáng',
          'Bạn có khả năng hoàn thành công việc cao hơn 40% trước 11:00 sáng.',
          AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.sm),
        _suggestionCard(
          Icons.warning_amber,
          'Tiến độ tổng thể',
          'Bạn đã hoàn thành $completed/$total công việc.',
          completed == total ? AppColors.primary : AppColors.secondary,
        ),
      ],
    );
  }

  Widget _donutChart() {
    final size = ResponsiveHelper.scaleWidth(context, 120).clamp(80.0, 160.0);
    return SizedBox(
      width: size, height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size.fromRadius(size / 2), painter: _DonutPainter()),
          Text('100%', style: TextStyle(fontSize: size * 0.14, fontWeight: FontWeight.w700, color: AppColors.primary)),
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
          Row(children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: AppDimensions.sm),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))
          ]),
          Text('$percent%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
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
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _suggestionCard(IconData icon, String title, String desc, Color accent) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border(left: BorderSide(color: accent, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 24),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              Text(desc, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
            ],
          )),
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
