/// Dart XML is a lightweight library for parsing, traversing, querying and
/// building XML documents.
import 'src/xml/entities/entity_mapping.dart';
import 'src/xml/nodes/parse.dart';
import 'src/xml/nodes/synthetic_interface.dart';
import 'src/xml/utils/exceptions.dart';

export 'src/xml/builder.dart' show XmlBuilder;
export 'src/xml/entities/default_mapping.dart' show defaultEntityMapping, XmlDefaultEntityMapping;
export 'src/xml/entities/entity_mapping.dart' show XmlEntityMapping;
export 'src/xml/entities/null_mapping.dart' show XmlNullEntityMapping;
export 'src/xml/navigation/navigation.dart';
export 'src/xml/nodes/synthetic_impl.dart';
export 'src/xml/nodes/synthetic_interface.dart';
export 'src/xml/parser.dart';
export 'src/xml/utils/attribute_type.dart' show XmlAttributeType;
export 'src/xml/utils/exceptions.dart'
    show XmlException, XmlParserException, XmlNodeTypeException, XmlParentException, XmlTagException;
export 'src/xml/utils/token.dart' show XmlToken;
export 'src/xml/visitors/normalizer.dart' show XmlNormalizerExtension;
export 'src/xml/visitors/pretty_writer.dart' show XmlPrettyWriter;
export 'src/xml/visitors/transformer.dart' show XmlTransformer;
export 'src/xml/visitors/writer.dart' show XmlWriter;

/// Return an [XmlDocument] for the given [input] string, or throws an
/// [XmlParserException] if the input is invalid.
///
/// For example, the following code prints `Hello World`:
///
///    final document = parse('<?xml?><root message="Hello World" />');
///    print(document.rootElement.getAttribute('message'));
///
/// Note: It is the responsibility of the caller to provide a standard Dart
/// [String] using the default UTF-16 encoding.
@Deprecated('Use `XmlDocument.parse` instead')
XmlDocument parse(String input, {XmlEntityMapping? entityMapping}) =>
    parseXmlDocument(input, entityMapping: entityMapping);
