import 'package:flutter/material.dart';
import 'package:transportia/widgets/inputs/obj_inputs.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/inputs/search_filtering/main_obj.dart';

class SearchFilterBuilder {
  final BuildContext context;
  final SearchFilters filters;
  final VoidCallback onChanged;

  SearchFilterBuilder({
    required this.context,
    required this.filters,
    required this.onChanged,
  });

  List<Widget> build(List<SearchFilter> enabledFilters) {
    return enabledFilters.map((filter) {
      switch (filter) {
        case SearchFilter.livery:
          return liveryInputField(context, filters.livery, (value) {
            filters.livery = value;
            onChanged();
          });

        case SearchFilter.vehicle:
          return vehicleInputField(context, filters.vehicle, (value) {
            filters.vehicle = value;
            onChanged();
          });

        case SearchFilter.vehicleType:
          return vehicleTypeInputField(context, filters.vehicleType, (value) {
            filters.vehicleType = value;
            onChanged();
          });

        case SearchFilter.route:
          return routeInputField(context, filters.route, (value) {
            filters.route = value;
            onChanged();
          });

        case SearchFilter.operator:
          return operatorInputField(context, filters.operator, (value) {
            filters.operator = value;
            onChanged();
          });

        case SearchFilter.author:
          return authorInputField(context, filters.author, (value) {
            filters.author = value;
            onChanged();
          });

        case SearchFilter.vehicleMatched:
          return matchedVehicleInputField(context, filters.vehicleMatched, (
            value,
          ) {
            filters.vehicleMatched = value;
            onChanged();
          });

        case SearchFilter.demonstrator:
          return boolInputField(
            context,
            "Demonstrator?",
            filters.demonstrator,
            (value) {
              filters.demonstrator = value;
              onChanged();
            },
          );

        case SearchFilter.openTop:
          return boolInputField(context, "Open Top?", filters.openTop, (value) {
            filters.openTop = value;
            onChanged();
          });

        case SearchFilter.doubleDecker:
          return boolInputField(
            context,
            "Double Decker?",
            filters.doubleDecker,
            (value) {
              filters.doubleDecker = value;
              onChanged();
            },
          );

        case SearchFilter.coach:
          return boolInputField(context, "Coach?", filters.coach, (value) {
            filters.coach = value;
            onChanged();
          });

        case SearchFilter.trainingVehicle:
          return boolInputField(
            context,
            "Training Vehicle?",
            filters.trainingVehicle,
            (value) {
              filters.trainingVehicle = value;
              onChanged();
            },
          );

        case SearchFilter.withdrawn:
          return boolInputField(context, "Withdrawn?", filters.withdrawn, (
            value,
          ) {
            filters.withdrawn = value;
            onChanged();
          });

        case SearchFilter.electric:
          return boolInputField(context, "Electric?", filters.electric, (
            value,
          ) {
            filters.electric = value;
            onChanged();
          });

        case SearchFilter.hasImage:
          return boolInputField(context, "Has Image?", filters.hasImage, (
            value,
          ) {
            filters.hasImage = value;
            onChanged();
          });

        case SearchFilter.tram:
          return tramInputField(context, filters.tram, (value) {
            filters.tram = value;
            onChanged();
          });

        case SearchFilter.tramType:
          return tramTypeInputField(context, filters.tramType, (value) {
            filters.tramType = value;
            onChanged();
          });

        case SearchFilter.tramOperator:
          return tramOperatorInputField(context, filters.tramOperator, (value) {
            filters.tramOperator = value;
            onChanged();
          });

        default:
          return Text("Missing: ${filter.toString()}");
      }
    }).toList();
  }
}
