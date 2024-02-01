import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../core/widgets/truck_dropdown_button.dart';
import '../provider/home_provider.dart';
import '../tile/load_tile.dart';
import '../widget/load_date_range_picker_widget.dart';

class CompleteLoadScreen extends StatelessWidget {
  const CompleteLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const TitleText(text: AppString.upcomingLoads,textColor: Colors.white),
          titleSpacing: 0,
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
        body: homeProvider.completeLoadLoading
            ? const Center(child: LoadingWidget())
            : _bodyUI(homeProvider, size, context));
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
                  LoadTile(loadType: AppString.loadTypeList.last),
              separatorBuilder: (context, index) =>
              const SizedBox(height: TextSize.pagePadding),
            ),
          )
        ],
      );
}
