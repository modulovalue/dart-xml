import '../../../xml.dart';
import '../visitors/node_type.dart';
import 'base.dart';

/// XML document fragment node.
class XmlDocumentFragmentSyntheticImpl extends XmlDocumentFragmentBase {
  /// Create a document fragment node with `children`.
  XmlDocumentFragmentSyntheticImpl([
    Iterable<XmlNode> childrenIterable = const [],
  ]) {
    children.initialize(this, {
      XmlNodeType.CDATA,
      XmlNodeType.COMMENT,
      XmlNodeType.DECLARATION,
      XmlNodeType.DOCUMENT_TYPE,
      XmlNodeType.ELEMENT,
      XmlNodeType.PROCESSING,
      XmlNodeType.TEXT,
    });
    children.addAll(childrenIterable);
  }

  @override
  XmlDocumentFragmentSyntheticImpl copy() =>
      XmlDocumentFragmentSyntheticImpl(children.map((each) => each.copy()));
}

/// XML document node.
class XmlDocumentSyntheticImpl extends XmlDocumentBase {
  /// Create a document node with `children`.
  XmlDocumentSyntheticImpl([
    Iterable<XmlNode> childrenIterable = const [],
  ]) {
    children.initialize(this, {
      XmlNodeType.CDATA,
      XmlNodeType.COMMENT,
      XmlNodeType.DECLARATION,
      XmlNodeType.DOCUMENT_TYPE,
      XmlNodeType.ELEMENT,
      XmlNodeType.PROCESSING,
      XmlNodeType.TEXT,
    });
    children.addAll(childrenIterable);
  }

  @override
  XmlDocument copy() => XmlDocumentSyntheticImpl(children.map((each) => each.copy()));
}

/// XML CDATA node.
class XmlCDATASyntheticImpl extends XmlCDDATABase {
  /// Create a CDATA section with `text`.
  XmlCDATASyntheticImpl(this.text);

  @override
  String text;

  @override
  XmlCDATA copy() => XmlCDATASyntheticImpl(text);
}

/// XML attribute node.
class XmlAttributeSyntheticImpl extends XmlAttributeBase {
  /// Create an attribute with `name` and `value`.
  XmlAttributeSyntheticImpl(
    this.name,
    this.value, [
    this.attributeType = XmlAttributeType.DOUBLE_QUOTE,
  ]) {
    name.attachParent(this);
  }

  @override
  final XmlName name;

  @override
  String value;

  @override
  final XmlAttributeType attributeType;

  @override
  XmlAttribute copy() => XmlAttributeSyntheticImpl(name.copy(), value, attributeType);
}

/// XML comment node.
class XmlCommentSyntheticImpl extends XmlCommentBase {
  /// Create a comment section with `text`.
  XmlCommentSyntheticImpl(this.text);

  @override
  String text;

  @override
  XmlCommentSyntheticImpl copy() => XmlCommentSyntheticImpl(text);
}

/// XML document declaration.
class XmlDeclarationSyntheticImpl extends XmlDeclarationBase {
  XmlDeclarationSyntheticImpl([
    Iterable<XmlAttribute> attributesIterable = const [],
  ]) {
    attributes.initialize(this, {
      XmlNodeType.ATTRIBUTE,
    });
    attributes.addAll(attributesIterable);
  }

  @override
  XmlDeclaration copy() => XmlDeclarationSyntheticImpl(attributes.map((each) => each.copy()));
}

/// XML doctype node.
class XmlDoctypeSyntheticImpl extends XmlDoctypeBase {
  /// Create a doctype section with `text`.
  XmlDoctypeSyntheticImpl(
    this.text,
  );

  @override
  String text;

  @override
  XmlDoctype copy() => XmlDoctypeSyntheticImpl(text);
}

/// XML element node.
class XmlElementSyntheticImpl extends XmlElementBase {
  /// Create an element node with the provided [name], [attributes], and
  /// [children].
  XmlElementSyntheticImpl(
    this.name, [
    Iterable<XmlAttribute> attributesIterable = const [],
    Iterable<XmlNode> childrenIterable = const [],
    this.isSelfClosing = true,
  ]) {
    name.attachParent(this);
    attributes.initialize(this, {
      XmlNodeType.ATTRIBUTE,
    });
    attributes.addAll(attributesIterable);
    children.initialize(this, {
      XmlNodeType.CDATA,
      XmlNodeType.COMMENT,
      XmlNodeType.ELEMENT,
      XmlNodeType.PROCESSING,
      XmlNodeType.TEXT,
    });
    children.addAll(childrenIterable);
  }

  @override
  bool isSelfClosing;

  @override
  final XmlName name;

  @override
  XmlElement copy() => XmlElementSyntheticImpl(
      name.copy(), attributes.map((each) => each.copy()), children.map((each) => each.copy()), isSelfClosing);
}

/// XML processing instruction.
class XmlProcessingSyntheticImpl extends XmlProcessingBase {
  /// Create a processing node with `target` and `text`.
  XmlProcessingSyntheticImpl(
    this.target,
    this.text,
  );

  @override
  String text;

  @override
  final String target;

  @override
  XmlProcessing copy() => XmlProcessingSyntheticImpl(target, text);
}

/// XML text node.
class XmlTextSyntheticImpl extends XmlTextBase {
  /// Create a text node with `text`.
  XmlTextSyntheticImpl(
    this.text,
  );

  @override
  String text;

  @override
  XmlText copy() => XmlTextSyntheticImpl(text);
}

/// An XML entity name with a prefix.
class XmlPrefixNameSyntheticImpl extends XmlPrefixNameBase {
  XmlPrefixNameSyntheticImpl(
    this.prefix,
    this.local,
    this.qualified,
  );

  @override
  final String prefix;

  @override
  final String local;

  @override
  final String qualified;

  @override
  XmlPrefixName copy() => XmlPrefixNameSyntheticImpl(prefix, local, qualified);
}

/// An XML entity name without a prefix.
class XmlSimpleNameSyntheticImpl extends XmlSimpleNameBase {
  XmlSimpleNameSyntheticImpl(
    this.local,
  );

  @override
  final String local;

  @override
  XmlSimpleName copy() => XmlSimpleNameSyntheticImpl(local);
}

/// Known attribute names.
const versionAttribute = 'version';
const encodingAttribute = 'encoding';
const standaloneAttribute = 'standalone';
