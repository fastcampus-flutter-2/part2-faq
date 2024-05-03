import 'package:core_util/util.dart';
import 'package:feature_community_example/module/module.dart';
import 'package:feature_community_example/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tool_clind_theme/theme.dart';

enum Phase {
  real('http://127.0.0.1:8181', false),
  qa('http://127.0.0.1:8080', true);

  final String baseUrl;
  final bool debugShowCheckedModeBanner;

  const Phase(this.baseUrl, this.debugShowCheckedModeBanner);
}

Future<void> run(Phase phase) async {
  runApp(
    ModularApp(
      module: AppModule(
        baseUrl: phase.baseUrl,
      ),
      child: ClindCommunityApp(
        debugShowCheckedModeBanner: phase.debugShowCheckedModeBanner,
      ),
    ),
  );

  runApp(
    ModularApp(
      module: AppModule(
        baseUrl: phase.baseUrl,
      ),
      child: ClindCommunityApp(
        debugShowCheckedModeBanner: phase.debugShowCheckedModeBanner,
      ),
    ),
  );
}

class ClindCommunityApp extends StatefulWidget {
  final bool debugShowCheckedModeBanner;

  const ClindCommunityApp({
    super.key,
    this.debugShowCheckedModeBanner = false,
  });

  @override
  State<ClindCommunityApp> createState() => _ClindCommunityAppState();
}

class _ClindCommunityAppState extends State<ClindCommunityApp> {
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
