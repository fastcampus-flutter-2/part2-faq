import 'dart:async';

import 'package:core_util/util.dart';
import 'package:flutter/material.dart';

class ClindUriHandlerWidget extends StatefulWidget {
  final Widget child;

  const ClindUriHandlerWidget({
    super.key,
    required this.child,
  });

  @override
  State<ClindUriHandlerWidget> createState() => _ClindUriHandlerWidgetState();
}

class _ClindUriHandlerWidgetState extends State<ClindUriHandlerWidget> {
  StreamSubscription<RouteEvent>? _routeEventSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscribeRouteEvent();
    });
    super.initState();
  }

  @override
  void dispose() {
    _unsubscribeRouteEvent();
    super.dispose();
  }

  void _subscribeRouteEvent() {
    _routeEventSubscription = Modular.get<EventBus>().on<RouteEvent>().listen((event) {
      _open(event.route);
    });
  }

  void _unsubscribeRouteEvent() {
    _routeEventSubscription?.cancel();
    _routeEventSubscription = null;
  }

  Future<void> _open(String route) async {
    final Uri uri = Uri.tryParse(route) ?? Uri();
    Modular.to.pushNamed(
      uri.path,
      arguments: {
        ...uri.queryParameters,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
