// ignore_for_file: prefer_final_parameters

import '../../../xml.dart';
import '../visitors/node_type.dart';
import 'base.dart';
import 'mixin.dart';

class XmlDocumentFragmentSyntheticImpl extends XmlDocumentFragmentBase {
  XmlDocumentFragmentSyntheticImpl([
    Iterable<XmlNode> childrenIterable = const [],
  ]) {
    children.addAll(childrenIterable);
  }

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {
    XmlNodeType.CDATA,
    XmlNodeType.COMMENT,
    XmlNodeType.DECLARATION,
    XmlNodeType.DOCUMENT_TYPE,
    XmlNodeType.ELEMENT,
    XmlNodeType.PROCESSING,
    XmlNodeType.TEXT,
  });

  @override
  XmlDocumentFragmentSyntheticImpl copy() => XmlDocumentFragmentSyntheticImpl(
        children.map((each) => each.copy()),
      );
}

class XmlDocumentSyntheticImpl extends XmlDocumentBase {
  XmlDocumentSyntheticImpl(
    Iterable<XmlNode> childrenIterable,
  ) {
    children = XmlNodeList<XmlNode>(this, {
      XmlNodeType.CDATA,
      XmlNodeType.COMMENT,
      XmlNodeType.DECLARATION,
      XmlNodeType.DOCUMENT_TYPE,
      XmlNodeType.ELEMENT,
      XmlNodeType.PROCESSING,
      XmlNodeType.TEXT,
    })
      ..addAll(childrenIterable);
  }

  @override
  late final XmlNodeList<XmlNode> children;

  @override
  XmlDocument copy() => XmlDocumentSyntheticImpl(
        children.map((each) => each.copy()),
      );
}

class XmlCDATASyntheticImpl extends XmlCDDATABase {
  XmlCDATASyntheticImpl(this.text);

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

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
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

  @override
  final XmlName name;

  @override
  String value;

  @override
  final XmlAttributeType attributeType;

  @override
  XmlAttribute copy() => XmlAttributeSyntheticImpl(
        name.copy(),
        value,
        attributeType,
      );
}

class XmlCommentSyntheticImpl extends XmlCommentBase {
  XmlCommentSyntheticImpl(this.text);

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

  @override
  String text;

  @override
  XmlCommentSyntheticImpl copy() => XmlCommentSyntheticImpl(text);
}

class XmlDeclarationSyntheticImpl extends XmlDeclarationBase {
  XmlDeclarationSyntheticImpl([
    Iterable<XmlAttribute> attributesIterable = const [],
  ]) {
    attributes.addAll(attributesIterable);
  }

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

  @override
  late final XmlNodeList<XmlAttribute> attributes = XmlNodeList(this, {
    XmlNodeType.ATTRIBUTE,
  });

  @override
  XmlDeclaration copy() => XmlDeclarationSyntheticImpl(
        attributes.map((each) => each.copy()),
      );
}

class XmlDoctypeSyntheticImpl extends XmlDoctypeBase {
  XmlDoctypeSyntheticImpl(
    this.text,
  );

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

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
    attributes.addAll(attributesIterable);
    children.addAll(childrenIterable);
  }

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {
    XmlNodeType.CDATA,
    XmlNodeType.COMMENT,
    XmlNodeType.ELEMENT,
    XmlNodeType.PROCESSING,
    XmlNodeType.TEXT,
  });

  @override
  late final XmlNodeList<XmlAttribute> attributes = XmlNodeList(this, {
    XmlNodeType.ATTRIBUTE,
  });

  @override
  bool isSelfClosing;

  @override
  final XmlName name;

  @override
  XmlElement copy() => XmlElementSyntheticImpl(
        name.copy(),
        attributes.map((each) => each.copy()),
        children.map((each) => each.copy()),
        isSelfClosing,
      );
}

class XmlProcessingSyntheticImpl extends XmlProcessingBase {
  XmlProcessingSyntheticImpl(
    this.target,
    this.text,
  );

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

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
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

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
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

  @override
  final String prefix;

  @override
  final String local;

  @override
  final String qualified;

  @override
  XmlPrefixName copy() => XmlPrefixNameSyntheticImpl(
        prefix,
        local,
        qualified,
      );

  @override
  Z matchName<Z>({
    required final Z Function(XmlPrefixName) prefix,
    required final Z Function(XmlSimpleName) simple,
  }) =>
      prefix(this);
}

class XmlSimpleNameSyntheticImpl extends XmlSimpleNameBase {
  XmlSimpleNameSyntheticImpl(
    this.local,
  );

  @override
  late final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>(this, {});

  @override
  final String local;

  @override
  XmlSimpleName copy() => XmlSimpleNameSyntheticImpl(local);

  @override
  Z matchName<Z>({
    required final Z Function(XmlPrefixName) prefix,
    required final Z Function(XmlSimpleName) simple,
  }) =>
      simple(this);
}

/// Known attribute names.
const versionAttribute = 'version';
const encodingAttribute = 'encoding';
const standaloneAttribute = 'standalone';
