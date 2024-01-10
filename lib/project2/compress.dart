
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:min_max_heap/min_max_heap.dart';

class Solution {
  int sizeOfTheFirstSize=0;
  int sizeOfTheSecondFile=0;
  String treeStruct="";
  String orderInTree="";
  Map keys={};
  List newtext=[];
  String pathFile="";
  Map charcters = {};
  MinMaxHeap<Node> minMaxHeap =
  MinMaxHeap(criteria: (var node) => node.frequency);
  Solution() {
  }
  Future readFromFile() async {
    String data = "";
    try {
      FilePickerResult result = (await FilePicker.platform.pickFiles())!;
      File file = File(result.files.single.path!);
      sizeOfTheFirstSize=await file.length();
      pathFile=result.files.single.path!;
      var x = await file.readAsBytes();
      data=(utf8.decode(x));
    } catch (e) {
      print(e);
      return "There is a problem with the file.";
    }
    frequancy(data);
    return;
  }
  Future frequancy(String data)async {
    for (int i = 0; i < data.length; i++) {
      if (charcters.containsKey(data[i])) {
        charcters[data[i]].frequency += 1;
        continue;
      }
      charcters[data[i]] = Node(data[i], 1);
      minMaxHeap.add(charcters[data[i]]);
    }
    createHuffmanCoding();
  }
  void createHuffmanCoding() {
    Node left;
    Node right;
    Node pass;
    while (minMaxHeap.length != 1) {
      left = minMaxHeap.removeMin();
      right = minMaxHeap.removeMin();
      pass = Node("pass", left.frequency + right.frequency);
      pass.left = left;
      pass.right = right;
      minMaxHeap.add(pass);
    }
    keys.addAll(charcters);
    findAssginedCode(minMaxHeap.removeMin(), "");
    decode();
  }
  void findAssginedCode(Node? root, String path) {
    if(root!=null){
      treeStruct+="1";
    }
    if(root!.left==null){
      treeStruct+="0";
    }
    if(root!.left==null){
      treeStruct+="0";
    }

    if (root!.left==null && null== root.right) {
      orderInTree+=root.char;
      charcters[root.char]=path;
      return;
    }
    if(root.left!=null) {
      findAssginedCode(root.left, path + '0');
    }
    if(root.right!=null) {
      findAssginedCode(root.right, path + '1');
    }
  }

  void decode()async{
    String endcodedData="";
    String newPath=pathFile.substring(0,pathFile.lastIndexOf('.'))+".huf";////////dontforgetToEDit it
    File file=File(pathFile);
    File newfile=File(newPath);
    newfile.openSync(mode: FileMode.write).writeString(writheader()+'\n'+'->>>');
    if(!await file.exists()){
      newfile.create();
    }
    print(1);
    String data=utf8.decode(await file.readAsBytes());
    endcodedData+=createcodedforList(data);
    while(true){
      print(1);
      if(endcodedData.length>=256){
        newfile.openSync(mode: FileMode.append).writeString(generateFromBits(endcodedData.substring(0,256)));
        endcodedData=endcodedData.substring(256);
      }
      else{
        break;
      }
    }
    newfile.openSync(mode: FileMode.append).writeString(generateFromBits(endcodedData));
    sizeOfTheSecondFile=await newfile.length();
  }




  String writheader(){
    String header="";
    header+= findexternalbits().toString()+',';
    ////generate bytes from bits on treeStruct
    String bytes="";
    int bytesLeft=0;
    while(true){
      if(treeStruct.isEmpty) {
        break;
      }
      if(treeStruct.length<8){
        bytesLeft=8-treeStruct.length;
        treeStruct=treeStruct+"00000000";
        treeStruct=treeStruct.substring(0,8);
        bytes+=String.fromCharCode(getChar(treeStruct));
        break;
      }
      bytes+=String.fromCharCode(getChar(treeStruct.substring(0,8)));
      treeStruct=treeStruct.substring(8);
    }
    header+=(bytes.length.toString()+',');
    header+=bytesLeft.toString()+',';
    header+=bytes;
    header+=orderInTree;
    header+=(pathFile.substring(pathFile.lastIndexOf('.')));
    return header;
  }
  int findexternalbits()//in this method we are going to find the bits that are less than 8(can not combine in a single byte)
  {
    int num=0;
    int frequency=0;
    int length=0;
    for(var x in charcters.entries.toList()){
      length=x.value.length;
      frequency=keys[x.key].frequency;
      num=(length*frequency)+num;
    }
    return num%8;
  }
  String generateFromBits(String zeroAndOne){
    String newtext="";
    while(zeroAndOne.isNotEmpty){
      if(zeroAndOne.length<8){//00001
        zeroAndOne+="00000000";
        zeroAndOne=zeroAndOne.substring(0,8);
        newtext+=String.fromCharCode(getChar(zeroAndOne.substring(0,8)));
        break;
      }
      newtext+=String.fromCharCode(getChar(zeroAndOne.substring(0,8)));
      zeroAndOne=zeroAndOne.substring(8);
    }
    return newtext;
  }
  int getChar(String x){
    int num=0;
    for(int i=0;i<8;i++){//num=0  ->> 2+1=011
      num*=2;
      if(int.parse(x[i])==1){
        num+=1;
      }
    }//
    return num;
  }
  String createcodedforList(String data){
    String codedString="";
    for(int i=0;i<data.length;i++){
      codedString+=charcters[data[i]];
    }
    return codedString;
  }//change the list ob bytes taken from the file into charcter and then thier binary assignment



}

class Node {
  int frequency = 0;
  late var char;
  Node? left=null;
  Node? right=null;
  Node(var char, int frequency) {
    this.char = char;
    this.frequency = frequency;
  }
}
