// ignore_for_file: prefer_final_parameters

import '../nodes/parse.dart';
import '../nodes/synthetic_impl.dart';
import '../nodes/synthetic_interface.dart';

/// Transformer that creates an identical copy of the visited nodes.
///
/// Subclass can override one or more of the methods to modify the generated
/// copy.
class XmlTransformer implements XmlVisitor<XmlNode> {
  const XmlTransformer();

  @override
  XmlCDATA visitCDATA(XmlCDATA node) => XmlCDATASyntheticImpl(node.text);

  @override
  XmlComment visitComment(XmlComment node) => XmlCommentSyntheticImpl(node.text);

  @override
  XmlDeclaration visitDeclaration(XmlDeclaration node) =>
      XmlDeclarationSyntheticImpl(node.attributes.map(visitAttribute));

  @override
  XmlDoctype visitDoctype(XmlDoctype node) => XmlDoctypeSyntheticImpl(node.text);

  @override
  XmlDocument visitDocument(XmlDocument node) =>
      XmlDocumentSyntheticImpl(node.children.map((final a) => a.accept(this)));

  @override
  XmlDocumentFragment visitDocumentFragment(XmlDocumentFragment node) =>
      XmlDocumentFragmentSyntheticImpl(node.children.map((final a) => a.accept(this)));

  @override
  XmlElement visitElement(XmlElement node) => XmlElementSyntheticImpl(
      visitName(node.name),
      node.attributes.map(visitAttribute),
      node.children.map((final a) => a.accept(this)),
      node.isSelfClosing);

  @override
  XmlProcessing visitProcessing(XmlProcessing node) => XmlProcessingSyntheticImpl(node.target, node.text);

  @override
  XmlText visitText(XmlText node) => XmlTextSyntheticImpl(node.text);

  @override
  XmlAttribute visitAttribute(XmlAttribute node) =>
      XmlAttributeSyntheticImpl(visitName(node.name), node.value, node.attributeType);

  @override
  XmlName visitName(XmlName name) => createXmlNameFromString(name.qualified);
}
