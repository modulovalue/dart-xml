import '../../xml/utils/node_type.dart';
import '../event.dart';
import '../utils/named.dart';
import '../visitor.dart';
import '../range.dart';

/// Event of an closing XML element node.
class XmlEndElementEvent extends XmlEvent with XmlNamed {
  XmlEndElementEvent(this.name, [this.sourceRange]);

  @override
  final String name;
  final XmlEventSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.ELEMENT;

  @override
  void accept(XmlEventVisitor visitor) => visitor.visitEndElementEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      other is XmlEndElementEvent && other.name == name;
}
