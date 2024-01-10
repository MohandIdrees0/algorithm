import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/project2/compress.dart';
import 'package:project/project2/decompress.dart';

import '../CommonWidgetAndStyles.dart';
String x="";
class proj2 extends StatefulWidget {
  const proj2({super.key});

  @override
  State<proj2> createState() => _proj2State();
}

class _proj2State extends State<proj2> {
  bool wating=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: Size.infinite.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomLeft,end: Alignment.topRight,colors: [Color(0xff00375d),Colors.white])
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: (){Navigator.pop(context);},),top: 10,left: 10,),
            Positioned(width: MediaQuery.sizeOf(context).width,
              top: MediaQuery.sizeOf(context).height*0.45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textButton("CompressFile",()async{
                      if(!wating){
                        wating=true;
                        setState(() {

                        });
                        Solution x=Solution();
                        await x.readFromFile().then((value){wating=false;
                          print('BeforeCompress'+x.sizeOfTheFirstSize.toString()+'After Compress'+x.sizeOfTheSecondFile.toString());
                        setState(() {

                        });});

                      }
                    }),
                    textButton("Decompress",()async{
                      if(!wating){
                        wating=true;

                        FilePickerResult picker=(await FilePicker.platform.pickFiles())!;
                        if(picker.files.single.extension.toString().compareTo('huf')!=0){
                          wating=false;
                          success(context);
                          return;
                        }
                        setState(() {

                        });
                        await decompress().readFromFile(picker).then((value){wating=false;setState(() {
                          
                        });});
                      }
                    }),
                  ],
              ),
            ),
            Positioned(child: Text('Save Space',style: TextStyle(color: Colors.white,fontSize: 50),),top: 50,),
            Positioned(child: Text(wating?'Loading':"",style: TextStyle(color: Colors.white,fontSize: 30),),top:200,),
          ],
        ),
      ),
    );
  }
}

Future success(BuildContext context){
  return showDialog(context: context, builder: (BuildContext context) {
    return  AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text('The file should have extentions .huf',style: TextStyle(color: Colors.black))),
      content:  Wrap(direction: Axis.vertical,
      ),

    );
  },);
}