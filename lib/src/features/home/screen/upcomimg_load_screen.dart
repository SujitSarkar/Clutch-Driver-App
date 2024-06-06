import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/refresh_indicator.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/static_list.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../../../core/widgets/truck_dropdown_button.dart';
import '../provider/home_provider.dart';
import '../tile/upcoming_load_tile.dart';
import '../widget/load_date_range_picker_widget.dart';
import '../widget/no_load_found_widget.dart';

class UpcomingLoadScreen extends StatefulWidget {
  const UpcomingLoadScreen({super.key});

  @override
  State<UpcomingLoadScreen> createState() => _UpcomingLoadScreenState();
}

class _UpcomingLoadScreenState extends State<UpcomingLoadScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => HomeProvider.instance.getUpcomingLoadList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const TitleText(
              text: AppString.upcomingLoads, textColor: Colors.white),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(88),
            child: Container(
              color: AppColor.appBodyBg,
              padding:
                  const EdgeInsets.only(left: 4, right: TextSize.pagePadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      ///Calender icon
                      IconButton(
                        icon: const Icon(Icons.calendar_month,
                            color: AppColor.primaryColor),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => LoadDateRangePickerWidget(
                                  loadType: StaticList.loadTypeList[1]));
                        },
                      ),

                      ///Date text
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => LoadDateRangePickerWidget(
                                    loadType: StaticList.loadTypeList[1]));
                          },
                          child: BodyText(
                              text: homeProvider.filterStartDate!
                                          .millisecondsSinceEpoch ==
                                      homeProvider
                                          .filterEndDate!.millisecondsSinceEpoch
                                  ? DateFormat("MMM dd")
                                      .format(homeProvider.filterStartDate!)
                                  : '${DateFormat("MMM dd").format(homeProvider.filterStartDate!)} '
                                      '- ${DateFormat("MMM dd").format(homeProvider.filterEndDate!)}'),
                        ),
                      ),

                      ///Truck dropdown
                      TruckDropdown(
                          items: homeProvider.allTruckList,
                          selectedValue: homeProvider.selectedAllTruck,
                          hintText: 'Select Truck',
                          width: 150,
                          buttonHeight: 35,
                          dropdownWidth: 150,
                          onChanged: (value) {
                            homeProvider.changeAllTruck(
                                value: value, fromPage: AppRouter.upcomingLoad);
                          })
                    ],
                  ),

                  ///Search field
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SearchField(
                      controller: homeProvider.searchController,
                      hintText: AppString.search,
                      onChanged: (value) {
                        homeProvider.loadSearchOnChange(
                            loadType: StaticList.loadTypeList[1]);
                      },
                      suffixOnTap: () => homeProvider.clearSearchOnTap(
                          loadType: StaticList.loadTypeList[1]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: homeProvider.upcomingLoadLoading
            ? const Center(child: LoadingWidget(color: AppColor.primaryColor))
            : _bodyUI(homeProvider, size, context));
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size, BuildContext context) =>
      homeProvider.upcomingLoadList.isNotEmpty
          ? RefreshIndicatorWidget(
              onRefresh: () async => await homeProvider.getUpcomingLoadList(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: TextSize.pagePadding,
                    vertical: TextSize.textGap),
                itemCount: homeProvider.upcomingLoadList.length,
                itemBuilder: (context, index) => UpcomingLoadTile(
                  loadModel: homeProvider.upcomingLoadList[index],
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: TextSize.pagePadding),
              ),
            )
          : NoLoadFoundWidget(
              onRefresh: () async => homeProvider.getUpcomingLoadList());
}
