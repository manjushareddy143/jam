import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' as math;
//import 'package:jam/api/detail.dart';
//import 'package:jam/api/detailStart.dart';
//import 'package:jam/models/service.dart';
//import 'package:jam/screens/provider_list_screen.dart';
//import 'package:jam/swiper.dart';
//import 'package:flutter_icons/flutter_icons.dart';
//import 'package:jam/placeholder_widget.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  }); //configuration for the slivers layout
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child); //box with a specified size
  }

  @override //called to check if the present delegate is different from old delegate, if yes it rebuilds
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}