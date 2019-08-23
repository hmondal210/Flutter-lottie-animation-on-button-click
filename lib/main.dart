import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottie Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LottieDemo(),
    );
  }
}

class LottieDemo extends StatefulWidget {
  LottieDemo({Key key}) : super(key: key);

  @override
  _LottieDemoState createState() => _LottieDemoState();
}

class _LottieDemoState extends State<LottieDemo>
    with SingleTickerProviderStateMixin {
  LottieComposition _composition;
  String _assetName = 'assets/bookmark.json';
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _loadButtonPressed(_assetName);
    _controller = AnimationController(
      duration: Duration(milliseconds: 1),
      vsync: this,
    );
    _controller.addListener(() => setState(() {}));
  }

  void _loadButtonPressed(String assetName) {
    loadAsset(assetName).then((LottieComposition composition) {
      setState(() {
        _assetName = assetName;
        _composition = composition;
        _controller.reset();
      });
    });
  }

  void onBookmarked() {
    if (_controller.isCompleted || _composition == null) {
      setState(
        () {
          _controller.reset();
        },
      );
    } else {
      setState(
        () {
          if (_controller.isAnimating) {
            _controller.reset();
          } else {
            _controller.forward();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lottie Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => onBookmarked(),
              child: Lottie(
                composition: _composition,
                size: Size(300.0, 300.0),
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) => LottieComposition.fromMap(map));
}
