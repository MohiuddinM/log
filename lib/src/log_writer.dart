import 'package:rxdart/rxdart.dart';

import 'log_level.dart';
import 'log_message.dart';

abstract class LogWriter {
  final List<String> onlyNamespace, exceptNamespace;
  final LogLevel onlyLevel, minLevel;
  final bool enableInReleaseMode;
  static const bool _kReleaseMode = bool.fromEnvironment('dart.vm.product', defaultValue: false);

  const LogWriter(this.onlyNamespace, this.exceptNamespace, this.onlyLevel, LogLevel minLevel, [this.enableInReleaseMode = false])
      : assert(onlyNamespace == null || exceptNamespace == null),
        assert(onlyLevel == null || minLevel == null),
        this.minLevel = minLevel ?? (onlyLevel == null ? LogLevel.fine : null);

  Future<void> write(LogMessage message);

  bool shouldLog(LogMessage msg) {
    // bool debugMode = false;
    // assert(debugMode = true);

    if (_kReleaseMode && !enableInReleaseMode) {
      return false;
    }

    if (msg.level.value >= minLevel.value || msg.level == onlyLevel) {
      if (onlyNamespace != null) {
        if (onlyNamespace.contains(msg.loggerNamespace)) {
          return true;
        }
      } else if (exceptNamespace != null) {
        if (!exceptNamespace.contains(msg.loggerNamespace)) {
          return true;
        }
      } else {
        return true;
      }
    }

    return false;
  }
}

class ConsolePrinter extends LogWriter {
  const ConsolePrinter({List<String> onlyNamespace, List<String> exceptNamespace, LogLevel onlyLevel, LogLevel minLevel, bool enableInReleaseMode})
      : super(onlyNamespace, exceptNamespace, onlyLevel, minLevel, enableInReleaseMode);

  Future<void> write(LogMessage msg) async {
    String color = '';
    if (shouldLog(msg)) {
      if (msg.level == LogLevel.fine) {
        color = '\x1b[92m';
      } else if (msg.level == LogLevel.info || msg.level == LogLevel.debug) {
        color = '\x1b[93m';
      } else if (msg.level == LogLevel.warning) {
        color = '\x1b[31m';
      } else if (msg.level == LogLevel.error) {
        color = '\x1b[97;41m';
      }

      print('$color${msg.loggerName}: [${msg.level}] - ${msg.message}\x1b[0m');
    }
  }
}

class NullWriter extends LogWriter {
  const NullWriter() : super(null, null, null, null);

  Future<void> write(LogMessage message) async {}
}

//class LogFileWriter extends LogWriter {
//  const LogFileWriter(String filePath, {List<String> onlyNamespace, List<String> exceptNamespace, LogLevel onlyLevel, LogLevel minLevel})
//      : super(onlyNamespace, exceptNamespace, onlyLevel, minLevel);
//
//  Future<void> write(LogMessage msg) async {
//    if (shouldLog(msg)) {
//      print('written to file: ${msg.message}');
//    }
//  }
//}

class LogStreamWriter extends LogWriter {
  final _messages = BehaviorSubject<LogMessage>();

  Stream<LogMessage> get messages => _messages.stream;

  LogMessage get lastMessage => _messages.value;

  LogStreamWriter({List<String> onlyNamespace, List<String> exceptNamespace, LogLevel onlyLevel, LogLevel minLevel})
      : super(onlyNamespace, exceptNamespace, onlyLevel, minLevel);

  Future<void> write(LogMessage msg) async {
    if (shouldLog(msg)) {
      _messages.add(msg);
    }
  }
}
