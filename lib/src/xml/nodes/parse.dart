import 'package:petitparser/petitparser.dart';

import '../../../xml.dart';
import '../utils/cache.dart';

/// Return an [XmlDocument] for the given [input] string, or throws an
/// [XmlParserException] if the input is invalid.
///
/// For example, the following code prints `Hello World`:
///
///    final document = new XmlDocument.parse('<?xml?><root message="Hello World" />');
///    print(document.rootElement.getAttribute('message'));
///
/// Note: It is the responsibility of the caller to provide a standard Dart
/// [String] using the default UTF-16 encoding.
XmlDocument parseXmlDocument(
  String input, {
  XmlEntityMapping? entityMapping,
}) {
  final mapping = entityMapping ?? defaultEntityMapping;
  final parser = _documentParserCache[mapping];
  final result = parser.parse(input);
  if (result.isFailure) {
    final lineAndColumn = Token.lineAndColumnOf(result.buffer, result.position);
    throw XmlParserException(result.message,
        buffer: result.buffer, position: result.position, line: lineAndColumn[0], column: lineAndColumn[1]);
  }
  return result.value;
}

/// Internal cache of parsers for a specific entity mapping.
final XmlCache<XmlEntityMapping, Parser> _documentParserCache =
    XmlCache((entityMapping) => XmlParserDefinition(entityMapping).build(), 5);

/// Return an [XmlDocumentFragment] for the given [input] string, or throws an
/// [XmlParserException] if the input is invalid.
///
/// Note: It is the responsibility of the caller to provide a standard Dart
/// [String] using the default UTF-16 encoding.
XmlDocumentFragment parseXmlDocumentFragment(
  String input, {
  XmlEntityMapping? entityMapping,
}) {
  final mapping = entityMapping ?? defaultEntityMapping;
  final parser = _documentFragmentParserCache[mapping];
  final result = parser.parse(input);
  if (result.isFailure) {
    final lineAndColumn = Token.lineAndColumnOf(result.buffer, result.position);
    throw XmlParserException(result.message,
        buffer: result.buffer, position: result.position, line: lineAndColumn[0], column: lineAndColumn[1]);
  }
  return result.value;
}

/// Internal cache of parsers for a specific entity mapping.
final XmlCache<XmlEntityMapping, Parser> _documentFragmentParserCache = XmlCache((entityMapping) {
  final definition = XmlParserDefinition(entityMapping);
  return definition.build(start: definition.documentFragment).end();
}, 5);

// TODO move into a factory file?
/// Creates a qualified [XmlName] from a `local` name and an optional
/// `prefix`.
XmlName createXmlName(String local, [String? prefix]) {
  if (prefix == null || prefix.isEmpty) {
    return XmlSimpleNameSyntheticImpl(local);
  } else {
    return XmlPrefixNameSyntheticImpl(prefix, local, '$prefix${XmlToken.namespace}$local');
  }
}

/// Create a [XmlName] by parsing the provided `qualified` name.
XmlName createXmlNameFromString(String qualified) {
  final index = qualified.indexOf(XmlToken.namespace);
  if (index > 0) {
    final prefix = qualified.substring(0, index);
    final local = qualified.substring(index + 1);
    return XmlPrefixNameSyntheticImpl(prefix, local, qualified);
  } else {
    return XmlSimpleNameSyntheticImpl(qualified);
  }
}
