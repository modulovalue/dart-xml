import 'package:petitparser/petitparser.dart';

import '../xml/entities/entity_mapping.dart';
import '../xml/nodes/natural_impl.dart';
import '../xml/nodes/synthetic_interface.dart';
import '../xml/parser.dart';
import '../xml/utils/attribute_type.dart';
import '../xml/utils/cache.dart';
import '../xml/utils/token.dart';
import 'event.dart';

class XmlEventGrammarDefinition extends GrammarDefinition
    with
        XmlGrammarMixin<
            XmlEventAttribute,
            Object,
            Object,
            XmlCommentEvent,
            XmlCDATAEvent,
            XmlDeclarationEvent,
            XmlDoctypeEvent,
            Object,
            XmlProcessingEvent,
            Object,
            XmlTextEvent,
            String //
            > {
  XmlEventGrammarDefinition(this.entityMapping);

  @override
  final XmlEntityMapping entityMapping;

  @override
  Parser start() => ref0(characterData)
      .or(ref0<dynamic>(startElement))
      .or(ref0<dynamic>(endElement))
      .or(ref0<dynamic>(comment))
      .or(ref0<dynamic>(cdata))
      .or(ref0<dynamic>(declaration))
      .or(ref0<dynamic>(processing))
      .or(ref0<dynamic>(doctype));

  Parser<XmlStartElementEvent> startElement() => XmlToken.openElement
      .toParser()
      .seq(ref0<dynamic>(qualified))
      .seq(ref0<dynamic>(attributesProd))
      .seq(ref0<dynamic>(spaceOptionalProd))
      .seq(XmlToken.closeElement.toParser().or(XmlToken.closeEndElement.toParser()))
      .token()
      .map(
        (each) => XmlStartElementEvent(
          each.value[1] as String,
          (each.value[2] as List<dynamic>).cast<XmlEventAttribute>(),
          each.value[4] == XmlToken.closeEndElement,
          _range(each),
        ),
      );

  Parser<XmlEndElementEvent> endElement() => XmlToken.openEndElement
      .toParser()
      .seq(ref0<dynamic>(qualified))
      .seq(ref0<dynamic>(spaceOptionalProd))
      .seq(XmlToken.closeElement.toParser())
      .token()
      .map(
        (each) => XmlEndElementEvent(
          (each.value)[1] as String,
          _range(each),
        ),
      );

  Parser document() => documentProd();

  @override
  Parser<XmlEventAttribute> attribute() => attributeProd().token().map(
        (each) => XmlEventAttribute(
          (each.value[0] as Token<dynamic>).value as String,
          ((each.value[4] as Token<dynamic>).value as List<dynamic>)[1] as String,
          ((each.value[4] as Token<dynamic>).value as List<dynamic>)[0] == '"'
              ? XmlAttributeType.DOUBLE_QUOTE
              : XmlAttributeType.SINGLE_QUOTE,
          _range(each),
        ),
      );

  @override
  Parser<Object> attributeValueDouble() => attributeValueDoubleProd();

  @override
  Parser<Object> attributeValueSingle() => attributeValueSingleProd();

  @override
  Parser<XmlCommentEvent> comment() => commentProd().token().map(
        (each) => XmlCommentEvent(
          each.value[1] as String,
          _range(each),
        ),
      );

  @override
  Parser<XmlCDATAEvent> cdata() => cdataProd().token().map(
        (each) => XmlCDATAEvent(
          each.value[1] as String,
          _range(each),
        ),
      );

  @override
  Parser<XmlDeclarationEvent> declaration() => declarationProd().token().map(
        (each) => XmlDeclarationEvent(
          (each.value[1] as List<dynamic>).cast<XmlEventAttribute>(),
          _range(each),
        ),
      );

  @override
  Parser<XmlDoctypeEvent> doctype() => doctypeProd().token().map(
        (each) => XmlDoctypeEvent(
          each.value[2] as String,
          _range(each),
        ),
      );

  @override
  Parser<Object> element() => elementProd();

  @override
  Parser<XmlProcessingEvent> processing() => processingProd().token().map(
        (each) => XmlProcessingEvent(
          each.value[1] as String,
          each.value[2] as String,
          _range(each),
        ),
      );

  @override
  Parser<String> qualified() => qualifiedProd();

  @override
  Parser<XmlTextEvent> characterData() => characterDataProd().token().map(
        (each) => XmlTextEvent(
          each.value,
          _range(each),
        ),
      );

  @override
  Parser<String> spaceText() => spaceTextProd();
}

XmlSourceRange _range<T>(Token<T> t) => XmlSourceRangeImpl(t.start, t.stop);

final XmlCache<XmlEntityMapping, Parser> eventParserCache =
    XmlCache((entityMapping) => XmlEventGrammarDefinition(entityMapping).build<dynamic>(), 5);
