import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/app_localizations.dart';
import 'app/app_theme.dart';
import 'data/file_project_store.dart';
import 'data/native_csv_gateway.dart';
import 'domain/quality_engine.dart';
import 'state/workbench_controller.dart';
import 'ui/workbench_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    CleanTrailApp(
      controller: WorkbenchController(
        engine: const QualityEngine(),
        store: FileProjectStore(),
        gateway: NativeCsvGateway(),
      ),
    ),
  );
}

class CleanTrailApp extends StatefulWidget {
  const CleanTrailApp({required this.controller, super.key});

  final WorkbenchController controller;

  @override
  State<CleanTrailApp> createState() => _CleanTrailAppState();
}

class _CleanTrailAppState extends State<CleanTrailApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.s.appName,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supported) {
        if (_locale != null) return _locale;
        return locale?.languageCode == 'zh'
            ? const Locale('zh')
            : const Locale('en');
      },
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: WorkbenchHome(
        controller: widget.controller,
        onLocaleChanged: (locale) => setState(() => _locale = locale),
      ),
    );
  }
}
