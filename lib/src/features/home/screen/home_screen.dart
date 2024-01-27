import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/shimmer_widget.dart';
import '../provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final HomeProvider homeProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeProvider.initialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false, // Allow popping by default
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
        backgroundColor: AppColor.appBodyBg,
        appBar: AppBar(),
        drawer: const Drawer(child: AppDrawer()),
        body: homeProvider.initialLoading
            ? ShimmerWidget(child: _bodyUI(homeProvider, size))
            : _bodyUI(homeProvider, size)
      ),
    );
  }

  Widget _bodyUI(HomeProvider homeProvider, Size size)=>Container();
}
