String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String path = uri.path;
  List<String> segments = path.split('/');
  String fileName = segments.last;
  return fileName;
}
