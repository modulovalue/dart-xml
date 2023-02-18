// ignore_for_file: prefer_final_parameters

import '../nodes/synthetic_interface.dart';

class XmlVisitorNodeType implements XmlVisitor<XmlNodeType?> {
  const XmlVisitorNodeType();

  @override
  XmlNodeType visitAttribute(XmlAttribute node) => XmlNodeType.ATTRIBUTE;

  @override
  XmlNodeType visitCDATA(XmlCDATA node) => XmlNodeType.CDATA;

  @override
  XmlNodeType visitComment(XmlComment node) => XmlNodeType.COMMENT;

  @override
  XmlNodeType visitDeclaration(XmlDeclaration node) => XmlNodeType.DECLARATION;

  @override
  XmlNodeType? visitDoctype(XmlDoctype node) => XmlNodeType.DOCUMENT_TYPE;

  @override
  XmlNodeType visitDocument(XmlDocument node) => XmlNodeType.DOCUMENT;

  @override
  XmlNodeType visitDocumentFragment(XmlDocumentFragment node) => XmlNodeType.DOCUMENT_FRAGMENT;

  @override
  XmlNodeType visitElement(XmlElement node) => XmlNodeType.ELEMENT;

  @override
  XmlNodeType visitName(XmlName name) => XmlNodeType.NAME;

  @override
  XmlNodeType visitProcessing(XmlProcessing node) => XmlNodeType.PROCESSING;

  @override
  XmlNodeType visitText(XmlText node) => XmlNodeType.TEXT;
}
// ignore_for_file: constant_identifier_names
/// Enum of the different XML Node types.
enum XmlNodeType {
  /// An attribute node, e.g. `id="123"`.
  ATTRIBUTE,

  /// Raw character data (CDATA), e.g.  `<![CDATA[escaped text]]>`.
  CDATA,

  /// A comment, e.g. `<!-- comment -->`.
  COMMENT,

  /// A xml declaration, e.g. `<?xml version='1.0'?>`.
  DECLARATION,

  /// A document type declaration, e.g. `<!DOCTYPE html>`.
  DOCUMENT_TYPE,

  /// A document object.
  DOCUMENT,

  /// A document fragment, e.g. `#document-fragment`.
  DOCUMENT_FRAGMENT,

  /// An element node, e.g. `<item>` or `<item />`.
  ELEMENT,

  /// A processing instruction, e.g. `<?pi test?>`.
  PROCESSING,

  TEXT,

  NAME,
}

