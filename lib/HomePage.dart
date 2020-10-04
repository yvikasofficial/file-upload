import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _picker = ImagePicker();
  final Dio dio = Dio();
  File _file;
  final String endPoint = "http://15.206.42.144:5000/api/v1/file/upload";

  handlePickImage() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      _file = File(image.path);
      setState(() {});
    }
  }

  _handleUpload(File _file) async {
    if (_file == null) return;
    String base64Image = base64Encode(_file.readAsBytesSync());
    String fileName = _file.path.split("/").last;

    final FormData data = FormData.fromMap({
      "image": base64Image,
      "name": fileName,
    });
    final res = await dio.post(endPoint, data: data);
    print(res.statusCode);
  }

  _hanldeUplaad() async {
    String base64Image = base64Encode(_file.readAsBytesSync());
    String fileName = _file.path.split("/").last;
    final data = json.encode({
      "image": base64Image,
      "name": fileName,
    });
    final res = await dio.post(endPoint, data: data);
    print(res.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _file == null ? Container() : Image.file(_file),
            RaisedButton(
              onPressed: handlePickImage,
              child: Text("Pick"),
            ),
            RaisedButton(
              onPressed: () => _handleUpload(_file),
              child: Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}
