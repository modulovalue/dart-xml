import 'package:petitparser/petitparser.dart';
import 'package:xml/src/xml_events/range.dart';

import '../xml/entities/entity_mapping.dart';
import '../xml/production.dart';
import '../xml/utils/attribute_type.dart';
import '../xml/utils/cache.dart';
import '../xml/utils/token.dart';
import 'events/cdata.dart';
import 'events/comment.dart';
import 'events/declaration.dart';
import 'events/doctype.dart';
import 'events/end_element.dart';
import 'events/processing.dart';
import 'events/start_element.dart';
import 'events/text.dart';
import 'utils/event_attribute.dart';

class XmlEventDefinition extends XmlProductionDefinition {
  XmlEventDefinition(XmlEntityMapping entityMapping) : super(entityMapping);

  @override
  Parser start() => ref0(characterData)
      .or(ref0(startElement))
      .or(ref0(endElement))
      .or(ref0(comment))
      .or(ref0(cdata))
      .or(ref0(declaration))
      .or(ref0(processing))
      .or(ref0(doctype));

  @override
  Parser characterData() =>
      super.characterData().token().map((each) => XmlTextEvent(each.value, XmlEventSourceRange(each.start, each.stop)));

  Parser startElement() => XmlToken.openElement
      .toParser()
      .seq(ref0(qualified))
      .seq(ref0(attributes))
      .seq(ref0(spaceOptional))
      .seq(XmlToken.closeElement
          .toParser()
          .or(XmlToken.closeEndElement.toParser()))
      .token()
      .map((each) => XmlStartElementEvent(
          each.value[1],
          each.value[2].cast<XmlEventAttribute>(),
          each.value[4] == XmlToken.closeEndElement,
          XmlEventSourceRange(each.start, each.stop)));

  @override
  Parser attribute() => super.attribute().token().map((each) => XmlEventAttribute(
      each.value[0],
      each.value[4][1],
      each.value[4][0] == '"'
          ? XmlAttributeType.DOUBLE_QUOTE
          : XmlAttributeType.SINGLE_QUOTE,
      XmlEventSourceRange(each.start, each.stop)));

  Parser endElement() => XmlToken.openEndElement
      .toParser()
      .seq(ref0(qualified))
      .seq(ref0(spaceOptional))
      .seq(XmlToken.closeElement.toParser())
      .token()
      .map((each) => XmlEndElementEvent(each.value[1], XmlEventSourceRange(each.start, each.stop)));

  @override
  Parser comment() => super.comment().token().map((each) => XmlCommentEvent(each.value[1], XmlEventSourceRange(each.start, each.stop)));

  @override
  Parser cdata() => super.cdata().token().map((each) => XmlCDATAEvent(each.value[1], XmlEventSourceRange(each.start, each.stop)));

  @override
  Parser declaration() => super
      .declaration()
      .token()
      .map((each) => XmlDeclarationEvent(each.value[1].cast<XmlEventAttribute>(), XmlEventSourceRange(each.start, each.stop)));

  @override
  Parser processing() =>
      super.processing().token().map((each) => XmlProcessingEvent(each.value[1], each.value[2], XmlEventSourceRange(each.start, each.stop)));

  @override
  Parser doctype() => super.doctype().token().map((each) => XmlDoctypeEvent(each.value[2], XmlEventSourceRange(each.start, each.stop)));
}

final XmlCache<XmlEntityMapping, Parser> eventParserCache =
    XmlCache((entityMapping) => XmlEventDefinition(entityMapping).build(), 5);
