import 'dart:io';
import 'package:http_parser/http_parser.dart';

MediaType getMediaTypeFromFile(File file) {
  String extension = file.path.split('.').last.toLowerCase();
  switch (extension) {
    case 'png':
      return MediaType('image', 'png');
    case 'jpg':
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'pdf':
      return MediaType('application', 'pdf');
    case 'doc':
    case 'docx':
      return MediaType('application', 'msword');
    case 'txt':
      return MediaType('text', 'plain');
    default:
      throw UnsupportedError('Unsupported file extension: .$extension');
  }
}