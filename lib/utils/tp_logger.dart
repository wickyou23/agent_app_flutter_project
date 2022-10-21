//LOGGER

import 'dart:convert';
import 'dart:io';
import 'package:agent_app/res/res.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

late Logger logger;

Future<String> getLoggerPath() async {
  final directory = await getTemporaryDirectory();
  final fullPath = '${directory.path}/tp_hola.log';
  return fullPath;
}

Future<void> setupLogger() async {
  if (kReleaseMode) {
    final path = await getLoggerPath();
    logger = Logger(
      filter: ReleaseModeFilter(),
      printer: TPLogPrinter(),
      output: FileOutput(file: File(path)),
    );
  } else {
    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
        printTime: true,
        colors: false,
      ),
    );
  }
}

class FileOutput extends LogOutput {
  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  @override
  void init() {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    final logStr = '${event.lines.join('\n')}\n';
    _sink?.write(logStr);
  }

  @override
  void destroy() {
    _sink?.flush();
    _sink?.close();
  }
}

class ReleaseModeFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class TPLogPrinter extends LogPrinter {
  static final _deviceStackTraceRegex =
      RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  @override
  List<String> log(LogEvent event) {
    final messageStr = stringifyMessage(event.message);
    final timeStr = DateTime.now().csToString('yyyy-MM-dd hh:mm:ss.SSSSSS');
    final stackTraceStr = formatStackTrace(StackTrace.current) ?? '';
    return ['[$timeStr][$stackTraceStr] $messageStr'];
  }

  String stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message.call() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      final encoder = JsonEncoder.withIndent('  ', toEncodableFallback);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }

  Object toEncodableFallback(dynamic object) {
    return object.toString();
  }

  String? formatStackTrace(StackTrace? stackTrace) {
    final lines = stackTrace.toString().split('\n');
    var formatted = '';
    if (lines.length > 3) {
      final line = lines[3];
      if (line.isNotEmpty) {
        final match = _deviceStackTraceRegex.matchAsPrefix(line);
        if (match == null) {
          formatted = line;
        } else {
          formatted = match.group(1)!;
        }

        formatted = formatted.replaceFirst(RegExp(r'#\d+\s+'), '');
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted;
    }
  }
}
