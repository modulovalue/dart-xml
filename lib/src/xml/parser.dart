import 'package:petitparser/petitparser.dart';

import 'entities/entity_mapping.dart';
import 'nodes/natural_impl.dart';
import 'nodes/natural_interface.dart';
import 'nodes/parse.dart';
import 'nodes/synthetic_interface.dart';
import 'utils/attribute_type.dart';
import 'utils/character_data_parser.dart';
import 'utils/exceptions.dart';
import 'utils/token.dart';

/// XML grammar definition.
class XmlTreeGrammarDefinition extends GrammarDefinition
    with
        XmlGrammarMixin<
            XmlAttributeNaturalImpl,
            List<dynamic>,
            List<dynamic>,
            XmlCommentNaturalImpl,
            XmlCDATANaturalImpl,
            XmlDeclarationNaturalImpl,
            XmlDoctypeNaturalImpl,
            XmlElementNaturalImpl,
            XmlProcessingNaturalImpl,
            XmlNameNatural,
            XmlTextNaturalImpl,
            XmlTextNaturalImpl //
            > {
  XmlTreeGrammarDefinition(
    this.entityMapping,
  );

  @override
  final XmlEntityMapping entityMapping;

  @override
  Parser start() => ref0<dynamic>(document).end('Expected end of input');

  @override
  Parser<XmlAttributeNaturalImpl> attribute() => attributeProd().token().map((a) {
        final dynamic each = a.value;
        return XmlAttributeNaturalImpl(
          _range(a),
          (each as List<dynamic>)[0] as XmlName,
          (each[4] as List<dynamic>)[0] as String,
          (each[4] as List<dynamic>)[1] as XmlAttributeType,
        );
      });

  @override
  Parser<List<dynamic>> attributeValueDouble() => attributeValueDoubleProd().map<List<dynamic>>(
        (dynamic each) => <dynamic>[
          (each as List<dynamic>)[1],
          XmlAttributeType.DOUBLE_QUOTE,
        ],
      );

  @override
  Parser<List<dynamic>> attributeValueSingle() => attributeValueSingleProd().map<List<dynamic>>(
        (dynamic each) => <dynamic>[
          (each as List<dynamic>)[1],
          XmlAttributeType.SINGLE_QUOTE,
        ],
      );

  @override
  Parser<XmlCommentNaturalImpl> comment() => commentProd().token().map((a) {
        final dynamic each = a.value;
        return XmlCommentNaturalImpl(_range(a), (each as List<dynamic>)[1] as String);
      });

  @override
  Parser<XmlDeclarationNaturalImpl> declaration() => declarationProd().token().map((a) {
        final dynamic each = a.value;
        return XmlDeclarationNaturalImpl(
            _range(a), ((each as List<dynamic>)[1] as Iterable<dynamic>).cast<XmlAttribute>());
      });

  @override
  Parser<XmlCDATANaturalImpl> cdata() => cdataProd().token().map((a) {
        final dynamic each = a.value;
        final source = _range(a);
        return XmlCDATANaturalImpl(source, (each as List<dynamic>)[1] as String);
      });

  @override
  Parser<XmlDoctypeNaturalImpl> doctype() => doctypeProd().token().map((a) {
        final dynamic each = a.value;
        return XmlDoctypeNaturalImpl(_range(a), (each as List<dynamic>)[2] as String);
      });

  Parser<XmlDocumentNaturalImpl> document() => documentProd().token().map((a) {
        final dynamic each = a.value;
        final nodes = <XmlNode>[];
        if ((each as List<dynamic>)[0] != null) {
          nodes.add(each[0] as XmlDeclaration);
        }
        nodes.addAll((each[1] as List<dynamic>).cast<XmlNode>());
        if (each[2] != null) {
          nodes.add(each[2] as XmlDoctype);
        }
        nodes.addAll((each[3] as List<dynamic>).cast<XmlNode>());
        nodes.add(each[4] as XmlNode); // document
        nodes.addAll((each[5] as List<dynamic>).cast<XmlNode>());
        return XmlDocumentNaturalImpl(
          _range(a),
          nodes.cast<XmlNode>(),
        );
      });

  Parser<XmlDocumentFragmentNaturalImpl> documentFragment() => documentFragmentProd().token().map(
        (a) {
          final dynamic nodes = a.value;
          return XmlDocumentFragmentNaturalImpl(
            _range(a),
            (nodes as List<dynamic>).cast<XmlNode>(),
          );
        },
      );

  @override
  Parser<XmlElementNaturalImpl> element() => elementProd().token().map((a) {
        final dynamic list = a.value;
        final name = (list as List<dynamic>)[1] as XmlName;
        final attributes = (list[2] as List<dynamic>).cast<XmlNode>();
        if (list[4] == XmlToken.closeEndElement) {
          return XmlElementNaturalImpl(_range(a), name, attributes.cast(), [], true);
        } else {
          if (list[1] == (list[4] as List<dynamic>)[3]) {
            final children = ((list[4] as List<dynamic>)[1] as List<dynamic>).cast<XmlNode>();
            return XmlElementNaturalImpl(_range(a), name, attributes.cast(), children, children.isNotEmpty);
          } else {
            final token = (list[4] as List<dynamic>)[2] as Token<dynamic>;
            final lineAndColumn = Token.lineAndColumnOf(token.buffer, token.start);
            throw XmlParserException(
              'Expected </${list[1]}>, but found </${(list[4] as List<dynamic>)[3]}>',
              buffer: token.buffer,
              position: token.start,
              line: lineAndColumn[0],
              column: lineAndColumn[1],
            );
          }
        }
      });

  @override
  Parser<XmlProcessingNaturalImpl> processing() => processingProd().token().map((a) {
        final dynamic each = a.value;
        return XmlProcessingNaturalImpl(_range(a), (each as List<dynamic>)[1] as String, each[2] as String);
      });

  @override
  Parser<XmlNameNatural> qualified() => qualifiedProd().cast<String>().token().map((final a) {
        final each = a.value;
        return createXmlNameNaturalFromString(_range(a), each);
      });

  @override
  Parser<XmlTextNaturalImpl> characterData() => characterDataProd().cast<String>().token().map((final a) {
        final each = a.value;
        return XmlTextNaturalImpl(_range(a), each);
      });

  @override
  Parser<XmlTextNaturalImpl> spaceText() => spaceTextProd().cast<String>().token().map((final a) {
        final each = a.value;
        return XmlTextNaturalImpl(_range(a), each);
      });
}

XmlSourceRange _range(Token<dynamic> t) => XmlSourceRangeImpl(t.start, t.stop);

/// XML parsers that are shared between the XML tree and event based parsers.
mixin XmlGrammarMixin<
    ATTRIBUTE,
    ATTRIBUTEVALUEDOUBLE,
    ATTRIBUTEVALUESINGLE,
    COMMENT,
    CDATA,
    DECLARATION,
    DOCTYPE,
    ELEMENT,
    PROCESSING,
    QUALIFIED,
    CHARACTERDATA,
    SPACETEXT //
    > {
  XmlEntityMapping get entityMapping;

  Parser<ATTRIBUTE> attribute();

  Parser<ATTRIBUTEVALUEDOUBLE> attributeValueDouble();

  Parser<ATTRIBUTEVALUESINGLE> attributeValueSingle();

  Parser<COMMENT> comment();

  Parser<CDATA> cdata();

  Parser<DECLARATION> declaration();

  Parser<DOCTYPE> doctype();

  Parser<ELEMENT> element();

  Parser<PROCESSING> processing();

  Parser<QUALIFIED> qualified();

  Parser<CHARACTERDATA> characterData();

  Parser<SPACETEXT> spaceText();

  Parser<dynamic> attributeProd() => ref0<dynamic>(qualified)
      .seq(ref0<dynamic>(spaceOptionalProd))
      .seq(XmlToken.equals.toParser())
      .seq(ref0<dynamic>(spaceOptionalProd))
      .seq(ref0<dynamic>(attributeValueProd));

  Parser<dynamic> attributesProd() => ref0<dynamic>(spaceProd).seq(ref0<dynamic>(attribute)).pick(1).star();

  Parser<dynamic> attributeValueProd() =>
      ref0<dynamic>(attributeValueDouble).or(ref0<dynamic>(attributeValueSingle));

  Parser<dynamic> attributeValueDoubleProd() => XmlToken.doubleQuote
      .toParser()
      .seq(XmlCharacterDataParser(entityMapping, XmlToken.doubleQuote, 0))
      .seq(XmlToken.doubleQuote.toParser());

  Parser<dynamic> attributeValueSingleProd() => XmlToken.singleQuote
      .toParser()
      .seq(XmlCharacterDataParser(entityMapping, XmlToken.singleQuote, 0))
      .seq(XmlToken.singleQuote.toParser());

  Parser<dynamic> commentProd() => XmlToken.openComment
      .toParser()
      .seq(any().starLazy(XmlToken.closeComment.toParser()).flatten('Expected comment content'))
      .seq(XmlToken.closeComment.toParser());

  Parser<dynamic> cdataProd() => XmlToken.openCDATA
      .toParser()
      .seq(any().starLazy(XmlToken.closeCDATA.toParser()).flatten('Expected CDATA content'))
      .seq(XmlToken.closeCDATA.toParser());

  Parser<dynamic> contentProd() => ref0<dynamic>(characterData)
      .or(ref0<dynamic>(element))
      .or(ref0<dynamic>(processing))
      .or(ref0<dynamic>(comment))
      .or(ref0<dynamic>(cdata))
      .star();

  Parser<dynamic> declarationProd() => XmlToken.openDeclaration
      .toParser()
      .seq(ref0<dynamic>(attributesProd))
      .seq(ref0<dynamic>(spaceOptionalProd))
      .seq(XmlToken.closeDeclaration.toParser());

  Parser<dynamic> doctypeProd() => XmlToken.openDoctype
      .toParser()
      .seq(ref0<dynamic>(spaceProd))
      .seq(ref0<dynamic>(nameTokenProd)
          .or(ref0<dynamic>(attributeValueProd))
          .or(XmlToken.openDoctypeBlock
              .toParser()
              .seq(any().starLazy(XmlToken.closeDoctypeBlock.toParser()))
              .seq(XmlToken.closeDoctypeBlock.toParser()))
          .separatedBy<dynamic>(ref0<dynamic>(spaceOptionalProd))
          .flatten('Expected doctype content'))
      .seq(ref0<dynamic>(spaceOptionalProd))
      .seq(XmlToken.closeDoctype.toParser());

  Parser<dynamic> documentFragmentContentProd() => ref0<dynamic>(characterData)
      .or(ref0<dynamic>(element))
      .or(ref0<dynamic>(comment))
      .or(ref0<dynamic>(cdata))
      .or(ref0<dynamic>(declaration))
      .or(ref0<dynamic>(processing))
      .or(ref0<dynamic>(doctype));

  Parser<dynamic> documentProd() => ref0<dynamic>(declaration)
      .optional()
      .seq(ref0<dynamic>(miscProd))
      .seq(ref0<dynamic>(doctype).optional())
      .seq(ref0<dynamic>(miscProd))
      .seq(ref0<dynamic>(element))
      .seq(ref0<dynamic>(miscProd));

  Parser<dynamic> documentFragmentProd() => ref0<dynamic>(documentFragmentContentProd)
      .star()
      .seq(endOfInput('Expected end of input') | ref0<dynamic>(element))
      .pick(0);

  Parser<dynamic> elementProd() => XmlToken.openElement
      .toParser()
      .seq(ref0<dynamic>(qualified))
      .seq(ref0<dynamic>(attributesProd))
      .seq(ref0<dynamic>(spaceOptionalProd))
      .seq(XmlToken.closeEndElement.toParser().or(XmlToken.closeElement
          .toParser()
          .seq(ref0<dynamic>(contentProd))
          .seq(XmlToken.openEndElement.toParser().token())
          .seq(ref0<dynamic>(qualified))
          .seq(ref0<dynamic>(spaceOptionalProd))
          .seq(XmlToken.closeElement.toParser())));

  Parser<dynamic> processingProd() => XmlToken.openProcessing
      .toParser()
      .seq(ref0<dynamic>(nameTokenProd))
      .seq(ref0<dynamic>(spaceProd)
          .seq(any()
              .starLazy(XmlToken.closeProcessing.toParser())
              .flatten('Expected processing instruction content'))
          .pick(1)
          .optionalWith(''))
      .seq(XmlToken.closeProcessing.toParser());

  Parser<List<String>> spaceOptionalProd() => whitespace().star();

  Parser<String> spaceTextProd() => ref0<dynamic>(spaceProd).flatten('Expected whitespace');

  Parser<List<String>> spaceProd() => whitespace().plus();

  Parser<dynamic> miscProd() =>
      ref0<dynamic>(spaceText).or(ref0<dynamic>(comment)).or(ref0<dynamic>(processing)).star();

  Parser<String> characterDataProd() => XmlCharacterDataParser(entityMapping, XmlToken.openElement, 1);

  Parser<dynamic> qualifiedProd() => ref0<dynamic>(nameTokenProd);

  Parser<String> nameTokenProd() =>
      ref0<dynamic>(nameStartCharProd).seq(ref0<dynamic>(nameCharProd).star()).flatten('Expected name');

  Parser<String> nameStartCharProd() => pattern(_nameStartChars);

  // https://en.wikipedia.org/wiki/QName
  static const String _nameStartChars = ':A-Z_a-z'
      '\u00c0-\u00d6'
      '\u00d8-\u00f6'
      '\u00f8-\u02ff'
      '\u0370-\u037d'
      '\u037f-\u1fff'
      '\u200c-\u200d'
      '\u2070-\u218f'
      '\u2c00-\u2fef'
      '\u3001-\ud7ff'
      '\uf900-\ufdcf'
      '\ufdf0-\ufffd';

  Parser<String> nameCharProd() => pattern(_nameChars);

  static const String _nameChars = '$_nameStartChars'
      '-.0-9'
      '\u00b7'
      '\u0300-\u036f'
      '\u203f-\u2040';
}
