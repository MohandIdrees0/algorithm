import 'package:flutter/material.dart';
import '../CommonWidgetAndStyles.dart';
import 'IlluminatingConnections.dart';
import 'body.dart';
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  QuestionFormula questionFormula=QuestionFormula();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomLeft,end: Alignment.topRight,colors: [Color(0xff00375d),Colors.white])
        ),
        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Stack(
              children: [
                Center(child:  Text("Illuminating Connections",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),),
                Positioned(child: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: (){Navigator.pop(context);},),left: 5,top: 5,)
              ],
            ),
            SizedBox(height: 50,),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textButton("Read From File",()async{
                        String s=await questionFormula.readFromFile();
                        s.isNotEmpty?dialog(s):null;
                        setState(() {});
                      }),
                      SizedBox(width: 50,),
                    ],
                  ),
                  SizedBox(height: 40,),
                  manualInput(formula: questionFormula,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future dialog(String message){
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("error while reading the file"),
        content: Text(message),
      );
    },

    );
  }
}
