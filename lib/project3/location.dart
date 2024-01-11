import 'dart:ui';

class location extends points{
  String name="";
  location? parent;
  int cost=0;
  int status=0;
  List successor=[];
  location(this.name,String latitude,String longitude) : super(latitude, longitude){
    visible=true;
  }

}
class points{
  double longitude=0;
  double latitude=0;
  bool visible=false;
  points(String latitude,String longitude){
    this.latitude=double.parse(latitude);
    this.longitude=double.parse(longitude);
  }
  Offset findOffset(Size size){
    double y=((latitude-31.323463)/0.21702)*(size.height*(0.815-0.283));
    double x=((longitude-34.218752)/0.348155)*(size.width*(0.65-0.078));
    return Offset(x, y);
  }
}