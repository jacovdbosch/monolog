This is a simple and extensible **Logging** framework for Dart and Flutter highly inspired by [Monolog](https://github.com/Seldaek/monolog). It can be used instead of the default `print` method or `log` method from the `developer` package.

## Why Monolog?

While developing a larger app for the company I work for I found the need for more granular control over how logging information was being processed. Having more control over how logs are presented and processed can save you a lot of time in situations where going through logs is the only thing you can do to fix a problem.

Having worked with Monolog (PHP) in the past i found that i wanted a similar solution for my situation.

## Getting started

There are two parts to this package. First is the creation of a `Logger`, and the `Handlers` attached to that Logger. This package contains a simple `PrintHandler` log handler to get you started. 

Add this to the start of your app:

```Dart
import 'package:monolog/monolog.dart';

final logger = Logger('logger', handlers: [PrintHandler()]);
```

Later in the app you can use that `logger` instance to log your messages.

```Dart
logger.debug('debug');
logger.info('info');
logger.notice('notice');
logger.warning('warning');
logger.error('error');
logger.critical('critical');
logger.alert('alert');
logger.emergency('emergency');
```

## Logger Registry

Using the `LoggerRegistry` is completely **optional**. Using the Registry makes it possible for you to get a `Logger` instance from anywhere in your application.

```Dart
import 'package:monolog/monolog.dart';

final logger = Logger('logger', handlers: [PrintHandler()]);

LoggerRegistry.instance.put(logger);
``` 

By registering the `Logger` you can easily get it at a later stage in your application. This saves you from putting some global variable in your project.

```Dart
final logger = LoggerRegistry.instance.get();
```

The first `Logger` you add to the `LoggerRegistry` will be set to the default.

## Helpers

Using the `LoggerRegistry` allows you to also use the helper functions located in the `package:monolog/helpers.dart` file. The helper functions will use the default logger that is registered in the `LoggerRegistry`

```Dart
import 'package:monolog/helpers.dart';

debug('debug');
info('info');
notice('notice');
warning('warning');
error('error');
critical('critical');
alert('alert');
emergency('emergency');
```

## Writing a handler

The [examples](https://github.com/jacovdbosch/monolog/blob/main/examples) directory contains a file that shows you how to get started with Monolog. Writing a `Handler` for a `Logger` is fairly easy. The only thing you need to do is implement the `Handler` class methods.

```Dart
abstract class Handler {
  /// Checks whether the given record will be handled by this handler.
  ///
  bool handles(int level);

  /// Handle a [Record].
  ///
  bool handle(Record record);

  /// Handle a set of records.
  ///
  void handleBatch(List<Record> records);

  /// Disposes any resources attached to the handler.
  ///
  /// When disposing the handler all buffers should be flushed, and any open
  /// resources have to be closed.
  ///
  void dispose() {}
}
```

In practice:

```Dart
import 'package:monolog/monolog.dart';

class PrintingHandler implements Handler {
  @override
  bool handle(Record record) {
	print(record.message);

    return true;
  }

  @override
  void handleBatch(List<Record> records) => records.forEach((e) => handle(e));

  @override
  bool handles(int level) => true;

  @override
  void dispose() {}
}

final logger = Logger('logger', handlers: [PrintingHandler()]);
```