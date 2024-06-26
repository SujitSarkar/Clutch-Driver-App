// import 'package:clutch_driver_app/core/constants/app_color.dart';
// import 'package:clutch_driver_app/core/constants/app_string.dart';
// import 'package:clutch_driver_app/core/constants/text_size.dart';
// import 'package:clutch_driver_app/core/router/app_router.dart';
// import 'package:clutch_driver_app/core/widgets/loading_widget.dart';
// import 'package:clutch_driver_app/core/widgets/normal_card.dart';
// import 'package:clutch_driver_app/core/widgets/solid_button.dart';
// import 'package:clutch_driver_app/core/widgets/text_widget.dart';
// import 'package:clutch_driver_app/src/features/home/tile/company_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../provider/home_provider.dart';
//
// class CompanyListScreen extends StatelessWidget {
//   const CompanyListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeProvider homeProvider = Provider.of(context);
//     final Size size = MediaQuery.of(context).size;
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (value) async {
//         if (homeProvider.canPop()) {
//           Navigator.pop(context);
//         } else {
//           // ignore: use_build_context_synchronously
//           final shouldExit = await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: const Text(AppString.appExitMessage),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child:
//                   const Text(AppString.no, style: TextStyle(color: Colors.green)),
//                 ),
//                 TextButton(
//                   onPressed: () => SystemNavigator.pop(),
//                   child: const Text(AppString.yes, style: TextStyle(color: Colors.red)),
//                 ),
//               ],
//             ),
//           );
//           return shouldExit ?? false;
//         }
//       },
//       child: SafeArea(
//         child: Scaffold(
//             body: homeProvider.companyListLoading
//                 ? const Center(child: LoadingWidget())
//                 : _bodyUI(homeProvider, size, context)),
//       ),
//     );
//   }
//
//   Widget _bodyUI(HomeProvider homeProvider, Size size, BuildContext context) => Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: TextSize.pagePadding),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const TitleText(
//                   text: AppString.selectCompany,
//                   textColor: AppColor.primaryColor,
//                   fontWeight: FontWeight.bold),
//               const SizedBox(height: TextSize.textGap),
//
//               const SmallText(
//                   text: AppString.selectCompanyMgs,
//                   textColor: AppColor.secondaryTextColor,textAlign: TextAlign.center),
//               const SizedBox(height: TextSize.textFieldGap),
//
//               NormalCard(
//                 bgColor: AppColor.primaryColor.withOpacity(0.15),
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   itemCount: 3,
//                   itemBuilder: (context, index)=> CompanyTile(index: index),
//                   separatorBuilder: (context, index)=>const Divider(height: 0.0,thickness: 0.5,),
//                 ),
//               ),
//               const SizedBox(height: TextSize.textFieldGap),
//
//               SolidButton(onTap: (){
//                 Navigator.pushNamed(context, AppRouter.pendingLoad);
//               }, child: const ButtonText(text: 'Select',))
//             ],
//           ),
//         ),
//       );
// }
