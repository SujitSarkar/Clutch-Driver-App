import 'package:flutter/Material.dart';
import '../../../../core/constants/app_string.dart';

class DrawerMenuProvider extends ChangeNotifier {
  bool functionLoading = false;

  ///Additional Fees
  List<bool> additionalFeeCheckedList = List.generate(AppString.additionalFeeCheckBoxList.length,
      (index) => false);

  ///Pre-Start
  List<bool> preStartFeeCheckedList = List.generate(AppString.preStartCheckboxList.length,
      (index) => false);

  ///Fatigue Management
  List<String>  fatigueManagementCheckboxList = ['Regular Breaks Taken'];
  List<bool> fatigueManagementCheckedList = List.generate(1, (index) => false);

  ///Additional Fees
  void changeAdditionalFeeCheckedList(int index, bool? value){
    additionalFeeCheckedList[index] = value!;
    notifyListeners();
  }

  ///Pre-Start
  void changePreStartCheckedList(int index, bool? value){
    preStartFeeCheckedList[index] = value!;
    notifyListeners();
  }

  ///Fatigue Management
  void changeFatigueManagementCheckedList(int index, bool? value){
    fatigueManagementCheckedList[index] = value!;
    notifyListeners();
  }

  void addBreakButtonOnTap(){}
}
