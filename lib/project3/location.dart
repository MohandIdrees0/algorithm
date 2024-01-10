import 'dart:ui';

class location{
  String name="";
  location? parent;
  double longitude=0;
  double latitude=0;
  int cost=0;
  int status=0;
  List successor=[];
  location(String name,String latitude,String longitude){
    this.name=name;
    this.latitude=double.parse(latitude);
    this.longitude=double.parse(longitude);
  }
  Offset findOffset(){
    double y=((latitude-31.323463)/0.21702)*405;
    double x=((longitude-34.218752)/0.348155)*685;
    return Offset(x, y);
  }
}