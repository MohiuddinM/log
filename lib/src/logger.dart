import 'log_level.dart';
import 'log_message.dart';
import 'log_writer.dart';

/// Main class that provides Logging functionality
///
/// [tag] should be set to the name of the project
/// Can be used to ignore [LogMessage] from a particular tag
class Logger {
  final String name, tag;

  static LogWriter writer = const ConsolePrinter(minLevel: LogLevel.fine);

  const Logger(this.name, [this.tag = 'none']);

  /// Generic function which sends message to [LogWriter]
  ///
  /// This can either be used directly, but is more helpful to use level specific functions like [info], [warning] etc
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

  void fine(message, {bool includeStackTrace = false, stackTrace}) {
    var trace = stackTrace?.toString();
    if (includeStackTrace) {
      trace ??= _stackTrace;
    }

    log(
      LogMessage(
        LogLevel.fine,
        message.toString(),
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
        message.toString(),
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
        message.toString(),
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
        message.toString(),
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
        message.toString(),
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
