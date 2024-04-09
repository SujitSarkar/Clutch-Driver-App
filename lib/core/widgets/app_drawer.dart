import '../../src/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../src/features/authentication/provider/authentication_provider.dart';
import '../../src/features/drawer/screen/prestart_checklist_screen.dart';
import '../../src/features/home/provider/home_provider.dart';
import '../constants/app_color.dart';
import '../constants/app_string.dart';
import '../constants/text_size.dart';
import '../router/app_router.dart';
import '../router/page_navigator.dart';
import '../../src/features/drawer/widget/drawer_item_tile.dart';
import 'loading_widget.dart';
import 'normal_card.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);

    return Drawer(
      width: MediaQuery.of(context).size.width*.9,
      child: SafeArea(
        child: NormalCard(
            child: SingleChildScrollView(
          child: Column(children: [
            ///Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              decoration: BoxDecoration(
                  color: AppColor.drawerHeaderBg),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person, size: 42, color: Colors.grey),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${ProfileProvider.instance.loginModel?.data?.firstName??''} ${HomeProvider.instance.loginModel?.data?.lastName??''}',
                              maxLines: 3,
                              style: const TextStyle(fontSize: TextSize.bodyText),
                            ),
                            FittedBox(
                              child: Text(
                                ProfileProvider.instance.loginModel?.data?.email?? ProfileProvider.instance.loginModel?.data?.phone??'N/A',
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: TextSize.bodyText, color: Colors.grey),
                              ),
                            )
                          ]),
                    )
                  ]),
            ),
            const SizedBox(height: 12),

            DrawerItemTile(
                leadingIcon: Icons.hourglass_empty,
                title: AppString.pendingLoads,
                onTap: () async {
                  homeProvider.clearFilter();
                  Scaffold.of(context).closeDrawer();
                  final String currentRoute = ModalRoute.of(context)!.settings.name ?? '/';
                  if(!currentRoute.contains(AppRouter.pendingLoad)){
                     pushTo(AppRouter.pendingLoad);
                  }
                }),
            DrawerItemTile(
                leadingIcon: Icons.fire_truck,
                title: AppString.upcomingLoads,
                onTap: () async {
                  homeProvider.clearFilter();
                  Scaffold.of(context).closeDrawer();
                   pushTo(AppRouter.upcomingLoad);
                }),
            DrawerItemTile(
                leadingIcon: Icons.check_circle_outline_outlined,
                title: AppString.completedLoads,
                onTap: () async {
                  homeProvider.clearFilter();
                  Scaffold.of(context).closeDrawer();
                   pushTo(AppRouter.completeLoad);
                }),
            DrawerItemTile(
                leadingIcon: Icons.check_box_outlined,
                title: AppString.preStartChecklist,
                onTap: () async {
                  Scaffold.of(context).closeDrawer();
                  pushTo(AppRouter.preStartChecklist,
                      arguments: const PreStartChecklistScreen(fromPage: 'drawer'));
                }),
            DrawerItemTile(
                leadingIcon: Icons.newspaper,
                title: AppString.dailyLogbook,
                onTap: () async {
                  Scaffold.of(context).closeDrawer();
                  pushTo(AppRouter.dailyLogbook);
                }),
            DrawerItemTile(
                leadingIcon: Icons.key,
                title: AppString.changePassword,
                onTap: () async {
                  Scaffold.of(context).closeDrawer();
                  pushTo(AppRouter.changePassword);
                }),
            if(homeProvider.loginModel?.data?.linkdCompanyName!=null)
              ProfileProvider.instance.unlinkLoading
                  ? const LoadingWidget(color: AppColor.primaryColor)
                  : DrawerItemTile(
                leadingIcon: Icons.link_off,
                title: '${AppString.unlinkFrom} ${homeProvider.loginModel?.data?.linkdCompanyName??'N/A'}',
                onTap: () async {
                  ProfileProvider.instance.unlinkDriver();
                }),
            DrawerItemTile(
                leadingIcon: Icons.logout,
                title: AppString.logout,
                onTap: () async {
                  await AuthenticationProvider.instance.logout();
                }),
          ]),
        )),
      ),
    );
  }
}
