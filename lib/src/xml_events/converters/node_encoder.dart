import 'dart:convert' show ChunkedConversionSink;

import '../../xml/nodes/interface.dart';
import '../event.dart';
import '../utils/list_converter.dart';

extension XmlNodeEncoderExtension on Stream<List<XmlNode>> {
  /// Converts a sequence of [XmlNode] objects to [XmlEvent] objects.
  Stream<List<XmlEvent>> toXmlEvents() => transform(const XmlNodeEncoder());
}

/// A converter that encodes a forest of [XmlNode] objects to a sequence of
/// [XmlEvent] objects.
class XmlNodeEncoder extends XmlListConverter<XmlNode, XmlEvent> {
  const XmlNodeEncoder();

  @override
  ChunkedConversionSink<List<XmlNode>> startChunkedConversion(Sink<List<XmlEvent>> sink) =>
      _XmlNodeEncoderSink(sink);
}

class _XmlNodeEncoderSink extends ChunkedConversionSink<List<XmlNode>> implements XmlVisitor<void> {
  _XmlNodeEncoderSink(this.sink);

  final Sink<List<XmlEvent>> sink;

  @override
  void add(List<XmlNode> chunk) {
    for (final a in chunk) {
      a.accept(this);
    }
  }

  @override
  void close() => sink.close();

  @override
  void visitElement(XmlElement node) {
    final isSelfClosing = node.isSelfClosing && node.children.isEmpty;
    sink.add([XmlStartElementEvent(node.name.qualified, convertAttributes(node.attributes), isSelfClosing)]);
    if (!isSelfClosing) {
      for (final a in node.children) {
        a.accept<void>(this);
      }
      sink.add([XmlEndElementEvent(node.name.qualified)]);
    }
  }

  @override
  void visitCDATA(XmlCDATA node) => sink.add([XmlCDATAEvent(node.text)]);

  @override
  void visitComment(XmlComment node) => sink.add([XmlCommentEvent(node.text)]);

  @override
  void visitDeclaration(XmlDeclaration node) =>
      sink.add([XmlDeclarationEvent(convertAttributes(node.attributes))]);

  @override
  void visitDoctype(XmlDoctype node) => sink.add([XmlDoctypeEvent(node.text)]);

  @override
  void visitProcessing(XmlProcessing node) => sink.add([XmlProcessingEvent(node.target, node.text)]);

  @override
  void visitText(XmlText node) => sink.add([XmlTextEvent(node.text)]);

  List<XmlEventAttribute> convertAttributes(List<XmlAttribute> attributes) => attributes
      .map((attribute) => XmlEventAttribute(
            attribute.name.qualified,
            attribute.value,
            attribute.attributeType,
          ))
      .toList(growable: false);

  @override
  void visitAttribute(XmlAttribute node) {}

  @override
  void visitDocument(XmlDocument node) {}

  @override
  void visitDocumentFragment(XmlDocumentFragment node) {}

  @override
  void visitName(XmlName name) {}
}
