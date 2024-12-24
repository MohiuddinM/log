import 'package:clock/clock.dart';

import 'log_level.dart';
import 'log_message.dart';
import 'log_writer.dart';

/// Main class that provides Logging functionality
///
/// [tag] should be set to the name of the project
/// Can be used to ignore [LogMessage] from a particular tag
class Logger {
  const Logger(this.name, [this.tag = 'none']);

  static LogWriter writer = const ConsolePrinter(minLevel: LogLevel.fine);

  final String name, tag;

  /// Generic function which sends message to [LogWriter]
  ///
  /// This can either be used directly, but is more helpful to use level specific functions like [info], [warning] etc
  @pragma('vm:prefer-inline')
  void log(LogMessage message) {
    writer.write(message);
  }

  String get _stackTrace {
    final parts = StackTrace.current.toString().split('#');

    final output = StringBuffer();
    for (var i = 3; i < parts.length; i++) {
      output.write('#');
      output.write((i - 3).toString());
      output.write(parts[i].substring(1));
    }

    return output.toString();
  }

  @pragma('vm:prefer-inline')
  bool _shouldIgnoreLevel(LogLevel level) {
    final minLevel = writer.minLevel ?? LogLevel.fine;
    final onlyLevel = writer.onlyLevel;

    if (onlyLevel != null && level != onlyLevel) {
      return true;
    }

    return level < minLevel;
  }

  @pragma('vm:prefer-inline')
  String _str(o) => o is dynamic Function() ? o().toString() : o.toString();

  @pragma('vm:prefer-inline')
  void f(message, {bool includeStackTrace = false, stackTrace}) {
    return fine(
      message,
      includeStackTrace: includeStackTrace,
      stackTrace: stackTrace,
    );
  }

  void fine(message, {bool includeStackTrace = false, stackTrace}) {
    if (_shouldIgnoreLevel(LogLevel.fine)) {
      return;
    }

    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.fine,
        _str(message),
        clock.now(),
        trace,
        this,
      ),
    );
  }

  @pragma('vm:prefer-inline')
  void d(message, {bool includeStackTrace = false, stackTrace}) {
    return debug(
      message,
      includeStackTrace: includeStackTrace,
      stackTrace: stackTrace,
    );
  }

  void debug(message, {bool includeStackTrace = false, stackTrace}) {
    if (_shouldIgnoreLevel(LogLevel.debug)) {
      return;
    }

    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.debug,
        _str(message),
        clock.now(),
        trace,
        this,
      ),
    );
  }

  @pragma('vm:prefer-inline')
  void i(message, {bool includeStackTrace = false, stackTrace}) {
    return info(
      message,
      includeStackTrace: includeStackTrace,
      stackTrace: stackTrace,
    );
  }

  void info(message, {bool includeStackTrace = false, stackTrace}) {
    if (_shouldIgnoreLevel(LogLevel.info)) {
      return;
    }

    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.info,
        _str(message),
        clock.now(),
        trace,
        this,
      ),
    );
  }

  @pragma('vm:prefer-inline')
  void w(message, {bool includeStackTrace = false, stackTrace}) {
    return warning(
      message,
      includeStackTrace: includeStackTrace,
      stackTrace: stackTrace,
    );
  }

  void warning(message, {bool includeStackTrace = false, stackTrace}) {
    if (_shouldIgnoreLevel(LogLevel.warning)) {
      return;
    }

    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.warning,
        _str(message),
        clock.now(),
        trace,
        this,
      ),
    );
  }

  @pragma('vm:prefer-inline')
  void e(message, {bool includeStackTrace = true, stackTrace}) {
    return error(
      message,
      includeStackTrace: includeStackTrace,
      stackTrace: stackTrace,
    );
  }

  void error(message, {bool includeStackTrace = true, stackTrace}) {
    if (_shouldIgnoreLevel(LogLevel.error)) {
      return;
    }

    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.error,
        _str(message),
        clock.now(),
        trace,
        this,
      ),
    );
  }

  @override
  int get hashCode => Object.hash(name, tag);

  @override
  bool operator ==(Object other) =>
      other is Logger && other.name == name && other.tag == tag;
}
