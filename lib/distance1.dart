import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'dart:math';

class DistanceDouble {
  final LatLng dis1_;
  final LatLng dis2_;

  const DistanceDouble({
    Key? key,
    required this.dis1_,
    required this.dis2_,
  });

  double disfunction() {
    final double km = distance_(dis1_, dis2_);

    return km;
  }
}

double distance_(LatLng dis1_, LatLng dis2_) {
  double km = 0;
  //print("#dis1_ : " + dis1_.toString());
  //print("#dis2_ : " + dis2_.toString());
  final a = dis1_.toString().substring(7);
  final b = a.indexOf(",");
  final c = a.substring(0, b);
  final d = a.indexOf(')');
  final e = a.substring(b + 2, d);

  print("# : c : " + c.toString());
  print("# : e : " + e.toString());

  final a2 = dis2_.toString().substring(7);
  final b2 = a2.indexOf(",");
  final c2 = a2.substring(0, b2);
  final d2 = a2.indexOf(')');
  final e2 = a2.substring(b2 + 2, d2);

  print("# : c2 : " + c2.toString());
  print("# : e2 : " + e2.toString());

  double x1 = double.parse(c);
  double y1 = double.parse(e);

  double x2 = double.parse(c2);
  double y2 = double.parse(e2);

  print("# x1 : " + x1.toString());
  print("# y1 : " + y1.toString());

  //위도 1 : x1   경도 1: y1
  //위도 2 : x2   경도 2: y2
  double x = (cos(x1) * 6400 * 2 * 3.14 / 360) * (y1 - y2);
  double y = 111 * (x2 - x1);

  print("# x : " + x.toString());
  print("# y : " + y.toString());
  km = (x * x + y * y) * sqrt1_2;
  print("# km : " + km.toString());

  String s = (km / 100).toStringAsFixed(2);
  km = double.parse(s);
  return km;
}
