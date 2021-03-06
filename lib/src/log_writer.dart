import 'package:rxdart/rxdart.dart';

import 'log_level.dart';
import 'log_message.dart';

/// Base class which a [Logger] requires to write a [LogMessage]
///
/// Subclasses must override the [write] method
/// This library comes with a [ConsolePrinter] as a default [LogWriter],
abstract class LogWriter {
  final List<String>? onlyTags, exceptTags;
  final LogLevel? onlyLevel, minLevel;
  static bool enableInReleaseMode = false;
  static const bool _kReleaseMode =
      bool.fromEnvironment('dart.vm.product', defaultValue: false);

  const LogWriter(this.onlyTags, this.exceptTags, this.onlyLevel, this.minLevel)
      : assert(onlyTags == null || exceptTags == null),
        assert(onlyLevel == null || minLevel == null);

  /// This function is responsible for outputting the message
  ///
  /// It is implemented by concrete classes extending [LogWriter]
  Future<void> write(LogMessage message);

  bool shouldLog(LogMessage msg) {
    // bool debugMode = false;
    // assert(debugMode = true);

    if (_kReleaseMode && !enableInReleaseMode) {
      return false;
    }

    if (msg.level >= (minLevel ?? LogLevel.fine) || msg.level == onlyLevel) {
      if (onlyTags != null) {
        if (onlyTags!.contains(msg.logger.tag)) {
          return true;
        }
      } else if (exceptTags != null) {
        if (!exceptTags!.contains(msg.logger.tag)) {
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
  static const _ansiEsc = '\x1B[';
  static const _ansiReset = '\x1b[0m';

  const ConsolePrinter({
    List<String>? onlyTags,
    List<String>? exceptTags,
    LogLevel? onlyLevel,
    LogLevel? minLevel,
  }) : super(onlyTags, exceptTags, onlyLevel, minLevel);

  @override
  Future<void> write(LogMessage msg) async {
    var color = '';
    if (shouldLog(msg)) {
      if (msg.level == LogLevel.fine) {
        color = '92m';
      } else if (msg.level == LogLevel.info || msg.level == LogLevel.debug) {
        color = '93m';
      } else if (msg.level == LogLevel.warning) {
        color = '31m';
      } else if (msg.level == LogLevel.error) {
        color = '97;41m';
      }

      print(
          '$_ansiEsc$color${msg.logger.name}: [${msg.level}] - ${msg.message}$_ansiReset');

      if (msg.stackTrace != null) {
        print(msg.stackTrace);
      }
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

  LogMessage get lastMessage {
    final _lastMessage = _messages.value;

    if (_lastMessage != null) {
      return _lastMessage;
    }

    throw StateError('No messages have been written');
  }

  LogStreamWriter({
    List<String>? onlyTags,
    List<String>? exceptTags,
    LogLevel? onlyLevel,
    LogLevel? minLevel,
  }) : super(onlyTags, exceptTags, onlyLevel, minLevel);

  @override
  Future<void> write(LogMessage msg) async {
    if (shouldLog(msg)) {
      _messages.add(msg);
    }
  }
}
