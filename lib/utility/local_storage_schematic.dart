import 'package:hive/hive.dart';

part 'local_storage_schematic.g.dart'; //here my file name is api_response_box.dart

@HiveType(typeId: 0) //declare unique for every class
class LocalStorageSchematic extends HiveObject {
  @HiveField(0) //unique index of the field
  late String url;

  @HiveField(1)
  late String response;

  @HiveField(2)
  late int timestamp;
}
