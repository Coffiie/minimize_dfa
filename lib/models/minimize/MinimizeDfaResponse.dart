class MinimizeDfaResponse {
  String initialGraph;
  String finalGraph;
  String error;

  MinimizeDfaResponse({this.error,this.initialGraph, this.finalGraph});

  MinimizeDfaResponse.fromJson(Map<String, dynamic> json) {
    initialGraph = json['initialGraph'];
    finalGraph = json['finalGraph'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['initialGraph'] = this.initialGraph;
    data['finalGraph'] = this.finalGraph;
    data['error'] = this.error;
    return data;
  }
}