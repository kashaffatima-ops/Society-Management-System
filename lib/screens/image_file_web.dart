import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget imageWidget(XFile file) {
  return Image.network(
    file.path,
    fit: BoxFit.cover,
  );
}

XFile getFileFromXFile(XFile file) {
  return file;
}
