import 'package:flutter/foundation.dart';

class GenericResponse {
  int status;
  Map<String, dynamic>? response;
  String? error;

  GenericResponse(
      {required this.status, required this.response, required this.error});

  // GenericResponse.fromMap(Map<String, dynamic> map) {
  //   this.status = int.parse(map['status'].toString());
  //   this.message = map['message'];
  // }

  GenericResponse.withError(this.status, String this.error) {
    debugPrint("Error Occurred in Generic Response: $status => $error");
  }
}
