import 'dart:convert';
import 'dart:io';

import 'package:hasad/app/routes.dart';
import 'package:hasad/data/cubits/custom_field/fetch_custom_fields_cubit.dart';
import 'package:hasad/data/model/custom_field/custom_field_model.dart';
import 'package:hasad/data/model/item/item_model.dart';
import 'package:hasad/ui/screens/item/add_item_screen/custom_filed_structure/custom_field.dart';
import 'package:hasad/ui/screens/item/add_item_screen/select_category.dart';

import 'package:hasad/ui/screens/widgets/dynamic_field.dart';
import 'package:hasad/utils/cloud_state/cloud_state.dart';
import 'package:hasad/utils/custom_text.dart';
import 'package:hasad/utils/extensions/extensions.dart';
import 'package:hasad/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMoreDetailsScreen extends StatefulWidget {
  final bool? isEdit;
  final File? mainImage;

  final List<File>? otherImage;

  const AddMoreDetailsScreen(
      {super.key, this.isEdit, this.mainImage, this.otherImage});

  static MaterialPageRoute route(RouteSettings settings) {
    Map? args = settings.arguments as Map?;
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider.value(
          value:
              (args?['context'] as BuildContext).read<FetchCustomFieldsCubit>(),
          child: AddMoreDetailsScreen(
            isEdit: args?['isEdit'],
            mainImage: args?['mainImage'],
            otherImage: args?['otherImage'],
          ),
        );
      },
    );
  }

  @override
  CloudState<AddMoreDetailsScreen> createState() =>
      _AddMoreDetailsScreenState();
}

class _AddMoreDetailsScreenState extends CloudState<AddMoreDetailsScreen> {
  List<CustomFieldBuilder> moreDetailDynamicFields = [];
  late final GlobalKey<FormState> _formKey;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    Future.delayed(
      Duration.zero,
      () {
        moreDetailDynamicFields =
            context.read<FetchCustomFieldsCubit>().getFields().map((field) {
          Map<String, dynamic> fieldData = field.toMap();
          // Assuming 'getCloudData' returns the correct item based on 'edit_request'

          // Check if 'item' and 'item.customFields' are not null before accessing them
          if (widget.isEdit == true) {
            ItemModel item = getCloudData('edit_request') as ItemModel;

            CustomFieldModel? matchingField =
                item.customFields!.any((e) => e.id == field.id)
                    ? item.customFields?.firstWhere((e) => e.id == field.id)
                    : null;
            if (matchingField != null) {
              // Set 'value' in 'fieldData' based on the matching field's value
              fieldData['value'] = matchingField.value;
            } // Use null-aware operator '?.' for safety
          }

          fieldData['isEdit'] = widget.isEdit == true;
          CustomFieldBuilder customFieldBuilder = CustomFieldBuilder(fieldData);
          customFieldBuilder.stateUpdater(setState);
          customFieldBuilder.init();
          return customFieldBuilder;
        }).toList();

        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: UiUtils.buildAppBar(context,
            showBackButton: true, title: "AdDetails".translate(context)),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: UiUtils.buildButton(
              context,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Map itemDetailsScreenData = getCloudData("item_details");
                  itemDetailsScreenData['custom_fields'] =
                      json.encode(AbstractField.fieldsData);

                  itemDetailsScreenData.addAll(AbstractField.files);

                  addCloudData("with_more_details", itemDetailsScreenData);
                  // itemDetailsScreenData
                  screenStack++;
                  Navigator.pushNamed(
                    context,
                    Routes.confirmLocationScreen,
                    arguments: {
                      "isEdit": widget.isEdit == true,
                      "mainImage": widget.mainImage,
                      "otherImage": widget.otherImage
                    },
                  ).then((value) {
                    screenStack--;

                    if (value == "success") {
                      screenStack = 0;
                    }
                  });
                }
              },
              height: 48,
              fontSize: context.font.large,
              buttonTitle: "next".translate(context),
            ),
          ),
        ),
        body: BlocConsumer<FetchCustomFieldsCubit, FetchCustomFieldState>(
          listener: (context, state) {
            if (state is FetchCustomFieldSuccess) {
              if (state.fields.isEmpty) {
                Navigator.pushNamed(context, Routes.confirmLocationScreen,
                    arguments: {
                      "mainImage": widget.mainImage,
                      "otherImage": widget.otherImage,
                      "isEdit": widget.isEdit,
                    }).then((value) {
                  screenStack--;

                  if (value == "success") {
                    screenStack = 0;
                  }
                });
              }
            }
          },
          builder: (context, state) {
            if (state is FetchCustomFieldFail) {
              return Center(
                child: CustomText(state.error.toString()),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "giveMoreDetailsAboutYourAds".translate(context),
                        fontSize: context.font.large,
                        fontWeight: FontWeight.w600,
                      ),
                      ...moreDetailDynamicFields.map(
                        (field) {
                          field.stateUpdater(setState);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9.0),
                            child: field.build(context),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
