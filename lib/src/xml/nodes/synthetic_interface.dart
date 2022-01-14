import 'package:meta/meta.dart';

import '../../../xml.dart';
import '../utils/predicate.dart';

/// Immutable abstract XML node.
abstract class XmlNode implements XmlParentable, XmlAttributes, XmlNodeNavigateable {
  /// Return a copy of this node and all its children.
  XmlNode copy();

  /// Return the markup representing this node and all its child nodes.
  String get outerXml;

  /// Replaces the markup representing this node and all its child nodes.
  set outerXml(String value);

  /// Return the markup representing the child nodes of this node.
  String get innerXml;

  /// Replaces the markup representing the child nodes of this node.
  set innerXml(String value);

  /// Return the direct children of this node in document order.
  List<XmlNode> get children;

  /// Return an [Iterable] over the [XmlElement] children of this node.
  Iterable<XmlElement> get childElements;

  /// Return the first child element with the given `name`, or `null`.
  XmlElement? getElement(String name, {String? namespace});

  /// Return the first child of this node, or `null` if there are no children.
  XmlNode? get firstChild;

  /// Return the first child [XmlElement], or `null` if there are none.
  XmlElement? get firstElementChild;

  /// Return the last child of this node, or `null` if there are no children.
  XmlNode? get lastChild;

  /// Return the last child [XmlElement], or `null` if there are none.
  XmlElement? get lastElementChild;

  /// Return an XML string of this object.
  ///
  /// If [pretty] is set to `true` the output is nicely reformatted, otherwise
  /// the tree is emitted verbatim.
  ///
  /// The [entityMapping] defines how character entities are encoded into the
  /// resulting output.
  ///
  /// The remaining options are used for pretty printing only:
  ///
  /// - The option [indent] defines the indention of nodes, by default nodes
  ///   are indented with 2 spaces.
  /// - The option [newLine] defines the printing of new lines, by default
  ///   the standard new-line `'\n'` character is used.
  /// - The option [level] customizes the initial indention level, by default
  ///   this is `0`.
  /// - If the predicate [preserveWhitespace] returns `true`, the whitespace
  ///   characters within the node and its children are preserved by switching
  ///   to non-pretty mode. By default all whitespace is normalized.
  /// - If the predicate [indentAttribute] returns `true`, the attribute
  ///   will be begin on a new line. Has no effect within elements where
  ///   whitespace are preserved.
  /// - If the [sortAttributes] is provided, attributes are on-the-fly sorted
  ///   using the provided [Comparator].
  /// - If the predicate [spaceBeforeSelfClose] returns `true`, self-closing
  ///   elements will be closed with a space before the slash ('<example />')
  ///
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
  });

  /// Return the concatenated text of this node and all its descendants, for
  /// [XmlData] nodes return the textual value of the node.
  String get text;

  /// Return the concatenated text of this node and all its descendants.
  String get innerText;

  /// Replaces the children of this node with text contents.
  set innerText(String value);

  /// Dispatch the invocation depending on this type to the [visitor].
  T accept<T>(XmlVisitor<T> visitor);
}

abstract class XmlNodeNavigateable {
  /// Return a lazy [Iterable] of the ancestors of this node (parent,
  /// grandparent, ...) in reverse document order.
  Iterable<XmlNode> get ancestors;

  /// Return a lazy [Iterable] of the ancestor [XmlElement] nodes of this
  /// node (parent, grandparent, ...) in reverse document order.
  Iterable<XmlElement> get ancestorElements;

  /// Return a lazy [Iterable] of the descendants of this node (attributes,
  /// children, grandchildren, ...) in document order.
  Iterable<XmlNode> get descendants;

  /// Return a lazy [Iterable] of the descendants [XmlElement] nodes of this
  /// node (attributes, children, grandchildren, ...) in document order.
  Iterable<XmlElement> get descendantElements;

  /// Return a lazy [Iterable] of the _direct_ child elements in document
  /// order with the specified tag `name` and `namespace`.
  ///
  /// Both `name` and `namespace` can be set to a specific [String] or `'*'` to
  /// match anything. If no `namespace` is provided, the _fully qualified_ name
  /// will be matched, otherwise only the _local name_ is compared.
  ///
  /// For example:
  /// - `element.findElements('xsd:annotation')` finds all direct child elements
  ///   with the fully qualified tag name `xsd:annotation`.
  /// - `element.findElements('annotation', namespace: '*')` finds all direct
  ///   child elements with the local tag name `annotation` no matter their
  ///   namespace.
  /// - `element.findElements('*', namespace: 'http://www.w3.org/2001/XMLSchema')`
  ///   finds all direct child elements within the provided namespace URI.
  ///
  Iterable<XmlElement> findElements(String name, {String? namespace});

  /// Return a lazy [Iterable] of the _recursive_ child elements in document
  /// order with the specified tag `name`.
  ///
  /// Both `name` and `namespace` can be set to a specific [String] or `'*'` to
  /// match anything. If no `namespace` is provided, the _fully qualified_ name
  /// will be matched, otherwise only the _local name_ is compared.
  ///
  /// For example:
  /// - `document.findAllElements('xsd:annotation')` finds all elements with the
  ///   fully qualified tag name `xsd:annotation`.
  /// - `document.findAllElements('annotation', namespace: '*')` finds all
  ///   elements with the local tag name `annotation` no matter their namespace.
  /// - `document.findAllElements('*', namespace: 'http://www.w3.org/2001/XMLSchema')`
  ///   finds all elements with the given namespace URI.
  ///
  Iterable<XmlElement> findAllElements(String name, {String? namespace});

  /// Return a lazy [Iterable] of the nodes following this node in document
  /// order.
  Iterable<XmlNode> get following;

  /// Return a lazy [Iterable] of the [XmlElement] nodes following this node
  /// in document order.
  Iterable<XmlElement> get followingElements;

  /// Return a lazy [Iterable] of the direct descendants of this [XmlNode]
  /// (attributes, children) in document order.
  Iterable<XmlNode> get nodes;

  /// Return the root of the tree in which this node is found, whether that's
  /// a document or another element.
  XmlNode get root;

  /// Return the document that contains this node, or `null` if the node is
  /// not part of a document.
  XmlDocument? get document;

  /// Return the first parent of this node that is of type [XmlElement], or
  /// `null` if there is none.
  XmlElement? get parentElement;

  /// Return the depth of this node in its tree, a root node has depth 0.
  int get depth;

  /// Return a lazy [Iterable] of the nodes preceding this node in document
  /// order.
  Iterable<XmlNode> get preceding;

  /// Return a lazy [Iterable] of the [XmlElement] nodes preceding this node in
  /// document order.
  Iterable<XmlElement> get precedingElements;

  /// Returns an [Iterable] over the siblings of this node. If the node has
  /// no parent or no siblings, return a collection with just this node.
  Iterable<XmlNode> get siblings;

  /// Returns an [Iterable] over the [XmlElement] siblings of this node. If the
  /// node has no parent or no siblings, return an empty collection.
  Iterable<XmlNode> get siblingElements;

  /// Return the previous sibling of this node, or `null`.
  XmlNode? get previousSibling;

  /// Return the previous element sibling of this node, or `null`.
  XmlElement? get previousElementSibling;

  /// Return the next sibling of this node, or `null`.
  XmlNode? get nextSibling;

  /// Return the next element sibling of this node, or `null`.
  XmlElement? get nextElementSibling;
}

/// XML document fragment node.
abstract class XmlDocumentFragment implements XmlNode {
  @override
  XmlDocumentFragment copy();
}

/// XML document node.
abstract class XmlDocument implements XmlNode {
  /// Return the [XmlDeclaration] element, or `null` if not defined.
  ///
  /// For example the following code prints `<?xml version="1.0">`:
  ///
  ///    var xml = '<?xml version="1.0">'
  ///              '<shelf></shelf>';
  ///    print(XmlDocument.parse(xml).doctypeElement);
  ///
  XmlDeclaration? get declaration;

  /// Return the [XmlDoctype] element, or `null` if not defined.
  ///
  /// For example, the following code prints `<!DOCTYPE html>`:
  ///
  ///    var xml = '<!DOCTYPE html>'
  ///              '<html><body></body></html>';
  ///    print(XmlDocument.parse(xml).doctypeElement);
  ///
  XmlDoctype? get doctypeElement;

  /// Return the root [XmlElement] of the document, or throw a [StateError] if
  /// the document has no such element.
  ///
  /// For example, the following code prints `<books />`:
  ///
  ///     var xml = '<?xml version="1.0"?>'
  ///               '<books />';
  ///     print(XmlDocument.parse(xml).rootElement);
  ///
  XmlElement get rootElement;

  @override
  XmlDocument copy();
}

/// XML CDATA node.
abstract class XmlCDATA implements XmlNode, XmlAttributes, XmlParentable, XmlData {
  @override
  XmlCDATA copy();
}

/// XML attribute node.
abstract class XmlAttribute implements XmlAttributes, XmlNode, XmlParentable, XmlHasName {
  /// The value of the attribute.
  abstract String value;

  /// Return the quote type.
  XmlAttributeType get attributeType;

  @override
  XmlAttribute copy();
}

/// XML comment node.
abstract class XmlComment implements XmlAttributes, XmlParentable, XmlData, XmlNode {
  @override
  XmlComment copy();
}

/// XML document declaration.
abstract class XmlDeclaration implements XmlNode, XmlAttributes, XmlParentable {
  /// Return the XML version of the document, or `null`.
  String? get version;

  /// Set the XML version of the document.
  set version(String? value);

  /// Return the encoding of the document, or `null`.
  String? get encoding;

  /// Set the encoding of the document.
  set encoding(String? value);

  /// Return the value of the standalone directive.
  bool get standalone;

  /// Set the value of the standalone directive.
  set standalone(bool? value);

  @override
  XmlDeclaration copy();
}

/// XML doctype node.
abstract class XmlDoctype implements XmlNode, XmlAttributes, XmlParentable, XmlData {
  @override
  XmlDoctype copy();
}

/// XML element node.
abstract class XmlElement implements XmlNode, XmlAttributes, XmlParentable, XmlHasName {
  /// Defines whether the element should be self-closing when empty.
  abstract bool isSelfClosing;
}

/// XML processing instruction.
abstract class XmlProcessing implements XmlNode, XmlAttributes, XmlParentable, XmlData {
  /// Return the processing target.
  String get target;

  @override
  XmlProcessing copy();
}

/// XML text node.
abstract class XmlText implements XmlNode, XmlAttributes, XmlParentable, XmlData {
  @override
  XmlText copy();
}

/// An XML entity name with a prefix.
abstract class XmlPrefixName implements XmlNode, XmlAttributes, XmlParentable, XmlName {
  @override
  String get prefix;

  @override
  XmlPrefixName copy();
}

/// An XML entity name without a prefix.
abstract class XmlSimpleName implements XmlNode, XmlAttributes, XmlParentable, XmlName {
  @override
  XmlSimpleName copy();
}

/// XML entity name.
abstract class XmlName implements XmlNode {
  /// Return the namespace prefix, or `null`.
  String? get prefix;

  /// Return the local name, excluding the namespace prefix.
  String get local;

  /// Return the fully qualified name, including the namespace prefix.
  String get qualified;

  /// Return the namespace URI, or `null`.
  String? get namespaceUri;

  @override
  XmlName copy();

  Z matchName<Z>({
    required final Z Function(XmlPrefixName) prefix,
    required final Z Function(XmlSimpleName) simple,
  });
}

/// Base interface for nodes with a parent.
abstract class XmlParentable {
  /// Return the parent node of this node, or `null` if there is none.
  XmlNode? get parent;

  /// Test whether the node has a parent or not.
  bool get hasParent;

  /// Replace this node with `other`.
  void replace(XmlNode other);

  /// Internal helper to attach a child to this parent, do not call directly.
  @internal
  void attachParent(XmlNode parent);

  /// Internal helper to detach a child from its parent, do not call directly.
  @internal
  void detachParent(XmlNode parent);
}

/// Attribute interface for nodes.
abstract class XmlAttributes {
  /// Return the attribute nodes of this node in document order.
  List<XmlAttribute> get attributes;

  /// Return the attribute value with the given `name`, or `null`.
  String? getAttribute(String name, {String? namespace});

  String? getAttributeStrictQualified(String qualifiedName);

  /// Return the attribute node with the given `name`, or `null`.
  XmlAttribute? getAttributeNode(String name, {String? namespace});

  XmlAttribute? getAttributeNodeStrictQualified(String qualifiedName);

  /// Set the attribute value with the given fully qualified `name` to `value`.
  /// If an attribute with the name already exist, its value is updated.
  /// If the value is `null`, the attribute is removed.
  void setAttribute(String name, String? value, {String? namespace});

  /// Removes the attribute value with the given fully qualified `name`.
  void removeAttribute(String name, {String? namespace});
}

/// Abstract XML data node.
abstract class XmlData {
  /// The textual value of this node.
  abstract String text;
}

/// Mixin for all nodes with a name.
abstract class XmlHasName {
  /// Return the name of the node.
  XmlName get name;
}

abstract class XmlSourceRange {
  int get offset;

  int get end;
}

/// Basic visitor over [XmlNode]s.
abstract class XmlVisitor<T> {
  /// Visit an [XmlDeclaration] node.
  T visitDeclaration(XmlDeclaration node);

  /// Visit an [XmlDocument] node.
  T visitDocument(XmlDocument node);

  /// Visit an [XmlDocumentFragment] node.
  T visitDocumentFragment(XmlDocumentFragment node);

  /// Visit an [XmlElement] node.
  T visitElement(XmlElement node);

  /// Visit an [XmlCDATA] node.
  T visitCDATA(XmlCDATA node);

  /// Visit an [XmlComment] node.
  T visitComment(XmlComment node);

  /// Visit an [XmlDoctype] node.
  T visitDoctype(XmlDoctype node);

  /// Visit an [XmlProcessing] node.
  T visitProcessing(XmlProcessing node);

  /// Visit an [XmlText] node.
  T visitText(XmlText node);

  /// Visit an [XmlName].
  T visitName(XmlName name);

  /// Visit an [XmlAttribute] node.
  T visitAttribute(XmlAttribute node);
}
