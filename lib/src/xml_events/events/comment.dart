import '../../xml/utils/node_type.dart';
import '../event.dart';
import '../visitor.dart';
import '../range.dart';

/// Event of an XML comment node.
class XmlCommentEvent extends XmlEvent {
  XmlCommentEvent(this.text, [this.sourceRange]);

  final String text;
  final XmlEventSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.COMMENT;

  @override
  void accept(XmlEventVisitor visitor) => visitor.visitCommentEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode;

  @override
  bool operator ==(Object other) =>
      other is XmlCommentEvent && other.text == text;
}
