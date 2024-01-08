import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    required this.animationController,
    required this.animation,
    required this.callback,
    required this.itemRow,
    super.key,
  });

  final VoidCallback callback;
  final AnimationController animationController;
  final Animation<double> animation;
  final Widget itemRow;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: GestureDetector(
                onTap: () => callback(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: itemRow,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
