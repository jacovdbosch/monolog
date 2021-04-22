import 'logger.dart';

abstract class LoggerRegistry {
  static LoggerRegistry _instance;

  static LoggerRegistry get instance => _instance ??= asNewInstance();

  static LoggerRegistry asNewInstance() => _LoggerRegistryImpl();

  /// Add a new [Logger] instance into the registry.
  ///
  /// Will default to the [name] given and will use the name of the [Logger]
  /// instance as a fallback.
  ///
  /// [overwrite] true means you will overwrite any instances that were already
  /// registered with the given name.
  ///
  /// [isDefault] makes the given [Logger] instance the default logger to be
  /// used in the helper methods provided by this package.
  ///
  void put(
    Logger logger, {
    String name,
    bool overwrite = false,
    bool isDefault = false,
  });

  /// Check if a logger exists in the registry with the given [name].
  ///
  bool exists(String name);

  /// Remove the logger with the given [name].
  ///
  /// If no logger has been found it will throw an [ArgumentError].
  ///
  void remove(String name);

  /// Clear the whole registry of any registered loggers.
  ///
  void clear();

  /// Get the logger with the given [name]. If [name] is null it will return
  /// the default logger if available.
  ///
  /// If no logger has been found it will throw an [ArgumentError].
  ///
  Logger get([String name]);

  /// This is a alias for [LoggerRegistry.get]. This method makes it possible
  /// to do something like this: LoggerRegistry.instance('logger-name'),
  /// instead of LoggerRegistry.instance.get('logger-name').
  ///
  Logger call([String name]);

  /// Set the logger with the given [name] as the default logger.
  ///
  /// If no logger has been found it will throw an [ArgumentError].
  ///
  void setDefault(String name);
}

class _LoggerRegistryImpl implements LoggerRegistry {
  final Map<String, Logger> _instances = {};
  String _default;

  @override
  Logger call([String name]) => get(name);

  @override
  Logger get([String name]) {
    if (name == null) {
      if (_default == null) {
        throw ArgumentError(
          'No name given when fetching a logger. Default used but no default Logger available',
        );
      }

      return _instances[_default];
    }

    if (!exists(name)) {
      throw ArgumentError.value(
        name,
        'name',
        'The Logger with the given name was not found.',
      );
    }

    return _instances[name];
  }

  @override
  bool exists(String name) => _instances.containsKey(name);

  @override
  void clear() {
    _default = null;

    for (final instance in _instances.values) {
      instance.dispose();
    }

    _instances.clear();
  }

  @override
  void put(
    Logger logger, {
    String name,
    bool overwrite = false,
    bool isDefault = false,
  }) {
    name = name ?? logger.name;

    if (name == null) {
      throw ArgumentError.value(
        name,
        'name',
        'Registering a Logger without a name. Either no name was given when registering the Logger, or the Logger has no name.',
      );
    }

    if (exists(name)) {
      if (!overwrite) {
        throw ArgumentError.value(
          name,
          'name',
          'Registering a Logger with a name that already exists. Either overwrite the Logger or check if you are registering multiple Loggers with the same name.',
        );
      }

      remove(name);
    }

    _instances[name] = logger;

    if (isDefault) _default = name;
  }

  @override
  void remove(String name) {
    if (!exists(name)) {
      throw ArgumentError.value(
        name,
        'name',
        'The Logger with the given name was not found.',
      );
    }

    _instances[name].dispose();
    _instances.remove(name);
  }

  @override
  void setDefault(String name) {
    if (!exists(name)) {
      throw ArgumentError.value(
        name,
        'name',
        'The Logger with the given name was not found.',
      );
    }

    _default = name;
  }
}
