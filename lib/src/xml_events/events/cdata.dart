import '../../xml/utils/node_type.dart';
import '../event.dart';
import '../visitor.dart';
import '../range.dart';

/// Event of an XML CDATA node.
class XmlCDATAEvent extends XmlEvent {
  XmlCDATAEvent(this.text, [this.sourceRange]);

  final String text;
  final XmlEventSourceRange? sourceRange;

  @override
  XmlNodeType get nodeType => XmlNodeType.CDATA;

  @override
  void accept(XmlEventVisitor visitor) => visitor.visitCDATAEvent(this);

  @override
  int get hashCode => nodeType.hashCode ^ text.hashCode;

  @override
  bool operator ==(Object other) =>
      other is XmlCDATAEvent && other.text == text;
}
