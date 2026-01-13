import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../error/handlers/token_provider.dart';

@lazySingleton
class SocketService {
  IO.Socket? _socket;
  final TokenProvider _tokenProvider;

  SocketService(this._tokenProvider);

  // Callback for new match events
  Function(Map<String, dynamic>)? onNewMatch;

  Future<void> connect() async {
    if (_socket?.connected == true) {
      return;
    }

    try {
      // Get access token
      final token = await _tokenProvider.getAccessToken();
      if (token == null || token.isEmpty) {
        print('SocketService: No access token, cannot connect');
        return;
      }

      // Get base URL from environment
      final baseUrl = dotenv.get('BASE_URL', fallback: 'http://localhost:5000');
      String socketUrl = baseUrl;
      if (socketUrl.endsWith('/')) {
        socketUrl = socketUrl.substring(0, socketUrl.length - 1);
      }

      print('SocketService: Connecting to $socketUrl');

      _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .setAuth({
              'token': token, // Socket.io auth object
            })
            .setExtraHeaders({
              'Authorization': 'Bearer $token', // Also set in headers as fallback
            })
            .build(),
      );

      _socket!.onConnect((_) {
        print('SocketService: Connected');
      });

      _socket!.onDisconnect((_) {
        print('SocketService: Disconnected');
      });

      _socket!.onError((error) {
        print('SocketService: Error: $error');
      });

      // Listen for new_match event
      _socket!.on('new_match', (data) {
        print('SocketService: Received new_match event: $data');
        if (onNewMatch != null && data is Map<String, dynamic>) {
          onNewMatch!(data);
        }
      });

      _socket!.connect();
    } catch (e) {
      print('SocketService: Failed to connect: $e');
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;
}

