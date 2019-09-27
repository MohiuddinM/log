class LogLevel implements Comparable<LogLevel> {
  static const fine = LogLevel(0, 'FINE');
  static const debug = LogLevel(1, 'DEBUG');
  static const info = LogLevel(2, 'INFO');
  static const warning = LogLevel(3, 'WARNING');
  static const error = LogLevel(4, 'ERROR');

  final int value;
  final String name;

  const LogLevel(this.value, this.name);

  @override
  bool operator ==(Object other) => other is LogLevel && value == other.value;

  @override
  int compareTo(LogLevel other) => value - other.value;

  @override
  String toString() => name;
}
