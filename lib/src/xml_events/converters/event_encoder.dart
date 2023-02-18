// ignore_for_file: prefer_final_parameters

import 'dart:convert' show Converter, ChunkedConversionSink;

import '../../xml/entities/default_mapping.dart';
import '../../xml/entities/entity_mapping.dart';
import '../../xml/utils/token.dart';
import '../event.dart';
import '../utils/conversion_sink.dart';

extension XmlEventEncoderExtension on Stream<List<XmlEvent>> {
  /// Converts a sequence of [XmlEvent] objects to a [String].
  Stream<String> toXmlString({XmlEntityMapping? entityMapping}) =>
      transform(XmlEventEncoder(entityMapping: entityMapping));
}

/// A converter that encodes a sequence of [XmlEvent] objects to a [String].
class XmlEventEncoder extends Converter<List<XmlEvent>, String> {
  XmlEventEncoder({XmlEntityMapping? entityMapping}) : entityMapping = entityMapping ?? defaultEntityMapping;

  final XmlEntityMapping entityMapping;

  @override
  String convert(List<XmlEvent> input) {
    final buffer = StringBuffer();
    final sink = ConversionSink<String>(buffer.write);
    startChunkedConversion(sink)
      ..add(input)
      ..close();
    return buffer.toString();
  }

  @override
  ChunkedConversionSink<List<XmlEvent>> startChunkedConversion(Sink<String> sink) =>
      _XmlEventEncoderSink(sink, entityMapping);
}

class _XmlEventEncoderSink extends ChunkedConversionSink<List<XmlEvent>> implements XmlEventVisitor<void> {
  _XmlEventEncoderSink(this.sink, this.entityMapping);

  final Sink<String> sink;
  final XmlEntityMapping entityMapping;

  @override
  void add(List<XmlEvent> chunk) {
    for (final a in chunk) {
      a.accept(this);
    }
  }

  @override
  void close() => sink.close();

  @override
  void visitCDATAEvent(XmlCDATAEvent event) {
    sink.add(XmlToken.openCDATA);
    sink.add(event.text);
    sink.add(XmlToken.closeCDATA);
  }

  @override
  void visitCommentEvent(XmlCommentEvent event) {
    sink.add(XmlToken.openComment);
    sink.add(event.text);
    sink.add(XmlToken.closeComment);
  }

  @override
  void visitDeclarationEvent(XmlDeclarationEvent event) {
    sink.add(XmlToken.openDeclaration);
    addAttributes(event.attributes);
    sink.add(XmlToken.closeDeclaration);
  }

  @override
  void visitDoctypeEvent(XmlDoctypeEvent event) {
    sink.add(XmlToken.openDoctype);
    sink.add(XmlToken.whitespace);
    sink.add(event.text);
    sink.add(XmlToken.closeDoctype);
  }

  @override
  void visitEndElementEvent(XmlEndElementEvent event) {
    sink.add(XmlToken.openEndElement);
    sink.add(event.name);
    sink.add(XmlToken.closeElement);
  }

  @override
  void visitProcessingEvent(XmlProcessingEvent event) {
    sink.add(XmlToken.openProcessing);
    sink.add(event.target);
    if (event.text.isNotEmpty) {
      sink.add(XmlToken.whitespace);
      sink.add(event.text);
    }
    sink.add(XmlToken.closeProcessing);
  }

  @override
  void visitStartElementEvent(XmlStartElementEvent event) {
    sink.add(XmlToken.openElement);
    sink.add(event.name);
    addAttributes(event.attributes);
    if (event.isSelfClosing) {
      sink.add(XmlToken.closeEndElement);
    } else {
      sink.add(XmlToken.closeElement);
    }
  }

  @override
  void visitTextEvent(XmlTextEvent event) {
    sink.add(entityMapping.encodeText(event.text));
  }

  void addAttributes(List<XmlEventAttribute> attributes) {
    for (final attribute in attributes) {
      sink.add(XmlToken.whitespace);
      sink.add(attribute.name);
      sink.add(XmlToken.equals);
      sink.add(entityMapping.encodeAttributeValueWithQuotes(
        attribute.value,
        attribute.attributeType,
      ));
    }
  }
}
