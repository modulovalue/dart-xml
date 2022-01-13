import '../../../xml.dart';
import '../utils/namespace.dart';

mixin XmlDocumentFragmentMixin implements XmlDocumentFragment {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitDocumentFragment(this);
}

mixin XmlDocumentMixin implements XmlDocument {
  @override
  XmlDeclaration? get declaration {
    for (final node in children) {
      if (node is XmlDeclaration) {
        return node;
      }
    }
    return null;
  }

  @override
  XmlDoctype? get doctypeElement {
    for (final node in children) {
      if (node is XmlDoctype) {
        return node;
      }
    }
    return null;
  }

  @override
  XmlElement get rootElement {
    for (final node in children) {
      if (node is XmlElement) {
        return node;
      }
    }
    throw StateError('Empty XML document');
  }

  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitDocument(this);
}

mixin XmlCDATAMixin implements XmlCDATA {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitCDATA(this);
}

mixin XmlAttributeMixin implements XmlAttribute {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitAttribute(this);
}

mixin XmlCommentMixin implements XmlComment {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitComment(this);
}

mixin XmlDeclarationMixin implements XmlDeclaration {
  @override
  String? get version => getAttribute(versionAttribute);

  @override
  set version(String? value) => setAttribute(versionAttribute, value);

  @override
  String? get encoding => getAttribute(encodingAttribute);

  @override
  set encoding(String? value) => setAttribute(encodingAttribute, value);

  @override
  bool get standalone => getAttribute(standaloneAttribute) == 'yes';

  @override
  set standalone(bool? value) => setAttribute(
      standaloneAttribute,
      value == null
          ? null
          : value
              ? 'yes'
              : 'no');

  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitDeclaration(this);
}

mixin XmlDoctypeMixin implements XmlDoctype {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitDoctype(this);
}

mixin XmlElementMixin implements XmlElement {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitElement(this);
}

mixin XmlProcessingMixin implements XmlProcessing {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitProcessing(this);
}

mixin XmlTextMixin implements XmlText {
  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitText(this);
}

mixin XmlPrefixNameMixin implements XmlPrefixName {
  @override
  String? get namespaceUri => lookupAttribute(parent, xmlns, prefix)?.value;

  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitName(this);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is XmlName && other.qualified == qualified;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => qualified.hashCode;
}

mixin XmlSimpleNameMixin implements XmlSimpleName {
  @override
  String? get prefix => null;

  @override
  String get qualified => local;

  @override
  String? get namespaceUri => lookupAttribute(parent, null, xmlns)?.value;

  @override
  T accept<T>(XmlVisitor<T> visitor) => visitor.visitName(this);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is XmlName && other.qualified == qualified;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => qualified.hashCode;
}
