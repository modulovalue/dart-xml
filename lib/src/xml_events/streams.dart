// ignore_for_file: prefer_final_parameters

import 'dart:convert';

import '../../xml.dart';
import '../xml/utils/predicate.dart';
import 'event.dart';
import 'utils/list_converter.dart';

extension XmlFlattenStreamExtension<T> on Stream<Iterable<T>> {
  /// Flattens a [Stream] of [Iterable] values of type [T] to a [Stream] of
  /// values of type [T].
  Stream<T> flatten() => expand((values) => values);
}

typedef EventHandler<T> = void Function(T event);

extension XmlForEachEventExtension on Stream<XmlEvent> {
  /// Executes the provided callbacks on each event of this stream.
  ///
  /// Completes the returned [Future] when all events of this stream have been
  /// processed.
  Future<void> forEachEvent({
    EventHandler<XmlCDATAEvent>? onCDATA,
    EventHandler<XmlCommentEvent>? onComment,
    EventHandler<XmlDeclarationEvent>? onDeclaration,
    EventHandler<XmlDoctypeEvent>? onDoctype,
    EventHandler<XmlEndElementEvent>? onEndElement,
    EventHandler<XmlProcessingEvent>? onProcessing,
    EventHandler<XmlStartElementEvent>? onStartElement,
    EventHandler<XmlTextEvent>? onText,
  }) =>
      forEach(_XmlForEachEventHandler(
        onCDATA: onCDATA,
        onComment: onComment,
        onDeclaration: onDeclaration,
        onDoctype: onDoctype,
        onEndElement: onEndElement,
        onProcessing: onProcessing,
        onStartElement: onStartElement,
        onText: onText,
      ));
}

extension XmlForEachEventListExtension on Stream<List<XmlEvent>> {
  /// Executes the provided callbacks on each event of this stream.
  ///
  /// Completes the returned [Future] when all events of this stream have been
  /// processed.
  Future<void> forEachEvent({
    EventHandler<XmlCDATAEvent>? onCDATA,
    EventHandler<XmlCommentEvent>? onComment,
    EventHandler<XmlDeclarationEvent>? onDeclaration,
    EventHandler<XmlDoctypeEvent>? onDoctype,
    EventHandler<XmlEndElementEvent>? onEndElement,
    EventHandler<XmlProcessingEvent>? onProcessing,
    EventHandler<XmlStartElementEvent>? onStartElement,
    EventHandler<XmlTextEvent>? onText,
  }) =>
      flatten().forEachEvent(
        onCDATA: onCDATA,
        onComment: onComment,
        onDeclaration: onDeclaration,
        onDoctype: onDoctype,
        onEndElement: onEndElement,
        onProcessing: onProcessing,
        onStartElement: onStartElement,
        onText: onText,
      );
}

class _XmlForEachEventHandler implements XmlEventVisitor<void> {
  const _XmlForEachEventHandler({
    this.onCDATA,
    this.onComment,
    this.onDeclaration,
    this.onDoctype,
    this.onEndElement,
    this.onProcessing,
    this.onStartElement,
    this.onText,
  });

  final EventHandler<XmlCDATAEvent>? onCDATA;
  final EventHandler<XmlCommentEvent>? onComment;
  final EventHandler<XmlDeclarationEvent>? onDeclaration;
  final EventHandler<XmlDoctypeEvent>? onDoctype;
  final EventHandler<XmlEndElementEvent>? onEndElement;
  final EventHandler<XmlProcessingEvent>? onProcessing;
  final EventHandler<XmlStartElementEvent>? onStartElement;
  final EventHandler<XmlTextEvent>? onText;

  void call(XmlEvent input) => input.accept(this);

  @override
  void visitCDATAEvent(XmlCDATAEvent event) => onCDATA?.call(event);

  @override
  void visitCommentEvent(XmlCommentEvent event) => onComment?.call(event);

  @override
  void visitDeclarationEvent(XmlDeclarationEvent event) => onDeclaration?.call(event);

  @override
  void visitDoctypeEvent(XmlDoctypeEvent event) => onDoctype?.call(event);

  @override
  void visitEndElementEvent(XmlEndElementEvent event) => onEndElement?.call(event);

  @override
  void visitProcessingEvent(XmlProcessingEvent event) => onProcessing?.call(event);

  @override
  void visitStartElementEvent(XmlStartElementEvent event) => onStartElement?.call(event);

  @override
  void visitTextEvent(XmlTextEvent event) => onText?.call(event);
}

extension XmlNormalizeEventsExtension on Stream<List<XmlEvent>> {
  /// Normalizes a sequence of [XmlEvent] objects by removing empty and
  /// combining adjacent text events.
  Stream<List<XmlEvent>> normalizeEvents() => transform(const XmlNormalizeEvents());
}

/// A converter that normalizes sequences of [XmlEvent] objects, namely combines
/// adjacent and removes empty text events.
class XmlNormalizeEvents extends XmlListConverter<XmlEvent, XmlEvent> {
  const XmlNormalizeEvents();

  @override
  ChunkedConversionSink<List<XmlEvent>> startChunkedConversion(Sink<List<XmlEvent>> sink) =>
      _XmlNormalizeEventsSink(sink);
}

class _XmlNormalizeEventsSink extends ChunkedConversionSink<List<XmlEvent>> {
  _XmlNormalizeEventsSink(this.sink);

  final Sink<List<XmlEvent>> sink;
  final List<XmlEvent> buffer = <XmlEvent>[];

  @override
  void add(List<XmlEvent> chunk) {
    // Filter out empty text nodes.
    buffer.addAll(chunk.where((event) => !(event is XmlTextEvent && event.text.isEmpty)));
    // Merge adjacent text nodes.
    for (var i = 0; i < buffer.length - 1;) {
      final event1 = buffer[i], event2 = buffer[i + 1];
      if (event1 is XmlTextEvent && event2 is XmlTextEvent) {
        final event = XmlTextEvent(event1.text + event2.text);
        event.attachParentEvent(event1.parentEvent);
        buffer[i] = event;
        buffer.removeAt(i + 1);
      } else {
        i++;
      }
    }
    // Move to sink whatever is possible.
    if (buffer.isNotEmpty) {
      if (buffer.last is XmlTextEvent) {
        if (buffer.length > 1) {
          sink.add(buffer.sublist(0, buffer.length - 1));
          buffer.removeRange(0, buffer.length - 1);
        }
      } else {
        sink.add(buffer.toList(growable: false));
        buffer.clear();
      }
    }
  }

  @override
  void close() {
    if (buffer.isNotEmpty) {
      sink.add(buffer.toList(growable: false));
      buffer.clear();
    }
    sink.close();
  }
}

extension XmlSubtreeSelectorExtension on Stream<List<XmlEvent>> {
  /// From a sequence of [XmlEvent] objects filter the event sequences that
  /// form sub-trees for which [predicate] returns `true`.
  Stream<List<XmlEvent>> selectSubtreeEvents(Predicate<XmlStartElementEvent> predicate) =>
      transform(XmlSubtreeSelector(predicate));
}

/// A converter that selects [XmlEvent] objects that are part of a sub-tree
/// started by an [XmlStartElementEvent] satisfying the provided predicate.
class XmlSubtreeSelector extends XmlListConverter<XmlEvent, XmlEvent> {
  const XmlSubtreeSelector(this.predicate);

  final Predicate<XmlStartElementEvent> predicate;

  @override
  ChunkedConversionSink<List<XmlEvent>> startChunkedConversion(Sink<List<XmlEvent>> sink) =>
      _XmlSubtreeSelectorSink(sink, predicate);
}

class _XmlSubtreeSelectorSink extends ChunkedConversionSink<List<XmlEvent>> {
  _XmlSubtreeSelectorSink(this.sink, this.predicate);

  final Sink<List<XmlEvent>> sink;
  final Predicate<XmlStartElementEvent> predicate;
  final List<XmlStartElementEvent> stack = [];

  @override
  void add(List<XmlEvent> chunk) {
    final result = <XmlEvent>[];
    for (final event in chunk) {
      if (stack.isEmpty) {
        if (event is XmlStartElementEvent && predicate(event)) {
          if (!event.isSelfClosing) {
            stack.add(event);
          }
          result.add(event);
        }
      } else {
        if (event is XmlStartElementEvent && !event.isSelfClosing) {
          stack.add(event);
        } else if (event is XmlEndElementEvent) {
          XmlTagException.checkClosingTag(stack.last.name, event.name);
          stack.removeLast();
        }
        result.add(event);
      }
    }
    if (result.isNotEmpty) {
      sink.add(result);
    }
  }

  @override
  void close() {
    sink.close();
  }
}

extension XmlWithParentEventsExtension on Stream<List<XmlEvent>> {
  /// Annotates a stream of [XmlEvent] objects with parent events. The parent
  /// events are thereafter accessible through [XmlParented.parentEvent].
  ///
  /// [XmlEndElementEvent] are parented to their corresponding
  /// [XmlStartElementEvent]. Throws an [XmlTagException] is the nesting
  /// is invalid.
  Stream<List<XmlEvent>> withParentEvents() => transform(const XmlWithParentEvents());
}

/// A converter that annotates [XmlEvent] objects with their parent events.
class XmlWithParentEvents extends XmlListConverter<XmlEvent, XmlEvent> {
  const XmlWithParentEvents();

  @override
  ChunkedConversionSink<List<XmlEvent>> startChunkedConversion(Sink<List<XmlEvent>> sink) =>
      _XmlWithParentEventsSink(sink);
}

class _XmlWithParentEventsSink extends ChunkedConversionSink<List<XmlEvent>> implements XmlEventVisitor<void> {
  _XmlWithParentEventsSink(this.sink);

  final Sink<List<XmlEvent>> sink;
  XmlStartElementEvent? currentParent;

  @override
  void add(List<XmlEvent> events) {
    for (final a in events) {
      a.accept(this);
    }
    sink.add(events);
  }

  @override
  void close() {
    if (currentParent != null) {
      throw XmlTagException.missingClosingTag(currentParent!.name);
    }
    sink.close();
  }

  @override
  void visitCDATAEvent(XmlCDATAEvent event) => event.attachParentEvent(currentParent);

  @override
  void visitCommentEvent(XmlCommentEvent event) => event.attachParentEvent(currentParent);

  @override
  void visitDeclarationEvent(XmlDeclarationEvent event) => event.attachParentEvent(currentParent);

  @override
  void visitDoctypeEvent(XmlDoctypeEvent event) => event.attachParentEvent(currentParent);

  @override
  void visitEndElementEvent(XmlEndElementEvent event) {
    if (currentParent == null) {
      throw XmlTagException.unexpectedClosingTag(event.name);
    } else if (currentParent!.name != event.name) {
      throw XmlTagException.mismatchClosingTag(currentParent!.name, event.name);
    }
    event.attachParentEvent(currentParent);
    currentParent = currentParent!.parentEvent;
  }

  @override
  void visitProcessingEvent(XmlProcessingEvent event) => event.attachParentEvent(currentParent);

  @override
  void visitStartElementEvent(XmlStartElementEvent event) {
    event.attachParentEvent(currentParent);
    for (final attribute in event.attributes) {
      attribute.attachParentEvent(event);
    }
    if (!event.isSelfClosing) {
      currentParent = event;
    }
  }

  @override
  void visitTextEvent(XmlTextEvent event) => event.attachParentEvent(currentParent);
}
