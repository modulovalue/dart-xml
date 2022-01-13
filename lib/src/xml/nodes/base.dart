import 'interface.dart';
import 'mixin.dart';
import 'node_mixin.dart';

// TODO use mixins once https://github.com/dart-lang/language/issues/540 is fixed.

abstract class XmlNodeBase with XmlNodeMixin, XmlNodeNavigateableMixin {}

abstract class XmlDocumentFragmentBase extends XmlNodeBase
    with XmlDocumentFragmentMixin
    implements XmlDocumentFragment {}

abstract class XmlDocumentBase extends XmlNodeBase with XmlDocumentMixin implements XmlDocument {}

abstract class XmlCDDATABase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlCDATAMixin
    implements XmlCDATA {}

abstract class XmlAttributeBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlAttributeMixin
    implements XmlAttribute {}

abstract class XmlCommentBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlCommentMixin
    implements XmlComment {}

abstract class XmlDeclarationBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlAttributesMixin, XmlDeclarationMixin
    implements XmlDeclaration {}

abstract class XmlDoctypeBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlDoctypeMixin
    implements XmlDoctype {}

abstract class XmlElementBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlAttributesMixin, XmlElementMixin
    implements XmlElement {}

abstract class XmlProcessingBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlProcessingMixin
    implements XmlProcessing {}

abstract class XmlTextBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlTextMixin
    implements XmlText {}

abstract class XmlPrefixNameBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlPrefixNameMixin
    implements XmlPrefixName {}

abstract class XmlSimpleNameBase extends XmlNodeBase
    with XmlAttributes, XmlParentableMixin, XmlSimpleNameMixin
    implements XmlSimpleName {}
