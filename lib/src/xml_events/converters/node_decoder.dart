import 'dart:convert' show ChunkedConversionSink;

import '../../xml/nodes/parse.dart';
import '../../xml/nodes/synthetic_impl.dart';
import '../../xml/nodes/synthetic_interface.dart';
import '../../xml/utils/exceptions.dart';
import '../event.dart';
import '../utils/list_converter.dart';

extension XmlNodeDecoderExtension on Stream<List<XmlEvent>> {
  /// Converts a sequence of [XmlEvent] objects to [XmlNode] objects.
  Stream<List<XmlNode>> toXmlNodes() => transform(const XmlNodeDecoder());
}

/// A converter that decodes a sequence of [XmlEvent] objects to a forest of
/// [XmlNode] objects.
class XmlNodeDecoder extends XmlListConverter<XmlEvent, XmlNode> {
  const XmlNodeDecoder();

  @override
  ChunkedConversionSink<List<XmlEvent>> startChunkedConversion(Sink<List<XmlNode>> sink) =>
      _XmlNodeDecoderSink(sink);
}

class _XmlNodeDecoderSink extends ChunkedConversionSink<List<XmlEvent>> implements XmlEventVisitor<void> {
  _XmlNodeDecoderSink(this.sink);

  final Sink<List<XmlNode>> sink;
  XmlElement? parent;

  @override
  void add(List<XmlEvent> chunk) {
    for (final a in chunk) {
      a.accept(this);
    }
  }

  @override
  void visitCDATAEvent(XmlCDATAEvent event) => commit(XmlCDATASyntheticImpl(event.text), event);

  @override
  void visitCommentEvent(XmlCommentEvent event) => commit(XmlCommentSyntheticImpl(event.text), event);

  @override
  void visitDeclarationEvent(XmlDeclarationEvent event) =>
      commit(XmlDeclarationSyntheticImpl(convertAttributes(event.attributes)), event);

  @override
  void visitDoctypeEvent(XmlDoctypeEvent event) => commit(XmlDoctypeSyntheticImpl(event.text), event);

  @override
  void visitEndElementEvent(XmlEndElementEvent event) {
    if (parent == null) {
      throw XmlTagException.unexpectedClosingTag(event.name);
    }
    final element = parent!;
    XmlTagException.checkClosingTag(element.name.qualified, event.name);
    parent = element.parentElement;
    if (parent == null) {
      commit(element, event.parentEvent);
    }
  }

  @override
  void visitProcessingEvent(XmlProcessingEvent event) =>
      commit(XmlProcessingSyntheticImpl(event.target, event.text), event);

  @override
  void visitStartElementEvent(XmlStartElementEvent event) {
    final element = XmlElementSyntheticImpl(
      createXmlNameFromString(event.name),
      convertAttributes(event.attributes),
      [],
      event.isSelfClosing,
    );
    if (event.isSelfClosing) {
      commit(element, event);
    } else {
      if (parent != null) {
        parent!.children.add(element);
      }
      parent = element;
    }
  }

  @override
  void visitTextEvent(XmlTextEvent event) => commit(XmlTextSyntheticImpl(event.text), event);

  @override
  void close() {
    if (parent != null) {
      throw XmlTagException.missingClosingTag(parent!.name.qualified);
    }
    sink.close();
  }

  void commit(XmlNode node, XmlEvent? event) {
    if (parent == null) {
      // If we have information about a parent event, create hidden
      // [XmlElement] nodes to make sure namespace resolution works
      // as expected.
      for (var outerElement = node, outerEvent = event?.parentEvent;
          outerEvent != null;
          outerEvent = outerEvent.parentEvent) {
        outerElement = XmlElementSyntheticImpl(
          createXmlNameFromString(outerEvent.name),
          convertAttributes(outerEvent.attributes),
          [outerElement],
          outerEvent.isSelfClosing,
        );
      }
      sink.add(<XmlNode>[node]);
    } else {
      parent!.children.add(node);
    }
  }

  Iterable<XmlAttribute> convertAttributes(Iterable<XmlEventAttribute> attributes) =>
      attributes.map((attribute) => XmlAttributeSyntheticImpl(
          createXmlNameFromString(attribute.name), attribute.value, attribute.attributeType));
}
