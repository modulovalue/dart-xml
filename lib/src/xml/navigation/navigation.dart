// ignore_for_file: prefer_final_parameters

import 'dart:collection';

import '../nodes/synthetic_interface.dart';
import '../utils/name_matcher.dart';

/// Iterable to walk over the ancestors of a node.
class XmlAncestorsIterable extends IterableBase<XmlNode> {
  XmlAncestorsIterable(this._start);

  final XmlNode _start;

  @override
  Iterator<XmlNode> get iterator => XmlAncestorsIterator(_start);
}

/// Iterator to walk over the ancestors of a node.
class XmlAncestorsIterator extends Iterator<XmlNode> {
  XmlAncestorsIterator(this._current);

  XmlNode? _current;

  @override
  XmlNode get current => _current!;

  @override
  bool moveNext() {
    if (_current != null) {
      _current = _current!.parent;
    }
    return _current != null;
  }
}

/// Iterable to walk over the descendants of a node.
class XmlDescendantsIterable extends IterableBase<XmlNode> {
  XmlDescendantsIterable(this._start);

  final XmlNode _start;

  @override
  Iterator<XmlNode> get iterator => XmlDescendantsIterator(_start);
}

/// Iterator to walk over the descendants of a node.
class XmlDescendantsIterator extends Iterator<XmlNode> {
  XmlDescendantsIterator(XmlNode start) {
    push(start);
  }

  final List<XmlNode> _todo = [];
  late XmlNode _current;

  void push(XmlNode node) {
    _todo.addAll(node.children.reversed);
    _todo.addAll(node.attributes.reversed);
  }

  @override
  XmlNode get current => _current;

  @override
  bool moveNext() {
    if (_todo.isEmpty) {
      return false;
    } else {
      _current = _todo.removeLast();
      push(_current);
      return true;
    }
  }
}

Iterable<XmlElement> filterElements(
  Iterable<XmlNode> iterable,
  String name,
  String? namespace,
) {
  final matcher = createNameMatcher(name, namespace);
  return iterable.whereType<XmlElement>().where(matcher);
}

/// Iterable to walk over the followers of a node.
class XmlFollowingIterable extends IterableBase<XmlNode> {
  XmlFollowingIterable(this._start);

  final XmlNode _start;

  @override
  Iterator<XmlNode> get iterator => XmlFollowingIterator(_start);
}

/// Iterator to walk over the followers of a node.
class XmlFollowingIterator extends Iterator<XmlNode> {
  XmlFollowingIterator(XmlNode start) {
    final following = <XmlNode>[];
    for (var parent = start.parent, child = start;
        parent != null;
        parent = parent.parent, child = child.parent!) {
      if (child is XmlAttribute) {
        final attributesIndex = parent.attributes.indexOf(child);
        following.addAll(parent.attributes.sublist(attributesIndex + 1));
        following.addAll(parent.children);
      } else {
        final childrenIndex = parent.children.indexOf(child);
        following.addAll(parent.children.sublist(childrenIndex + 1));
      }
    }
    _todo.addAll(following.reversed);
  }

  final List<XmlNode> _todo = [];
  XmlNode? _current;

  @override
  XmlNode get current => _current!;

  @override
  bool moveNext() {
    if (_todo.isEmpty) {
      _current = null;
      return false;
    } else {
      _current = _todo.removeLast();
      _todo.addAll(_current!.children.reversed);
      _todo.addAll(_current!.attributes.reversed);
      return true;
    }
  }
}

/// Iterable to walk over the precedents of a node.
class XmlPrecedingIterable extends IterableBase<XmlNode> {
  XmlPrecedingIterable(this._start);

  final XmlNode _start;

  @override
  Iterator<XmlNode> get iterator => XmlPrecedingIterator(_start);
}

/// Iterator to walk over the precedents of a node.
class XmlPrecedingIterator extends Iterator<XmlNode> {
  XmlPrecedingIterator(this._start) {
    _todo.add(_start.root);
  }

  final XmlNode _start;
  final List<XmlNode> _todo = [];
  XmlNode? _current;

  @override
  XmlNode get current => _current!;

  @override
  bool moveNext() {
    if (_todo.isEmpty) {
      _current = null;
      return false;
    } else {
      _current = _todo.removeLast();
      if (identical(_current, _start)) {
        _current = null;
        _todo.clear();
        return false;
      }
      _todo.addAll(_current!.children.reversed);
      _todo.addAll(_current!.attributes.reversed);
      return true;
    }
  }
}
