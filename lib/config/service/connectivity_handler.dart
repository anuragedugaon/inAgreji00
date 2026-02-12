import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../widgets/no_internet_screen.dart';

class ConnectivityHandler extends StatefulWidget {
  final Widget child;

  const ConnectivityHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<ConnectivityHandler> createState() => _ConnectivityHandlerState();
}

class _ConnectivityHandlerState extends State<ConnectivityHandler> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final isOnline = !results.contains(ConnectivityResult.none);

      if (_hasConnection != isOnline && mounted) {
        setState(() => _hasConnection = isOnline);
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final isOnline = !results.contains(ConnectivityResult.none);

    if (mounted) setState(() => _hasConnection = isOnline);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _hasConnection
        ? widget.child
        : const NoInternetScreen();
  }
}
