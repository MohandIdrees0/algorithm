
import 'package:flutter/material.dart';

import 'data.dart';
import 'location.dart';

class GPS extends StatelessWidget {
  const GPS({super.key});
  @override
  Widget build(BuildContext context) {
    List list=[];
    String value1="";
    String value2="";
    Size size=MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.yellow])),
            child: Row(
              children: [
                Container(
                  width: 800,
                  height: 1200,
                  child: Image(image: AssetImage("lib/images/Gaza.png"),fit: BoxFit.fill,),
                ),
                Expanded(
                  child: FutureBuilder(future: data().readFile(), builder: (context,snapshot){
                    if(snapshot.hasData){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 40,),
                          drop((value){value1=value;},size,snapshot.data,"Source"),
                          SizedBox(height: 40,),
                          drop((value){value2=value;},size,snapshot.data,"Target"),
                          SizedBox(height: 40,),
                          Container(child: TextButton(onPressed: (){
                            list.add(value1+","+value2);
                            print(list);
                          }, child: Text("Run")),width: 200,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.yellow.shade200),)
                        ],
                      );
                    }
                    return Container();
                  }),
                )
              ],
            ),
          ),
          FutureBuilder(future: data().readFile(), builder: (context,snapshots){
            if(snapshots.hasData){
              List<Positioned> cites=[];
              List<location> locations=snapshots.data;
              for(var location in locations) {
                cites.add(Positioned(child: CircleAvatar(backgroundColor: Colors.red, radius: 2,), bottom: 215 + location.findOffset().dy, left: 95 + location.findOffset().dx,));
                cites.add(Positioned(child:Text(location.name), bottom: 215 + location.findOffset().dy, left: 90 + location.findOffset().dx,));
              }
              return Stack(children: cites,);
            }
            else{
              return Container();
            }
          }),
          Positioned(child: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),top: 10,left: 10,),
          Container(width: size.width,height: size.height,child: GestureDetector(onTapUp: (details){
            print(details);
          },),)
        ],
      ),
    );
  }
}

Row drop(Function function,Size size,List Options,String descriptionName){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        alignment: Alignment.topRight,
        child: Text(descriptionName,style: TextStyle(color: Colors.white,fontSize: 20)),
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
List<DropdownMenuItem<String>> list(List listOfItem){
  List<DropdownMenuItem<String>> list=[];
  for(location x in listOfItem){
    list.add(DropdownMenuItem<String>(value: x.name,alignment: Alignment.center,child: Text(x.name,textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),));
  }
  return list;
}
String? validInput(String? validEmail) {
  if (validEmail == null || validEmail.length == 0)
    return 'يرحى اضافة المطلوب';
}