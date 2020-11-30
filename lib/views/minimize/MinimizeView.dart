import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:minimize_dfa/viewmodels/minimize/MinimizeViewModel.dart';
import 'package:stacked/stacked.dart';

class MinimizeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MinimizeViewModel>.reactive(
      onModelReady: (model) async => await model.init(),
      viewModelBuilder: () => MinimizeViewModel(),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Minimize"),),
          body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CarouselSlider.builder(
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height,
                            enableInfiniteScroll: false),
                        itemCount: 2,
                        itemBuilder: (bCtx, i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  padding: EdgeInsets.all(8.0),
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(color: Colors.red[200]),
                                  child: SingleChildScrollView(
                                                                    child: Column(
                                      children: [
                                        i == 0
                                            ? Text(
                                                "Initial Graph",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              )
                                            : Text(
                                                "Final Graph",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                        SizedBox(height: 8.0),
                                        model.images[i]
                                      ],
                                    ),
                                  ));
                            },
                          );
                        },
                      ),
                  )),
        ),
      ),
    );
  }
}
