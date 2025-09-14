import 'package:flutter/widgets.dart';

class Responsive {
  static bool isMobile(BuildContext ctx) => MediaQuery.of(ctx).size.width < 600;
  static bool isDesktop(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 1024;
}