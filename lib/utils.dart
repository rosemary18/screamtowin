import 'dart:io';
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
    print(e);
  }

  return rpath;
}
