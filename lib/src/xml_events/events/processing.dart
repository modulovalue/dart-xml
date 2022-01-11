import '../../xml/utils/node_type.dart';
import '../event.dart';
import '../visitor.dart';
import '../range.dart';

/// Event of an XML processing node.
class XmlProcessingEvent extends XmlEvent {
  XmlProcessingEvent(this.target, this.text, [this.sourceRange]);

  final String target;

  final String text;

  final XmlEventSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.PROCESSING;

  @override
  void accept(XmlEventVisitor visitor) => visitor.visitProcessingEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode ^ target.hashCode;

  @override
  bool operator ==(Object other) =>
      other is XmlProcessingEvent &&
      other.target == target &&
      other.text == text;
}
