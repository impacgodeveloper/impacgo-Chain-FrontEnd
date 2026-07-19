import 'dart:html' as html;

void saveCsv(String csv, String filename) {
  final blob = html.Blob([csv], 'text/csv');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
