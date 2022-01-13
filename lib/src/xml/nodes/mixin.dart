import 'package:meta/meta.dart';

import '../../../xml.dart';
import '../utils/name_matcher.dart';
import '../utils/namespace.dart';
import '../utils/node_list.dart';
import '../utils/predicate.dart';
import 'parse.dart';

/// Immutable abstract XML node.
mixin XmlNodeMixin implements XmlNode {
  @override
  XmlNode copy();

  @override
  String get outerXml => toXmlString();

  @override
  set outerXml(String value) => replace(parseXmlDocumentFragment(value));

  @override
  String get innerXml => children.map((node) => node.toXmlString()).join();

  @override
  set innerXml(String value) => children
    ..clear()
    ..add(parseXmlDocumentFragment(value));

  @override
  final XmlNodeList<XmlNode> children = XmlNodeList<XmlNode>();

  @override
  Iterable<XmlElement> get childElements => children.whereType<XmlElement>();

  @override
  XmlElement? getElement(String name, {String? namespace}) {
    final tester = createNameMatcher(name, namespace);
    for (final node in children) {
      if (node is XmlElement && tester(node)) {
        return node;
      }
    }
    return null;
  }

  @override
  XmlNode? get firstChild => children.isEmpty ? null : children.first;

  @override
  XmlElement? get firstElementChild {
    for (final node in children) {
      if (node is XmlElement) {
        return node;
      }
    }
    return null;
  }

  @override
  XmlNode? get lastChild => children.isEmpty ? null : children.last;

  @override
  XmlElement? get lastElementChild {
    for (final node in children.reversed) {
      if (node is XmlElement) {
        return node;
      }
    }
    return null;
  }

  @override
  String toXmlString({
    bool pretty = false,
    XmlEntityMapping? entityMapping,
    int? level,
    String? indent,
    String? newLine,
    Predicate<XmlNode>? preserveWhitespace,
    Predicate<XmlAttribute>? indentAttribute,
    Comparator<XmlAttribute>? sortAttributes,
    Predicate<XmlNode>? spaceBeforeSelfClose,
  }) {
    final buffer = StringBuffer();
    final writer = pretty
        ? XmlPrettyWriter(
            buffer,
            entityMapping: entityMapping,
            level: level,
            indent: indent,
            newLine: newLine,
            preserveWhitespace: preserveWhitespace,
            indentAttribute: indentAttribute,
            sortAttributes: sortAttributes,
            spaceBeforeSelfClose: spaceBeforeSelfClose,
          )
        : XmlWriter(buffer, entityMapping: entityMapping);
    accept(writer);
    return buffer.toString();
  }

  @override
  String get text => innerText;

  @override
  String get innerText => XmlDescendantsIterable(this)
      .where((node) => node is XmlText || node is XmlCDATA)
      .map((node) => node.text)
      .join();

  @override
  set innerText(String value) {
    children.clear();
    if (value.isNotEmpty) {
      children.add(XmlTextSyntheticImpl(value));
    }
  }

  @override
  List<XmlAttribute> get attributes => const [];

  @override
  String? getAttribute(String name, {String? namespace}) => null;

  @override
  XmlAttribute? getAttributeNode(String name, {String? namespace}) => null;

  @override
  void setAttribute(String name, String? value, {String? namespace}) =>
      throw UnsupportedError('$this has no attributes.');

  @override
  void removeAttribute(String name, {String? namespace}) => setAttribute(name, null, namespace: namespace);

  @override
  XmlNode? get parent => null;

  @override
  bool get hasParent => false;

  @override
  void replace(XmlNode other) => _throwNoParent();

  @override
  @internal
  void attachParent(XmlNode parent) => _throwNoParent();

  @override
  @internal
  void detachParent(XmlNode parent) => _throwNoParent();

  void _throwNoParent() => throw UnsupportedError('$this does not have a parent.');

  @override
  T accept<T>(XmlVisitor<T> visitor);

  @override
  String toString() => toXmlString();
}

/// Mixin for nodes with a parent.
mixin XmlParentableMixin implements XmlParentable {
  XmlNode? _parent;

  @override
  XmlNode? get parent => _parent;

  @override
  bool get hasParent => _parent != null;

  @override
  void replace(XmlNode other) {
    if (_parent != null) {
      final siblings = _parent!.children;
      for (var i = 0; i < siblings.length; i++) {
        if (identical(siblings[i], this)) {
          siblings[i] = other;
          break;
        }
      }
    }
  }

  @override
  void attachParent(XmlNode parent) {
    XmlParentException.checkNoParent(this);
    _parent = parent;
  }

  @override
  void detachParent(XmlNode parent) {
    XmlParentException.checkMatchingParent(this, parent);
    _parent = null;
  }
}

/// Mixin for nodes with attributes.
mixin XmlAttributesMixin implements XmlAttributes {
  @override
  final XmlNodeList<XmlAttribute> attributes = XmlNodeList<XmlAttribute>();

  @override
  String? getAttribute(String name, {String? namespace}) =>
      getAttributeNode(name, namespace: namespace)?.value;

  @override
  XmlAttribute? getAttributeNode(String name, {String? namespace}) {
    final tester = createNameMatcher(name, namespace);
    for (final attribute in attributes) {
      if (tester(attribute)) {
        return attribute;
      }
    }
    return null;
  }

  @override
  void setAttribute(String name, String? value, {String? namespace}) {
    final index = attributes.indexWhere(createNameMatcher(name, namespace));
    if (index < 0) {
      if (value != null) {
        final prefix = namespace == null ? null : lookupNamespacePrefix(this as dynamic, namespace);
        attributes.add(XmlAttributeSyntheticImpl(createXmlName(name, prefix), value));
      }
    } else {
      if (value != null) {
        attributes[index].value = value;
      } else {
        attributes.removeAt(index);
      }
    }
  }
}

mixin XmlNodeNavigateableMixin implements XmlNode {
  @override
  Iterable<XmlNode> get ancestors => XmlAncestorsIterable(this);

  @override
  Iterable<XmlElement> get ancestorElements => ancestors.whereType<XmlElement>();

  @override
  Iterable<XmlNode> get descendants => XmlDescendantsIterable(this);

  @override
  Iterable<XmlElement> get descendantElements => descendants.whereType<XmlElement>();

  @override
  Iterable<XmlElement> findElements(String name, {String? namespace}) =>
      filterElements(children, name, namespace);

  @override
  Iterable<XmlElement> findAllElements(String name, {String? namespace}) =>
      filterElements(descendants, name, namespace);

  @override
  Iterable<XmlNode> get following => XmlFollowingIterable(this);

  @override
  Iterable<XmlElement> get followingElements => following.whereType<XmlElement>();

  @override
  Iterable<XmlNode> get nodes => [...attributes, ...children];

  @override
  XmlNode get root {
    XmlNode current = this;
    while (current.parent != null) {
      current = current.parent!;
    }
    return current;
  }

  @override
  XmlDocument? get document {
    final node = root;
    if (node is XmlDocument) {
      return node;
    } else {
      return null;
    }
  }

  @override
  XmlElement? get parentElement {
    for (var current = parent; current != null; current = current.parent) {
      if (current is XmlElement) {
        return current;
      }
    }
    return null;
  }

  @override
  int get depth {
    var result = 0;
    XmlNode current = this;
    while (current.parent != null) {
      current = current.parent!;
      result++;
    }
    return result;
  }

  @override
  Iterable<XmlNode> get preceding => XmlPrecedingIterable(this);

  @override
  Iterable<XmlElement> get precedingElements => preceding.whereType<XmlElement>();

  @override
  Iterable<XmlNode> get siblings => parent == null ? [this] : parent!.children;

  @override
  Iterable<XmlNode> get siblingElements => siblings.whereType<XmlElement>();

  @override
  XmlNode? get previousSibling {
    if (parent != null) {
      final siblings = parent!.children;
      for (var i = siblings.length - 1; i > 0; i--) {
        if (identical(siblings[i], this)) {
          return siblings[i - 1];
        }
      }
    }
    return null;
  }

  @override
  XmlElement? get previousElementSibling {
    if (parent != null) {
      final siblings = parent!.children;
      for (var i = siblings.length - 1; i > 0; i--) {
        if (identical(siblings[i], this)) {
          for (var j = i - 1; j >= 0; j--) {
            final candidate = siblings[j];
            if (candidate is XmlElement) {
              return candidate;
            }
          }
          return null;
        }
      }
    }
    return null;
  }

  @override
  XmlNode? get nextSibling {
    if (parent != null) {
      final siblings = parent!.children;
      for (var i = 0; i < siblings.length - 1; i++) {
        if (identical(siblings[i], this)) {
          return siblings[i + 1];
        }
      }
    }
    return null;
  }

  @override
  XmlElement? get nextElementSibling {
    if (parent != null) {
      final siblings = parent!.children;
      for (var i = 0; i < siblings.length - 1; i++) {
        if (identical(siblings[i], this)) {
          for (var j = i + 1; j < siblings.length; j++) {
            final candidate = siblings[j];
            if (candidate is XmlElement) {
              return candidate;
            }
          }
          return null;
        }
      }
    }
    return null;
  }
}
