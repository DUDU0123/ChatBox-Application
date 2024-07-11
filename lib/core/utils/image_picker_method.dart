import 'dart:developer';
import 'dart:io';
import 'package:chatbox/core/enums/enums.dart';
import 'package:image_picker/image_picker.dart';

File? xFileToFileConverter({required XFile? xfile}) {
  if (xfile == null) {
    return null;
  }
  File? file = File(xfile.path);
  return file;
}

Future<File?> selectAsset({
  required ImageSource imageSource,
  required AssetSelected? assetSelected,
}) async {
  switch (assetSelected) {
    case AssetSelected.photo:
      return pickImage(imageSource: imageSource);
    case AssetSelected.video:
      return takeVideoAsset(imageSource: imageSource);
    default:
      return null;
  }
}

Future<File?> pickImage({required ImageSource imageSource}) async {
  try {
    File? file;
    XFile? pickedXFile = await ImagePicker().pickImage(source: imageSource);

    file = xFileToFileConverter(xfile: pickedXFile);
    if (file != null) {
      return file;
    } else {
      return null;
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<File?> takeVideoAsset({required ImageSource imageSource}) async {
  try {
    File? file;
    XFile? videoFromCameraXfile =
        await ImagePicker().pickVideo(source: imageSource);
    file = xFileToFileConverter(xfile: videoFromCameraXfile);
    if (file != null) {
      return file;
    } else {
      return null;
    }
  } catch (e) {
    log("takeVideo error");
    throw Exception(e);
  }
}

// Future<File?> takeImageUsingCameraController({
//   required CameraController cameraController,
// }) async {
//   File? file;
//   try {
//     XFile pickedXFile = await cameraController.takePicture();
//     file = xFileToFileConverter(xfile: pickedXFile);
//     if (file != null) {
//       return file;
//     } else {
//       return null;
//     }
//   } catch (e) {
//     log("takeImageUsingCameraController error");
//     throw Exception(e);
//   }
// }
