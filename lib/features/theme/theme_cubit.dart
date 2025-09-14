import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../core/storage/hive_boxes.dart';


class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void loadTheme() {
    final box = Hive.box(HiveBoxes.settings);
    final stored = box.get('theme', defaultValue: 'system') as String;
    if (stored == 'light') {
      emit(ThemeMode.light);
    } else if (stored == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }

  void toggleTheme(ThemeMode mode) {
    Hive.box(HiveBoxes.settings).put('theme', mode.name);
    emit(mode);
  }
}