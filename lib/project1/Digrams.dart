import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project/project1/IlluminatingConnections.dart';

import '../CommonWidgetAndStyles.dart';

class Digram extends StatefulWidget {
  const Digram({super.key, required this.formula});
  final QuestionFormula formula;
  @override
  State<Digram> createState() => _DigramState();
}

class _DigramState extends State<Digram> {
  List animationController=[];
  List ColorTween=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomLeft,end: Alignment.topRight,colors: [Color(0xff00375d),Colors.blue,Colors.white])),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5,),
              Container(
                alignment: Alignment.topLeft,
                child:TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
              ),
              Expanded(child: column())
            ],
          ),
        ),
      ),
    );
  }
  Stack column(){
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    int lightNumber=widget.formula.lights.length;
    int numberOfSources=widget.formula.numberOfSources;

    List<Container> rows=[];
    Container light=Container(child: Row());
    Container powerSource=Container();

    for(int i=0;i<max(lightNumber, numberOfSources);i++){
      if(i<lightNumber) {
        light = Container(
          width: width/30+width/40,
          child: Row(
            children: [
              Container(child: Text(widget.formula.lights[i].toString(),style: TextStyle(color: Colors.white,fontSize: width/60)),width: width/40,),
              Center(
                  child: Image.asset(
                'lib/images/lamp.png',
                width: width/30,
                color: widget.formula.findNumbers().contains(widget.formula.lights[i])?Colors.yellow:Colors.black,
              )),
            ],
          ),
        );
      }
      if(i<numberOfSources){
        powerSource=Container(child: Container(child: Center(child: Text((i+1).toString())),),color: widget.formula.findNumbers().contains(i)?Colors.yellow:Colors.black,width: 50,height: height/20
        ,
        );
      }
      rows.add(Container(child: Row(children: [light,powerSource],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),margin: EdgeInsets.all(5),height: height/20,));
      powerSource=Container(width: width/30+width/40,color: Colors.red,);
      light=Container(child: Row(),width: width/30+width/40,height: 30,);
    }
    return Stack(
      children: [
        Column(
          children: rows,),
        createClipPath()
      ],
    );
  }
  ClipPath createClipPath(){
    return ClipPath(
      child: Container(color: Colors.red,),
      clipper: clipPath(),
    );
  }

}
class clipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width,size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // Since this is a static clipper, we don't need to reclip.
  }
}
