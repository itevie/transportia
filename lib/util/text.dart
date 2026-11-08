import 'package:html/parser.dart' as html;

String stripHtml(String value) {
  return html.parse(value).body?.text ?? '';
}

String? oneOf(List<String?> values) {
  var r = values.firstWhere((x) => x != null);
  return r == null
      ? null
      : r.isEmpty
      ? null
      : r;
}
