import 'interface.dart';

class XmlSourceRangeImpl implements XmlSourceRange {
  const XmlSourceRangeImpl(
    final this.offset,
    final this.end,
  );

  @override
  final int offset;
  @override
  final int end;
}
