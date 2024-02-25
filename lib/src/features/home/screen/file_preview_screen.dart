import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/text_widget.dart';

class FilePreviewScreen extends StatelessWidget {
  final String fileUrl;
  const FilePreviewScreen({super.key, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText(text:'File Preview',textColor: Colors.white),
      ),
      body: Center(
        child: getFilePreviewWidget(),
      ),
    );
  }

  Widget getFilePreviewWidget() {
    if (fileUrl.endsWith('.pdf')) {
      return SfPdfViewer.network(fileUrl);
    } else if (fileUrl.endsWith('.png') || fileUrl.endsWith('.jpg')) {
      return CachedNetworkImage(
        imageUrl: fileUrl,
        placeholder: (context, url) => const LoadingWidget(color: AppColor.primaryColor),
        errorWidget: (context, url, error) => const Icon(Icons.error,size: 36),
      );
    } else if (fileUrl.endsWith('.doc') || fileUrl.endsWith('.docx')) {
      return const Center(
        child: BodyText(text:'File type not supported: Word Document'),
      );
    } else {
      // Assuming text file
      return FutureBuilder(
        future: http.get(Uri.parse(fileUrl)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(color: AppColor.primaryColor);
          } else if (snapshot.hasError) {
            return const Center(child: BodyText(text:'Error loading file'));
          } else {
            return SingleChildScrollView(
              child: Text(snapshot.data!.body),
            );
          }
        },
      );
    }
  }
}
