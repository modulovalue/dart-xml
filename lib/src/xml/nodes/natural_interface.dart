import 'synthetic_interface.dart';

abstract class XmlNameNatural implements XmlName, XmlNodeNatural {}

abstract class XmlNodeNatural implements XmlNode {
  XmlSourceRange get source;
}
