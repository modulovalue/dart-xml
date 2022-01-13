import 'mixin.dart';
import 'node_mixin.dart';
import 'synthetic_interface.dart';

// TODO use mixins once https://github.com/dart-lang/language/issues/540 is fixed.

abstract class XmlNodeBase with XmlNodeMixin, XmlNodeNavigateableMixin {}

abstract class XmlDocumentFragmentBase extends XmlNodeBase
    with XmlDocumentFragmentMixin
    implements XmlDocumentFragment {}

abstract class XmlDocumentBase extends XmlNodeBase with XmlDocumentMixin implements XmlDocument {}

abstract class XmlCDDATABase extends XmlNodeBase with XmlParentableMixin, XmlCDATAMixin implements XmlCDATA {}

abstract class XmlAttributeBase extends XmlNodeBase
    with XmlParentableMixin, XmlAttributeMixin
    implements XmlAttribute {}

abstract class XmlCommentBase extends XmlNodeBase
    with XmlParentableMixin, XmlCommentMixin
    implements XmlComment {}

abstract class XmlDeclarationBase extends XmlNodeBase
    with XmlParentableMixin, XmlAttributesMixin, XmlDeclarationMixin
    implements XmlDeclaration {}

abstract class XmlDoctypeBase extends XmlNodeBase
    with XmlParentableMixin, XmlDoctypeMixin
    implements XmlDoctype {}

abstract class XmlElementBase extends XmlNodeBase
    with XmlParentableMixin, XmlAttributesMixin, XmlElementMixin
    implements XmlElement {}

abstract class XmlProcessingBase extends XmlNodeBase
    with XmlParentableMixin, XmlProcessingMixin
    implements XmlProcessing {}

abstract class XmlTextBase extends XmlNodeBase with XmlParentableMixin, XmlTextMixin implements XmlText {}

abstract class XmlPrefixNameBase extends XmlNodeBase
    with XmlParentableMixin, XmlPrefixNameMixin
    implements XmlPrefixName {}

abstract class XmlSimpleNameBase extends XmlNodeBase
    with XmlParentableMixin, XmlSimpleNameMixin
    implements XmlSimpleName {}
