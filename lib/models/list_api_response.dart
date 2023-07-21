import 'package:cybersec_news/models/api_response.dart';
import 'package:http/http.dart' as http;

class ListApiResponse extends GenericResponse {
  final int statusCode;
  final List<http.Response> listResponse;
  ListApiResponse(this.statusCode, this.listResponse)
      : super(status: statusCode, response: {}, error: '');
}
