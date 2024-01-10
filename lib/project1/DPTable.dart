import 'package:flutter/material.dart';
import 'package:project/project1/IlluminatingConnections.dart';

import '../CommonWidgetAndStyles.dart';

class DbTable extends StatefulWidget{
  const DbTable({super.key, required this.questionFormula});
  final QuestionFormula questionFormula;
  @override
  State<DbTable> createState() => _DbTableState();
}

class _DbTableState extends State<DbTable> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<Color?> animation;
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController=ScrollController(initialScrollOffset: -100);
    controller=AnimationController(vsync: this,duration: Duration(seconds: 1));
    controller.repeat(reverse: true);
    animation=ColorTween(
      begin: Colors.red,
      end: Colors.white,

    ).animate(controller);
  }
  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomLeft,end: Alignment.topRight,colors: [Color(0xff00375d),Colors.white,Colors.blue])
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                ],
              ),
              Text('DB Table',style: textStyle.copyWith(color: Colors.black,fontSize: 25),),
              SizedBox(height: 25,),
              Row(
                children: [
                  SizedBox(width: widget.questionFormula.numberOfSources>10?0:100,),
                  Flexible(
                    flex: 5,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.8,
                      child: Container(
                        child: Scrollbar(controller: scrollController,
                          thumbVisibility: true,
                          child: ListView(
                            physics: ScrollPhysics(),
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: ScrollPhysics(parent: ScrollPhysics()),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(
                                    widget.questionFormula.arr.length,
                                        (row) => Row(
                                      children: List.generate(
                                        widget.questionFormula.arr[0].length,
                                            (col) => AnimatedBuilder(
                                              builder: (context,child){
                                                return Card(
                                                  color:findColor(row, col),
                                                  child: Container(
                                                    width: 50, // Adjust as needed
                                                    height: 50, // Adjust as needed
                                                    child: Center(
                                                      child: Text(widget.questionFormula.arr[row][col].toString()),
                                                    ),
                                                  ),
                                                );
                                              }, animation: controller,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(height: MediaQuery.of(context).size.height*0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(backgroundColor: Colors.grey,radius: 10,),
                              SizedBox(width: 10,),
                              Text('Power Source',style: textStyle,)
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(backgroundColor: Colors.green,radius: 10,),
                              SizedBox(width: 10,),
                              Text('Light Number',style: textStyle,)

                            ],
                          ),
                          Row(
                            children: [
                              AnimatedBuilder(builder: (context,_){
                                return CircleAvatar(backgroundColor: animation.value!,radius: 10,);
                              },animation: controller,),
                              SizedBox(width: 10,),
                              Text('Power Source',style: textStyle,)

                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
  bool isContain(int number){
    return widget.questionFormula.findNumbers().contains(number);
  }
  Color findColor(int row,int col){
    if(row==0 && col==0) {
      return Colors.blue;
    }
    else if(row==0) {
      return Colors.blueGrey;
    }
    else if(col==0) {
      return Colors.green;
    }
    else if(widget.questionFormula.arr[row][0]==widget.questionFormula.arr[0][col] && isContain(widget.questionFormula.arr[row][0])){
      return animation.value!;
    }
    else {
      return Colors.white;
    }
  }
}
