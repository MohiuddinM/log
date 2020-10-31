import 'package:quick_log/quick_log.dart';

/// Used to assign severity or importance to a [LogMessage]
///
/// A [LogWriter] can also filter messages based of their [LogLevel]
class LogLevel implements Comparable<LogLevel> {
  final int value;
  final String name;

  const LogLevel._(this.value, this.name);

  static const fine = LogLevel._(0, 'FINE');
  static const debug = LogLevel._(1, 'DEBUG');
  static const info = LogLevel._(2, 'INFO');
  static const warning = LogLevel._(3, 'WARNING');
  static const error = LogLevel._(4, 'ERROR');

  @override
  bool operator ==(Object other) => other is LogLevel && value == other.value;

  @override
  int compareTo(LogLevel other) => value - other.value;

  @override
  String toString() => name;
}
