import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget imageWidget(XFile file) {
  return Image.file(
    File(file.path),
    fit: BoxFit.cover,
  );
}

File getFileFromXFile(XFile file) {
  return File(file.path);
}
