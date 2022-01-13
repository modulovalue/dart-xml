import 'entities/entity_mapping.dart';
import 'nodes/synthetic_impl.dart';
import 'nodes/interface.dart';
import 'nodes/parse.dart';
import 'utils/attribute_type.dart';
import 'utils/character_data_parser.dart';
import 'package:petitparser/petitparser.dart';

import 'utils/exceptions.dart';
import 'utils/token.dart';

/// XML parser that defines standard actions to the the XML tree.
class XmlParserDefinition extends XmlGrammarDefinition<XmlNode, XmlName> {
  XmlParserDefinition(XmlEntityMapping entityMapping) : super(entityMapping);

  @override
  XmlAttribute createAttribute(
          XmlName name, String text, XmlAttributeType type) =>
      XmlAttributeSyntheticImpl(name, text, type);

  @override
  XmlComment createComment(String text) => XmlCommentSyntheticImpl(text);

  @override
  XmlCDATA createCDATA(String text) => XmlCDATASyntheticImpl(text);

  @override
  XmlDeclaration createDeclaration(Iterable<XmlNode> attributes) =>
      XmlDeclarationSyntheticImpl(attributes.cast<XmlAttribute>());

  @override
  XmlDoctype createDoctype(String text) => XmlDoctypeSyntheticImpl(text);

  @override
  XmlDocument createDocument(Iterable<XmlNode> children) =>
      XmlDocumentSyntheticImpl(children);

  @override
  XmlNode createDocumentFragment(Iterable<XmlNode> children) =>
      XmlDocumentFragmentSyntheticImpl(children);

  @override
  XmlElement createElement(XmlName name, Iterable<XmlNode> attributes,
          Iterable<XmlNode> children, [bool isSelfClosing = true]) =>
      XmlElementSyntheticImpl(
          name, attributes.cast<XmlAttribute>(), children, isSelfClosing);

  @override
  XmlProcessing createProcessing(String target, String text) =>
      XmlProcessingSyntheticImpl(target, text);

  @override
  XmlName createQualified(String name) => createXmlNameFromString(name);

  @override
  XmlText createText(String text) => XmlTextSyntheticImpl(text);
}

/// XML grammar definition with [TNode] and [TName].
abstract class XmlGrammarDefinition<TNode, TName>
    extends XmlProductionDefinition {
  XmlGrammarDefinition(XmlEntityMapping entityMapping) : super(entityMapping);

  // Callbacks used to build the XML AST.
  TNode createAttribute(TName name, String text, XmlAttributeType type);

  TNode createComment(String text);

  TNode createCDATA(String text);

  TNode createDeclaration(Iterable<TNode> attributes);

  TNode createDoctype(String text);

  TNode createDocument(Iterable<TNode> children);

  TNode createDocumentFragment(Iterable<TNode> children);

  TNode createElement(TName name, Iterable<TNode> attributes,
      Iterable<TNode> children, bool isSelfClosing);

  TNode createProcessing(String target, String text);

  TName createQualified(String name);

  TNode createText(String text);

  // Connects the productions and the XML AST callbacks.

  @override
  Parser attribute() => super
      .attribute()
      .map((each) => createAttribute(each[0], each[4][0], each[4][1]));

  @override
  Parser attributeValueDouble() => super
      .attributeValueDouble()
      .map((each) => [each[1], XmlAttributeType.DOUBLE_QUOTE]);

  @override
  Parser attributeValueSingle() => super
      .attributeValueSingle()
      .map((each) => [each[1], XmlAttributeType.SINGLE_QUOTE]);

  @override
  Parser comment() => super.comment().map((each) => createComment(each[1]));

  @override
  Parser declaration() => super
      .declaration()
      .map((each) => createDeclaration(each[1].cast<TNode>()));

  @override
  Parser cdata() => super.cdata().map((each) => createCDATA(each[1]));

  @override
  Parser doctype() => super.doctype().map((each) => createDoctype(each[2]));

  @override
  Parser document() => super.document().map((each) {
    final nodes = [];
    if (each[0] != null) {
      nodes.add(each[0]); // declaration
    }
    nodes.addAll(each[1]);
    if (each[2] != null) {
      nodes.add(each[2]); // doctype
    }
    nodes.addAll(each[3]);
    nodes.add(each[4]); // document
    nodes.addAll(each[5]);
    return createDocument(nodes.cast<TNode>());
  });

  @override
  Parser documentFragment() => super
      .documentFragment()
      .map((nodes) => createDocumentFragment(nodes.cast<TNode>()));

  @override
  Parser element() => super.element().map((list) {
    final TName name = list[1];
    final attributes = list[2].cast<TNode>();
    if (list[4] == XmlToken.closeEndElement) {
      return createElement(name, attributes, [], true);
    } else {
      if (list[1] == list[4][3]) {
        final children = list[4][1].cast<TNode>();
        return createElement(
            name, attributes, children, children.isNotEmpty);
      } else {
        final Token token = list[4][2];
        final lineAndColumn =
        Token.lineAndColumnOf(token.buffer, token.start);
        throw XmlParserException(
            'Expected </${list[1]}>, but found </${list[4][3]}>',
            buffer: token.buffer,
            position: token.start,
            line: lineAndColumn[0],
            column: lineAndColumn[1]);
      }
    }
  });

  @override
  Parser processing() =>
      super.processing().map((each) => createProcessing(each[1], each[2]));

  @override
  Parser qualified() => super.qualified().cast<String>().map(createQualified);

  @override
  Parser characterData() =>
      super.characterData().cast<String>().map(createText);

  @override
  Parser spaceText() => super.spaceText().cast<String>().map(createText);
}

/// XML parser that defines standard actions to the the XML tree.
class XmlProductionDefinition extends GrammarDefinition {
  XmlProductionDefinition(this.entityMapping);

  final XmlEntityMapping entityMapping;

  @override
  Parser start() => ref0(document).end('Expected end of input');

  Parser attribute() => ref0(qualified)
      .seq(ref0(spaceOptional))
      .seq(XmlToken.equals.toParser())
      .seq(ref0(spaceOptional))
      .seq(ref0(attributeValue));

  Parser attributeValue() =>
      ref0(attributeValueDouble).or(ref0(attributeValueSingle));

  Parser attributeValueDouble() => XmlToken.doubleQuote
      .toParser()
      .seq(XmlCharacterDataParser(entityMapping, XmlToken.doubleQuote, 0))
      .seq(XmlToken.doubleQuote.toParser());

  Parser attributeValueSingle() => XmlToken.singleQuote
      .toParser()
      .seq(XmlCharacterDataParser(entityMapping, XmlToken.singleQuote, 0))
      .seq(XmlToken.singleQuote.toParser());

  Parser attributes() => ref0(space).seq(ref0(attribute)).pick(1).star();

  Parser comment() => XmlToken.openComment
      .toParser()
      .seq(any()
      .starLazy(XmlToken.closeComment.toParser())
      .flatten('Expected comment content'))
      .seq(XmlToken.closeComment.toParser());

  Parser cdata() => XmlToken.openCDATA
      .toParser()
      .seq(any()
      .starLazy(XmlToken.closeCDATA.toParser())
      .flatten('Expected CDATA content'))
      .seq(XmlToken.closeCDATA.toParser());

  Parser content() => ref0(characterData)
      .or(ref0(element))
      .or(ref0(processing))
      .or(ref0(comment))
      .or(ref0(cdata))
      .star();

  Parser declaration() => XmlToken.openDeclaration
      .toParser()
      .seq(ref0(attributes))
      .seq(ref0(spaceOptional))
      .seq(XmlToken.closeDeclaration.toParser());

  Parser doctype() => XmlToken.openDoctype
      .toParser()
      .seq(ref0(space))
      .seq(ref0(nameToken)
      .or(ref0(attributeValue))
      .or(XmlToken.openDoctypeBlock
      .toParser()
      .seq(any().starLazy(XmlToken.closeDoctypeBlock.toParser()))
      .seq(XmlToken.closeDoctypeBlock.toParser()))
      .separatedBy(ref0(spaceOptional))
      .flatten('Expected doctype content'))
      .seq(ref0(spaceOptional))
      .seq(XmlToken.closeDoctype.toParser());

  Parser document() => ref0(declaration)
      .optional()
      .seq(ref0(misc))
      .seq(ref0(doctype).optional())
      .seq(ref0(misc))
      .seq(ref0(element))
      .seq(ref0(misc));

  Parser documentFragment() => ref0(documentFragmentContent)
      .star()
      .seq(endOfInput('Expected end of input') | ref0(element))
      .pick(0);

  Parser documentFragmentContent() => ref0(characterData)
      .or(ref0(element))
      .or(ref0(comment))
      .or(ref0(cdata))
      .or(ref0(declaration))
      .or(ref0(processing))
      .or(ref0(doctype));

  Parser element() => XmlToken.openElement
      .toParser()
      .seq(ref0(qualified))
      .seq(ref0(attributes))
      .seq(ref0(spaceOptional))
      .seq(XmlToken.closeEndElement.toParser().or(XmlToken.closeElement
      .toParser()
      .seq(ref0(content))
      .seq(XmlToken.openEndElement.toParser().token())
      .seq(ref0(qualified))
      .seq(ref0(spaceOptional))
      .seq(XmlToken.closeElement.toParser())));

  Parser processing() => XmlToken.openProcessing
      .toParser()
      .seq(ref0(nameToken))
      .seq(ref0(space)
      .seq(any()
      .starLazy(XmlToken.closeProcessing.toParser())
      .flatten('Expected processing instruction content'))
      .pick(1)
      .optionalWith(''))
      .seq(XmlToken.closeProcessing.toParser());

  Parser qualified() => ref0(nameToken);

  Parser characterData() =>
      XmlCharacterDataParser(entityMapping, XmlToken.openElement, 1);

  Parser misc() =>
      ref0(spaceText).or(ref0(comment)).or(ref0(processing)).star();

  Parser space() => whitespace().plus();

  Parser spaceText() => ref0(space).flatten('Expected whitespace');

  Parser spaceOptional() => whitespace().star();

  Parser nameToken() =>
      ref0(nameStartChar).seq(ref0(nameChar).star()).flatten('Expected name');

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
