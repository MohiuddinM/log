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

  void fine(
    String message, {
    bool includeStackTrace = false,
    stackTrace,
  }) {
    final trace =
        includeStackTrace ? stackTrace?.toString() ?? _stackTrace : null;
    log(LogMessage(LogLevel.fine, message, DateTime.now(), trace, this));
  }

  void debug(
    String message, {
    bool includeStackTrace = false,
    stackTrace,
  }) {
    final trace =
        includeStackTrace ? stackTrace?.toString() ?? _stackTrace : null;
    log(LogMessage(LogLevel.debug, message, DateTime.now(), trace, this));
  }

  void info(
    String message, {
    bool includeStackTrace = false,
    stackTrace,
  }) {
    final trace =
        includeStackTrace ? stackTrace?.toString() ?? _stackTrace : null;
    log(LogMessage(LogLevel.info, message, DateTime.now(), trace, this));
  }

  void warning(
    String message, {
    bool includeStackTrace = false,
    stackTrace,
  }) {
    final trace =
        includeStackTrace ? stackTrace?.toString() ?? _stackTrace : null;
    log(LogMessage(LogLevel.warning, message, DateTime.now(), trace, this));
  }

  void error(
    String message, {
    bool includeStackTrace = true,
    stackTrace,
  }) {
    final trace =
        includeStackTrace ? stackTrace?.toString() ?? _stackTrace : null;
    log(LogMessage(LogLevel.error, message, DateTime.now(), trace, this));
  }

  @override
  int get hashCode => name.hashCode + tag.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Logger && other.name == name && other.tag == tag;
}
