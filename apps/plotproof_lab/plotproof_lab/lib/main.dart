import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/progress_repository.dart';
import 'state/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final controller = AppController(
    SharedPreferencesProgressRepository(preferences),
  );
  await controller.initialize(systemLocale: PlatformDispatcher.instance.locale);
  runApp(PlotProofApp(controller: controller));
}
