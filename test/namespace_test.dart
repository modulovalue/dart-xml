import 'package:test/test.dart';
import 'package:xml2/xml.dart';

void main() {
  test('default namespace', () {
    final document =
    parseXmlDocument('<html xmlns="http://www.w3.org/1999/xhtml">'
            '  <body lang="en"/>'
            '</html>');
    final nodes = List<dynamic>.from(document.descendants)..add(document);
    for (final node in nodes) {
      if (node is XmlAttribute && node.name.prefix == 'xmlns') {
        break;
      }
      if (node is XmlHasName) {
        expect(node.name.namespaceUri, 'http://www.w3.org/1999/xhtml');
      }
    }
  });
  test('prefix namespace', () {
    final document = parseXmlDocument(
        '<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">'
        '  <xhtml:body xhtml:lang="en"/>'
        '</xhtml:html>');
    final nodes = List<dynamic>.from(document.descendants)..add(document);
    for (final node in nodes) {
      if (node is XmlAttribute && node.name.prefix == 'xmlns') {
        break;
      }
      if (node is XmlHasName) {
        expect(node.name.namespaceUri, 'http://www.w3.org/1999/xhtml');
      }
    }
  });
}
