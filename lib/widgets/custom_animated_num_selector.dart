import 'dart:async';
import 'package:animated_number_selector_flutter/widgets/custom_draggable_container.dart';
import 'package:animated_number_selector_flutter/widgets/custom_num_selector_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class CustomAnimatedNumSelector extends StatefulWidget {

  final double height;
  final double width;
  
  const CustomAnimatedNumSelector({
    super.key,
    required this.height,
    required this.width
  });

  @override
  State<CustomAnimatedNumSelector> createState() => _CustomAnimatedNumSelectorState();
}

class _CustomAnimatedNumSelectorState extends State<CustomAnimatedNumSelector> with SingleTickerProviderStateMixin{

  static const timerDelay = 1200;

  static const speedDelay = 1800;

  late final AnimationController _controller;
  late final Animation<double> _animator;

  Timer? _timer;

  double xPosNumContainer = 0;
  bool dragging = false;
  int counter = 0;
  int lastDirection = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: speedDelay));
    _animator = Tween<double>(begin: 1, end: 8)
      .animate(_controller)
      ..addListener((() => setState(() {})));
  }

  void incrementOrDecrement(final int value) => counter += value;

  void stopTimer(){
    if(_timer != null){
      _timer!.cancel();
    }
  }

  void onDragUpdate(final double widthLimits, final double deltaDX){
    final bool isInLimit = xPosNumContainer.abs() >= widthLimits - (widthLimits * 0.1);
    setState(() {
        dragging = true;
        xPosNumContainer = clampDouble(xPosNumContainer + deltaDX, -widthLimits, widthLimits);
    });
    if(isInLimit){
      if(isInLimit && _timer == null || !_timer!.isActive){
        final int direction = lastDirection = xPosNumContainer > 0 ? 1 : -1;
        if(_animator.status == AnimationStatus.dismissed){
          incrementOrDecrement(direction);
          _controller.forward();
        }

        final Duration delay = Duration(milliseconds: timerDelay ~/ _animator.value);
        _timer = Timer.periodic(delay, (Timer t){
          incrementOrDecrement(direction);
          _timer!.cancel();
        });
      }
    } else{
      _controller.reset();
      stopTimer();
    }
  }

  void onDragEnd(){
    _controller.reset();
    dragging = false;
    xPosNumContainer = 0;
    stopTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double widthLimits = widget.width / 3;

    final double leftArrowOpacity = 1 - clampDouble((xPosNumContainer / -widthLimits) * 2, 0, 1);
    final double rightArrowOpacity = 1 - clampDouble((xPosNumContainer / widthLimits) * 2, 0, 1);

    final int animatedContainerDuration = dragging ? 150 : 350;
    final int switcherDuration = timerDelay ~/ _animator.value;
    final double switcherXDirection = lastDirection == 1 ? widget.width * 0.005 : -widget.width * 0.005;
    final Curve animatedContainerCurve = dragging ? Curves.ease : Curves.easeInOutBack;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Row(
        children: [
          CustomNumSelectorIcon(
            icon: Icons.arrow_back_ios_new_rounded, 
            opacity: leftArrowOpacity
          ),
          Expanded(
            child: CustomDraggableContainer(
              onHorizontalDragUpdateCallback: (delta) => onDragUpdate(widthLimits, delta), 
              onHorizontalDragEndCallback: onDragEnd, 
              curve: animatedContainerCurve, 
              animatedContainerDuration: animatedContainerDuration, 
              switcherDuration: switcherDuration, 
              xPos: xPosNumContainer, 
              switcherXPos: switcherXDirection, 
              text: counter.toString()
            )
          ),
          CustomNumSelectorIcon(
            icon: Icons.arrow_forward_ios_rounded, 
            opacity: rightArrowOpacity
          ),
        ],
      ),
    );
  }
}