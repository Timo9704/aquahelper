import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  LoadingIndicatorState createState() => LoadingIndicatorState();
}

class LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<int>? _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    _dotsAnimation = StepTween(
      begin: 0,
      end: 3,
    ).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotsAnimation!,
      builder: (context, child) {
        String dots = '.' * _dotsAnimation!.value;
        return Text('KI-Assistent schreibt $dots', style: const TextStyle(fontSize: 16.0));
      },
    );
  }
}