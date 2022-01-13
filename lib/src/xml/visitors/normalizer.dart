import '../nodes/interface.dart';
import 'node_type.dart';

extension XmlNormalizerExtension on XmlNode {
  /// Puts all child nodes into a "normalized" form, that is no text nodes in
  /// the sub-tree are empty and there are no adjacent text nodes.
  void normalize() => accept(const XmlNormalizer());
}

/// Normalizes a node tree in-place.
class XmlNormalizer implements XmlVisitor<void> {
  const XmlNormalizer();

  @Deprecated('Use `const XmlNormalizer()`.')
  static const XmlNormalizer defaultInstance = XmlNormalizer();

  @override
  void visitDocument(XmlDocument node) => _normalize(node.children);

  @override
  void visitDocumentFragment(XmlDocumentFragment node) => _normalize(node.children);

  @override
  void visitElement(XmlElement node) => _normalize(node.children);

  void _normalize(List<XmlNode> children) {
    _removeEmpty(children);
    _mergeAdjacent(children);
    for (final a in children) {
      a.accept(this);
    }
  }

  void _removeEmpty(List<XmlNode> children) {
    for (var i = 0; i < children.length;) {
      final node = children[i];
      if (node.accept(const XmlVisitorNodeType()) == XmlNodeType.TEXT && node.text.isEmpty) {
        children.removeAt(i);
      } else {
        i++;
      }
    }
  }

  void _mergeAdjacent(List<XmlNode> children) {
    XmlText? previousText;
    for (var i = 0; i < children.length;) {
      final node = children[i];
      if (node is XmlText) {
        if (previousText == null) {
          previousText = node;
          i++;
        } else {
          previousText.text += node.text;
          children.removeAt(i);
        }
      } else {
        previousText = null;
        i++;
      }
    }
  }

  @override
  void visitAttribute(XmlAttribute node) {}

  @override
  void visitCDATA(XmlCDATA node) {}

  @override
  void visitComment(XmlComment node) {}

  @override
  void visitDeclaration(XmlDeclaration node) {}

  @override
  void visitDoctype(XmlDoctype node) {}

  @override
  void visitName(XmlName name) {}

  @override
  void visitProcessing(XmlProcessing node) {}

  @override
  void visitText(XmlText node) {}
}
