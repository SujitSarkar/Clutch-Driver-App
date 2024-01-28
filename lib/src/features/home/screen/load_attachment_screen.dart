import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/text_widget.dart';
import '../provider/home_provider.dart';

class LoadAttachmentScreen extends StatelessWidget {
  const LoadAttachmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: TextSize.pagePadding),
              child: InkWell(
                onTap: ()=> Navigator.pushNamed(context, AppRouter.profile),
                child: const CircleAvatar(
                    child: Icon(Icons.person, color: AppColor.primaryColor)),
              ),
            )
          ],
        ),
        drawer: const Drawer(child: AppDrawer()),
        body: _bodyUI(homeProvider, size, context));
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size, BuildContext context) =>
      Column(
        children: [
          ///Save & Cancel Button
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      homeProvider.clearAttachedFile();
                      Navigator.pop(context);
                    },
                    child: const BodyText(
                      text: AppString.cancel,
                      textColor: AppColor.primaryColor,
                    )),
                TextButton(
                    onPressed: () {},
                    child: const BodyText(
                      text: AppString.save,
                      textColor: AppColor.primaryColor,
                    )),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: TextSize.pagePadding),
              children: [
                ///Image preview
                InkWell(
                  onTap: () async {
                    await homeProvider.getImageFromCamera();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: homeProvider.selectedAttachmentFile != null
                        ? ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: isImageFile(
                                    homeProvider.selectedAttachmentFile!)
                                ? Image.file(
                                    homeProvider.selectedAttachmentFile!,
                                    fit: BoxFit.fitHeight)
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: BodyText(
                                        text: homeProvider
                                            .selectedAttachmentFile!
                                            .uri
                                            .pathSegments
                                            .last,
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
                    onPressed: () async {
                      await homeProvider.getFileFromStorage();
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
                    text: AppString.linkedDocument, fontWeight: FontWeight.bold),
                const Divider(height: 8, thickness: 0.8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeProvider.attachmentFileList.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            homeProvider
                                .removeFileFromAttachmentFileList(index);
                          },
                          icon: const Icon(Icons.cancel_outlined,
                              color: AppColor.disableColor)),
                      Expanded(
                        child: BodyText(
                            text: homeProvider.attachmentFileList[index].uri
                                .pathSegments.last,
                            textColor: AppColor.textColor),
                      ),
                    ],
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                )
              ],
            ),
          )
        ],
      );
}
