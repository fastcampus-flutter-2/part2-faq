import 'package:feature_community/clind.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tool_clind_component/component.dart';
import 'package:tool_clind_theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.darkBlack,
      body: ICommunityRoutes.findScreen(Uri(path: CommunityRoute.community.path)),
      floatingActionButton: ClindWriteButton(
        onTap: () => ICommunityRouteTo.write(),
      ),
    );
  }
}
