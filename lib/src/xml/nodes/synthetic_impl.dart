import '../../../xml.dart';
import '../visitors/node_type.dart';
import 'base.dart';

class XmlDocumentFragmentSyntheticImpl extends XmlDocumentFragmentBase {
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

class XmlDocumentSyntheticImpl extends XmlDocumentBase {
  XmlDocumentSyntheticImpl(
    Iterable<XmlNode> childrenIterable,
  ) {
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

class XmlCDATASyntheticImpl extends XmlCDDATABase {
  XmlCDATASyntheticImpl(this.text);

  @override
  String text;

  @override
  XmlCDATA copy() => XmlCDATASyntheticImpl(text);
}

class XmlAttributeSyntheticImpl extends XmlAttributeBase {
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

class XmlCommentSyntheticImpl extends XmlCommentBase {
  XmlCommentSyntheticImpl(this.text);

  @override
  String text;

  @override
  XmlCommentSyntheticImpl copy() => XmlCommentSyntheticImpl(text);
}

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

class XmlDoctypeSyntheticImpl extends XmlDoctypeBase {
  XmlDoctypeSyntheticImpl(
    this.text,
  );

  @override
  String text;

  @override
  XmlDoctype copy() => XmlDoctypeSyntheticImpl(text);
}

class XmlElementSyntheticImpl extends XmlElementBase {
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

class XmlProcessingSyntheticImpl extends XmlProcessingBase {
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

class XmlTextSyntheticImpl extends XmlTextBase {
  XmlTextSyntheticImpl(
    this.text,
  );

  @override
  String text;

  @override
  XmlText copy() => XmlTextSyntheticImpl(text);
}

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
