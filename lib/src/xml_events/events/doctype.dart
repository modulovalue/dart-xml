import '../../xml/utils/node_type.dart';
import '../event.dart';
import '../visitor.dart';
import '../range.dart';

/// Event of an XML doctype node.
class XmlDoctypeEvent extends XmlEvent {
  XmlDoctypeEvent(this.text, [this.sourceRange]);

  final String text;
  final XmlEventSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.DOCUMENT_TYPE;

  @override
  void accept(XmlEventVisitor visitor) => visitor.visitDoctypeEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode;

  @override
  bool operator ==(Object other) =>
      other is XmlDoctypeEvent && other.text == text;
}
