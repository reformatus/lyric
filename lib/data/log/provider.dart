import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
class ShowLogLevel extends _$ShowLogLevel {
  @override
  Level build() {
    return Level.WARNING;
  }
}

@Riverpod(keepAlive: true)
class LogMessages extends _$LogMessages {
  @override
  List<LogMessage> build() {
    return [];
  }

  void addRecord(LogRecord record) {
    state.add(LogMessage(record));
    // TODO show message snackbar when necessary
    ref.notifyListeners();
  }

  void markAllRead() {
    for (var e in state) {
      e.isRead = true;
    }
    ref.notifyListeners();
  }

  void markAsRead(LogMessage message) {
    if (!message.isRead) {
      message.isRead = true;
      ref.notifyListeners();
    }
  }
}

@riverpod
int unreadLogCount(Ref ref) {
  final logs = ref.watch(logMessagesProvider);
  final level = ref.watch(showLogLevelProvider);
  return logs
      .where((e) => e.record.level.value >= level.value && !e.isRead)
      .length;
}

class LogMessage {
  LogRecord record;
  bool isRead = false;

  LogMessage(this.record);
  LogMessage.read(this.record) : isRead = true;
}
