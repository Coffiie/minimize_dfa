import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:minimize_dfa/models/minimize/MinimizeDfaRequest.dart';
import 'package:minimize_dfa/models/minimize/MinimizeDfaResponse.dart';

const API_URL = "http://10.0.2.2:8000/minimizeddfa/";

class HttpService {
  Future<MinimizeDfaResponse> minimizeDFA(MinimizeDfaRequest request) async {
    Response res =
        await http.post(API_URL, body: json.encode(request.toJson()),headers: {"content-type":"application/json"});
    print(res.body);
    MinimizeDfaResponse response =
        MinimizeDfaResponse.fromJson(json.decode(res.body));
    return response;
  }
}
