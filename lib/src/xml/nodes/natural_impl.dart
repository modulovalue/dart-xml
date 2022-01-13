import '../utils/attribute_type.dart';
import 'natural_interface.dart';
import 'synthetic_impl.dart';
import 'synthetic_interface.dart';

class XmlDocumentNaturalImpl extends XmlDocumentSyntheticImpl implements XmlNodeNatural {
  XmlDocumentNaturalImpl(
    this.source,
    this.declaration,
    Iterable<XmlNode> a,
    this.doctypeElement,
    Iterable<XmlNode> b,
    this.rootElement,
    Iterable<XmlNode> c,
  ) : super(
          [
            if (declaration != null) declaration,
            ...a,
            if (doctypeElement != null) doctypeElement,
            ...b,
            rootElement,
            ...c,
          ],
        );
  @override
  final XmlDeclarationNaturalImpl? declaration;
  @override
  final XmlDoctypeNaturalImpl? doctypeElement;
  @override
  final XmlElementNaturalImpl rootElement;
  @override
  final XmlSourceRange source;
}

class XmlDocumentFragmentNaturalImpl extends XmlDocumentFragmentSyntheticImpl implements XmlNodeNatural {
  XmlDocumentFragmentNaturalImpl(
    this.source,
    Iterable<XmlNode> childrenIterable,
  ) : super(childrenIterable);

  @override
  final XmlSourceRange source;
}

class XmlCDATANaturalImpl extends XmlCDATASyntheticImpl implements XmlNodeNatural {
  XmlCDATANaturalImpl(
    this.source,
    String text,
  ) : super(text);

  @override
  final XmlSourceRange source;
}

class XmlAttributeNaturalImpl extends XmlAttributeSyntheticImpl implements XmlNodeNatural {
  XmlAttributeNaturalImpl(
    this.source,
    XmlName name,
    String value,
    XmlAttributeType attributeType,
  ) : super(name, value, attributeType);

  @override
  final XmlSourceRange source;
}

class XmlCommentNaturalImpl extends XmlCommentSyntheticImpl implements XmlNodeNatural {
  XmlCommentNaturalImpl(
    this.source,
    String text,
  ) : super(text);

  @override
  final XmlSourceRange source;
}

class XmlDeclarationNaturalImpl extends XmlDeclarationSyntheticImpl implements XmlNodeNatural {
  XmlDeclarationNaturalImpl(
    this.source,
    Iterable<XmlAttributeNaturalImpl> attributesIterable,
  ) : super(attributesIterable);


  @override
  final XmlSourceRange source;
}

class XmlDoctypeNaturalImpl extends XmlDoctypeSyntheticImpl implements XmlNodeNatural {
  XmlDoctypeNaturalImpl(
    this.source,
    String text,
  ) : super(text);

  @override
  final XmlSourceRange source;
}

class XmlElementNaturalImpl extends XmlElementSyntheticImpl implements XmlNodeNatural {
  XmlElementNaturalImpl(
    this.source,
    XmlName name,
    Iterable<XmlAttribute> attributesIterable,
    Iterable<XmlNode> childrenIterable,
    bool isSelfClosing,
  ) : super(name, attributesIterable, childrenIterable, isSelfClosing);

  @override
  final XmlSourceRange source;
}

class XmlProcessingNaturalImpl extends XmlProcessingSyntheticImpl implements XmlNodeNatural {
  XmlProcessingNaturalImpl(
    this.source,
    String target,
    String text,
  ) : super(target, text);

  @override
  final XmlSourceRange source;
}

/// XML text node.
class XmlTextNaturalImpl extends XmlTextSyntheticImpl implements XmlNodeNatural {
  XmlTextNaturalImpl(
    this.source,
    String text,
  ) : super(text);

  @override
  final XmlSourceRange source;
}

/// An XML entity name with a prefix.
class XmlPrefixNameNaturalImpl extends XmlPrefixNameSyntheticImpl implements XmlNameNatural {
  XmlPrefixNameNaturalImpl(
    this.source,
    String prefix,
    String local,
    String qualified,
  ) : super(prefix, local, qualified);

  @override
  final XmlSourceRange source;
}

/// An XML entity name without a prefix.
class XmlSimpleNameNaturalImpl extends XmlSimpleNameSyntheticImpl implements XmlNameNatural {
  XmlSimpleNameNaturalImpl(
    this.source,
    String local,
  ) : super(local);

  @override
  final XmlSourceRange source;
}

class XmlSourceRangeImpl implements XmlSourceRange {
  const XmlSourceRangeImpl(
    final this.offset,
    final this.end,
  );

  @override
  final int offset;
  @override
  final int end;
}
