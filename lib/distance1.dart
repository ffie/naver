import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DistanceDouble {
  final LatLng dis1_;
  final LatLng dis2_;

  const DistanceDouble({
    Key? key,
    required this.dis1_,
    required this.dis2_,
  });

  double disfunction() {
    Distance distance = const Distance();

    final double km = distance.as(LengthUnit.Kilometer, dis1_, dis2_);

    return km;
  }
}
