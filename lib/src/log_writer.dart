import 'package:clock/clock.dart';
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
  static const bool _kReleaseMode = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  const LogWriter(this.onlyTags, this.exceptTags, this.onlyLevel, this.minLevel)
      : assert(onlyTags == null || exceptTags == null),
        assert(onlyLevel == null || minLevel == null);

  /// This function is responsible for outputting the message
  ///
  /// It is implemented by concrete classes extending [LogWriter]
  Future<void> write(LogMessage message);

  bool shouldLog(LogMessage msg) {
    if (_kReleaseMode && !enableInReleaseMode) {
      return false;
    }

    if (onlyLevel != null && onlyLevel != msg.level) {
      return false;
    }

    if (msg.level >= (minLevel ?? LogLevel.fine)) {
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

  String color(LogLevel level) => switch (level) {
        LogLevel.fine => '92m',
        LogLevel.debug || LogLevel.info => '93m',
        LogLevel.warning => '31m',
        LogLevel.error => '97;41m',
      };

  @override
  Future<void> write(LogMessage message) async {
    if (!shouldLog(message)) {
      return;
    }

    final c = color(message.level);

    print(
      '$_ansiEsc$c[${message.level}] ${message.logger.name}: ${message.message}$_ansiReset',
    );

    if (message.stackTrace != null) {
      print(message.stackTrace);
    }
  }
}

enum TimeSetting {
  none,
  fromStart,
  fromPreviousMessage,
}

enum TimeUnit {
  us,
  ms,
  s,
  m,
}

/// Default [LogWriter], prints all [LogMessage] to the default console
class ConsolePrinterWithTime extends ConsolePrinter {
  ConsolePrinterWithTime({
    super.onlyTags,
    super.exceptTags,
    super.onlyLevel,
    super.minLevel,
    this.startTime,
    this.timeUnit,
    this.timeSetting = TimeSetting.fromStart,
  });

  static const _ansiEsc = '\x1B[';
  static const _ansiReset = '\x1b[0m';

  final TimeSetting timeSetting;
  final TimeUnit? timeUnit;
  final DateTime? startTime;
  final _startTime = clock.now();
  DateTime? _lastMessageTime;

  String _durationToString(Duration duration) {
    final timeUnit = this.timeUnit;

    if (timeUnit != null) {
      return switch (timeUnit) {
        TimeUnit.us => duration.inMicroseconds.toString(),
        TimeUnit.ms => duration.inMilliseconds.toString(),
        TimeUnit.s => duration.inSeconds.toString(),
        TimeUnit.m => duration.inMinutes.toString(),
      };
    }

    final us = duration.inMicroseconds;

    if (us < 1000) {
      return '$us us';
    }

    final ms = us ~/ 1000;

    if (ms < 1000) {
      return '$ms ms';
    }

    final s = ms / 1000;

    return '${s.toStringAsFixed(1)} s';
  }

  Duration _timeSinceLastMessage(DateTime from) {
    return _lastMessageTime == null
        ? Duration.zero
        : from.difference(_lastMessageTime ?? from);
  }

  Duration _timeSinceStart(DateTime from) {
    return from.difference(startTime ?? _startTime);
  }

  @override
  Future<void> write(LogMessage message) async {
    if (!shouldLog(message)) {
      return;
    }

    final c = color(message.level);

    var timeString = switch (timeSetting) {
      TimeSetting.none => '',
      TimeSetting.fromStart =>
        '+${_durationToString(_timeSinceStart(message.timestamp))}',
      TimeSetting.fromPreviousMessage =>
        '+${_durationToString(_timeSinceLastMessage(message.timestamp))}',
    };

    if (timeString.isNotEmpty) {
      timeString = ' ($timeString)';
    }

    print(
      '$_ansiEsc$c[${message.level}] ${message.logger.name}: ${message.message}$timeString$_ansiReset',
    );

    if (message.stackTrace != null) {
      print(message.stackTrace);
    }

    _lastMessageTime = message.timestamp;
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
  late ReplaySubject<LogMessage> _messages;

  Stream<LogMessage> get messages => _messages.stream;

  @pragma('vm:prefer-inline')
  List<LogMessage> get pastMessages => _messages.values;

  @pragma('vm:prefer-inline')
  LogMessage get lastMessage => pastMessages.last;

  LogStreamWriter({
    List<String>? onlyTags,
    List<String>? exceptTags,
    LogLevel? onlyLevel,
    LogLevel? minLevel,
  })  : _messages = ReplaySubject(),
        super(onlyTags, exceptTags, onlyLevel, minLevel);

  @override
  Future<void> write(LogMessage message) async {
    if (shouldLog(message)) {
      _messages.add(message);
    }
  }

  Future<void> dispose() async {
    return _messages.close();
  }

  void clear() {
    _messages = ReplaySubject();
  }
}
