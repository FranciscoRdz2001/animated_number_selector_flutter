import 'dart:async';

import 'package:animated_number_selector_flutter/utils/responsive_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {


  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  static const timerDelay = 1200;

  static const speedDelay = 1800;

  late final AnimationController _controller;
  late final Animation<double> _animator;

  final GlobalKey containerKey = GlobalKey();

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
      ..addListener(animationListener)
      ..addStatusListener(animationStatusListener);
  }

  void animationListener(){
    setState(() {
    });
  }

  void animationStatusListener(AnimationStatus status) {
  }

  void incrementOrDecrement(final int value) => counter += value;

  void stopTimer(){
    if(_timer != null){
      _timer!.cancel();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final ResponsiveUtil resp = ResponsiveUtil.of(context);

    final double hPadding = resp.wp(2.5);
    final double vPadding = resp.hp(2.5);

    final double containerHeight = resp.hp(6);
    final double containerWidth = resp.wp(40);

    final double widthLimits = containerWidth / 3;

    final double leftArrowOpacity = 1 - clampDouble((xPosNumContainer / -widthLimits) * 2, 0, 1);
    final double rightArrowOpacity = 1 - clampDouble((xPosNumContainer / widthLimits) * 2, 0, 1);

    return Scaffold(
      backgroundColor: const Color(0xfff8f5fe),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hPadding,
          vertical: vPadding
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Animated number selector flutter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87, 
                  fontSize: 30,
                  fontWeight: FontWeight.w600
                  )
              ),
              SizedBox(height: resp.hp(5)),
              const Text(
                'Select a number:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87, 
                  fontSize: 18,
                  fontWeight: FontWeight.w300
                  )
              ),
              SizedBox(height: resp.hp(2.5)),
              SizedBox(
                height: containerHeight,
                width: containerWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: const Color(0xffe1d2fd).withOpacity(leftArrowOpacity)
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) async {
                          final bool isInLimit = xPosNumContainer.abs() >= widthLimits - (widthLimits * 0.1);
                          setState(() {
                              dragging = true;
                              xPosNumContainer = clampDouble(xPosNumContainer + details.delta.dx, -widthLimits, widthLimits);
                          });
                          if(isInLimit){
                            if(_timer == null || !_timer!.isActive){
                              final int direction = xPosNumContainer > 0 ? 1 : -1;
                              lastDirection = direction;
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
                        },
                        onHorizontalDragEnd: (details) {
                          _controller.reset();
                          dragging = false;
                          xPosNumContainer = 0;
                          stopTimer();
                        },
                        child: AnimatedContainer(
                          key: containerKey,
                          clipBehavior: Clip.hardEdge,
                          duration: Duration(milliseconds: dragging ? 150 : 350),
                          curve: dragging ? Curves.ease : Curves.easeInOutBack,
                          transform: Matrix4.identity()..translate(xPosNumContainer),
                          decoration: BoxDecoration(
                            color: const Color(0xff854df9),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: timerDelay ~/ _animator.value),
                                transitionBuilder: (child, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(begin: Offset(lastDirection == 1 ? resp.wp(0.225) : -resp.wp(0.225), 0), end: const Offset(0, 0)).animate(animation),
                                    child: child,
                                  );
                                },
                                child: Center(
                                  key: Key(counter.toString()),
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          counter.toString(),
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
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: const Color(0xffe1d2fd).withOpacity(rightArrowOpacity)
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}