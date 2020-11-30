import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:minimize_dfa/models/minimize/MinimizeDfaRequest.dart';
import 'package:minimize_dfa/models/minimize/MinimizeDfaResponse.dart';
import 'package:minimize_dfa/services/minimize/HttpService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class MinimizeViewModel extends BaseViewModel {
  TextEditingController _alphabetController = TextEditingController();
  TextEditingController get alphabetController => _alphabetController;
  set alphabetController(value) {
    _alphabetController = value;
    notifyListeners();
  }

  TextEditingController _statesController = TextEditingController();

  TextEditingController get statesController => _statesController;
  set statesController(value) {
    _statesController = value;
    notifyListeners();
  }

  TextEditingController _initialStateController = TextEditingController();
  TextEditingController get initialStateController => _initialStateController;
  set initialStateController(value) {
    _initialStateController = value;
    notifyListeners();
  }

  TextEditingController _finalStatesController = TextEditingController();
  TextEditingController get finalStatesController => _finalStatesController;
  set finalStatesController(value) {
    _finalStatesController = value;
    notifyListeners();
  }


  Image _initialImage;
  Image get initialImage => _initialImage;
  set initialImage(value) {
    _initialImage = value;
    notifyListeners();
  }

  Image _finalImage;
  Image get finalImage => _finalImage;
  set finalImage(value) {
    _finalImage = value;
    notifyListeners();
  }

  Future<void> init() async {
    setBusy(true);
    await _getOfflineValues();
    setBusy(false);
  }

  List<Image> _images = List<Image>();
  List<Image> get images => _images;
  set images(values) {
    _images.clear();
    _images = values;
    notifyListeners();
  }

  Uint8List _initialGraph;
  Uint8List _finalGraph;

  _getOfflineValues() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _initial = _prefs.getString('initial');
    String _final = _prefs.getString('final');

    _initial = _initial.substring(2, _initial.length - 1);
    _final = _final.substring(2, _final.length - 1);

    _initialGraph = base64.decode(_initial);
    _finalGraph = base64.decode(_final);

    initialImage = Image.memory(
      _initialGraph,
      fit: BoxFit.cover,
    );
    finalImage = Image.memory(
      _finalGraph,
      fit: BoxFit.cover,
    );

    images = [initialImage, finalImage];
  }

  String _minimizeDFAError = "";
  String get minimizeDFAError => _minimizeDFAError;
  set minimizeDFAError(value) {
    _minimizeDFAError = value;
    notifyListeners();
  }

  int transitionBuilder = 0;
  List<TextEditingController> transitionController = List<TextEditingController>();
  initFocusListeners() {
    statesFocusNode.addListener(() {
      if (!statesFocusNode.hasFocus) {
        transitionController.clear();

        var list =statesController.text.split(",");
        transitionBuilder = list.length;
        for(int i = 0;i<transitionBuilder;i++)
        {
          transitionController.add(TextEditingController());
        }
        notifyListeners();
      }
    });}


  FocusNode _statesFocusNode = FocusNode();
  FocusNode get statesFocusNode => _statesFocusNode;
  set statesFocusNode(value){
    _statesFocusNode = value;
    notifyListeners();
  }

  Future<bool> minimizeDFA() async {
    List<String> alphabets = _alphabetController.text.split(",");
    List<String> states = _statesController.text.split(",");
    List<String> finalStates = _finalStatesController.text.split(",");
    String initialState = _initialStateController.text;
    // List<Map<String, String>> transitionList = [
    //   {"b": "s1", "a": "s2"},
    //   {"a": "s3", "b": "s1"},
    //   {"c": "s3"}
    // ];

    // List<String> _split = transitionController.text.split("}");
    // print(_split);
    // List<Map<String, String>> transitionList = List<Map<String,String>>();
    // for (String item in _split) {
    //   var string;
    //   if(item.indexOf("{") == 0)
    //   {
    //     string  = item+ "}";
    //   }
    //   else
    //   {
    //     string = item.substring(1);
    //     string +="}";
    //   }
    //   transitionList.add(json.decode(string));
    
    // }



    List<dynamic> transitionList = List<dynamic>();
    var list = [];
    for(int i=0;i<transitionController.length;i++)
    {
      var decoded = json.decode(transitionController[i].text);
      list.add(decoded);
      
    }

    transitionList = list;

    print(transitionList);
    MinimizeDfaRequest request = MinimizeDfaRequest(
        alphabets: alphabets,
        states: states,
        initialState: initialState,
        finalStates: finalStates,
        transitionList: transitionList);
    MinimizeDfaResponse response = await HttpService().minimizeDFA(request);
    if (response.error.isNotEmpty) {
      minimizeDFAError = response.error;
      return false;
    } else {
      _storeResponseOffline(response);
      return true;
    }
  }

  void _storeResponseOffline(MinimizeDfaResponse response) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setString('initial', response.initialGraph);
    await _prefs.setString('final', response.finalGraph);
  }
}
