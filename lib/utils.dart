import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

const storage = FlutterSecureStorage();

readStorage({required String key, required Function(String?) cb}) async {
  await storage.containsKey(key: key).then((value) async {
    if (value) {
      return await storage.read(key: key).then((value) {
        cb(value);
      });
    } else {
      return await cb(null);
    }
  });
}

writeStorage({required String key, required String value}) async {
  bool exist = await storage.containsKey(key: key);

  if (exist) {
    await storage.delete(key: key);
    return await storage.write(key: key, value: value);
  }

  return await storage.write(key: key, value: value);
}

// ignore: non_constant_identifier_names
Future<String> saveImage(String source_path) async {
  String rpath = "";
  String t = Platform.isWindows ? "\\" : "/";
  final dirPath = await getApplicationDocumentsDirectory();
  final destPath = '${dirPath.path}$t${source_path.split(t).last}';

  try {
    final sourceFile = File(source_path);
    final dest = File(destPath);
    await sourceFile.copy(dest.path).then((value) {
      rpath = dest.path;
    });
  } catch (e) {
    debugPrint(e.toString());
  }

  return rpath;
}

Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
