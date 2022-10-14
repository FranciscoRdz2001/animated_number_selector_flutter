import 'package:animated_number_selector_flutter/utils/responsive_util.dart';
import 'package:animated_number_selector_flutter/widgets/custom_animated_num_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final ResponsiveUtil resp = ResponsiveUtil.of(context);

    final double hPadding = resp.wp(2.5);
    final double vPadding = resp.hp(2.5);

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
              CustomAnimatedNumSelector(
                height: resp.hp(6),
                width: resp.wp(40)
              )
            ],
          ),
        ),
      ),
    );
  }
}