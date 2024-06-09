import 'dart:io';
import 'package:clutch_driver_app/core/utils/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/static_list.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/app_media_service.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/home_provider.dart';

class LoadAttachmentScreen extends StatefulWidget {
  const LoadAttachmentScreen({super.key, required this.loadWeightType});
  final String loadWeightType;

  @override
  State<LoadAttachmentScreen> createState() => _LoadAttachmentScreenState();
}

class _LoadAttachmentScreenState extends State<LoadAttachmentScreen> {
  File? selectedAttachmentFile;
  List<File> attachmentFileList = [];

  @override
  void initState() {
    debugPrint('Weight type: ${widget.loadWeightType}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: TitleText(
              text: 'Upload ${widget.loadWeightType} attachment',
              textColor: Colors.white),
          titleSpacing: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: TextSize.pagePadding),
              child: InkWell(
                onTap: () => pushTo(AppRouter.profile),
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: AppColor.primaryColor)),
              ),
            )
          ],
        ),
        body: _bodyUI(homeProvider, size));
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size) => Column(
        children: [
          ///Save & Cancel Button
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => popScreen(),
                    child: const BodyText(
                      text: AppString.cancel,
                      textColor: AppColor.disableColor,
                    )),
                TextButton(
                    onPressed: () async {
                      await homeProvider.saveLoadWeightAttachment(
                        loadWeightType: widget.loadWeightType,
                        files: attachmentFileList,
                      );
                      popScreen();
                    },
                    child: homeProvider.functionLoading
                        ? const LoadingWidget(color: AppColor.primaryColor)
                        : const BodyText(
                            text: AppString.save,
                            textColor: AppColor.primaryColor,
                          )),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: TextSize.pagePadding),
              children: [
                ///Image preview
                InkWell(
                  onTap: () async {
                    await AppMediaService()
                        .getImageFromCamera()
                        .then((File? value) {
                      if (value != null) {
                        selectedAttachmentFile = value;
                        attachmentFileList.add(value);
                        setState(() {});
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: selectedAttachmentFile != null
                        ? ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: isImageFile(selectedAttachmentFile!)
                                ? Image.file(selectedAttachmentFile!,
                                    fit: BoxFit.fitHeight)
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: BodyText(
                                        text: selectedAttachmentFile!
                                            .uri.pathSegments.last,
                                        textAlign: TextAlign.center,
                                        textColor: Colors.blue),
                                  ))
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: AppColor.disableColor, size: 30),
                              BodyText(
                                  text: AppString.openCamera,
                                  textColor: AppColor.disableColor)
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: TextSize.pagePadding),

                ///Attachment Button
                TextButton(
                    onPressed: () {
                      uploadAttachmentOnTap();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.attach_file, color: AppColor.disableColor),
                        SizedBox(width: 8),
                        BodyText(
                            text: AppString.uploadAttachment,
                            textColor: AppColor.primaryColor)
                      ],
                    )),
                const SizedBox(height: TextSize.pagePadding),

                ///Attachment List
                const BodyText(
                    text: AppString.linkedDocument,
                    fontWeight: FontWeight.bold),
                const Divider(height: 8, thickness: 0.8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attachmentFileList.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            removeFileFromAttachmentFileList(index);
                          },
                          icon: const Icon(Icons.cancel_outlined,
                              color: AppColor.disableColor)),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedAttachmentFile =
                                  attachmentFileList[index];
                            });
                          },
                          child: BodyText(
                              text: attachmentFileList[index]
                                  .uri
                                  .pathSegments
                                  .last,
                              textColor: AppColor.textColor),
                        ),
                      ),
                    ],
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                ),
                // const SizedBox(height: TextSize.pagePadding),

                ///Uploaded List
                const BodyText(
                    text: AppString.uploadedDocument,
                    fontWeight: FontWeight.bold),
                const Divider(height: 8, thickness: 0.8),
                if (homeProvider.loadWeightModel != null)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.loadWeightType == StaticList.loadWeightType.first
                            ? homeProvider.loadWeightModel!.data!.pickup!
                                .pickupAttachments!.length
                            : homeProvider.loadWeightModel!.data!.deli!
                                .deliveryAttachments!.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        InkWell(
                          onTap: () {
                            final url = widget.loadWeightType ==
                                    StaticList.loadWeightType.first
                                ? '${homeProvider.loadWeightModel!.data!.pickup!.url}/${homeProvider.loadWeightModel!.data!.pickup!.pickupAttachments![index]}'
                                : '${homeProvider.loadWeightModel!.data!.deli!.url}/${homeProvider.loadWeightModel!.data!.deli!.deliveryAttachments![index]}';
                            debugPrint(url);
                            pushTo(AppRouter.filePreview, arguments: url);
                          },
                          child: BodyText(
                              text: widget.loadWeightType ==
                                      StaticList.loadWeightType.first
                                  ? homeProvider.loadWeightModel!.data!.pickup!
                                      .pickupAttachments![index]
                                  : homeProvider.loadWeightModel!.data!.deli!
                                      .deliveryAttachments![index],
                              textColor: AppColor.primaryColor),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  ),
              ],
            ),
          )
        ],
      );

  Future<void> uploadAttachmentOnTap() async {
    modalBottomSheet(
        context: context,
        height: MediaQuery.of(context).size.height * .3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextButton(
                  onPressed: () async {
                    popScreen();
                    await AppMediaService()
                        .getImageFromCamera()
                        .then((File? value) {
                      if (value != null) {
                        selectedAttachmentFile = value;
                        attachmentFileList.add(value);
                        setState(() {});
                      }
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.camera, color: AppColor.primaryColor),
                      SizedBox(width: 8),
                      BodyText(text: AppString.camera)
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    popScreen();
                    await AppMediaService()
                        .getImageFromGallery(imageQuality: 100)
                        .then((File? value) {
                      if (value != null) {
                        selectedAttachmentFile = value;
                        attachmentFileList.add(selectedAttachmentFile!);
                        setState(() {});
                      }
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.image_outlined, color: AppColor.primaryColor),
                      SizedBox(width: 8),
                      BodyText(text: AppString.gallery)
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    popScreen();
                    await AppMediaService()
                        .getFileFromStorage()
                        .then((File? value) {
                      if (value != null) {
                        selectedAttachmentFile = value;
                        attachmentFileList.add(selectedAttachmentFile!);
                        setState(() {});
                      }
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.file_copy_outlined,
                          color: AppColor.primaryColor),
                      SizedBox(width: 8),
                      BodyText(text: AppString.file)
                    ],
                  )),
            ],
          ),
        ));
  }

  void removeFileFromAttachmentFileList(int index) {
    if (selectedAttachmentFile?.uri.pathSegments.last ==
        attachmentFileList[index].uri.pathSegments.last) {
      selectedAttachmentFile = null;
    }
    attachmentFileList.removeAt(index);
    setState(() {});
  }
}
