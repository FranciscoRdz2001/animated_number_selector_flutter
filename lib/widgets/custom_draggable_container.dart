import 'package:flutter/material.dart';


class CustomDraggableContainer extends StatelessWidget {

  final void Function(double delta) onHorizontalDragUpdateCallback;
  final VoidCallback onHorizontalDragEndCallback;

  final Curve curve;
  final int animatedContainerDuration;
  final int switcherDuration;
  final double xPos;
  final double switcherXPos;
  final String text;

  const CustomDraggableContainer({
    super.key,
    required this.onHorizontalDragUpdateCallback,
    required this.onHorizontalDragEndCallback,
    required this.curve,
    required this.animatedContainerDuration,
    required this.switcherDuration,
    required this.xPos,
    required this.switcherXPos,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) => onHorizontalDragUpdateCallback(details.delta.dx),
      onHorizontalDragEnd: (details) => onHorizontalDragEndCallback(),
      child: AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: Duration(milliseconds: animatedContainerDuration),
        curve: curve,
        transform: Matrix4.identity()..translate(xPos),
        decoration: BoxDecoration(
          color: const Color(0xff854df9),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: switcherDuration),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(begin: Offset(switcherXPos, 0), end: const Offset(0, 0)).animate(animation),
                  child: child,
                );
              },
              child: Center(
                key: Key(text),
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Color(0xffede4f2),
                          fontSize: 30,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}