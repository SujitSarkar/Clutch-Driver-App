import 'package:flutter/material.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/text_widget.dart';
import '../../home/model/load_model.dart';

enum DestinationType { pickup, destibation }

class AddressDetailsWidget extends StatelessWidget {
  const AddressDetailsWidget(
      {super.key, required this.model, required this.destinationType});
  final LoadDataModel model;
  final DestinationType destinationType;

  @override
  Widget build(BuildContext context) {
    return destinationType == DestinationType.pickup
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Address:115-117 William Angliss Drive,
              BodyText(
                  text:
                      '${AppString.address}: ${model.pickup?.streetNumber ?? ''}, ${model.pickup?.streetAddress ?? ''}'),
              BodyText(
                  text: '${AppString.suburb}: ${model.pickup?.suburb ?? ''}'),
              BodyText(
                  text:
                      '${AppString.state}: ${model.pickup?.state ?? ''} / ${AppString.postCode}: ${model.pickup?.postcode ?? ''}'),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                  text:
                      '${AppString.address}: ${model.destination?.streetNumber ?? ''}, ${model.destination?.streetAddress ?? ''}'),
              BodyText(
                  text:
                      '${AppString.suburb}: ${model.destination?.suburb ?? ''}'),
              BodyText(
                  text:
                      '${AppString.state}: ${model.destination?.state ?? ''} / ${AppString.postCode}: ${model.destination?.postcode ?? ''}'),
            ],
          );
  }
}
