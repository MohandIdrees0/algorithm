import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:min_max_heap/min_max_heap.dart';
import 'package:project/project2/compress.dart';

class decompress {
  String path="";
  String extention="";
  String bitsToBuildTree="";
  Node? root;
  Node? track;
  String charcters="";
  String charctersNotcoded="";
  int numberOfbits=0;
  decompress() {
  }
  Future readFromFile(FilePickerResult picker) async {
    String data="";
    try{
      path=picker.files.single.path!;
      File file=File(picker.files.single.path!);
      data=utf8.decode(await file.readAsBytes());
    }
    catch(e){
      print(e);
      return;
    }
    String header=(data.substring(0,data.indexOf('->>>')));
    handleHeader(header);
    charctersNotcoded=data.substring(header.length+4);
    readFromFileAndWrite();
  }


  void readFromFileAndWrite()async{
    track=root;
    File file=File(path.substring(0,path.lastIndexOf('.'))+'afterDecopress'+(extention.trim()));
    file.openSync(mode: FileMode.write).writeString('');
    RandomAccessFile randomAccessFile=file.openSync(mode: FileMode.append);
    while(true){
      if(charctersNotcoded.length<9){
        break;
      }
      await randomAccessFile.writeString(DecodingAndReturnFinalAnswer(charctersNotcoded.substring(0,8),0));
      charctersNotcoded=charctersNotcoded.substring(8);
    }
    await randomAccessFile.writeString(DecodingAndReturnFinalAnswer(charctersNotcoded,numberOfbits));
    randomAccessFile.close();
  }
  String DecodingAndReturnFinalAnswer(String s,int num){
    List list= s.codeUnits;
    String result="";
    String bits="";
    String extrabits;
    for(var x in list){
      bits+=decimalToBinary(x);
    }
    if(num>1){
      bits=bits.substring(0,bits.length-(8-num));
    }
    for(int i=0;i<bits.length;i++){
      if(bits[i].compareTo('0')==0){
        track=track!.left;
      }
      else{
        track=track!.right;
      }
      if(track!.right==null && track!.left==null){
        result+=track!.char;
        track=root;
      }
    }
    return result;
  }
  ////handle Header
  void handleHeader(String charcters){
    numberOfbits=int.parse(charcters[0]);
    charcters=charcters.substring(2);
    ////save the charcter
    int numberOfcharcter=int.parse(charcters.substring(0,charcters.indexOf(',')));
    charcters=charcters.substring(charcters.indexOf(',')+1);
    int bytesLeft=int.parse(charcters.substring(0,charcters.indexOf(',')));
    charcters=charcters.substring(2);
    this.charcters=charcters.substring(numberOfcharcter,charcters.lastIndexOf('.'));
    generateBits(charcters.substring(0,numberOfcharcter),bytesLeft);
    this.extention=charcters.substring(charcters.lastIndexOf('.'));
  }
  void generateBits(String treeStruct,int extrabits){/////this method will take the bytes and divide them into bits
    String bits="";
    List list=treeStruct.codeUnits;
    String extraBits="";
    for(var x in list)
      bits+=decimalToBinary(x);

    if(extrabits>0){
      bits=bits.substring(0,bits.length-(extrabits));
    }
    this.bitsToBuildTree=bits;
    root=createTree(root);
    rewriteChar(root,'');
  }
  Node? createTree(Node? root){
    if(bitsToBuildTree[0].compareTo('1')==0){
      root=Node('pass', 0);
      bitsToBuildTree=bitsToBuildTree.substring(1);
    }
    else{
      bitsToBuildTree=bitsToBuildTree.substring(1);
      return null;
    }
    root.left=createTree(root.left);
    root.right=createTree(root.right);
    return root;
  }
  void rewriteChar(Node? root,String path){
    if (root!.left==null && null== root.right) {
      root.char=this.charcters[0];
      this.charcters=this.charcters.substring(1);
      return;
    }
    if(root.left!=null) {
      rewriteChar(root.left, path + '0');
    }
    if(root.right!=null) {
      rewriteChar(root.right, path + '1');
    }
  }
  String decimalToBinary(int decimalNumber) {
    if (decimalNumber == 0) {
      return '0';
    }
    List<int> binaryDigits = [];
    while (decimalNumber > 0) {
      binaryDigits.add(decimalNumber % 2);
      decimalNumber ~/= 2;
    }
    binaryDigits = binaryDigits.reversed.toList();
    if(binaryDigits.length<8){
      binaryDigits.insertAll(0, List.generate(8-binaryDigits.length, (index) => 0));
      binaryDigits=binaryDigits.sublist(0,8);
    }
    return binaryDigits.join('');
  }
}