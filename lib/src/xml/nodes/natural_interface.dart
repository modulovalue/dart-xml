// ignore_for_file: prefer_final_parameters

import '../../../xml.dart';

abstract class XmlNameNatural implements XmlName, XmlNodeNatural {
  Z matchNaturalName<Z>({
    required final Z Function(XmlPrefixNameNaturalImpl) prefix,
    required final Z Function(XmlSimpleNameNaturalImpl) simple,
  });
}

abstract class XmlNodeNatural implements XmlNode {
  XmlSourceRange get source;
}

abstract class XmlElementChildNatural implements XmlNodeNatural {
  Z matchNaturalElementChild<Z>({
    required Z Function(XmlTextNaturalImpl) text,
    required Z Function(XmlElementNaturalImpl) element,
    required Z Function(XmlProcessingNaturalImpl) processing,
    required Z Function(XmlCommentNaturalImpl) comment,
    required Z Function(XmlCDATANaturalImpl) cdata,
  });
}
