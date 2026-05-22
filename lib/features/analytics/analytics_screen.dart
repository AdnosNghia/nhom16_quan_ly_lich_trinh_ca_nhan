import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helpers/responsive_helper.dart';
import '../../shared/providers/event_provider.dart';
import '../../shared/providers/category_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../shared/providers/auth_provider.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.marginMobile),
                    child: Column(
                      children: [
                        _buildHeader(context, eventProvider),
                        const SizedBox(height: AppDimensions.lg),
                        _buildBarChart(context, eventProvider),
                        const SizedBox(height: AppDimensions.lg),
                        _buildDistributionRow(context, eventProvider),
                        const SizedBox(height: AppDimensions.lg),
                        _buildHeatmap(context, eventProvider),
                        const SizedBox(height: AppDimensions.lg),
                        _buildSuggestions(context, eventProvider),
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
    );
  }

  /// Helper: get events for the current week (Mon-Sun)
  List<dynamic> _getWeekEvents(EventProvider eventProvider) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final weekStart = DateTime(now.year, now.month, now.day - (weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    return eventProvider.events.where((e) =>
      e.startTime.isAfter(weekStart) && e.startTime.isBefore(weekEnd)
    ).toList();
  }

  Widget _buildHeader(BuildContext context, EventProvider eventProvider) {
    final weekEvents = _getWeekEvents(eventProvider);
    final total = weekEvents.length;
    final completed = weekEvents.where((e) => e.isCompleted).length;
    final productivity = total > 0 ? (completed / total * 100).toInt() : 0;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.weeklyOverview, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimaryContainer)),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  productivity >= 70 ? 'Tiến độ tuyệt vời!' : productivity >= 40 ? 'Đang tiến triển!' : 'Hãy cố gắng hơn!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Bạn đã hoàn thành $completed trên $total công việc.',
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.productivityScore, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: AppDimensions.sm),
                Text.rich(
                  TextSpan(
                    text: '$productivity',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.primary),
                    children: const [TextSpan(text: '/100', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))],
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: total > 0 ? completed / total : 0,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context, EventProvider eventProvider) {
    final now = DateTime.now();
    final dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    // Compute actual completed event counts for the past 7 days
    // and generate correct day labels
    final days = <String>[];
    final counts = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      days.add(dayLabels[date.weekday - 1]); // weekday: 1=Mon→T2, 7=Sun→CN
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      return eventProvider.events.where((e) =>
        e.isCompleted &&
        e.startTime.isAfter(startOfDay) &&
        e.startTime.isBefore(endOfDay)
      ).length;
    });
    final maxCount = counts.reduce((a, b) => a > b ? a : b);
    final values = counts.map((c) => maxCount > 0 ? c / maxCount : 0.1).toList();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(AppStrings.tasksCompleted, style: TextStyle(fontSize: ResponsiveHelper.scaleFont(context, 18).clamp(14, 22), fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: 4),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                child: Text('7 ngày qua', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
                        Text('${counts[index]}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: values[index].clamp(0.05, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMd)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(days[index], style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
    final catProvider = context.read<CategoryProvider>();

    // Build dynamic category distribution from actual events
    final Map<String, int> catCounts = {};
    for (final e in eventProvider.events) {
      if (e.categoryId.isNotEmpty) {
        catCounts[e.categoryId] = (catCounts[e.categoryId] ?? 0) + 1;
      }
    }
    final totalEvents = eventProvider.events.length;

    // Build legend data sorted by count descending
    final entries = catCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final legendData = entries.map((entry) {
      final catName = catProvider.getNameForCategory(entry.key);
      final catColor = catProvider.getColorForCategory(entry.key);
      final percent = totalEvents > 0 ? (entry.value / totalEvents * 100).round() : 0;
      return (name: catName.isEmpty ? 'Khác' : catName, percent: percent, color: catColor);
    }).toList();

    // Build donut segments
    final donutSegments = entries.map((entry) {
      final catColor = catProvider.getColorForCategory(entry.key);
      final fraction = totalEvents > 0 ? entry.value / totalEvents : 0.0;
      return (fraction: fraction, color: catColor);
    }).toList();

    final isSmall = MediaQuery.of(context).size.width < 400;
    final donutWidget = Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.timeDistribution, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: AppDimensions.lg),
          _donutChart(donutSegments),
          const SizedBox(height: AppDimensions.md),
          ...legendData.map((item) => _legendItem(item.name, item.percent, item.color)),
        ],
      ),
    );

    final statsWidget = Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.focusStats, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: AppDimensions.lg),
          _statCard('Tổng sự kiện', '${eventProvider.events.length} sự kiện', Theme.of(context).colorScheme.primary),
          const SizedBox(height: AppDimensions.sm),
          _statCard('Đã hoàn thành', '${eventProvider.events.where((e) => e.isCompleted).length}', Theme.of(context).colorScheme.secondary),
          const SizedBox(height: AppDimensions.sm),
          _statCard('Còn lại', '${eventProvider.events.where((e) => !e.isCompleted).length}', Theme.of(context).colorScheme.tertiary),
        ],
      ),
    );

    if (isSmall) {
      return Column(
        children: [
          donutWidget,
          const SizedBox(height: AppDimensions.md),
          statsWidget,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: donutWidget),
        const SizedBox(width: AppDimensions.md),
        Expanded(child: statsWidget),
      ],
    );
  }

  Widget _buildHeatmap(BuildContext context, EventProvider eventProvider) {
    // Compute completed events per day for the last 30 days
    final now = DateTime.now();
    final heatData = List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      return eventProvider.events.where((e) =>
        e.isCompleted &&
        e.startTime.isAfter(startOfDay) &&
        e.startTime.isBefore(endOfDay)
      ).length;
    });
    final maxHeat = heatData.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.activity30Days, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: AppDimensions.xs),
          Text('Trực quan hóa sự kiên trì trong việc hoàn thành công việc.', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(30, (index) {
              final opacity = maxHeat > 0 ? (heatData[index] / maxHeat).clamp(0.0, 1.0) : 0.0;
              return Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                  color: heatData[index] == 0
                      ? Theme.of(context).colorScheme.surfaceContainer
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2 + opacity * 0.8),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
              );
            }),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              Text('Ít', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(width: AppDimensions.sm),
              ...[0.0, 0.2, 0.4, 0.6, 1.0].map((o) => Container(
                width: 12, height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: o),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
              )),
              const SizedBox(width: AppDimensions.sm),
              Text('Nhiều', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, EventProvider eventProvider) {
    final weekEvents = _getWeekEvents(eventProvider);
    final total = weekEvents.length;
    final completed = weekEvents.where((e) => e.isCompleted).length;

    // Compute morning productivity
    final morningCompleted = eventProvider.events.where((e) =>
      e.isCompleted && e.startTime.hour < 12
    ).length;
    final afternoonCompleted = eventProvider.events.where((e) =>
      e.isCompleted && e.startTime.hour >= 12
    ).length;
    final morningAdvantage = (morningCompleted + afternoonCompleted) > 0
        ? ((morningCompleted / (morningCompleted + afternoonCompleted)) * 100).round()
        : 50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.smartSuggestions, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: AppDimensions.sm),
        _suggestionCard(
          Icons.lightbulb,
          morningAdvantage >= 50 ? 'Đỉnh cao buổi sáng' : 'Hiệu suất buổi chiều',
          morningAdvantage >= 50
              ? 'Bạn hoàn thành $morningAdvantage% công việc trước 12:00 trưa.'
              : 'Bạn hoàn thành ${100 - morningAdvantage}% công việc sau 12:00 trưa.',
          Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: AppDimensions.sm),
        _suggestionCard(
          Icons.warning_amber,
          'Tiến độ tổng thể',
          'Bạn đã hoàn thành $completed/$total công việc tuần này.',
          completed == total && total > 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _donutChart(List<({double fraction, Color color})> segments) {
    final size = ResponsiveHelper.scaleWidth(context, 120).clamp(80.0, 160.0);
    final totalPercent = segments.fold<double>(0, (sum, s) => sum + s.fraction);
    return SizedBox(
      width: size, height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size.fromRadius(size / 2), painter: _DynamicDonutPainter(segments: segments, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh)),
          Text(
            '${(totalPercent * 100).round()}%',
            style: TextStyle(fontSize: size * 0.14, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
          ),
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
            Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant))
          ]),
          Text('$percent%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.sm + 4),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _suggestionCard(IconData icon, String title, String desc, Color accent) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
              Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
              Text(desc, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          )),
        ],
      ),
    );
  }
}

/// Dynamic donut chart painter that draws segments based on actual data.
class _DynamicDonutPainter extends CustomPainter {
  final List<({double fraction, Color color})> segments;
  final Color backgroundColor;
  _DynamicDonutPainter({required this.segments, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final strokeWidth = 24.0;

    // Background ring
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = backgroundColor;
    canvas.drawCircle(center, radius, bgPaint);

    if (segments.isEmpty) return;

    double startAngle = -pi / 2; // Start from top
    for (final seg in segments) {
      final sweepAngle = seg.fraction * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = seg.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DynamicDonutPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}
