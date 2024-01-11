import 'dart:io';
import 'dart:math';
import 'package:min_max_heap/min_max_heap.dart';
import 'package:project/project3/location.dart';

class data{
  Map<String,location> cities={};
  List<points> point=[];
  int numberOfCites=0;
  int numberOfAdjacent=0;
  data(){
  }
  Future readFile()async{
    try {
    File file = File("C:\\Users\\HP\\OneDrive\\Desktop\\GPS.txt");
    var data = await file.readAsLines();
    getlength(data[0]);
    fillList(data.sublist(1,numberOfCites+1));
    findSuccessor(data.sublist(numberOfCites+1,numberOfCites+1+numberOfAdjacent));
    addPoints(data.sublist(numberOfCites+1+numberOfAdjacent));
    return cities.values.toList();
      return point;
    } catch (e) {
    throw e;
    }
  }
  void fillList(List<String> list){
    for(var x in list){
      if(x.isEmpty){
        continue;
      }
      x=x.trim();
      String latitude=x.substring(x.lastIndexOf(',')+1);
      x=x.substring(0,x.lastIndexOf(',')).trim();
      String longitude=x.substring(x.lastIndexOf(',')+1);
      x=x.substring(0,x.lastIndexOf(',')).trim();
      String name=x;
      cities[name]=(location(name, longitude, latitude));
    }
  }
  void getlength(String x){
    x=x.trim();
    numberOfAdjacent=int.parse(x.substring(x.lastIndexOf(' ')+1));
    x=(x.substring(0,x.lastIndexOf(' '))).trim();
    numberOfCites=int.parse(x);
  }
  void findSuccessor(List list){
    for(String x in list){
      x=x.trim();
      String key=x.substring(x.lastIndexOf(',')+1).trim();
      String child=x.substring(0,x.indexOf(',')).trim();
      if(cities[child]!=null){
        //this.list.add([key,child]);
        cities[key]?.successor.add(cities[child]);
      }
    }
  }
  List<location> findOptimalSolution(location source,location goal){
    MinMaxHeap<location> minMaxHeap = MinMaxHeap(criteria: (var node) => node.cost);
    minMaxHeap.add(source);
    while(true){
      if(minMaxHeap.isEmpty)
        break;
      location v=minMaxHeap.removeMin();
      v.status=2;
      if(v.name.compareTo(goal.name)==0){
        List<location> path=getPath(v);
        Future.delayed(Duration(seconds: 2)).then((value) => clearParent());
        return path;
      }
      for(location x in v.successor){
        if(x.status==0){
          x.cost=(findDistance(x, v)+v.cost).toInt();
          x.parent=v;
          x.status=1;
          minMaxHeap.add(x);
        }
        else if(x.status==1){
          if(v.cost+findDistance(v, x)<x.cost){
            x.parent=v;
            minMaxHeap.updateWhere((element) => x.name.compareTo(element.name)==0, updater: (element){element.cost=(v.cost+findDistance(v, x)).toInt();});
          }
        }
      }
    }
    return [];
  }
  void test(){
    MinMaxHeap<test1> minMaxHeap = MinMaxHeap(criteria: (var node) => node.number);
    minMaxHeap.add(test1("mohand", 3));
    minMaxHeap.add(test1("ahmad", 2));
    minMaxHeap.updateWhere((element) => element.name.compareTo('ahmad')==0, updater: (node){node.number=10;});
  }
  double findDistance(location location1,location location2){
    double delta_lat = toRadians(location2.latitude) - toRadians(location1.latitude);
    double delta_lon = toRadians(location2.longitude) - toRadians(location1.longitude);
    double a = pow(sin(delta_lat / 2),2) + cos(location1.latitude) * cos(location2.latitude) * pow(sin(delta_lon / 2),2);
    double answer = 2 * asin(sqrt(a))*6371000;
    return (answer);
  }
  double toRadians(double degree) {
    return degree * pi / 180.0;
  }
  List<location> getPath(location loacation){
    List<location> list=[];
    while(loacation.parent!=null){
      list.add(loacation);
      loacation=loacation.parent!;
    }
    return list;
  }
  /*void getDuplicate(){
    String data="\n";
    for(var x in list){
      data+=(x[0]+","+x[1]+"\n");
      data+=(x[1]+","+x[0]+"\n");

    }
  }*/
  void addPoints(List list){
    for(var x in list){
      if(x.isEmpty){
        continue;
      }
      x=x.trim();
      String latitude=x.substring(x.lastIndexOf(',')+1);
      x=x.substring(0,x.lastIndexOf(',')).trim();
      String longitude=x.substring(x.lastIndexOf(',')+1);
      x=x.substring(0,x.lastIndexOf(',')).trim();
      String name=x;
      point.add(points(longitude, latitude));
    }
  }
  void clearParent(){
    cities.values.toList().forEach((element) {element.parent=null;element.cost=0;element.status=0;});
  }
}
class test1{
  int number=0;
  String name="";
  test1(this.name,this.number){

  }
}
