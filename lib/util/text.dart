import 'package:html/parser.dart' as html;

String stripHtml(String value) {
  return html.parse(value).body?.text ?? '';
}
