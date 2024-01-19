/// Used to assign severity or importance to a [LogMessage]
///
/// A [LogWriter] can also filter messages based of their [LogLevel]
enum LogLevel implements Comparable<LogLevel> {
  fine(0, 'FINE'),
  debug(1, 'DEBUG'),
  info(2, 'INFO'),
  warning(3, 'WARNING'),
  error(4, 'ERROR');

  final int value;
  final String name;

  const LogLevel(this.value, this.name);

  bool operator >=(LogLevel other) => value >= other.value;

  @override
  int compareTo(LogLevel other) => value - other.value;

  @override
  String toString() => name;
}
