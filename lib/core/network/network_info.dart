// core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility to check network connectivity before calling APIs.
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  /// Returns true if connected to Wi-Fi or mobile data.
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
  }
}
