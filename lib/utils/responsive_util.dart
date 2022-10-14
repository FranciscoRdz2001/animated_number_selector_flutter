import 'package:flutter/widgets.dart';

class ResponsiveUtil{

  late final double width;
  late final double height;

  ResponsiveUtil({
    required BuildContext context
  }){
    final Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
  }

  factory ResponsiveUtil.of(final BuildContext context) => ResponsiveUtil(context: context);

  double hp(final double percent) => height * (percent / 100);
  double wp(final double percent) => width * (percent / 100);
}