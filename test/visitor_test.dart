import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('normalizer', () {
    test('remove empty text', () {
      final element = XmlElementSyntheticImpl(createXmlName('element'), [], [
        XmlTextSyntheticImpl(''),
        XmlElementSyntheticImpl(createXmlName('element1')),
        XmlTextSyntheticImpl(''),
        XmlElementSyntheticImpl(createXmlName('element2')),
        XmlTextSyntheticImpl(''),
      ]);
      element.normalize();
      expect(element.children.length, 2);
      expect(
          element.toXmlString(), '<element><element1/><element2/></element>');
    });
    test('join adjacent text', () {
      final element = XmlElementSyntheticImpl(createXmlName('element'), [], [
        XmlTextSyntheticImpl('aaa'),
        XmlTextSyntheticImpl('bbb'),
        XmlTextSyntheticImpl('ccc'),
      ]);
      element.normalize();
      expect(element.children.length, 1);
      expect(element.toXmlString(), '<element>aaabbbccc</element>');
    });
    test('document fragment', () {
      final fragment = XmlDocumentFragmentSyntheticImpl([
        XmlTextSyntheticImpl(''),
        XmlTextSyntheticImpl('aaa'),
        XmlTextSyntheticImpl(''),
        XmlElementSyntheticImpl(createXmlName('element1')),
        XmlTextSyntheticImpl(''),
        XmlTextSyntheticImpl('bbb'),
        XmlTextSyntheticImpl(''),
        XmlTextSyntheticImpl('ccc'),
        XmlTextSyntheticImpl(''),
        XmlElementSyntheticImpl(createXmlName('element2')),
        XmlTextSyntheticImpl(''),
        XmlTextSyntheticImpl('ddd'),
        XmlTextSyntheticImpl(''),
      ]);
      fragment.normalize();
      final element = XmlElementSyntheticImpl(createXmlName('element'));
      element.children.add(fragment);
      expect(element.children.length, 5);
      expect(element.toXmlString(),
          '<element>aaa<element1/>bbbccc<element2/>ddd</element>');
    });
  });
  group('writer', () {
    final document = parseXmlDocument('<body>\n'
        '  <a>\tWhat\r the  heck?\n</a>\n'
        '  <b>\tWhat\r the  heck?\n</b>\n'
        '</body>');
    test('default', () {
      final output = document.toXmlString();
      expect(
          output,
          '<body>\n'
          '  <a>\tWhat\r the  heck?\n</a>\n'
          '  <b>\tWhat\r the  heck?\n</b>\n'
          '</body>');
    });
    test('pretty', () {
      final output = document.toXmlString(pretty: true);
      expect(
          output,
          '<body>\n'
          '  <a>What the heck?</a>\n'
          '  <b>What the heck?</b>\n'
          '</body>');
    });
    test('indent', () {
      final output = document.toXmlString(pretty: true, indent: '\t');
      expect(
          output,
          '<body>\n'
          '\t<a>What the heck?</a>\n'
          '\t<b>What the heck?</b>\n'
          '</body>');
    });
    test('newline', () {
      final output = document.toXmlString(pretty: true, newLine: '\r\n');
      expect(
          output,
          '<body>\r\n'
          '  <a>What the heck?</a>\r\n'
          '  <b>What the heck?</b>\r\n'
          '</body>');
    });
    group('whitespace', () {
      test('preserve all', () {
        final output = document.toXmlString(
            pretty: true, preserveWhitespace: (node) => true);
        expect(
            output,
            '<body>\n'
            '  <a>\tWhat\r the  heck?\n</a>\n'
            '  <b>\tWhat\r the  heck?\n</b>\n'
            '</body>');
      });
      test('preserve some', () {
        final output = document.toXmlString(
            pretty: true,
            preserveWhitespace: (node) =>
                node is XmlElement && node.name.local == 'b');
        expect(
            output,
            '<body>\n'
            '  <a>What the heck?</a>\n'
            '  <b>\tWhat\r the  heck?\n</b>\n'
            '</body>');
      });
      test('preserve nested', () {
        final input = parseXmlDocument('<html><body>'
            '<p><b>bold</b>, <i>italic</i> and <b><i>both</i></b>.</p>'
            '</body></html>');
        final output = input.toXmlString(
            pretty: true,
            preserveWhitespace: (node) =>
                node is XmlElement && node.name.local == 'p');
        expect(
            output,
            '<html>\n'
            '  <body>\n'
            '    <p><b>bold</b>, <i>italic</i> and <b><i>both</i></b>.</p>\n'
            '  </body>\n'
            '</html>');
      });
      test('normalize text', () {
        final input = XmlDocumentSyntheticImpl([
          XmlElementSyntheticImpl(createXmlNameFromString('contents'), [], [
            XmlTextSyntheticImpl(' Hello '),
            XmlTextSyntheticImpl('   '),
            XmlTextSyntheticImpl(' World '),
            XmlTextSyntheticImpl(' '),
          ])
        ]);
        final output = input.toXmlString(pretty: true);
        expect(output, '<contents>Hello World</contents>');
      });
    });
    group('attributes', () {
      const input = '<body>'
          '<a a="1">AAA</a>'
          '<b a="1" b="2">BBB</b>'
          '<c a="1" b="2" c="3">CCC</c>'
          '</body>';
      final document = parseXmlDocument(input);
      tearDown(() => expect(document.toXmlString(), input,
          reason: 'Modified the original DOM.'));
      test('indent none', () {
        final output = document.toXmlString(
          pretty: true,
          indentAttribute: (node) => false,
        );
        expect(
            output,
            '<body>\n'
            '  <a a="1">AAA</a>\n'
            '  <b a="1" b="2">BBB</b>\n'
            '  <c a="1" b="2" c="3">CCC</c>\n'
            '</body>');
      });
      test('indent all', () {
        final output = document.toXmlString(
          pretty: true,
          indentAttribute: (node) => true,
        );
        expect(
            output,
            '<body>\n'
            '  <a\n'
            '    a="1">AAA</a>\n'
            '  <b\n'
            '    a="1"\n'
            '    b="2">BBB</b>\n'
            '  <c\n'
            '    a="1"\n'
            '    b="2"\n'
            '    c="3">CCC</c>\n'
            '</body>');
      });
      test('intend after first', () {
        final output = document.toXmlString(
          pretty: true,
          indentAttribute: (node) => node.parent!.attributes.first != node,
        );
        expect(
            output,
            '<body>\n'
            '  <a a="1">AAA</a>\n'
            '  <b a="1"\n'
            '    b="2">BBB</b>\n'
            '  <c a="1"\n'
            '    b="2"\n'
            '    c="3">CCC</c>\n'
            '</body>');
      });
      test('indent when multiple', () {
        final output = document.toXmlString(
          pretty: true,
          indentAttribute: (node) => node.parent!.attributes.length > 1,
        );
        expect(
            output,
            '<body>\n'
            '  <a a="1">AAA</a>\n'
            '  <b\n'
            '    a="1"\n'
            '    b="2">BBB</b>\n'
            '  <c\n'
            '    a="1"\n'
            '    b="2"\n'
            '    c="3">CCC</c>\n'
            '</body>');
      });
      test('indent every second', () {
        final output = document.toXmlString(
          pretty: true,
          indentAttribute: (node) {
            final index = node.parent!.attributes.indexOf(node);
            return index > 0 && index.isEven;
          },
        );
        expect(
            output,
            '<body>\n'
            '  <a a="1">AAA</a>\n'
            '  <b a="1" b="2">BBB</b>\n'
            '  <c a="1" b="2"\n'
            '    c="3">CCC</c>\n'
            '</body>');
      });
      test('no indent in preserve mode', () {
        final output = document.toXmlString(
          pretty: true,
          preserveWhitespace: (node) => true,
          indentAttribute: (node) => true,
        );
        expect(
            output,
            '<body>'
            '<a a="1">AAA</a>'
            '<b a="1" b="2">BBB</b>'
            '<c a="1" b="2" c="3">CCC</c>'
            '</body>');
      });
      test('sort reverse', () {
        final output = document.toXmlString(
          pretty: true,
          sortAttributes: (a, b) =>
              b.name.qualified.compareTo(a.name.qualified),
        );
        expect(
            output,
            '<body>\n'
            '  <a a="1">AAA</a>\n'
            '  <b b="2" a="1">BBB</b>\n'
            '  <c c="3" b="2" a="1">CCC</c>\n'
            '</body>');
      });
      test('sort reverse in preserve mode', () {
        final output = document.toXmlString(
          pretty: true,
          preserveWhitespace: (n) => true,
          sortAttributes: (a, b) =>
              b.name.qualified.compareTo(a.name.qualified),
        );
        expect(
            output,
            '<body>'
            '<a a="1">AAA</a>'
            '<b b="2" a="1">BBB</b>'
            '<c c="3" b="2" a="1">CCC</c>'
            '</body>');
      });
      test('insert space before self-closing', () {
        final element = XmlElementSyntheticImpl(
          createXmlName('base'),
          [],
          [
            XmlElementSyntheticImpl(createXmlName('simple')),
            XmlElementSyntheticImpl(
              createXmlName('with-attributes'),
              [XmlAttributeSyntheticImpl(createXmlName('attr'), 'val')],
            ),
            XmlElementSyntheticImpl(createXmlName('do-not-add')),
          ],
        );

        final output = element.toXmlString(
          pretty: true,
          spaceBeforeSelfClose: (node) =>
              node is XmlElement && node.name.local != 'do-not-add',
        );
        expect(
          output,
          '<base>\n'
          '  <simple />\n'
          '  <with-attributes attr="val" />\n'
          '  <do-not-add/>\n'
          '</base>',
        );
      });
    });
  });
}
