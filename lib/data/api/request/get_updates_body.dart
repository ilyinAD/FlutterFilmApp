import 'package:chck_smth_in_flutter/domain/model/updates_type_enum.dart';

class GetUpdatesBody {
  final UpdatesType name;
  GetUpdatesBody({required this.name});
  Map<String, dynamic> toAPI() {
    return {
      "since": name.name,
    };
  }
}
