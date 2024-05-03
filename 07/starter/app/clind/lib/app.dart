import 'package:clind/module/module.dart';
import 'package:clind/widget/widget.dart';
import 'package:core_util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tool_clind_theme/theme.dart';

enum Phase {
  real('http://127.0.0.1:8181', false),
  qa('http://127.0.0.1:8080', true);

  final String baseUrl;
  final bool debugShowCheckedModeBanner;

  const Phase(this.baseUrl, this.debugShowCheckedModeBanner);
}

Future<void> run(Phase phase) async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await ICoreFirebase.initialize();
  await ICoreFirebaseRemoteConfig.initialize();
  await ICoreFirebaseRemoteConfig.fetchAndActivate();
  runApp(
    ModularApp(
      module: AppModule(
        baseUrl: phase.baseUrl,
      ),
      child: ClindApp(
        debugShowCheckedModeBanner: phase.debugShowCheckedModeBanner,
      ),
    ),
  );
}

class ClindApp extends StatefulWidget {
  final bool debugShowCheckedModeBanner;

  const ClindApp({
    super.key,
    this.debugShowCheckedModeBanner = false,
  });

  @override
  State<ClindApp> createState() => _ClindAppState();
}

class _ClindAppState extends State<ClindApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClindTheme(
      themeData: ClindThemeData.dark(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        themeMode: ThemeMode.dark,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: [
          const Locale('ko'),
        ],
        routerConfig: Modular.routerConfig,
        builder: (context, child) => ClindUriHandlerWidget(
          child: child!,
        ),
      ),
    );
  }
}
