import 'package:collection/collection.dart' show ListEquality;

import '../../xml/utils/node_type.dart';
import '../event.dart';
import '../utils/event_attribute.dart';
import '../visitor.dart';
import '../range.dart';

/// Event of an XML declaration.
class XmlDeclarationEvent extends XmlEvent {
  XmlDeclarationEvent(this.attributes, [this.sourceRange]);

  final List<XmlEventAttribute> attributes;
  final XmlEventSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.DECLARATION;

  @override
  void accept(XmlEventVisitor visitor) => visitor.visitDeclarationEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ const ListEquality().hash(attributes);

  @override
  bool operator ==(Object other) =>
      other is XmlDeclarationEvent &&
      const ListEquality().equals(other.attributes, attributes);
}
