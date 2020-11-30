class MinimizeDfaRequest {
  List<String> alphabets;
  List<String> states;
  String initialState;
  List<String> finalStates;
  List<dynamic> transitionList;

  MinimizeDfaRequest(
      {this.alphabets,
      this.states,
      this.initialState,
      this.finalStates,
      this.transitionList});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alphabets'] = this.alphabets;
    data['states'] = this.states;
    data['initialState'] = this.initialState;
    data['finalStates'] = this.finalStates;
    data['transitionList'] = this.transitionList;
    return data;
  }
}



