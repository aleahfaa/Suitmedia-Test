import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ShimmerUserItem extends StatefulWidget {
  const ShimmerUserItem({super.key});
  @override
  State<ShimmerUserItem> createState() => _ShimmerUserItemState();
}

class _ShimmerUserItemState extends State<ShimmerUserItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _color = ColorTween(
      begin: AppColors.shimmerBase,
      end: AppColors.shimmerHighlight,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (context, _) {
        final c = _color.value ?? AppColors.shimmerBase;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              _box(width: 49, height: 49, radius: 24.5, color: c),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: double.infinity, height: 14, color: c),
                    const SizedBox(height: 8),
                    _box(width: 140, height: 10, color: c),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _box({
    required double width,
    required double height,
    required Color color,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
