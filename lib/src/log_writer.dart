import 'package:rxdart/rxdart.dart';

import 'log_level.dart';
import 'log_message.dart';

/// Base class which a [Logger] requires to write a [LogMessage]
///
/// Subclasses must override the [write] method
/// This library comes with a [ConsolePrinter] as a default [LogWriter],
abstract class LogWriter {
  final List<String> onlyTags, exceptTags;
  final LogLevel onlyLevel, minLevel;
  final bool _enableInReleaseMode;
  static const bool _kReleaseMode =
      bool.fromEnvironment('dart.vm.product', defaultValue: false);

  const LogWriter(
      this.onlyTags, this.exceptTags, this.onlyLevel, LogLevel minLevel,
      [bool enableInReleaseMode])
      : assert(onlyTags == null || exceptTags == null),
        assert(onlyLevel == null || minLevel == null),
        minLevel = minLevel ?? (onlyLevel == null ? LogLevel.fine : null),
        _enableInReleaseMode = enableInReleaseMode ?? false;

  Future<void> write(LogMessage message);

  bool shouldLog(LogMessage msg) {
    // bool debugMode = false;
    // assert(debugMode = true);

    if (_kReleaseMode && !_enableInReleaseMode) {
      return false;
    }

    if (msg.level.value >= minLevel.value || msg.level == onlyLevel) {
      if (onlyTags != null) {
        if (onlyTags.contains(msg.loggerTag)) {
          return true;
        }
      } else if (exceptTags != null) {
        if (!exceptTags.contains(msg.loggerTag)) {
          return true;
        }
      } else {
        return true;
      }
    }

    return false;
  }
}

/// Default [LogWriter], prints all [LogMessage] to the default console
class ConsolePrinter extends LogWriter {
  const ConsolePrinter(
      {List<String> onlyTags,
      List<String> exceptTags,
      LogLevel onlyLevel,
      LogLevel minLevel,
      bool enableInReleaseMode})
      : super(onlyTags, exceptTags, onlyLevel, minLevel, enableInReleaseMode);

  @override
  Future<void> write(LogMessage msg) async {
    var color = '';
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

/// Discards all message written to it
class NullWriter extends LogWriter {
  const NullWriter() : super(null, null, null, null);

  @override
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

/// Writes [LogMessage] to a [Stream]
///
/// Useful for debugging purpose
/// Stream can also be redirected
class LogStreamWriter extends LogWriter {
  final _messages = BehaviorSubject<LogMessage>();

  Stream<LogMessage> get messages => _messages.stream;

  LogMessage get lastMessage => _messages.value;

  LogStreamWriter(
      {List<String> onlyNamespace,
      List<String> exceptNamespace,
      LogLevel onlyLevel,
      LogLevel minLevel})
      : super(onlyNamespace, exceptNamespace, onlyLevel, minLevel);

  @override
  Future<void> write(LogMessage msg) async {
    if (shouldLog(msg)) {
      _messages.add(msg);
    }
  }
}
