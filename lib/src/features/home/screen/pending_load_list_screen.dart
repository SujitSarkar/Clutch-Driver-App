import 'package:clutch_driver_app/core/constants/app_color.dart';
import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/core/constants/text_size.dart';
import 'package:clutch_driver_app/core/router/app_router.dart';
import 'package:clutch_driver_app/core/widgets/text_widget.dart';
import 'package:clutch_driver_app/core/widgets/truck_dropdown_button.dart';
import 'package:clutch_driver_app/src/features/home/provider/home_provider.dart';
import 'package:clutch_driver_app/src/features/home/tile/load_tile.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../widget/load_date_range_picker_widget.dart';

class PendingLoadListScreen extends StatelessWidget {
  const PendingLoadListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (homeProvider.canPop()) {
          Navigator.pop(context);
        } else {
          // ignore: use_build_context_synchronously
          final shouldExit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(AppString.appExitMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                  const Text(AppString.no, style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text(AppString.yes, style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const TitleText(text: AppString.pendingLoads,textColor: Colors.white),
            titleSpacing: 8,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: TextSize.pagePadding),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRouter.profile),
                  child: const CircleAvatar(
                      child: Icon(Icons.person, color: AppColor.primaryColor)),
                ),
              )
            ],
          ),
          drawer: const Drawer(child: AppDrawer()),
          body: homeProvider.pendingLoadLoading
              ? const Center(child: LoadingWidget())
              : _bodyUI(homeProvider, size, context)),
    );
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size, BuildContext context) =>
      Column(
        children: [
          ///Filter section
          Padding(
            padding:
                const EdgeInsets.only(left: 4, right: TextSize.pagePadding),
            child: Row(
              children: [
                ///Calender icon
                IconButton(
                  icon: const Icon(Icons.calendar_month,
                      color: AppColor.primaryColor),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) =>
                            const LoadDateRangePickerWidget());
                  },
                ),

                ///Date text
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              const LoadDateRangePickerWidget());
                    },
                    child: BodyText(
                        text: homeProvider
                                    .filterStartDate!.millisecondsSinceEpoch ==
                                homeProvider.filterEndDate!.millisecondsSinceEpoch
                            ? DateFormat("MMM dd")
                                .format(homeProvider.filterStartDate!)
                            : '${DateFormat("MMM dd").format(homeProvider.filterStartDate!)} - ${DateFormat("MMM dd").format(homeProvider.filterEndDate!)}'),
                  ),
                ),

                ///Truck dropdown
                TruckDropdown(
                    items: AppString.truckList,
                    selectedValue: homeProvider.selectedTruck,
                    hintText: 'Select Truck',
                    width: 150,
                    buttonHeight: 35,
                    dropdownWidth: 150,
                    onChanged: (value) {
                      homeProvider.changeTruck(value);
                    })
              ],
            ),
          ),

          ///Load List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: TextSize.pagePadding, vertical: TextSize.textGap),
              itemCount: 5,
              itemBuilder: (context, index) =>
                  LoadTile(loadType: AppString.loadTypeList.first),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: TextSize.pagePadding),
            ),
          )
        ],
      );
}
