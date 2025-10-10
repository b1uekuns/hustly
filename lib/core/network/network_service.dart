import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetWorkService {
  static final NetWorkService _instance = NetWorkService._internal();
  factory NetWorkService() => _instance;
  NetWorkService._internal();

  late StreamSubscription<ConnectivityResult> _streamSubscription;
  bool isConnected = false;

  Future<void> init(BuildContext context) async {

    _streamSubscription = Connectivity()
        .onConnectivityChanged
        .map((list) => list.first)
        .listen((result) => _handleConnectivity(result, context));
  }

  void _handleConnectivity(ConnectivityResult result, BuildContext context) {

    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        isConnected = true;
        break;
      case ConnectivityResult.none:
        isConnected = false;
        // showSnackBar(
        //   context,
        //   title: 'Mất kết nối',
        //   message: 'Vui lòng kiểm tra lại kết nối mạng',
        //   isError: true,
        // );
        break;
      default:
        isConnected = false;
    }
  }

  void dispose() {
    _streamSubscription.cancel();
  }
}
