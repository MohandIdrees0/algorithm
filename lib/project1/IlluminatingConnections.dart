import 'dart:io';

import 'package:file_picker/file_picker.dart';

class QuestionFormula {
  late int numberOfSources=0;
  late List<int> lights=[];
  late List<List<int>> arr;
  int max=0;

  void readData(int number, List<int> lights) {
    this.numberOfSources = number;
    this.lights = lights;
    arr = List.generate(
        lights.length + 1, (index) => List<int>.filled(number+1, 0));
    paintBorders();
    paint2DArray();
  }//
  List findOptimalSolutionBetter(){//list 13452     2
    //   1 3 4 5 2
    //
    List result=List.generate(lights.length, (index) => 1);
    for(int i=1;i<result.length;i++){
      int maxBefore=0;//1 1 1 1
      for(int j=0;j<i;j++){
        if(lights[j]<lights[i]){
          maxBefore=maxBefore>result[j]?maxBefore:result[j];
        }
        result[i]=maxBefore!=0?maxBefore+1:1;
      }
      print(result[i]);
    }
    print(result);
    int max=0;
    for(int i=0;i<result.length;i++){
      max=max<result[i]?result[i]:max;
    }

    this.max=max;
    return result;
  }




  void paintBorders() {
    arr[0][0] = 0;
    for (int column = 1; column < arr[0].length; column++) {
      arr[0][column] = column;
    }
    for (int row = 1; row < arr.length; row++) {
      arr[row][0] = lights[row - 1];
    }
  }

  void printArray() {
    for (int i = 0; i < arr.length; i++) {
      print(arr[i]);
    }
  }

  List<int> findNumbers() {
    int row = arr.length - 1;
    int column = arr[0].length - 1;
    List<int> list = [];

    while (true) {
      if (row == 1 && column == 1) {
        if (arr[1][1] == 1) {
          list.add(1);
        }
        break;
      }
      if (row == 1) {
        if (arr[row][column] > arr[row][column - 1]) {
          list.add(arr[row][0]);
          break;
        }
        column -= 1;
        continue;
      }
      if (column == 1) {
        if (arr[row][column] > arr[row - 1][column]) {
          list.add(arr[0][column]);
          break;
        }
        row -= 1;
        continue;
      }
      if (arr[row][column] > arr[row][column - 1] &&
          arr[row][column] > arr[row - 1][column]) {
        list.add(arr[row][0]);
        row -= 1;
        column -= 1;
        continue;
      }
      if (arr[row][column] == arr[row][column - 1]) {
        column -= 1;
        continue;
      }
      if (arr[row][column] == arr[row - 1][column]) {
        row -= 1;
        continue;
      }
    }
    return list;
  }

  Future<String> readFromFile() async {
    String data = "";
    try {
      FilePickerResult result = (await FilePicker.platform.pickFiles())!;
      File file = File(result.files.single.path!);
      data = await file.readAsString();
    } catch (e) {
      return "There is a problem with the file.";
    }
    return getDataFromString(data);

  }

  String getDataFromString(String data) {
    List<int> array = [];
    String errorMessage = "";
    try {
      this.numberOfSources = int.parse(data.substring(0, data.indexOf(',')));
      data = data.substring(data.indexOf(',') + 1);
      while (data.isNotEmpty) {
        if (data.indexOf(",") == -1) {
          array.add(int.parse(data.trim()));
          break;
        }
        if (int.parse(data.substring(0, data.indexOf(',')).trim()) <= 0) {
          errorMessage = "All numbers must be positive.";
        }
        if (int.parse(data.substring(0, data.indexOf(',')).trim()) >
            this.numberOfSources) {
          errorMessage =
          "All numbers must be in the range of 1 to $numberOfSources.";
        }
        if (array.contains(int.parse(data.substring(0, data.indexOf(',')).trim()))) {
          errorMessage =
          "Repetition cannot exist in lights";
        }
        array.add(int.parse(data.substring(0, data.indexOf(',')).trim()));
        data = data.substring(data.indexOf(',') + 1);
      }

      if (this.numberOfSources < array.length) {
        errorMessage = "The number of lights must be less than the number of sources.";
      }
      this.lights = List.from(array);
    } catch (e) {
      errorMessage = "The data in the file must be separated by a comma.";
    }
    if(errorMessage.isNotEmpty){this.lights=[];numberOfSources=0;}
    return errorMessage;
  }

  void paint2DArray() {
    for (int row = 1; row < arr.length; row++) {
      for (int column = 1; column < arr[0].length; column++) {
        if (row == 1 && column == 1) {
          arr[1][1] = arr[0][1] == arr[1][0] ? 1 : 0;
          continue;
        }
        if (row == 1) {
          arr[1][column] =
          arr[1][0] == arr[0][column] ? 1 : arr[1][column - 1];
          continue;
        }
        if (column == 1) {
          arr[row][1] = arr[0][1] == arr[row][0] ? 1 : arr[row - 1][1];
          continue;
        }
        arr[row][column] = arr[row][0] == arr[0][column]
            ? arr[row - 1][column - 1] + 1
            : arr[row - 1][column].compareTo(arr[row][column - 1]) > 0
            ? arr[row - 1][column]
            : arr[row][column - 1];
      }
    }
  }
}
