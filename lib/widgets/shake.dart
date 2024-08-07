import 'package:flutter/material.dart';

class ShakingWidget extends StatefulWidget {

  final Widget child;
  const ShakingWidget({super.key, required this.child});

  @override
  State<ShakingWidget> createState() => _ShakingWidgetState();
}

class _ShakingWidgetState extends State<ShakingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      lowerBound: -3.0,
      upperBound: 3.0,
    )..repeat(reverse: true); // Menetapkan animasi berulang

    // Menetapkan tween animasi
    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}