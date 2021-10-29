import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mask Text with Image"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            //
            // ignore: prefer_const_constructors
            MaskedImage(
              image: const NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7NCeIag5T-N2HrAs_KKWzJIfHG3Dn4l4ySQ&usqp=CAU"),
              child: Text(
                "KHMER",
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.withOpacity(.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaskedImage extends StatelessWidget {
  final ImageProvider image;
  final Widget child;
  const MaskedImage({
    Key? key,
    required this.image,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<ui.Image>(
        future: loadingImage(),
        builder: (context, snapshot) => snapshot.hasData
            ? ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => ImageShader(
                  snapshot.data!,
                  TileMode.clamp,
                  TileMode.clamp,
                  Matrix4.identity().storage,
                ),
                child: child,
              )
            : Container(),
      );
  Future<ui.Image> loadingImage() async {
    // ignore: prefer_const_constructors
    final stream = image.resolve(ImageConfiguration());
    final completer = Completer<ui.Image>();
    stream.addListener(
      ImageStreamListener(
        (info, _) => completer.complete(info.image),
      ),
    );
    return completer.future;
  }
}
