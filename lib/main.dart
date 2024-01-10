import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/project1/mainPageForProject.dart';
import 'package:project/project2/mainPageProj2.dart';
import 'package:project/project3/mainPage.dart';
import 'package:window_manager/window_manager.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(1200, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
    home: myMainPage(),//MyApp
  ));
}

class myMainPage extends StatelessWidget {
  const myMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.yellow])),
        child: Stack(
          children: [
            Positioned(child: Text("ALGORITHM",style: TextStyle(color: Colors.white,fontSize: 40),),top: 50,left: MediaQuery.sizeOf(context).width*0.4,),
            Positioned(
              top: MediaQuery.sizeOf(context).height/2,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    algorithmType("lib/images/rar-format.png","Illuminating Connections",(){Navigator.push(context, MaterialPageRoute(builder: (context)=>proj2()));}),
                    SizedBox(width: 20,),
                    algorithmType("lib/images/light-bulb.png","Illuminating Connections",(){Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));}),//Navigator.push(context, MaterialPageRoute(builder: (context)=>myMainPage()));
                    SizedBox(width: 20,),
                    algorithmType("lib/images/world.jpeg","GPS",(){Navigator.push(context, MaterialPageRoute(builder: (context)=>GPS()));})//Navigator.push(context, MaterialPageRoute(builder: (context)=>myMainPage()));

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Column algorithmType(String image,String Name,Function function){
    return Column(
      children: [
        InkWell(
          onTap: (){function();},
          child:Card(elevation: 10,
            child: Container(alignment: Alignment.center,
              height: 100,width: 100,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image),fit: BoxFit.fill),borderRadius: BorderRadius.circular(15),),
            ),
          ),
        ),
        Text(Name,style: TextStyle(color: Colors.white,fontSize: 20),)
      ],
    );
  }
}
