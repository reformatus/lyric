import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

enum ConnectionType { unlimited, mobile, offline }

@Riverpod(keepAlive: true)
class Connection extends _$Connection {
  @override
  ConnectionType build() {
    Connectivity().onConnectivityChanged.listen((list) {
      if (list.every((e) => e == ConnectivityResult.mobile)) {
        setTo(ConnectionType.mobile);
        return;
      }
      if (list.every((e) => e == ConnectivityResult.none)) {
        setTo(ConnectionType.offline);
        return;
      }
      setTo(ConnectionType.unlimited);
    });

    return ConnectionType.unlimited;
  }

  void setTo(ConnectionType newValue) {
    state = newValue;
  }
}
