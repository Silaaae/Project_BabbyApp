import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/baby_provider.dart';
import '../../models/development_model.dart';
import '../../services/api_service.dart';
import '../../config/theme.dart';
import 'dart:math' as math;

class DevelopmentScreen extends StatefulWidget {
  const DevelopmentScreen({Key? key}) : super(key: key);

  @override
  State<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends State<DevelopmentScreen>
    with SingleTickerProviderStateMixin {
  List<Development> developments = [];
  bool isLoading = true;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _loadDevelopments();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  List<dynamic> _extractList(dynamic response) {
    if (response is List) return response;

    if (response is Map) {
      // support common API shapes
      final dynamic data = response['data'];
      if (data is List) return data;

      final dynamic items = response['items'];
      if (items is List) return items;

      final dynamic devs = response['developments'];
      if (devs is List) return devs;
    }

    return const <dynamic>[];
  }

  Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return <String, dynamic>{};
  }

  Future<void> _loadDevelopments() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      final response = await ApiService.get('developments');
      final List<dynamic> data = _extractList(response);

      final List<Development> parsed = data
          .map((e) => Development.fromJson(_asMap(e)))
          .toList();

      if (!mounted) return;

      setState(() {
        developments = parsed;
      });

      _progressController.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        developments = [];
      });
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final baby = context.watch<BabyProvider>().selectedBaby;
    final babyAge = baby?.ageInMonths ?? 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667EEA).withOpacity(0.1),
              const Color(0xFF764BA2).withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildGradientHeader(context, baby, babyAge),
              if (!isLoading && baby != null) _buildProgressTimeline(babyAge),
              Expanded(
                child: isLoading
                    ? _buildLoadingState()
                    : _buildDevelopmentTimeline(babyAge),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientHeader(BuildContext context, dynamic baby, int babyAge) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('🎯',
                                  style: TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Développement',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (baby != null)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${baby.name} • ${baby.ageInMonths} mois',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTimeline(int babyAge) {
    if (developments.isEmpty) return const SizedBox.shrink();

    final totalMonths = developments.last.month;
    final progress = totalMonths == 0 ? 0.0 : (babyAge / totalMonths);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progression',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$babyAge / $totalMonths mois',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: (progress.clamp(0.0, 1.0)) * _progressController.value,
                  minHeight: 12,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMilestoneIndicator('Passés', babyAge, Colors.white),
              _buildMilestoneIndicator(
                'À venir',
                (totalMonths - babyAge).clamp(0, 9999),
                Colors.white.withOpacity(0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneIndicator(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: $count',
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDevelopmentTimeline(int babyAge) {
    if (developments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: developments.length,
      itemBuilder: (context, index) {
        final dev = developments[index];
        final isCurrentMonth = dev.month == babyAge;
        final isPast = dev.month < babyAge;
        final isFuture = dev.month > babyAge;

        return _buildTimelineItem(
          dev,
          isCurrentMonth,
          isPast,
          isFuture,
          index,
        );
      },
    );
  }

  Widget _buildTimelineItem(
      Development dev,
      bool isCurrent,
      bool isPast,
      bool isFuture,
      int index,
      ) {
    final colors = _getGradientColors(dev.month);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 80)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient:
                          (isCurrent || isPast) ? LinearGradient(colors: colors) : null,
                          color: isFuture ? Colors.grey[300] : null,
                          shape: BoxShape.circle,
                          boxShadow: isCurrent
                              ? [
                            BoxShadow(
                              color: colors[0].withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${dev.month}',
                            style: TextStyle(
                              fontSize: isCurrent ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: (isCurrent || isPast)
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      if (index < developments.length - 1)
                        Container(
                          width: 3,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: isPast
                                ? LinearGradient(
                              colors: colors,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                                : null,
                            color: isPast ? null : Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showDevelopmentDetails(dev, colors),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: isCurrent
                              ? LinearGradient(
                            colors: [
                              colors[0].withOpacity(0.1),
                              colors[1].withOpacity(0.05),
                            ],
                          )
                              : null,
                          color: isCurrent ? null : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: isCurrent
                              ? Border.all(color: colors[0], width: 2.5)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: isCurrent
                                  ? colors[0].withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: isCurrent ? 20 : 10,
                              offset: Offset(0, isCurrent ? 8 : 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dev.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isCurrent
                                          ? colors[0]
                                          : const Color(0xFF2D3436),
                                    ),
                                  ),
                                ),
                                if (isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: colors),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors[0].withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Actuel',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else if (isPast)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: colors),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildSkillPreview('🏃', dev.motorSkills, colors[0]),
                            const SizedBox(height: 8),
                            _buildSkillPreview('🧠', dev.cognitiveSkills, colors[1]),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.arrow_forward, size: 16, color: colors[0]),
                                const SizedBox(width: 8),
                                Text(
                                  'Voir détails',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colors[0],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillPreview(String emoji, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.length > 80 ? '${text.substring(0, 80)}...' : text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showDevelopmentDetails(Development dev, List<Color> colors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: colors),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors[0].withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${dev.month}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          dev.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildDetailSection('🏃 Motricité', dev.motorSkills, colors[0]),
                      const SizedBox(height: 20),
                      _buildDetailSection('🧠 Cognitif', dev.cognitiveSkills, colors[1]),
                      const SizedBox(height: 20),
                      _buildDetailSection('👥 Social', dev.socialSkills, const Color(0xFF4CAF50)),
                      const SizedBox(height: 20),
                      _buildDetailSection('💬 Langage', dev.languageSkills, const Color(0xFFFF9800)),
                      if (dev.tips != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFF59D).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('💡', style: TextStyle(fontSize: 24)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Conseil pratique',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF57F17),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      dev.tips!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFF57F17),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2D3436),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(int month) {
    final colorSets = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFFA8BFF), const Color(0xFF2BD2FF)],
      [const Color(0xFFF093FB), const Color(0xFFF5576C)],
      [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      [const Color(0xFFFA709A), const Color(0xFFFEE140)],
    ];
    return colorSets[month % colorSets.length];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🎯', style: TextStyle(fontSize: 60)),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucune donnée',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les jalons de développement apparaîtront ici',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Chargement...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
