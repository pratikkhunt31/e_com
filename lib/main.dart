import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/storage/hive_boxes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(HiveBoxes.settings);
  await Hive.openBox(HiveBoxes.cart);
  await Hive.openBox(HiveBoxes.wishlist);
  await Hive.openBox(HiveBoxes.cacheProducts);
  await Hive.openBox(HiveBoxes.session);
  await Hive.openBox("auth");

  runApp(const MyApp());
}




