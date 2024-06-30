// ignore_for_file: prefer_final_parameters

import 'package:test/test.dart';
import 'package:xml2/src/xml/nodes/parse.dart';

void verifyIterator<T>(Iterable<T> iterable) {
  final iterator = iterable.iterator;
  while (iterator.moveNext()) {
    expect(iterator.current, isNotNull);
  }
  expect(iterator.moveNext(), isFalse);
}

void main() {
  const bookXml = '<book>'
      '<title lang="en" price="12.00">XML</title>'
      '<description/>'
      '</book>';
  final book = parseXmlDocument(bookXml);
  test('ancestors', () {
    expect(book.ancestors, <dynamic>[]);
    expect(book.children[0].ancestors, [book]);
    expect(book.children[0].children[0].ancestors, [book.children[0], book]);
    expect(book.children[0].children[0].attributes[0].ancestors,
        [book.children[0].children[0], book.children[0], book]);
    expect(book.children[0].children[0].attributes[1].ancestors,
        [book.children[0].children[0], book.children[0], book]);
    expect(book.children[0].children[0].children[0].ancestors,
        [book.children[0].children[0], book.children[0], book]);
    expect(book.children[0].children[1].ancestors, [book.children[0], book]);
    verifyIterator(book.children[0].children[1].ancestors);
  });
  test('ancestorElements', () {
    expect(book.ancestorElements, <dynamic>[]);
    expect(book.children[0].ancestorElements, <dynamic>[]);
    expect(book.children[0].children[0].ancestorElements, [book.children[0]]);
    expect(book.children[0].children[0].attributes[0].ancestorElements,
        [book.children[0].children[0], book.children[0]]);
    expect(book.children[0].children[0].attributes[1].ancestorElements,
        [book.children[0].children[0], book.children[0]]);
    expect(book.children[0].children[0].children[0].ancestorElements,
        [book.children[0].children[0], book.children[0]]);
    expect(book.children[0].children[1].ancestorElements, [book.children[0]]);
    verifyIterator(book.children[0].children[1].ancestorElements);
  });
  test('preceding', () {
    expect(book.preceding, <dynamic>[]);
    expect(book.children[0].preceding, [book]);
    expect(book.children[0].children[0].preceding, [book, book.children[0]]);
    expect(book.children[0].children[0].attributes[0].preceding,
        [book, book.children[0], book.children[0].children[0]]);
    expect(book.children[0].children[0].attributes[1].preceding, [
      book,
      book.children[0],
      book.children[0].children[0],
      book.children[0].children[0].attributes[0]
    ]);
    expect(book.children[0].children[0].children[0].preceding, [
      book,
      book.children[0],
      book.children[0].children[0],
      book.children[0].children[0].attributes[0],
      book.children[0].children[0].attributes[1]
    ]);
    expect(book.children[0].children[1].preceding, [
      book,
      book.children[0],
      book.children[0].children[0],
      book.children[0].children[0].attributes[0],
      book.children[0].children[0].attributes[1],
      book.children[0].children[0].children[0]
    ]);
    verifyIterator(book.children[0].children[1].preceding);
  });
  test('precedingElements', () {
    expect(book.precedingElements, <dynamic>[]);
    expect(book.children[0].precedingElements, <dynamic>[]);
    expect(book.children[0].children[0].precedingElements, [book.children[0]]);
    expect(book.children[0].children[0].attributes[0].precedingElements,
        [book.children[0], book.children[0].children[0]]);
    expect(book.children[0].children[0].attributes[1].precedingElements,
        [book.children[0], book.children[0].children[0]]);
    expect(book.children[0].children[0].children[0].precedingElements,
        [book.children[0], book.children[0].children[0]]);
    expect(book.children[0].children[1].precedingElements,
        [book.children[0], book.children[0].children[0]]);
    verifyIterator(book.children[0].children[1].precedingElements);
  });
  test('descendants', () {
    expect(book.descendants, [
      book.children[0],
      book.children[0].children[0],
      book.children[0].children[0].attributes[0],
      book.children[0].children[0].attributes[1],
      book.children[0].children[0].children[0],
      book.children[0].children[1]
    ]);
    expect(book.children[0].descendants, [
      book.children[0].children[0],
      book.children[0].children[0].attributes[0],
      book.children[0].children[0].attributes[1],
      book.children[0].children[0].children[0],
      book.children[0].children[1]
    ]);
    expect(book.children[0].children[0].descendants, [
      book.children[0].children[0].attributes[0],
      book.children[0].children[0].attributes[1],
      book.children[0].children[0].children[0]
    ]);
    expect(book.children[0].children[0].attributes[0].descendants, <dynamic>[]);
    expect(book.children[0].children[0].attributes[1].descendants, <dynamic>[]);
    expect(book.children[0].children[0].children[0].descendants, <dynamic>[]);
    expect(book.children[0].children[1].descendants, <dynamic>[]);
    verifyIterator(book.descendants);
  });
  test('descendantElements', () {
    expect(book.descendantElements, [
      book.children[0],
      book.children[0].children[0],
      book.children[0].children[1]
    ]);
    expect(book.children[0].descendantElements,
        [book.children[0].children[0], book.children[0].children[1]]);
    expect(book.children[0].children[0].descendantElements, <dynamic>[]);
    expect(book.children[0].children[0].attributes[0].descendantElements, <dynamic>[]);
    expect(book.children[0].children[0].attributes[1].descendantElements, <dynamic>[]);
    expect(book.children[0].children[0].children[0].descendantElements, <dynamic>[]);
    expect(book.children[0].children[1].descendantElements, <dynamic>[]);
    verifyIterator(book.descendantElements);
  });
  test('following', () {
    expect(book.following, <dynamic>[]);
    expect(book.children[0].following, <dynamic>[]);
    expect(
        book.children[0].children[0].following, [book.children[0].children[1]]);
    expect(book.children[0].children[0].attributes[0].following, [
      book.children[0].children[0].attributes[1],
      book.children[0].children[0].children[0],
      book.children[0].children[1]
    ]);
    expect(book.children[0].children[0].attributes[1].following, [
      book.children[0].children[0].children[0],
      book.children[0].children[1]
    ]);
    expect(book.children[0].children[0].children[0].following,
        [book.children[0].children[1]]);
    expect(book.children[0].children[1].following, <dynamic>[]);
    verifyIterator(book.following);
  });
  test('followingElements', () {
    expect(book.followingElements, <dynamic>[]);
    expect(book.children[0].followingElements, <dynamic>[]);
    expect(book.children[0].children[0].followingElements,
        [book.children[0].children[1]]);
    expect(book.children[0].children[0].attributes[0].followingElements,
        [book.children[0].children[1]]);
    expect(book.children[0].children[0].attributes[1].followingElements,
        [book.children[0].children[1]]);
    expect(book.children[0].children[0].children[0].followingElements,
        [book.children[0].children[1]]);
    expect(book.children[0].children[1].followingElements, <dynamic>[]);
    verifyIterator(book.followingElements);
  });
  test('nodes', () {
    expect(book.nodes, [book.children[0]]);
    expect(book.children[0].nodes,
        [book.children[0].children[0], book.children[0].children[1]]);
    expect(book.children[0].children[0].nodes, [
      book.children[0].children[0].attributes[0],
      book.children[0].children[0].attributes[1],
      book.children[0].children[0].children[0]
    ]);
    expect(book.children[0].children[0].attributes[0].nodes, <dynamic>[]);
    expect(book.children[0].children[0].attributes[1].nodes, <dynamic>[]);
    expect(book.children[0].children[0].children[0].nodes, <dynamic>[]);
    expect(book.children[0].children[1].nodes, <dynamic>[]);
    verifyIterator(book.nodes);
  });
}
