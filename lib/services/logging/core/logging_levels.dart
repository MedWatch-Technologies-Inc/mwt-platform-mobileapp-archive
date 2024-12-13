/// [LoggingLevels]s to control logging output. Logging can be enabled to include all
/// levels above certain [LoggingLevels]. [LoggingLevels]s are ordered using an integer
/// value [LoggingLevels.value]. The predefined [LoggingLevels] constants below are sorted as
/// follows (in descending order): [LoggingLevels.shout], [LoggingLevels.severe],
/// [LoggingLevels.warning], [LoggingLevels.info], [LoggingLevels.config], [LoggingLevels.fine], [LoggingLevels.finer],
/// [LoggingLevels.finest], and [LoggingLevels.all].
///
/// We recommend using one of the predefined logging levels. If you define your
/// own level, make sure you use a value between those used in [LoggingLevels.all] and
/// [LoggingLevels.off].

enum LoggingLevels {
  /// Special key to turn on logging for all levels ([value] = 0).
  all,

  /// Special key to turn off all logging ([value] = 2000).
  off,

  /// Key for highly detailed tracing ([value] = 300).
  finest,

  /// Key for fairly detailed tracing ([value] = 400).
  finer,

  /// Key for tracing information ([value] = 500).
  fine,

  /// Key for static configuration messages ([value] = 700).
  config,

  /// Key for informational messages ([value] = 800).
  info,

  /// Key for potential problems ([value] = 900).
  warning,

  /// Key for serious failures ([value] = 1000).
  severe,

  /// Key for extra debugging loudness ([value] = 1200).
  shout,
}

extension LoggingLevelsX on LoggingLevels {
  int get value {
    switch (this) {
      case LoggingLevels.all:
        return 0;
      case LoggingLevels.off:
        return 2000;
      case LoggingLevels.finest:
        return 300;
      case LoggingLevels.finer:
        return 400;
      case LoggingLevels.fine:
        return 500;
      case LoggingLevels.config:
        return 700;
      case LoggingLevels.info:
        return 800;
      case LoggingLevels.warning:
        return 900;
      case LoggingLevels.severe:
        return 1000;
      case LoggingLevels.shout:
        return 1200;
    }
  }

  String get name {
    switch (this) {
      case LoggingLevels.all:
        return 'ALL';
      case LoggingLevels.off:
        return 'OFF';
      case LoggingLevels.finest:
        return 'FINEST';
      case LoggingLevels.finer:
        return 'FINER';
      case LoggingLevels.fine:
        return 'FINE';
      case LoggingLevels.config:
        return 'CONFIG';
      case LoggingLevels.info:
        return 'INFO';
      case LoggingLevels.warning:
        return 'WARNING';
      case LoggingLevels.severe:
        return 'SEVERE';
      case LoggingLevels.shout:
        return 'SHOUT';
    }
  }

  bool operator <(LoggingLevels other) => value < other.value;

  bool operator <=(LoggingLevels other) => value <= other.value;

  bool operator >(LoggingLevels other) => value > other.value;

  bool operator >=(LoggingLevels other) => value >= other.value;

  int compareTo(LoggingLevels other) => value - other.value;
}
