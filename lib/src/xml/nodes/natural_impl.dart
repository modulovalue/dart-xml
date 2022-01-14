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

class XmlCDATANaturalImpl extends XmlCDATASyntheticImpl implements XmlNodeNatural, XmlElementChildNatural {
  XmlCDATANaturalImpl(
    this.source,
    String text,
  ) : super(text);

  @override
  Z matchNaturalElementChild<Z>({
    required Z Function(XmlTextNaturalImpl) text,
    required Z Function(XmlElementNaturalImpl) element,
    required Z Function(XmlProcessingNaturalImpl) processing,
    required Z Function(XmlCommentNaturalImpl) comment,
    required Z Function(XmlCDATANaturalImpl) cdata,
  }) =>
      cdata(this);

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

class XmlCommentNaturalImpl extends XmlCommentSyntheticImpl
    implements XmlNodeNatural, XmlElementChildNatural {
  XmlCommentNaturalImpl(
    this.source,
    String text,
  ) : super(text);

  @override
  Z matchNaturalElementChild<Z>({
    required Z Function(XmlTextNaturalImpl) text,
    required Z Function(XmlElementNaturalImpl) element,
    required Z Function(XmlProcessingNaturalImpl) processing,
    required Z Function(XmlCommentNaturalImpl) comment,
    required Z Function(XmlCDATANaturalImpl) cdata,
  }) =>
      comment(this);
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

class XmlElementNaturalImpl extends XmlElementSyntheticImpl
    implements XmlNodeNatural, XmlElementChildNatural {
  // TODO the parent won't need to validate that children have the correct type once synthetic hierarchy also has an element child type.
  XmlElementNaturalImpl(
    this.source,
    XmlName name,
    Iterable<XmlAttribute> attributesIterable,
    this.childrenNodes,
    bool isSelfClosing,
  ) : super(name, attributesIterable, childrenNodes, isSelfClosing);

  final Iterable<XmlElementChildNatural> childrenNodes;
  @override
  final XmlSourceRange source;

  @override
  Z matchNaturalElementChild<Z>({
    required Z Function(XmlTextNaturalImpl) text,
    required Z Function(XmlElementNaturalImpl) element,
    required Z Function(XmlProcessingNaturalImpl) processing,
    required Z Function(XmlCommentNaturalImpl) comment,
    required Z Function(XmlCDATANaturalImpl) cdata,
  }) =>
      element(this);
}

class XmlProcessingNaturalImpl extends XmlProcessingSyntheticImpl
    implements XmlNodeNatural, XmlElementChildNatural {
  XmlProcessingNaturalImpl(
    this.source,
    String target,
    String text,
  ) : super(target, text);

  @override
  Z matchNaturalElementChild<Z>({
    required Z Function(XmlTextNaturalImpl) text,
    required Z Function(XmlElementNaturalImpl) element,
    required Z Function(XmlProcessingNaturalImpl) processing,
    required Z Function(XmlCommentNaturalImpl) comment,
    required Z Function(XmlCDATANaturalImpl) cdata,
  }) =>
      processing(this);

  @override
  final XmlSourceRange source;
}

class XmlTextNaturalImpl extends XmlTextSyntheticImpl implements XmlNodeNatural, XmlElementChildNatural {
  XmlTextNaturalImpl(
    this.source,
    String text,
  ) : super(text);

  @override
  Z matchNaturalElementChild<Z>({
    required Z Function(XmlTextNaturalImpl) text,
    required Z Function(XmlElementNaturalImpl) element,
    required Z Function(XmlProcessingNaturalImpl) processing,
    required Z Function(XmlCommentNaturalImpl) comment,
    required Z Function(XmlCDATANaturalImpl) cdata,
  }) =>
      text(this);

  @override
  final XmlSourceRange source;
}

class XmlPrefixNameNaturalImpl extends XmlPrefixNameSyntheticImpl implements XmlNameNatural {
  XmlPrefixNameNaturalImpl(
    this.source,
    String prefix,
    String local,
    String qualified,
  ) : super(prefix, local, qualified);

  @override
  final XmlSourceRange source;

  @override
  Z matchNaturalName<Z>({
    required final Z Function(XmlPrefixNameNaturalImpl) prefix,
    required final Z Function(XmlSimpleNameNaturalImpl) simple,
  }) => prefix(this);
}

class XmlSimpleNameNaturalImpl extends XmlSimpleNameSyntheticImpl implements XmlNameNatural {
  XmlSimpleNameNaturalImpl(
    this.source,
    String local,
  ) : super(local);

  @override
  final XmlSourceRange source;

  @override
  Z matchNaturalName<Z>({
    required final Z Function(XmlPrefixNameNaturalImpl) prefix,
    required final Z Function(XmlSimpleNameNaturalImpl) simple,
  }) => simple(this);
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
