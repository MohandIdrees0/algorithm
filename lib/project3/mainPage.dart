
import 'dart:math';

import 'package:flutter/material.dart';

import 'data.dart';
import 'location.dart';

class GPS extends StatefulWidget {
  const GPS({super.key});

  @override
  State<GPS> createState() => _GPSState();
}

class _GPSState extends State<GPS> {
  List points=[];
  List<location> path=[];
  data instance=data();
  Future data1=Future(() => null);
  String value1="";
  String value2="";
  @override
  Widget build(BuildContext context) {
    if(instance.cities.isEmpty){
      data1=Future(() => instance.readFile());
    }
    GlobalKey<FormState> _key = GlobalKey<FormState>();
    //printpoints();
    Size size=MediaQuery.sizeOf(context);
    return Scaffold(
      body: Form(
        key: _key,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.yellow])),
              child: Row(
                children: [
                  Container(
                    width: size.width*(2/3),
                    height: size.height,
                    child: const Image(image: AssetImage("lib/images/Gaza.png"),fit: BoxFit.fill,),
                  ),
                  Expanded(
                    child: FutureBuilder(future: data1, builder: (context,snapshot){
                      if(snapshot.hasData){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40,),
                            drop((value){value1=value;},size,snapshot.data,"Source"),
                            const SizedBox(height: 40,),
                            drop((value){value2=value;},size,snapshot.data,"Target"),
                            const SizedBox(height: 40,),
                            Container(child:
                            TextButton(onPressed: (){
                              if(_key.currentState!.validate()){
                                path=instance.findOptimalSolution(instance.cities[value1]!,instance.cities[value2]!);
                                setState(() {});
                              }
                            }, child: const Text("Run")),width: 200,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.yellow.shade200),),
                            SizedBox(height: 20,),
                            Visibility(child: Text("follow this cities to reach your target",style: TextStyle(fontWeight: FontWeight.bold),),visible: path.isNotEmpty,),
                            SizedBox(
                              height: size.height/5,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  for(var x in path.reversed)
                                    Container(decoration: BoxDecoration(color: Colors.white70,borderRadius: BorderRadius.circular(15)),
                                      child: Row(children: [Text(x.name)],mainAxisAlignment: MainAxisAlignment.center,),
                                      padding: const EdgeInsets.all(5),margin: const EdgeInsets.only(top: 5),)
                                ],
                              ),
                            ),
                            if(path.isNotEmpty)
                              Text("the total distance is = "+path[0].cost.toString()+"M",style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 15,),
                          ],
                        );
                      }
                      return Container();
                    }),
                  )
                ],
              ),
            ),
            FutureBuilder(future: data1, builder: (context,snapshots){
              if(snapshots.hasData){
                List<Positioned> cites=[];
                List<location> locations=snapshots.data;
                for(var location in locations) {
                  cites.add(Positioned(child: const CircleAvatar(backgroundColor: Colors.red, radius: 2,), bottom: size.height*0.283 + location.findOffset(size).dy, left: size.width*0.078 + location.findOffset(size).dx,));
                  cites.add(Positioned(child:Text(location.name), bottom: size.height*0.283 + location.findOffset(size).dy, left: size.width*0.078 + location.findOffset(size).dx,));
                }
                return Stack(children: cites,);
              }
              else{
                return Container();
              }
            }),
            /*FutureBuilder(future: data().readFile(), builder: (context,snapshots){
              if(snapshots.hasData){
                List<Positioned> cites=[];
                List locations=snapshots.data;
                for(var location in locations) {
                  cites.add(Positioned(child: CircleAvatar(backgroundColor: Colors.red, radius: 2,), bottom: size.height*0.283 + location.findOffset(size).dy, left: size.width*0.078 + location.findOffset(size).dx,));
                  //cites.add(Positioned(child:Text(location.name), bottom: size.height*0.283 + location.findOffset(size).dy, left: size.width*0.078 + location.findOffset(size).dx,));
                }
                return Stack(children: cites,);
              }
              else{
                return Container();
              }
            }),*/
            Positioned(child: IconButton(onPressed: (){Navigator.pop(context);},icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),),top: 10,left: 10,),
            /*Container(width: size.width,height: size.height,child: GestureDetector(onTapUp: (details){
              printGPSPosition(details,size);
            },),)*/
          ],
        ),
      ),
    );
  }

  void printGPSPosition(TapUpDetails details,size){
    Offset f=details.globalPosition;
    f=Offset(f.dx-size.width*0.078,size.height- f.dy-size.height*0.283);
    var latitude=(((f.dy)/(size.height*(0.815-0.283)))*0.21702)+31.323463;
    var longitude=(((f.dx)/(size.width*(0.65-0.078)))*0.348155)+34.218752;
    points.add((Random.secure().nextInt(100).toString()+","+latitude.toString()+","+longitude.toString()));
    }
  void printpoints(){
    points.forEach((element) {print("\n"+element);});
  }
  Row drop(Function function,Size size,List Options,String descriptionName){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.topRight,
          child: Text(descriptionName,style: const TextStyle(color: Colors.white,fontSize: 20)),
        ),
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<String>(isExpanded: true,elevation: 10,validator: validInput,
              borderRadius: BorderRadius.circular(10),
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),label: Text(descriptionName)),
              onChanged: (value) {
                function(value);
              },
              dropdownColor: Colors.grey,
              menuMaxHeight: size.height / 5+4,
              items: list(Options)
          ),
        ),
      ],
    );
  }
}

List<DropdownMenuItem<String>> list(List listOfItem){
  List<DropdownMenuItem<String>> list=[];
  for(location x in listOfItem){
    list.add(DropdownMenuItem<String>(value: x.name,alignment: Alignment.center,child: Text(x.name,textAlign: TextAlign.start,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),));
  }
  return list;
}
String? validInput(String? validEmail) {
  if (validEmail == null || validEmail.length == 0)
    return 'يرحى اضافة المطلوب';
}