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
  String _str(o) => o is String Function() ? o() : o.toString();

  void fine(message, {bool includeStackTrace = false, stackTrace}) {
    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.fine,
        _str(message),
        DateTime.now(),
        trace,
        this,
      ),
    );
  }

  void debug(message, {bool includeStackTrace = false, stackTrace}) {
    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.debug,
        _str(message),
        DateTime.now(),
        trace,
        this,
      ),
    );
  }

  void info(message, {bool includeStackTrace = false, stackTrace}) {
    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.info,
        _str(message),
        DateTime.now(),
        trace,
        this,
      ),
    );
  }

  void warning(message, {bool includeStackTrace = false, stackTrace}) {
    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.warning,
        _str(message),
        DateTime.now(),
        trace,
        this,
      ),
    );
  }

  void error(message, {bool includeStackTrace = true, stackTrace}) {
    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.error,
        _str(message),
        DateTime.now(),
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
