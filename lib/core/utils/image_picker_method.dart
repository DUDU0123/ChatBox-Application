import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage({required ImageSource imageSource}) async {
  try {
    File? file;
    XFile? pickedXFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedXFile != null) {
      file = File(pickedXFile.path);
    }
    if(file!=null){
      return file;
    }else{
      return null;
    }
  } catch (e) {
    throw Exception(e);
  }
}
