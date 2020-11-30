import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minimize_dfa/viewmodels/minimize/MinimizeViewModel.dart';
import 'package:minimize_dfa/views/minimize/MinimizeView.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showToast(String message, {Color color = Colors.red}) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MinimizeViewModel>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => MinimizeViewModel(),
        onModelReady: (model)=>model.initFocusListeners(),
        builder: (context, model, _) => SafeArea(
              child: Scaffold(
                  appBar: AppBar(title: Text("Welcome")),
                  body: SingleChildScrollView(
                                      child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          
                          children: [
                            InputWidget(
                              labelText: "Enter Alphabets",
                              controller: model.alphabetController,
                            ),
                            InputWidget(
                              labelText: "Enter States",
                              controller: model.statesController,
                              focusNode: model.statesFocusNode,
                            ),
                            InputWidget(
                              labelText: "Enter Initial State",
                              controller: model.initialStateController,
                            ),
                            InputWidget(
                              labelText: "Enter Final State(s)",
                              controller: model.finalStatesController,
                            ),
                            model.transitionBuilder != 0 ? ListView.builder(shrinkWrap: true,itemCount: model.transitionBuilder,itemBuilder: (context,i)=>InputWidget(
                              labelText: "Enter Transition For State ${i+1}",
                              controller: model.transitionController[i],
                            ),) : Container(),
                            Row(
                              children: [
                                Expanded(
                                    child: RaisedButton(
                                  onPressed: () async {
                                   bool isValid = _formKey.currentState.validate(); 
                                  if(isValid)
                                  {
                                     bool success = await model.minimizeDFA();

                                    if (success) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => MinimizeView()));
                                              
                                    } else {
                                      _showToast(model.minimizeDFAError);
                                    }
                                  }
                                  else
                                  {
                                    _showToast("Please enter inputs correctly");
                                  }
                                  },
                                  child: Text("Minimize DFA"),
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ));
  }
}

class InputWidget extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  FocusNode focusNode;
  InputWidget({this.labelText, this.controller,this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        validator: (value){
          if(value.isEmpty)
          return "All fields are important";
        },
        focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
              labelText: "$labelText", border: OutlineInputBorder()),
          keyboardType: TextInputType.name),
    );
  }
}
