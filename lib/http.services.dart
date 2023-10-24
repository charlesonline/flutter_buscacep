import 'package:http/http.dart' as http;

class HttpServices {
  final String baseUrl;
  final String endpoint;
  final Map<String, dynamic>? params;

  HttpServices({required this.baseUrl, required this.endpoint, this.params});

  Future<http.Response> getRequest() async {
    return await http.get(getUri(baseUrl, endpoint, params));
  }

  static getUri(baseUrl, endpoint, params){
    return Uri.https(baseUrl, endpoint, params);
  }
}
