import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../xml_events.dart';
import '../xml/nodes/interface.dart';
import '../xml/utils/namespace.dart';
import '../xml/utils/token.dart';
import '../xml/visitors/node_type.dart';

/// Event of an XML CDATA node.
class XmlCDATAEvent extends XmlEvent {
  XmlCDATAEvent(this.text, [this.sourceRange]);

  final String text;
  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.CDATA;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) => visitor.visitCDATAEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode;

  @override
  bool operator ==(Object other) => other is XmlCDATAEvent && other.text == text;
}

/// Event of an XML comment node.
class XmlCommentEvent extends XmlEvent {
  XmlCommentEvent(this.text, [this.sourceRange]);

  final String text;
  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.COMMENT;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) => visitor.visitCommentEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode;

  @override
  bool operator ==(Object other) => other is XmlCommentEvent && other.text == text;
}

/// Event of an XML declaration.
class XmlDeclarationEvent extends XmlEvent {
  XmlDeclarationEvent(this.attributes, [this.sourceRange]);

  final List<XmlEventAttribute> attributes;
  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.DECLARATION;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) => visitor.visitDeclarationEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ const ListEquality<dynamic>().hash(attributes);

  @override
  bool operator ==(Object other) =>
      other is XmlDeclarationEvent && const ListEquality<dynamic>().equals(other.attributes, attributes);
}

/// Event of an XML doctype node.
class XmlDoctypeEvent extends XmlEvent {
  XmlDoctypeEvent(this.text, [this.sourceRange]);

  final String text;
  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.DOCUMENT_TYPE;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) =>  visitor.visitDoctypeEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode;

  @override
  bool operator ==(Object other) => other is XmlDoctypeEvent && other.text == text;
}

/// Event of an closing XML element node.
class XmlEndElementEvent extends XmlEvent with XmlNamed {
  XmlEndElementEvent(this.name, [this.sourceRange]);

  @override
  final String name;
  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.ELEMENT;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) => visitor.visitEndElementEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) => other is XmlEndElementEvent && other.name == name;
}

/// Event of an XML processing node.
class XmlProcessingEvent extends XmlEvent {
  XmlProcessingEvent(this.target, this.text, [this.sourceRange]);

  final String target;

  final String text;

  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.PROCESSING;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) => visitor.visitProcessingEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode ^ target.hashCode;

  @override
  bool operator ==(Object other) =>
      other is XmlProcessingEvent && other.target == target && other.text == text;
}

/// Event of an XML start element node.
class XmlStartElementEvent extends XmlEvent with XmlNamed {
  XmlStartElementEvent(this.name, this.attributes, this.isSelfClosing, [this.sourceRange]);

  @override
  final String name;

  final List<XmlEventAttribute> attributes;

  final bool isSelfClosing;

  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.ELEMENT;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) => visitor.visitStartElementEvent(this);

  @override
  int get hashCode =>
      nodeType.hashCode ^ name.hashCode ^ isSelfClosing.hashCode ^ const ListEquality<dynamic>().hash(attributes);

  @override
  bool operator ==(Object other) =>
      other is XmlStartElementEvent &&
      other.name == name &&
      other.isSelfClosing == isSelfClosing &&
      const ListEquality<dynamic>().equals(other.attributes, attributes);
}

/// Event of an XML text node.
class XmlTextEvent extends XmlEvent {
  XmlTextEvent(this.text, [this.sourceRange]);

  final String text;

  @override
  final XmlSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.TEXT;

  @override
  T accept<T>(XmlEventVisitor<T> visitor) => visitor.visitTextEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode;

  @override
  bool operator ==(Object other) => other is XmlTextEvent && other.text == text;
}

/// Mixin with additional accessors for named objects.
mixin XmlNamed implements XmlParented {
  /// The fully qualified name.
  String get name;

  /// The fully qualified name (alias to name).
  String get qualifiedName => name;

  /// The namespace prefix, or `null`.
  String? get namespacePrefix {
    final index = name.indexOf(XmlToken.namespace);
    return index > 0 ? name.substring(0, index) : null;
  }

  /// The namespace URI, or `null`. Can only be resolved when the named entity
  /// has complete and up-to-date [XmlParented.parentEvent] information.
  String? get namespaceUri {
    // Identify the prefix and local name to match.
    final index = name.indexOf(XmlToken.namespace);
    final prefix = index < 0 ? null : xmlns;
    final local = index < 0 ? xmlns : name.substring(0, index);
    // Identify the start element to match.
    final start = this is XmlStartElementEvent ? this as XmlStartElementEvent : parentEvent;
    // Walk up the tree to find the matching namespace.
    for (var event = start; event != null; event = event.parentEvent) {
      for (final attribute in event.attributes) {
        if (attribute.namespacePrefix == prefix && attribute.localName == local) {
          return attribute.value;
        }
      }
    }
    // Namespace could not be identified.
    return null;
  }

  /// The local name, excluding the namespace prefix.
  String get localName {
    final index = name.indexOf(XmlToken.namespace);
    return index > 0 ? name.substring(index + 1) : name;
  }
}

/// Mixin with information about the parent event.
mixin XmlParented {
  /// Hold a lazy reference to the parent event.
  XmlStartElementEvent? _parentEvent;

  /// Return the parent event of type [XmlStartElementEvent], or `null`.
  ///
  /// The parent event is not set by default. It is only available if the
  /// event stream is annotated with [XmlWithParentEvents].
  XmlStartElementEvent? get parentEvent => _parentEvent;

  /// Internal helper to attach a parent to this child, do not call directly.
  @internal
  void attachParentEvent(XmlStartElementEvent? parentEvent) {
    if (_parentEvent != null) {
      throw StateError('Parent event already resolved.');
    }
    _parentEvent = parentEvent;
  }
}

/// Immutable attributes of XML events.
class XmlEventAttribute with XmlNamed, XmlParented {
  XmlEventAttribute(this.name, this.value, this.attributeType, [this.sourceRange]);

  @override
  final String name;

  final String value;

  final XmlAttributeType attributeType;

  final XmlSourceRange? sourceRange;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;

  @override
  bool operator ==(Object other) =>
      other is XmlEventAttribute &&
      other.name == name &&
      other.value == value &&
      other.attributeType == attributeType;
}

/// Immutable base class for all events.
abstract class XmlEvent with XmlParented {
  XmlEvent();

  /// Return the node type of this node.
  XmlNodeType get nodeType;

  /// Dispatch to the [visitor] based on event type.
  T accept<T>(XmlEventVisitor<T> visitor);

  @override
  String toString() => XmlEventEncoder().convert([this]);

  XmlSourceRange? get sourceRange;
}

/// Basic visitor over [XmlEvent] nodes.
abstract class XmlEventVisitor<T> {
  /// Visit an [XmlCDATAEvent] event.
  T visitCDATAEvent(XmlCDATAEvent event);

  /// Visit an [XmlCommentEvent] event.
  T visitCommentEvent(XmlCommentEvent event);

  /// Visit an [XmlDeclarationEvent] event.
  T visitDeclarationEvent(XmlDeclarationEvent event);

  /// Visit an [XmlDoctypeEvent] event.
  T visitDoctypeEvent(XmlDoctypeEvent event);

  /// Visit an [XmlEndElementEvent] event.
  T visitEndElementEvent(XmlEndElementEvent event);

  /// Visit an [XmlProcessingEvent] event.
  T visitProcessingEvent(XmlProcessingEvent event);

  /// Visit an [XmlStartElementEvent] event.
  T visitStartElementEvent(XmlStartElementEvent event);

  /// Visit an [XmlTextEvent] event.
  T visitTextEvent(XmlTextEvent event);
}
