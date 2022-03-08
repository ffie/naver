// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, avoid_print, unused_local_variable, unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class Map3 extends StatefulWidget {
  const Map3({Key? key}) : super(key: key);

  @override
  State<Map3> createState() => _MapState();
}

class _MapState extends State<Map3> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const MODE_ADD = 0xF1;
  static const MODE_REMOVE = 0xF2;
  static const MODE_NONE = 0xF3;
  static const MODE_MODIFY = 0xF4;
  static const MODE_DISTANCE = 0xF5;
  int _currentMode = MODE_NONE;
  static String sDis = "KM";

  final _textMap = TextEditingController();

  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];
  List<Marker> _markers2 = [];

  @override
  void dispose() {
    _textMap.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'icon/marker.png',
      ).then((image) {
        setState(() {
          print("test1");
          _markers.add(Marker(
              markerId: 'id',
              position: LatLng(37.489488, 126.724519),
              captionText: "커스텀 아이콘",
              captionColor: Colors.indigo,
              captionTextSize: 20.0,
              alpha: 0.8,
              captionOffset: 30,
              icon: image,
              anchor: AnchorPoint(0.5, 1),
              width: 45,
              height: 45,
              infoWindow: '인포 윈도우',
              onMarkerTab: _onMarkerTap));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('map'),
        ),
        body: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(sDis),
            ),
            _naverMap(),
            _controlPanel(),
            _textFieldView(),
          ],
        ),
      ),
    );
  }

  _controlPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 추가
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentMode = MODE_ADD),
              child: Container(
                decoration: BoxDecoration(
                    color:
                        _currentMode == MODE_ADD ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '추가',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        _currentMode == MODE_ADD ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          // 삭제
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentMode = MODE_REMOVE),
              child: Container(
                decoration: BoxDecoration(
                    color: _currentMode == MODE_REMOVE
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '삭제',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentMode == MODE_REMOVE
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          //수정
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentMode = MODE_MODIFY),
              child: Container(
                decoration: BoxDecoration(
                    color: _currentMode == MODE_MODIFY
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentMode == MODE_MODIFY
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentMode = MODE_DISTANCE;
                });
              },
              //onTap: () => setState(() => _currentMode = MODE_DISTANCE),
              child: Container(
                decoration: BoxDecoration(
                    color: _currentMode == MODE_DISTANCE
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '거리계산',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentMode == MODE_DISTANCE
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          // none
          GestureDetector(
            onTap: () => setState(() => _currentMode = MODE_NONE),
            child: Container(
              decoration: BoxDecoration(
                  color:
                      _currentMode == MODE_NONE ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black)),
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.clear,
                color: _currentMode == MODE_NONE ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _naverMap() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          NaverMap(
            onMapCreated: _onMapCreated,
            onMapTap: _onMapTap,
            markers: _markers,
            initLocationTrackingMode: LocationTrackingMode.NoFollow,
          ),
        ],
      ),
    );
  }

  _textFieldView() => Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: CupertinoTextField(
              controller: _textMap,
              maxLines: 1,
              onChanged: (text) {
                print(text);
              },
            ),
          ),
        ),
      );

  void _onMapTap(LatLng latLng) {
    if (_currentMode == MODE_ADD) {
      _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: latLng,
        infoWindow: "정보를 입력하세요",
        onMarkerTab: _onMarkerTap,
      ));
      setState(() {});
    }
    if (_currentMode == MODE_DISTANCE) {
      _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: latLng,
        infoWindow: "거리 계산하자",
        onMarkerTab: _onMarkerTap,
      ));
      setState(() {});
    }
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) {
      _controller = Completer();
    }
    _controller.complete(controller);
  }

  void _onMarkerTap(Marker? marker, Map<String, int?> dd) {
    int pos = _markers.indexWhere((m) => m.markerId == marker!.markerId);
    int pos2 = _markers.lastIndexWhere((m) => m.markerId == marker!.markerId);
    setState(() {
      _markers[pos].captionText = '선택됨';
    });
    if (_currentMode == MODE_REMOVE) {
      setState(() {
        _markers.removeWhere((m) => m.markerId == marker!.markerId);
      });
    }
    if (_currentMode == MODE_MODIFY) {
      setState(() {
        _markers[pos].infoWindow = _textMap.text;
      });
    }
    if (_currentMode == MODE_DISTANCE) {
      setState(() {
        _markers[pos2].captionText = '두번째';

        var dis1 = _markers[pos].position;
        var dis2 = _markers[pos2].position;

        List<LatLng?> _coordinates = [dis1, dis2];
        sDis = _coordinates.length.toString();
      });
    }
    if (_currentMode == MODE_NONE) {
      setState(() {
        //_markers.clear();
      });
    }
  }
}
