import 'package:petitparser/petitparser.dart';

import '../xml/entities/entity_mapping.dart';
import '../xml/nodes/natural_impl.dart';
import '../xml/parser.dart';
import '../xml/utils/attribute_type.dart';
import '../xml/utils/cache.dart';
import '../xml/utils/token.dart';
import 'event.dart';

class XmlEventDefinition extends XmlProductionDefinition {
  XmlEventDefinition(XmlEntityMapping entityMapping) : super(entityMapping);

  @override
  Parser start() => ref0<dynamic>(characterData)
      .or(ref0<dynamic>(startElement))
      .or(ref0<dynamic>(endElement))
      .or(ref0<dynamic>(comment))
      .or(ref0<dynamic>(cdata))
      .or(ref0<dynamic>(declaration))
      .or(ref0<dynamic>(processing))
      .or(ref0<dynamic>(doctype));

  @override
  Parser characterData() => super
      .characterData()
      .token()
      .map<dynamic>((each) => XmlTextEvent(each.value as String, XmlSourceRangeImpl(each.start, each.stop)));

  Parser startElement() => XmlToken.openElement
      .toParser()
      .seq(ref0<dynamic>(qualified))
      .seq(ref0<dynamic>(attributes))
      .seq(ref0<dynamic>(spaceOptional))
      .seq(XmlToken.closeElement.toParser().or(XmlToken.closeEndElement.toParser()))
      .token()
      .map<dynamic>((each) => XmlStartElementEvent(
          each.value[1] as String,
          (each.value[2] as List<dynamic>).cast<XmlEventAttribute>(),
          each.value[4] == XmlToken.closeEndElement,
          XmlSourceRangeImpl(each.start, each.stop)));

  @override
  Parser attribute() => super.attribute().token().map<dynamic>((each) => XmlEventAttribute(
      each.value[0] as String,
      each.value[4][1] as String,
      each.value[4][0] == '"' ? XmlAttributeType.DOUBLE_QUOTE : XmlAttributeType.SINGLE_QUOTE,
      XmlSourceRangeImpl(each.start, each.stop)));

  Parser endElement() => XmlToken.openEndElement
      .toParser()
      .seq(ref0<dynamic>(qualified))
      .seq(ref0<dynamic>(spaceOptional))
      .seq(XmlToken.closeElement.toParser())
      .token()
      .map<dynamic>(
          (each) => XmlEndElementEvent(each.value[1] as String, XmlSourceRangeImpl(each.start, each.stop)));

  @override
  Parser comment() => super.comment().token().map<dynamic>(
      (each) => XmlCommentEvent(each.value[1] as String, XmlSourceRangeImpl(each.start, each.stop)));

  @override
  Parser cdata() => super.cdata().token().map<dynamic>(
      (each) => XmlCDATAEvent(each.value[1] as String, XmlSourceRangeImpl(each.start, each.stop)));

  @override
  Parser declaration() => super.declaration().token().map<dynamic>((each) => XmlDeclarationEvent(
      (each.value[1] as List<dynamic>).cast<XmlEventAttribute>(), XmlSourceRangeImpl(each.start, each.stop)));

  @override
  Parser processing() => super.processing().token().map<dynamic>((each) => XmlProcessingEvent(
      each.value[1] as String, each.value[2] as String, XmlSourceRangeImpl(each.start, each.stop)));

  @override
  Parser doctype() => super.doctype().token().map<dynamic>(
      (each) => XmlDoctypeEvent(each.value[2] as String, XmlSourceRangeImpl(each.start, each.stop)));
}

final XmlCache<XmlEntityMapping, Parser> eventParserCache =
    XmlCache((entityMapping) => XmlEventDefinition(entityMapping).build<dynamic>(), 5);
