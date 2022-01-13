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

/// XML parser that defines standard actions to the the XML tree.
class XmlParserDefinition extends XmlGrammarDefinition {
  XmlParserDefinition(XmlEntityMapping entityMapping)
      : super(
          entityMapping,
        );

  @override
  XmlAttributeNaturalImpl createAttribute(
    XmlSourceRange source,
    XmlName name,
    String text,
    XmlAttributeType type,
  ) =>
      XmlAttributeNaturalImpl(
        source,
        name,
        text,
        type,
      );

  @override
  XmlCommentNaturalImpl createComment(
    XmlSourceRange source,
    String text,
  ) =>
      XmlCommentNaturalImpl(
        source,
        text,
      );

  @override
  XmlCDATANaturalImpl createCDATA(
    XmlSourceRange source,
    String text,
  ) =>
      XmlCDATANaturalImpl(
        source,
        text,
      );

  @override
  XmlDeclarationNaturalImpl createDeclaration(
    XmlSourceRange source,
    Iterable<XmlNode> attributes,
  ) =>
      XmlDeclarationNaturalImpl(
        source,
        attributes.cast<XmlAttribute>(),
      );

  @override
  XmlDoctypeNaturalImpl createDoctype(
    XmlSourceRange source,
    String text,
  ) =>
      XmlDoctypeNaturalImpl(
        source,
        text,
      );

  @override
  XmlDocumentNaturalImpl createDocument(
    XmlSourceRange source,
    Iterable<XmlNode> children,
  ) =>
      XmlDocumentNaturalImpl(
        source,
        children,
      );

  @override
  XmlDocumentFragmentNaturalImpl createDocumentFragment(
    XmlSourceRange source,
    Iterable<XmlNode> children,
  ) =>
      XmlDocumentFragmentNaturalImpl(
        source,
        children,
      );

  @override
  XmlElementNaturalImpl createElement(
    XmlSourceRange source,
    XmlName name,
    Iterable<XmlNode> attributes,
    Iterable<XmlNode> children, [
    bool isSelfClosing = true,
  ]) =>
      XmlElementNaturalImpl(
        source,
        name,
        attributes.cast<XmlAttribute>(),
        children,
        isSelfClosing,
      );

  @override
  XmlProcessingNaturalImpl createProcessing(
    XmlSourceRange source,
    String target,
    String text,
  ) =>
      XmlProcessingNaturalImpl(
        source,
        target,
        text,
      );

  @override
  XmlNameNatural createQualified(
    XmlSourceRange source,
    String name,
  ) =>
      createXmlNameNaturalFromString(
        source,
        name,
      );

  @override
  XmlTextNaturalImpl createText(
    XmlSourceRange source,
    String text,
  ) =>
      XmlTextNaturalImpl(
        source,
        text,
      );
}

/// XML grammar definition.
abstract class XmlGrammarDefinition extends XmlProductionDefinition {
  XmlGrammarDefinition(XmlEntityMapping entityMapping) : super(entityMapping);

  // Callbacks used to build the XML AST.
  XmlNode createAttribute(XmlSourceRange source, XmlName name, String text, XmlAttributeType type);

  XmlNode createComment(XmlSourceRange source, String text);

  XmlNode createCDATA(XmlSourceRange source, String text);

  XmlNode createDeclaration(XmlSourceRange source, Iterable<XmlNode> attributes);

  XmlNode createDoctype(XmlSourceRange source, String text);

  XmlNode createDocument(XmlSourceRange source, Iterable<XmlNode> children);

  XmlNode createDocumentFragment(XmlSourceRange source, Iterable<XmlNode> children);

  XmlNode createElement(XmlSourceRange source, XmlName name, Iterable<XmlNode> attributes,
      Iterable<XmlNode> children, bool isSelfClosing);

  XmlNode createProcessing(XmlSourceRange source, String target, String text);

  XmlName createQualified(XmlSourceRange source, String name);

  XmlNode createText(XmlSourceRange source, String text);

  // Connects the productions and the XML AST callbacks.

  @override
  Parser attribute() => super.attribute().token().map<dynamic>((a) {
        final dynamic each = a.value;
        return createAttribute(
            _range(a), each[0] as XmlName, each[4][0] as String, each[4][1] as XmlAttributeType);
      });

  XmlSourceRange _range(Token<dynamic> t) => XmlSourceRangeImpl(t.start, t.stop);

  @override
  Parser attributeValueDouble() => super
      .attributeValueDouble()
      .map<dynamic>((dynamic each) => <dynamic>[each[1], XmlAttributeType.DOUBLE_QUOTE]);

  @override
  Parser attributeValueSingle() => super
      .attributeValueSingle()
      .map<dynamic>((dynamic each) => <dynamic>[each[1], XmlAttributeType.SINGLE_QUOTE]);

  @override
  Parser comment() => super.comment().token().map<dynamic>((a) {
        final dynamic each = a.value;
        return createComment(_range(a), each[1] as String);
      });

  @override
  Parser declaration() => super.declaration().token().map<dynamic>((a) {
        final dynamic each = a.value;
        return createDeclaration(_range(a), (each[1] as Iterable<dynamic>).cast<XmlNode>());
      });

  @override
  Parser cdata() => super.cdata().token().map<dynamic>((a) {
        final dynamic each = a.value;
        final source = _range(a);
        return createCDATA(source, each[1] as String);
      });

  @override
  Parser doctype() => super.doctype().token().map<dynamic>((a) {
        final dynamic each = a.value;
        return createDoctype(_range(a), each[2] as String);
      });

  @override
  Parser document() => super.document().token().map<dynamic>((a) {
        final dynamic each = a.value;
        final nodes = <dynamic>[];
        if (each[0] != null) {
          nodes.add(each[0]); // declaration
        }
        nodes.addAll(each[1] as List<dynamic>);
        if (each[2] != null) {
          nodes.add(each[2]); // doctype
        }
        nodes.addAll(each[3] as List<dynamic>);
        nodes.add(each[4]); // document
        nodes.addAll(each[5] as List<dynamic>);
        return createDocument(
          _range(a),
          nodes.cast<XmlNode>(),
        );
      });

  @override
  Parser documentFragment() => super.documentFragment().token().map<dynamic>((a) {
        final dynamic nodes = a.value;
        return createDocumentFragment(_range(a), (nodes as List<dynamic>).cast<XmlNode>());
      });

  @override
  Parser element() => super.element().token().map<dynamic>((a) {
        final dynamic list = a.value;
        final name = list[1] as XmlName;
        final attributes = (list[2] as List<dynamic>).cast<XmlNode>();
        if (list[4] == XmlToken.closeEndElement) {
          return createElement(_range(a), name, attributes, [], true);
        } else {
          if (list[1] == list[4][3]) {
            final children = (list[4][1] as List<dynamic>).cast<XmlNode>();
            return createElement(_range(a), name, attributes, children, children.isNotEmpty);
          } else {
            final token = list[4][2] as Token<dynamic>;
            final lineAndColumn = Token.lineAndColumnOf(token.buffer, token.start);
            throw XmlParserException('Expected </${list[1]}>, but found </${list[4][3]}>',
                buffer: token.buffer,
                position: token.start,
                line: lineAndColumn[0],
                column: lineAndColumn[1]);
          }
        }
      });

  @override
  Parser processing() => super.processing().token().map<dynamic>((a) {
        final dynamic each = a.value;
        return createProcessing(_range(a), each[1] as String, each[2] as String);
      });

  @override
  Parser qualified() => super.qualified().cast<String>().token().map<dynamic>((final a) {
        final each = a.value;
        return createQualified(_range(a), each);
      });

  @override
  Parser characterData() => super.characterData().cast<String>().token().map<dynamic>((final a) {
        final each = a.value;
        return createText(_range(a), each);
      });

  @override
  Parser spaceText() => super.spaceText().cast<String>().token().map<dynamic>((final a) {
        final each = a.value;
        return createText(_range(a), each);
      });
}

/// XML parser that defines standard actions to the the XML tree.
class XmlProductionDefinition extends GrammarDefinition {
  XmlProductionDefinition(this.entityMapping);

  final XmlEntityMapping entityMapping;

  @override
  Parser start() => ref0<dynamic>(document).end('Expected end of input');

  Parser attribute() => ref0<dynamic>(qualified)
      .seq(ref0<dynamic>(spaceOptional))
      .seq(XmlToken.equals.toParser())
      .seq(ref0<dynamic>(spaceOptional))
      .seq(ref0<dynamic>(attributeValue));

  Parser attributeValue() => ref0<dynamic>(attributeValueDouble).or(ref0<dynamic>(attributeValueSingle));

  Parser attributeValueDouble() => XmlToken.doubleQuote
      .toParser()
      .seq(XmlCharacterDataParser(entityMapping, XmlToken.doubleQuote, 0))
      .seq(XmlToken.doubleQuote.toParser());

  Parser attributeValueSingle() => XmlToken.singleQuote
      .toParser()
      .seq(XmlCharacterDataParser(entityMapping, XmlToken.singleQuote, 0))
      .seq(XmlToken.singleQuote.toParser());

  Parser attributes() => ref0<dynamic>(space).seq(ref0<dynamic>(attribute)).pick(1).star();

  Parser comment() => XmlToken.openComment
      .toParser()
      .seq(any().starLazy(XmlToken.closeComment.toParser()).flatten('Expected comment content'))
      .seq(XmlToken.closeComment.toParser());

  Parser cdata() => XmlToken.openCDATA
      .toParser()
      .seq(any().starLazy(XmlToken.closeCDATA.toParser()).flatten('Expected CDATA content'))
      .seq(XmlToken.closeCDATA.toParser());

  Parser content() => ref0<dynamic>(characterData)
      .or(ref0<dynamic>(element))
      .or(ref0<dynamic>(processing))
      .or(ref0<dynamic>(comment))
      .or(ref0<dynamic>(cdata))
      .star();

  Parser declaration() => XmlToken.openDeclaration
      .toParser()
      .seq(ref0<dynamic>(attributes))
      .seq(ref0<dynamic>(spaceOptional))
      .seq(XmlToken.closeDeclaration.toParser());

  Parser doctype() => XmlToken.openDoctype
      .toParser()
      .seq(ref0<dynamic>(space))
      .seq(ref0<dynamic>(nameToken)
          .or(ref0<dynamic>(attributeValue))
          .or(XmlToken.openDoctypeBlock
              .toParser()
              .seq(any().starLazy(XmlToken.closeDoctypeBlock.toParser()))
              .seq(XmlToken.closeDoctypeBlock.toParser()))
          .separatedBy<dynamic>(ref0<dynamic>(spaceOptional))
          .flatten('Expected doctype content'))
      .seq(ref0<dynamic>(spaceOptional))
      .seq(XmlToken.closeDoctype.toParser());

  Parser document() => ref0<dynamic>(declaration)
      .optional()
      .seq(ref0<dynamic>(misc))
      .seq(ref0<dynamic>(doctype).optional())
      .seq(ref0<dynamic>(misc))
      .seq(ref0<dynamic>(element))
      .seq(ref0<dynamic>(misc));

  Parser documentFragment() => ref0<dynamic>(documentFragmentContent)
      .star()
      .seq(endOfInput('Expected end of input') | ref0<dynamic>(element))
      .pick(0);

  Parser documentFragmentContent() => ref0<dynamic>(characterData)
      .or(ref0<dynamic>(element))
      .or(ref0<dynamic>(comment))
      .or(ref0<dynamic>(cdata))
      .or(ref0<dynamic>(declaration))
      .or(ref0<dynamic>(processing))
      .or(ref0<dynamic>(doctype));

  Parser element() => XmlToken.openElement
      .toParser()
      .seq(ref0<dynamic>(qualified))
      .seq(ref0<dynamic>(attributes))
      .seq(ref0<dynamic>(spaceOptional))
      .seq(XmlToken.closeEndElement.toParser().or(XmlToken.closeElement
          .toParser()
          .seq(ref0<dynamic>(content))
          .seq(XmlToken.openEndElement.toParser().token())
          .seq(ref0<dynamic>(qualified))
          .seq(ref0<dynamic>(spaceOptional))
          .seq(XmlToken.closeElement.toParser())));

  Parser processing() => XmlToken.openProcessing
      .toParser()
      .seq(ref0<dynamic>(nameToken))
      .seq(ref0<dynamic>(space)
          .seq(any()
              .starLazy(XmlToken.closeProcessing.toParser())
              .flatten('Expected processing instruction content'))
          .pick(1)
          .optionalWith(''))
      .seq(XmlToken.closeProcessing.toParser());

  Parser qualified() => ref0<dynamic>(nameToken);

  Parser characterData() => XmlCharacterDataParser(entityMapping, XmlToken.openElement, 1);

  Parser misc() => ref0<dynamic>(spaceText).or(ref0<dynamic>(comment)).or(ref0<dynamic>(processing)).star();

  Parser space() => whitespace().plus();

  Parser spaceText() => ref0<dynamic>(space).flatten('Expected whitespace');

  Parser spaceOptional() => whitespace().star();

  Parser nameToken() =>
      ref0<dynamic>(nameStartChar).seq(ref0<dynamic>(nameChar).star()).flatten('Expected name');

  Parser nameStartChar() => pattern(_nameStartChars);

  Parser nameChar() => pattern(_nameChars);

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
  static const String _nameChars = '$_nameStartChars'
      '-.0-9'
      '\u00b7'
      '\u0300-\u036f'
      '\u203f-\u2040';
}
