import 'dart:io';
import 'dart:math';

import 'package:log/log.dart';
import 'package:log/src/log_message.dart';
import 'package:rxdart/rxdart.dart';

abstract class LogWriter {
  final List<String> onlyNamespace, exceptNamespace;
  final LogLevel onlyLevel, minLevel;

  const LogWriter(this.onlyNamespace, this.exceptNamespace, this.onlyLevel, minLevel)
      : assert(onlyNamespace == null || exceptNamespace == null),
        assert(onlyLevel == null || minLevel == null),
        this.minLevel = minLevel ?? (onlyLevel == null ? LogLevel.fine : null);

  Future<void> write(LogMessage message);

  bool shouldLog(LogMessage msg) {
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
  const ConsolePrinter({List<String> onlyNamespace, List<String> exceptNamespace, LogLevel onlyLevel, LogLevel minLevel})
      : super(onlyNamespace, exceptNamespace, onlyLevel, minLevel);

  Future<void> write(LogMessage msg) async {
    String color = '';
    if (shouldLog(msg)) {
      if (msg.level == LogLevel.fine) {
        color = '\x1b[93m';
      } else if (msg.level == LogLevel.info || msg.level == LogLevel.debug) {
        color = '\x1b[92m';
      } else if (msg.level == LogLevel.warning) {
        color = '\x1b[31m';
      } else if (msg.level == LogLevel.error) {
        color = '\x1b[97;41m';
      }

      print('$color${msg.loggerName}: [${msg.level}] - ${msg.message}');
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