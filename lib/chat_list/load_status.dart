import 'package:flutter/material.dart';

enum LoadStatus { loading, loaded, none }

class LoadingBox extends StatefulWidget {
  final LoadStatus status;
  const LoadingBox({super.key, required this.status});

  @override
  LoadingBoxState createState() => LoadingBoxState();
}

class LoadingBoxState extends State<LoadingBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  Color? _color = Colors.grey;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(LoadingBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == LoadStatus.loading) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == LoadStatus.loaded) {
      _color = Colors.green;
    } else if (widget.status == LoadStatus.none) {
      _color = Colors.grey;
    }
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            color: widget.status == LoadStatus.loading
                ? _colorAnimation.value
                : _color,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
