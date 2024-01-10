import 'package:flutter/material.dart';
import 'package:project/project1/DPTable.dart';
import 'package:project/project1/Digrams.dart';
import 'package:project/project1/IlluminatingConnections.dart';

import '../CommonWidgetAndStyles.dart';

class manualInput extends StatefulWidget {
  const manualInput({super.key, required this.formula});
  final QuestionFormula formula;
  @override
  State<manualInput> createState() => _manualInputState();
}

class _manualInputState extends State<manualInput> {
  String currentLights = "";
  String maxNumberOfLight = "";
  String LightsThatGivesExpectedAnswer = "";
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool ExistAnswer = false;
  late TextEditingController addLightContoller = TextEditingController();
  late TextEditingController addNumberOfSourcesContoller;
  @override
  Widget build(BuildContext context) {
    addNumberOfSourcesContoller = TextEditingController(
        text: widget.formula.numberOfSources == 0
            ? ""
            : widget.formula.numberOfSources.toString());
    if (widget.formula.lights.isNotEmpty) {
      fillCurrentLight();
    }
    if (ExistAnswer) {
      MaxLight();
    }
    return Form(
      key: _key,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Number Of power Sources',
                        style: textStyle,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: 200,
                          height: 50,
                          child: TextFormField(
                            validator: NumberOfSourcesValidate,
                            onChanged: (value) {
                              if (_key.currentState!.validate() ||
                                  NumberOfSourcesValidate(value) == null) {
                                widget.formula.numberOfSources =
                                    int.parse(value);
                              }
                            },
                            decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 13),
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true),
                            controller: addNumberOfSourcesContoller,
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Light In Order',
                        style: textStyle,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: 200,
                          height: 50,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            validator: LightNumberValidate,
                            onChanged: (value) {
                              if (_key.currentState!.validate()) {}
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true),
                            controller: addLightContoller,
                          )),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      textButton('add Light', () {
                        if (_key.currentState!.validate()) {
                          if (addLightContoller.text.isNotEmpty) {
                            widget.formula.lights
                                .add(int.parse(addLightContoller.text));
                            addLightContoller.clear();
                            setState(() {});
                          }
                        }
                      }),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentLights,
                  style: textStyle,
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: widget.formula.lights.isNotEmpty,
                  child: InkWell(
                    onTap: (){
                      widget.formula.lights.removeLast();
                      currentLights="current Lights: ";
                      setState(() {
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 10,
                      child: Icon(
                        Icons.remove,
                        size: 10,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            textButton('find Solution', () {
              if(widget.formula.lights.length==0 || widget.formula.lights.length<widget.formula.numberOfSources){
                if(widget.formula.lights.length<widget.formula.numberOfSources){
                  dialog('', context);
                }
                return;
              }
              widget.formula.readData(
                  widget.formula.numberOfSources, widget.formula.lights);
              ExistAnswer = true;
              setState(() {});
            }),
            SizedBox(
              height: 40,
            ),
            Text(
              maxNumberOfLight,
              style: textStyle,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              LightsThatGivesExpectedAnswer,
              style: textStyle,
            ),
            SizedBox(
              height: 40,
            ),
            Visibility(
              visible: ExistAnswer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textButton("Diagram", () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Digram(formula: widget.formula,)));
                  }),
                  SizedBox(width: 10,),
                  textButton("DB Table", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DbTable(
                                  questionFormula: widget.formula,
                                )));
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void fillCurrentLight() {
    currentLights = "current Light: ";
    for (var i in widget.formula.lights) {
      currentLights += i.toString() + ",";
    }
  }

  void MaxLight() {
    maxNumberOfLight = "Maximum Number Of Lights: " +
        widget.formula.findNumbers().length.toString();
    LightsThatGivesExpectedAnswer = "Lights That Gives Expected Answer: " +
        widget.formula.findNumbers().reversed.toString();
  }

  String? NumberOfSourcesValidate(String? text) {
    if (text == null || text.length == 0) {
      return "please enter a number";
    }
    try {
      int n = int.parse(text.trim());
      if (n <= 0) {
        return "the number must be positive integer";
      } else if (n < widget.formula.lights.length) {
        return "it should be larger than " +
            widget.formula.lights.length.toString();
      }
    } catch (e) {
      return "the input must be number";
    }
  }

  String? LightNumberValidate(String? text) {
    if (text != null && text.isNotEmpty) {
      try {
        int n = int.parse(text!.trim());
        if (n <= 0) {
          return "the number must be positive integer";
        } else if (widget.formula.lights.length+1 > widget.formula.numberOfSources) {
          return "it should be less or equal " +
              widget.formula.numberOfSources.toString();
        } else if (widget.formula.lights.contains(n)) {
          return "the light " + text + " is already exist";
        }
      } catch (e) {
        return "the input must be number";
      }
    }
  }
}
Future dialog(String message,BuildContext context){
  return showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      title: Text("the total number of lights must be the same as Number of Sources"),
      content: Text(message),
    );
  },

  );
}