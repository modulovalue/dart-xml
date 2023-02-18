/// XML position printer.
// ignore_for_file: prefer_final_parameters

import 'dart:io';
import 'dart:math';

import 'package:args/args.dart' as args;
import 'package:petitparser/petitparser.dart';
import 'package:xml/xml.dart';

final args.ArgParser argumentParser = args.ArgParser()
  ..addOption(
    'position',
    abbr: 'p',
    help: 'Print character index instead of line:column.',
    allowed: ['start', 'stop', 'startstop', 'line', 'column', 'linecolumn'],
    defaultsTo: 'linecolumn',
  )
  ..addOption(
    'limit',
    abbr: 'l',
    help: 'Limit output to the specified number of characters.',
    defaultsTo: '60',
  );

void printUsage() {
  stdout.writeln('Usage: xml_pos [options] {files}');
  stdout.writeln();
  stdout.writeln(argumentParser.usage);
  exit(1);
}

void main(List<String> arguments) {
  final files = <File>[];
  final results = argumentParser.parse(arguments);
  final position = results['position'] as String;
  final limit = int.parse(results['limit'] as String);
  for (final argument in results.rest) {
    final file = File(argument);
    if (file.existsSync()) {
      files.add(file);
    } else {
      stderr.writeln('File not found: $file');
      exit(2);
    }
  }
  if (files.isEmpty) {
    printUsage();
  }

  for (final file in files) {
    final result = parser.parse(file.readAsStringSync());
    if (result.isFailure) {
      stdout.writeln('Parse error in $file: $result.message');
      exit(3);
    }
    final XmlDocument document = result.value as XmlDocument;
    for (final node in document.descendants) {
      final token = tokens[node];
      if (token != null) {
        final positionString = outputPosition(position, token).padLeft(10);
        final tokenString = outputString(limit, token);
        stdout.writeln('$positionString: $tokenString');
      }
    }
    tokens.clear();
  }
}

String outputPosition(String position, Token<dynamic> token) {
  switch (position) {
    case 'start':
      return '${token.start}';
    case 'stop':
      return '${token.stop}';
    case 'startstop':
      return '${token.start}-${token.stop}';
    case 'line':
      return '${token.line}';
    case 'column':
      return '${token.column}';
    default:
      return '${token.line}:${token.column}';
  }
}

String outputString(int limit, Token<dynamic> token) {
  final input = token.input.trim();
  final index = input.indexOf('\n');
  final length = min(limit, index < 0 ? input.length : index);
  final output = input.substring(0, length);
  return output.length < input.length ? '$output...' : output;
}

// Custom parser that produces a mapping of nodes to tokens as a side-effect.

final Map<XmlNode, Token<dynamic>> tokens = {};

final Parser parser = XmlTreeGrammarDefinitionRegisterPosition(defaultEntityMapping).build<dynamic>();

class XmlTreeGrammarDefinitionRegisterPosition extends XmlTreeGrammarDefinition {
  XmlTreeGrammarDefinitionRegisterPosition(XmlEntityMapping entityMapping) : super(entityMapping);

  @override
  Parser<XmlCommentNaturalImpl> comment() => collectPosition(super.comment().cast());

  @override
  Parser<XmlCDATANaturalImpl> cdata() => collectPosition(super.cdata().cast());

  @override
  Parser<XmlDoctypeNaturalImpl> doctype() => collectPosition(super.doctype().cast());

  @override
  Parser<XmlDocumentNaturalImpl> document() => collectPosition(super.document().cast());

  @override
  Parser<XmlElementNaturalImpl> element() => collectPosition(super.element().cast());

  @override
  Parser<XmlProcessingNaturalImpl> processing() => collectPosition(super.processing().cast());

  Parser<T> collectPosition<T extends XmlNode>(Parser<T> parser) => parser.token().map((token) {
        tokens[token.value] = token;
        return token.value;
      });
}
