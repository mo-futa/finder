import 'dart:io';

import 'package:finder_v2/constants.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart'; 

/// Widget to capture and crop the image
class MultiImagePicker extends StatefulWidget {
  final Function(List<File> files) callBack;
  MultiImagePicker({required this.callBack});
  createState() => _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  List<File> _imageFileList = [];
  // @override
  // void initState() {
  //   super.initState();
  //   //youve recieved a list i[of image urls that u are trying to convert to fiels and asign to _imageFileList
  //   _imageFileList = widget.images == null ? [] : widget.images.map((imageUrl) => File(imageUrl)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageFileList.length,
            itemBuilder: (context, index) => Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      // color: Colors.pink.shade900,
                      ),
                  child: _imageFileList.length == 0
                      ? Center(
                          child: Text('pick an image',
                              style: TextStyle(color: Colors.black)))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imageFileList[index],
                            fit: BoxFit.cover,
                          )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => setState(() {
                      _imageFileList.removeAt(index);
                      widget.callBack(_imageFileList);
                    }),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 30,
                      width: 30,
                      child: Center(child: Icon(Icons.close)),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Material(
                    color: mainColor,
                    child: InkWell(
                      onTap: () async {
                        _imageFileList.add(await pickImage(ImageSource.camera));
                        setState(() {});
                        widget.callBack(_imageFileList);
                      },
                      splashColor: Colors.pinkAccent.shade100,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ClipOval(
                  child: Material(
                    color: mainColor,
                    child: InkWell(
                      onTap: () async {
                        _imageFileList
                            .add(await pickImage(ImageSource.gallery));

                        setState(() {});
                        widget.callBack(_imageFileList);
                      },
                      splashColor: Colors.pinkAccent.shade100,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //  Padding(
  //             padding: const EdgeInsets.all(32),
  //             child: TextButton(
  //                 onPressed: () {}, //=> uploadFile(_imageFile),
  //                 child: Text('upload'))),

}

Future<File> pickImage(ImageSource imageSource) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: imageSource);
  return File(pickedFile!.path);
}

Future<List<String>> uploadFiles(
    BuildContext context, List<File> imageFiles) async {
  List<String> urls = [];
  if (imageFiles.isNotEmpty)
    for (var imageFile in imageFiles) {
      String fileName = basename(imageFile.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('racers/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      urls.add(await taskSnapshot.ref.getDownloadURL());
    }
  return urls;
}
