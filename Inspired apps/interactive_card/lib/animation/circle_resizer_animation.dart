import 'package:flutter/material.dart';

class CircleResizerAnimation extends StatefulWidget {
  const CircleResizerAnimation({Key? key, required this.destination})
      : super(key: key);
  final Widget destination;
  @override
  State<CircleResizerAnimation> createState() => _CircleResizerAnimationState();
}

class _CircleResizerAnimationState extends State<CircleResizerAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  double? value;
  @override
  void initState() {
    super.initState();

    _startAnimation();
  }

  _initController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  _startAnimation() {
    _initController();
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.decelerate,
    );
    _animationController!.forward();
    _animationController!.addListener(() {
      setState(() {
        value = _animationController!.value;
      });
    });
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => widget.destination,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.48;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircleAvatar(
            radius: value == null ? width : width * value!,
            backgroundColor: const Color(0xFF6540D0),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
  }
}
