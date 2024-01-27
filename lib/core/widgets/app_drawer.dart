import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/text_size.dart';
import '../tile/drawer_item_tile.dart';
import 'normal_card.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NormalCard(
          child: SingleChildScrollView(
        child: Column(children: [
          ///Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            decoration: BoxDecoration(
                color: AppColor.drawerHeaderBg),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 42, color: Colors.grey),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mr. Deepu Khan',
                          style: TextStyle(fontSize: TextSize.bodyText),
                        ),
                        Text(
                          'deepu@gmail.com',
                          style: TextStyle(
                              fontSize: TextSize.bodyText, color: Colors.grey),
                        )
                      ])
                ]),
          ),
          const SizedBox(height: 12),

          DrawerItemTile(
              leadingIcon: Icons.fire_truck,
              title: AppString.upcomingLoads,
              onTap: () async {}),
          DrawerItemTile(
              leadingIcon: Icons.check_circle_outline_outlined,
              title: AppString.completedLoads,
              onTap: () async {}),
          DrawerItemTile(
              leadingIcon: Icons.newspaper,
              title: AppString.dailyLogbook,
              onTap: () async {}),

          DrawerItemTile(
              leadingIcon: Icons.logout,
              title: AppString.logout,
              onTap: () async {}),
        ]),
      )),
    );
  }
}
