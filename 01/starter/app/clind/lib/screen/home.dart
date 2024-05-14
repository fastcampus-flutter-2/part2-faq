import 'dart:async';

import 'package:clind/route/route.dart';
import 'package:clind/screen/screen.dart';
import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:core_util/util.dart';
import 'package:feature_community/clind.dart';
import 'package:feature_my/clind.dart';
import 'package:feature_notification/clind.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presentation/presentation.dart';
import 'package:tool_clind_component/component.dart';
import 'package:tool_clind_theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<HomeTabEvent>? _homeTabEventSubscription;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SplashScreen.show(context);
      _subscribeHomeTabEvent();
    });
    super.initState();
  }

  @override
  void dispose() {
    _unsubscribeHomeTabEvent();
    super.dispose();
  }

  void _subscribeHomeTabEvent() {
    _homeTabEventSubscription = Modular.get<EventBus>().on<HomeTabEvent>().listen((event) {
      context.readFlowBloc<HomeTabCubit>().change(index: event.index);
    });
  }

  void _unsubscribeHomeTabEvent() {
    _homeTabEventSubscription?.cancel();
    _homeTabEventSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.darkBlack,
      body: FlowBlocBuilder<HomeTabCubit, int>.when(
        data: (context, state) => CoreTabSwitchingView(
          currentTabIndex: state.data,
          tabCount: ClindNavigationType.values.length,
          tabBuilder: (context, index) {
            final Widget screen = switch (index) {
              0 => ICommunityRoutes.findScreen(Uri(path: CommunityRoute.community.path)),
              1 => INotificationRoutes.findScreen(Uri(path: NotificationRoute.notification.path)),
              2 => IMyRoutes.findScreen(Uri(path: MyRoute.my.path)),
              _ => IClindRoutes.findScreen(Uri(path: ClindRoute.unknown.path)),
            };
            return screen;
          },
        ),
      ),
      bottomNavigationBar: FlowBlocBuilder<HomeTabCubit, int>.when(
        data: (context, state) => ClindBottomNavigationBar(
          items: ClindNavigationType.values.map((e) => ClindBottomNavigationItem(type: e)).toList(),
          currentIndex: state.data,
          onTap: (index) => context.readFlowBloc<HomeTabCubit>().change(index: index),
        ),
      ),
      floatingActionButton: FlowBlocBuilder<HomeTabCubit, int>.when(
        data: (context, state) {
          switch (state.data) {
            case 0:
            case 1:
              return ClindWriteButton(
                onTap: () => ICommunityRouteTo.write(),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
