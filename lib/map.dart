// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'dart:async';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Completer<NaverMapController> _controller = Completer();
  TargetPlatform debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('map'),
      ),
      body: NaverMap(
        onMapCreated: _onMapCreated,
        locationButtonEnable: true,
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) {
      _controller = Completer();
      print("1");
    }
    print("1");
    _controller.complete(controller);
  }
}
